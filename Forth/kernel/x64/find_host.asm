; C-callable wrapper for the translated _find_word.
; Public domain.
;
; Save this thread's register file, pass the C arguments in, return here,
; then put the file back so the next eval still has its VM registers.

OPTION CASEMAP:NONE

EXTERN arm_load_base:PROC
EXTERN _find_word:PROC

.DATA

save_arm DQ 31 DUP(0)
save_n   DB 0
save_z   DB 0
save_c   DB 0
save_v   DB 0

.CODE

PUBLIC host_find_word
host_find_word PROC
    push rbx
    push r12
    push rsi
    push rdi
    push r15
    mov rbx, rcx
    mov r12, rdx
    sub rsp, 20h
    call arm_load_base
    mov r15, rax
    lea rsi, [r15]
    lea rdi, save_arm
    mov rcx, 31
    rep movsq
    mov al, BYTE PTR [r15+248]
    mov save_n, al
    mov al, BYTE PTR [r15+249]
    mov save_z, al
    mov al, BYTE PTR [r15+250]
    mov save_c, al
    mov al, BYTE PTR [r15+251]
    mov save_v, al
    mov QWORD PTR [r15], rbx
    mov QWORD PTR [r15+8], r12
    lea rax, host_find_back
    mov QWORD PTR [r15+240], rax
    add rsp, 20h
    jmp _find_word
host_find_back:
    mov rbx, QWORD PTR [r15]
    lea rsi, save_arm
    lea rdi, [r15]
    mov rcx, 31
    rep movsq
    mov al, save_n
    mov BYTE PTR [r15+248], al
    mov al, save_z
    mov BYTE PTR [r15+249], al
    mov al, save_c
    mov BYTE PTR [r15+250], al
    mov al, save_v
    mov BYTE PTR [r15+251], al
    mov rax, rbx
    pop r15
    pop rdi
    pop rsi
    pop r12
    pop rbx
    ret
host_find_word ENDP

END
