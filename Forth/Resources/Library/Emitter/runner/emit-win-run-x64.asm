; emit-win-run-x64.asm — start a translated x64 image. Public domain.
; rcx = dsp   rdx = return stack   r8 = colon CFA
; r9 = exit xt   [rsp+40] = register file
; The image addresses arm_xN through that file, and uses the real RSP.

OPTION CASEMAP:NONE

.CODE

PUBLIC run_itc

run_itc PROC
    mov r11, QWORD PTR [rsp+40]
    push rbx
    push rdi
    push rsi
    push r12
    mov rsi, r11
    mov QWORD PTR [rsi+176], rcx
    mov QWORD PTR [rsi+184], rdx
    mov QWORD PTR [rsi+168], r8
    mov QWORD PTR [rsi+160], 0
    mov QWORD PTR [rsi+224], 0
    mov rax, QWORD PTR [rsi+184]
    sub rax, 8
    mov QWORD PTR [rsi+184], rax
    lea rcx, ew_back
    mov QWORD PTR [rax], rcx
    mov rax, QWORD PTR [rsi+184]
    sub rax, 8
    mov QWORD PTR [rsi+184], rax
    mov QWORD PTR [rax], r9
    lea rax, QWORD PTR [r8+8]
    mov QWORD PTR [rsi+152], rax
    mov rcx, QWORD PTR [rax]
    add rax, 8
    mov QWORD PTR [rsi+152], rax
    mov QWORD PTR [rsi+168], rcx
    mov rax, QWORD PTR [rcx]
    jmp rax
ew_back:
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret
run_itc ENDP

END
