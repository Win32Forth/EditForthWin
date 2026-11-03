; Generated from Forth/kernel/arm64/prims_dbg.asm. Do not edit.
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
EXTRN DODOES:PROC
EXTRN XCATCH:PROC
EXTRN XCATCH_OK:PROC
EXTRN XEXECUTE:PROC
EXTRN XTHROW:PROC
EXTRN _print_signed:PROC
EXTRN _print_unsigned:PROC
EXTRN _putchar:PROC
EXTRN catch_ok_cell:BYTE
EXTRN cfa_0branch:BYTE
EXTRN cfa_branch:BYTE
EXTRN cfa_lit:BYTE
EXTRN cfa_loop:BYTE
EXTRN cfa_plusloop:BYTE
EXTRN data_stack:BYTE
EXTRN here_ptr:BYTE
EXTRN host_debug_get_span:PROC
EXTRN host_debug_paint:PROC
EXTRN host_debug_set_span:PROC
EXTRN key_fn:BYTE
EXTRN latest_var:BYTE
EXTRN line_mode:BYTE
EXTRN line_origin:BYTE
EXTRN return_stack:BYTE
EXTRN source_base:BYTE
EXTRN source_id:BYTE
EXTRN throw_handler:BYTE
EXTRN to_in:BYTE
EXTRN tw_continue_cell:BYTE
EXTRN tw_continue_cfa:BYTE
EXTRN user_dict_area:BYTE
EXTRN wordlist_reg:BYTE
EXTRN wordlist_reg_n:BYTE
.CODE
PUBLIC next_debug
PUBLIC debug_break_asap
PUBLIC debug_armed
PUBLIC debug_busy
PUBLIC debug_bp_go
PUBLIC debug_bp_xts
PUBLIC debug_bp_en
PUBLIC debug_cfa
PUBLIC debug_xt
PUBLIC debug_name
PUBLIC view_file_n
PUBLIC view_paths
PUBLIC view_src_id
PUBLIC view_id_sp
PUBLIC include_name_pending
PUBLIC include_name_len
PUBLIC _view_line_now
PUBLIC _view_push_src_id
PUBLIC _view_pop_src_id
PUBLIC _view_set_src_from_pending
PUBLIC debug_runto_ip
PUBLIC debug_runto_off
PUBLIC debug_runto_status
PUBLIC debug_floor
PUBLIC debug_field_count
PUBLIC debug_field_len
PUBLIC _debug_note_byte
PUBLIC _getchar
next_debug_gate:
next_debug:
    ; lea x1, debug_busy
    lea rax, debug_busy
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbnz    x2, nd_exec
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    jne nd_exec
    ; lea x2, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbz     x3, nd_floor
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    je nd_floor
    ; ldr     x21, [x19]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    ; mov     x3, #1
    mov rax, 1
    mov QWORD PTR arm_x3, rax
    ; mov     x28, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x28, rax
    ; lea x4, debug_armed
    lea rax, debug_armed
    mov QWORD PTR arm_x4, rax
    ; ldr     x5, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; str     x3, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; cbnz    x5, nd_asap_floor
    mov rax, QWORD PTR arm_x5
    cmp rax, 0
    jne nd_asap_floor
    ; lea x4, debug_need_intro
    lea rax, debug_need_intro
    mov QWORD PTR arm_x4, rax
    ; str     x3, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
nd_asap_floor:
    ; lea x4, debug_floor
    lea rax, debug_floor
    mov QWORD PTR arm_x4, rax
    ; str     xzr, [x4]
    mov r10, QWORD PTR arm_x4
    mov QWORD PTR [r10], 0
    ; lea x4, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x4, rax
    ; str     xzr, [x4]
    mov r10, QWORD PTR arm_x4
    mov QWORD PTR [r10], 0
    ; lea x4, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR arm_x4, rax
    ; str     xzr, [x4]
    mov r10, QWORD PTR arm_x4
    mov QWORD PTR [r10], 0
    ; lea x4, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x4, rax
    ; str     xzr, [x4]
    mov r10, QWORD PTR arm_x4
    mov QWORD PTR [r10], 0
    ; lea x4, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x4, rax
    ; str     xzr, [x4]
    mov r10, QWORD PTR arm_x4
    mov QWORD PTR [r10], 0
    ; lea x4, debug_break_min_cfa
    lea rax, debug_break_min_cfa
    mov QWORD PTR arm_x4, rax
    ; ldr     x4, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     x4, nd_asap_hit
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    je nd_asap_hit
    ; mov     x0, x19
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x21
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR arm_x1, rax
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_resolve_enclosing
    lea rax, xret_1
    mov QWORD PTR arm_x30, rax
    jmp _debug_resolve_enclosing
    xret_1:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; cbz     x0, nd_exec
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je nd_exec
    ; lea x4, debug_break_min_cfa
    lea rax, debug_break_min_cfa
    mov QWORD PTR arm_x4, rax
    ; ldr     x4, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cmp     x0, x4
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x4
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    nd_exec
    cmp BYTE PTR arm_c, 0
    je nd_exec
nd_asap_hit:
    ; lea x2, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; add     x3, x23, #8
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x3, rax
    ; lea x4, debug_floor
    lea rax, debug_floor
    mov QWORD PTR arm_x4, rax
    ; str     x3, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; b       nd_force
    jmp nd_force
nd_floor:
    ; lea x2, debug_floor
    lea rax, debug_floor
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, nd_out
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je nd_out
    ; cmp     x23, x2
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    nd_out
    cmp BYTE PTR arm_c, 0
    je nd_out
    ; b.eq    nd_exec
    cmp BYTE PTR arm_z, 0
    jne nd_exec
    ; mov     x28, #0
    mov rax, 0
    mov QWORD PTR arm_x28, rax
    ; lea x3, debug_armed
    lea rax, debug_armed
    mov QWORD PTR arm_x3, rax
    ; str     xzr, [x3]
    mov r10, QWORD PTR arm_x3
    mov QWORD PTR [r10], 0
    ; lea x3, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x3, rax
    ; str     xzr, [x3]
    mov r10, QWORD PTR arm_x3
    mov QWORD PTR [r10], 0
    ; lea x3, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR arm_x3, rax
    ; str     xzr, [x3]
    mov r10, QWORD PTR arm_x3
    mov QWORD PTR [r10], 0
    ; lea x3, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x3, rax
    ; str     xzr, [x3]
    mov r10, QWORD PTR arm_x3
    mov QWORD PTR [r10], 0
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_debug_paint
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_paint
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; b       nd_exec
    jmp nd_exec
nd_out:
    ; lea x2, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, nd_over
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je nd_over
    ; cmp     x23, x2
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    nd_exec
    cmp BYTE PTR arm_c, 0
    je nd_exec
    cmp BYTE PTR arm_z, 0
    jne nd_exec
nd_over:
    ; lea x2, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, nd_peek
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je nd_peek
    ; cmp     x23, x2
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    nd_exec
    cmp BYTE PTR arm_c, 0
    je nd_exec
nd_peek:
    ; ldr     x21, [x19]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    ; lea x2, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbz     x3, nd_bp
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    je nd_bp
    ; cmp     x19, x3
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    nd_runto_miss
    cmp BYTE PTR arm_z, 0
    je nd_runto_miss
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; b       nd_force
    jmp nd_force
nd_runto_miss:
    ; lea x2, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbz     x3, nd_exec
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    je nd_exec
    ; b       nd_scan
    jmp nd_scan
nd_bp:
    ; lea x2, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbz     x3, nd_force
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    je nd_force
nd_scan:
    ; lea x3, debug_bp_xts
    lea rax, debug_bp_xts
    mov QWORD PTR arm_x3, rax
    ; lea x6, debug_bp_en
    lea rax, debug_bp_en
    mov QWORD PTR arm_x6, rax
    ; mov     x4, #8
    mov rax, 8
    mov QWORD PTR arm_x4, rax
nd_scan_loop:
    ; ldr     x5, [x3], #8
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x3
    add rax, 8
    mov QWORD PTR arm_x3, rax
    ; ldr     x7, [x6], #8
    mov r10, QWORD PTR arm_x6
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x7, rax
    mov rax, QWORD PTR arm_x6
    add rax, 8
    mov QWORD PTR arm_x6, rax
    ; cbz     x5, nd_scan_next
    mov rax, QWORD PTR arm_x5
    cmp rax, 0
    je nd_scan_next
    ; cbz     x7, nd_scan_next
    mov rax, QWORD PTR arm_x7
    cmp rax, 0
    je nd_scan_next
    ; cmp     x5, x21
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x21
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    nd_scan_hit
    cmp BYTE PTR arm_z, 0
    jne nd_scan_hit
nd_scan_next:
    ; subs    x4, x4, #1
    mov rax, QWORD PTR arm_x4
    sub rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x4, rax
    ; b.ne    nd_scan_loop
    cmp BYTE PTR arm_z, 0
    je nd_scan_loop
    ; b       nd_exec
    jmp nd_exec
nd_scan_hit:
    ; lea x2, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x3, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR arm_x3, rax
    ; str     xzr, [x3]
    mov r10, QWORD PTR arm_x3
    mov QWORD PTR [r10], 0
nd_force:
    ; ldr     x2, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; lea x3, XCATCH_OK
    lea rax, XCATCH_OK
    mov QWORD PTR arm_x3, rax
    ; cmp     x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    nd_exec
    cmp BYTE PTR arm_z, 0
    jne nd_exec
    ; lea x3, XDBGOFF
    lea rax, XDBGOFF
    mov QWORD PTR arm_x3, rax
    ; cmp     x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    nd_exec
    cmp BYTE PTR arm_z, 0
    jne nd_exec
    ; lea x2, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x1, debug_busy
    lea rax, debug_busy
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #1
    mov rax, 1
    mov QWORD PTR arm_x2, rax
    ; str     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_pause
    lea rax, xret_2
    mov QWORD PTR arm_x30, rax
    jmp _debug_pause
    xret_2:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; lea x1, debug_busy
    lea rax, debug_busy
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_abort
    lea rax, debug_abort
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, nd_exec
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je nd_exec
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; mov     x20, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x20, rax
    ; b       XTHROW
    jmp XTHROW
nd_exec:
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
nm_XDBGSHOWXT:
    ; DCB "DBG-SHOW-XT", 0
    DB "DBG-SHOW-XT", 0
hl_XDBGSHOWXT:
    ; DCB "DBG-SHOW-XT ( -- addr ) xt of the view sync word or 0", 0
    DB "DBG-SHOW-XT ( -- addr ) xt of the view sync word or 0", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGSHOWXT:
    ; DCQ     nm_XDBGSHOWXT, hl_XDBGSHOWXT
    DQ OFFSET nm_XDBGSHOWXT, OFFSET hl_XDBGSHOWXT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGSHOWXT, 0
    DQ OFFSET XDBGSHOWXT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGSHOWXT
    DQ OFFSET row_XDBGSHOWXT
BOOTPTR ENDS
.CODE
XDBGSHOWXT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_show_xt
    lea rax, debug_show_xt
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
nm_XDBGSYNCOK:
    ; DCB "DBG-SYNC-OK", 0
    DB "DBG-SYNC-OK", 0
hl_XDBGSYNCOK:
    ; DCB "DBG-SYNC-OK ( -- addr ) set 1 after a debug VIEW", 0
    DB "DBG-SYNC-OK ( -- addr ) set 1 after a debug VIEW", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGSYNCOK:
    ; DCQ     nm_XDBGSYNCOK, hl_XDBGSYNCOK
    DQ OFFSET nm_XDBGSYNCOK, OFFSET hl_XDBGSYNCOK
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGSYNCOK, 0
    DQ OFFSET XDBGSYNCOK, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGSYNCOK
    DQ OFFSET row_XDBGSYNCOK
BOOTPTR ENDS
.CODE
XDBGSYNCOK:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_sync_ok
    lea rax, debug_sync_ok
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
nm_XDBGHLXT:
    ; DCB "DBG-HL-XT", 0
    DB "DBG-HL-XT", 0
hl_XDBGHLXT:
    ; DCB "DBG-HL-XT ( -- addr ) xt of the highlight word or 0", 0
    DB "DBG-HL-XT ( -- addr ) xt of the highlight word or 0", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGHLXT:
    ; DCQ     nm_XDBGHLXT, hl_XDBGHLXT
    DQ OFFSET nm_XDBGHLXT, OFFSET hl_XDBGHLXT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGHLXT, 0
    DQ OFFSET XDBGHLXT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGHLXT
    DQ OFFSET row_XDBGHLXT
BOOTPTR ENDS
.CODE
XDBGHLXT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_hl_xt
    lea rax, debug_hl_xt
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
nm_XDBGWHEELXT:
    ; DCB "DBG-WHEEL-XT", 0
    DB "DBG-WHEEL-XT", 0
hl_XDBGWHEELXT:
    ; DCB "DBG-WHEEL-XT ( -- addr ) xt of the wheel word or 0", 0
    DB "DBG-WHEEL-XT ( -- addr ) xt of the wheel word or 0", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGWHEELXT:
    ; DCQ     nm_XDBGWHEELXT, hl_XDBGWHEELXT
    DQ OFFSET nm_XDBGWHEELXT, OFFSET hl_XDBGWHEELXT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGWHEELXT, 0
    DQ OFFSET XDBGWHEELXT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGWHEELXT
    DQ OFFSET row_XDBGWHEELXT
BOOTPTR ENDS
.CODE
XDBGWHEELXT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_wheel_xt
    lea rax, debug_wheel_xt
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
nm_XDBGPAUSEXT:
    ; DCB "DBG-PAUSE-XT", 0
    DB "DBG-PAUSE-XT", 0
hl_XDBGPAUSEXT:
    ; DCB "DBG-PAUSE-XT ( -- addr ) Forth pause xt or 0", 0
    DB "DBG-PAUSE-XT ( -- addr ) Forth pause xt or 0", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGPAUSEXT:
    ; DCQ     nm_XDBGPAUSEXT, hl_XDBGPAUSEXT
    DQ OFFSET nm_XDBGPAUSEXT, OFFSET hl_XDBGPAUSEXT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGPAUSEXT, 0
    DQ OFFSET XDBGPAUSEXT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGPAUSEXT
    DQ OFFSET row_XDBGPAUSEXT
BOOTPTR ENDS
.CODE
XDBGPAUSEXT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_pause_xt
    lea rax, debug_pause_xt
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
nm_XDBGKEYXT:
    ; DCB "DBG-KEY-XT", 0
    DB "DBG-KEY-XT", 0
hl_XDBGKEYXT:
    ; DCB "DBG-KEY-XT ( -- addr ) Forth key mode xt or 0", 0
    DB "DBG-KEY-XT ( -- addr ) Forth key mode xt or 0", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGKEYXT:
    ; DCQ     nm_XDBGKEYXT, hl_XDBGKEYXT
    DQ OFFSET nm_XDBGKEYXT, OFFSET hl_XDBGKEYXT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGKEYXT, 0
    DQ OFFSET XDBGKEYXT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGKEYXT
    DQ OFFSET row_XDBGKEYXT
BOOTPTR ENDS
.CODE
XDBGKEYXT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_key_xt
    lea rax, debug_key_xt
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
nm_XDBGINLINE:
    ; DCB "DBG-INLINE", 0
    DB "DBG-INLINE", 0
hl_XDBGINLINE:
    ; DCB "DBG-INLINE ( -- x ) cell after the paused IP", 0
    DB "DBG-INLINE ( -- x ) cell after the paused IP", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGINLINE:
    ; DCQ     nm_XDBGINLINE, hl_XDBGINLINE
    DQ OFFSET nm_XDBGINLINE, OFFSET hl_XDBGINLINE
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGINLINE, 0
    DQ OFFSET XDBGINLINE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGINLINE
    DQ OFFSET row_XDBGINLINE
BOOTPTR ENDS
.CODE
XDBGINLINE:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_inline
    lea rax, debug_inline
    mov QWORD PTR arm_x20, rax
    ; ldr     x20, [x20]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR [r10]
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
nm_XDBGTOSAT:
    ; DCB "DBG-TOS@", 0
    DB "DBG-TOS@", 0
hl_XDBGTOSAT:
    ; DCB "DBG-TOS@ ( -- x ) data TOS at the last pause or 0", 0
    DB "DBG-TOS@ ( -- x ) data TOS at the last pause or 0", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGTOSAT:
    ; DCQ     nm_XDBGTOSAT, hl_XDBGTOSAT
    DQ OFFSET nm_XDBGTOSAT, OFFSET hl_XDBGTOSAT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGTOSAT, 0
    DQ OFFSET XDBGTOSAT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGTOSAT
    DQ OFFSET row_XDBGTOSAT
BOOTPTR ENDS
.CODE
XDBGTOSAT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, debug_scnt
    lea rax, debug_scnt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, dbg_tos_empty
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je dbg_tos_empty
    ; lea x1, debug_sbuf
    lea rax, debug_sbuf
    mov QWORD PTR arm_x1, rax
    ; sub     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    sub rax, 1
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x1, x0, lsl #3]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
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
dbg_tos_empty:
    ; mov     x20, #0
    mov rax, 0
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
nm_XDBGXTAT:
    ; DCB "DBG-XT@", 0
    DB "DBG-XT@", 0
hl_XDBGXTAT:
    ; DCB "DBG-XT@ ( -- xt ) upcoming xt at the last pause", 0
    DB "DBG-XT@ ( -- xt ) upcoming xt at the last pause", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGXTAT:
    ; DCQ     nm_XDBGXTAT, hl_XDBGXTAT
    DQ OFFSET nm_XDBGXTAT, OFFSET hl_XDBGXTAT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGXTAT, 0
    DQ OFFSET XDBGXTAT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGXTAT
    DQ OFFSET row_XDBGXTAT
BOOTPTR ENDS
.CODE
XDBGXTAT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_xt
    lea rax, debug_xt
    mov QWORD PTR arm_x20, rax
    ; ldr     x20, [x20]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR [r10]
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
nm_XDBGIPAT:
    ; DCB "DBG-IP@", 0
    DB "DBG-IP@", 0
hl_XDBGIPAT:
    ; DCB "DBG-IP@ ( -- ip ) paused IP", 0
    DB "DBG-IP@ ( -- ip ) paused IP", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGIPAT:
    ; DCQ     nm_XDBGIPAT, hl_XDBGIPAT
    DQ OFFSET nm_XDBGIPAT, OFFSET hl_XDBGIPAT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGIPAT, 0
    DQ OFFSET XDBGIPAT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGIPAT
    DQ OFFSET row_XDBGIPAT
BOOTPTR ENDS
.CODE
XDBGIPAT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_ip
    lea rax, debug_ip
    mov QWORD PTR arm_x20, rax
    ; ldr     x20, [x20]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR [r10]
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
nm_XDBGCFAAT:
    ; DCB "DBG-CFA@", 0
    DB "DBG-CFA@", 0
hl_XDBGCFAAT:
    ; DCB "DBG-CFA@ ( -- cfa|0 ) enclosing colon at the last pause", 0
    DB "DBG-CFA@ ( -- cfa|0 ) enclosing colon at the last pause", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGCFAAT:
    ; DCQ     nm_XDBGCFAAT, hl_XDBGCFAAT
    DQ OFFSET nm_XDBGCFAAT, OFFSET hl_XDBGCFAAT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGCFAAT, 0
    DQ OFFSET XDBGCFAAT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGCFAAT
    DQ OFFSET row_XDBGCFAAT
BOOTPTR ENDS
.CODE
XDBGCFAAT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_cfa
    lea rax, debug_cfa
    mov QWORD PTR arm_x20, rax
    ; ldr     x20, [x20]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR [r10]
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
nm_XDBGBODYN:
    ; DCB "DBG-BODY#", 0
    DB "DBG-BODY#", 0
hl_XDBGBODYN:
    ; DCB "DBG-BODY# ( -- u ) body cell index of the paused IP", 0
    DB "DBG-BODY# ( -- u ) body cell index of the paused IP", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGBODYN:
    ; DCQ     nm_XDBGBODYN, hl_XDBGBODYN
    DQ OFFSET nm_XDBGBODYN, OFFSET hl_XDBGBODYN
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGBODYN, 0
    DQ OFFSET XDBGBODYN, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGBODYN
    DQ OFFSET row_XDBGBODYN
BOOTPTR ENDS
.CODE
XDBGBODYN:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_body_cells
    lea rax, debug_body_cells
    mov QWORD PTR arm_x20, rax
    ; ldr     x20, [x20]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR [r10]
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
nm_XDBGNEEDINTRO:
    ; DCB "DBG-NEED-INTRO", 0
    DB "DBG-NEED-INTRO", 0
hl_XDBGNEEDINTRO:
    ; DCB "DBG-NEED-INTRO ( -- addr )", 0
    DB "DBG-NEED-INTRO ( -- addr )", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGNEEDINTRO:
    ; DCQ     nm_XDBGNEEDINTRO, hl_XDBGNEEDINTRO
    DQ OFFSET nm_XDBGNEEDINTRO, OFFSET hl_XDBGNEEDINTRO
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGNEEDINTRO, 0
    DQ OFFSET XDBGNEEDINTRO, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGNEEDINTRO
    DQ OFFSET row_XDBGNEEDINTRO
BOOTPTR ENDS
.CODE
XDBGNEEDINTRO:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_need_intro
    lea rax, debug_need_intro
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
nm_XDBGNEEDSTACKS:
    ; DCB "DBG-NEED-STACKS", 0
    DB "DBG-NEED-STACKS", 0
hl_XDBGNEEDSTACKS:
    ; DCB "DBG-NEED-STACKS ( -- addr )", 0
    DB "DBG-NEED-STACKS ( -- addr )", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGNEEDSTACKS:
    ; DCQ     nm_XDBGNEEDSTACKS, hl_XDBGNEEDSTACKS
    DQ OFFSET nm_XDBGNEEDSTACKS, OFFSET hl_XDBGNEEDSTACKS
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGNEEDSTACKS, 0
    DQ OFFSET XDBGNEEDSTACKS, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGNEEDSTACKS
    DQ OFFSET row_XDBGNEEDSTACKS
BOOTPTR ENDS
.CODE
XDBGNEEDSTACKS:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_need_stacks
    lea rax, debug_need_stacks
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
nm_XDBGHELPSHOWN:
    ; DCB "DBG-HELP-SHOWN", 0
    DB "DBG-HELP-SHOWN", 0
hl_XDBGHELPSHOWN:
    ; DCB "DBG-HELP-SHOWN ( -- addr )", 0
    DB "DBG-HELP-SHOWN ( -- addr )", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGHELPSHOWN:
    ; DCQ     nm_XDBGHELPSHOWN, hl_XDBGHELPSHOWN
    DQ OFFSET nm_XDBGHELPSHOWN, OFFSET hl_XDBGHELPSHOWN
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGHELPSHOWN, 0
    DQ OFFSET XDBGHELPSHOWN, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGHELPSHOWN
    DQ OFFSET row_XDBGHELPSHOWN
BOOTPTR ENDS
.CODE
XDBGHELPSHOWN:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_help_shown
    lea rax, debug_help_shown
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
nm_XDBGSKIPNL:
    ; DCB "DBG-SKIP-NL", 0
    DB "DBG-SKIP-NL", 0
hl_XDBGSKIPNL:
    ; DCB "DBG-SKIP-NL ( -- addr )", 0
    DB "DBG-SKIP-NL ( -- addr )", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGSKIPNL:
    ; DCQ     nm_XDBGSKIPNL, hl_XDBGSKIPNL
    DQ OFFSET nm_XDBGSKIPNL, OFFSET hl_XDBGSKIPNL
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGSKIPNL, 0
    DQ OFFSET XDBGSKIPNL, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGSKIPNL
    DQ OFFSET row_XDBGSKIPNL
BOOTPTR ENDS
.CODE
XDBGSKIPNL:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_skip_nl
    lea rax, debug_skip_nl
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
nm_XDBGMIDLINE:
    ; DCB "DBG-MIDLINE", 0
    DB "DBG-MIDLINE", 0
hl_XDBGMIDLINE:
    ; DCB "DBG-MIDLINE ( -- addr )", 0
    DB "DBG-MIDLINE ( -- addr )", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGMIDLINE:
    ; DCQ     nm_XDBGMIDLINE, hl_XDBGMIDLINE
    DQ OFFSET nm_XDBGMIDLINE, OFFSET hl_XDBGMIDLINE
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGMIDLINE, 0
    DQ OFFSET XDBGMIDLINE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGMIDLINE
    DQ OFFSET row_XDBGMIDLINE
BOOTPTR ENDS
.CODE
XDBGMIDLINE:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_midline
    lea rax, debug_midline
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
nm_XDBGLINECOL:
    ; DCB "DBG-LINE-COL", 0
    DB "DBG-LINE-COL", 0
hl_XDBGLINECOL:
    ; DCB "DBG-LINE-COL ( -- addr )", 0
    DB "DBG-LINE-COL ( -- addr )", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGLINECOL:
    ; DCQ     nm_XDBGLINECOL, hl_XDBGLINECOL
    DQ OFFSET nm_XDBGLINECOL, OFFSET hl_XDBGLINECOL
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGLINECOL, 0
    DQ OFFSET XDBGLINECOL, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGLINECOL
    DQ OFFSET row_XDBGLINECOL
BOOTPTR ENDS
.CODE
XDBGLINECOL:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_line_col
    lea rax, debug_line_col
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
nm_XDBGDOTSR:
    ; DCB "DBG-.SR", 0
    DB "DBG-.SR", 0
hl_XDBGDOTSR:
    ; DCB "DBG-.SR ( -- ) pad to the stack column and print S and R", 0
    DB "DBG-.SR ( -- ) pad to the stack column and print S and R", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGDOTSR:
    ; DCQ     nm_XDBGDOTSR, hl_XDBGDOTSR
    DQ OFFSET nm_XDBGDOTSR, OFFSET hl_XDBGDOTSR
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGDOTSR, 0
    DQ OFFSET XDBGDOTSR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGDOTSR
    DQ OFFSET row_XDBGDOTSR
BOOTPTR ENDS
.CODE
XDBGDOTSR:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x23, x24, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x24
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_busy
    lea rax, debug_busy
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, dbg_sr_live
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je dbg_sr_live
    ; lea x0, debug_pause_rsp
    lea rax, debug_pause_rsp
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, dbg_sr_live
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je dbg_sr_live
    ; mov     x23, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x23, rax
dbg_sr_live:
    ; bl      _debug_pad_to_stack_col
    lea rax, xret_3
    mov QWORD PTR arm_x30, rax
    jmp _debug_pad_to_stack_col
    xret_3:
    ; bl      _debug_print_SR
    lea rax, xret_4
    mov QWORD PTR arm_x30, rax
    jmp _debug_print_SR
    xret_4:
    ; ldp     x23, x24, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x23, rax
    mov QWORD PTR arm_x24, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGCURON:
    ; DCB "DBG-CURSOR-ON", 0
    DB "DBG-CURSOR-ON", 0
hl_XDBGCURON:
    ; DCB "DBG-CURSOR-ON ( -- )", 0
    DB "DBG-CURSOR-ON ( -- )", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGCURON:
    ; DCQ     nm_XDBGCURON, hl_XDBGCURON
    DQ OFFSET nm_XDBGCURON, OFFSET hl_XDBGCURON
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGCURON, 0
    DQ OFFSET XDBGCURON, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGCURON
    DQ OFFSET row_XDBGCURON
BOOTPTR ENDS
.CODE
XDBGCURON:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_cursor_on
    lea rax, xret_5
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_on
    xret_5:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGCUROFF:
    ; DCB "DBG-CURSOR-OFF", 0
    DB "DBG-CURSOR-OFF", 0
hl_XDBGCUROFF:
    ; DCB "DBG-CURSOR-OFF ( -- )", 0
    DB "DBG-CURSOR-OFF ( -- )", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGCUROFF:
    ; DCQ     nm_XDBGCUROFF, hl_XDBGCUROFF
    DQ OFFSET nm_XDBGCUROFF, OFFSET hl_XDBGCUROFF
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGCUROFF, 0
    DQ OFFSET XDBGCUROFF, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGCUROFF
    DQ OFFSET row_XDBGCUROFF
BOOTPTR ENDS
.CODE
XDBGCUROFF:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_cursor_off
    lea rax, xret_6
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_6:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGPRINTINL:
    ; DCB "DBG-PRINT-INLINE", 0
    DB "DBG-PRINT-INLINE", 0
hl_XDBGPRINTINL:
    ; DCB "DBG-PRINT-INLINE ( -- ) LIT or branch suffix after the name", 0
    DB "DBG-PRINT-INLINE ( -- ) LIT or branch suffix after the name", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGPRINTINL:
    ; DCQ     nm_XDBGPRINTINL, hl_XDBGPRINTINL
    DQ OFFSET nm_XDBGPRINTINL, OFFSET hl_XDBGPRINTINL
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGPRINTINL, 0
    DQ OFFSET XDBGPRINTINL, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGPRINTINL
    DQ OFFSET row_XDBGPRINTINL
BOOTPTR ENDS
.CODE
XDBGPRINTINL:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_print_inline_suffix
    lea rax, xret_7
    mov QWORD PTR arm_x30, rax
    jmp _debug_print_inline_suffix
    xret_7:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGPRINTNAME:
    ; DCB "DBG-PRINT-NAME", 0
    DB "DBG-PRINT-NAME", 0
hl_XDBGPRINTNAME:
    ; DCB "DBG-PRINT-NAME ( -- ) print the paused xt name", 0
    DB "DBG-PRINT-NAME ( -- ) print the paused xt name", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGPRINTNAME:
    ; DCQ     nm_XDBGPRINTNAME, hl_XDBGPRINTNAME
    DQ OFFSET nm_XDBGPRINTNAME, OFFSET hl_XDBGPRINTNAME
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGPRINTNAME, 0
    DQ OFFSET XDBGPRINTNAME, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGPRINTNAME
    DQ OFFSET row_XDBGPRINTNAME
BOOTPTR ENDS
.CODE
XDBGPRINTNAME:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_xt
    lea rax, debug_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _print_xt_name
    lea rax, xret_8
    mov QWORD PTR arm_x30, rax
    jmp _print_xt_name
    xret_8:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGINTOABLE:
    ; DCB "DBG-XT-INTOABLE?", 0
    DB "DBG-XT-INTOABLE?", 0
hl_XDBGINTOABLE:
    ; DCB "DBG-XT-INTOABLE? ( -- flag ) true when the paused xt can nest", 0
    DB "DBG-XT-INTOABLE? ( -- flag ) true when the paused xt can nest", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGINTOABLE:
    ; DCQ     nm_XDBGINTOABLE, hl_XDBGINTOABLE
    DQ OFFSET nm_XDBGINTOABLE, OFFSET hl_XDBGINTOABLE
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGINTOABLE, 0
    DQ OFFSET XDBGINTOABLE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGINTOABLE
    DQ OFFSET row_XDBGINTOABLE
BOOTPTR ENDS
.CODE
XDBGINTOABLE:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_xt
    lea rax, debug_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _debug_xt_intoable
    lea rax, xret_9
    mov QWORD PTR arm_x30, rax
    jmp _debug_xt_intoable
    xret_9:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGHOSTPAINT:
    ; DCB "DBG-HOST-PAINT", 0
    DB "DBG-HOST-PAINT", 0
hl_XDBGHOSTPAINT:
    ; DCB "DBG-HOST-PAINT ( -- ) refresh the editor debug pane", 0
    DB "DBG-HOST-PAINT ( -- ) refresh the editor debug pane", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGHOSTPAINT:
    ; DCQ     nm_XDBGHOSTPAINT, hl_XDBGHOSTPAINT
    DQ OFFSET nm_XDBGHOSTPAINT, OFFSET hl_XDBGHOSTPAINT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGHOSTPAINT, 0
    DQ OFFSET XDBGHOSTPAINT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGHOSTPAINT
    DQ OFFSET row_XDBGHOSTPAINT
BOOTPTR ENDS
.CODE
XDBGHOSTPAINT:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_debug_paint
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_paint
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGHOSTSPAN:
    ; DCB "DBG-HOST-SPAN", 0
    DB "DBG-HOST-SPAN", 0
hl_XDBGHOSTSPAN:
    ; DCB "DBG-HOST-SPAN ( off len -- ) pending editor highlight span", 0
    DB "DBG-HOST-SPAN ( off len -- ) pending editor highlight span", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGHOSTSPAN:
    ; DCQ     nm_XDBGHOSTSPAN, hl_XDBGHOSTSPAN
    DQ OFFSET nm_XDBGHOSTSPAN, OFFSET hl_XDBGHOSTSPAN
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGHOSTSPAN, 0
    DQ OFFSET XDBGHOSTSPAN, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGHOSTSPAN
    DQ OFFSET row_XDBGHOSTSPAN
BOOTPTR ENDS
.CODE
XDBGHOSTSPAN:
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
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_debug_set_span
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_set_span
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGHOSTSPANAT:
    ; DCB "DBG-HOST-SPAN@", 0
    DB "DBG-HOST-SPAN@", 0
hl_XDBGHOSTSPANAT:
    ; DCB "DBG-HOST-SPAN@ ( -- off len ) peek the pending highlight span", 0
    DB "DBG-HOST-SPAN@ ( -- off len ) peek the pending highlight span", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGHOSTSPANAT:
    ; DCQ     nm_XDBGHOSTSPANAT, hl_XDBGHOSTSPANAT
    DQ OFFSET nm_XDBGHOSTSPANAT, OFFSET hl_XDBGHOSTSPANAT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGHOSTSPANAT, 0
    DQ OFFSET XDBGHOSTSPANAT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGHOSTSPANAT
    DQ OFFSET row_XDBGHOSTSPANAT
BOOTPTR ENDS
.CODE
XDBGHOSTSPANAT:
    ; sub     sp, sp, #32
    mov rax, rsp
    sub rax, 20h
    mov rsp, rax
    ; stp     x29, x30, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; mov     x0, sp
    mov rax, rsp
    mov QWORD PTR arm_x0, rax
    ; add     x1, sp, #8
    mov rax, rsp
    add rax, 8
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [sp]
    lea r10, [rsp]
    mov QWORD PTR [r10], 0
    ; str     xzr, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; bl      host_debug_get_span
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_get_span
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldr     x1, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; ldp     x29, x30, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #32
    mov rax, rsp
    add rax, 20h
    mov rsp, rax
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
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x2
    mov rax, QWORD PTR arm_x2
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
nm_XDBGVIEWUPD:
    ; DCB "DBG-VIEW-UPDATE", 0
    DB "DBG-VIEW-UPDATE", 0
hl_XDBGVIEWUPD:
    ; DCB "DBG-VIEW-UPDATE ( -- ) sync VIEW highlight and paint", 0
    DB "DBG-VIEW-UPDATE ( -- ) sync VIEW highlight and paint", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGVIEWUPD:
    ; DCQ     nm_XDBGVIEWUPD, hl_XDBGVIEWUPD
    DQ OFFSET nm_XDBGVIEWUPD, OFFSET hl_XDBGVIEWUPD
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGVIEWUPD, 0
    DQ OFFSET XDBGVIEWUPD, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGVIEWUPD
    DQ OFFSET row_XDBGVIEWUPD
BOOTPTR ENDS
.CODE
XDBGVIEWUPD:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; stp     x23, x24, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x24
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_sync_view
    lea rax, xret_10
    mov QWORD PTR arm_x30, rax
    jmp _debug_sync_view
    xret_10:
    ; bl      _debug_highlight
    lea rax, xret_11
    mov QWORD PTR arm_x30, rax
    jmp _debug_highlight
    xret_11:
    ; bl      host_debug_paint
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_paint
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldp     x23, x24, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x23, rax
    mov QWORD PTR arm_x24, rcx
    add rsp, 10h
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGWHEELDO:
    ; DCB "DBG-WHEEL-DO", 0
    DB "DBG-WHEEL-DO", 0
hl_XDBGWHEELDO:
    ; DCB "DBG-WHEEL-DO ( u -- ) wheel or resize while paused", 0
    DB "DBG-WHEEL-DO ( u -- ) wheel or resize while paused", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGWHEELDO:
    ; DCQ     nm_XDBGWHEELDO, hl_XDBGWHEELDO
    DQ OFFSET nm_XDBGWHEELDO, OFFSET hl_XDBGWHEELDO
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGWHEELDO, 0
    DQ OFFSET XDBGWHEELDO, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGWHEELDO
    DQ OFFSET row_XDBGWHEELDO
BOOTPTR ENDS
.CODE
XDBGWHEELDO:
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
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; stp     x23, x24, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x24
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_wheel
    lea rax, xret_12
    mov QWORD PTR arm_x30, rax
    jmp _debug_wheel
    xret_12:
    ; ldp     x23, x24, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x23, rax
    mov QWORD PTR arm_x24, rcx
    add rsp, 10h
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGSTEPOVER:
    ; DCB "DBG-STEP-OVER", 0
    DB "DBG-STEP-OVER", 0
hl_XDBGSTEPOVER:
    ; DCB "DBG-STEP-OVER ( -- ) step over a colon word", 0
    DB "DBG-STEP-OVER ( -- ) step over a colon word", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGSTEPOVER:
    ; DCQ     nm_XDBGSTEPOVER, hl_XDBGSTEPOVER
    DQ OFFSET nm_XDBGSTEPOVER, OFFSET hl_XDBGSTEPOVER
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGSTEPOVER, 0
    DQ OFFSET XDBGSTEPOVER, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGSTEPOVER
    DQ OFFSET row_XDBGSTEPOVER
BOOTPTR ENDS
.CODE
XDBGSTEPOVER:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_cursor_off
    lea rax, xret_13
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_13:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_need_stacks
    lea rax, debug_need_stacks
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x1, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x0, debug_xt
    lea rax, debug_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, dbg_over_done
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je dbg_over_done
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; lea x2, DOCOL
    lea rax, DOCOL
    mov QWORD PTR arm_x2, rax
    ; cmp     x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    dbg_over_done
    cmp BYTE PTR arm_z, 0
    je dbg_over_done
    ; lea x0, debug_pause_rsp
    lea rax, debug_pause_rsp
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
dbg_over_done:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGSTEPINTO:
    ; DCB "DBG-STEP-INTO", 0
    DB "DBG-STEP-INTO", 0
hl_XDBGSTEPINTO:
    ; DCB "DBG-STEP-INTO ( -- ) step into the next xt", 0
    DB "DBG-STEP-INTO ( -- ) step into the next xt", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGSTEPINTO:
    ; DCQ     nm_XDBGSTEPINTO, hl_XDBGSTEPINTO
    DQ OFFSET nm_XDBGSTEPINTO, OFFSET hl_XDBGSTEPINTO
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGSTEPINTO, 0
    DQ OFFSET XDBGSTEPINTO, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGSTEPINTO
    DQ OFFSET row_XDBGSTEPINTO
BOOTPTR ENDS
.CODE
XDBGSTEPINTO:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_cursor_off
    lea rax, xret_14
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_14:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_need_stacks
    lea rax, debug_need_stacks
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x1, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGSTEPOUT:
    ; DCB "DBG-STEP-OUT", 0
    DB "DBG-STEP-OUT", 0
hl_XDBGSTEPOUT:
    ; DCB "DBG-STEP-OUT ( -- ) run until this colon returns", 0
    DB "DBG-STEP-OUT ( -- ) run until this colon returns", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGSTEPOUT:
    ; DCQ     nm_XDBGSTEPOUT, hl_XDBGSTEPOUT
    DQ OFFSET nm_XDBGSTEPOUT, OFFSET hl_XDBGSTEPOUT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGSTEPOUT, 0
    DQ OFFSET XDBGSTEPOUT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGSTEPOUT
    DQ OFFSET row_XDBGSTEPOUT
BOOTPTR ENDS
.CODE
XDBGSTEPOUT:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_cursor_off
    lea rax, xret_15
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_15:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_need_stacks
    lea rax, debug_need_stacks
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x1, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_pause_rsp
    lea rax, debug_pause_rsp
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGGO:
    ; DCB "DBG-GO", 0
    DB "DBG-GO", 0
hl_XDBGGO:
    ; DCB "DBG-GO ( -- ) disarm unless a breakpoint or run-to is armed", 0
    DB "DBG-GO ( -- ) disarm unless a breakpoint or run-to is armed", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGGO:
    ; DCQ     nm_XDBGGO, hl_XDBGGO
    DQ OFFSET nm_XDBGGO, OFFSET hl_XDBGGO
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGGO, 0
    DQ OFFSET XDBGGO, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGGO
    DQ OFFSET row_XDBGGO
BOOTPTR ENDS
.CODE
XDBGGO:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_cursor_off
    lea rax, xret_16
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_16:
    ; bl      _debug_clear_step
    lea rax, xret_17
    mov QWORD PTR arm_x30, rax
    jmp _debug_clear_step
    xret_17:
    ; lea x1, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x1, rax
    ; ldr     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, dbg_go_keep
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne dbg_go_keep
    ; lea x1, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR arm_x1, rax
    ; ldr     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, dbg_go_keep
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne dbg_go_keep
    ; mov     x28, #0
    mov rax, 0
    mov QWORD PTR arm_x28, rax
    ; lea x1, debug_armed
    lea rax, debug_armed
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; bl      host_debug_paint
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_paint
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
dbg_go_keep:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XDBGABORT:
    ; DCB "DBG-ABORT-SESSION", 0
    DB "DBG-ABORT-SESSION", 0
hl_XDBGABORT:
    ; DCB "DBG-ABORT-SESSION ( -- ) disarm and THROW -1", 0
    DB "DBG-ABORT-SESSION ( -- ) disarm and THROW -1", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGABORT:
    ; DCQ     nm_XDBGABORT, hl_XDBGABORT
    DQ OFFSET nm_XDBGABORT, OFFSET hl_XDBGABORT
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGABORT, 0
    DQ OFFSET XDBGABORT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGABORT
    DQ OFFSET row_XDBGABORT
BOOTPTR ENDS
.CODE
XDBGABORT:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_cursor_off
    lea rax, xret_18
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_18:
    ; bl      _debug_clear_step
    lea rax, xret_19
    mov QWORD PTR arm_x30, rax
    jmp _debug_clear_step
    xret_19:
    ; lea x0, str_dbg_abort
    lea rax, str_dbg_abort
    mov QWORD PTR arm_x0, rax
    ; bl      _emit_z
    lea rax, xret_20
    mov QWORD PTR arm_x30, rax
    jmp _emit_z
    xret_20:
    ; bl      _debug_disarm
    lea rax, xret_21
    mov QWORD PTR arm_x30, rax
    jmp _debug_disarm
    xret_21:
    ; bl      host_debug_paint
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_paint
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XTDBGARM:
    ; DCB "TDBG-ARM-KEYS", 0
    DB "TDBG-ARM-KEYS", 0
hl_XTDBGARM:
    ; DCB "TDBG-ARM-KEYS ( -- ) arm the host debug-key steal", 0
    DB "TDBG-ARM-KEYS ( -- ) arm the host debug-key steal", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTDBGARM:
    ; DCQ     nm_XTDBGARM, hl_XTDBGARM
    DQ OFFSET nm_XTDBGARM, OFFSET hl_XTDBGARM
    ; DCQ     0
    DQ 0
    ; DCQ     XTDBGARM, 0
    DQ OFFSET XTDBGARM, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTDBGARM
    DQ OFFSET row_XTDBGARM
BOOTPTR ENDS
.CODE
XTDBGARM:
    ; lea x0, tdebug_armed
    lea rax, tdebug_armed
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
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
nm_XTDBGDISARM:
    ; DCB "TDBG-DISARM-KEYS", 0
    DB "TDBG-DISARM-KEYS", 0
hl_XTDBGDISARM:
    ; DCB "TDBG-DISARM-KEYS ( -- ) disarm the host debug-key steal", 0
    DB "TDBG-DISARM-KEYS ( -- ) disarm the host debug-key steal", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTDBGDISARM:
    ; DCQ     nm_XTDBGDISARM, hl_XTDBGDISARM
    DQ OFFSET nm_XTDBGDISARM, OFFSET hl_XTDBGDISARM
    ; DCQ     0
    DQ 0
    ; DCQ     XTDBGDISARM, 0
    DQ OFFSET XTDBGDISARM, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTDBGDISARM
    DQ OFFSET row_XTDBGDISARM
BOOTPTR ENDS
.CODE
XTDBGDISARM:
    ; lea x0, tdebug_armed
    lea rax, tdebug_armed
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
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
nm_XDBGBREAKMIN:
    ; DCB "DBG-BREAK-MIN!", 0
    DB "DBG-BREAK-MIN!", 0
hl_XDBGBREAKMIN:
    ; DCB "DBG-BREAK-MIN! ( addr -- ) low water for Break ASAP", 0
    DB "DBG-BREAK-MIN! ( addr -- ) low water for Break ASAP", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGBREAKMIN:
    ; DCQ     nm_XDBGBREAKMIN, hl_XDBGBREAKMIN
    DQ OFFSET nm_XDBGBREAKMIN, OFFSET hl_XDBGBREAKMIN
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGBREAKMIN, 0
    DQ OFFSET XDBGBREAKMIN, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGBREAKMIN
    DQ OFFSET row_XDBGBREAKMIN
BOOTPTR ENDS
.CODE
XDBGBREAKMIN:
    ; lea x0, debug_break_min_cfa
    lea rax, debug_break_min_cfa
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
nm_XDBGON:
    ; DCB "DBG-ON", 0
    DB "DBG-ON", 0
hl_XDBGON:
    ; DCB "DBG-ON ( -- ) arm the NEXT stepper", 0
    DB "DBG-ON ( -- ) arm the NEXT stepper", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGON:
    ; DCQ     nm_XDBGON, hl_XDBGON
    DQ OFFSET nm_XDBGON, OFFSET hl_XDBGON
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGON, 0
    DQ OFFSET XDBGON, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGON
    DQ OFFSET row_XDBGON
BOOTPTR ENDS
.CODE
XDBGON:
    ; lea x0, debug_floor
    lea rax, debug_floor
    mov QWORD PTR arm_x0, rax
    ; str     x23, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10], rax
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; mov     x28, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x28, rax
    ; lea x0, debug_armed
    lea rax, debug_armed
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x0, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_runto_off
    lea rax, debug_runto_off
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_runto_status
    lea rax, debug_runto_status
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_abort
    lea rax, debug_abort
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_view_cfa
    lea rax, debug_view_cfa
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_skip_nl
    lea rax, debug_skip_nl
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x0, debug_midline
    lea rax, debug_midline
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_help_shown
    lea rax, debug_help_shown
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_cursor_on
    lea rax, debug_cursor_on
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_need_stacks
    lea rax, debug_need_stacks
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_need_intro
    lea rax, debug_need_intro
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x0, debug_line_col
    lea rax, debug_line_col
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_stack_anchor
    lea rax, debug_stack_anchor
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_ip
    lea rax, debug_ip
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_cfa
    lea rax, debug_cfa
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_body_cells
    lea rax, debug_body_cells
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_call_depth
    lea rax, debug_call_depth
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
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
nm_XDBGOFF:
    ; DCB "DBG-OFF", 0
    DB "DBG-OFF", 0
hl_XDBGOFF:
    ; DCB "DBG-OFF ( -- ) disarm the NEXT stepper", 0
    DB "DBG-OFF ( -- ) disarm the NEXT stepper", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDBGOFF:
    ; DCQ     nm_XDBGOFF, hl_XDBGOFF
    DQ OFFSET nm_XDBGOFF, OFFSET hl_XDBGOFF
    ; DCQ     0
    DQ 0
    ; DCQ     XDBGOFF, 0
    DQ OFFSET XDBGOFF, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDBGOFF
    DQ OFFSET row_XDBGOFF
BOOTPTR ENDS
.CODE
XDBGOFF:
    ; mov     x28, #0
    mov rax, 0
    mov QWORD PTR arm_x28, rax
    ; lea x0, debug_armed
    lea rax, debug_armed
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_call_depth
    lea rax, debug_call_depth
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_midline
    lea rax, debug_midline
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_help_shown
    lea rax, debug_help_shown
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_cursor_on
    lea rax, debug_cursor_on
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_need_stacks
    lea rax, debug_need_stacks
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_need_intro
    lea rax, debug_need_intro
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_line_col
    lea rax, debug_line_col
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_stack_anchor
    lea rax, debug_stack_anchor
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_ip
    lea rax, debug_ip
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_cfa
    lea rax, debug_cfa
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_body_cells
    lea rax, debug_body_cells
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_floor
    lea rax, debug_floor
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_runto_off
    lea rax, debug_runto_off
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_runto_status
    lea rax, debug_runto_status
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_abort
    lea rax, debug_abort
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_view_cfa
    lea rax, debug_view_cfa
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_debug_paint
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_paint
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; lea x0, str_dbg_done
    lea rax, str_dbg_done
    mov QWORD PTR arm_x0, rax
    ; bl      _emit_z
    lea rax, xret_22
    mov QWORD PTR arm_x30, rax
    jmp _emit_z
    xret_22:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
nm_XBREAK_TABLE:
    ; DCB "BREAK-TABLE", 0
    DB "BREAK-TABLE", 0
hl_XBREAK_TABLE:
    ; DCB "BREAK-TABLE ( -- addr ) 8 breakpoint xt slots", 0
    DB "BREAK-TABLE ( -- addr ) 8 breakpoint xt slots", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBREAK_TABLE:
    ; DCQ     nm_XBREAK_TABLE, hl_XBREAK_TABLE
    DQ OFFSET nm_XBREAK_TABLE, OFFSET hl_XBREAK_TABLE
    ; DCQ     0
    DQ 0
    ; DCQ     XBREAK_TABLE, 0
    DQ OFFSET XBREAK_TABLE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBREAK_TABLE
    DQ OFFSET row_XBREAK_TABLE
BOOTPTR ENDS
.CODE
XBREAK_TABLE:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_bp_xts
    lea rax, debug_bp_xts
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
nm_XBREAK_ENABLES:
    ; DCB "BREAK-ENABLES", 0
    DB "BREAK-ENABLES", 0
hl_XBREAK_ENABLES:
    ; DCB "BREAK-ENABLES ( -- addr ) 8 breakpoint enable flags", 0
    DB "BREAK-ENABLES ( -- addr ) 8 breakpoint enable flags", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBREAK_ENABLES:
    ; DCQ     nm_XBREAK_ENABLES, hl_XBREAK_ENABLES
    DQ OFFSET nm_XBREAK_ENABLES, OFFSET hl_XBREAK_ENABLES
    ; DCQ     0
    DQ 0
    ; DCQ     XBREAK_ENABLES, 0
    DQ OFFSET XBREAK_ENABLES, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBREAK_ENABLES
    DQ OFFSET row_XBREAK_ENABLES
BOOTPTR ENDS
.CODE
XBREAK_ENABLES:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_bp_en
    lea rax, debug_bp_en
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
nm_XBPGO:
    ; DCB "(BP-GO)", 0
    DB "(BP-GO)", 0
hl_XBPGO:
    ; DCB "(BP-GO) ( -- ) run until an enabled breakpoint xt", 0
    DB "(BP-GO) ( -- ) run until an enabled breakpoint xt", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBPGO:
    ; DCQ     nm_XBPGO, hl_XBPGO
    DQ OFFSET nm_XBPGO, OFFSET hl_XBPGO
    ; DCQ     0
    DQ 0
    ; DCQ     XBPGO, 0
    DQ OFFSET XBPGO, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBPGO
    DQ OFFSET row_XBPGO
BOOTPTR ENDS
.CODE
XBPGO:
    ; lea x0, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
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
nm_XRUNTOIP:
    ; DCB "(RUNTO-IP)", 0
    DB "(RUNTO-IP)", 0
hl_XRUNTOIP:
    ; DCB "(RUNTO-IP) ( addr -- ) arm run-to at a threaded cell", 0
    DB "(RUNTO-IP) ( addr -- ) arm run-to at a threaded cell", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRUNTOIP:
    ; DCQ     nm_XRUNTOIP, hl_XRUNTOIP
    DQ OFFSET nm_XRUNTOIP, OFFSET hl_XRUNTOIP
    ; DCQ     0
    DQ 0
    ; DCQ     XRUNTOIP, 0
    DQ OFFSET XRUNTOIP, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRUNTOIP
    DQ OFFSET row_XRUNTOIP
BOOTPTR ENDS
.CODE
XRUNTOIP:
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
    ; lea x1, debug_runto_ip
    lea rax, debug_runto_ip
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
nm_XRUNTOOFFAT:
    ; DCB "RUNTO-OFF@", 0
    DB "RUNTO-OFF@", 0
hl_XRUNTOOFFAT:
    ; DCB "RUNTO-OFF@ ( -- off ) pending file offset for run-to", 0
    DB "RUNTO-OFF@ ( -- off ) pending file offset for run-to", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRUNTOOFFAT:
    ; DCQ     nm_XRUNTOOFFAT, hl_XRUNTOOFFAT
    DQ OFFSET nm_XRUNTOOFFAT, OFFSET hl_XRUNTOOFFAT
    ; DCQ     0
    DQ 0
    ; DCQ     XRUNTOOFFAT, 0
    DQ OFFSET XRUNTOOFFAT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRUNTOOFFAT
    DQ OFFSET row_XRUNTOOFFAT
BOOTPTR ENDS
.CODE
XRUNTOOFFAT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, debug_runto_off
    lea rax, debug_runto_off
    mov QWORD PTR arm_x20, rax
    ; ldr     x20, [x20]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR [r10]
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
nm_XRUNTOSTAT:
    ; DCB "RUNTO-STATUS!", 0
    DB "RUNTO-STATUS!", 0
hl_XRUNTOSTAT:
    ; DCB "RUNTO-STATUS! ( n -- ) store the host run-to status", 0
    DB "RUNTO-STATUS! ( n -- ) store the host run-to status", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRUNTOSTAT:
    ; DCQ     nm_XRUNTOSTAT, hl_XRUNTOSTAT
    DQ OFFSET nm_XRUNTOSTAT, OFFSET hl_XRUNTOSTAT
    ; DCQ     0
    DQ 0
    ; DCQ     XRUNTOSTAT, 0
    DQ OFFSET XRUNTOSTAT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRUNTOSTAT
    DQ OFFSET row_XRUNTOSTAT
BOOTPTR ENDS
.CODE
XRUNTOSTAT:
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
    ; lea x1, debug_runto_status
    lea rax, debug_runto_status
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
nm_XVIEW_PATH:
    ; DCB "VIEW-PATH", 0
    DB "VIEW-PATH", 0
hl_XVIEW_PATH:
    ; DCB "VIEW-PATH ( id -- c-addr u | 0 0 ) path for a VIEW file id", 0
    DB "VIEW-PATH ( id -- c-addr u | 0 0 ) path for a VIEW file id", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XVIEW_PATH:
    ; DCQ     nm_XVIEW_PATH, hl_XVIEW_PATH
    DQ OFFSET nm_XVIEW_PATH, OFFSET hl_XVIEW_PATH
    ; DCQ     0
    DQ 0
    ; DCQ     XVIEW_PATH, 0
    DQ OFFSET XVIEW_PATH, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XVIEW_PATH
    DQ OFFSET row_XVIEW_PATH
BOOTPTR ENDS
.CODE
XVIEW_PATH:
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, view_path_none
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je view_path_none
    ; lea x0, view_file_n
    lea rax, view_file_n
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    view_path_none
    cmp BYTE PTR arm_c, 0
    je xsk_23
    cmp BYTE PTR arm_z, 0
    je view_path_none
    xsk_23:
    ; sub     x2, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #VIEW_PATH_MAX
    mov rax, 100h
    mov QWORD PTR arm_x3, rax
    ; mul     x2, x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    imul rax, rcx
    mov QWORD PTR arm_x2, rax
    ; lea x0, view_paths
    lea rax, view_paths
    mov QWORD PTR arm_x0, rax
    ; add     x0, x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; ldrb    w2, [x0]
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; add     x3, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; mov     x20, x2
    mov rax, QWORD PTR arm_x2
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
view_path_none:
    ; str     xzr, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov QWORD PTR [r10], 0
    ; mov     x20, #0
    mov rax, 0
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
nm_XVIEW_REG:
    ; DCB "VIEW-REG", 0
    DB "VIEW-REG", 0
hl_XVIEW_REG:
    ; DCB "VIEW-REG ( c-addr u -- id ) register a source path for VIEW", 0
    DB "VIEW-REG ( c-addr u -- id ) register a source path for VIEW", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XVIEW_REG:
    ; DCQ     nm_XVIEW_REG, hl_XVIEW_REG
    DQ OFFSET nm_XVIEW_REG, OFFSET hl_XVIEW_REG
    ; DCQ     0
    DQ 0
    ; DCQ     XVIEW_REG, 0
    DQ OFFSET XVIEW_REG, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XVIEW_REG
    DQ OFFSET row_XVIEW_REG
BOOTPTR ENDS
.CODE
XVIEW_REG:
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
    ; cmp     x1, #0
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.le    view_reg_fail
    cmp BYTE PTR arm_z, 0
    jne view_reg_fail
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne view_reg_fail
    ; cmp     x1, #255
    mov rax, QWORD PTR arm_x1
    cmp rax, 0FFh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    view_reg_fail
    cmp BYTE PTR arm_c, 0
    je xsk_24
    cmp BYTE PTR arm_z, 0
    je view_reg_fail
    xsk_24:
    ; cbz     x0, view_reg_fail
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je view_reg_fail
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; bl      _view_register_path
    lea rax, xret_25
    mov QWORD PTR arm_x30, rax
    jmp _view_register_path
    xret_25:
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
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
view_reg_fail:
    ; mov     x20, #0
    mov rax, 0
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
nm_XVIEW_STAMP:
    ; DCB "VIEW-STAMP", 0
    DB "VIEW-STAMP", 0
hl_XVIEW_STAMP:
    ; DCB "VIEW-STAMP ( xt file-id line -- ) set the source VIEW in the header", 0
    DB "VIEW-STAMP ( xt file-id line -- ) set the source VIEW in the header", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XVIEW_STAMP:
    ; DCQ     nm_XVIEW_STAMP, hl_XVIEW_STAMP
    DQ OFFSET nm_XVIEW_STAMP, OFFSET hl_XVIEW_STAMP
    ; DCQ     0
    DQ 0
    ; DCQ     XVIEW_STAMP, 0
    DQ OFFSET XVIEW_STAMP, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XVIEW_STAMP
    DQ OFFSET row_XVIEW_STAMP
BOOTPTR ENDS
.CODE
XVIEW_STAMP:
    ; mov     x3, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x3, rax
    ; ldr     x2, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x1, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
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
    ; cbz     x1, view_stamp_done
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je view_stamp_done
    ; ldr     x0, [x1, #-8]
    mov r10, QWORD PTR arm_x1
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; mov     x4, #0xFFFF
    mov rax, 0FFFFh
    mov QWORD PTR arm_x4, rax
    ; lsl     x4, x4, #32
    mov rax, QWORD PTR arm_x4
    shl rax, 32
    mov QWORD PTR arm_x4, rax
    ; bic     x0, x0, x4
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x4
    not rcx
    and rax, rcx
    mov QWORD PTR arm_x0, rax
    ; mov     x4, #VIEW_FILE_MASK
    mov rax, 1FFFh
    mov QWORD PTR arm_x4, rax
    ; lsl     x4, x4, #48
    mov rax, QWORD PTR arm_x4
    shl rax, 48
    mov QWORD PTR arm_x4, rax
    ; bic     x0, x0, x4
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x4
    not rcx
    and rax, rcx
    mov QWORD PTR arm_x0, rax
    ; and     x3, x3, #0xFFFF
    mov rax, QWORD PTR arm_x3
    and rax, 0FFFFh
    mov QWORD PTR arm_x3, rax
    ; lsl     x3, x3, #32
    mov rax, QWORD PTR arm_x3
    shl rax, 32
    mov QWORD PTR arm_x3, rax
    ; orr     x0, x0, x3
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x3
    or rax, rcx
    mov QWORD PTR arm_x0, rax
    ; mov     x4, #VIEW_FILE_MASK
    mov rax, 1FFFh
    mov QWORD PTR arm_x4, rax
    ; and     x2, x2, x4
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x4
    and rax, rcx
    mov QWORD PTR arm_x2, rax
    ; lsl     x2, x2, #48
    mov rax, QWORD PTR arm_x2
    shl rax, 48
    mov QWORD PTR arm_x2, rax
    ; orr     x0, x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    or rax, rcx
    mov QWORD PTR arm_x0, rax
    ; str     x0, [x1, #-8]
    mov r10, QWORD PTR arm_x1
    add r10, -8
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
view_stamp_done:
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
_debug_pause:
    ; stp     x29, x30, [sp, #-64]!
    add rsp, -64
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; stp     x23, x24, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x24
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_pause_rsp
    lea rax, debug_pause_rsp
    mov QWORD PTR arm_x0, rax
    ; str     x23, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10], rax
    ; lea x0, debug_xt
    lea rax, debug_xt
    mov QWORD PTR arm_x0, rax
    ; str     x21, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10], rax
    ; ldr     x0, [x19, #8]
    mov r10, QWORD PTR arm_x19
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; lea x1, debug_inline
    lea rax, debug_inline
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x0, debug_ip
    lea rax, debug_ip
    mov QWORD PTR arm_x0, rax
    ; str     x19, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10], rax
    ; mov     x0, x19
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x21
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR arm_x1, rax
    ; bl      _debug_resolve_enclosing
    lea rax, xret_26
    mov QWORD PTR arm_x30, rax
    jmp _debug_resolve_enclosing
    xret_26:
    ; lea x2, debug_cfa
    lea rax, debug_cfa
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lsr     x1, x1, #3
    mov rax, QWORD PTR arm_x1
    shr rax, 3
    mov QWORD PTR arm_x1, rax
    ; lea x2, debug_body_cells
    lea rax, debug_body_cells
    mov QWORD PTR arm_x2, rax
    ; str     x1, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x0, tw_continue_cell
    lea rax, tw_continue_cell
    mov QWORD PTR arm_x0, rax
    ; cmp     x19, x0
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_leave
    cmp BYTE PTR arm_z, 0
    jne pause_leave
    ; lea x0, debug_pause_xt
    lea rax, debug_pause_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, pause_asm
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je pause_asm
    ; bl      _debug_capture
    lea rax, xret_27
    mov QWORD PTR arm_x30, rax
    jmp _debug_capture
    xret_27:
    ; lea x0, debug_pause_xt
    lea rax, debug_pause_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _debug_call_xt
    lea rax, xret_28
    mov QWORD PTR arm_x30, rax
    jmp _debug_call_xt
    xret_28:
    ; b       pause_leave
    jmp pause_leave
pause_asm:
    ; lea x0, debug_need_intro
    lea rax, debug_need_intro
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, pause_after
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je pause_after
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; bl      _debug_end_line
    lea rax, xret_29
    mov QWORD PTR arm_x30, rax
    jmp _debug_end_line
    xret_29:
    ; lea x0, str_dbg_keys
    lea rax, str_dbg_keys
    mov QWORD PTR arm_x0, rax
    ; bl      _emit_z
    lea rax, xret_30
    mov QWORD PTR arm_x30, rax
    jmp _emit_z
    xret_30:
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_31
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_31:
    ; bl      _debug_pad_to_stack_col
    lea rax, xret_32
    mov QWORD PTR arm_x30, rax
    jmp _debug_pad_to_stack_col
    xret_32:
    ; bl      _debug_print_SR
    lea rax, xret_33
    mov QWORD PTR arm_x30, rax
    jmp _debug_print_SR
    xret_33:
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_34
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_34:
    ; b       pause_word
    jmp pause_word
pause_after:
    ; lea x0, debug_need_stacks
    lea rax, debug_need_stacks
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, pause_word
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je pause_word
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_help_shown
    lea rax, debug_help_shown
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, pause_pad_sr
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je pause_pad_sr
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_35
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_35:
pause_pad_sr:
    ; bl      _debug_pad_to_stack_col
    lea rax, xret_36
    mov QWORD PTR arm_x30, rax
    jmp _debug_pad_to_stack_col
    xret_36:
    ; bl      _debug_print_SR
    lea rax, xret_37
    mov QWORD PTR arm_x30, rax
    jmp _debug_print_SR
    xret_37:
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_38
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_38:
pause_word:
    ; lea x0, debug_line_col
    lea rax, debug_line_col
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; mov     x0, x21
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR arm_x0, rax
    ; bl      _debug_xt_intoable
    lea rax, xret_39
    mov QWORD PTR arm_x30, rax
    jmp _debug_xt_intoable
    xret_39:
    ; cbz     x0, pause_chevrons
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je pause_chevrons
    ; mov     x0, #'I'
    mov rax, 49h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_40
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_40:
pause_chevrons:
    ; mov     x0, #62
    mov rax, 3Eh
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_41
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_41:
    ; mov     x0, #62
    mov rax, 3Eh
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_42
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_42:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_43
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_43:
    ; mov     x0, x21
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR arm_x0, rax
    ; bl      _print_xt_name
    lea rax, xret_44
    mov QWORD PTR arm_x30, rax
    jmp _print_xt_name
    xret_44:
    ; bl      _debug_print_inline_suffix
    lea rax, xret_45
    mov QWORD PTR arm_x30, rax
    jmp _debug_print_inline_suffix
    xret_45:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_46
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_46:
    ; bl      _debug_cursor_on
    lea rax, xret_47
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_on
    xret_47:
    ; bl      _debug_capture
    lea rax, xret_48
    mov QWORD PTR arm_x30, rax
    jmp _debug_capture
    xret_48:
    ; bl      _debug_sync_view
    lea rax, xret_49
    mov QWORD PTR arm_x30, rax
    jmp _debug_sync_view
    xret_49:
    ; bl      _debug_highlight
    lea rax, xret_50
    mov QWORD PTR arm_x30, rax
    jmp _debug_highlight
    xret_50:
    ; bl      host_debug_paint
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_paint
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
pause_key:
    ; bl      _getchar
    lea rax, xret_51
    mov QWORD PTR arm_x30, rax
    jmp _getchar
    xret_51:
    ; tbnz    x0, #63, pause_key_abort
    mov rax, QWORD PTR arm_x0
    bt rax, 63
    jc pause_key_abort
    ; lea x2, debug_key_xt
    lea rax, debug_key_xt
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, pause_asm_key
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je pause_asm_key
    ; lea x1, debug_key_raw
    lea rax, debug_key_raw
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; bl      _debug_ds_isolate
    lea rax, xret_52
    mov QWORD PTR arm_x30, rax
    jmp _debug_ds_isolate
    xret_52:
    ; lea x1, debug_key_raw
    lea rax, debug_key_raw
    mov QWORD PTR arm_x1, rax
    ; ldr     x20, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; lea x0, debug_key_xt
    lea rax, debug_key_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _debug_call_xt
    lea rax, xret_53
    mov QWORD PTR arm_x30, rax
    jmp _debug_call_xt
    xret_53:
    ; lea x1, debug_call_tos
    lea rax, debug_call_tos
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_key_mode
    lea rax, debug_key_mode
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; bl      _debug_ds_restore
    lea rax, xret_54
    mov QWORD PTR arm_x30, rax
    jmp _debug_ds_restore
    xret_54:
    ; lea x0, debug_key_mode
    lea rax, debug_key_mode
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, pause_key
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je pause_key
    ; cmp     x0, #1
    mov rax, QWORD PTR arm_x0
    cmp rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_over
    cmp BYTE PTR arm_z, 0
    jne pause_over
    ; cmp     x0, #2
    mov rax, QWORD PTR arm_x0
    cmp rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_into
    cmp BYTE PTR arm_z, 0
    jne pause_into
    ; cmp     x0, #3
    mov rax, QWORD PTR arm_x0
    cmp rax, 3
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_out
    cmp BYTE PTR arm_z, 0
    jne pause_out
    ; cmp     x0, #4
    mov rax, QWORD PTR arm_x0
    cmp rax, 4
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_go
    cmp BYTE PTR arm_z, 0
    jne pause_go
    ; cmp     x0, #5
    mov rax, QWORD PTR arm_x0
    cmp rax, 5
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_key_abort
    cmp BYTE PTR arm_z, 0
    jne pause_key_abort
    ; cmp     x0, #6
    mov rax, QWORD PTR arm_x0
    cmp rax, 6
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_wheel_key
    cmp BYTE PTR arm_z, 0
    jne pause_wheel_key
    ; cmp     x0, #7
    mov rax, QWORD PTR arm_x0
    cmp rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_help
    cmp BYTE PTR arm_z, 0
    jne pause_help
    ; lea x0, debug_key_raw
    lea rax, debug_key_raw
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
pause_asm_key:
    ; lsr     x1, x0, #24
    mov rax, QWORD PTR arm_x0
    shr rax, 24
    mov QWORD PTR arm_x1, rax
    ; and     x1, x1, #0xFF
    mov rax, QWORD PTR arm_x1
    and rax, 0FFh
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, #2
    mov rax, QWORD PTR arm_x1
    cmp rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    pause_not_fkey
    cmp BYTE PTR arm_z, 0
    je pause_not_fkey
    ; mov     x2, #0xFFFFFF
    mov rax, 0FFFFFFh
    mov QWORD PTR arm_x2, rax
    ; and     x0, x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    and rax, rcx
    mov QWORD PTR arm_x0, rax
    ; cmp     x0, #16
    mov rax, QWORD PTR arm_x0
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_over
    cmp BYTE PTR arm_z, 0
    jne pause_over
    ; cmp     x0, #17
    mov rax, QWORD PTR arm_x0
    cmp rax, 11h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_into
    cmp BYTE PTR arm_z, 0
    jne pause_into
    ; cmp     x0, #18
    mov rax, QWORD PTR arm_x0
    cmp rax, 12h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_out
    cmp BYTE PTR arm_z, 0
    jne pause_out
    ; b       pause_key
    jmp pause_key
pause_not_fkey:
    ; cmp     x1, #1
    mov rax, QWORD PTR arm_x1
    cmp rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    pause_plain
    cmp BYTE PTR arm_z, 0
    je pause_plain
    ; mov     x2, #0x1FFFFF
    mov rax, 1FFFFFh
    mov QWORD PTR arm_x2, rax
    ; and     x0, x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    and rax, rcx
    mov QWORD PTR arm_x0, rax
pause_plain:
    ; lea x1, debug_skip_nl
    lea rax, debug_skip_nl
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, pause_take
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je pause_take
    ; cmp     w0, #10
    mov eax, DWORD PTR arm_x0
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_key
    cmp BYTE PTR arm_z, 0
    jne pause_key
    ; cmp     w0, #13
    mov eax, DWORD PTR arm_x0
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_key
    cmp BYTE PTR arm_z, 0
    jne pause_key
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
pause_take:
    ; cmp     w0, #'h'
    mov eax, DWORD PTR arm_x0
    cmp eax, 68h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_help
    cmp BYTE PTR arm_z, 0
    jne pause_help
    ; cmp     w0, #'H'
    mov eax, DWORD PTR arm_x0
    cmp eax, 48h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_help
    cmp BYTE PTR arm_z, 0
    jne pause_help
    ; cmp     w0, #134
    mov eax, DWORD PTR arm_x0
    cmp eax, 86h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_go
    cmp BYTE PTR arm_z, 0
    jne pause_go
    ; cmp     w0, #'g'
    mov eax, DWORD PTR arm_x0
    cmp eax, 67h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_go
    cmp BYTE PTR arm_z, 0
    jne pause_go
    ; cmp     w0, #'G'
    mov eax, DWORD PTR arm_x0
    cmp eax, 47h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_go
    cmp BYTE PTR arm_z, 0
    jne pause_go
    ; cmp     w0, #27
    mov eax, DWORD PTR arm_x0
    cmp eax, 1Bh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_key_abort
    cmp BYTE PTR arm_z, 0
    jne pause_key_abort
    ; cmp     w0, #'q'
    mov eax, DWORD PTR arm_x0
    cmp eax, 71h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_key_abort
    cmp BYTE PTR arm_z, 0
    jne pause_key_abort
    ; cmp     w0, #'Q'
    mov eax, DWORD PTR arm_x0
    cmp eax, 51h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_key_abort
    cmp BYTE PTR arm_z, 0
    jne pause_key_abort
    ; cmp     w0, #32
    mov eax, DWORD PTR arm_x0
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_over
    cmp BYTE PTR arm_z, 0
    jne pause_over
    ; cmp     w0, #13
    mov eax, DWORD PTR arm_x0
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_over
    cmp BYTE PTR arm_z, 0
    jne pause_over
    ; cmp     w0, #'o'
    mov eax, DWORD PTR arm_x0
    cmp eax, 6Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_over
    cmp BYTE PTR arm_z, 0
    jne pause_over
    ; cmp     w0, #'O'
    mov eax, DWORD PTR arm_x0
    cmp eax, 4Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_over
    cmp BYTE PTR arm_z, 0
    jne pause_over
    ; cmp     w0, #'i'
    mov eax, DWORD PTR arm_x0
    cmp eax, 69h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_into
    cmp BYTE PTR arm_z, 0
    jne pause_into
    ; cmp     w0, #'I'
    mov eax, DWORD PTR arm_x0
    cmp eax, 49h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_into
    cmp BYTE PTR arm_z, 0
    jne pause_into
    ; cmp     w0, #'u'
    mov eax, DWORD PTR arm_x0
    cmp eax, 75h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_out
    cmp BYTE PTR arm_z, 0
    jne pause_out
    ; cmp     w0, #'U'
    mov eax, DWORD PTR arm_x0
    cmp eax, 55h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_out
    cmp BYTE PTR arm_z, 0
    jne pause_out
    ; cmp     w0, #3
    mov eax, DWORD PTR arm_x0
    cmp eax, 3
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_wheel_raw
    cmp BYTE PTR arm_z, 0
    jne pause_wheel_raw
    ; cmp     w0, #7
    mov eax, DWORD PTR arm_x0
    cmp eax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pause_wheel_raw
    cmp BYTE PTR arm_z, 0
    jne pause_wheel_raw
    ; cbz     w0, pause_wheel_raw
    mov eax, DWORD PTR arm_x0
    cmp rax, 0
    je pause_wheel_raw
    ; b       pause_key
    jmp pause_key
pause_help:
    ; lea x1, debug_help_shown
    lea rax, debug_help_shown
    mov QWORD PTR arm_x1, rax
    ; ldr     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, pause_key
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne pause_key
    ; bl      _debug_cursor_off
    lea rax, xret_55
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_55:
    ; lea x0, str_dbg_keys
    lea rax, str_dbg_keys
    mov QWORD PTR arm_x0, rax
    ; bl      _emit_z
    lea rax, xret_56
    mov QWORD PTR arm_x30, rax
    jmp _emit_z
    xret_56:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_help_shown
    lea rax, debug_help_shown
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; bl      _debug_cursor_on
    lea rax, xret_57
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_on
    xret_57:
    ; b       pause_key
    jmp pause_key
pause_wheel_key:
    ; lea x0, debug_key_raw
    lea rax, debug_key_raw
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
pause_wheel_raw:
    ; bl      _debug_wheel
    lea rax, xret_58
    mov QWORD PTR arm_x30, rax
    jmp _debug_wheel
    xret_58:
    ; b       pause_key
    jmp pause_key
pause_over:
    ; bl      _debug_cursor_off
    lea rax, xret_59
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_59:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_need_stacks
    lea rax, debug_need_stacks
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x1, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x0, debug_xt
    lea rax, debug_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, pause_leave
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je pause_leave
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; lea x2, DOCOL
    lea rax, DOCOL
    mov QWORD PTR arm_x2, rax
    ; cmp     x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    pause_leave
    cmp BYTE PTR arm_z, 0
    je pause_leave
    ; str     x23, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10], rax
    ; b       pause_leave
    jmp pause_leave
pause_into:
    ; bl      _debug_cursor_off
    lea rax, xret_60
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_60:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_need_stacks
    lea rax, debug_need_stacks
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x1, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; b       pause_leave
    jmp pause_leave
pause_out:
    ; bl      _debug_cursor_off
    lea rax, xret_61
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_61:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_need_stacks
    lea rax, debug_need_stacks
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x1, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x1, rax
    ; str     x23, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10], rax
    ; b       pause_leave
    jmp pause_leave
pause_key_abort:
    ; bl      _debug_cursor_off
    lea rax, xret_62
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_62:
    ; bl      _debug_clear_step
    lea rax, xret_63
    mov QWORD PTR arm_x30, rax
    jmp _debug_clear_step
    xret_63:
    ; lea x0, str_dbg_abort
    lea rax, str_dbg_abort
    mov QWORD PTR arm_x0, rax
    ; bl      _emit_z
    lea rax, xret_64
    mov QWORD PTR arm_x30, rax
    jmp _emit_z
    xret_64:
    ; bl      _debug_disarm
    lea rax, xret_65
    mov QWORD PTR arm_x30, rax
    jmp _debug_disarm
    xret_65:
    ; bl      host_debug_paint
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_paint
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; b       pause_leave
    jmp pause_leave
pause_go:
    ; bl      _debug_cursor_off
    lea rax, xret_66
    mov QWORD PTR arm_x30, rax
    jmp _debug_cursor_off
    xret_66:
    ; bl      _debug_clear_step
    lea rax, xret_67
    mov QWORD PTR arm_x30, rax
    jmp _debug_clear_step
    xret_67:
    ; lea x1, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x1, rax
    ; ldr     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, pause_leave
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne pause_leave
    ; lea x1, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR arm_x1, rax
    ; ldr     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, pause_leave
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne pause_leave
    ; mov     x28, #0
    mov rax, 0
    mov QWORD PTR arm_x28, rax
    ; lea x1, debug_armed
    lea rax, debug_armed
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; bl      host_debug_paint
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_paint
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
pause_leave:
    ; lea x0, debug_armed
    lea rax, debug_armed
    mov QWORD PTR arm_x0, rax
    ; ldr     x28, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x28, rax
    ; ldp     x19, x20, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    ; ldp     x21, x22, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    ; ldp     x23, x24, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x23, rax
    mov QWORD PTR arm_x24, rcx
    ; ldp     x29, x30, [sp], #64
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 40h
    ; ret
    jmp QWORD PTR arm_x30
_debug_disarm:
    ; mov     x2, #-1
    mov rax, -1
    mov QWORD PTR arm_x2, rax
    ; lea x1, debug_abort
    lea rax, debug_abort
    mov QWORD PTR arm_x1, rax
    ; str     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; mov     x28, #0
    mov rax, 0
    mov QWORD PTR arm_x28, rax
    ; lea x1, debug_armed
    lea rax, debug_armed
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_runto_off
    lea rax, debug_runto_off
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_runto_status
    lea rax, debug_runto_status
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; ret
    jmp QWORD PTR arm_x30
_debug_clear_step:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_need_stacks
    lea rax, debug_need_stacks
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, debug_need_intro
    lea rax, debug_need_intro
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; bl      _debug_end_line
    lea rax, xret_68
    mov QWORD PTR arm_x30, rax
    jmp _debug_end_line
    xret_68:
    ; lea x0, debug_help_shown
    lea rax, debug_help_shown
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x1, debug_midline
    lea rax, debug_midline
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_over
    lea rax, debug_over
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; lea x1, debug_out
    lea rax, debug_out
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_end_line:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x1, debug_midline
    lea rax, debug_midline
    mov QWORD PTR arm_x1, rax
    ; ldr     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, end_line_done
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je end_line_done
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_69
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_69:
end_line_done:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_emit_z:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
emit_z_loop:
    ; ldrb    w0, [x19], #1
    mov r10, QWORD PTR arm_x19
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x19
    add rax, 1
    mov QWORD PTR arm_x19, rax
    ; cbz     w0, emit_z_done
    mov eax, DWORD PTR arm_x0
    cmp rax, 0
    je emit_z_done
    ; bl      _putchar
    lea rax, xret_70
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_70:
    ; b       emit_z_loop
    jmp emit_z_loop
emit_z_done:
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_call_xt:
    ; cbz     x0, call_xt_ret
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je call_xt_ret
    ; lea x2, debug_call_depth
    lea rax, debug_call_depth
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cmp     x3, #DEBUG_CALL_MAX
    mov rax, QWORD PTR arm_x3
    cmp rax, 4
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    call_xt_ret
    cmp BYTE PTR arm_c, 0
    jne call_xt_ret
    ; lea x1, debug_vmsave_stack
    lea rax, debug_vmsave_stack
    mov QWORD PTR arm_x1, rax
    ; mov     x4, #DEBUG_VMSAVE_SIZE
    mov rax, 48h
    mov QWORD PTR arm_x4, rax
    ; mul     x4, x3, x4
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x4
    imul rax, rcx
    mov QWORD PTR arm_x4, rax
    ; add     x1, x1, x4
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x4
    add rax, rcx
    mov QWORD PTR arm_x1, rax
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; stp     x19, x20, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [x1, #16]
    mov r10, QWORD PTR arm_x1
    add r10, 10h
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; stp     x23, x24, [x1, #32]
    mov r10, QWORD PTR arm_x1
    add r10, 20h
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x24
    mov QWORD PTR [r10+8], rax
    ; stp     x29, x30, [x1, #48]
    mov r10, QWORD PTR arm_x1
    add r10, 30h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; str     x28, [x1, #64]
    mov r10, QWORD PTR arm_x1
    add r10, 40h
    mov rax, QWORD PTR arm_x28
    mov QWORD PTR [r10], rax
    ; sub     x4, x3, #1
    mov rax, QWORD PTR arm_x3
    sub rax, 1
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #4096
    mov rax, 1000h
    mov QWORD PTR arm_x5, rax
    ; lea x23, debug_nest_rstack
    lea rax, debug_nest_rstack
    mov QWORD PTR arm_x23, rax
    ; mul     x4, x4, x5
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x5
    imul rax, rcx
    mov QWORD PTR arm_x4, rax
    ; add     x23, x23, x4
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x4
    add rax, rcx
    mov QWORD PTR arm_x23, rax
    ; add     x23, x23, x5
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x5
    add rax, rcx
    mov QWORD PTR arm_x23, rax
    ; mov     x28, #0
    mov rax, 0
    mov QWORD PTR arm_x28, rax
    ; lea x19, debug_ret_ipcell
    lea rax, debug_ret_ipcell
    mov QWORD PTR arm_x19, rax
    ; mov     x21, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x21, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
call_xt_ret:
    ; ret
    jmp QWORD PTR arm_x30
    ; ALIGN 4
ALIGN 4
XDBG_CALL_DONE:
    ; lea x1, debug_call_tos
    lea rax, debug_call_tos
    mov QWORD PTR arm_x1, rax
    ; str     x20, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x2, debug_call_depth
    lea rax, debug_call_depth
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbz     x3, call_done_ret
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    je call_done_ret
    ; sub     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    sub rax, 1
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; lea x1, debug_vmsave_stack
    lea rax, debug_vmsave_stack
    mov QWORD PTR arm_x1, rax
    ; mov     x4, #DEBUG_VMSAVE_SIZE
    mov rax, 48h
    mov QWORD PTR arm_x4, rax
    ; mul     x4, x3, x4
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x4
    imul rax, rcx
    mov QWORD PTR arm_x4, rax
    ; add     x1, x1, x4
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x4
    add rax, rcx
    mov QWORD PTR arm_x1, rax
    ; ldp     x19, x20, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    ; ldp     x21, x22, [x1, #16]
    mov r10, QWORD PTR arm_x1
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    ; ldp     x23, x24, [x1, #32]
    mov r10, QWORD PTR arm_x1
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x23, rax
    mov QWORD PTR arm_x24, rcx
    ; ldp     x29, x30, [x1, #48]
    mov r10, QWORD PTR arm_x1
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; ldr     x28, [x1, #64]
    mov r10, QWORD PTR arm_x1
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x28, rax
call_done_ret:
    ; ret
    jmp QWORD PTR arm_x30
_debug_ds_isolate:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x21, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+8], rax
    ; lea x19, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x19, rax
    ; add     x19, x19, #1, lsl #12
    mov rax, QWORD PTR arm_x19
    add rax, 1000h
    mov QWORD PTR arm_x19, rax
    ; lea x0, debug_dsave_tos
    lea rax, debug_dsave_tos
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, debug_dsave_dsp
    lea rax, debug_dsave_dsp
    mov QWORD PTR arm_x0, rax
    ; str     x22, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10], rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; cmp     x22, x19
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x19
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    ds_iso_store
    cmp BYTE PTR arm_c, 0
    jne ds_iso_store
    ; sub     x1, x19, x22
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x22
    sub rax, rcx
    mov QWORD PTR arm_x1, rax
    ; lsr     x1, x1, #3
    mov rax, QWORD PTR arm_x1
    shr rax, 3
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, #DBG_DSAVE_MAX
    mov rax, QWORD PTR arm_x1
    cmp rax, 40h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    ds_iso_copy
    cmp BYTE PTR arm_c, 0
    je ds_iso_copy
    cmp BYTE PTR arm_z, 0
    jne ds_iso_copy
    ; mov     x1, #DBG_DSAVE_MAX
    mov rax, 40h
    mov QWORD PTR arm_x1, rax
ds_iso_copy:
    ; lea x0, debug_dsave_buf
    lea rax, debug_dsave_buf
    mov QWORD PTR arm_x0, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
ds_iso_loop:
    ; cmp     x2, x1
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    ds_iso_store
    cmp BYTE PTR arm_c, 0
    jne ds_iso_store
    ; ldr     x3, [x22, x2, lsl #3]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x0, x2, lsl #3]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x2
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
    ; b       ds_iso_loop
    jmp ds_iso_loop
ds_iso_store:
    ; lea x0, debug_dsave_n
    lea rax, debug_dsave_n
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; mov     x22, x19
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR arm_x22, rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
    ; ldp     x19, x21, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x21, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_ds_restore:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x21, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_dsave_n
    lea rax, debug_dsave_n
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_dsave_dsp
    lea rax, debug_dsave_dsp
    mov QWORD PTR arm_x0, rax
    ; ldr     x22, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x22, rax
    ; lea x0, debug_dsave_tos
    lea rax, debug_dsave_tos
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; cbz     x1, ds_res_done
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je ds_res_done
    ; lea x0, debug_dsave_buf
    lea rax, debug_dsave_buf
    mov QWORD PTR arm_x0, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
ds_res_loop:
    ; cmp     x2, x1
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    ds_res_done
    cmp BYTE PTR arm_c, 0
    jne ds_res_done
    ; ldr     x3, [x0, x2, lsl #3]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x2
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x22, x2, lsl #3]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
    ; b       ds_res_loop
    jmp ds_res_loop
ds_res_done:
    ; ldp     x19, x21, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x21, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_sync_view:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_cfa
    lea rax, debug_cfa
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, sync_have
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne sync_have
    ; mov     x0, x19
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR arm_x0, rax
    ; lea x1, debug_xt
    lea rax, debug_xt
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; bl      _debug_resolve_enclosing
    lea rax, xret_71
    mov QWORD PTR arm_x30, rax
    jmp _debug_resolve_enclosing
    xret_71:
sync_have:
    ; cbz     x0, sync_done
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je sync_done
    ; lea x1, debug_view_cfa
    lea rax, debug_view_cfa
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cmp     x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    sync_done
    cmp BYTE PTR arm_z, 0
    jne sync_done
    ; stp     x0, x1, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; lea x24, debug_view_name
    lea rax, debug_view_name
    mov QWORD PTR arm_x24, rax
    ; strb    wzr, [x24]
    mov r10, QWORD PTR arm_x24
    mov BYTE PTR [r10], 0
    ; tst     x0, #7
    mov rax, QWORD PTR arm_x0
    test rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    sync_drop
    cmp BYTE PTR arm_z, 0
    je sync_drop
    ; ldr     x1, [x0, #-8]
    mov r10, QWORD PTR arm_x0
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; and     x1, x1, #0xFFFF
    mov rax, QWORD PTR arm_x1
    and rax, 0FFFFh
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, sync_drop
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je sync_drop
    ; lsr     x4, x1, #12
    mov rax, QWORD PTR arm_x1
    shr rax, 12
    mov QWORD PTR arm_x4, rax
    ; cbnz    x4, sync_drop
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    jne sync_drop
    ; sub     x0, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    sub rax, rcx
    mov QWORD PTR arm_x0, rax
    ; ldrb    w1, [x0], #1
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w1, w1, #NFA_LEN_MASK
    mov eax, DWORD PTR arm_x1
    and eax, 7Fh
    mov QWORD PTR arm_x1, rax
    ; cbz     w1, sync_drop
    mov eax, DWORD PTR arm_x1
    cmp rax, 0
    je sync_drop
    ; cmp     w1, #31
    mov eax, DWORD PTR arm_x1
    cmp eax, 1Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    sync_len_ok
    cmp BYTE PTR arm_c, 0
    je sync_len_ok
    cmp BYTE PTR arm_z, 0
    jne sync_len_ok
    ; mov     w1, #31
    mov eax, 1Fh
    mov QWORD PTR arm_x1, rax
sync_len_ok:
    ; strb    w1, [x24], #1
    mov r10, QWORD PTR arm_x24
    mov eax, DWORD PTR arm_x1
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x24
    add rax, 1
    mov QWORD PTR arm_x24, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
sync_copy:
    ; cmp     x2, x1
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    sync_copied
    cmp BYTE PTR arm_c, 0
    jne sync_copied
    ; ldrb    w3, [x0, x2]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x2
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; strb    w3, [x24, x2]
    mov r10, QWORD PTR arm_x24
    mov rax, QWORD PTR arm_x2
    add r10, rax
    mov eax, DWORD PTR arm_x3
    mov BYTE PTR [r10], al
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
    ; b       sync_copy
    jmp sync_copy
sync_copied:
    ; lea x0, debug_show_xt
    lea rax, debug_show_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, sync_drop
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je sync_drop
    ; lea x1, debug_view_name
    lea rax, debug_view_name
    mov QWORD PTR arm_x1, rax
    ; ldrb    w2, [x1], #1
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; cbz     w2, sync_drop
    mov eax, DWORD PTR arm_x2
    cmp rax, 0
    je sync_drop
    ; lea x3, debug_sync_ok
    lea rax, debug_sync_ok
    mov QWORD PTR arm_x3, rax
    ; str     xzr, [x3]
    mov r10, QWORD PTR arm_x3
    mov QWORD PTR [r10], 0
    ; stp     x1, x2, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_ds_isolate
    lea rax, xret_72
    mov QWORD PTR arm_x30, rax
    jmp _debug_ds_isolate
    xret_72:
    ; ldp     x1, x2, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x1, rax
    mov QWORD PTR arm_x2, rcx
    add rsp, 10h
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
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x20, rax
    ; lea x0, debug_show_xt
    lea rax, debug_show_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _debug_call_xt
    lea rax, xret_73
    mov QWORD PTR arm_x30, rax
    jmp _debug_call_xt
    xret_73:
    ; bl      _debug_ds_restore
    lea rax, xret_74
    mov QWORD PTR arm_x30, rax
    jmp _debug_ds_restore
    xret_74:
    ; lea x3, debug_sync_ok
    lea rax, debug_sync_ok
    mov QWORD PTR arm_x3, rax
    ; ldr     x0, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x3]
    mov r10, QWORD PTR arm_x3
    mov QWORD PTR [r10], 0
    ; cbz     x0, sync_drop
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je sync_drop
    ; ldp     x0, x1, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    add rsp, 10h
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; b       sync_done
    jmp sync_done
sync_drop:
    ; add     sp, sp, #16
    mov rax, rsp
    add rax, 10h
    mov rsp, rax
sync_done:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_wheel:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x1, debug_wheel_xt
    lea rax, debug_wheel_xt
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, wheel_done
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je wheel_done
    ; stp     x0, x1, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_ds_isolate
    lea rax, xret_75
    mov QWORD PTR arm_x30, rax
    jmp _debug_ds_isolate
    xret_75:
    ; ldp     x0, x1, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    add rsp, 10h
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
    ; mov     x0, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x0, rax
    ; bl      _debug_call_xt
    lea rax, xret_76
    mov QWORD PTR arm_x30, rax
    jmp _debug_call_xt
    xret_76:
    ; bl      _debug_ds_restore
    lea rax, xret_77
    mov QWORD PTR arm_x30, rax
    jmp _debug_ds_restore
    xret_77:
    ; bl      host_debug_paint
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_paint
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
wheel_done:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_highlight:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_ip
    lea rax, debug_ip
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; lea x1, tw_continue_cell
    lea rax, tw_continue_cell
    mov QWORD PTR arm_x1, rax
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    hl_done
    cmp BYTE PTR arm_z, 0
    jne hl_done
    ; lea x0, debug_hl_xt
    lea rax, debug_hl_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, hl_done
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je hl_done
    ; lea x1, debug_name
    lea rax, debug_name
    mov QWORD PTR arm_x1, rax
    ; ldrb    w2, [x1], #1
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; cbz     w2, hl_done
    mov eax, DWORD PTR arm_x2
    cmp rax, 0
    je hl_done
    ; stp     x1, x2, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10+8], rax
    ; bl      _debug_ds_isolate
    lea rax, xret_78
    mov QWORD PTR arm_x30, rax
    jmp _debug_ds_isolate
    xret_78:
    ; ldp     x1, x2, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x1, rax
    mov QWORD PTR arm_x2, rcx
    add rsp, 10h
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
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x20, rax
    ; lea x0, debug_hl_xt
    lea rax, debug_hl_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _debug_call_xt
    lea rax, xret_79
    mov QWORD PTR arm_x30, rax
    jmp _debug_call_xt
    xret_79:
    ; bl      _debug_ds_restore
    lea rax, xret_80
    mov QWORD PTR arm_x30, rax
    jmp _debug_ds_restore
    xret_80:
hl_done:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_capture:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; lea x19, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x19, rax
    ; add     x19, x19, #1, lsl #12
    mov rax, QWORD PTR arm_x19
    add rax, 1000h
    mov QWORD PTR arm_x19, rax
    ; lea x9, debug_scnt
    lea rax, debug_scnt
    mov QWORD PTR arm_x9, rax
    ; cmp     x22, x19
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x19
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    cap_s_empty
    cmp BYTE PTR arm_c, 0
    jne cap_s_empty
    ; sub     x21, x19, x22
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x22
    sub rax, rcx
    mov QWORD PTR arm_x21, rax
    ; lsr     x21, x21, #3
    mov rax, QWORD PTR arm_x21
    shr rax, 3
    mov QWORD PTR arm_x21, rax
    ; cmp     x21, #16
    mov rax, QWORD PTR arm_x21
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    cap_s_n
    cmp BYTE PTR arm_c, 0
    je cap_s_n
    cmp BYTE PTR arm_z, 0
    jne cap_s_n
    ; mov     x21, #16
    mov rax, 10h
    mov QWORD PTR arm_x21, rax
cap_s_n:
    ; str     x21, [x9]
    mov r10, QWORD PTR arm_x9
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10], rax
    ; lea x24, debug_sbuf
    lea rax, debug_sbuf
    mov QWORD PTR arm_x24, rax
    ; cbz     x21, cap_r
    mov rax, QWORD PTR arm_x21
    cmp rax, 0
    je cap_r
    ; sub     x1, x21, #1
    mov rax, QWORD PTR arm_x21
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x20, [x24, x1, lsl #3]
    mov r10, QWORD PTR arm_x24
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; cbz     x1, cap_r
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je cap_r
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
cap_s_loop:
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    cap_r
    cmp BYTE PTR arm_c, 0
    jne cap_r
    ; sub     x2, x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    sub rax, rcx
    mov QWORD PTR arm_x2, rax
    ; sub     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    sub rax, 1
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x22, x2, lsl #3]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x24, x0, lsl #3]
    mov r10, QWORD PTR arm_x24
    mov rax, QWORD PTR arm_x0
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; b       cap_s_loop
    jmp cap_s_loop
cap_s_empty:
    ; str     xzr, [x9]
    mov r10, QWORD PTR arm_x9
    mov QWORD PTR [r10], 0
cap_r:
    ; lea x19, return_stack
    lea rax, return_stack
    mov QWORD PTR arm_x19, rax
    ; add     x19, x19, #1, lsl #12
    mov rax, QWORD PTR arm_x19
    add rax, 1000h
    mov QWORD PTR arm_x19, rax
    ; lea x10, debug_floor
    lea rax, debug_floor
    mov QWORD PTR arm_x10, rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR arm_x10
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x10, rax
    ; cbz     x10, cap_r_clip
    mov rax, QWORD PTR arm_x10
    cmp rax, 0
    je cap_r_clip
    ; cmp     x10, x19
    mov rax, QWORD PTR arm_x10
    mov rcx, QWORD PTR arm_x19
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    cap_r_clip
    cmp BYTE PTR arm_c, 0
    je xsk_81
    cmp BYTE PTR arm_z, 0
    je cap_r_clip
    xsk_81:
    ; cmp     x10, x23
    mov rax, QWORD PTR arm_x10
    mov rcx, QWORD PTR arm_x23
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    cap_r_clip
    cmp BYTE PTR arm_c, 0
    je cap_r_clip
    cmp BYTE PTR arm_z, 0
    jne cap_r_clip
    ; mov     x19, x10
    mov rax, QWORD PTR arm_x10
    mov QWORD PTR arm_x19, rax
cap_r_clip:
    ; lea x24, debug_rbuf
    lea rax, debug_rbuf
    mov QWORD PTR arm_x24, rax
    ; lea x10, throw_handler
    lea rax, throw_handler
    mov QWORD PTR arm_x10, rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR arm_x10
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x10, rax
    ; cmp     x23, x19
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x19
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    cap_r_empty
    cmp BYTE PTR arm_c, 0
    jne cap_r_empty
    ; sub     x21, x19, x23
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x23
    sub rax, rcx
    mov QWORD PTR arm_x21, rax
    ; lsr     x21, x21, #3
    mov rax, QWORD PTR arm_x21
    shr rax, 3
    mov QWORD PTR arm_x21, rax
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
cap_r_loop:
    ; cmp     x0, x21
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x21
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    cap_r_store
    cmp BYTE PTR arm_c, 0
    jne cap_r_store
    ; add     x2, x23, x0, lsl #3
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x0
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR arm_x2, rax
    ; cmp     x2, x10
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x10
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    cap_r_keep
    cmp BYTE PTR arm_z, 0
    je cap_r_keep
    ; add     x0, x0, #6
    mov rax, QWORD PTR arm_x0
    add rax, 6
    mov QWORD PTR arm_x0, rax
    ; b       cap_r_loop
    jmp cap_r_loop
cap_r_keep:
    ; cmp     x1, #16
    mov rax, QWORD PTR arm_x1
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    cap_r_store
    cmp BYTE PTR arm_c, 0
    jne cap_r_store
    ; ldr     x2, [x23, x0, lsl #3]
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x0
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; str     x2, [x24, x1, lsl #3]
    mov r10, QWORD PTR arm_x24
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; b       cap_r_loop
    jmp cap_r_loop
cap_r_empty:
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
cap_r_store:
    ; lea x9, debug_rcnt
    lea rax, debug_rcnt
    mov QWORD PTR arm_x9, rax
    ; str     x1, [x9]
    mov r10, QWORD PTR arm_x9
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x0, debug_xt
    lea rax, debug_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; lea x19, debug_name
    lea rax, debug_name
    mov QWORD PTR arm_x19, rax
    ; strb    wzr, [x19]
    mov r10, QWORD PTR arm_x19
    mov BYTE PTR [r10], 0
    ; cbz     x0, cap_done
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je cap_done
    ; lea x1, tw_continue_cfa
    lea rax, tw_continue_cfa
    mov QWORD PTR arm_x1, rax
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    cap_done
    cmp BYTE PTR arm_z, 0
    jne cap_done
    ; tst     x0, #7
    mov rax, QWORD PTR arm_x0
    test rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    cap_done
    cmp BYTE PTR arm_z, 0
    je cap_done
    ; ldr     x1, [x0, #-8]
    mov r10, QWORD PTR arm_x0
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; and     x1, x1, #0xFFFF
    mov rax, QWORD PTR arm_x1
    and rax, 0FFFFh
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, cap_done
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je cap_done
    ; lsr     x4, x1, #12
    mov rax, QWORD PTR arm_x1
    shr rax, 12
    mov QWORD PTR arm_x4, rax
    ; cbnz    x4, cap_done
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    jne cap_done
    ; sub     x0, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    sub rax, rcx
    mov QWORD PTR arm_x0, rax
    ; ldrb    w1, [x0], #1
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w1, w1, #NFA_LEN_MASK
    mov eax, DWORD PTR arm_x1
    and eax, 7Fh
    mov QWORD PTR arm_x1, rax
    ; cbz     w1, cap_done
    mov eax, DWORD PTR arm_x1
    cmp rax, 0
    je cap_done
    ; cmp     w1, #31
    mov eax, DWORD PTR arm_x1
    cmp eax, 1Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    cap_name_ok
    cmp BYTE PTR arm_c, 0
    je cap_name_ok
    cmp BYTE PTR arm_z, 0
    jne cap_name_ok
    ; mov     w1, #31
    mov eax, 1Fh
    mov QWORD PTR arm_x1, rax
cap_name_ok:
    ; strb    w1, [x19], #1
    mov r10, QWORD PTR arm_x19
    mov eax, DWORD PTR arm_x1
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x19
    add rax, 1
    mov QWORD PTR arm_x19, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
cap_name_loop:
    ; cmp     x2, x1
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    cap_done
    cmp BYTE PTR arm_c, 0
    jne cap_done
    ; ldrb    w3, [x0, x2]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x2
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; strb    w3, [x19, x2]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR arm_x2
    add r10, rax
    mov eax, DWORD PTR arm_x3
    mov BYTE PTR [r10], al
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
    ; b       cap_name_loop
    jmp cap_name_loop
cap_done:
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_resolve_enclosing:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
    ; mov     x20, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x20, rax
    ; lea x0, catch_ok_cell
    lea rax, catch_ok_cell
    mov QWORD PTR arm_x0, rax
    ; cmp     x19, x0
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    res_catch
    cmp BYTE PTR arm_z, 0
    jne res_catch
    ; lea x0, tw_continue_cell
    lea rax, tw_continue_cell
    mov QWORD PTR arm_x0, rax
    ; cmp     x19, x0
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    res_scan
    cmp BYTE PTR arm_z, 0
    je res_scan
    ; ldr     x0, [x23, #8]
    mov r10, QWORD PTR arm_x23
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, res_none
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je res_none
    ; tst     x0, #7
    mov rax, QWORD PTR arm_x0
    test rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    res_none
    cmp BYTE PTR arm_z, 0
    je res_none
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, DOCOL
    lea rax, DOCOL
    mov QWORD PTR arm_x2, rax
    ; cmp     x1, x2
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    res_none
    cmp BYTE PTR arm_z, 0
    je res_none
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; b       res_out
    jmp res_out
res_catch:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, res_none
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je res_none
    ; tst     x0, #7
    mov rax, QWORD PTR arm_x0
    test rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    res_none
    cmp BYTE PTR arm_z, 0
    je res_none
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, DOCOL
    lea rax, DOCOL
    mov QWORD PTR arm_x2, rax
    ; cmp     x1, x2
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    res_none
    cmp BYTE PTR arm_z, 0
    je res_none
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; b       res_out
    jmp res_out
res_scan:
    ; mov     x0, x19
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR arm_x0, rax
    ; bl      _ip_find_colon
    lea rax, xret_82
    mov QWORD PTR arm_x30, rax
    jmp _ip_find_colon
    xret_82:
    ; cbnz    x0, res_out
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne res_out
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, res_none
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je res_none
    ; tst     x0, #7
    mov rax, QWORD PTR arm_x0
    test rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    res_none
    cmp BYTE PTR arm_z, 0
    je res_none
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, DOCOL
    lea rax, DOCOL
    mov QWORD PTR arm_x2, rax
    ; cmp     x1, x2
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    res_none
    cmp BYTE PTR arm_z, 0
    je res_none
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; b       res_out
    jmp res_out
res_none:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
res_out:
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_ip_find_colon:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; stp     x23, x24, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x24
    mov QWORD PTR [r10+8], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; mov     x21, #0
    mov rax, 0
    mov QWORD PTR arm_x21, rax
    ; mov     x22, #0
    mov rax, 0
    mov QWORD PTR arm_x22, rax
    ; lea x19, wordlist_reg_n
    lea rax, wordlist_reg_n
    mov QWORD PTR arm_x19, rax
    ; ldr     x19, [x19]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    ; lea x23, wordlist_reg
    lea rax, wordlist_reg
    mov QWORD PTR arm_x23, rax
    ; mov     x24, #0
    mov rax, 0
    mov QWORD PTR arm_x24, rax
ip_wid_loop:
    ; cmp     x24, x19
    mov rax, QWORD PTR arm_x24
    mov rcx, QWORD PTR arm_x19
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    ip_wid_done
    cmp BYTE PTR arm_c, 0
    jne ip_wid_done
    ; ldr     x0, [x23, x24, lsl #3]
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x24
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _ip_scan_wid
    lea rax, xret_83
    mov QWORD PTR arm_x30, rax
    jmp _ip_scan_wid
    xret_83:
    ; add     x24, x24, #1
    mov rax, QWORD PTR arm_x24
    add rax, 1
    mov QWORD PTR arm_x24, rax
    ; b       ip_wid_loop
    jmp ip_wid_loop
ip_wid_done:
    ; lea x0, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x0, rax
    ; bl      _ip_scan_wid
    lea rax, xret_84
    mov QWORD PTR arm_x30, rax
    jmp _ip_scan_wid
    xret_84:
    ; mov     x0, x21
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR arm_x0, rax
    ; cbz     x21, ip_no_off
    mov rax, QWORD PTR arm_x21
    cmp rax, 0
    je ip_no_off
    ; sub     x1, x20, x22
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x22
    sub rax, rcx
    mov QWORD PTR arm_x1, rax
    ; b       ip_find_out
    jmp ip_find_out
ip_no_off:
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
ip_find_out:
    ; ldp     x23, x24, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x23, rax
    mov QWORD PTR arm_x24, rcx
    add rsp, 10h
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_ip_scan_wid:
    ; cbz     x0, scan_ret
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je scan_ret
    ; mov     x9, #0
    mov rax, 0
    mov QWORD PTR arm_x9, rax
scan_thread:
    ; cmp     x9, #DICT_THREADS
    mov rax, QWORD PTR arm_x9
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    scan_ret
    cmp BYTE PTR arm_c, 0
    jne scan_ret
    ; ldr     x10, [x0, x9, lsl #3]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x9
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x10, rax
scan_link:
    ; cbz     x10, scan_next_thread
    mov rax, QWORD PTR arm_x10
    cmp rax, 0
    je scan_next_thread
    ; tst     x10, #7
    mov rax, QWORD PTR arm_x10
    test rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    scan_next_thread
    cmp BYTE PTR arm_z, 0
    je scan_next_thread
    ; ldr     x11, [x10]
    mov r10, QWORD PTR arm_x10
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x11, rax
    ; lea x12, DOCOL
    lea rax, DOCOL
    mov QWORD PTR arm_x12, rax
    ; cmp     x11, x12
    mov rax, QWORD PTR arm_x11
    mov rcx, QWORD PTR arm_x12
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    scan_lfa
    cmp BYTE PTR arm_z, 0
    je scan_lfa
    ; add     x11, x10, #8
    mov rax, QWORD PTR arm_x10
    add rax, 8
    mov QWORD PTR arm_x11, rax
    ; cmp     x11, x20
    mov rax, QWORD PTR arm_x11
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    scan_lfa
    cmp BYTE PTR arm_c, 0
    je xsk_85
    cmp BYTE PTR arm_z, 0
    je scan_lfa
    xsk_85:
    ; sub     x12, x20, x11
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x11
    sub rax, rcx
    mov QWORD PTR arm_x12, rax
    ; lsr     x13, x12, #20
    mov rax, QWORD PTR arm_x12
    shr rax, 20
    mov QWORD PTR arm_x13, rax
    ; cbnz    x13, scan_lfa
    mov rax, QWORD PTR arm_x13
    cmp rax, 0
    jne scan_lfa
    ; cbz     x21, scan_take
    mov rax, QWORD PTR arm_x21
    cmp rax, 0
    je scan_take
    ; cmp     x11, x22
    mov rax, QWORD PTR arm_x11
    mov rcx, QWORD PTR arm_x22
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    scan_lfa
    cmp BYTE PTR arm_c, 0
    je scan_lfa
    cmp BYTE PTR arm_z, 0
    jne scan_lfa
scan_take:
    ; mov     x22, x11
    mov rax, QWORD PTR arm_x11
    mov QWORD PTR arm_x22, rax
    ; mov     x21, x10
    mov rax, QWORD PTR arm_x10
    mov QWORD PTR arm_x21, rax
scan_lfa:
    ; ldr     x10, [x10, #-16]
    mov r10, QWORD PTR arm_x10
    add r10, -16
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x10, rax
    ; b       scan_link
    jmp scan_link
scan_next_thread:
    ; add     x9, x9, #1
    mov rax, QWORD PTR arm_x9
    add rax, 1
    mov QWORD PTR arm_x9, rax
    ; b       scan_thread
    jmp scan_thread
scan_ret:
    ; ret
    jmp QWORD PTR arm_x30
_debug_print_inline_suffix:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_xt
    lea rax, debug_xt
    mov QWORD PTR arm_x0, rax
    ; ldr     x19, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    ; cbz     x19, inl_done
    mov rax, QWORD PTR arm_x19
    cmp rax, 0
    je inl_done
    ; lea x0, debug_inline
    lea rax, debug_inline
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; lea x1, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x19, x1
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    inl_branch
    cmp BYTE PTR arm_z, 0
    je inl_branch
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_86
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_86:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, inl_number
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je inl_number
    ; tst     x0, #7
    mov rax, QWORD PTR arm_x0
    test rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    inl_number
    cmp BYTE PTR arm_z, 0
    je inl_number
    ; lea x1, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR arm_x1, rax
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    inl_number
    cmp BYTE PTR arm_c, 0
    je inl_number
    ; lea x1, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    inl_number
    cmp BYTE PTR arm_c, 0
    jne inl_number
    ; ldr     x1, [x0, #-8]
    mov r10, QWORD PTR arm_x0
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; and     x1, x1, #0xFFFF
    mov rax, QWORD PTR arm_x1
    and rax, 0FFFFh
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, inl_number
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je inl_number
    ; lsr     x4, x1, #12
    mov rax, QWORD PTR arm_x1
    shr rax, 12
    mov QWORD PTR arm_x4, rax
    ; cbnz    x4, inl_number
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    jne inl_number
    ; sub     x2, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    sub rax, rcx
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, inl_number
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je inl_number
    ; lea x3, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR arm_x3, rax
    ; cmp     x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    inl_number
    cmp BYTE PTR arm_c, 0
    je inl_number
    ; ldrb    w2, [x2]
    mov r10, QWORD PTR arm_x2
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; and     w2, w2, #NFA_LEN_MASK
    mov eax, DWORD PTR arm_x2
    and eax, 7Fh
    mov QWORD PTR arm_x2, rax
    ; cbz     w2, inl_number
    mov eax, DWORD PTR arm_x2
    cmp rax, 0
    je inl_number
    ; cmp     w2, #64
    mov eax, DWORD PTR arm_x2
    cmp eax, 40h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    inl_number
    cmp BYTE PTR arm_c, 0
    jne inl_number
    ; bl      _print_xt_name
    lea rax, xret_87
    mov QWORD PTR arm_x30, rax
    jmp _print_xt_name
    xret_87:
    ; b       inl_done
    jmp inl_done
inl_number:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      _print_signed
    lea rax, xret_88
    mov QWORD PTR arm_x30, rax
    jmp _print_signed
    xret_88:
    ; b       inl_done
    jmp inl_done
inl_branch:
    ; lea x1, cfa_branch
    lea rax, cfa_branch
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x19, x1
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    inl_cells
    cmp BYTE PTR arm_z, 0
    jne inl_cells
    ; lea x1, cfa_0branch
    lea rax, cfa_0branch
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x19, x1
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    inl_cells
    cmp BYTE PTR arm_z, 0
    jne inl_cells
    ; lea x1, cfa_loop
    lea rax, cfa_loop
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x19, x1
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    inl_cells
    cmp BYTE PTR arm_z, 0
    jne inl_cells
    ; lea x1, cfa_plusloop
    lea rax, cfa_plusloop
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x19, x1
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    inl_done
    cmp BYTE PTR arm_z, 0
    je inl_done
inl_cells:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_89
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_89:
    ; asr     x20, x20, #3
    mov rax, QWORD PTR arm_x20
    sar rax, 3
    mov QWORD PTR arm_x20, rax
    ; tbnz    x20, #63, inl_neg
    mov rax, QWORD PTR arm_x20
    bt rax, 63
    jc inl_neg
    ; mov     x0, #'+'
    mov rax, 2Bh
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_90
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_90:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      _print_unsigned
    lea rax, xret_91
    mov QWORD PTR arm_x30, rax
    jmp _print_unsigned
    xret_91:
    ; b       inl_cells_word
    jmp inl_cells_word
inl_neg:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      _print_signed
    lea rax, xret_92
    mov QWORD PTR arm_x30, rax
    jmp _print_signed
    xret_92:
inl_cells_word:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_93
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_93:
    ; mov     x0, #'C'
    mov rax, 43h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_94
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_94:
    ; mov     x0, #'E'
    mov rax, 45h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_95
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_95:
    ; mov     x0, #'L'
    mov rax, 4Ch
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_96
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_96:
    ; mov     x0, #'L'
    mov rax, 4Ch
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_97
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_97:
    ; mov     x0, #'S'
    mov rax, 53h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_98
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_98:
inl_done:
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_xt_intoable:
    ; cbz     x0, into_no
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je into_no
    ; tst     x0, #7
    mov rax, QWORD PTR arm_x0
    test rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    into_no
    cmp BYTE PTR arm_z, 0
    je into_no
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x0, DOCOL
    lea rax, DOCOL
    mov QWORD PTR arm_x0, rax
    ; cmp     x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    into_yes
    cmp BYTE PTR arm_z, 0
    jne into_yes
    ; lea x0, DODOES
    lea rax, DODOES
    mov QWORD PTR arm_x0, rax
    ; cmp     x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    into_yes
    cmp BYTE PTR arm_z, 0
    jne into_yes
    ; lea x0, XEXECUTE
    lea rax, XEXECUTE
    mov QWORD PTR arm_x0, rax
    ; cmp     x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    into_yes
    cmp BYTE PTR arm_z, 0
    jne into_yes
    ; lea x0, XCATCH
    lea rax, XCATCH
    mov QWORD PTR arm_x0, rax
    ; cmp     x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    into_yes
    cmp BYTE PTR arm_z, 0
    jne into_yes
into_no:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
into_yes:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_print_xt_name:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; cbz     x0, pxn_q
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je pxn_q
    ; lea x1, tw_continue_cfa
    lea rax, tw_continue_cfa
    mov QWORD PTR arm_x1, rax
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    pxn_check
    cmp BYTE PTR arm_z, 0
    je pxn_check
    ; lea x0, str_traverse
    lea rax, str_traverse
    mov QWORD PTR arm_x0, rax
    ; bl      _emit_z
    lea rax, xret_99
    mov QWORD PTR arm_x30, rax
    jmp _emit_z
    xret_99:
    ; b       pxn_done
    jmp pxn_done
pxn_check:
    ; tst     x0, #7
    mov rax, QWORD PTR arm_x0
    test rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    pxn_q
    cmp BYTE PTR arm_z, 0
    je pxn_q
    ; ldr     x1, [x0, #-8]
    mov r10, QWORD PTR arm_x0
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; and     x1, x1, #0xFFFF
    mov rax, QWORD PTR arm_x1
    and rax, 0FFFFh
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, pxn_q
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je pxn_q
    ; lsr     x4, x1, #12
    mov rax, QWORD PTR arm_x1
    shr rax, 12
    mov QWORD PTR arm_x4, rax
    ; cbnz    x4, pxn_q
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    jne pxn_q
    ; sub     x19, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    sub rax, rcx
    mov QWORD PTR arm_x19, rax
    ; ldrb    w20, [x19], #1
    mov r10, QWORD PTR arm_x19
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x19
    add rax, 1
    mov QWORD PTR arm_x19, rax
    ; and     w20, w20, #NFA_LEN_MASK
    mov eax, DWORD PTR arm_x20
    and eax, 7Fh
    mov QWORD PTR arm_x20, rax
    ; cbz     w20, pxn_q
    mov eax, DWORD PTR arm_x20
    cmp rax, 0
    je pxn_q
    ; cmp     w20, #64
    mov eax, DWORD PTR arm_x20
    cmp eax, 40h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    pxn_q
    cmp BYTE PTR arm_c, 0
    jne pxn_q
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
pxn_scan:
    ; cmp     x1, x20
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    pxn_print
    cmp BYTE PTR arm_c, 0
    jne pxn_print
    ; ldrb    w0, [x19, x1]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR arm_x1
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     w0, #32
    mov eax, DWORD PTR arm_x0
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    pxn_q
    cmp BYTE PTR arm_c, 0
    je pxn_q
    ; cmp     w0, #126
    mov eax, DWORD PTR arm_x0
    cmp eax, 7Eh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    pxn_q
    cmp BYTE PTR arm_c, 0
    je xsk_100
    cmp BYTE PTR arm_z, 0
    je pxn_q
    xsk_100:
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       pxn_scan
    jmp pxn_scan
pxn_print:
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
pxn_out:
    ; cmp     x1, x20
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    pxn_done
    cmp BYTE PTR arm_c, 0
    jne pxn_done
    ; ldrb    w0, [x19, x1]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR arm_x1
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; stp     x1, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; bl      _putchar
    lea rax, xret_101
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_101:
    ; ldp     x1, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x1, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       pxn_out
    jmp pxn_out
pxn_done:
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
pxn_q:
    ; mov     x0, #63
    mov rax, 3Fh
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_102
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_102:
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_note_byte:
    ; lea x1, debug_armed
    lea rax, debug_armed
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, note_ret
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je note_ret
    ; lea x2, debug_line_col
    lea rax, debug_line_col
    mov QWORD PTR arm_x2, rax
    ; lea x3, debug_midline
    lea rax, debug_midline
    mov QWORD PTR arm_x3, rax
    ; cmp     w0, #10
    mov eax, DWORD PTR arm_x0
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    note_not_nl
    cmp BYTE PTR arm_z, 0
    je note_not_nl
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; str     xzr, [x3]
    mov r10, QWORD PTR arm_x3
    mov QWORD PTR [r10], 0
    ; ret
    jmp QWORD PTR arm_x30
note_not_nl:
    ; cmp     w0, #8
    mov eax, DWORD PTR arm_x0
    cmp eax, 8
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    note_glyph
    cmp BYTE PTR arm_z, 0
    je note_glyph
    ; ldr     x1, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, note_bs_flag
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je note_bs_flag
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
note_bs_flag:
    ; ldr     x1, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, #0
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    note_bs_zero
    cmp BYTE PTR arm_z, 0
    jne note_bs_zero
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       note_bs_store
    jmp note_bs_store
note_bs_zero:
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
note_bs_store:
    ; str     x1, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; ret
    jmp QWORD PTR arm_x30
note_glyph:
    ; and     w1, w0, #0xC0
    mov eax, DWORD PTR arm_x0
    and eax, 0C0h
    mov QWORD PTR arm_x1, rax
    ; cmp     w1, #0x80
    mov eax, DWORD PTR arm_x1
    cmp eax, 80h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    note_ret
    cmp BYTE PTR arm_z, 0
    jne note_ret
    ; ldr     x1, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
note_ret:
    ; ret
    jmp QWORD PTR arm_x30
_debug_pad_to_stack_col:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_line_col
    lea rax, debug_line_col
    mov QWORD PTR arm_x0, rax
    ; ldr     x19, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    ; cmp     x19, #DEBUG_STACK_COL
    mov rax, QWORD PTR arm_x19
    cmp rax, 17h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    pad_done
    cmp BYTE PTR arm_z, 0
    jne pad_done
    ; b.hi    pad_one
    cmp BYTE PTR arm_c, 0
    je xsk_103
    cmp BYTE PTR arm_z, 0
    je pad_one
    xsk_103:
    ; mov     x0, #DEBUG_STACK_COL
    mov rax, 17h
    mov QWORD PTR arm_x0, rax
    ; sub     x19, x0, x19
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x19
    sub rax, rcx
    mov QWORD PTR arm_x19, rax
pad_loop:
    ; cbz     x19, pad_done
    mov rax, QWORD PTR arm_x19
    cmp rax, 0
    je pad_done
    ; sub     x19, x19, #1
    mov rax, QWORD PTR arm_x19
    sub rax, 1
    mov QWORD PTR arm_x19, rax
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_104
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_104:
    ; b       pad_loop
    jmp pad_loop
pad_one:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_105
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_105:
pad_done:
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_cursor_on:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_line_col
    lea rax, debug_line_col
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_stack_anchor
    lea rax, debug_stack_anchor
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; mov     x0, #0xE2
    mov rax, 0E2h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_106
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_106:
    ; mov     x0, #0x96
    mov rax, 96h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_107
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_107:
    ; mov     x0, #0x88
    mov rax, 88h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_108
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_108:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_cursor_on
    lea rax, debug_cursor_on
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_cursor_off:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_cursor_on
    lea rax, debug_cursor_on
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, cursor_off_done
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je cursor_off_done
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; mov     x0, #8
    mov rax, 8
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_109
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_109:
    ; lea x0, debug_stack_anchor
    lea rax, debug_stack_anchor
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_line_col
    lea rax, debug_line_col
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
cursor_off_done:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_print_SR:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; lea x0, debug_field_len
    lea rax, debug_field_len
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x0, debug_field_count
    lea rax, debug_field_count
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; mov     x0, #83
    mov rax, 53h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_110
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_110:
    ; bl      _debug_print_dots
    lea rax, xret_111
    mov QWORD PTR arm_x30, rax
    jmp _debug_print_dots
    xret_111:
    ; lea x0, debug_field_len
    lea rax, debug_field_len
    mov QWORD PTR arm_x0, rax
    ; ldr     x19, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    ; cmp     x19, #45
    mov rax, QWORD PTR arm_x19
    cmp rax, 2Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    sr_past
    cmp BYTE PTR arm_c, 0
    jne sr_past
    ; mov     x0, #45
    mov rax, 2Dh
    mov QWORD PTR arm_x0, rax
    ; sub     x19, x0, x19
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x19
    sub rax, rcx
    mov QWORD PTR arm_x19, rax
sr_pad:
    ; cbz     x19, sr_r
    mov rax, QWORD PTR arm_x19
    cmp rax, 0
    je sr_r
    ; sub     x19, x19, #1
    mov rax, QWORD PTR arm_x19
    sub rax, 1
    mov QWORD PTR arm_x19, rax
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_112
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_112:
    ; b       sr_pad
    jmp sr_pad
sr_past:
    ; b.eq    sr_r
    cmp BYTE PTR arm_z, 0
    jne sr_r
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_113
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_113:
sr_r:
    ; mov     x0, #82
    mov rax, 52h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_114
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_114:
    ; bl      _debug_print_rstack
    lea rax, xret_115
    mov QWORD PTR arm_x30, rax
    jmp _debug_print_rstack
    xret_115:
    ; lea x0, debug_field_count
    lea rax, debug_field_count
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_print_dots:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; lea x19, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x19, rax
    ; add     x19, x19, #1, lsl #12
    mov rax, QWORD PTR arm_x19
    add rax, 1000h
    mov QWORD PTR arm_x19, rax
    ; cmp     x22, x19
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x19
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    dpd_empty
    cmp BYTE PTR arm_c, 0
    jne dpd_empty
    ; sub     x21, x19, x22
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x22
    sub rax, rcx
    mov QWORD PTR arm_x21, rax
    ; lsr     x21, x21, #3
    mov rax, QWORD PTR arm_x21
    shr rax, 3
    mov QWORD PTR arm_x21, rax
    ; mov     x0, #40
    mov rax, 28h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_116
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_116:
    ; mov     x0, x21
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR arm_x0, rax
    ; bl      _print_unsigned
    lea rax, xret_117
    mov QWORD PTR arm_x30, rax
    jmp _print_unsigned
    xret_117:
    ; mov     x0, #41
    mov rax, 29h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_118
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_118:
    ; mov     x0, #58
    mov rax, 3Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_119
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_119:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_120
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_120:
    ; cmp     x21, #6
    mov rax, QWORD PTR arm_x21
    cmp rax, 6
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    dpd_under
    cmp BYTE PTR arm_c, 0
    je dpd_under
    cmp BYTE PTR arm_z, 0
    jne dpd_under
    ; mov     x0, #'.'
    mov rax, 2Eh
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_121
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_121:
    ; mov     x0, #'.'
    mov rax, 2Eh
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_122
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_122:
    ; mov     x0, #'.'
    mov rax, 2Eh
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_123
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_123:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_124
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_124:
dpd_under:
    ; cmp     x21, #1
    mov rax, QWORD PTR arm_x21
    cmp rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    dpd_tos
    cmp BYTE PTR arm_z, 0
    jne dpd_tos
    ; sub     x19, x21, #1
    mov rax, QWORD PTR arm_x21
    sub rax, 1
    mov QWORD PTR arm_x19, rax
    ; cmp     x19, #5
    mov rax, QWORD PTR arm_x19
    cmp rax, 5
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    dpd_mem
    cmp BYTE PTR arm_c, 0
    je dpd_mem
    cmp BYTE PTR arm_z, 0
    jne dpd_mem
    ; mov     x19, #5
    mov rax, 5
    mov QWORD PTR arm_x19, rax
dpd_mem:
    ; cbz     x19, dpd_tos
    mov rax, QWORD PTR arm_x19
    cmp rax, 0
    je dpd_tos
    ; sub     x19, x19, #1
    mov rax, QWORD PTR arm_x19
    sub rax, 1
    mov QWORD PTR arm_x19, rax
    ; lsl     x0, x19, #3
    mov rax, QWORD PTR arm_x19
    shl rax, 3
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x22, x0]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _print_signed
    lea rax, xret_125
    mov QWORD PTR arm_x30, rax
    jmp _print_signed
    xret_125:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_126
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_126:
    ; b       dpd_mem
    jmp dpd_mem
dpd_tos:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      _print_signed
    lea rax, xret_127
    mov QWORD PTR arm_x30, rax
    jmp _print_signed
    xret_127:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_128
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_128:
    ; b       dpd_done
    jmp dpd_done
dpd_empty:
    ; mov     x0, #40
    mov rax, 28h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_129
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_129:
    ; mov     x0, #48
    mov rax, 30h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_130
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_130:
    ; mov     x0, #41
    mov rax, 29h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_131
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_131:
    ; mov     x0, #58
    mov rax, 3Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_132
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_132:
dpd_done:
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_debug_print_rstack:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; sub     sp, sp, #32
    mov rax, rsp
    sub rax, 20h
    mov rsp, rax
    ; lea x19, return_stack
    lea rax, return_stack
    mov QWORD PTR arm_x19, rax
    ; add     x19, x19, #1, lsl #12
    mov rax, QWORD PTR arm_x19
    add rax, 1000h
    mov QWORD PTR arm_x19, rax
    ; lea x0, debug_floor
    lea rax, debug_floor
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, dpr_clip
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je dpr_clip
    ; cmp     x0, x19
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x19
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    dpr_clip
    cmp BYTE PTR arm_c, 0
    je xsk_133
    cmp BYTE PTR arm_z, 0
    je dpr_clip
    xsk_133:
    ; cmp     x0, x23
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x23
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    dpr_clip
    cmp BYTE PTR arm_c, 0
    je dpr_clip
    cmp BYTE PTR arm_z, 0
    jne dpr_clip
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
dpr_clip:
    ; cmp     x23, x19
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x19
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    dpr_empty
    cmp BYTE PTR arm_c, 0
    jne dpr_empty
    ; sub     x21, x19, x23
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x23
    sub rax, rcx
    mov QWORD PTR arm_x21, rax
    ; lsr     x21, x21, #3
    mov rax, QWORD PTR arm_x21
    shr rax, 3
    mov QWORD PTR arm_x21, rax
    ; lea x22, throw_handler
    lea rax, throw_handler
    mov QWORD PTR arm_x22, rax
    ; ldr     x22, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x22, rax
    ; mov     x19, #0
    mov rax, 0
    mov QWORD PTR arm_x19, rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
dpr_count:
    ; cmp     x20, x21
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x21
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    dpr_counted
    cmp BYTE PTR arm_c, 0
    jne dpr_counted
    ; add     x0, x23, x20, lsl #3
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x20
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; cmp     x0, x22
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x22
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    dpr_one
    cmp BYTE PTR arm_z, 0
    je dpr_one
    ; add     x20, x20, #6
    mov rax, QWORD PTR arm_x20
    add rax, 6
    mov QWORD PTR arm_x20, rax
    ; b       dpr_count
    jmp dpr_count
dpr_one:
    ; add     x19, x19, #1
    mov rax, QWORD PTR arm_x19
    add rax, 1
    mov QWORD PTR arm_x19, rax
    ; add     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    add rax, 1
    mov QWORD PTR arm_x20, rax
    ; b       dpr_count
    jmp dpr_count
dpr_counted:
    ; cbz     x19, dpr_empty
    mov rax, QWORD PTR arm_x19
    cmp rax, 0
    je dpr_empty
    ; mov     x0, #40
    mov rax, 28h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_134
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_134:
    ; mov     x0, x19
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR arm_x0, rax
    ; bl      _print_unsigned
    lea rax, xret_135
    mov QWORD PTR arm_x30, rax
    jmp _print_unsigned
    xret_135:
    ; mov     x0, #41
    mov rax, 29h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_136
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_136:
    ; mov     x0, #58
    mov rax, 3Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_137
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_137:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_138
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_138:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
    ; mov     x19, #0
    mov rax, 0
    mov QWORD PTR arm_x19, rax
dpr_show:
    ; cmp     x20, x21
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x21
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    dpr_done
    cmp BYTE PTR arm_c, 0
    jne dpr_done
    ; cmp     x19, #4
    mov rax, QWORD PTR arm_x19
    cmp rax, 4
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    dpr_ellip
    cmp BYTE PTR arm_c, 0
    jne dpr_ellip
    ; add     x0, x23, x20, lsl #3
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x20
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; cmp     x0, x22
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x22
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    dpr_show_one
    cmp BYTE PTR arm_z, 0
    je dpr_show_one
    ; add     x20, x20, #6
    mov rax, QWORD PTR arm_x20
    add rax, 6
    mov QWORD PTR arm_x20, rax
    ; b       dpr_show
    jmp dpr_show
dpr_show_one:
    ; ldr     x0, [x23, x20, lsl #3]
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x20
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _print_unsigned
    lea rax, xret_139
    mov QWORD PTR arm_x30, rax
    jmp _print_unsigned
    xret_139:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_140
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_140:
    ; add     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    add rax, 1
    mov QWORD PTR arm_x20, rax
    ; add     x19, x19, #1
    mov rax, QWORD PTR arm_x19
    add rax, 1
    mov QWORD PTR arm_x19, rax
    ; b       dpr_show
    jmp dpr_show
dpr_ellip:
    ; mov     x0, #'.'
    mov rax, 2Eh
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_141
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_141:
    ; mov     x0, #'.'
    mov rax, 2Eh
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_142
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_142:
    ; mov     x0, #'.'
    mov rax, 2Eh
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_143
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_143:
    ; b       dpr_done
    jmp dpr_done
dpr_empty:
    ; mov     x0, #40
    mov rax, 28h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_144
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_144:
    ; mov     x0, #48
    mov rax, 30h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_145
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_145:
    ; mov     x0, #41
    mov rax, 29h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_146
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_146:
    ; mov     x0, #58
    mov rax, 3Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_147
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_147:
dpr_done:
    ; add     sp, sp, #32
    mov rax, rsp
    add rax, 20h
    mov rsp, rax
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_view_register_path:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
    ; mov     x20, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x20, rax
    ; cmp     x20, #0
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.le    vrp_fail
    cmp BYTE PTR arm_z, 0
    jne vrp_fail
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne vrp_fail
    ; cmp     x20, #255
    mov rax, QWORD PTR arm_x20
    cmp rax, 0FFh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    vrp_len_ok
    cmp BYTE PTR arm_c, 0
    je vrp_len_ok
    cmp BYTE PTR arm_z, 0
    jne vrp_len_ok
    ; mov     x20, #255
    mov rax, 0FFh
    mov QWORD PTR arm_x20, rax
vrp_len_ok:
    ; lea x21, view_file_n
    lea rax, view_file_n
    mov QWORD PTR arm_x21, rax
    ; ldr     x22, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x22, rax
    ; mov     x3, #1
    mov rax, 1
    mov QWORD PTR arm_x3, rax
vrp_search:
    ; cmp     x3, x22
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x22
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    vrp_append
    cmp BYTE PTR arm_c, 0
    je xsk_148
    cmp BYTE PTR arm_z, 0
    je vrp_append
    xsk_148:
    ; sub     x4, x3, #1
    mov rax, QWORD PTR arm_x3
    sub rax, 1
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #VIEW_PATH_MAX
    mov rax, 100h
    mov QWORD PTR arm_x5, rax
    ; mul     x4, x4, x5
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x5
    imul rax, rcx
    mov QWORD PTR arm_x4, rax
    ; lea x5, view_paths
    lea rax, view_paths
    mov QWORD PTR arm_x5, rax
    ; add     x5, x5, x4
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x4
    add rax, rcx
    mov QWORD PTR arm_x5, rax
    ; ldrb    w6, [x5]
    mov r10, QWORD PTR arm_x5
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; cmp     x6, x20
    mov rax, QWORD PTR arm_x6
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    vrp_next
    cmp BYTE PTR arm_z, 0
    je vrp_next
    ; mov     x7, #0
    mov rax, 0
    mov QWORD PTR arm_x7, rax
vrp_cmp:
    ; cmp     x7, x20
    mov rax, QWORD PTR arm_x7
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    vrp_found
    cmp BYTE PTR arm_c, 0
    jne vrp_found
    ; add     x8, x5, #1
    mov rax, QWORD PTR arm_x5
    add rax, 1
    mov QWORD PTR arm_x8, rax
    ; ldrb    w9, [x8, x7]
    mov r10, QWORD PTR arm_x8
    mov rax, QWORD PTR arm_x7
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x9, rax
    ; ldrb    w10, [x19, x7]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR arm_x7
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x10, rax
    ; cmp     w9, w10
    mov eax, DWORD PTR arm_x9
    mov ecx, DWORD PTR arm_x10
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    vrp_next
    cmp BYTE PTR arm_z, 0
    je vrp_next
    ; add     x7, x7, #1
    mov rax, QWORD PTR arm_x7
    add rax, 1
    mov QWORD PTR arm_x7, rax
    ; b       vrp_cmp
    jmp vrp_cmp
vrp_next:
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       vrp_search
    jmp vrp_search
vrp_append:
    ; cmp     x22, #VIEW_FILE_MAX
    mov rax, QWORD PTR arm_x22
    cmp rax, 100h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    vrp_fail
    cmp BYTE PTR arm_c, 0
    jne vrp_fail
    ; add     x22, x22, #1
    mov rax, QWORD PTR arm_x22
    add rax, 1
    mov QWORD PTR arm_x22, rax
    ; str     x22, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10], rax
    ; mov     x3, x22
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR arm_x3, rax
    ; sub     x4, x3, #1
    mov rax, QWORD PTR arm_x3
    sub rax, 1
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #VIEW_PATH_MAX
    mov rax, 100h
    mov QWORD PTR arm_x5, rax
    ; mul     x4, x4, x5
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x5
    imul rax, rcx
    mov QWORD PTR arm_x4, rax
    ; lea x5, view_paths
    lea rax, view_paths
    mov QWORD PTR arm_x5, rax
    ; add     x5, x5, x4
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x4
    add rax, rcx
    mov QWORD PTR arm_x5, rax
    ; strb    w20, [x5]
    mov r10, QWORD PTR arm_x5
    mov eax, DWORD PTR arm_x20
    mov BYTE PTR [r10], al
    ; mov     x7, #0
    mov rax, 0
    mov QWORD PTR arm_x7, rax
vrp_store:
    ; cmp     x7, x20
    mov rax, QWORD PTR arm_x7
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    vrp_found
    cmp BYTE PTR arm_c, 0
    jne vrp_found
    ; ldrb    w9, [x19, x7]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR arm_x7
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x9, rax
    ; add     x8, x5, #1
    mov rax, QWORD PTR arm_x5
    add rax, 1
    mov QWORD PTR arm_x8, rax
    ; strb    w9, [x8, x7]
    mov r10, QWORD PTR arm_x8
    mov rax, QWORD PTR arm_x7
    add r10, rax
    mov eax, DWORD PTR arm_x9
    mov BYTE PTR [r10], al
    ; add     x7, x7, #1
    mov rax, QWORD PTR arm_x7
    add rax, 1
    mov QWORD PTR arm_x7, rax
    ; b       vrp_store
    jmp vrp_store
vrp_found:
    ; mov     x0, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x0, rax
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
vrp_fail:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_view_line_now:
    ; lea x0, view_src_id
    lea rax, view_src_id
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _vln_none
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _vln_none
    ; lea x0, source_id
    lea rax, source_id
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _vln_none
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _vln_none
    ; b       _source_line_now
    jmp _source_line_now
_vln_none:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_source_line_now:
    ; lea x1, source_base
    lea rax, source_base
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, to_in
    lea rax, to_in
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; lea x4, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x4, rax
    ; ldr     x4, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     x4, _source_line_at
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    je _source_line_at
    ; lea x3, line_origin
    lea rax, line_origin
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; add     x4, x1, x2
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x4, rax
    ; sub     x2, x4, x3
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x3
    sub rax, rcx
    mov QWORD PTR arm_x2, rax
    ; mov     x1, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x1, rax
_source_line_at:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
_sla_loop:
    ; cmp     x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _sla_done
    cmp BYTE PTR arm_c, 0
    jne _sla_done
    ; ldrb    w4, [x1, x3]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x3
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _sla_next
    cmp BYTE PTR arm_z, 0
    je _sla_next
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
_sla_next:
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _sla_loop
    jmp _sla_loop
_sla_done:
    ; ret
    jmp QWORD PTR arm_x30
_view_set_src_from_pending:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, include_name_len
    lea rax, include_name_len
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _vset_clear
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _vset_clear
    ; lea x0, include_name_pending
    lea rax, include_name_pending
    mov QWORD PTR arm_x0, rax
    ; bl      _view_register_path
    lea rax, xret_149
    mov QWORD PTR arm_x30, rax
    jmp _view_register_path
    xret_149:
    ; lea x1, view_src_id
    lea rax, view_src_id
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_vset_clear:
    ; lea x1, view_src_id
    lea rax, view_src_id
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_view_push_src_id:
    ; lea x0, view_src_id
    lea rax, view_src_id
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, view_id_sp
    lea rax, view_id_sp
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cmp     x3, #8
    mov rax, QWORD PTR arm_x3
    cmp rax, 8
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _vpush_full
    cmp BYTE PTR arm_c, 0
    jne _vpush_full
    ; lea x4, view_id_stack
    lea rax, view_id_stack
    mov QWORD PTR arm_x4, rax
    ; str     x1, [x4, x3, lsl #3]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x3
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
_vpush_full:
    ; ret
    jmp QWORD PTR arm_x30
_view_pop_src_id:
    ; lea x2, view_id_sp
    lea rax, view_id_sp
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbz     x3, _vpop_empty
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    je _vpop_empty
    ; sub     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    sub rax, 1
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; lea x4, view_id_stack
    lea rax, view_id_stack
    mov QWORD PTR arm_x4, rax
    ; ldr     x1, [x4, x3, lsl #3]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x3
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x0, view_src_id
    lea rax, view_src_id
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; ret
    jmp QWORD PTR arm_x30
_vpop_empty:
    ; lea x0, view_src_id
    lea rax, view_src_id
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; ret
    jmp QWORD PTR arm_x30
_getchar:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x1, key_fn
    lea rax, key_fn
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, getchar_none
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je getchar_none
    ; blr     x1
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    mov r11, QWORD PTR arm_x1
    call r11
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; b       getchar_out
    jmp getchar_out
getchar_none:
    ; mov     x0, #-1
    mov rax, -1
    mov QWORD PTR arm_x0, rax
getchar_out:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
.CONST
str_dbg_keys:
    ; DCB "[Space/o/Return=over i=into u=out Esc/q=abort g=go h=help]", 0
    DB "[Space/o/Return=over i=into u=out Esc/q=abort g=go h=help]", 0
str_dbg_abort:
    ; DCB "DEBUG aborted", 10, 0
    DB "DEBUG aborted", 0Ah, 0
str_dbg_done:
    ; DCB "DEBUG done", 10, 0
    DB "DEBUG done", 0Ah, 0
str_traverse:
    ; DCB "(TRAVERSE)", 0
    DB "(TRAVERSE)", 0
.DATA
debug_armed:
    ; DCQ 0
    DQ 0
tdebug_armed:
    ; DCQ 0
    DQ 0
debug_midline:
    ; DCQ 0
    DQ 0
debug_field_count:
    ; DCQ 0
    DQ 0
debug_field_len:
    ; DCQ 0
    DQ 0
debug_help_shown:
    ; DCQ 0
    DQ 0
debug_cursor_on:
    ; DCQ 0
    DQ 0
debug_need_stacks:
    ; DCQ 0
    DQ 0
debug_need_intro:
    ; DCQ 0
    DQ 0
debug_line_col:
    ; DCQ 0
    DQ 0
debug_stack_anchor:
    ; DCQ 0
    DQ 0
debug_busy:
    ; DCQ 0
    DQ 0
debug_floor:
    ; DCQ 0
    DQ 0
debug_bp_go:
    ; DCQ 0
    DQ 0
debug_runto_ip:
    ; DCQ 0
    DQ 0
debug_runto_off:
    ; DCQ 0
    DQ 0
debug_runto_status:
    ; DCQ 0
    DQ 0
debug_break_asap:
    ; DCQ 0
    DQ 0
debug_break_min_cfa:
    ; DCQ 0
    DQ 0
debug_bp_xts:
    ; SPACE 64
    DB 64 DUP(0)
debug_bp_en:
    ; SPACE 64
    DB 64 DUP(0)
debug_over:
    ; DCQ 0
    DQ 0
debug_out:
    ; DCQ 0
    DQ 0
debug_abort:
    ; DCQ 0
    DQ 0
debug_show_xt:
    ; DCQ 0
    DQ 0
debug_sync_ok:
    ; DCQ 0
    DQ 0
debug_hl_xt:
    ; DCQ 0
    DQ 0
debug_wheel_xt:
    ; DCQ 0
    DQ 0
debug_pause_xt:
    ; DCQ 0
    DQ 0
debug_pause_rsp:
    ; DCQ 0
    DQ 0
debug_key_xt:
    ; DCQ 0
    DQ 0
debug_key_raw:
    ; DCQ 0
    DQ 0
debug_key_mode:
    ; DCQ 0
    DQ 0
debug_call_tos:
    ; DCQ 0
    DQ 0
debug_view_cfa:
    ; DCQ 0
    DQ 0
debug_view_name:
    ; SPACE 32
    DB 32 DUP(0)
debug_call_depth:
    ; DCQ 0
    DQ 0
    ; ALIGN 8
ALIGN 8
debug_vmsave_stack:
    ; SPACE 288
    DB 288 DUP(0)
debug_ret_cfa:
    ; DCQ XDBG_CALL_DONE
    DQ OFFSET XDBG_CALL_DONE
debug_ret_ipcell:
    ; DCQ debug_ret_cfa
    DQ OFFSET debug_ret_cfa
debug_skip_nl:
    ; DCQ 0
    DQ 0
debug_xt:
    ; DCQ 0
    DQ 0
debug_inline:
    ; DCQ 0
    DQ 0
debug_ip:
    ; DCQ 0
    DQ 0
debug_cfa:
    ; DCQ 0
    DQ 0
debug_body_cells:
    ; DCQ 0
    DQ 0
debug_scnt:
    ; DCQ 0
    DQ 0
debug_sbuf:
    ; SPACE 128
    DB 128 DUP(0)
debug_rcnt:
    ; DCQ 0
    DQ 0
debug_rbuf:
    ; SPACE 128
    DB 128 DUP(0)
debug_name:
    ; SPACE 32
    DB 32 DUP(0)
debug_rlab:
    ; SPACE 512
    DB 512 DUP(0)
debug_dsave_tos:
    ; DCQ 0
    DQ 0
debug_dsave_dsp:
    ; DCQ 0
    DQ 0
debug_dsave_n:
    ; DCQ 0
    DQ 0
debug_dsave_buf:
    ; SPACE 512
    DB 512 DUP(0)
    ; ALIGN 8
ALIGN 8
debug_nest_rstack:
    ; SPACE 16384
    DB 16384 DUP(0)
view_src_id:
    ; DCQ 0
    DQ 0
view_file_n:
    ; DCQ 0
    DQ 0
view_paths:
    ; SPACE 65536
    DB 65536 DUP(0)
view_id_sp:
    ; DCQ 0
    DQ 0
view_id_stack:
    ; SPACE 64
    DB 64 DUP(0)
include_name_len:
    ; DCQ 0
    DQ 0
include_name_pending:
    ; SPACE 256
    DB 256 DUP(0)
END
