; Generated from Forth/kernel/arm64/prims_k1.asm. Do not edit.
OPTION CASEMAP:NONE
EXTRN arm_x0:QWORD
EXTRN arm_x1:QWORD
EXTRN arm_x2:QWORD
EXTRN arm_x3:QWORD
EXTRN arm_x4:QWORD
EXTRN arm_x5:QWORD
EXTRN arm_x6:QWORD
EXTRN arm_x7:QWORD
EXTRN arm_x8:QWORD
EXTRN arm_x9:QWORD
EXTRN arm_x10:QWORD
EXTRN arm_x11:QWORD
EXTRN arm_x12:QWORD
EXTRN arm_x13:QWORD
EXTRN arm_x14:QWORD
EXTRN arm_x15:QWORD
EXTRN arm_x16:QWORD
EXTRN arm_x17:QWORD
EXTRN arm_x18:QWORD
EXTRN arm_x19:QWORD
EXTRN arm_x20:QWORD
EXTRN arm_x21:QWORD
EXTRN arm_x22:QWORD
EXTRN arm_x23:QWORD
EXTRN arm_x24:QWORD
EXTRN arm_x25:QWORD
EXTRN arm_x26:QWORD
EXTRN arm_x27:QWORD
EXTRN arm_x28:QWORD
EXTRN arm_x29:QWORD
EXTRN arm_x30:QWORD
EXTRN arm_n:BYTE
EXTRN arm_z:BYTE
EXTRN arm_c:BYTE
EXTRN arm_v:BYTE
EXTRN DOCOL:PROC
EXTRN _compile_cell:PROC
EXTRN _cursor_commit:PROC
EXTRN _cursor_load:PROC
EXTRN _find_word:PROC
EXTRN _header_build:PROC
EXTRN _next_word:PROC
EXTRN _nfa_reveal_cfa:PROC
EXTRN _print_signed:PROC
EXTRN _print_wid_name:PROC
EXTRN _putchar:PROC
EXTRN _quit_exit:PROC
EXTRN _take_line:PROC
EXTRN _take_pending_help:PROC
EXTRN _throw_unwind_to_sp:PROC
EXTRN base_var:BYTE
EXTRN blk_var:BYTE
EXTRN cfa_0branch:BYTE
EXTRN cfa_branch:BYTE
EXTRN cfa_cstr:BYTE
EXTRN cfa_does:BYTE
EXTRN cfa_lit:BYTE
EXTRN cfa_slit:BYTE
EXTRN current_var:BYTE
EXTRN data_stack:BYTE
EXTRN debug_break_asap:BYTE
EXTRN emit_cstr:PROC
EXTRN emit_str:PROC
EXTRN eval_resume_sp:BYTE
EXTRN here_ptr:BYTE
EXTRN last_cfa:BYTE
EXTRN latest_var:BYTE
EXTRN line_mode:BYTE
EXTRN next_debug:PROC
EXTRN pad_buffer:BYTE
EXTRN pending_help_addr:BYTE
EXTRN pending_help_len:BYTE
EXTRN search_order:BYTE
EXTRN search_order_n:BYTE
EXTRN source_base:BYTE
EXTRN source_cur:BYTE
EXTRN source_end:BYTE
EXTRN state_var:BYTE
EXTRN throw_handler:BYTE
EXTRN to_in:BYTE
EXTRN user_dict_area:BYTE
EXTRN user_dict_size_cell:BYTE
EXTRN word_scratch:BYTE
EXTRN wordlist_reg:BYTE
EXTRN wordlist_reg_n:BYTE
EXTRN xchar_emit_buf:BYTE
.CODE
PUBLIC DOVAR
PUBLIC DOCON
PUBLIC DODOES
PUBLIC XTHROW
PUBLIC XBranch
PUBLIC X0Branch
PUBLIC XTYPE
PUBLIC msg_allot
BWSTR SEGMENT ALIGN(1) READ
nm_XQDUP:
    ; DCB "?DUP", 0
    DB "?DUP", 0
hl_XQDUP:
    ; DCB "?DUP ( n -- n n | 0 ) dup if non-zero", 0
    DB "?DUP ( n -- n n | 0 ) dup if non-zero", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XQDUP:
    ; DCQ     nm_XQDUP, hl_XQDUP
    DQ OFFSET nm_XQDUP, OFFSET hl_XQDUP
    ; DCQ     0
    DQ 0
    ; DCQ     XQDUP, XQDUP_END
    DQ OFFSET XQDUP, OFFSET XQDUP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XQDUP
    DQ OFFSET row_XQDUP
BOOTPTR ENDS
.CODE
XQDUP:
    ; cbz     x20, XQDUP_END
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    je XQDUP_END
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
XQDUP_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XROT:
    ; DCB "ROT", 0
    DB "ROT", 0
hl_XROT:
    ; DCB "ROT ( a b c -- b c a ) rotate top three", 0
    DB "ROT ( a b c -- b c a ) rotate top three", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XROT:
    ; DCQ     nm_XROT, hl_XROT
    DQ OFFSET nm_XROT, OFFSET hl_XROT
    ; DCQ     0
    DQ 0
    ; DCQ     XROT, XROT_END
    DQ OFFSET XROT, OFFSET XROT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XROT
    DQ OFFSET row_XROT
BOOTPTR ENDS
.CODE
XROT:
    ; ldr     x0, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x22, #8]
    mov r10, QWORD PTR arm_x22
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x22, #8]
    mov r10, QWORD PTR arm_x22
    add r10, 8
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; str     x20, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x20, rax
XROT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XNROT:
    ; DCB "-ROT", 0
    DB "-ROT", 0
hl_XNROT:
    ; DCB "-ROT ( a b c -- c a b ) reverse-rotate top three", 0
    DB "-ROT ( a b c -- c a b ) reverse-rotate top three", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XNROT:
    ; DCQ     nm_XNROT, hl_XNROT
    DQ OFFSET nm_XNROT, OFFSET hl_XNROT
    ; DCQ     0
    DQ 0
    ; DCQ     XNROT, XNROT_END
    DQ OFFSET XNROT, OFFSET XNROT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XNROT
    DQ OFFSET row_XNROT
BOOTPTR ENDS
.CODE
XNROT:
    ; ldr     x0, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x22, #8]
    mov r10, QWORD PTR arm_x22
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; str     x20, [x22, #8]
    mov r10, QWORD PTR arm_x22
    add r10, 8
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; str     x1, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XNROT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
PUBLIC XROLL
BWSTR SEGMENT ALIGN(1) READ
nm_XROLL:
    ; DCB "ROLL", 0
    DB "ROLL", 0
hl_XROLL:
    ; DCB "ROLL ( xu ... x0 u -- xu ) move the uth cell to TOS", 0
    DB "ROLL ( xu ... x0 u -- xu ) move the uth cell to TOS", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XROLL:
    ; DCQ     nm_XROLL, hl_XROLL
    DQ OFFSET nm_XROLL, OFFSET hl_XROLL
    ; DCQ     0
    DQ 0
    ; DCQ     XROLL, XROLL_END
    DQ OFFSET XROLL, OFFSET XROLL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XROLL
    DQ OFFSET row_XROLL
BOOTPTR ENDS
.CODE
XROLL:
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cbz     x1, XROLL_END
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je XROLL_END
    ; sub     x2, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x2, rax
    ; lsl     x2, x2, #3
    mov rax, QWORD PTR arm_x2
    shl rax, 3
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x22, x2]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; mov     x4, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x4, rax
_roll_shift:
    ; cbz     x4, _roll_put
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    je _roll_put
    ; sub     x5, x4, #8
    mov rax, QWORD PTR arm_x4
    sub rax, 8
    mov QWORD PTR arm_x5, rax
    ; ldr     x6, [x22, x5]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x5
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; str     x6, [x22, x4]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x4
    add r10, rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; mov     x4, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x4, rax
    ; b       _roll_shift
    jmp _roll_shift
_roll_put:
    ; str     x0, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; mov     x20, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x20, rax
XROLL_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XNIP:
    ; DCB "NIP", 0
    DB "NIP", 0
hl_XNIP:
    ; DCB "NIP ( x1 x2 -- x2 ) drop the cell under TOS", 0
    DB "NIP ( x1 x2 -- x2 ) drop the cell under TOS", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XNIP:
    ; DCQ     nm_XNIP, hl_XNIP
    DQ OFFSET nm_XNIP, OFFSET hl_XNIP
    ; DCQ     0
    DQ 0
    ; DCQ     XNIP, XNIP_END
    DQ OFFSET XNIP, OFFSET XNIP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XNIP
    DQ OFFSET row_XNIP
BOOTPTR ENDS
.CODE
XNIP:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
XNIP_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XTOR:
    ; DCB ">R", 0
    DB ">R", 0
hl_XTOR:
    ; DCB ">R ( n -- ) ( R: -- n ) to return stack", 0
    DB ">R ( n -- ) ( R: -- n ) to return stack", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTOR:
    ; DCQ     nm_XTOR, hl_XTOR
    DQ OFFSET nm_XTOR, OFFSET hl_XTOR
    ; DCQ     0
    DQ 0
    ; DCQ     XTOR, XTOR_END
    DQ OFFSET XTOR, OFFSET XTOR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTOR
    DQ OFFSET row_XTOR
BOOTPTR ENDS
.CODE
XTOR:
    ; str     x20, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
XTOR_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XRTO:
    ; DCB "R>", 0
    DB "R>", 0
hl_XRTO:
    ; DCB "R> ( -- n ) ( R: n -- ) from return stack", 0
    DB "R> ( -- n ) ( R: n -- ) from return stack", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRTO:
    ; DCQ     nm_XRTO, hl_XRTO
    DQ OFFSET nm_XRTO, OFFSET hl_XRTO
    ; DCQ     0
    DQ 0
    ; DCQ     XRTO, XRTO_END
    DQ OFFSET XRTO, OFFSET XRTO_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRTO
    DQ OFFSET row_XRTO
BOOTPTR ENDS
.CODE
XRTO:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
XRTO_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XRFETCH:
    ; DCB "R@", 0
    DB "R@", 0
hl_XRFETCH:
    ; DCB "R@ ( -- n ) ( R: n -- n ) copy top of return stack", 0
    DB "R@ ( -- n ) ( R: n -- n ) copy top of return stack", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRFETCH:
    ; DCQ     nm_XRFETCH, hl_XRFETCH
    DQ OFFSET nm_XRFETCH, OFFSET hl_XRFETCH
    ; DCQ     0
    DQ 0
    ; DCQ     XRFETCH, XRFETCH_END
    DQ OFFSET XRFETCH, OFFSET XRFETCH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRFETCH
    DQ OFFSET row_XRFETCH
BOOTPTR ENDS
.CODE
XRFETCH:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x23]
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
XRFETCH_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XONEPLUS:
    ; DCB "1+", 0
    DB "1+", 0
hl_XONEPLUS:
    ; DCB "1+ ( n -- n+1 ) increment", 0
    DB "1+ ( n -- n+1 ) increment", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XONEPLUS:
    ; DCQ     nm_XONEPLUS, hl_XONEPLUS
    DQ OFFSET nm_XONEPLUS, OFFSET hl_XONEPLUS
    ; DCQ     0
    DQ 0
    ; DCQ     XONEPLUS, XONEPLUS_END
    DQ OFFSET XONEPLUS, OFFSET XONEPLUS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XONEPLUS
    DQ OFFSET row_XONEPLUS
BOOTPTR ENDS
.CODE
XONEPLUS:
    ; add     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    add rax, 1
    mov QWORD PTR arm_x20, rax
XONEPLUS_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XAND:
    ; DCB "AND", 0
    DB "AND", 0
hl_XAND:
    ; DCB "AND ( n1 n2 -- n ) bitwise and", 0
    DB "AND ( n1 n2 -- n ) bitwise and", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAND:
    ; DCQ     nm_XAND, hl_XAND
    DQ OFFSET nm_XAND, OFFSET hl_XAND
    ; DCQ     0
    DQ 0
    ; DCQ     XAND, XAND_END
    DQ OFFSET XAND, OFFSET XAND_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAND
    DQ OFFSET row_XAND
BOOTPTR ENDS
.CODE
XAND:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; and     x20, x20, x0
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x0
    and rax, rcx
    mov QWORD PTR arm_x20, rax
XAND_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XORR:
    ; DCB "OR", 0
    DB "OR", 0
hl_XORR:
    ; DCB "OR ( n1 n2 -- n ) bitwise or", 0
    DB "OR ( n1 n2 -- n ) bitwise or", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XORR:
    ; DCQ     nm_XORR, hl_XORR
    DQ OFFSET nm_XORR, OFFSET hl_XORR
    ; DCQ     0
    DQ 0
    ; DCQ     XORR, XORR_END
    DQ OFFSET XORR, OFFSET XORR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XORR
    DQ OFFSET row_XORR
BOOTPTR ENDS
.CODE
XORR:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; orr     x20, x20, x0
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x0
    or rax, rcx
    mov QWORD PTR arm_x20, rax
XORR_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XINVERT:
    ; DCB "INVERT", 0
    DB "INVERT", 0
hl_XINVERT:
    ; DCB "INVERT ( n -- ~n ) bitwise invert", 0
    DB "INVERT ( n -- ~n ) bitwise invert", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XINVERT:
    ; DCQ     nm_XINVERT, hl_XINVERT
    DQ OFFSET nm_XINVERT, OFFSET hl_XINVERT
    ; DCQ     0
    DQ 0
    ; DCQ     XINVERT, XINVERT_END
    DQ OFFSET XINVERT, OFFSET XINVERT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XINVERT
    DQ OFFSET row_XINVERT
BOOTPTR ENDS
.CODE
XINVERT:
    ; mvn     x20, x20
    mov rax, QWORD PTR arm_x20
    not rax
    mov QWORD PTR arm_x20, rax
XINVERT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XRSHIFT:
    ; DCB "RSHIFT", 0
    DB "RSHIFT", 0
hl_XRSHIFT:
    ; DCB "RSHIFT ( n bits -- n ) logical right shift", 0
    DB "RSHIFT ( n bits -- n ) logical right shift", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRSHIFT:
    ; DCQ     nm_XRSHIFT, hl_XRSHIFT
    DQ OFFSET nm_XRSHIFT, OFFSET hl_XRSHIFT
    ; DCQ     0
    DQ 0
    ; DCQ     XRSHIFT, XRSHIFT_END
    DQ OFFSET XRSHIFT, OFFSET XRSHIFT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRSHIFT
    DQ OFFSET row_XRSHIFT
BOOTPTR ENDS
.CODE
XRSHIFT:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; lsr     x20, x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    shr rax, cl
    mov QWORD PTR arm_x20, rax
XRSHIFT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XEQUAL:
    ; DCB "=", 0
    DB "=", 0
hl_XEQUAL:
    ; DCB "= ( n1 n2 -- flag ) equal", 0
    DB "= ( n1 n2 -- flag ) equal", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XEQUAL:
    ; DCQ     nm_XEQUAL, hl_XEQUAL
    DQ OFFSET nm_XEQUAL, OFFSET hl_XEQUAL
    ; DCQ     0
    DQ 0
    ; DCQ     XEQUAL, XEQUAL_END
    DQ OFFSET XEQUAL, OFFSET XEQUAL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XEQUAL
    DQ OFFSET row_XEQUAL
BOOTPTR ENDS
.CODE
XEQUAL:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cmp     x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, eq
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    je xsk_1
    mov rax, -1
    xsk_1:
    mov QWORD PTR arm_x20, rax
XEQUAL_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XLESS:
    ; DCB "<", 0
    DB "<", 0
hl_XLESS:
    ; DCB "< ( n1 n2 -- flag ) less than", 0
    DB "< ( n1 n2 -- flag ) less than", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLESS:
    ; DCQ     nm_XLESS, hl_XLESS
    DQ OFFSET nm_XLESS, OFFSET hl_XLESS
    ; DCQ     0
    DQ 0
    ; DCQ     XLESS, XLESS_END
    DQ OFFSET XLESS, OFFSET XLESS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLESS
    DQ OFFSET row_XLESS
BOOTPTR ENDS
.CODE
XLESS:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cmp     x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, lt
    xor eax, eax
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je xsk_2
    mov rax, -1
    xsk_2:
    mov QWORD PTR arm_x20, rax
XLESS_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XGREATER:
    ; DCB ">", 0
    DB ">", 0
hl_XGREATER:
    ; DCB "> ( n1 n2 -- flag ) greater than", 0
    DB "> ( n1 n2 -- flag ) greater than", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XGREATER:
    ; DCQ     nm_XGREATER, hl_XGREATER
    DQ OFFSET nm_XGREATER, OFFSET hl_XGREATER
    ; DCQ     0
    DQ 0
    ; DCQ     XGREATER, XGREATER_END
    DQ OFFSET XGREATER, OFFSET XGREATER_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XGREATER
    DQ OFFSET row_XGREATER
BOOTPTR ENDS
.CODE
XGREATER:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cmp     x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, gt
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    jne xsk_3
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne xsk_3
    mov rax, -1
    xsk_3:
    mov QWORD PTR arm_x20, rax
XGREATER_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XZEQUAL:
    ; DCB "0=", 0
    DB "0=", 0
hl_XZEQUAL:
    ; DCB "0= ( n -- flag ) zero?", 0
    DB "0= ( n -- flag ) zero?", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XZEQUAL:
    ; DCQ     nm_XZEQUAL, hl_XZEQUAL
    DQ OFFSET nm_XZEQUAL, OFFSET hl_XZEQUAL
    ; DCQ     0
    DQ 0
    ; DCQ     XZEQUAL, XZEQUAL_END
    DQ OFFSET XZEQUAL, OFFSET XZEQUAL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XZEQUAL
    DQ OFFSET row_XZEQUAL
BOOTPTR ENDS
.CODE
XZEQUAL:
    ; cmp     x20, #0
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, eq
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    je xsk_4
    mov rax, -1
    xsk_4:
    mov QWORD PTR arm_x20, rax
XZEQUAL_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XFETCH:
    ; DCB "@", 0
    DB "@", 0
hl_XFETCH:
    ; DCB "@ ( addr -- n ) fetch cell", 0
    DB "@ ( addr -- n ) fetch cell", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFETCH:
    ; DCQ     nm_XFETCH, hl_XFETCH
    DQ OFFSET nm_XFETCH, OFFSET hl_XFETCH
    ; DCQ     0
    DQ 0
    ; DCQ     XFETCH, XFETCH_END
    DQ OFFSET XFETCH, OFFSET XFETCH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFETCH
    DQ OFFSET row_XFETCH
BOOTPTR ENDS
.CODE
XFETCH:
    ; ldr     x20, [x20]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
XFETCH_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSTORE:
    ; DCB "!", 0
    DB "!", 0
hl_XSTORE:
    ; DCB "! ( n addr -- ) store cell", 0
    DB "! ( n addr -- ) store cell", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSTORE:
    ; DCQ     nm_XSTORE, hl_XSTORE
    DQ OFFSET nm_XSTORE, OFFSET hl_XSTORE
    ; DCQ     0
    DQ 0
    ; DCQ     XSTORE, XSTORE_END
    DQ OFFSET XSTORE, OFFSET XSTORE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSTORE
    DQ OFFSET row_XSTORE
BOOTPTR ENDS
.CODE
XSTORE:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; str     x0, [x20]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
XSTORE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCFETCH:
    ; DCB "C@", 0
    DB "C@", 0
hl_XCFETCH:
    ; DCB "C@ ( addr -- byte ) fetch byte", 0
    DB "C@ ( addr -- byte ) fetch byte", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCFETCH:
    ; DCQ     nm_XCFETCH, hl_XCFETCH
    DQ OFFSET nm_XCFETCH, OFFSET hl_XCFETCH
    ; DCQ     0
    DQ 0
    ; DCQ     XCFETCH, XCFETCH_END
    DQ OFFSET XCFETCH, OFFSET XCFETCH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCFETCH
    DQ OFFSET row_XCFETCH
BOOTPTR ENDS
.CODE
XCFETCH:
    ; ldrb    w20, [x20]
    mov r10, QWORD PTR arm_x20
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x20, rax
XCFETCH_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCSTORE:
    ; DCB "C!", 0
    DB "C!", 0
hl_XCSTORE:
    ; DCB "C! ( byte addr -- ) store byte", 0
    DB "C! ( byte addr -- ) store byte", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCSTORE:
    ; DCQ     nm_XCSTORE, hl_XCSTORE
    DQ OFFSET nm_XCSTORE, OFFSET hl_XCSTORE
    ; DCQ     0
    DQ 0
    ; DCQ     XCSTORE, XCSTORE_END
    DQ OFFSET XCSTORE, OFFSET XCSTORE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCSTORE
    DQ OFFSET row_XCSTORE
BOOTPTR ENDS
.CODE
XCSTORE:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; strb    w0, [x20]
    mov r10, QWORD PTR arm_x20
    mov eax, DWORD PTR arm_x0
    mov BYTE PTR [r10], al
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
XCSTORE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XBL:
    ; DCB "BL", 0
    DB "BL", 0
hl_XBL:
    ; DCB "BL ( -- c ) ASCII blank", 0
    DB "BL ( -- c ) ASCII blank", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBL:
    ; DCQ     nm_XBL, hl_XBL
    DQ OFFSET nm_XBL, OFFSET hl_XBL
    ; DCQ     0
    DQ 0
    ; DCQ     XBL, XBL_END
    DQ OFFSET XBL, OFFSET XBL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBL
    DQ OFFSET row_XBL
BOOTPTR ENDS
.CODE
XBL:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XBL_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XEMIT:
    ; DCB "EMIT", 0
    DB "EMIT", 0
hl_XEMIT:
    ; DCB "EMIT ( c -- ) emit one character", 0
    DB "EMIT ( c -- ) emit one character", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XEMIT:
    ; DCQ     nm_XEMIT, hl_XEMIT
    DQ OFFSET nm_XEMIT, OFFSET hl_XEMIT
    ; DCQ     0
    DQ 0
    ; DCQ     XEMIT, XEMIT_END
    DQ OFFSET XEMIT, OFFSET XEMIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XEMIT
    DQ OFFSET row_XEMIT
BOOTPTR ENDS
.CODE
XEMIT:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _putchar
    lea rax, xret_5
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_5:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
XEMIT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XTYPE:
    ; DCB "TYPE", 0
    DB "TYPE", 0
hl_XTYPE:
    ; DCB "TYPE ( addr len -- ) type string", 0
    DB "TYPE ( addr len -- ) type string", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTYPE:
    ; DCQ     nm_XTYPE, hl_XTYPE
    DQ OFFSET nm_XTYPE, OFFSET hl_XTYPE
    ; DCQ     0
    DQ 0
    ; DCQ     XTYPE, XTYPE_END
    DQ OFFSET XTYPE, OFFSET XTYPE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTYPE
    DQ OFFSET row_XTYPE
BOOTPTR ENDS
.CODE
XTYPE:
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cbz     x1, XTYPE_END
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je XTYPE_END
    ; sub     sp, sp, #80
    mov rax, rsp
    sub rax, 50h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; ldp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; bl      emit_str
    lea rax, xret_6
    mov QWORD PTR arm_x30, rax
    jmp emit_str
    xret_6:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #80
    mov rax, rsp
    add rax, 50h
    mov rsp, rax
XTYPE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XXCHAR_EMIT:
    ; DCB "XEMIT", 0
    DB "XEMIT", 0
hl_XXCHAR_EMIT:
    ; DCB "XEMIT ( xchar -- ) emit UTF-8 xchar to console", 0
    DB "XEMIT ( xchar -- ) emit UTF-8 xchar to console", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XXCHAR_EMIT:
    ; DCQ     nm_XXCHAR_EMIT, hl_XXCHAR_EMIT
    DQ OFFSET nm_XXCHAR_EMIT, OFFSET hl_XXCHAR_EMIT
    ; DCQ     0
    DQ 0
    ; DCQ     XXCHAR_EMIT, XXCHAR_EMIT_END
    DQ OFFSET XXCHAR_EMIT, OFFSET XXCHAR_EMIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XXCHAR_EMIT
    DQ OFFSET row_XXCHAR_EMIT
BOOTPTR ENDS
.CODE
XXCHAR_EMIT:
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; movz    x2, #0xFFFF
    mov rax, 0FFFFh
    mov QWORD PTR arm_x2, rax
    ; movk    x2, #0x10, lsl #16
    mov rax, QWORD PTR arm_x2
    mov rcx, 0FFFFFFFF0000FFFFh
    and rax, rcx
    mov rcx, 100000h
    or rax, rcx
    mov QWORD PTR arm_x2, rax
    ; cmp     x1, x2
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csel    x1, x2, x1, hi
    cmp BYTE PTR arm_c, 0
    je xsk_9
    cmp BYTE PTR arm_z, 0
    je xsk_7
    xsk_9:
    mov rax, QWORD PTR arm_x1
    jmp xsk_8
    xsk_7:
    mov rax, QWORD PTR arm_x2
    xsk_8:
    mov QWORD PTR arm_x1, rax
    ; lea x0, xchar_emit_buf
    lea rax, xchar_emit_buf
    mov QWORD PTR arm_x0, rax
    ; mov     x3, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x3, rax
    ; cmp     x1, #0x7F
    mov rax, QWORD PTR arm_x1
    cmp rax, 7Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _xe_1
    cmp BYTE PTR arm_c, 0
    je _xe_1
    cmp BYTE PTR arm_z, 0
    jne _xe_1
    ; cmp     x1, #0x7FF
    mov rax, QWORD PTR arm_x1
    cmp rax, 7FFh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _xe_2
    cmp BYTE PTR arm_c, 0
    je _xe_2
    cmp BYTE PTR arm_z, 0
    jne _xe_2
    ; movz    x4, #0xFFFF
    mov rax, 0FFFFh
    mov QWORD PTR arm_x4, rax
    ; cmp     x1, x4
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x4
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _xe_3
    cmp BYTE PTR arm_c, 0
    je _xe_3
    cmp BYTE PTR arm_z, 0
    jne _xe_3
    ; lsr     x4, x1, #18
    mov rax, QWORD PTR arm_x1
    shr rax, 18
    mov QWORD PTR arm_x4, rax
    ; orr     w4, w4, #0xF0
    mov eax, DWORD PTR arm_x4
    or eax, 0F0h
    mov QWORD PTR arm_x4, rax
    ; strb    w4, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; lsr     x4, x1, #12
    mov rax, QWORD PTR arm_x1
    shr rax, 12
    mov QWORD PTR arm_x4, rax
    ; and     w4, w4, #0x3F
    mov eax, DWORD PTR arm_x4
    and eax, 3Fh
    mov QWORD PTR arm_x4, rax
    ; orr     w4, w4, #0x80
    mov eax, DWORD PTR arm_x4
    or eax, 80h
    mov QWORD PTR arm_x4, rax
    ; strb    w4, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; lsr     x4, x1, #6
    mov rax, QWORD PTR arm_x1
    shr rax, 6
    mov QWORD PTR arm_x4, rax
    ; and     w4, w4, #0x3F
    mov eax, DWORD PTR arm_x4
    and eax, 3Fh
    mov QWORD PTR arm_x4, rax
    ; orr     w4, w4, #0x80
    mov eax, DWORD PTR arm_x4
    or eax, 80h
    mov QWORD PTR arm_x4, rax
    ; strb    w4, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w4, w1, #0x3F
    mov eax, DWORD PTR arm_x1
    and eax, 3Fh
    mov QWORD PTR arm_x4, rax
    ; orr     w4, w4, #0x80
    mov eax, DWORD PTR arm_x4
    or eax, 80h
    mov QWORD PTR arm_x4, rax
    ; strb    w4, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; b       _xe_9
    jmp _xe_9
_xe_3:
    ; lsr     x4, x1, #12
    mov rax, QWORD PTR arm_x1
    shr rax, 12
    mov QWORD PTR arm_x4, rax
    ; orr     w4, w4, #0xE0
    mov eax, DWORD PTR arm_x4
    or eax, 0E0h
    mov QWORD PTR arm_x4, rax
    ; strb    w4, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; lsr     x4, x1, #6
    mov rax, QWORD PTR arm_x1
    shr rax, 6
    mov QWORD PTR arm_x4, rax
    ; and     w4, w4, #0x3F
    mov eax, DWORD PTR arm_x4
    and eax, 3Fh
    mov QWORD PTR arm_x4, rax
    ; orr     w4, w4, #0x80
    mov eax, DWORD PTR arm_x4
    or eax, 80h
    mov QWORD PTR arm_x4, rax
    ; strb    w4, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w4, w1, #0x3F
    mov eax, DWORD PTR arm_x1
    and eax, 3Fh
    mov QWORD PTR arm_x4, rax
    ; orr     w4, w4, #0x80
    mov eax, DWORD PTR arm_x4
    or eax, 80h
    mov QWORD PTR arm_x4, rax
    ; strb    w4, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; b       _xe_9
    jmp _xe_9
_xe_2:
    ; lsr     x4, x1, #6
    mov rax, QWORD PTR arm_x1
    shr rax, 6
    mov QWORD PTR arm_x4, rax
    ; orr     w4, w4, #0xC0
    mov eax, DWORD PTR arm_x4
    or eax, 0C0h
    mov QWORD PTR arm_x4, rax
    ; strb    w4, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w4, w1, #0x3F
    mov eax, DWORD PTR arm_x1
    and eax, 3Fh
    mov QWORD PTR arm_x4, rax
    ; orr     w4, w4, #0x80
    mov eax, DWORD PTR arm_x4
    or eax, 80h
    mov QWORD PTR arm_x4, rax
    ; strb    w4, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; b       _xe_9
    jmp _xe_9
_xe_1:
    ; strb    w1, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x1
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
_xe_9:
    ; sub     x1, x0, x3
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x3
    sub rax, rcx
    mov QWORD PTR arm_x1, rax
    ; mov     x0, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x0, rax
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      emit_str
    lea rax, xret_10
    mov QWORD PTR arm_x30, rax
    jmp emit_str
    xret_10:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
XXCHAR_EMIT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XDP:
    ; DCB "DP", 0
    DB "DP", 0
hl_XDP:
    ; DCB "DP ( -- addr ) dictionary pointer variable", 0
    DB "DP ( -- addr ) dictionary pointer variable", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDP:
    ; DCQ     nm_XDP, hl_XDP
    DQ OFFSET nm_XDP, OFFSET hl_XDP
    ; DCQ     0
    DQ 0
    ; DCQ     XDP, XDP_END
    DQ OFFSET XDP, OFFSET XDP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDP
    DQ OFFSET row_XDP
BOOTPTR ENDS
.CODE
XDP:
    ; lea x0, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XDP_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XHERE:
    ; DCB "HERE", 0
    DB "HERE", 0
hl_XHERE:
    ; DCB "HERE ( -- addr ) current dictionary pointer", 0
    DB "HERE ( -- addr ) current dictionary pointer", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XHERE:
    ; DCQ     nm_XHERE, hl_XHERE
    DQ OFFSET nm_XHERE, OFFSET hl_XHERE
    ; DCQ     0
    DQ 0
    ; DCQ     XHERE, XHERE_END
    DQ OFFSET XHERE, OFFSET XHERE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XHERE
    DQ OFFSET row_XHERE
BOOTPTR ENDS
.CODE
XHERE:
    ; lea x0, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XHERE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XALLOT:
    ; DCB "ALLOT", 0
    DB "ALLOT", 0
hl_XALLOT:
    ; DCB "ALLOT ( n -- ) allocate n bytes in dictionary", 0
    DB "ALLOT ( n -- ) allocate n bytes in dictionary", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XALLOT:
    ; DCQ     nm_XALLOT, hl_XALLOT
    DQ OFFSET nm_XALLOT, OFFSET hl_XALLOT
    ; DCQ     0
    DQ 0
    ; DCQ     XALLOT, XALLOT_END
    DQ OFFSET XALLOT, OFFSET XALLOT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XALLOT
    DQ OFFSET row_XALLOT
BOOTPTR ENDS
.CODE
XALLOT:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; lea x1, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; add     x3, x2, x0
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x0
    add rax, rcx
    mov QWORD PTR arm_x3, rax
    ; lea x4, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR arm_x4, rax
    ; cmp     x3, x4
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x4
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _allot_fail
    cmp BYTE PTR arm_c, 0
    je _allot_fail
    ; lea x5, user_dict_size_cell
    lea rax, user_dict_size_cell
    mov QWORD PTR arm_x5, rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR arm_x5
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; add     x5, x4, x5
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x5
    add rax, rcx
    mov QWORD PTR arm_x5, rax
    ; cmp     x3, x5
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _allot_fail
    cmp BYTE PTR arm_c, 0
    je xsk_11
    cmp BYTE PTR arm_z, 0
    je _allot_fail
    xsk_11:
    ; str     x3, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; b       XALLOT_END
    jmp XALLOT_END
_allot_fail:
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, msg_allot
    lea rax, msg_allot
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_12
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_12:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; b       _quit_exit
    jmp _quit_exit
XALLOT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCOMMA:
    ; DCB 0x2C, 0
    DB 2Ch, 0
hl_XCOMMA:
    ; DCB 0x2C, "( n -- ) compile a cell", 0
    DB 2Ch, "( n -- ) compile a cell", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCOMMA:
    ; DCQ     nm_XCOMMA, hl_XCOMMA
    DQ OFFSET nm_XCOMMA, OFFSET hl_XCOMMA
    ; DCQ     0
    DQ 0
    ; DCQ     XCOMMA, 0
    DQ OFFSET XCOMMA, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCOMMA
    DQ OFFSET row_XCOMMA
BOOTPTR ENDS
.CODE
XCOMMA:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _compile_cell
    lea rax, xret_13
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_13:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XIMMEDIATE:
    ; DCB "IMMEDIATE", 0
    DB "IMMEDIATE", 0
hl_XIMMEDIATE:
    ; DCB "IMMEDIATE ( -- ) mark latest word as immediate", 0
    DB "IMMEDIATE ( -- ) mark latest word as immediate", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XIMMEDIATE:
    ; DCQ     nm_XIMMEDIATE, hl_XIMMEDIATE
    DQ OFFSET nm_XIMMEDIATE, OFFSET hl_XIMMEDIATE
    ; DCQ     0
    DQ 0
    ; DCQ     XIMMEDIATE, 0
    DQ OFFSET XIMMEDIATE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XIMMEDIATE
    DQ OFFSET row_XIMMEDIATE
BOOTPTR ENDS
.CODE
XIMMEDIATE:
    ; lea x0, last_cfa
    lea rax, last_cfa
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _imm_done
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _imm_done
    ; ldr     x1, [x0, #-8]
    mov r10, QWORD PTR arm_x0
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #1
    mov rax, 1
    mov QWORD PTR arm_x2, rax
    ; lsl     x2, x2, #63
    mov rax, QWORD PTR arm_x2
    shl rax, 63
    mov QWORD PTR arm_x2, rax
    ; orr     x1, x1, x2
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x2
    or rax, rcx
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0, #-8]
    mov r10, QWORD PTR arm_x0
    add r10, -8
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
_imm_done:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSETDOC:
    ; DCB "SETDOC", 0
    DB "SETDOC", 0
hl_XSETDOC:
    ; DCB "SETDOC ( c-addr u -- ) pending help for next defining word", 0
    DB "SETDOC ( c-addr u -- ) pending help for next defining word", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSETDOC:
    ; DCQ     nm_XSETDOC, hl_XSETDOC
    DQ OFFSET nm_XSETDOC, OFFSET hl_XSETDOC
    ; DCQ     0
    DQ 0
    ; DCQ     XSETDOC, 0
    DQ OFFSET XSETDOC, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSETDOC
    DQ OFFSET row_XSETDOC
BOOTPTR ENDS
.CODE
XSETDOC:
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
_setdoc_skip:
    ; cbz     x1, _setdoc_store
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _setdoc_store
    ; ldrb    w2, [x0]
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cmp     w2, #32
    mov eax, DWORD PTR arm_x2
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _setdoc_adv
    cmp BYTE PTR arm_z, 0
    jne _setdoc_adv
    ; cmp     w2, #9
    mov eax, DWORD PTR arm_x2
    cmp eax, 9
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _setdoc_store
    cmp BYTE PTR arm_z, 0
    je _setdoc_store
_setdoc_adv:
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _setdoc_skip
    jmp _setdoc_skip
_setdoc_store:
    ; lea x2, pending_help_addr
    lea rax, pending_help_addr
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, pending_help_len
    lea rax, pending_help_len
    mov QWORD PTR arm_x2, rax
    ; str     x1, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCREATE:
    ; DCB "CREATE", 0
    DB "CREATE", 0
hl_XCREATE:
    ; DCB "CREATE ( 'name' -- ) create a word that pushes its data field", 0
    DB "CREATE ( 'name' -- ) create a word that pushes its data field", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCREATE:
    ; DCQ     nm_XCREATE, hl_XCREATE
    DQ OFFSET nm_XCREATE, OFFSET hl_XCREATE
    ; DCQ     0
    DQ 0
    ; DCQ     XCREATE, 0
    DQ OFFSET XCREATE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCREATE
    DQ OFFSET row_XCREATE
BOOTPTR ENDS
.CODE
XCREATE:
    ; sub     sp, sp, #96
    mov rax, rsp
    sub rax, 60h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _next_word
    lea rax, xret_14
    mov QWORD PTR arm_x30, rax
    jmp _next_word
    xret_14:
    ; cbz     x1, _create_fail
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _create_fail
    ; stp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; bl      _take_pending_help
    lea rax, xret_15
    mov QWORD PTR arm_x30, rax
    jmp _take_pending_help
    xret_15:
    ; ldp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; lea x4, DOVAR
    lea rax, DOVAR
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
    ; bl      _header_build
    lea rax, xret_16
    mov QWORD PTR arm_x30, rax
    jmp _header_build
    xret_16:
    ; lea x1, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x1, rax
    ; ldr     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0], #8
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    mov rax, QWORD PTR arm_x0
    add rax, 8
    mov QWORD PTR arm_x0, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_create_fail:
    ; lea x0, msg_huh_k1
    lea rax, msg_huh_k1
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_17
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_17:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSTATE:
    ; DCB "STATE", 0
    DB "STATE", 0
hl_XSTATE:
    ; DCB "STATE ( -- addr ) compilation state variable", 0
    DB "STATE ( -- addr ) compilation state variable", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSTATE:
    ; DCQ     nm_XSTATE, hl_XSTATE
    DQ OFFSET nm_XSTATE, OFFSET hl_XSTATE
    ; DCQ     0
    DQ 0
    ; DCQ     XSTATE, 0
    DQ OFFSET XSTATE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSTATE
    DQ OFFSET row_XSTATE
BOOTPTR ENDS
.CODE
XSTATE:
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XBASE:
    ; DCB "BASE", 0
    DB "BASE", 0
hl_XBASE:
    ; DCB "BASE ( -- addr ) current numeric base variable", 0
    DB "BASE ( -- addr ) current numeric base variable", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBASE:
    ; DCQ     nm_XBASE, hl_XBASE
    DQ OFFSET nm_XBASE, OFFSET hl_XBASE
    ; DCQ     0
    DQ 0
    ; DCQ     XBASE, XBASE_END
    DQ OFFSET XBASE, OFFSET XBASE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBASE
    DQ OFFSET row_XBASE
BOOTPTR ENDS
.CODE
XBASE:
    ; lea x0, base_var
    lea rax, base_var
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XBASE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XLAST:
    ; DCB "LAST", 0
    DB "LAST", 0
hl_XLAST:
    ; DCB "LAST ( -- xt ) CFA of most recently defined word", 0
    DB "LAST ( -- xt ) CFA of most recently defined word", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLAST:
    ; DCQ     nm_XLAST, hl_XLAST
    DQ OFFSET nm_XLAST, OFFSET hl_XLAST
    ; DCQ     0
    DQ 0
    ; DCQ     XLAST, 0
    DQ OFFSET XLAST, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLAST
    DQ OFFSET row_XLAST
BOOTPTR ENDS
.CODE
XLAST:
    ; lea x0, last_cfa
    lea rax, last_cfa
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XREGWID:
    ; DCB "(REGISTER-WID)", 0
    DB "(REGISTER-WID)", 0
hl_XREGWID:
    ; DCB "(REGISTER-WID) ( wid -- ) register a wordlist", 0
    DB "(REGISTER-WID) ( wid -- ) register a wordlist", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XREGWID:
    ; DCQ     nm_XREGWID, hl_XREGWID
    DQ OFFSET nm_XREGWID, OFFSET hl_XREGWID
    ; DCQ     0
    DQ 0
    ; DCQ     XREGWID, 0
    DQ OFFSET XREGWID, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XREGWID
    DQ OFFSET row_XREGWID
BOOTPTR ENDS
.CODE
XREGWID:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _wordlist_register
    lea rax, xret_18
    mov QWORD PTR arm_x30, rax
    jmp _wordlist_register
    xret_18:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_wordlist_register:
    ; lea x1, wordlist_reg_n
    lea rax, wordlist_reg_n
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; lea x3, wordlist_reg
    lea rax, wordlist_reg
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
_wreg_scan:
    ; cmp     x4, x2
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _wreg_add
    cmp BYTE PTR arm_c, 0
    jne _wreg_add
    ; ldr     x5, [x3, x4, lsl #3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; cmp     x5, x0
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _wreg_done
    cmp BYTE PTR arm_z, 0
    jne _wreg_done
    ; add     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; b       _wreg_scan
    jmp _wreg_scan
_wreg_add:
    ; cmp     x2, #32
    mov rax, QWORD PTR arm_x2
    cmp rax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _wreg_done
    cmp BYTE PTR arm_c, 0
    jne _wreg_done
    ; str     x0, [x3, x2, lsl #3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x2
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
    ; str     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
_wreg_done:
    ; ret
    jmp QWORD PTR arm_x30
BWSTR SEGMENT ALIGN(1) READ
nm_XGET_ORDER:
    ; DCB "GET-ORDER", 0
    DB "GET-ORDER", 0
hl_XGET_ORDER:
    ; DCB "GET-ORDER ( -- widn ... wid1 n ) copy search order", 0
    DB "GET-ORDER ( -- widn ... wid1 n ) copy search order", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XGET_ORDER:
    ; DCQ     nm_XGET_ORDER, hl_XGET_ORDER
    DQ OFFSET nm_XGET_ORDER, OFFSET hl_XGET_ORDER
    ; DCQ     0
    DQ 0
    ; DCQ     XGET_ORDER, 0
    DQ OFFSET XGET_ORDER, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XGET_ORDER
    DQ OFFSET row_XGET_ORDER
BOOTPTR ENDS
.CODE
XGET_ORDER:
    ; lea x0, search_order_n
    lea rax, search_order_n
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, search_order
    lea rax, search_order
    mov QWORD PTR arm_x2, rax
    ; mov     x3, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x3, rax
_get_ord_loop:
    ; cbz     x3, _get_ord_n
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    je _get_ord_n
    ; sub     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    sub rax, 1
    mov QWORD PTR arm_x3, rax
    ; ldr     x4, [x2, x3, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x4
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR arm_x20, rax
    ; b       _get_ord_loop
    jmp _get_ord_loop
_get_ord_n:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSET_ORDER:
    ; DCB "SET-ORDER", 0
    DB "SET-ORDER", 0
hl_XSET_ORDER:
    ; DCB "SET-ORDER ( widn ... wid1 n -- ) replace search order", 0
    DB "SET-ORDER ( widn ... wid1 n -- ) replace search order", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSET_ORDER:
    ; DCQ     nm_XSET_ORDER, hl_XSET_ORDER
    DQ OFFSET nm_XSET_ORDER, OFFSET hl_XSET_ORDER
    ; DCQ     0
    DQ 0
    ; DCQ     XSET_ORDER, 0
    DQ OFFSET XSET_ORDER, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSET_ORDER
    DQ OFFSET row_XSET_ORDER
BOOTPTR ENDS
.CODE
XSET_ORDER:
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cmn     x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.eq    XONLY
    cmp BYTE PTR arm_z, 0
    jne XONLY
    ; cmp     x1, #0
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lt    _set_ord_bad
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne _set_ord_bad
    ; cmp     x1, #8
    mov rax, QWORD PTR arm_x1
    cmp rax, 8
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _set_ord_bad
    cmp BYTE PTR arm_c, 0
    je xsk_19
    cmp BYTE PTR arm_z, 0
    je _set_ord_bad
    xsk_19:
    ; lea x0, search_order_n
    lea rax, search_order_n
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x2, search_order
    lea rax, search_order
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
_set_ord_loop:
    ; cmp     x3, x1
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _set_ord_bad
    cmp BYTE PTR arm_c, 0
    jne _set_ord_bad
    ; str     x20, [x2, x3, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _set_ord_loop
    jmp _set_ord_loop
_set_ord_bad:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XPUSH_ORDER:
    ; DCB "PUSH-ORDER", 0
    DB "PUSH-ORDER", 0
hl_XPUSH_ORDER:
    ; DCB "PUSH-ORDER ( wid -- ) prepend wid to search order", 0
    DB "PUSH-ORDER ( wid -- ) prepend wid to search order", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPUSH_ORDER:
    ; DCQ     nm_XPUSH_ORDER, hl_XPUSH_ORDER
    DQ OFFSET nm_XPUSH_ORDER, OFFSET hl_XPUSH_ORDER
    ; DCQ     0
    DQ 0
    ; DCQ     XPUSH_ORDER, 0
    DQ OFFSET XPUSH_ORDER, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPUSH_ORDER
    DQ OFFSET row_XPUSH_ORDER
BOOTPTR ENDS
.CODE
XPUSH_ORDER:
    ; lea x0, search_order_n
    lea rax, search_order_n
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, #8
    mov rax, QWORD PTR arm_x1
    cmp rax, 8
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _push_ord_drop
    cmp BYTE PTR arm_c, 0
    jne _push_ord_drop
    ; lea x2, search_order
    lea rax, search_order
    mov QWORD PTR arm_x2, rax
    ; mov     x3, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x3, rax
_push_ord_shift:
    ; cbz     x3, _push_ord_store
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    je _push_ord_store
    ; sub     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    sub rax, 1
    mov QWORD PTR arm_x3, rax
    ; ldr     x4, [x2, x3, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; add     x5, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x5, rax
    ; str     x4, [x2, x5, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x5
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10], rax
    ; b       _push_ord_shift
    jmp _push_ord_shift
_push_ord_store:
    ; str     x20, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
_push_ord_drop:
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XDEFINITIONS:
    ; DCB "DEFINITIONS", 0
    DB "DEFINITIONS", 0
hl_XDEFINITIONS:
    ; DCB "DEFINITIONS ( -- ) CURRENT = first in search order", 0
    DB "DEFINITIONS ( -- ) CURRENT = first in search order", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDEFINITIONS:
    ; DCQ     nm_XDEFINITIONS, hl_XDEFINITIONS
    DQ OFFSET nm_XDEFINITIONS, OFFSET hl_XDEFINITIONS
    ; DCQ     0
    DQ 0
    ; DCQ     XDEFINITIONS, 0
    DQ OFFSET XDEFINITIONS, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDEFINITIONS
    DQ OFFSET row_XDEFINITIONS
BOOTPTR ENDS
.CODE
XDEFINITIONS:
    ; lea x0, search_order_n
    lea rax, search_order_n
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _def_done
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _def_done
    ; lea x1, search_order
    lea rax, search_order
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x0, current_var
    lea rax, current_var
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
_def_done:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XONLY:
    ; DCB "ONLY", 0
    DB "ONLY", 0
hl_XONLY:
    ; DCB "ONLY ( -- ) search order = FORTH only", 0
    DB "ONLY ( -- ) search order = FORTH only", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XONLY:
    ; DCQ     nm_XONLY, hl_XONLY
    DQ OFFSET nm_XONLY, OFFSET hl_XONLY
    ; DCQ     0
    DQ 0
    ; DCQ     XONLY, 0
    DQ OFFSET XONLY, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XONLY
    DQ OFFSET row_XONLY
BOOTPTR ENDS
.CODE
XONLY:
    ; lea x0, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x0, rax
    ; lea x1, search_order
    lea rax, search_order
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; lea x1, search_order_n
    lea rax, search_order_n
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XFORTH:
    ; DCB "FORTH", 0
    DB "FORTH", 0
hl_XFORTH:
    ; DCB "FORTH ( -- ) set first search-order entry to FORTH", 0
    DB "FORTH ( -- ) set first search-order entry to FORTH", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFORTH:
    ; DCQ     nm_XFORTH, hl_XFORTH
    DQ OFFSET nm_XFORTH, OFFSET hl_XFORTH
    ; DCQ     0
    DQ 0
    ; DCQ     XFORTH, 0
    DQ OFFSET XFORTH, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFORTH
    DQ OFFSET row_XFORTH
BOOTPTR ENDS
.CODE
XFORTH:
    ; lea x0, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x0, rax
    ; lea x1, search_order
    lea rax, search_order
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x1, search_order_n
    lea rax, search_order_n
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbnz    x2, _forth_done
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    jne _forth_done
    ; mov     x2, #1
    mov rax, 1
    mov QWORD PTR arm_x2, rax
    ; str     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
_forth_done:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCURRENT:
    ; DCB "CURRENT", 0
    DB "CURRENT", 0
hl_XCURRENT:
    ; DCB "CURRENT ( -- addr ) compilation wordlist variable", 0
    DB "CURRENT ( -- addr ) compilation wordlist variable", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCURRENT:
    ; DCQ     nm_XCURRENT, hl_XCURRENT
    DQ OFFSET nm_XCURRENT, OFFSET hl_XCURRENT
    ; DCQ     0
    DQ 0
    ; DCQ     XCURRENT, 0
    DQ OFFSET XCURRENT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCURRENT
    DQ OFFSET row_XCURRENT
BOOTPTR ENDS
.CODE
XCURRENT:
    ; lea x0, current_var
    lea rax, current_var
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XGET_CURRENT:
    ; DCB "GET-CURRENT", 0
    DB "GET-CURRENT", 0
hl_XGET_CURRENT:
    ; DCB "GET-CURRENT ( -- wid ) wid of the compilation wordlist", 0
    DB "GET-CURRENT ( -- wid ) wid of the compilation wordlist", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XGET_CURRENT:
    ; DCQ     nm_XGET_CURRENT, hl_XGET_CURRENT
    DQ OFFSET nm_XGET_CURRENT, OFFSET hl_XGET_CURRENT
    ; DCQ     0
    DQ 0
    ; DCQ     XGET_CURRENT, 0
    DQ OFFSET XGET_CURRENT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XGET_CURRENT
    DQ OFFSET row_XGET_CURRENT
BOOTPTR ENDS
.CODE
XGET_CURRENT:
    ; lea x0, current_var
    lea rax, current_var
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSET_CURRENT:
    ; DCB "SET-CURRENT", 0
    DB "SET-CURRENT", 0
hl_XSET_CURRENT:
    ; DCB "SET-CURRENT ( wid -- ) set the compilation wordlist", 0
    DB "SET-CURRENT ( wid -- ) set the compilation wordlist", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSET_CURRENT:
    ; DCQ     nm_XSET_CURRENT, hl_XSET_CURRENT
    DQ OFFSET nm_XSET_CURRENT, OFFSET hl_XSET_CURRENT
    ; DCQ     0
    DQ 0
    ; DCQ     XSET_CURRENT, 0
    DQ OFFSET XSET_CURRENT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSET_CURRENT
    DQ OFFSET row_XSET_CURRENT
BOOTPTR ENDS
.CODE
XSET_CURRENT:
    ; lea x0, current_var
    lea rax, current_var
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XWORDLIST:
    ; DCB "WORDLIST", 0
    DB "WORDLIST", 0
hl_XWORDLIST:
    ; DCB "WORDLIST ( -- wid ) create empty word list", 0
    DB "WORDLIST ( -- wid ) create empty word list", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XWORDLIST:
    ; DCQ     nm_XWORDLIST, hl_XWORDLIST
    DQ OFFSET nm_XWORDLIST, OFFSET hl_XWORDLIST
    ; DCQ     0
    DQ 0
    ; DCQ     XWORDLIST, 0
    DQ OFFSET XWORDLIST, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XWORDLIST
    DQ OFFSET row_XWORDLIST
BOOTPTR ENDS
.CODE
XWORDLIST:
    ; lea x0, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; add     x1, x1, #7
    mov rax, QWORD PTR arm_x1
    add rax, 7
    mov QWORD PTR arm_x1, rax
    ; bic     x1, x1, #7
    mov rax, QWORD PTR arm_x1
    mov rcx, 7
    not rcx
    and rax, rcx
    mov QWORD PTR arm_x1, rax
    ; add     x3, x1, #128
    mov rax, QWORD PTR arm_x1
    add rax, 80h
    mov QWORD PTR arm_x3, rax
    ; lea x4, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR arm_x4, rax
    ; cmp     x3, x4
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x4
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _allot_fail
    cmp BYTE PTR arm_c, 0
    je _allot_fail
    ; lea x5, user_dict_size_cell
    lea rax, user_dict_size_cell
    mov QWORD PTR arm_x5, rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR arm_x5
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; add     x5, x4, x5
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x5
    add rax, rcx
    mov QWORD PTR arm_x5, rax
    ; cmp     x3, x5
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _allot_fail
    cmp BYTE PTR arm_c, 0
    je xsk_20
    cmp BYTE PTR arm_z, 0
    je _allot_fail
    xsk_20:
    ; mov     x2, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x2, rax
    ; mov     x5, #16
    mov rax, 10h
    mov QWORD PTR arm_x5, rax
_wl_zero:
    ; str     xzr, [x1], #8
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    mov rax, QWORD PTR arm_x1
    add rax, 8
    mov QWORD PTR arm_x1, rax
    ; subs    x5, x5, #1
    mov rax, QWORD PTR arm_x5
    sub rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x5, rax
    ; b.ne    _wl_zero
    cmp BYTE PTR arm_z, 0
    je _wl_zero
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _wordlist_register
    lea rax, xret_21
    mov QWORD PTR arm_x30, rax
    jmp _wordlist_register
    xret_21:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XPREVIOUS:
    ; DCB "PREVIOUS", 0
    DB "PREVIOUS", 0
hl_XPREVIOUS:
    ; DCB "PREVIOUS ( -- ) drop first search-order entry", 0
    DB "PREVIOUS ( -- ) drop first search-order entry", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPREVIOUS:
    ; DCQ     nm_XPREVIOUS, hl_XPREVIOUS
    DQ OFFSET nm_XPREVIOUS, OFFSET hl_XPREVIOUS
    ; DCQ     0
    DQ 0
    ; DCQ     XPREVIOUS, 0
    DQ OFFSET XPREVIOUS, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPREVIOUS
    DQ OFFSET row_XPREVIOUS
BOOTPTR ENDS
.CODE
XPREVIOUS:
    ; lea x0, search_order_n
    lea rax, search_order_n
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, #1
    mov rax, QWORD PTR arm_x1
    cmp rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _prev_done
    cmp BYTE PTR arm_c, 0
    je _prev_done
    cmp BYTE PTR arm_z, 0
    jne _prev_done
    ; lea x2, search_order
    lea rax, search_order
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
_prev_shift:
    ; add     x4, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; cmp     x4, x1
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _prev_store
    cmp BYTE PTR arm_c, 0
    jne _prev_store
    ; ldr     x5, [x2, x4, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x4
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; str     x5, [x2, x3, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10], rax
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _prev_shift
    jmp _prev_shift
_prev_store:
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
_prev_done:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XORDER:
    ; DCB "ORDER", 0
    DB "ORDER", 0
hl_XORDER:
    ; DCB "ORDER ( -- ) print search order and CURRENT", 0
    DB "ORDER ( -- ) print search order and CURRENT", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XORDER:
    ; DCQ     nm_XORDER, hl_XORDER
    DQ OFFSET nm_XORDER, OFFSET hl_XORDER
    ; DCQ     0
    DQ 0
    ; DCQ     XORDER, 0
    DQ OFFSET XORDER, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XORDER
    DQ OFFSET row_XORDER
BOOTPTR ENDS
.CODE
XORDER:
    ; sub     sp, sp, #80
    mov rax, rsp
    sub rax, 50h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; lea x0, str_search_order
    lea rax, str_search_order
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_22
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_22:
    ; lea x0, search_order_n
    lea rax, search_order_n
    mov QWORD PTR arm_x0, rax
    ; ldr     x19, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    ; lea x20, search_order
    lea rax, search_order
    mov QWORD PTR arm_x20, rax
    ; mov     x21, #0
    mov rax, 0
    mov QWORD PTR arm_x21, rax
_ord_loop:
    ; cmp     x21, x19
    mov rax, QWORD PTR arm_x21
    mov rcx, QWORD PTR arm_x19
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _ord_nl
    cmp BYTE PTR arm_c, 0
    jne _ord_nl
    ; ldr     x0, [x20, x21, lsl #3]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR arm_x21
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _print_wid_name
    lea rax, xret_23
    mov QWORD PTR arm_x30, rax
    jmp _print_wid_name
    xret_23:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_24
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_24:
    ; add     x21, x21, #1
    mov rax, QWORD PTR arm_x21
    add rax, 1
    mov QWORD PTR arm_x21, rax
    ; b       _ord_loop
    jmp _ord_loop
_ord_nl:
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_25
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_25:
    ; lea x0, str_comp_wl
    lea rax, str_comp_wl
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_26
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_26:
    ; lea x0, current_var
    lea rax, current_var
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _print_wid_name
    lea rax, xret_27
    mov QWORD PTR arm_x30, rax
    jmp _print_wid_name
    xret_27:
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_28
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_28:
    ; ldp     x21, x22, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    ; ldp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #80
    mov rax, rsp
    add rax, 50h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCELL:
    ; DCB "CELL", 0
    DB "CELL", 0
hl_XCELL:
    ; DCB "CELL ( -- n ) address unit size in bytes", 0
    DB "CELL ( -- n ) address unit size in bytes", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCELL:
    ; DCQ     nm_XCELL, hl_XCELL
    DQ OFFSET nm_XCELL, OFFSET hl_XCELL
    ; DCQ     0
    DQ 0
    ; DCQ     XCELL, XCELL_END
    DQ OFFSET XCELL, OFFSET XCELL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCELL
    DQ OFFSET row_XCELL
BOOTPTR ENDS
.CODE
XCELL:
    ; mov     x0, #8
    mov rax, 8
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XCELL_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCELLS:
    ; DCB "CELLS", 0
    DB "CELLS", 0
hl_XCELLS:
    ; DCB "CELLS ( n -- n ) cells to address units", 0
    DB "CELLS ( n -- n ) cells to address units", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCELLS:
    ; DCQ     nm_XCELLS, hl_XCELLS
    DQ OFFSET nm_XCELLS, OFFSET hl_XCELLS
    ; DCQ     0
    DQ 0
    ; DCQ     XCELLS, XCELLS_END
    DQ OFFSET XCELLS, OFFSET XCELLS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCELLS
    DQ OFFSET row_XCELLS
BOOTPTR ENDS
.CODE
XCELLS:
    ; lsl     x20, x20, #3
    mov rax, QWORD PTR arm_x20
    shl rax, 3
    mov QWORD PTR arm_x20, rax
XCELLS_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XDEPTH:
    ; DCB "DEPTH", 0
    DB "DEPTH", 0
hl_XDEPTH:
    ; DCB "DEPTH ( -- +n ) data stack depth in cells", 0
    DB "DEPTH ( -- +n ) data stack depth in cells", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDEPTH:
    ; DCQ     nm_XDEPTH, hl_XDEPTH
    DQ OFFSET nm_XDEPTH, OFFSET hl_XDEPTH
    ; DCQ     0
    DQ 0
    ; DCQ     XDEPTH, XDEPTH_END
    DQ OFFSET XDEPTH, OFFSET XDEPTH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDEPTH
    DQ OFFSET row_XDEPTH
BOOTPTR ENDS
.CODE
XDEPTH:
    ; lea x1, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x1, rax
    ; add     x0, x1, #1, lsl #12
    mov rax, QWORD PTR arm_x1
    add rax, 1000h
    mov QWORD PTR arm_x0, rax
    ; cmp     x22, x0
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _depth_fix
    cmp BYTE PTR arm_c, 0
    je xsk_29
    cmp BYTE PTR arm_z, 0
    je _depth_fix
    xsk_29:
    ; cmp     x22, x1
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _depth_fix
    cmp BYTE PTR arm_c, 0
    je _depth_fix
    ; b       _depth_n
    jmp _depth_n
_depth_fix:
    ; mov     x22, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x22, rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
_depth_n:
    ; sub     x0, x0, x22
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x22
    sub rax, rcx
    mov QWORD PTR arm_x0, rax
    ; lsr     x0, x0, #3
    mov rax, QWORD PTR arm_x0
    shr rax, 3
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XDEPTH_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCLEARSTACK:
    ; DCB "CLEARSTACK", 0
    DB "CLEARSTACK", 0
hl_XCLEARSTACK:
    ; DCB "CLEARSTACK ( -- ) empty the data stack", 0
    DB "CLEARSTACK ( -- ) empty the data stack", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCLEARSTACK:
    ; DCQ     nm_XCLEARSTACK, hl_XCLEARSTACK
    DQ OFFSET nm_XCLEARSTACK, OFFSET hl_XCLEARSTACK
    ; DCQ     0
    DQ 0
    ; DCQ     XCLEARSTACK, XCLEARSTACK_END
    DQ OFFSET XCLEARSTACK, OFFSET XCLEARSTACK_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCLEARSTACK
    DQ OFFSET row_XCLEARSTACK
BOOTPTR ENDS
.CODE
XCLEARSTACK:
    ; lea x22, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x22, rax
    ; add     x22, x22, #1, lsl #12
    mov rax, QWORD PTR arm_x22
    add rax, 1000h
    mov QWORD PTR arm_x22, rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XCLEARSTACK_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSP0:
    ; DCB "SP0", 0
    DB "SP0", 0
hl_XSP0:
    ; DCB "SP0 ( -- addr ) empty data-stack pointer", 0
    DB "SP0 ( -- addr ) empty data-stack pointer", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSP0:
    ; DCQ     nm_XSP0, hl_XSP0
    DQ OFFSET nm_XSP0, OFFSET hl_XSP0
    ; DCQ     0
    DQ 0
    ; DCQ     XSP0, XSP0_END
    DQ OFFSET XSP0, OFFSET XSP0_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSP0
    DQ OFFSET row_XSP0
BOOTPTR ENDS
.CODE
XSP0:
    ; lea x1, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x1, rax
    ; add     x0, x1, #1, lsl #12
    mov rax, QWORD PTR arm_x1
    add rax, 1000h
    mov QWORD PTR arm_x0, rax
    ; cmp     x22, x0
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _sp0_fix
    cmp BYTE PTR arm_c, 0
    je xsk_30
    cmp BYTE PTR arm_z, 0
    je _sp0_fix
    xsk_30:
    ; cmp     x22, x1
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _sp0_fix
    cmp BYTE PTR arm_c, 0
    je _sp0_fix
    ; b       _sp0_push
    jmp _sp0_push
_sp0_fix:
    ; mov     x22, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x22, rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
_sp0_push:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XSP0_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSPFETCH:
    ; DCB "SP@", 0
    DB "SP@", 0
hl_XSPFETCH:
    ; DCB "SP@ ( -- addr ) current data-stack pointer under TOS", 0
    DB "SP@ ( -- addr ) current data-stack pointer under TOS", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSPFETCH:
    ; DCQ     nm_XSPFETCH, hl_XSPFETCH
    DQ OFFSET nm_XSPFETCH, OFFSET hl_XSPFETCH
    ; DCQ     0
    DQ 0
    ; DCQ     XSPFETCH, XSPFETCH_END
    DQ OFFSET XSPFETCH, OFFSET XSPFETCH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSPFETCH
    DQ OFFSET row_XSPFETCH
BOOTPTR ENDS
.CODE
XSPFETCH:
    ; mov     x0, x22
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XSPFETCH_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSPSTORE:
    ; DCB "SP!", 0
    DB "SP!", 0
hl_XSPSTORE:
    ; DCB "SP! ( addr -- ) set the data-stack pointer", 0
    DB "SP! ( addr -- ) set the data-stack pointer", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSPSTORE:
    ; DCQ     nm_XSPSTORE, hl_XSPSTORE
    DQ OFFSET nm_XSPSTORE, OFFSET hl_XSPSTORE
    ; DCQ     0
    DQ 0
    ; DCQ     XSPSTORE, XSPSTORE_END
    DQ OFFSET XSPSTORE, OFFSET XSPSTORE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSPSTORE
    DQ OFFSET row_XSPSTORE
BOOTPTR ENDS
.CODE
XSPSTORE:
    ; mov     x22, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x22, rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XSPSTORE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XDICT_THREADS:
    ; DCB "DICT-THREADS", 0
    DB "DICT-THREADS", 0
hl_XDICT_THREADS:
    ; DCB "DICT-THREADS ( -- n ) hash threads per wordlist", 0
    DB "DICT-THREADS ( -- n ) hash threads per wordlist", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDICT_THREADS:
    ; DCQ     nm_XDICT_THREADS, hl_XDICT_THREADS
    DQ OFFSET nm_XDICT_THREADS, OFFSET hl_XDICT_THREADS
    ; DCQ     0
    DQ 0
    ; DCQ     XDICT_THREADS, 0
    DQ OFFSET XDICT_THREADS, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDICT_THREADS
    DQ OFFSET row_XDICT_THREADS
BOOTPTR ENDS
.CODE
XDICT_THREADS:
    ; mov     x0, #16
    mov rax, 10h
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XBRACKET_TICK:
    ; DCB "[']", 0
    DB "[']", 0
hl_XBRACKET_TICK:
    ; DCB "['] ( -- xt ) compile xt of next name", 0
    DB "['] ( -- xt ) compile xt of next name", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBRACKET_TICK:
    ; DCQ     nm_XBRACKET_TICK, hl_XBRACKET_TICK
    DQ OFFSET nm_XBRACKET_TICK, OFFSET hl_XBRACKET_TICK
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XBRACKET_TICK, 0
    DQ OFFSET XBRACKET_TICK, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBRACKET_TICK
    DQ OFFSET row_XBRACKET_TICK
BOOTPTR ENDS
.CODE
XBRACKET_TICK:
    ; sub     sp, sp, #96
    mov rax, rsp
    sub rax, 60h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _next_word
    lea rax, xret_31
    mov QWORD PTR arm_x30, rax
    jmp _next_word
    xret_31:
    ; cbz     x1, _btick_fail
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _btick_fail
    ; stp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; bl      _find_word
    lea rax, xret_32
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_32:
    ; cbz     x0, _btick_fail
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _btick_fail
    ; str     x0, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x1, state_var
    lea rax, state_var
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _btick_interp
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _btick_interp
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_33
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_33:
    ; ldr     x0, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_34
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_34:
    ; b       _btick_leave
    jmp _btick_leave
_btick_interp:
    ; ldr     x0, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
_btick_leave:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_btick_fail:
    ; lea x0, msg_huh_k1
    lea rax, msg_huh_k1
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_35
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_35:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; b       _quit_exit
    jmp _quit_exit
BWSTR SEGMENT ALIGN(1) READ
nm_XLIT_ADDR:
    ; DCB "LIT-ADDR", 0
    DB "LIT-ADDR", 0
hl_XLIT_ADDR:
    ; DCB "LIT-ADDR ( -- xt ) xt of LIT", 0
    DB "LIT-ADDR ( -- xt ) xt of LIT", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLIT_ADDR:
    ; DCQ     nm_XLIT_ADDR, hl_XLIT_ADDR
    DQ OFFSET nm_XLIT_ADDR, OFFSET hl_XLIT_ADDR
    ; DCQ     0
    DQ 0
    ; DCQ     XLIT_ADDR, 0
    DQ OFFSET XLIT_ADDR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLIT_ADDR
    DQ OFFSET row_XLIT_ADDR
BOOTPTR ENDS
.CODE
XLIT_ADDR:
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_X0BRANCH_ADDR:
    ; DCB "0BRANCH-ADDR", 0
    DB "0BRANCH-ADDR", 0
hl_X0BRANCH_ADDR:
    ; DCB "0BRANCH-ADDR ( -- xt ) xt of 0BRANCH", 0
    DB "0BRANCH-ADDR ( -- xt ) xt of 0BRANCH", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_X0BRANCH_ADDR:
    ; DCQ     nm_X0BRANCH_ADDR, hl_X0BRANCH_ADDR
    DQ OFFSET nm_X0BRANCH_ADDR, OFFSET hl_X0BRANCH_ADDR
    ; DCQ     0
    DQ 0
    ; DCQ     X0BRANCH_ADDR, 0
    DQ OFFSET X0BRANCH_ADDR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_X0BRANCH_ADDR
    DQ OFFSET row_X0BRANCH_ADDR
BOOTPTR ENDS
.CODE
X0BRANCH_ADDR:
    ; lea x0, cfa_0branch
    lea rax, cfa_0branch
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XBRANCH_ADDR:
    ; DCB "BRANCH-ADDR", 0
    DB "BRANCH-ADDR", 0
hl_XBRANCH_ADDR:
    ; DCB "BRANCH-ADDR ( -- xt ) xt of BRANCH", 0
    DB "BRANCH-ADDR ( -- xt ) xt of BRANCH", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBRANCH_ADDR:
    ; DCQ     nm_XBRANCH_ADDR, hl_XBRANCH_ADDR
    DQ OFFSET nm_XBRANCH_ADDR, OFFSET hl_XBRANCH_ADDR
    ; DCQ     0
    DQ 0
    ; DCQ     XBRANCH_ADDR, 0
    DQ OFFSET XBRANCH_ADDR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBRANCH_ADDR
    DQ OFFSET row_XBRANCH_ADDR
BOOTPTR ENDS
.CODE
XBRANCH_ADDR:
    ; lea x0, cfa_branch
    lea rax, cfa_branch
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XDOCOL_ADDR:
    ; DCB "DOCOL-ADDR", 0
    DB "DOCOL-ADDR", 0
hl_XDOCOL_ADDR:
    ; DCB "DOCOL-ADDR ( -- addr ) address of DOCOL code", 0
    DB "DOCOL-ADDR ( -- addr ) address of DOCOL code", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDOCOL_ADDR:
    ; DCQ     nm_XDOCOL_ADDR, hl_XDOCOL_ADDR
    DQ OFFSET nm_XDOCOL_ADDR, OFFSET hl_XDOCOL_ADDR
    ; DCQ     0
    DQ 0
    ; DCQ     XDOCOL_ADDR, 0
    DQ OFFSET XDOCOL_ADDR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDOCOL_ADDR
    DQ OFFSET row_XDOCOL_ADDR
BOOTPTR ENDS
.CODE
XDOCOL_ADDR:
    ; lea x0, DOCOL
    lea rax, DOCOL
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XDOCON_ADDR:
    ; DCB "DOCON-ADDR", 0
    DB "DOCON-ADDR", 0
hl_XDOCON_ADDR:
    ; DCB "DOCON-ADDR ( -- addr ) address of DOCON code", 0
    DB "DOCON-ADDR ( -- addr ) address of DOCON code", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDOCON_ADDR:
    ; DCQ     nm_XDOCON_ADDR, hl_XDOCON_ADDR
    DQ OFFSET nm_XDOCON_ADDR, OFFSET hl_XDOCON_ADDR
    ; DCQ     0
    DQ 0
    ; DCQ     XDOCON_ADDR, 0
    DQ OFFSET XDOCON_ADDR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDOCON_ADDR
    DQ OFFSET row_XDOCON_ADDR
BOOTPTR ENDS
.CODE
XDOCON_ADDR:
    ; lea x0, DOCON
    lea rax, DOCON
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XBranch:
    ; DCB "BRANCH", 0
    DB "BRANCH", 0
hl_XBranch:
    ; DCB "BRANCH ( -- ) unconditional branch", 0
    DB "BRANCH ( -- ) unconditional branch", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBranch:
    ; DCQ     nm_XBranch, hl_XBranch
    DQ OFFSET nm_XBranch, OFFSET hl_XBranch
    ; DCQ     0
    DQ 0
    ; DCQ     XBranch, XBranch_END
    DQ OFFSET XBranch, OFFSET XBranch_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBranch
    DQ OFFSET row_XBranch
BOOTPTR ENDS
.CODE
XBranch:
    ; ldr     x0, [x19]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; add     x19, x19, x0
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x0
    add rax, rcx
    mov QWORD PTR arm_x19, rax
XBranch_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_X0Branch:
    ; DCB "0BRANCH", 0
    DB "0BRANCH", 0
hl_X0Branch:
    ; DCB "0BRANCH ( flag -- ) branch if zero", 0
    DB "0BRANCH ( flag -- ) branch if zero", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_X0Branch:
    ; DCQ     nm_X0Branch, hl_X0Branch
    DQ OFFSET nm_X0Branch, OFFSET hl_X0Branch
    ; DCQ     0
    DQ 0
    ; DCQ     X0Branch, X0Branch_END
    DQ OFFSET X0Branch, OFFSET X0Branch_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_X0Branch
    DQ OFFSET row_X0Branch
BOOTPTR ENDS
.CODE
X0Branch:
    ; lea x1, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x1, rax
    ; add     x1, x1, #1, lsl #12
    mov rax, QWORD PTR arm_x1
    add rax, 1000h
    mov QWORD PTR arm_x1, rax
    ; cbz     x20, _0br_true
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    je _0br_true
    ; cmp     x22, x1
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _0br_empty_skip
    cmp BYTE PTR arm_c, 0
    jne _0br_empty_skip
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; b       _0br_skip
    jmp _0br_skip
_0br_empty_skip:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
    ; mov     x22, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x22, rax
_0br_skip:
    ; add     x19, x19, #8
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_0br_true:
    ; cmp     x22, x1
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _0br_empty_take
    cmp BYTE PTR arm_c, 0
    jne _0br_empty_take
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; b       _0br_take
    jmp _0br_take
_0br_empty_take:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
    ; mov     x22, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x22, rax
_0br_take:
    ; ldr     x0, [x19]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; add     x19, x19, x0
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x0
    add rax, rcx
    mov QWORD PTR arm_x19, rax
X0Branch_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_DOVAR:
    ; DCB "(DOVAR)", 0
    DB "(DOVAR)", 0
hl_DOVAR:
    ; DCB "(DOVAR) CREATE/VARIABLE runtime", 0
    DB "(DOVAR) CREATE/VARIABLE runtime", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_DOVAR:
    ; DCQ     nm_DOVAR, hl_DOVAR
    DQ OFFSET nm_DOVAR, OFFSET hl_DOVAR
    ; DCQ     0
    DQ 0
    ; DCQ     DOVAR, DOVAR_END
    DQ OFFSET DOVAR, OFFSET DOVAR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_DOVAR
    DQ OFFSET row_DOVAR
BOOTPTR ENDS
.CODE
DOVAR:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; add     x20, x21, #16
    mov rax, QWORD PTR arm_x21
    add rax, 10h
    mov QWORD PTR arm_x20, rax
DOVAR_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_DOCON:
    ; DCB "(DOCON)", 0
    DB "(DOCON)", 0
hl_DOCON:
    ; DCB "(DOCON) CONSTANT runtime", 0
    DB "(DOCON) CONSTANT runtime", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_DOCON:
    ; DCQ     nm_DOCON, hl_DOCON
    DQ OFFSET nm_DOCON, OFFSET hl_DOCON
    ; DCQ     0
    DQ 0
    ; DCQ     DOCON, DOCON_END
    DQ OFFSET DOCON, OFFSET DOCON_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_DOCON
    DQ OFFSET row_DOCON
BOOTPTR ENDS
.CODE
DOCON:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x21, #16]
    mov r10, QWORD PTR arm_x21
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
DOCON_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_DODOES:
    ; DCB "(DODOES)", 0
    DB "(DODOES)", 0
hl_DODOES:
    ; DCB "(DODOES) DOES> runtime", 0
    DB "(DODOES) DOES> runtime", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_DODOES:
    ; DCQ     nm_DODOES, hl_DODOES
    DQ OFFSET nm_DODOES, OFFSET hl_DODOES
    ; DCQ     0
    DQ 0
    ; DCQ     DODOES, DODOES_END
    DQ OFFSET DODOES, OFFSET DODOES_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_DODOES
    DQ OFFSET row_DODOES
BOOTPTR ENDS
.CODE
DODOES:
    ; str     x19, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10], rax
    ; ldr     x19, [x21, #8]
    mov r10, QWORD PTR arm_x21
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    ; add     x0, x21, #16
    mov rax, QWORD PTR arm_x21
    add rax, 10h
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
DODOES_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XDO_RT:
    ; DCB "(DO)", 0
    DB "(DO)", 0
hl_XDO_RT:
    ; DCB "(DO) ( limit start -- ) runtime for DO", 0
    DB "(DO) ( limit start -- ) runtime for DO", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDO_RT:
    ; DCQ     nm_XDO_RT, hl_XDO_RT
    DQ OFFSET nm_XDO_RT, OFFSET hl_XDO_RT
    ; DCQ     0
    DQ 0
    ; DCQ     XDO_RT, XDO_RT_END
    DQ OFFSET XDO_RT, OFFSET XDO_RT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDO_RT
    DQ OFFSET row_XDO_RT
BOOTPTR ENDS
.CODE
XDO_RT:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; str     x0, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; str     x20, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
XDO_RT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XQDO_RT:
    ; DCB "(?DO)", 0
    DB "(?DO)", 0
hl_XQDO_RT:
    ; DCB "(?DO) ( limit start -- ) runtime for ?DO", 0
    DB "(?DO) ( limit start -- ) runtime for ?DO", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XQDO_RT:
    ; DCQ     nm_XQDO_RT, hl_XQDO_RT
    DQ OFFSET nm_XQDO_RT, OFFSET hl_XQDO_RT
    ; DCQ     0
    DQ 0
    ; DCQ     XQDO_RT, XQDO_RT_END
    DQ OFFSET XQDO_RT, OFFSET XQDO_RT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XQDO_RT
    DQ OFFSET row_XQDO_RT
BOOTPTR ENDS
.CODE
XQDO_RT:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cmp     x20, x0
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _qdo_skip
    cmp BYTE PTR arm_z, 0
    jne _qdo_skip
    ; str     x0, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; str     x20, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; add     x19, x19, #8
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_qdo_skip:
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x0, [x19]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; add     x19, x19, x0
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x0
    add rax, rcx
    mov QWORD PTR arm_x19, rax
XQDO_RT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XLOOP_RT:
    ; DCB "(LOOP)", 0
    DB "(LOOP)", 0
hl_XLOOP_RT:
    ; DCB "(LOOP) ( -- ) runtime for LOOP", 0
    DB "(LOOP) ( -- ) runtime for LOOP", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOOP_RT:
    ; DCQ     nm_XLOOP_RT, hl_XLOOP_RT
    DQ OFFSET nm_XLOOP_RT, OFFSET hl_XLOOP_RT
    ; DCQ     0
    DQ 0
    ; DCQ     XLOOP_RT, XLOOP_RT_END
    DQ OFFSET XLOOP_RT, OFFSET XLOOP_RT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOOP_RT
    DQ OFFSET row_XLOOP_RT
BOOTPTR ENDS
.CODE
XLOOP_RT:
    ; ldr     x0, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; ldr     x1, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ge    _loop_done
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _loop_done
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _loop_done
    cmp BYTE PTR arm_z, 0
    jne _loop_done
    ; str     x1, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; str     x0, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldr     x2, [x19]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; add     x19, x19, x2
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x19, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_loop_done:
    ; add     x19, x19, #8
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
XLOOP_RT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XPLUSLOOP_RT:
    ; DCB "(+LOOP)", 0
    DB "(+LOOP)", 0
hl_XPLUSLOOP_RT:
    ; DCB "(+LOOP) ( n -- ) runtime for +LOOP", 0
    DB "(+LOOP) ( n -- ) runtime for +LOOP", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPLUSLOOP_RT:
    ; DCQ     nm_XPLUSLOOP_RT, hl_XPLUSLOOP_RT
    DQ OFFSET nm_XPLUSLOOP_RT, OFFSET hl_XPLUSLOOP_RT
    ; DCQ     0
    DQ 0
    ; DCQ     XPLUSLOOP_RT, XPLUSLOOP_RT_END
    DQ OFFSET XPLUSLOOP_RT, OFFSET XPLUSLOOP_RT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPLUSLOOP_RT
    DQ OFFSET row_XPLUSLOOP_RT
BOOTPTR ENDS
.CODE
XPLUSLOOP_RT:
    ; ldr     x0, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; ldr     x1, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; mov     x2, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x2, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; sub     x3, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    sub rax, rcx
    mov QWORD PTR arm_x3, rax
    ; add     x4, x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x4, rax
    ; eor     x5, x3, x4
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x4
    xor rax, rcx
    mov QWORD PTR arm_x5, rax
    ; eor     x6, x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    xor rax, rcx
    mov QWORD PTR arm_x6, rax
    ; ands    x5, x5, x6
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x6
    and rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    mov QWORD PTR arm_x5, rax
    ; b.mi    _pl_done
    cmp BYTE PTR arm_n, 0
    jne _pl_done
    ; add     x0, x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; str     x0, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldr     x2, [x19]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; add     x19, x19, x2
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x19, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_pl_done:
    ; add     x19, x19, #8
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
XPLUSLOOP_RT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XDOES_RT:
    ; DCB "(DOES>)", 0
    DB "(DOES>)", 0
hl_XDOES_RT:
    ; DCB "(DOES>) ( -- ) patch latest CREATE word and return", 0
    DB "(DOES>) ( -- ) patch latest CREATE word and return", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDOES_RT:
    ; DCQ     nm_XDOES_RT, hl_XDOES_RT
    DQ OFFSET nm_XDOES_RT, OFFSET hl_XDOES_RT
    ; DCQ     0
    DQ 0
    ; DCQ     XDOES_RT, XDOES_RT_END
    DQ OFFSET XDOES_RT, OFFSET XDOES_RT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDOES_RT
    DQ OFFSET row_XDOES_RT
BOOTPTR ENDS
.CODE
XDOES_RT:
    ; lea x0, last_cfa
    lea rax, last_cfa
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _xdoes_ret
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _xdoes_ret
    ; lea x1, DODOES
    lea rax, DODOES
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; str     x19, [x0, #8]
    mov r10, QWORD PTR arm_x0
    add r10, 8
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10], rax
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _nfa_reveal_cfa
    lea rax, xret_36
    mov QWORD PTR arm_x30, rax
    jmp _nfa_reveal_cfa
    xret_36:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
_xdoes_ret:
    ; ldr     x19, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
XDOES_RT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XDOES:
    ; DCB "DOES>", 0
    DB "DOES>", 0
hl_XDOES:
    ; DCB "DOES> ( -- ) modify last CREATE'd word (immediate)", 0
    DB "DOES> ( -- ) modify last CREATE'd word (immediate)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDOES:
    ; DCQ     nm_XDOES, hl_XDOES
    DQ OFFSET nm_XDOES, OFFSET hl_XDOES
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XDOES, 0
    DQ OFFSET XDOES, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDOES
    DQ OFFSET row_XDOES
BOOTPTR ENDS
.CODE
XDOES:
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, cfa_does
    lea rax, cfa_does
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_37
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_37:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XTHROW:
    ; DCB "THROW", 0
    DB "THROW", 0
hl_XTHROW:
    ; DCB "THROW ( n -- ) raise exception n (0 is a no-op)", 0
    DB "THROW ( n -- ) raise exception n (0 is a no-op)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTHROW:
    ; DCQ     nm_XTHROW, hl_XTHROW
    DQ OFFSET nm_XTHROW, OFFSET hl_XTHROW
    ; DCQ     0
    DQ 0
    ; DCQ     XTHROW, 0
    DQ OFFSET XTHROW, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTHROW
    DQ OFFSET row_XTHROW
BOOTPTR ENDS
.CODE
XTHROW:
    ; cbz     x20, _throw_zero
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    je _throw_zero
    ; lea x7, throw_handler
    lea rax, throw_handler
    mov QWORD PTR arm_x7, rax
    ; ldr     x1, [x7]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _throw_uncaught
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _throw_uncaught
    ; mov     x5, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x5, rax
    ; mov     x23, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x23, rax
    ; ldr     x19, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; ldr     x6, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; mov     x4, x22
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR arm_x4, rax
    ; ldr     x22, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x22, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; ldr     x8, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x8, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; cmp     x4, x22
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x22
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _throw_tos_snap
    cmp BYTE PTR arm_c, 0
    jne _throw_tos_snap
    ; ldr     x8, [x22, #-8]
    mov r10, QWORD PTR arm_x22
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x8, rax
_throw_tos_snap:
    ; mov     x20, x8
    mov rax, QWORD PTR arm_x8
    mov QWORD PTR arm_x20, rax
    ; ldr     x0, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; str     x0, [x7]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldr     x0, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; lea x3, eval_resume_sp
    lea rax, eval_resume_sp
    mov QWORD PTR arm_x3, rax
    ; str     x0, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; sub     sp, sp, #80
    mov rax, rsp
    sub rax, 50h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x5, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x22, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; mov     x0, x6
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR arm_x0, rax
    ; bl      _throw_unwind_to_sp
    lea rax, xret_38
    mov QWORD PTR arm_x30, rax
    jmp _throw_unwind_to_sp
    xret_38:
    ; ldp     x19, x22, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x22, rcx
    ; ldp     x5, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x5, rax
    mov QWORD PTR arm_x20, rcx
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #80
    mov rax, rsp
    add rax, 50h
    mov rsp, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x20, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_throw_uncaught:
    ; sub     sp, sp, #80
    mov rax, rsp
    sub rax, 50h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; str     x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, msg_throw
    lea rax, msg_throw
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_39
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_39:
    ; ldr     x0, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _print_signed
    lea rax, xret_40
    mov QWORD PTR arm_x30, rax
    jmp _print_signed
    xret_40:
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_41
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_41:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #80
    mov rax, rsp
    add rax, 50h
    mov rsp, rax
    ; b       _quit_exit
    jmp _quit_exit
_throw_zero:
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XPARSE:
    ; DCB "PARSE", 0
    DB "PARSE", 0
hl_XPARSE:
    ; DCB "PARSE ( char -- c-addr u ) parse through delimiter", 0
    DB "PARSE ( char -- c-addr u ) parse through delimiter", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPARSE:
    ; DCQ     nm_XPARSE, hl_XPARSE
    DQ OFFSET nm_XPARSE, OFFSET hl_XPARSE
    ; DCQ     0
    DQ 0
    ; DCQ     XPARSE, XPARSE_END
    DQ OFFSET XPARSE, OFFSET XPARSE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPARSE
    DQ OFFSET row_XPARSE
BOOTPTR ENDS
.CODE
XPARSE:
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; mov     w7, w20
    mov eax, DWORD PTR arm_x20
    mov QWORD PTR arm_x7, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; bl      _cursor_load
    lea rax, xret_42
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_42:
    ; mov     x9, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x9, rax
    ; lea x3, source_end
    lea rax, source_end
    mov QWORD PTR arm_x3, rax
    ; ldr     x6, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; mov     x3, x9
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR arm_x3, rax
_parse_scan:
    ; cmp     x3, x6
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x6
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _parse_eos
    cmp BYTE PTR arm_c, 0
    jne _parse_eos
    ; ldrb    w4, [x3]
    mov r10, QWORD PTR arm_x3
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _parse_eos
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _parse_eos
    ; cmp     w4, w7
    mov eax, DWORD PTR arm_x4
    mov ecx, DWORD PTR arm_x7
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _parse_found
    cmp BYTE PTR arm_z, 0
    jne _parse_found
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _parse_scan
    jmp _parse_scan
_parse_found:
    ; sub     x5, x3, x9
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x9
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _parse_commit
    jmp _parse_commit
_parse_eos:
    ; sub     x5, x3, x9
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x9
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
_parse_commit:
    ; mov     x0, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x0, rax
    ; bl      _cursor_commit
    lea rax, xret_43
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_43:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x9
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR arm_x20, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x20, rax
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
XPARSE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XWORD:
    ; DCB "WORD", 0
    DB "WORD", 0
hl_XWORD:
    ; DCB "WORD ( char -- addr ) counted string in transient buffer", 0
    DB "WORD ( char -- addr ) counted string in transient buffer", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XWORD:
    ; DCQ     nm_XWORD, hl_XWORD
    DQ OFFSET nm_XWORD, OFFSET hl_XWORD
    ; DCQ     0
    DQ 0
    ; DCQ     XWORD, XWORD_END
    DQ OFFSET XWORD, OFFSET XWORD_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XWORD
    DQ OFFSET row_XWORD
BOOTPTR ENDS
.CODE
XWORD:
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; mov     w7, w20
    mov eax, DWORD PTR arm_x20
    mov QWORD PTR arm_x7, rax
    ; bl      _cursor_load
    lea rax, xret_44
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_44:
    ; lea x3, source_end
    lea rax, source_end
    mov QWORD PTR arm_x3, rax
    ; ldr     x9, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
_word_skip:
    ; cmp     x0, x9
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _word_empty
    cmp BYTE PTR arm_c, 0
    jne _word_empty
    ; ldrb    w4, [x0]
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _word_empty
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _word_empty
    ; cmp     w7, #32
    mov eax, DWORD PTR arm_x7
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _word_skip_exact
    cmp BYTE PTR arm_z, 0
    je _word_skip_exact
    ; cmp     w4, #32
    mov eax, DWORD PTR arm_x4
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _word_adv
    cmp BYTE PTR arm_z, 0
    jne _word_adv
    ; cmp     w4, #9
    mov eax, DWORD PTR arm_x4
    cmp eax, 9
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _word_adv
    cmp BYTE PTR arm_z, 0
    jne _word_adv
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _word_adv
    cmp BYTE PTR arm_z, 0
    jne _word_adv
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _word_adv
    cmp BYTE PTR arm_z, 0
    jne _word_adv
    ; b       _word_start
    jmp _word_start
_word_skip_exact:
    ; cmp     w4, w7
    mov eax, DWORD PTR arm_x4
    mov ecx, DWORD PTR arm_x7
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _word_start
    cmp BYTE PTR arm_z, 0
    je _word_start
_word_adv:
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; b       _word_skip
    jmp _word_skip
_word_start:
    ; mov     x3, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x3, rax
_word_scan:
    ; cmp     x0, x9
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _word_end
    cmp BYTE PTR arm_c, 0
    jne _word_end
    ; ldrb    w4, [x0]
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _word_end
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _word_end
    ; cmp     w7, #32
    mov eax, DWORD PTR arm_x7
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _word_scan_exact
    cmp BYTE PTR arm_z, 0
    je _word_scan_exact
    ; cmp     w4, #32
    mov eax, DWORD PTR arm_x4
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _word_end
    cmp BYTE PTR arm_z, 0
    jne _word_end
    ; cmp     w4, #9
    mov eax, DWORD PTR arm_x4
    cmp eax, 9
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _word_end
    cmp BYTE PTR arm_z, 0
    jne _word_end
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _word_end
    cmp BYTE PTR arm_z, 0
    jne _word_end
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _word_end
    cmp BYTE PTR arm_z, 0
    jne _word_end
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; b       _word_scan
    jmp _word_scan
_word_scan_exact:
    ; cmp     w4, w7
    mov eax, DWORD PTR arm_x4
    mov ecx, DWORD PTR arm_x7
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _word_end
    cmp BYTE PTR arm_z, 0
    jne _word_end
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; b       _word_scan
    jmp _word_scan
_word_end:
    ; sub     x5, x0, x3
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x3
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
    ; cmp     x0, x9
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _word_store
    cmp BYTE PTR arm_c, 0
    jne _word_store
    ; ldrb    w4, [x0]
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _word_store
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _word_store
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; cmp     w7, #32
    mov eax, DWORD PTR arm_x7
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _word_store
    cmp BYTE PTR arm_z, 0
    je _word_store
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _word_store
    cmp BYTE PTR arm_z, 0
    je _word_store
    ; cmp     x0, x9
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _word_store
    cmp BYTE PTR arm_c, 0
    jne _word_store
    ; ldrb    w4, [x0]
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _word_store
    cmp BYTE PTR arm_z, 0
    je _word_store
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
_word_store:
    ; cmp     x5, #63
    mov rax, QWORD PTR arm_x5
    cmp rax, 3Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _word_len_ok
    cmp BYTE PTR arm_c, 0
    je _word_len_ok
    cmp BYTE PTR arm_z, 0
    jne _word_len_ok
    ; mov     x5, #63
    mov rax, 3Fh
    mov QWORD PTR arm_x5, rax
_word_len_ok:
    ; bl      _cursor_commit
    lea rax, xret_45
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_45:
    ; lea x6, word_scratch
    lea rax, word_scratch
    mov QWORD PTR arm_x6, rax
    ; strb    w5, [x6]
    mov r10, QWORD PTR arm_x6
    mov eax, DWORD PTR arm_x5
    mov BYTE PTR [r10], al
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
_word_copy:
    ; cmp     x1, x5
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ge    _word_done
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _word_done
    ; ldrb    w4, [x3, x1]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x1
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; add     x8, x6, #1
    mov rax, QWORD PTR arm_x6
    add rax, 1
    mov QWORD PTR arm_x8, rax
    ; strb    w4, [x8, x1]
    mov r10, QWORD PTR arm_x8
    mov rax, QWORD PTR arm_x1
    add r10, rax
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _word_copy
    jmp _word_copy
_word_done:
    ; mov     x20, x6
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR arm_x20, rax
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_word_empty:
    ; bl      _cursor_commit
    lea rax, xret_46
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_46:
    ; lea x6, word_scratch
    lea rax, word_scratch
    mov QWORD PTR arm_x6, rax
    ; strb    wzr, [x6]
    mov r10, QWORD PTR arm_x6
    mov BYTE PTR [r10], 0
    ; mov     x20, x6
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR arm_x20, rax
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
XWORD_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XDOTPAREN:
    ; DCB ".(", 0
    DB ".(", 0
hl_XDOTPAREN:
    ; DCB ".( ( -- ) print text until ) (immediate)", 0
    DB ".( ( -- ) print text until ) (immediate)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDOTPAREN:
    ; DCQ     nm_XDOTPAREN, hl_XDOTPAREN
    DQ OFFSET nm_XDOTPAREN, OFFSET hl_XDOTPAREN
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XDOTPAREN, 0
    DQ OFFSET XDOTPAREN, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDOTPAREN
    DQ OFFSET row_XDOTPAREN
BOOTPTR ENDS
.CODE
XDOTPAREN:
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; mov     w7, #41
    mov eax, 29h
    mov QWORD PTR arm_x7, rax
    ; bl      _cursor_load
    lea rax, xret_47
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_47:
    ; mov     x9, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x9, rax
    ; lea x3, source_end
    lea rax, source_end
    mov QWORD PTR arm_x3, rax
    ; ldr     x6, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; mov     x3, x9
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR arm_x3, rax
_dotp_scan:
    ; cmp     x3, x6
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x6
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _dotp_eos
    cmp BYTE PTR arm_c, 0
    jne _dotp_eos
    ; ldrb    w4, [x3]
    mov r10, QWORD PTR arm_x3
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _dotp_eos
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _dotp_eos
    ; cmp     w4, w7
    mov eax, DWORD PTR arm_x4
    mov ecx, DWORD PTR arm_x7
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _dotp_found
    cmp BYTE PTR arm_z, 0
    jne _dotp_found
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _dotp_scan
    jmp _dotp_scan
_dotp_found:
    ; sub     x5, x3, x9
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x9
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _dotp_go
    jmp _dotp_go
_dotp_eos:
    ; sub     x5, x3, x9
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x9
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
_dotp_go:
    ; mov     x0, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x0, rax
    ; bl      _cursor_commit
    lea rax, xret_48
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_48:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x9
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR arm_x20, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x20, rax
    ; b       XTYPE
    jmp XTYPE
BWSTR SEGMENT ALIGN(1) READ
nm_XBACKSLASH:
    ; DCB 0x5C, 0
    DB 5Ch, 0
hl_XBACKSLASH:
    ; DCB 0x5C, "( -- ) comment to end of line (immediate)", 0
    DB 5Ch, "( -- ) comment to end of line (immediate)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBACKSLASH:
    ; DCQ     nm_XBACKSLASH, hl_XBACKSLASH
    DQ OFFSET nm_XBACKSLASH, OFFSET hl_XBACKSLASH
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XBACKSLASH, 0
    DQ OFFSET XBACKSLASH, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBACKSLASH
    DQ OFFSET row_XBACKSLASH
BOOTPTR ENDS
.CODE
XBACKSLASH:
    ; lea x0, blk_var
    lea rax, blk_var
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, _bs_block
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _bs_block
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _cursor_load
    lea rax, xret_49
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_49:
    ; mov     x10, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x10, rax
    ; lea x3, source_end
    lea rax, source_end
    mov QWORD PTR arm_x3, rax
    ; ldr     x9, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
_bs_loop:
    ; cmp     x10, x9
    mov rax, QWORD PTR arm_x10
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _bs_done
    cmp BYTE PTR arm_c, 0
    jne _bs_done
    ; ldrb    w4, [x10]
    mov r10, QWORD PTR arm_x10
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _bs_done
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _bs_done
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _bs_done
    cmp BYTE PTR arm_z, 0
    jne _bs_done
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _bs_done
    cmp BYTE PTR arm_z, 0
    jne _bs_done
    ; add     x10, x10, #1
    mov rax, QWORD PTR arm_x10
    add rax, 1
    mov QWORD PTR arm_x10, rax
    ; b       _bs_loop
    jmp _bs_loop
_bs_done:
    ; mov     x0, x10
    mov rax, QWORD PTR arm_x10
    mov QWORD PTR arm_x0, rax
    ; bl      _cursor_commit
    lea rax, xret_50
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_50:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_bs_block:
    ; lea x0, to_in
    lea rax, to_in
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, source_base
    lea rax, source_base
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; lea x2, source_end
    lea rax, source_end
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; sub     x2, x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    sub rax, rcx
    mov QWORD PTR arm_x2, rax
    ; lsr     x5, x1, #6
    mov rax, QWORD PTR arm_x1
    shr rax, 6
    mov QWORD PTR arm_x5, rax
    ; add     x5, x5, #1
    mov rax, QWORD PTR arm_x5
    add rax, 1
    mov QWORD PTR arm_x5, rax
    ; lsl     x5, x5, #6
    mov rax, QWORD PTR arm_x5
    shl rax, 6
    mov QWORD PTR arm_x5, rax
    ; cmp     x5, x2
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _bs_blk_ok
    cmp BYTE PTR arm_c, 0
    je _bs_blk_ok
    cmp BYTE PTR arm_z, 0
    jne _bs_blk_ok
    ; mov     x5, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x5, rax
_bs_blk_ok:
    ; str     x5, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10], rax
    ; add     x3, x3, x5
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    add rax, rcx
    mov QWORD PTR arm_x3, rax
    ; lea x0, source_cur
    lea rax, source_cur
    mov QWORD PTR arm_x0, rax
    ; str     x3, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XPAREN:
    ; DCB "(", 0
    DB "(", 0
hl_XPAREN:
    ; DCB "( -- ) comment until ) (immediate)", 0
    DB "( -- ) comment until ) (immediate)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPAREN:
    ; DCQ     nm_XPAREN, hl_XPAREN
    DQ OFFSET nm_XPAREN, OFFSET hl_XPAREN
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XPAREN, 0
    DQ OFFSET XPAREN, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPAREN
    DQ OFFSET row_XPAREN
BOOTPTR ENDS
.CODE
XPAREN:
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _cursor_load
    lea rax, xret_51
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_51:
    ; mov     x10, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x10, rax
    ; lea x3, source_end
    lea rax, source_end
    mov QWORD PTR arm_x3, rax
    ; ldr     x9, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
_par_loop:
    ; cmp     x10, x9
    mov rax, QWORD PTR arm_x10
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _par_eol
    cmp BYTE PTR arm_c, 0
    jne _par_eol
    ; ldrb    w4, [x10]
    mov r10, QWORD PTR arm_x10
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _par_eol
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _par_eol
    ; cmp     w4, #41
    mov eax, DWORD PTR arm_x4
    cmp eax, 29h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _par_found
    cmp BYTE PTR arm_z, 0
    jne _par_found
    ; add     x10, x10, #1
    mov rax, QWORD PTR arm_x10
    add rax, 1
    mov QWORD PTR arm_x10, rax
    ; b       _par_loop
    jmp _par_loop
_par_found:
    ; add     x10, x10, #1
    mov rax, QWORD PTR arm_x10
    add rax, 1
    mov QWORD PTR arm_x10, rax
    ; b       _par_store
    jmp _par_store
_par_eol:
    ; lea x0, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _par_store
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _par_store
    ; bl      _take_line
    lea rax, xret_52
    mov QWORD PTR arm_x30, rax
    jmp _take_line
    xret_52:
    ; cbz     x0, _par_eof
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _par_eof
    ; bl      _cursor_load
    lea rax, xret_53
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_53:
    ; mov     x10, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x10, rax
    ; lea x3, source_end
    lea rax, source_end
    mov QWORD PTR arm_x3, rax
    ; ldr     x9, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
    ; b       _par_loop
    jmp _par_loop
_par_eof:
    ; bl      _cursor_load
    lea rax, xret_54
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_54:
    ; mov     x10, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x10, rax
_par_store:
    ; mov     x0, x10
    mov rax, QWORD PTR arm_x10
    mov QWORD PTR arm_x0, rax
    ; bl      _cursor_commit
    lea rax, xret_55
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_55:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSLIT:
    ; DCB "(S", 0x22, ")", 0
    DB "(S", 22h, ")", 0
hl_XSLIT:
    ; DCB "(S", 0x22, ")", "( -- c-addr u ) runtime for a compiled quote string", 0
    DB "(S", 22h, ")", "( -- c-addr u ) runtime for a compiled quote string", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSLIT:
    ; DCQ     nm_XSLIT, hl_XSLIT
    DQ OFFSET nm_XSLIT, OFFSET hl_XSLIT
    ; DCQ     0
    DQ 0
    ; DCQ     XSLIT, XSLIT_END
    DQ OFFSET XSLIT, OFFSET XSLIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSLIT
    DQ OFFSET row_XSLIT
BOOTPTR ENDS
.CODE
XSLIT:
    ; ldr     x0, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x19
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR arm_x20, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; add     x19, x19, x0
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x0
    add rax, rcx
    mov QWORD PTR arm_x19, rax
    ; add     x19, x19, #7
    mov rax, QWORD PTR arm_x19
    add rax, 7
    mov QWORD PTR arm_x19, rax
    ; bic     x19, x19, #7
    mov rax, QWORD PTR arm_x19
    mov rcx, 7
    not rcx
    and rax, rcx
    mov QWORD PTR arm_x19, rax
XSLIT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSQUOTE:
    ; DCB "S", 0x22, 0
    DB "S", 22h, 0
hl_XSQUOTE:
    ; DCB "S", 0x22, "( -- c-addr u ) quote-delimited string (immediate)", 0
    DB "S", 22h, "( -- c-addr u ) quote-delimited string (immediate)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSQUOTE:
    ; DCQ     nm_XSQUOTE, hl_XSQUOTE
    DQ OFFSET nm_XSQUOTE, OFFSET hl_XSQUOTE
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XSQUOTE, 0
    DQ OFFSET XSQUOTE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSQUOTE
    DQ OFFSET row_XSQUOTE
BOOTPTR ENDS
.CODE
XSQUOTE:
    ; sub     sp, sp, #96
    mov rax, rsp
    sub rax, 60h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _cursor_load
    lea rax, xret_56
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_56:
    ; mov     x1, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x1, rax
    ; lea x3, source_end
    lea rax, source_end
    mov QWORD PTR arm_x3, rax
    ; ldr     x6, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; mov     x9, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x9, rax
_sq_scan:
    ; cmp     x1, x6
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x6
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _sq_eos
    cmp BYTE PTR arm_c, 0
    jne _sq_eos
    ; ldrb    w3, [x1]
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbz     w3, _sq_eos
    mov eax, DWORD PTR arm_x3
    cmp rax, 0
    je _sq_eos
    ; cmp     w3, #34
    mov eax, DWORD PTR arm_x3
    cmp eax, 22h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _sq_found
    cmp BYTE PTR arm_z, 0
    jne _sq_found
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _sq_scan
    jmp _sq_scan
_sq_found:
    ; sub     x5, x1, x9
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x9
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _sq_commit
    jmp _sq_commit
_sq_eos:
    ; sub     x5, x1, x9
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x9
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
_sq_commit:
    ; mov     x0, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x0, rax
    ; bl      _cursor_commit
    lea rax, xret_57
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_57:
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, _sq_comp
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _sq_comp
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x9
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR arm_x20, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x20, rax
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_sq_comp:
    ; stp     x9, x5, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10+8], rax
    ; lea x0, cfa_slit
    lea rax, cfa_slit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_58
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_58:
    ; ldr     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_59
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_59:
    ; ldr     x5, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; ldr     x9, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
    ; lea x0, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
_sq_cpy:
    ; cmp     x3, x5
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ge    _sq_align
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _sq_align
    ; ldrb    w4, [x9, x3]
    mov r10, QWORD PTR arm_x9
    mov rax, QWORD PTR arm_x3
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; strb    w4, [x1, x3]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x3
    add r10, rax
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _sq_cpy
    jmp _sq_cpy
_sq_align:
    ; add     x1, x1, x5
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x5
    add rax, rcx
    mov QWORD PTR arm_x1, rax
    ; add     x1, x1, #7
    mov rax, QWORD PTR arm_x1
    add rax, 7
    mov QWORD PTR arm_x1, rax
    ; bic     x1, x1, #7
    mov rax, QWORD PTR arm_x1
    mov rcx, 7
    not rcx
    and rax, rcx
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCSTR:
    ; DCB "(C", 0x22, ")", 0
    DB "(C", 22h, ")", 0
hl_XCSTR:
    ; DCB "(C", 0x22, ")", "( -- c-addr ) runtime for a compiled counted string", 0
    DB "(C", 22h, ")", "( -- c-addr ) runtime for a compiled counted string", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCSTR:
    ; DCQ     nm_XCSTR, hl_XCSTR
    DQ OFFSET nm_XCSTR, OFFSET hl_XCSTR
    ; DCQ     0
    DQ 0
    ; DCQ     XCSTR, XCSTR_END
    DQ OFFSET XCSTR, OFFSET XCSTR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCSTR
    DQ OFFSET row_XCSTR
BOOTPTR ENDS
.CODE
XCSTR:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x19
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR arm_x20, rax
    ; ldrb    w0, [x19]
    mov r10, QWORD PTR arm_x19
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; add     x19, x19, x0
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x0
    add rax, rcx
    mov QWORD PTR arm_x19, rax
    ; add     x19, x19, #1
    mov rax, QWORD PTR arm_x19
    add rax, 1
    mov QWORD PTR arm_x19, rax
    ; add     x19, x19, #7
    mov rax, QWORD PTR arm_x19
    add rax, 7
    mov QWORD PTR arm_x19, rax
    ; bic     x19, x19, #7
    mov rax, QWORD PTR arm_x19
    mov rcx, 7
    not rcx
    and rax, rcx
    mov QWORD PTR arm_x19, rax
XCSTR_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCQUOTE:
    ; DCB "C", 0x22, 0
    DB "C", 22h, 0
hl_XCQUOTE:
    ; DCB "C", 0x22, "( -- c-addr ) compile a quote-delimited counted string", 0
    DB "C", 22h, "( -- c-addr ) compile a quote-delimited counted string", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCQUOTE:
    ; DCQ     nm_XCQUOTE, hl_XCQUOTE
    DQ OFFSET nm_XCQUOTE, OFFSET hl_XCQUOTE
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XCQUOTE, 0
    DQ OFFSET XCQUOTE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCQUOTE
    DQ OFFSET row_XCQUOTE
BOOTPTR ENDS
.CODE
XCQUOTE:
    ; sub     sp, sp, #96
    mov rax, rsp
    sub rax, 60h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _cursor_load
    lea rax, xret_60
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_60:
    ; mov     x1, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x1, rax
    ; lea x3, source_end
    lea rax, source_end
    mov QWORD PTR arm_x3, rax
    ; ldr     x6, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; mov     x9, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x9, rax
_cq_scan:
    ; cmp     x1, x6
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x6
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _cq_eos
    cmp BYTE PTR arm_c, 0
    jne _cq_eos
    ; ldrb    w3, [x1]
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbz     w3, _cq_eos
    mov eax, DWORD PTR arm_x3
    cmp rax, 0
    je _cq_eos
    ; cmp     w3, #34
    mov eax, DWORD PTR arm_x3
    cmp eax, 22h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _cq_found
    cmp BYTE PTR arm_z, 0
    jne _cq_found
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _cq_scan
    jmp _cq_scan
_cq_found:
    ; sub     x5, x1, x9
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x9
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _cq_commit
    jmp _cq_commit
_cq_eos:
    ; sub     x5, x1, x9
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x9
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
_cq_commit:
    ; mov     x0, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x0, rax
    ; bl      _cursor_commit
    lea rax, xret_61
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_61:
    ; cmp     x5, #255
    mov rax, QWORD PTR arm_x5
    cmp rax, 0FFh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _cq_lenok
    cmp BYTE PTR arm_c, 0
    je _cq_lenok
    cmp BYTE PTR arm_z, 0
    jne _cq_lenok
    ; mov     x5, #255
    mov rax, 0FFh
    mov QWORD PTR arm_x5, rax
_cq_lenok:
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, _cq_comp
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _cq_comp
    ; lea x0, pad_buffer
    lea rax, pad_buffer
    mov QWORD PTR arm_x0, rax
    ; strb    w5, [x0]
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x5
    mov BYTE PTR [r10], al
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
_cq_ipad:
    ; cmp     x3, x5
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ge    _cq_idone
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _cq_idone
    ; ldrb    w4, [x9, x3]
    mov r10, QWORD PTR arm_x9
    mov rax, QWORD PTR arm_x3
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; add     x6, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x6, rax
    ; strb    w4, [x6, x3]
    mov r10, QWORD PTR arm_x6
    mov rax, QWORD PTR arm_x3
    add r10, rax
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _cq_ipad
    jmp _cq_ipad
_cq_idone:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_cq_comp:
    ; stp     x9, x5, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10+8], rax
    ; lea x0, cfa_cstr
    lea rax, cfa_cstr
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_62
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_62:
    ; ldr     x5, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; ldr     x9, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
    ; lea x0, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; strb    w5, [x1], #1
    mov r10, QWORD PTR arm_x1
    mov eax, DWORD PTR arm_x5
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
_cq_cpy:
    ; cmp     x3, x5
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ge    _cq_align
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _cq_align
    ; ldrb    w4, [x9, x3]
    mov r10, QWORD PTR arm_x9
    mov rax, QWORD PTR arm_x3
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; strb    w4, [x1, x3]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x3
    add r10, rax
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _cq_cpy
    jmp _cq_cpy
_cq_align:
    ; add     x1, x1, x5
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x5
    add rax, rcx
    mov QWORD PTR arm_x1, rax
    ; add     x1, x1, #7
    mov rax, QWORD PTR arm_x1
    add rax, 7
    mov QWORD PTR arm_x1, rax
    ; bic     x1, x1, #7
    mov rax, QWORD PTR arm_x1
    mov rcx, 7
    not rcx
    and rax, rcx
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
next_debug_gate:
    ; lea x16, next_debug
    lea rax, next_debug
    mov QWORD PTR arm_x16, rax
    ; br      x16
    mov rax, QWORD PTR arm_x16
    jmp rax
.CONST
msg_allot:
    ; DCB     "ALLOT: dictionary full (need more USER-DICT space)", 10, 0
    DB "ALLOT: dictionary full (need more USER-DICT space)", 0Ah, 0
msg_throw:
    ; DCB     " throw ", 0
    DB " throw ", 0
msg_huh_k1:
    ; DCB     " ?", 10, 0
    DB " ?", 0Ah, 0
str_search_order:
    ; DCB "Search order: ", 0
    DB "Search order: ", 0
str_comp_wl:
    ; DCB     "Compilation wordlist: ", 0
    DB "Compilation wordlist: ", 0
END
