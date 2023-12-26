; nasm -felf64 06b.asm && ld 06b.o && ./a.out

global _start

section .text

ceil:
    ; ceil(x) = round(x + 0.5 - eps)
    mov r10, 1
    cvtsi2sd xmm8, r10
    mov r11, 2
    cvtsi2sd xmm9, r11
    divsd xmm8, xmm9
    addsd xmm0, xmm8
    mov r11, 1000000000
    cvtsi2sd xmm9, r11
    divsd xmm8, xmm9
    subsd xmm0, xmm8
    cvtsd2si rax, xmm0
    ret

floor:
    ; floor(x) = round(x - 0.5 + eps)
    mov r10, 1
    cvtsi2sd xmm8, r10
    mov r11, 2
    cvtsi2sd xmm9, r11
    divsd xmm8, xmm9
    subsd xmm0, xmm8
    mov r11, 1000000000
    cvtsi2sd xmm9, r11
    divsd xmm8, xmm9
    addsd xmm0, xmm8
    cvtsd2si rax, xmm0
    ret

solve:
    mov r8, [input_time + 8 * rax]
    mov r9, [input_dist + 8 * rax]
    mov r10, r8
    imul r10, r10
    mov r11, r9
    imul r11, 4
    sub r10, r11
    cvtsi2sd xmm1, r10
    sqrtsd xmm2, xmm1

    cvtsi2sd xmm3, r8
    addsd xmm3, xmm2
    mov r10, 2
    cvtsi2sd xmm8, r10
    divsd xmm3, xmm8
    movsd xmm0, xmm3
    call ceil
    mov r12, rax

    cvtsi2sd xmm3, r8
    subsd xmm3, xmm2
    mov r10, 2
    cvtsi2sd xmm8, r10
    divsd xmm3, xmm8
    movsd xmm0, xmm3
    call floor
    mov r13, rax

    mov rax, r12
    sub rax, r13
    sub rax, 1

    ret

write_int:
    mov r8, buf
    add r8, 8 * 20
    mov byte [r8], 10
    dec r8
    mov r9, 2
    loop_start: cmp rax, 0
    jz loop_end
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add rdx, 48
    mov byte [r8], dl
    dec r8
    inc r9
    jmp loop_start
    loop_end: mov rax, 1
    mov rdi, 1
    mov rsi, r8
    mov rdx, r9
    syscall
    ret

_start:
    mov rax, 0
    call solve
    call write_int
    
    mov rax, 60
    xor rdi, rdi
    syscall

section .data
    input_time dq 48938466
    input_dist dq 261119210191063

section .bss
    buf resb 25
