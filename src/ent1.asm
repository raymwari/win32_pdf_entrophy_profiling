section .text
  extern strm_len, shannon
  extern onerr
  freq:
    push ebp
    push esi
    push edi
    push eax
    push ebx
    push ecx
    push edx
    
    mov ebp, esp
    mov esi, [ebp + 32] ; unique elements
    mov ecx, [ebp + 40] ; length of unique elements
    xor eax, eax
    freq1:
      mov edi, [ebp + 36] ; all elements
      mov edx, [strm_len]
      mov byte al, [esi]
      xor ebx, ebx 
      freq2:
        mov byte ah, [edi]
        cmp al, ah
        jne skp
        inc ebx

        skp:
          inc edi
          dec edx
          test edx, edx
          jnz freq2

      mov eax, [strm_len]
      push eax
      push ebx
      call ent1
      
      inc esi
      dec ecx
      test ecx, ecx
      jnz freq1

    pop edx
    pop ecx
    pop ebx
    pop eax
    pop edi
    pop esi
    pop ebp

    ret 12

    ent1:
      push ebp
      push esi
      push edi
      push eax
      push ebx
      push ecx
      push edx

      mov ebp, esp      
      mov ebx, [ebp + 32] ; occcurence
      mov ecx, [ebp + 36] ; sum
      push ecx
      push ebx
      call shannon
      add esp, 8

      pop edx
      pop ecx
      pop ebx
      pop eax
      pop edi
      pop esi
      pop ebp

      ret 8