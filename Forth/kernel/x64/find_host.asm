; C-callable wrapper for the translated _find_word.
; Public domain.
;
; The ARM64 kernel exports _find_word as a normal function (x0 = token,
; x1 = length, ret = CFA). The x64 translation keeps those values in the
; virtual register file and returns with jmp [arm_x30]. companion.c calls
; it for Ctrl+click VIEW and breakpoints. A direct call ignores rcx/rdx
; and jumps through a stale arm_x30, which kills forthx64.exe. The editor
; then prints "Forth stopped."
;
; Save the register file, pass the C arguments in, return here, then put
; the file back so the next eval still has its VM registers.

OPTION CASEMAP:NONE

EXTERN arm_x0:QWORD
EXTERN arm_x1:QWORD
EXTERN arm_x30:QWORD
EXTERN arm_n:BYTE
EXTERN arm_z:BYTE
EXTERN arm_c:BYTE
EXTERN arm_v:BYTE
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
    mov rbx, rcx
    mov r12, rdx
    push rsi
    push rdi
    lea rsi, arm_x0
    lea rdi, save_arm
    mov rcx, 31
    rep movsq
    mov al, BYTE PTR arm_n
    mov save_n, al
    mov al, BYTE PTR arm_z
    mov save_z, al
    mov al, BYTE PTR arm_c
    mov save_c, al
    mov al, BYTE PTR arm_v
    mov save_v, al
    pop rdi
    pop rsi
    mov QWORD PTR arm_x0, rbx
    mov QWORD PTR arm_x1, r12
    lea rax, host_find_back
    mov QWORD PTR arm_x30, rax
    jmp _find_word
host_find_back:
    mov rbx, QWORD PTR arm_x0
    push rsi
    push rdi
    lea rsi, save_arm
    lea rdi, arm_x0
    mov rcx, 31
    rep movsq
    mov al, save_n
    mov BYTE PTR arm_n, al
    mov al, save_z
    mov BYTE PTR arm_z, al
    mov al, save_c
    mov BYTE PTR arm_c, al
    mov al, save_v
    mov BYTE PTR arm_v, al
    pop rdi
    pop rsi
    mov rax, rbx
    pop r12
    pop rbx
    ret
host_find_word ENDP

END
