section .data
  unq_len equ 256

section .bss
  unq resb unq_len

section .text 
  extern stream_buf, strm_len
  extern max_ssize, onerr
  extern mem_a, freq
  ent:
    push ebp
    push esi
    push edi
    push eax
    push ebx
    push ecx
    mov ebp, esp

    xor ebx, ebx           
    mov ecx, [ebp + 28]    
    mov esi, stream_buf  
    encl:                        
      mov byte al, [esi]        
      mov edi, unq            
      mov edx, ebx            
      test edx, edx
      jz add_unq
      scan:
        mov byte ah, [edi]          
        cmp al, ah
        je match
        inc edi
        dec edx
        jnz scan

      add_unq:
        cmp ebx, unq_len        
        jae match         
        mov edi, unq
        add edi, ebx
        mov [edi], al
        inc ebx

      match:
        inc esi            
        dec ecx                 
        test ecx, ecx
        jnz encl  

    push ebx
    mov esi, stream_buf      
    push esi
    push edi
    call freq
    cu:
      mov byte [edi], 0
      inc edi
      dec ebx
      test ebx, ebx
      jnz cu

    pop ecx
    pop ebx
    pop eax
    pop edi
    pop esi
    pop ebp

    ret 4