; Generated from Forth/kernel/arm64/prims.asm. Do not edit.
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
EXTRN _interpret_loop:PROC
EXTRN _local_frame_try_exit:PROC
EXTRN _print_signed:PROC
EXTRN _print_unsigned:PROC
EXTRN _putchar:PROC
EXTRN _quit_exit:PROC
EXTRN _sa_print_signed:PROC
EXTRN _sa_putchar:PROC
EXTRN debug_break_asap:BYTE
EXTRN debug_floor:BYTE
EXTRN dstack:BYTE
EXTRN emit_cstr:PROC
EXTRN next_debug:PROC
EXTRN return_stack:BYTE
EXTRN throw_handler:BYTE
.CODE
PUBLIC DOCOL
PUBLIC XRESTART
PUBLIC DOEXIT
PUBLIC XLit
PUBLIC XDUP
PUBLIC XDROP
PUBLIC XSWAP
PUBLIC XOVER
PUBLIC XPLUS
PUBLIC XMINUS
PUBLIC XSTAR
PUBLIC XSLASH
PUBLIC XMOD
PUBLIC XDOT
PUBLIC XDOTS
PUBLIC XRSDOT
PUBLIC XCR
PUBLIC XBYE
BWSTR SEGMENT ALIGN(1) READ
nm_XNEXT:
    ; DCB "(NEXT)", 0
    DB "(NEXT)", 0
hl_XNEXT:
    ; DCB "(NEXT) ITC dispatch", 0
    DB "(NEXT) ITC dispatch", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XNEXT:
    ; DCQ     nm_XNEXT, hl_XNEXT
    DQ OFFSET nm_XNEXT, OFFSET hl_XNEXT
    ; DCQ     0
    DQ 0
    ; DCQ     XNEXT, XNEXT_END
    DQ OFFSET XNEXT, OFFSET XNEXT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XNEXT
    DQ OFFSET row_XNEXT
BOOTPTR ENDS
.CODE
XNEXT:
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
XNEXT_END:
BWSTR SEGMENT ALIGN(1) READ
nm_DOCOL:
    ; DCB "(DOCOL)", 0
    DB "(DOCOL)", 0
hl_DOCOL:
    ; DCB "(DOCOL) colon runtime", 0
    DB "(DOCOL) colon runtime", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_DOCOL:
    ; DCQ     nm_DOCOL, hl_DOCOL
    DQ OFFSET nm_DOCOL, OFFSET hl_DOCOL
    ; DCQ     0
    DQ 0
    ; DCQ     DOCOL, DOCOL_END
    DQ OFFSET DOCOL, OFFSET DOCOL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_DOCOL
    DQ OFFSET row_DOCOL
BOOTPTR ENDS
.CODE
DOCOL:
    ; str     x19, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10], rax
    ; add     x19, x21, #16
    mov rax, QWORD PTR arm_x21
    add rax, 10h
    mov QWORD PTR arm_x19, rax
    ; ldr     x0, [x19]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, DOCOL_END
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne DOCOL_END
    ; b       _quit_exit
    jmp _quit_exit
DOCOL_END:
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
nm_DOEXIT:
    ; DCB "EXIT", 0
    DB "EXIT", 0
hl_DOEXIT:
    ; DCB "EXIT ( -- ) return from colon definition", 0
    DB "EXIT ( -- ) return from colon definition", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_DOEXIT:
    ; DCQ     nm_DOEXIT, hl_DOEXIT
    DQ OFFSET nm_DOEXIT, OFFSET hl_DOEXIT
    ; DCQ     0
    DQ 0
    ; DCQ     DOEXIT, DOEXIT_END
    DQ OFFSET DOEXIT, OFFSET DOEXIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_DOEXIT
    DQ OFFSET row_DOEXIT
BOOTPTR ENDS
.CODE
DOEXIT:
    ; bl      _local_frame_try_exit
    lea rax, xret_1
    mov QWORD PTR arm_x30, rax
    jmp _local_frame_try_exit
    xret_1:
    ; ldr     x19, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
DOEXIT_END:
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
nm_XLit:
    ; DCB "LIT", 0
    DB "LIT", 0
hl_XLit:
    ; DCB "LIT ( -- n ) internal: literal value", 0
    DB "LIT ( -- n ) internal: literal value", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLit:
    ; DCQ     nm_XLit, hl_XLit
    DQ OFFSET nm_XLit, OFFSET hl_XLit
    ; DCQ     0
    DQ 0
    ; DCQ     XLit, XLit_END
    DQ OFFSET XLit, OFFSET XLit_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLit
    DQ OFFSET row_XLit
BOOTPTR ENDS
.CODE
XLit:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
XLit_END:
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
nm_XDUP:
    ; DCB "DUP", 0
    DB "DUP", 0
hl_XDUP:
    ; DCB "DUP ( n -- n n ) duplicate top", 0
    DB "DUP ( n -- n n ) duplicate top", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDUP:
    ; DCQ     nm_XDUP, hl_XDUP
    DQ OFFSET nm_XDUP, OFFSET hl_XDUP
    ; DCQ     0
    DQ 0
    ; DCQ     XDUP, XDUP_END
    DQ OFFSET XDUP, OFFSET XDUP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDUP
    DQ OFFSET row_XDUP
BOOTPTR ENDS
.CODE
XDUP:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
XDUP_END:
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
nm_XDROP:
    ; DCB "DROP", 0
    DB "DROP", 0
hl_XDROP:
    ; DCB "DROP ( n -- ) discard top", 0
    DB "DROP ( n -- ) discard top", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDROP:
    ; DCQ     nm_XDROP, hl_XDROP
    DQ OFFSET nm_XDROP, OFFSET hl_XDROP
    ; DCQ     0
    DQ 0
    ; DCQ     XDROP, XDROP_END
    DQ OFFSET XDROP, OFFSET XDROP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDROP
    DQ OFFSET row_XDROP
BOOTPTR ENDS
.CODE
XDROP:
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
XDROP_END:
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
nm_XSWAP:
    ; DCB "SWAP", 0
    DB "SWAP", 0
hl_XSWAP:
    ; DCB "SWAP ( a b -- b a ) swap top two", 0
    DB "SWAP ( a b -- b a ) swap top two", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSWAP:
    ; DCQ     nm_XSWAP, hl_XSWAP
    DQ OFFSET nm_XSWAP, OFFSET hl_XSWAP
    ; DCQ     0
    DQ 0
    ; DCQ     XSWAP, XSWAP_END
    DQ OFFSET XSWAP, OFFSET XSWAP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSWAP
    DQ OFFSET row_XSWAP
BOOTPTR ENDS
.CODE
XSWAP:
    ; ldr     x0, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XSWAP_END:
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
nm_XOVER:
    ; DCB "OVER", 0
    DB "OVER", 0
hl_XOVER:
    ; DCB "OVER ( a b -- a b a ) copy second", 0
    DB "OVER ( a b -- a b a ) copy second", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XOVER:
    ; DCQ     nm_XOVER, hl_XOVER
    DQ OFFSET nm_XOVER, OFFSET hl_XOVER
    ; DCQ     0
    DQ 0
    ; DCQ     XOVER, XOVER_END
    DQ OFFSET XOVER, OFFSET XOVER_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XOVER
    DQ OFFSET row_XOVER
BOOTPTR ENDS
.CODE
XOVER:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x22, #8]
    mov r10, QWORD PTR arm_x22
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
XOVER_END:
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
nm_XPLUS:
    ; DCB "+", 0
    DB "+", 0
hl_XPLUS:
    ; DCB "+ ( n1 n2 -- n ) addition", 0
    DB "+ ( n1 n2 -- n ) addition", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPLUS:
    ; DCQ     nm_XPLUS, hl_XPLUS
    DQ OFFSET nm_XPLUS, OFFSET hl_XPLUS
    ; DCQ     0
    DQ 0
    ; DCQ     XPLUS, XPLUS_END
    DQ OFFSET XPLUS, OFFSET XPLUS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPLUS
    DQ OFFSET row_XPLUS
BOOTPTR ENDS
.CODE
XPLUS:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; add     x20, x20, x0
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x0
    add rax, rcx
    mov QWORD PTR arm_x20, rax
XPLUS_END:
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
nm_XMINUS:
    ; DCB "-", 0
    DB "-", 0
hl_XMINUS:
    ; DCB "- ( n1 n2 -- n ) subtraction", 0
    DB "- ( n1 n2 -- n ) subtraction", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMINUS:
    ; DCQ     nm_XMINUS, hl_XMINUS
    DQ OFFSET nm_XMINUS, OFFSET hl_XMINUS
    ; DCQ     0
    DQ 0
    ; DCQ     XMINUS, XMINUS_END
    DQ OFFSET XMINUS, OFFSET XMINUS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMINUS
    DQ OFFSET row_XMINUS
BOOTPTR ENDS
.CODE
XMINUS:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; sub     x20, x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    sub rax, rcx
    mov QWORD PTR arm_x20, rax
XMINUS_END:
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
nm_XSTAR:
    ; DCB "*", 0
    DB "*", 0
hl_XSTAR:
    ; DCB "* ( n1 n2 -- n ) multiplication", 0
    DB "* ( n1 n2 -- n ) multiplication", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSTAR:
    ; DCQ     nm_XSTAR, hl_XSTAR
    DQ OFFSET nm_XSTAR, OFFSET hl_XSTAR
    ; DCQ     0
    DQ 0
    ; DCQ     XSTAR, XSTAR_END
    DQ OFFSET XSTAR, OFFSET XSTAR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSTAR
    DQ OFFSET row_XSTAR
BOOTPTR ENDS
.CODE
XSTAR:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mul     x20, x20, x0
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x0
    imul rax, rcx
    mov QWORD PTR arm_x20, rax
XSTAR_END:
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
nm_XSLASH:
    ; DCB "/", 0
    DB "/", 0
hl_XSLASH:
    ; DCB "/ ( n1 n2 -- quot ) division (quotient)", 0
    DB "/ ( n1 n2 -- quot ) division (quotient)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSLASH:
    ; DCQ     nm_XSLASH, hl_XSLASH
    DQ OFFSET nm_XSLASH, OFFSET hl_XSLASH
    ; DCQ     0
    DQ 0
    ; DCQ     XSLASH, XSLASH_END
    DQ OFFSET XSLASH, OFFSET XSLASH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSLASH
    DQ OFFSET row_XSLASH
BOOTPTR ENDS
.CODE
XSLASH:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; sdiv    x20, x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    cmp rcx, 0
    je xdiv0_3
    cmp rcx, -1
    jne xdivov_4
    mov r8, 8000000000000000h
    cmp rax, r8
    je xdiv_2
    xdivov_4:
    cqo
    idiv rcx
    jmp xdiv_2
    xdiv0_3:
    xor eax, eax
    xdiv_2:
    mov QWORD PTR arm_x20, rax
XSLASH_END:
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
nm_XMOD:
    ; DCB "MOD", 0
    DB "MOD", 0
hl_XMOD:
    ; DCB "MOD ( n1 n2 -- rem ) modulo", 0
    DB "MOD ( n1 n2 -- rem ) modulo", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMOD:
    ; DCQ     nm_XMOD, hl_XMOD
    DQ OFFSET nm_XMOD, OFFSET hl_XMOD
    ; DCQ     0
    DQ 0
    ; DCQ     XMOD, XMOD_END
    DQ OFFSET XMOD, OFFSET XMOD_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMOD
    DQ OFFSET row_XMOD
BOOTPTR ENDS
.CODE
XMOD:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; sdiv    x1, x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    cmp rcx, 0
    je xdiv0_6
    cmp rcx, -1
    jne xdivov_7
    mov r8, 8000000000000000h
    cmp rax, r8
    je xdiv_5
    xdivov_7:
    cqo
    idiv rcx
    jmp xdiv_5
    xdiv0_6:
    xor eax, eax
    xdiv_5:
    mov QWORD PTR arm_x1, rax
    ; msub    x20, x1, x20, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x20
    imul rax, rcx
    mov rcx, QWORD PTR arm_x0
    sub rcx, rax
    mov rax, rcx
    mov QWORD PTR arm_x20, rax
XMOD_END:
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
nm_XCR:
    ; DCB "CR", 0
    DB "CR", 0
hl_XCR:
    ; DCB "CR ( -- ) carriage return / newline", 0
    DB "CR ( -- ) carriage return / newline", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCR:
    ; DCQ     nm_XCR, hl_XCR
    DQ OFFSET nm_XCR, OFFSET hl_XCR
    ; DCQ     0
    DQ 0
    ; DCQ     XCR, XCR_END
    DQ OFFSET XCR, OFFSET XCR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCR
    DQ OFFSET row_XCR
BOOTPTR ENDS
.CODE
XCR:
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
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_8
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_8:
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
XCR_END:
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
nm_XDOT:
    ; DCB ".", 0
    DB ".", 0
hl_XDOT:
    ; DCB ". ( n -- ) print number (with space)", 0
    DB ". ( n -- ) print number (with space)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDOT:
    ; DCQ     nm_XDOT, hl_XDOT
    DQ OFFSET nm_XDOT, OFFSET hl_XDOT
    ; DCQ     0
    DQ 0
    ; DCQ     XDOT, XDOT_END
    DQ OFFSET XDOT, OFFSET XDOT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDOT
    DQ OFFSET row_XDOT
BOOTPTR ENDS
.CODE
XDOT:
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
    ; bl      _sa_print_signed
    lea rax, xret_9
    mov QWORD PTR arm_x30, rax
    jmp _sa_print_signed
    xret_9:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _sa_putchar
    lea rax, xret_10
    mov QWORD PTR arm_x30, rax
    jmp _sa_putchar
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
XDOT_END:
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
nm_XDOTS:
    ; DCB ".S", 0
    DB ".S", 0
hl_XDOTS:
    ; DCB ".S ( -- ) print data stack contents", 0
    DB ".S ( -- ) print data stack contents", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDOTS:
    ; DCQ     nm_XDOTS, hl_XDOTS
    DQ OFFSET nm_XDOTS, OFFSET hl_XDOTS
    ; DCQ     0
    DQ 0
    ; DCQ     XDOTS, 0
    DQ OFFSET XDOTS, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDOTS
    DQ OFFSET row_XDOTS
BOOTPTR ENDS
.CODE
XDOTS:
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
    ; bl      _print_dots
    lea rax, xret_11
    mov QWORD PTR arm_x30, rax
    jmp _print_dots
    xret_11:
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
nm_XRSDOT:
    ; DCB "R.S", 0
    DB "R.S", 0
hl_XRSDOT:
    ; DCB "R.S ( -- ) print return stack contents", 0
    DB "R.S ( -- ) print return stack contents", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRSDOT:
    ; DCQ     nm_XRSDOT, hl_XRSDOT
    DQ OFFSET nm_XRSDOT, OFFSET hl_XRSDOT
    ; DCQ     0
    DQ 0
    ; DCQ     XRSDOT, 0
    DQ OFFSET XRSDOT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRSDOT
    DQ OFFSET row_XRSDOT
BOOTPTR ENDS
.CODE
XRSDOT:
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
    ; bl      _print_rstack
    lea rax, xret_12
    mov QWORD PTR arm_x30, rax
    jmp _print_rstack
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
nm_XBYE:
    ; DCB "BYE", 0
    DB "BYE", 0
hl_XBYE:
    ; DCB "BYE ( -- ) exit Forth to the host", 0
    DB "BYE ( -- ) exit Forth to the host", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBYE:
    ; DCQ     nm_XBYE, hl_XBYE
    DQ OFFSET nm_XBYE, OFFSET hl_XBYE
    ; DCQ     0
    DQ 0
    ; DCQ     XBYE, XBYE_END
    DQ OFFSET XBYE, OFFSET XBYE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBYE
    DQ OFFSET row_XBYE
BOOTPTR ENDS
.CODE
XBYE:
    ; b       _quit_exit
    jmp _quit_exit
XBYE_END:
XRESTART:
    ; b       _interpret_loop
    jmp _interpret_loop
_print_dots:
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
    ; stp     x25, x26, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR [r10+8], rax
    ; lea x0, msg_open
    lea rax, msg_open
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_13
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_13:
    ; lea x25, dstack
    lea rax, dstack
    mov QWORD PTR arm_x25, rax
    ; add     x25, x25, #1, lsl #12
    mov rax, QWORD PTR arm_x25
    add rax, 1000h
    mov QWORD PTR arm_x25, rax
    ; sub     x26, x25, x22
    mov rax, QWORD PTR arm_x25
    mov rcx, QWORD PTR arm_x22
    sub rax, rcx
    mov QWORD PTR arm_x26, rax
    ; lsr     x26, x26, #3
    mov rax, QWORD PTR arm_x26
    shr rax, 3
    mov QWORD PTR arm_x26, rax
    ; add     x0, x26, #1
    mov rax, QWORD PTR arm_x26
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; bl      _print_signed
    lea rax, xret_14
    mov QWORD PTR arm_x30, rax
    jmp _print_signed
    xret_14:
    ; lea x0, msg_mid
    lea rax, msg_mid
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_15
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_15:
    ; sub     x25, x25, #8
    mov rax, QWORD PTR arm_x25
    sub rax, 8
    mov QWORD PTR arm_x25, rax
_print_dots_loop:
    ; cmp     x25, x22
    mov rax, QWORD PTR arm_x25
    mov rcx, QWORD PTR arm_x22
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _print_dots_tos
    cmp BYTE PTR arm_c, 0
    je _print_dots_tos
    ; ldr     x0, [x25]
    mov r10, QWORD PTR arm_x25
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _print_signed
    lea rax, xret_16
    mov QWORD PTR arm_x30, rax
    jmp _print_signed
    xret_16:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_17
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_17:
    ; sub     x25, x25, #8
    mov rax, QWORD PTR arm_x25
    sub rax, 8
    mov QWORD PTR arm_x25, rax
    ; b       _print_dots_loop
    jmp _print_dots_loop
_print_dots_tos:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      _print_signed
    lea rax, xret_18
    mov QWORD PTR arm_x30, rax
    jmp _print_signed
    xret_18:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_19
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_19:
    ; ldp     x25, x26, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x25, rax
    mov QWORD PTR arm_x26, rcx
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
    ; ret
    jmp QWORD PTR arm_x30
_print_rstack:
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
    ; stp     x25, x26, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR [r10+8], rax
    ; lea x25, return_stack
    lea rax, return_stack
    mov QWORD PTR arm_x25, rax
    ; add     x25, x25, #1, lsl #12
    mov rax, QWORD PTR arm_x25
    add rax, 1000h
    mov QWORD PTR arm_x25, rax
    ; lea x0, debug_floor
    lea rax, debug_floor
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _pr_floor_keep
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _pr_floor_keep
    ; cmp     x0, x25
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x25
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _pr_floor_keep
    cmp BYTE PTR arm_c, 0
    je xsk_20
    cmp BYTE PTR arm_z, 0
    je _pr_floor_keep
    xsk_20:
    ; cmp     x0, x23
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x23
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _pr_floor_keep
    cmp BYTE PTR arm_c, 0
    je _pr_floor_keep
    cmp BYTE PTR arm_z, 0
    jne _pr_floor_keep
    ; mov     x25, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x25, rax
_pr_floor_keep:
    ; cmp     x23, x25
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x25
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _pr_empty
    cmp BYTE PTR arm_c, 0
    jne _pr_empty
    ; sub     x26, x25, x23
    mov rax, QWORD PTR arm_x25
    mov rcx, QWORD PTR arm_x23
    sub rax, rcx
    mov QWORD PTR arm_x26, rax
    ; lsr     x26, x26, #3
    mov rax, QWORD PTR arm_x26
    shr rax, 3
    mov QWORD PTR arm_x26, rax
    ; str     x26, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR [r10], rax
    ; lea x0, throw_handler
    lea rax, throw_handler
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x0, [sp, #72]
    lea r10, [rsp]
    add r10, 48h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; mov     x25, #0
    mov rax, 0
    mov QWORD PTR arm_x25, rax
    ; mov     x26, #0
    mov rax, 0
    mov QWORD PTR arm_x26, rax
_pr_count:
    ; ldr     x0, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x25, x0
    mov rax, QWORD PTR arm_x25
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _pr_counted
    cmp BYTE PTR arm_c, 0
    jne _pr_counted
    ; ldr     x1, [sp, #72]
    lea r10, [rsp]
    add r10, 48h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _pr_count_one
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _pr_count_one
    ; add     x2, x23, x25, lsl #3
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x25
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR arm_x2, rax
    ; cmp     x2, x1
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _pr_count_one
    cmp BYTE PTR arm_z, 0
    je _pr_count_one
    ; add     x25, x25, #6
    mov rax, QWORD PTR arm_x25
    add rax, 6
    mov QWORD PTR arm_x25, rax
    ; b       _pr_count
    jmp _pr_count
_pr_count_one:
    ; add     x26, x26, #1
    mov rax, QWORD PTR arm_x26
    add rax, 1
    mov QWORD PTR arm_x26, rax
    ; add     x25, x25, #1
    mov rax, QWORD PTR arm_x25
    add rax, 1
    mov QWORD PTR arm_x25, rax
    ; b       _pr_count
    jmp _pr_count
_pr_counted:
    ; cbz     x26, _pr_empty
    mov rax, QWORD PTR arm_x26
    cmp rax, 0
    je _pr_empty
    ; str     x26, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR [r10], rax
    ; lea x0, msg_open
    lea rax, msg_open
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_21
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_21:
    ; ldr     x0, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _print_unsigned
    lea rax, xret_22
    mov QWORD PTR arm_x30, rax
    jmp _print_unsigned
    xret_22:
    ; lea x0, msg_mid
    lea rax, msg_mid
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_23
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_23:
    ; mov     x25, #0
    mov rax, 0
    mov QWORD PTR arm_x25, rax
_pr_show:
    ; ldr     x0, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x25, x0
    mov rax, QWORD PTR arm_x25
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _pr_done
    cmp BYTE PTR arm_c, 0
    jne _pr_done
    ; ldr     x1, [sp, #72]
    lea r10, [rsp]
    add r10, 48h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _pr_show_one
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _pr_show_one
    ; add     x2, x23, x25, lsl #3
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x25
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR arm_x2, rax
    ; cmp     x2, x1
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _pr_show_one
    cmp BYTE PTR arm_z, 0
    je _pr_show_one
    ; add     x25, x25, #6
    mov rax, QWORD PTR arm_x25
    add rax, 6
    mov QWORD PTR arm_x25, rax
    ; b       _pr_show
    jmp _pr_show
_pr_show_one:
    ; ldr     x0, [x23, x25, lsl #3]
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x25
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _print_unsigned
    lea rax, xret_24
    mov QWORD PTR arm_x30, rax
    jmp _print_unsigned
    xret_24:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_25
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_25:
    ; add     x25, x25, #1
    mov rax, QWORD PTR arm_x25
    add rax, 1
    mov QWORD PTR arm_x25, rax
    ; b       _pr_show
    jmp _pr_show
_pr_empty:
    ; lea x0, msg_open
    lea rax, msg_open
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_26
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_26:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; bl      _print_unsigned
    lea rax, xret_27
    mov QWORD PTR arm_x30, rax
    jmp _print_unsigned
    xret_27:
    ; lea x0, msg_mid
    lea rax, msg_mid
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_28
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_28:
_pr_done:
    ; ldp     x25, x26, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x25, rax
    mov QWORD PTR arm_x26, rcx
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
    ; ret
    jmp QWORD PTR arm_x30
next_debug_gate:
    ; lea x16, next_debug
    lea rax, next_debug
    mov QWORD PTR arm_x16, rax
    ; br      x16
    mov rax, QWORD PTR arm_x16
    jmp rax
.CONST
msg_open:
    ; DCB     "( ", 0
    DB "( ", 0
msg_mid:
    ; DCB     " ) ", 0
    DB " ) ", 0
END
