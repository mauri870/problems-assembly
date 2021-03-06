;
; A simple program to simulate the behavior of the GNU coreutils cat
;

%include "io.asm"
%include "stat.asm"

%define BUF_SIZE 4096

section .text
global _start
_start:
    pop     rdi             ; argc
    pop     rdi             ; argv[0]
    pop     rdi             ; argv[1] - file to read from

    mov     rdx, O_RDONLY
    call    open

    .read:
    push    rax             ; push rax to preserve the fd

    mov     rdi, rax
    mov     rsi, buffer
    mov     rdx, BUF_SIZE
    call    read

    cmp     rax, NULL
    jle     .exit

    mov     rdi, STDOUT
    mov     rsi, buffer
    mov     rdx, rax
    call    write

    pop     rax             ; pop fd into rax
    jmp     .read

    .exit:
    pop     rax
    mov     rdi, rax
    call    close

    xor     rdi, rdi
    call    exit

section .bss
    buffer: resb BUF_SIZE

