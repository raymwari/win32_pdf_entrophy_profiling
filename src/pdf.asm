section .data 
  fil db "/FlateDecode", 0
  strms db ">>stream", 0
  strme db "endstream", 0
  max_ssize equ 100000 ; 100kb (max stream size)
  NO_CMP equ 0x6A6
  STR_EX equ 0x6A7

section .bss
  is_cmp resb 1
  stream_buf resb max_ssize  
  strm_len resb 4 

section .text
  extern SetLastError, onerr
  extern ent
  pdf:
    push ebp
    mov ebp, esp
    mov esi, [ebp + 8]
    mov ecx, [ebp + 12]
    mov edi, fil
    xor bl, bl
    det_cmp:
      mov byte al, [esi]
      mov byte bl, [edi]
      cmp al, bl
      jne skip
      find_cmpr:
        mov byte al, [esi + 1] 
        mov byte bl, [edi + 1]
        cmp al, bl    
        jne skip
        mov byte al, [esi + 3] 
        mov byte bl, [edi + 3]
        cmp al, bl    
        jne skip             
        mov byte al, [esi + 5]
        mov byte bl, [edi + 5]
        cmp al, bl    
        jne skip     
        mov byte al, [esi + 7]
        mov byte bl, [edi + 7]
        cmp al, bl    
        jne skip  
        mov byte al, [esi + 9]
        mov byte bl, [edi + 9]
        cmp al, bl    
        jne skip              
        mov byte al, [esi + 11]
        mov byte bl, [edi + 11]
        cmp al, bl      
        mov byte [is_cmp], "T"       
        jne no_cmp        
        push esi     
        call f_stream                

      skip:
        inc esi
        dec ecx
        test ecx, ecx
        jnz det_cmp

    mov byte al, [is_cmp]
    cmp byte al, "T"
    jne no_cmp
      
    pop ebp
    ret 8

    f_stream:
      push ebp
      push esi
      push edi
      push eax
      push ebx
      push ecx

      mov ebp, esp
      mov esi, [ebp + 28] 
      mov ecx, strms
      fs_loop:
        mov byte al, [esi]
        mov byte bl, [ecx]
        cmp al, bl
        jne nxt
        mov byte al, [esi + 2]
        mov byte bl, [ecx + 2]   
        cmp al, bl
        jne nxt   
        mov byte al, [esi + 3]
        mov byte bl, [ecx + 3]   
        cmp al, bl
        jne nxt
        mov byte al, [esi + 6]
        mov byte bl, [ecx + 6]   
        cmp al, bl
        jne nxt       

        mov eax, 8 ; >>stream[_]
        padding:
          inc esi
          dec eax
          test eax, eax
          jnz padding

        mov edx, strme
        mov edi, stream_buf
        mov ebp, 0
        extract:
          mov byte al, [esi]
          mov byte bl, [edx]
          cmp al, bl
          jne cont_ex
          end_point:
            mov byte al, [esi + 2]
            mov byte bl, [edx + 2]
            cmp al, bl
            jne cont_ex
            mov byte al, [esi + 3]
            mov byte bl, [edx + 3]
            cmp al, bl
            jne cont_ex    
            mov byte al, [esi + 6]
            mov byte bl, [edx + 6]
            cmp al, bl
            jne cont_ex  
            mov edi, stream_buf ; stream extraction point
            len_check:
              cmp ebp, max_ssize - 50 ; safety
              jl pass
              push STR_EX
              call SetLastError
              jmp onerr
              
            pass:
              mov [strm_len], ebp
              push ebp
              call ent
              mov edx, [strm_len]
              clean_buf:
                mov byte [edi], 0
                inc edi
                dec edx
                test edx, edx
                jnz clean_buf

              jmp nxt       
            
          cont_ex:
            mov byte [edi], al ; stream loading point
            inc ebp
            inc edi
            inc esi
            jmp extract

        nxt: ; next stream
          eof: 
            mov byte al, [esi]
            cmp al, "%"
            jne cnt
            mov byte al, [esi + 1]
            cmp al, "%"
            jne cnt            
            mov byte al, [esi + 2]
            cmp al, "E"
            jne cnt 
            mov byte al, [esi + 3]
            cmp al, "O"
            jne cnt      
            mov byte al, [esi + 4]
            cmp al, "F"
            jne cnt    

            jmp fin  

          cnt:
            inc esi
            jmp fs_loop

      fin:
        pop ecx
        pop ebx
        pop eax
        pop edi
        pop esi
        pop ebp
        ret 4

  no_cmp:
    push NO_CMP
    call SetLastError
    jmp onerr  