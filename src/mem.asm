section .bss  
  hh resb 4

section .data
  HEAP_ZERO_MEMORY equ 0x00000008
  MEM_FAIL equ 0x6A8

section .text
  extern HeapCreate, onerr
  extern HeapAlloc, SetLastError

  mem_a: 
    push ebx ; reserving the original size of the file or stream
    push ebp
    mov ebp, esp

    push 0
    push 0
    push 0
    call HeapCreate
    test eax, eax
    jz onerr
    mov dword [hh], eax

    mov ecx, [ebp + 12]
    push ecx
    push HEAP_ZERO_MEMORY
    push eax
    call HeapAlloc
    test eax, eax
    jnz mem_pass
    push MEM_FAIL
    call SetLastError
    jmp onerr

    mem_pass:
      pop ebp
      pop ebx
      ret 4