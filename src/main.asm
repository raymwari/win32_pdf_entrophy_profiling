section .bss
  op_st resb 136
  f_size resd 2

section .data
  OF_PROMPT equ 0x00002000
  file_name db "target.pdf", 0
  pdf_sig db "%PDF", 0
  OF_EMPTY equ 0x6A5

  ; debugging:
  debug db "darkside",0

section .text
  global main
  main:
    extern OpenFile, ExitProcess
    extern GetFileSize, onerr
    extern SetLastError, mem_a
    extern ReadFile, pdf
    extern GetCommandLineA

    push OF_PROMPT
    lea eax, op_st
    push eax
    push file_name
    call OpenFile
    mov edi, eax

    push 0
    push edi
    call GetFileSize
    test eax, eax
    jz zero_bytes    
    mov ebx, eax
    
    push ebx  
    call mem_a
    mov esi, eax
    mov [f_size], ebx

    push 0
    push 0
    push ebx
    push esi
    push edi
    call ReadFile
    test eax, eax
    jz onerr

    mov ecx, pdf_sig
    mov edx, 4
    pdf_sg:
      mov byte al, [ecx]
      mov byte bl, [esi]
      cmp al, bl
      jne zero_bytes 
      inc ecx
      inc esi
      dec edx
      test edx, edx
      jnz pdf_sg
    
    mov edx, 4
    restore:
      dec esi
      dec edx
      test edx, edx
      jne restore
    
    mov eax, [f_size]
    push eax
    push esi
    call pdf

    push 0
    call ExitProcess

  zero_bytes:
    push OF_EMPTY
    call SetLastError
    jmp onerr