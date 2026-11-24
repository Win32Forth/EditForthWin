; Generated from Forth/kernel/arm64/sa_files.asm. Do not edit.
OPTION CASEMAP:NONE
EXTRN arm_excl:QWORD
EXTRN arm_excl_addr:QWORD
EXTRN arm_excl_val:QWORD
EXTRN file_op_hook:BYTE
EXTRN sa_win_file_op:PROC
.CODE
PUBLIC _file_op_call
BWSTR SEGMENT ALIGN(1) READ
nm_SA_FILES:
    ; DCB "(SA-FILES)", 0
    DB "(SA-FILES)", 0
hl_SA_FILES:
    ; DCB "(SA-FILES) ( -- ) stand-alone file runtime block", 0
    DB "(SA-FILES) ( -- ) stand-alone file runtime block", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_SA_FILES:
    ; DCQ     nm_SA_FILES, hl_SA_FILES
    DQ OFFSET nm_SA_FILES, OFFSET hl_SA_FILES
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     SA_FILES, SA_FILES_END
    DQ OFFSET SA_FILES, OFFSET SA_FILES_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_SA_FILES
    DQ OFFSET row_SA_FILES
BOOTPTR ENDS
.CODE
BWSTR SEGMENT ALIGN(1) READ
nm_XFILE_OP_CALL:
    ; DCB "(FILE-OP-CALL)", 0
    DB "(FILE-OP-CALL)", 0
hl_XFILE_OP_CALL:
    ; DCB "(FILE-OP-CALL) ( -- ) file op multiplex", 0
    DB "(FILE-OP-CALL) ( -- ) file op multiplex", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFILE_OP_CALL:
    ; DCQ     nm_XFILE_OP_CALL, hl_XFILE_OP_CALL
    DQ OFFSET nm_XFILE_OP_CALL, OFFSET hl_XFILE_OP_CALL
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     XFILE_OP_CALL, XFILE_OP_CALL_END
    DQ OFFSET XFILE_OP_CALL, OFFSET XFILE_OP_CALL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFILE_OP_CALL
    DQ OFFSET row_XFILE_OP_CALL
BOOTPTR ENDS
.CODE
SA_FILES:
XFILE_OP_CALL:
_file_op_call:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x29, sp
    mov rax, rsp
    mov QWORD PTR [r15+232], rax
    ; adr     x9, sa_files_hook_ptr
    lea rax, sa_files_hook_ptr
    mov QWORD PTR [r15+72], rax
    ; ldr     x9, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+72], rax
    ; cbnz    x9, _sfc_have
    mov rax, QWORD PTR [r15+72]
    cmp rax, 0
    jne _sfc_have
    ; lea x9, file_op_hook
    lea rax, file_op_hook
    mov QWORD PTR [r15+72], rax
_sfc_have:
    ; ldr     x9, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+72], rax
    ; cbz     x9, _sfc_win
    mov rax, QWORD PTR [r15+72]
    cmp rax, 0
    je _sfc_win
    ; b       _sfc_call
    jmp _sfc_call
_sfc_win:
    ; adr     x9, sa_win_file_op_ptr
    lea rax, sa_win_file_op_ptr
    mov QWORD PTR [r15+72], rax
    ; ldr     x9, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+72], rax
    ; cbz     x9, _sfc_none
    mov rax, QWORD PTR [r15+72]
    cmp rax, 0
    je _sfc_none
_sfc_call:
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; add     x6, sp, #16
    mov rax, rsp
    add rax, 10h
    mov QWORD PTR [r15+48], rax
    ; add     x7, sp, #24
    mov rax, rsp
    add rax, 18h
    mov QWORD PTR [r15+56], rax
    ; add     x8, sp, #32
    mov rax, rsp
    add rax, 20h
    mov QWORD PTR [r15+64], rax
    ; str     xzr, [x6]
    mov r10, QWORD PTR [r15+48]
    mov QWORD PTR [r10], 0
    ; str     xzr, [x7]
    mov r10, QWORD PTR [r15+56]
    mov QWORD PTR [r10], 0
    ; str     xzr, [x8]
    mov r10, QWORD PTR [r15+64]
    mov QWORD PTR [r10], 0
    ; str     x8, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+64]
    mov QWORD PTR [r10], rax
    ; blr     x9
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR [r15+0]
    mov rdx, QWORD PTR [r15+8]
    mov r8, QWORD PTR [r15+16]
    mov r9, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    mov r11, QWORD PTR [r15+72]
    call r11
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; ldr     x6, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+48], rax
    ; ldr     x7, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+56], rax
    ; ldr     x8, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+64], rax
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_sfc_none:
    ; mov     x0, #-1
    mov rax, -1
    mov QWORD PTR [r15+0], rax
    ; mov     x6, #0
    mov rax, 0
    mov QWORD PTR [r15+48], rax
    ; mov     x7, #0
    mov rax, 0
    mov QWORD PTR [r15+56], rax
    ; mov     x8, #0
    mov rax, 0
    mov QWORD PTR [r15+64], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
XFILE_OP_CALL_END:
    ; ALIGN 8
ALIGN 8
sa_win_file_op_ptr:
    ; DCQ     sa_win_file_op
    DQ OFFSET sa_win_file_op
sa_files_hook_ptr:
    ; DCQ     0
    DQ 0
sa_files_zero_cell:
    ; DCQ     0
    DQ 0
sa_files_pool_pad0:
    ; DCQ     0
    DQ 0
sa_files_pool_pad1:
    ; DCQ     0
    DQ 0
SA_FILES_END:
END
