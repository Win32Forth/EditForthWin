; NEXT stepper and the debugger words. Names and end fields match the Mac kernel.
; Mac rows for these words have no end label, so the end field stays 0.
; A Windows CATCH frame is six cells. The stepper skips that many.

DBG_HOME EQU 1

        INCLUDE Forth/kernel/arm64/vm.inc
        INCLUDE Forth/kernel/arm64/boot_words.inc

        AREA |.text|, CODE, READONLY, ALIGN=4

NFA_LEN_MASK    EQU 0x7F
VIEW_FILE_MASK  EQU 0x1FFF
VIEW_PATH_MAX   EQU 256
VIEW_FILE_MAX   EQU 256
DICT_THREADS    EQU 16
DEBUG_STACK_COL EQU 23
DEBUG_CALL_MAX  EQU 4
DEBUG_VMSAVE_SIZE EQU 72
DBG_DSAVE_MAX   EQU 64

        EXTERN _putchar
        EXTERN _print_signed
        EXTERN _print_unsigned
        EXTERN DOCOL
        EXTERN DODOES
        EXTERN XEXECUTE
        EXTERN XCATCH
        EXTERN XCATCH_OK
        EXTERN XTHROW
        EXTERN key_fn
        EXTERN data_stack
        EXTERN return_stack
        EXTERN throw_handler
        EXTERN here_ptr
        EXTERN user_dict_area
        EXTERN cfa_lit
        EXTERN cfa_branch
        EXTERN cfa_0branch
        EXTERN cfa_loop
        EXTERN cfa_plusloop
        EXTERN wordlist_reg
        EXTERN wordlist_reg_n
        EXTERN latest_var
        EXTERN catch_ok_cell
        EXTERN tw_continue_cell
        EXTERN tw_continue_cfa
        EXTERN host_debug_paint
        EXTERN host_debug_set_span
        EXTERN host_debug_get_span
        EXTERN source_id
        EXTERN source_base
        EXTERN to_in
        EXTERN line_mode
        EXTERN line_origin

        EXPORT next_debug
        EXPORT debug_break_asap
        EXPORT debug_armed
        EXPORT debug_busy
        EXPORT debug_bp_go
        EXPORT debug_bp_xts
        EXPORT debug_bp_en
        EXPORT debug_cfa
        EXPORT debug_xt
        EXPORT debug_name
        EXPORT view_file_n
        EXPORT view_paths
        EXPORT view_src_id
        EXPORT view_id_sp
        EXPORT include_name_pending
        EXPORT include_name_len
        EXPORT _view_line_now
        EXPORT _view_push_src_id
        EXPORT _view_pop_src_id
        EXPORT _view_set_src_from_pending
        EXPORT debug_runto_ip
        EXPORT debug_runto_off
        EXPORT debug_runto_status
        EXPORT debug_floor
        EXPORT debug_field_count
        EXPORT debug_field_len
        EXPORT _debug_note_byte
        EXPORT _getchar

        MACRO
        PUSH_ADDR $sym
        str     x20, [x22, #-8]!
        adrp    x20, $sym
        add     x20, x20, $sym
        MEND

        MACRO
        PUSH_VAL $sym
        str     x20, [x22, #-8]!
        adrp    x20, $sym
        add     x20, x20, $sym
        ldr     x20, [x20]
        MEND

; Armed NEXT. x28 is the hot-path mirror of debug_armed.
; next_debug_gate is the in-file target of the NEXT macro.
next_debug_gate
next_debug
        adrp    x1, debug_busy
        add     x1, x1, debug_busy
        ldr     x2, [x1]
        cbnz    x2, nd_exec
        adrp    x2, debug_break_asap
        add     x2, x2, debug_break_asap
        ldr     x3, [x2]
        cbz     x3, nd_floor
        ldr     x21, [x19]
        mov     x3, #1
        mov     x28, x3
        adrp    x4, debug_armed
        add     x4, x4, debug_armed
        ldr     x5, [x4]
        str     x3, [x4]
        cbnz    x5, nd_asap_floor
        adrp    x4, debug_need_intro
        add     x4, x4, debug_need_intro
        str     x3, [x4]
nd_asap_floor
        adrp    x4, debug_floor
        add     x4, x4, debug_floor
        str     xzr, [x4]
        adrp    x4, debug_bp_go
        add     x4, x4, debug_bp_go
        str     xzr, [x4]
        adrp    x4, debug_runto_ip
        add     x4, x4, debug_runto_ip
        str     xzr, [x4]
        adrp    x4, debug_over
        add     x4, x4, debug_over
        str     xzr, [x4]
        adrp    x4, debug_out
        add     x4, x4, debug_out
        str     xzr, [x4]
        adrp    x4, debug_break_min_cfa
        add     x4, x4, debug_break_min_cfa
        ldr     x4, [x4]
        cbz     x4, nd_asap_hit
        mov     x0, x19
        mov     x1, x21
        stp     x29, x30, [sp, #-16]!
        bl      _debug_resolve_enclosing
        ldp     x29, x30, [sp], #16
        cbz     x0, nd_exec
        adrp    x4, debug_break_min_cfa
        add     x4, x4, debug_break_min_cfa
        ldr     x4, [x4]
        cmp     x0, x4
        b.lo    nd_exec
nd_asap_hit
        adrp    x2, debug_break_asap
        add     x2, x2, debug_break_asap
        str     xzr, [x2]
        add     x3, x23, #8
        adrp    x4, debug_floor
        add     x4, x4, debug_floor
        str     x3, [x4]
        b       nd_force
nd_floor
        adrp    x2, debug_floor
        add     x2, x2, debug_floor
        ldr     x2, [x2]
        cbz     x2, nd_out
        cmp     x23, x2
        b.lo    nd_out
        b.eq    nd_exec
        mov     x28, #0
        adrp    x3, debug_armed
        add     x3, x3, debug_armed
        str     xzr, [x3]
        adrp    x3, debug_bp_go
        add     x3, x3, debug_bp_go
        str     xzr, [x3]
        adrp    x3, debug_runto_ip
        add     x3, x3, debug_runto_ip
        str     xzr, [x3]
        adrp    x3, debug_break_asap
        add     x3, x3, debug_break_asap
        str     xzr, [x3]
        stp     x29, x30, [sp, #-16]!
        bl      host_debug_paint
        ldp     x29, x30, [sp], #16
        b       nd_exec
nd_out
        adrp    x2, debug_out
        add     x2, x2, debug_out
        ldr     x2, [x2]
        cbz     x2, nd_over
        cmp     x23, x2
        b.ls    nd_exec
nd_over
        adrp    x2, debug_over
        add     x2, x2, debug_over
        ldr     x2, [x2]
        cbz     x2, nd_peek
        cmp     x23, x2
        b.lo    nd_exec
nd_peek
        ldr     x21, [x19]
        adrp    x2, debug_runto_ip
        add     x2, x2, debug_runto_ip
        ldr     x3, [x2]
        cbz     x3, nd_bp
        cmp     x19, x3
        b.ne    nd_runto_miss
        str     xzr, [x2]
        adrp    x2, debug_bp_go
        add     x2, x2, debug_bp_go
        str     xzr, [x2]
        b       nd_force
nd_runto_miss
        adrp    x2, debug_bp_go
        add     x2, x2, debug_bp_go
        ldr     x3, [x2]
        cbz     x3, nd_exec
        b       nd_scan
nd_bp
        adrp    x2, debug_bp_go
        add     x2, x2, debug_bp_go
        ldr     x3, [x2]
        cbz     x3, nd_force
nd_scan
        adrp    x3, debug_bp_xts
        add     x3, x3, debug_bp_xts
        adrp    x6, debug_bp_en
        add     x6, x6, debug_bp_en
        mov     x4, #8
nd_scan_loop
        ldr     x5, [x3], #8
        ldr     x7, [x6], #8
        cbz     x5, nd_scan_next
        cbz     x7, nd_scan_next
        cmp     x5, x21
        b.eq    nd_scan_hit
nd_scan_next
        subs    x4, x4, #1
        b.ne    nd_scan_loop
        b       nd_exec
nd_scan_hit
        adrp    x2, debug_bp_go
        add     x2, x2, debug_bp_go
        str     xzr, [x2]
        adrp    x3, debug_runto_ip
        add     x3, x3, debug_runto_ip
        str     xzr, [x3]
nd_force
        ldr     x2, [x21]
        adrp    x3, XCATCH_OK
        add     x3, x3, XCATCH_OK
        cmp     x2, x3
        b.eq    nd_exec
        adrp    x3, XDBGOFF
        add     x3, x3, XDBGOFF
        cmp     x2, x3
        b.eq    nd_exec
        adrp    x2, debug_over
        add     x2, x2, debug_over
        str     xzr, [x2]
        adrp    x2, debug_out
        add     x2, x2, debug_out
        str     xzr, [x2]
        adrp    x1, debug_busy
        add     x1, x1, debug_busy
        mov     x2, #1
        str     x2, [x1]
        stp     x29, x30, [sp, #-16]!
        bl      _debug_pause
        ldp     x29, x30, [sp], #16
        adrp    x1, debug_busy
        add     x1, x1, debug_busy
        str     xzr, [x1]
        adrp    x1, debug_abort
        add     x1, x1, debug_abort
        ldr     x2, [x1]
        cbz     x2, nd_exec
        str     xzr, [x1]
        mov     x20, x2
        b       XTHROW
nd_exec
        ldr     x21, [x19], #8
        ldr     x1, [x21]
        br      x1

; ---------------------------------------------------------------------
; Address and snapshot words
; ---------------------------------------------------------------------

        BOOT_WORD DBG-SHOW-XT, DBG-SHOW-XT ( -- addr ) xt of the view sync word or 0, 0, XDBGSHOWXT, 0
XDBGSHOWXT
        PUSH_ADDR debug_show_xt
        NEXT

        BOOT_WORD DBG-SYNC-OK, DBG-SYNC-OK ( -- addr ) set 1 after a debug VIEW, 0, XDBGSYNCOK, 0
XDBGSYNCOK
        PUSH_ADDR debug_sync_ok
        NEXT

        BOOT_WORD DBG-HL-XT, DBG-HL-XT ( -- addr ) xt of the highlight word or 0, 0, XDBGHLXT, 0
XDBGHLXT
        PUSH_ADDR debug_hl_xt
        NEXT

        BOOT_WORD DBG-WHEEL-XT, DBG-WHEEL-XT ( -- addr ) xt of the wheel word or 0, 0, XDBGWHEELXT, 0
XDBGWHEELXT
        PUSH_ADDR debug_wheel_xt
        NEXT

        BOOT_WORD DBG-PAUSE-XT, DBG-PAUSE-XT ( -- addr ) Forth pause xt or 0, 0, XDBGPAUSEXT, 0
XDBGPAUSEXT
        PUSH_ADDR debug_pause_xt
        NEXT

        BOOT_WORD DBG-KEY-XT, DBG-KEY-XT ( -- addr ) Forth key mode xt or 0, 0, XDBGKEYXT, 0
XDBGKEYXT
        PUSH_ADDR debug_key_xt
        NEXT

        BOOT_WORD DBG-INLINE, DBG-INLINE ( -- x ) cell after the paused IP, 0, XDBGINLINE, 0
XDBGINLINE
        PUSH_VAL debug_inline
        NEXT

        BOOT_WORD DBG-TOS@, DBG-TOS@ ( -- x ) data TOS at the last pause or 0, 0, XDBGTOSAT, 0
XDBGTOSAT
        str     x20, [x22, #-8]!
        adrp    x0, debug_scnt
        add     x0, x0, debug_scnt
        ldr     x0, [x0]
        cbz     x0, dbg_tos_empty
        adrp    x1, debug_sbuf
        add     x1, x1, debug_sbuf
        sub     x0, x0, #1
        ldr     x20, [x1, x0, lsl #3]
        NEXT
dbg_tos_empty
        mov     x20, #0
        NEXT

        BOOT_WORD DBG-XT@, DBG-XT@ ( -- xt ) upcoming xt at the last pause, 0, XDBGXTAT, 0
XDBGXTAT
        PUSH_VAL debug_xt
        NEXT

        BOOT_WORD DBG-IP@, DBG-IP@ ( -- ip ) paused IP, 0, XDBGIPAT, 0
XDBGIPAT
        PUSH_VAL debug_ip
        NEXT

        BOOT_WORD DBG-CFA@, DBG-CFA@ ( -- cfa|0 ) enclosing colon at the last pause, 0, XDBGCFAAT, 0
XDBGCFAAT
        PUSH_VAL debug_cfa
        NEXT

        BOOT_WORD DBG-BODY#, DBG-BODY# ( -- u ) body cell index of the paused IP, 0, XDBGBODYN, 0
XDBGBODYN
        PUSH_VAL debug_body_cells
        NEXT

        BOOT_WORD DBG-NEED-INTRO, DBG-NEED-INTRO ( -- addr ), 0, XDBGNEEDINTRO, 0
XDBGNEEDINTRO
        PUSH_ADDR debug_need_intro
        NEXT

        BOOT_WORD DBG-NEED-STACKS, DBG-NEED-STACKS ( -- addr ), 0, XDBGNEEDSTACKS, 0
XDBGNEEDSTACKS
        PUSH_ADDR debug_need_stacks
        NEXT

        BOOT_WORD DBG-HELP-SHOWN, DBG-HELP-SHOWN ( -- addr ), 0, XDBGHELPSHOWN, 0
XDBGHELPSHOWN
        PUSH_ADDR debug_help_shown
        NEXT

        BOOT_WORD DBG-SKIP-NL, DBG-SKIP-NL ( -- addr ), 0, XDBGSKIPNL, 0
XDBGSKIPNL
        PUSH_ADDR debug_skip_nl
        NEXT

        BOOT_WORD DBG-MIDLINE, DBG-MIDLINE ( -- addr ), 0, XDBGMIDLINE, 0
XDBGMIDLINE
        PUSH_ADDR debug_midline
        NEXT

        BOOT_WORD DBG-LINE-COL, DBG-LINE-COL ( -- addr ), 0, XDBGLINECOL, 0
XDBGLINECOL
        PUSH_ADDR debug_line_col
        NEXT

        BOOT_WORD DBG-.SR, DBG-.SR ( -- ) pad to the stack column and print S and R, 0, XDBGDOTSR, 0
XDBGDOTSR
        stp     x29, x30, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!
        adrp    x0, debug_busy
        add     x0, x0, debug_busy
        ldr     x0, [x0]
        cbz     x0, dbg_sr_live
        adrp    x0, debug_pause_rsp
        add     x0, x0, debug_pause_rsp
        ldr     x0, [x0]
        cbz     x0, dbg_sr_live
        mov     x23, x0
dbg_sr_live
        bl      _debug_pad_to_stack_col
        bl      _debug_print_SR
        ldp     x23, x24, [sp], #16
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-CURSOR-ON, DBG-CURSOR-ON ( -- ), 0, XDBGCURON, 0
XDBGCURON
        stp     x29, x30, [sp, #-16]!
        bl      _debug_cursor_on
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-CURSOR-OFF, DBG-CURSOR-OFF ( -- ), 0, XDBGCUROFF, 0
XDBGCUROFF
        stp     x29, x30, [sp, #-16]!
        bl      _debug_cursor_off
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-PRINT-INLINE, DBG-PRINT-INLINE ( -- ) LIT or branch suffix after the name, 0, XDBGPRINTINL, 0
XDBGPRINTINL
        stp     x29, x30, [sp, #-16]!
        bl      _debug_print_inline_suffix
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-PRINT-NAME, DBG-PRINT-NAME ( -- ) print the paused xt name, 0, XDBGPRINTNAME, 0
XDBGPRINTNAME
        stp     x29, x30, [sp, #-16]!
        adrp    x0, debug_xt
        add     x0, x0, debug_xt
        ldr     x0, [x0]
        bl      _print_xt_name
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-XT-INTOABLE?, DBG-XT-INTOABLE? ( -- flag ) true when the paused xt can nest, 0, XDBGINTOABLE, 0
XDBGINTOABLE
        stp     x29, x30, [sp, #-16]!
        adrp    x0, debug_xt
        add     x0, x0, debug_xt
        ldr     x0, [x0]
        bl      _debug_xt_intoable
        ldp     x29, x30, [sp], #16
        str     x20, [x22, #-8]!
        mov     x20, x0
        NEXT

        BOOT_WORD DBG-HOST-PAINT, DBG-HOST-PAINT ( -- ) refresh the editor debug pane, 0, XDBGHOSTPAINT, 0
XDBGHOSTPAINT
        stp     x29, x30, [sp, #-16]!
        bl      host_debug_paint
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-HOST-SPAN, DBG-HOST-SPAN ( off len -- ) pending editor highlight span, 0, XDBGHOSTSPAN, 0
XDBGHOSTSPAN
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_debug_set_span
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-HOST-SPAN@, DBG-HOST-SPAN@ ( -- off len ) peek the pending highlight span, 0, XDBGHOSTSPANAT, 0
XDBGHOSTSPANAT
        sub     sp, sp, #32
        stp     x29, x30, [sp, #16]
        mov     x0, sp
        add     x1, sp, #8
        str     xzr, [sp]
        str     xzr, [sp, #8]
        bl      host_debug_get_span
        ldr     x1, [sp]
        ldr     x2, [sp, #8]
        ldp     x29, x30, [sp, #16]
        add     sp, sp, #32
        str     x20, [x22, #-8]!
        mov     x20, x1
        str     x20, [x22, #-8]!
        mov     x20, x2
        NEXT

        BOOT_WORD DBG-VIEW-UPDATE, DBG-VIEW-UPDATE ( -- ) sync VIEW highlight and paint, 0, XDBGVIEWUPD, 0
XDBGVIEWUPD
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!
        bl      _debug_sync_view
        bl      _debug_highlight
        bl      host_debug_paint
        ldp     x23, x24, [sp], #16
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-WHEEL-DO, DBG-WHEEL-DO ( u -- ) wheel or resize while paused, 0, XDBGWHEELDO, 0
XDBGWHEELDO
        mov     x0, x20
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!
        bl      _debug_wheel
        ldp     x23, x24, [sp], #16
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-STEP-OVER, DBG-STEP-OVER ( -- ) step over a colon word, 0, XDBGSTEPOVER, 0
XDBGSTEPOVER
        stp     x29, x30, [sp, #-16]!
        bl      _debug_cursor_off
        mov     x1, #1
        adrp    x0, debug_need_stacks
        add     x0, x0, debug_need_stacks
        str     x1, [x0]
        adrp    x1, debug_out
        add     x1, x1, debug_out
        str     xzr, [x1]
        adrp    x1, debug_over
        add     x1, x1, debug_over
        str     xzr, [x1]
        adrp    x0, debug_xt
        add     x0, x0, debug_xt
        ldr     x0, [x0]
        cbz     x0, dbg_over_done
        ldr     x0, [x0]
        adrp    x2, DOCOL
        add     x2, x2, DOCOL
        cmp     x0, x2
        b.ne    dbg_over_done
        adrp    x0, debug_pause_rsp
        add     x0, x0, debug_pause_rsp
        ldr     x0, [x0]
        str     x0, [x1]
dbg_over_done
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-STEP-INTO, DBG-STEP-INTO ( -- ) step into the next xt, 0, XDBGSTEPINTO, 0
XDBGSTEPINTO
        stp     x29, x30, [sp, #-16]!
        bl      _debug_cursor_off
        mov     x1, #1
        adrp    x0, debug_need_stacks
        add     x0, x0, debug_need_stacks
        str     x1, [x0]
        adrp    x1, debug_out
        add     x1, x1, debug_out
        str     xzr, [x1]
        adrp    x1, debug_over
        add     x1, x1, debug_over
        str     xzr, [x1]
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-STEP-OUT, DBG-STEP-OUT ( -- ) run until this colon returns, 0, XDBGSTEPOUT, 0
XDBGSTEPOUT
        stp     x29, x30, [sp, #-16]!
        bl      _debug_cursor_off
        mov     x1, #1
        adrp    x0, debug_need_stacks
        add     x0, x0, debug_need_stacks
        str     x1, [x0]
        adrp    x1, debug_over
        add     x1, x1, debug_over
        str     xzr, [x1]
        adrp    x1, debug_out
        add     x1, x1, debug_out
        adrp    x0, debug_pause_rsp
        add     x0, x0, debug_pause_rsp
        ldr     x0, [x0]
        str     x0, [x1]
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-GO, DBG-GO ( -- ) disarm unless a breakpoint or run-to is armed, 0, XDBGGO, 0
XDBGGO
        stp     x29, x30, [sp, #-16]!
        bl      _debug_cursor_off
        bl      _debug_clear_step
        adrp    x1, debug_bp_go
        add     x1, x1, debug_bp_go
        ldr     x0, [x1]
        cbnz    x0, dbg_go_keep
        adrp    x1, debug_runto_ip
        add     x1, x1, debug_runto_ip
        ldr     x0, [x1]
        cbnz    x0, dbg_go_keep
        mov     x28, #0
        adrp    x1, debug_armed
        add     x1, x1, debug_armed
        str     xzr, [x1]
        adrp    x1, debug_bp_go
        add     x1, x1, debug_bp_go
        str     xzr, [x1]
        adrp    x1, debug_runto_ip
        add     x1, x1, debug_runto_ip
        str     xzr, [x1]
        adrp    x1, debug_break_asap
        add     x1, x1, debug_break_asap
        str     xzr, [x1]
        bl      host_debug_paint
dbg_go_keep
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD DBG-ABORT-SESSION, DBG-ABORT-SESSION ( -- ) disarm and THROW -1, 0, XDBGABORT, 0
XDBGABORT
        stp     x29, x30, [sp, #-16]!
        bl      _debug_cursor_off
        bl      _debug_clear_step
        adrp    x0, str_dbg_abort
        add     x0, x0, str_dbg_abort
        bl      _emit_z
        bl      _debug_disarm
        bl      host_debug_paint
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD TDBG-ARM-KEYS, TDBG-ARM-KEYS ( -- ) arm the host debug-key steal, 0, XTDBGARM, 0
XTDBGARM
        adrp    x0, tdebug_armed
        add     x0, x0, tdebug_armed
        mov     x1, #1
        str     x1, [x0]
        NEXT

        BOOT_WORD TDBG-DISARM-KEYS, TDBG-DISARM-KEYS ( -- ) disarm the host debug-key steal, 0, XTDBGDISARM, 0
XTDBGDISARM
        adrp    x0, tdebug_armed
        add     x0, x0, tdebug_armed
        str     xzr, [x0]
        NEXT

        BOOT_WORD DBG-BREAK-MIN!, DBG-BREAK-MIN! ( addr -- ) low water for Break ASAP, 0, XDBGBREAKMIN, 0
XDBGBREAKMIN
        adrp    x0, debug_break_min_cfa
        add     x0, x0, debug_break_min_cfa
        str     x20, [x0]
        ldr     x20, [x22], #8
        NEXT

        BOOT_WORD DBG-ON, DBG-ON ( -- ) arm the NEXT stepper, 0, XDBGON, 0
XDBGON
        adrp    x0, debug_floor
        add     x0, x0, debug_floor
        str     x23, [x0]
        mov     x1, #1
        mov     x28, x1
        adrp    x0, debug_armed
        add     x0, x0, debug_armed
        str     x1, [x0]
        adrp    x0, debug_bp_go
        add     x0, x0, debug_bp_go
        str     xzr, [x0]
        adrp    x0, debug_runto_ip
        add     x0, x0, debug_runto_ip
        str     xzr, [x0]
        adrp    x0, debug_runto_off
        add     x0, x0, debug_runto_off
        str     xzr, [x0]
        adrp    x0, debug_runto_status
        add     x0, x0, debug_runto_status
        str     xzr, [x0]
        adrp    x0, debug_break_asap
        add     x0, x0, debug_break_asap
        str     xzr, [x0]
        adrp    x0, debug_over
        add     x0, x0, debug_over
        str     xzr, [x0]
        adrp    x0, debug_out
        add     x0, x0, debug_out
        str     xzr, [x0]
        adrp    x0, debug_abort
        add     x0, x0, debug_abort
        str     xzr, [x0]
        adrp    x0, debug_view_cfa
        add     x0, x0, debug_view_cfa
        str     xzr, [x0]
        adrp    x0, debug_skip_nl
        add     x0, x0, debug_skip_nl
        str     x1, [x0]
        adrp    x0, debug_midline
        add     x0, x0, debug_midline
        str     xzr, [x0]
        adrp    x0, debug_help_shown
        add     x0, x0, debug_help_shown
        str     xzr, [x0]
        adrp    x0, debug_cursor_on
        add     x0, x0, debug_cursor_on
        str     xzr, [x0]
        adrp    x0, debug_need_stacks
        add     x0, x0, debug_need_stacks
        str     xzr, [x0]
        adrp    x0, debug_need_intro
        add     x0, x0, debug_need_intro
        str     x1, [x0]
        adrp    x0, debug_line_col
        add     x0, x0, debug_line_col
        str     xzr, [x0]
        adrp    x0, debug_stack_anchor
        add     x0, x0, debug_stack_anchor
        str     xzr, [x0]
        adrp    x0, debug_ip
        add     x0, x0, debug_ip
        str     xzr, [x0]
        adrp    x0, debug_cfa
        add     x0, x0, debug_cfa
        str     xzr, [x0]
        adrp    x0, debug_body_cells
        add     x0, x0, debug_body_cells
        str     xzr, [x0]
        adrp    x0, debug_call_depth
        add     x0, x0, debug_call_depth
        str     xzr, [x0]
        NEXT

        BOOT_WORD DBG-OFF, DBG-OFF ( -- ) disarm the NEXT stepper, 0, XDBGOFF, 0
XDBGOFF
        mov     x28, #0
        adrp    x0, debug_armed
        add     x0, x0, debug_armed
        str     xzr, [x0]
        adrp    x0, debug_call_depth
        add     x0, x0, debug_call_depth
        str     xzr, [x0]
        adrp    x0, debug_midline
        add     x0, x0, debug_midline
        str     xzr, [x0]
        adrp    x0, debug_help_shown
        add     x0, x0, debug_help_shown
        str     xzr, [x0]
        adrp    x0, debug_cursor_on
        add     x0, x0, debug_cursor_on
        str     xzr, [x0]
        adrp    x0, debug_need_stacks
        add     x0, x0, debug_need_stacks
        str     xzr, [x0]
        adrp    x0, debug_need_intro
        add     x0, x0, debug_need_intro
        str     xzr, [x0]
        adrp    x0, debug_line_col
        add     x0, x0, debug_line_col
        str     xzr, [x0]
        adrp    x0, debug_stack_anchor
        add     x0, x0, debug_stack_anchor
        str     xzr, [x0]
        adrp    x0, debug_ip
        add     x0, x0, debug_ip
        str     xzr, [x0]
        adrp    x0, debug_cfa
        add     x0, x0, debug_cfa
        str     xzr, [x0]
        adrp    x0, debug_body_cells
        add     x0, x0, debug_body_cells
        str     xzr, [x0]
        adrp    x0, debug_floor
        add     x0, x0, debug_floor
        str     xzr, [x0]
        adrp    x0, debug_over
        add     x0, x0, debug_over
        str     xzr, [x0]
        adrp    x0, debug_out
        add     x0, x0, debug_out
        str     xzr, [x0]
        adrp    x0, debug_bp_go
        add     x0, x0, debug_bp_go
        str     xzr, [x0]
        adrp    x0, debug_runto_ip
        add     x0, x0, debug_runto_ip
        str     xzr, [x0]
        adrp    x0, debug_runto_off
        add     x0, x0, debug_runto_off
        str     xzr, [x0]
        adrp    x0, debug_runto_status
        add     x0, x0, debug_runto_status
        str     xzr, [x0]
        adrp    x0, debug_break_asap
        add     x0, x0, debug_break_asap
        str     xzr, [x0]
        adrp    x0, debug_abort
        add     x0, x0, debug_abort
        str     xzr, [x0]
        adrp    x0, debug_view_cfa
        add     x0, x0, debug_view_cfa
        str     xzr, [x0]
        stp     x29, x30, [sp, #-16]!
        bl      host_debug_paint
        adrp    x0, str_dbg_done
        add     x0, x0, str_dbg_done
        bl      _emit_z
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD BREAK-TABLE, BREAK-TABLE ( -- addr ) 8 breakpoint xt slots, 0, XBREAK_TABLE, 0
XBREAK_TABLE
        PUSH_ADDR debug_bp_xts
        NEXT

        BOOT_WORD BREAK-ENABLES, BREAK-ENABLES ( -- addr ) 8 breakpoint enable flags, 0, XBREAK_ENABLES, 0
XBREAK_ENABLES
        PUSH_ADDR debug_bp_en
        NEXT

        BOOT_WORD (BP-GO), (BP-GO) ( -- ) run until an enabled breakpoint xt, 0, XBPGO, 0
XBPGO
        adrp    x0, debug_bp_go
        add     x0, x0, debug_bp_go
        mov     x1, #1
        str     x1, [x0]
        NEXT

        BOOT_WORD (RUNTO-IP), (RUNTO-IP) ( addr -- ) arm run-to at a threaded cell, 0, XRUNTOIP, 0
XRUNTOIP
        mov     x0, x20
        ldr     x20, [x22], #8
        adrp    x1, debug_runto_ip
        add     x1, x1, debug_runto_ip
        str     x0, [x1]
        NEXT

        BOOT_WORD RUNTO-OFF@, RUNTO-OFF@ ( -- off ) pending file offset for run-to, 0, XRUNTOOFFAT, 0
XRUNTOOFFAT
        PUSH_VAL debug_runto_off
        NEXT

        BOOT_WORD RUNTO-STATUS!, RUNTO-STATUS! ( n -- ) store the host run-to status, 0, XRUNTOSTAT, 0
XRUNTOSTAT
        mov     x0, x20
        ldr     x20, [x22], #8
        adrp    x1, debug_runto_status
        add     x1, x1, debug_runto_status
        str     x0, [x1]
        NEXT

        BOOT_WORD VIEW-PATH, VIEW-PATH ( id -- c-addr u | 0 0 ) path for a VIEW file id, 0, XVIEW_PATH, 0
XVIEW_PATH
        mov     x1, x20
        cbz     x1, view_path_none
        adrp    x0, view_file_n
        add     x0, x0, view_file_n
        ldr     x0, [x0]
        cmp     x1, x0
        b.hi    view_path_none
        sub     x2, x1, #1
        mov     x3, #VIEW_PATH_MAX
        mul     x2, x2, x3
        adrp    x0, view_paths
        add     x0, x0, view_paths
        add     x0, x0, x2
        ldrb    w2, [x0]
        add     x3, x0, #1
        str     x3, [x22, #-8]!
        mov     x20, x2
        NEXT
view_path_none
        str     xzr, [x22, #-8]!
        mov     x20, #0
        NEXT

        BOOT_WORD VIEW-REG, VIEW-REG ( c-addr u -- id ) register a source path for VIEW, 0, XVIEW_REG, 0
XVIEW_REG
        mov     x1, x20
        ldr     x0, [x22], #8
        cmp     x1, #0
        b.le    view_reg_fail
        cmp     x1, #255
        b.hi    view_reg_fail
        cbz     x0, view_reg_fail
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        bl      _view_register_path
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        mov     x20, x0
        NEXT
view_reg_fail
        mov     x20, #0
        NEXT

        BOOT_WORD VIEW-STAMP, VIEW-STAMP ( xt file-id line -- ) set the source VIEW in the header, 0, XVIEW_STAMP, 0
XVIEW_STAMP
        mov     x3, x20
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        ldr     x20, [x22], #8
        cbz     x1, view_stamp_done
        ldr     x0, [x1, #-8]
        mov     x4, #0xFFFF
        lsl     x4, x4, #32
        bic     x0, x0, x4
        mov     x4, #VIEW_FILE_MASK
        lsl     x4, x4, #48
        bic     x0, x0, x4
        and     x3, x3, #0xFFFF
        lsl     x3, x3, #32
        orr     x0, x0, x3
        mov     x4, #VIEW_FILE_MASK
        and     x2, x2, x4
        lsl     x2, x2, #48
        orr     x0, x0, x2
        str     x0, [x1, #-8]
view_stamp_done
        NEXT

; ---------------------------------------------------------------------
; Pause and helpers
; ---------------------------------------------------------------------

_debug_pause
        stp     x29, x30, [sp, #-64]!
        stp     x19, x20, [sp, #16]
        stp     x21, x22, [sp, #32]
        stp     x23, x24, [sp, #48]
        adrp    x0, debug_pause_rsp
        add     x0, x0, debug_pause_rsp
        str     x23, [x0]
        adrp    x0, debug_xt
        add     x0, x0, debug_xt
        str     x21, [x0]
        ldr     x0, [x19, #8]
        adrp    x1, debug_inline
        add     x1, x1, debug_inline
        str     x0, [x1]
        adrp    x0, debug_ip
        add     x0, x0, debug_ip
        str     x19, [x0]
        mov     x0, x19
        mov     x1, x21
        bl      _debug_resolve_enclosing
        adrp    x2, debug_cfa
        add     x2, x2, debug_cfa
        str     x0, [x2]
        lsr     x1, x1, #3
        adrp    x2, debug_body_cells
        add     x2, x2, debug_body_cells
        str     x1, [x2]
        adrp    x0, tw_continue_cell
        add     x0, x0, tw_continue_cell
        cmp     x19, x0
        b.eq    pause_leave
        adrp    x0, debug_pause_xt
        add     x0, x0, debug_pause_xt
        ldr     x0, [x0]
        cbz     x0, pause_asm
        bl      _debug_capture
        adrp    x0, debug_pause_xt
        add     x0, x0, debug_pause_xt
        ldr     x0, [x0]
        bl      _debug_call_xt
        b       pause_leave
pause_asm
        adrp    x0, debug_need_intro
        add     x0, x0, debug_need_intro
        ldr     x1, [x0]
        cbz     x1, pause_after
        str     xzr, [x0]
        bl      _debug_end_line
        adrp    x0, str_dbg_keys
        add     x0, x0, str_dbg_keys
        bl      _emit_z
        mov     x0, #10
        bl      _putchar
        bl      _debug_pad_to_stack_col
        bl      _debug_print_SR
        mov     x0, #10
        bl      _putchar
        b       pause_word
pause_after
        adrp    x0, debug_need_stacks
        add     x0, x0, debug_need_stacks
        ldr     x1, [x0]
        cbz     x1, pause_word
        str     xzr, [x0]
        adrp    x0, debug_help_shown
        add     x0, x0, debug_help_shown
        ldr     x1, [x0]
        cbz     x1, pause_pad_sr
        str     xzr, [x0]
        mov     x0, #10
        bl      _putchar
pause_pad_sr
        bl      _debug_pad_to_stack_col
        bl      _debug_print_SR
        mov     x0, #10
        bl      _putchar
pause_word
        adrp    x0, debug_line_col
        add     x0, x0, debug_line_col
        str     xzr, [x0]
        mov     x0, x21
        bl      _debug_xt_intoable
        cbz     x0, pause_chevrons
        mov     x0, #'I'
        bl      _putchar
pause_chevrons
        mov     x0, #62
        bl      _putchar
        mov     x0, #62
        bl      _putchar
        mov     x0, #32
        bl      _putchar
        mov     x0, x21
        bl      _print_xt_name
        bl      _debug_print_inline_suffix
        mov     x0, #32
        bl      _putchar
        bl      _debug_cursor_on
        bl      _debug_capture
        bl      _debug_sync_view
        bl      _debug_highlight
        bl      host_debug_paint
pause_key
        bl      _getchar
        tbnz    x0, #63, pause_key_abort
        adrp    x2, debug_key_xt
        add     x2, x2, debug_key_xt
        ldr     x2, [x2]
        cbz     x2, pause_asm_key
        adrp    x1, debug_key_raw
        add     x1, x1, debug_key_raw
        str     x0, [x1]
        bl      _debug_ds_isolate
        adrp    x1, debug_key_raw
        add     x1, x1, debug_key_raw
        ldr     x20, [x1]
        adrp    x0, debug_key_xt
        add     x0, x0, debug_key_xt
        ldr     x0, [x0]
        bl      _debug_call_xt
        adrp    x1, debug_call_tos
        add     x1, x1, debug_call_tos
        ldr     x1, [x1]
        adrp    x0, debug_key_mode
        add     x0, x0, debug_key_mode
        str     x1, [x0]
        bl      _debug_ds_restore
        adrp    x0, debug_key_mode
        add     x0, x0, debug_key_mode
        ldr     x0, [x0]
        cbz     x0, pause_key
        cmp     x0, #1
        b.eq    pause_over
        cmp     x0, #2
        b.eq    pause_into
        cmp     x0, #3
        b.eq    pause_out
        cmp     x0, #4
        b.eq    pause_go
        cmp     x0, #5
        b.eq    pause_key_abort
        cmp     x0, #6
        b.eq    pause_wheel_key
        cmp     x0, #7
        b.eq    pause_help
        adrp    x0, debug_key_raw
        add     x0, x0, debug_key_raw
        ldr     x0, [x0]
pause_asm_key
        lsr     x1, x0, #24
        and     x1, x1, #0xFF
        cmp     x1, #2
        b.ne    pause_not_fkey
        mov     x2, #0xFFFFFF
        and     x0, x0, x2
        cmp     x0, #16
        b.eq    pause_over
        cmp     x0, #17
        b.eq    pause_into
        cmp     x0, #18
        b.eq    pause_out
        b       pause_key
pause_not_fkey
        cmp     x1, #1
        b.ne    pause_plain
        mov     x2, #0x1FFFFF
        and     x0, x0, x2
pause_plain
        adrp    x1, debug_skip_nl
        add     x1, x1, debug_skip_nl
        ldr     x2, [x1]
        cbz     x2, pause_take
        cmp     w0, #10
        b.eq    pause_key
        cmp     w0, #13
        b.eq    pause_key
        str     xzr, [x1]
pause_take
        cmp     w0, #'h'
        b.eq    pause_help
        cmp     w0, #'H'
        b.eq    pause_help
        cmp     w0, #134
        b.eq    pause_go
        cmp     w0, #'g'
        b.eq    pause_go
        cmp     w0, #'G'
        b.eq    pause_go
        cmp     w0, #27
        b.eq    pause_key_abort
        cmp     w0, #'q'
        b.eq    pause_key_abort
        cmp     w0, #'Q'
        b.eq    pause_key_abort
        cmp     w0, #32
        b.eq    pause_over
        cmp     w0, #13
        b.eq    pause_over
        cmp     w0, #'o'
        b.eq    pause_over
        cmp     w0, #'O'
        b.eq    pause_over
        cmp     w0, #'i'
        b.eq    pause_into
        cmp     w0, #'I'
        b.eq    pause_into
        cmp     w0, #'u'
        b.eq    pause_out
        cmp     w0, #'U'
        b.eq    pause_out
        cmp     w0, #3
        b.eq    pause_wheel_raw
        cmp     w0, #7
        b.eq    pause_wheel_raw
        cbz     w0, pause_wheel_raw
        b       pause_key
pause_help
        adrp    x1, debug_help_shown
        add     x1, x1, debug_help_shown
        ldr     x0, [x1]
        cbnz    x0, pause_key
        bl      _debug_cursor_off
        adrp    x0, str_dbg_keys
        add     x0, x0, str_dbg_keys
        bl      _emit_z
        mov     x1, #1
        adrp    x0, debug_help_shown
        add     x0, x0, debug_help_shown
        str     x1, [x0]
        bl      _debug_cursor_on
        b       pause_key
pause_wheel_key
        adrp    x0, debug_key_raw
        add     x0, x0, debug_key_raw
        ldr     x0, [x0]
pause_wheel_raw
        bl      _debug_wheel
        b       pause_key
pause_over
        bl      _debug_cursor_off
        mov     x1, #1
        adrp    x0, debug_need_stacks
        add     x0, x0, debug_need_stacks
        str     x1, [x0]
        adrp    x1, debug_out
        add     x1, x1, debug_out
        str     xzr, [x1]
        adrp    x1, debug_over
        add     x1, x1, debug_over
        str     xzr, [x1]
        adrp    x0, debug_xt
        add     x0, x0, debug_xt
        ldr     x0, [x0]
        cbz     x0, pause_leave
        ldr     x0, [x0]
        adrp    x2, DOCOL
        add     x2, x2, DOCOL
        cmp     x0, x2
        b.ne    pause_leave
        str     x23, [x1]
        b       pause_leave
pause_into
        bl      _debug_cursor_off
        mov     x1, #1
        adrp    x0, debug_need_stacks
        add     x0, x0, debug_need_stacks
        str     x1, [x0]
        adrp    x1, debug_out
        add     x1, x1, debug_out
        str     xzr, [x1]
        adrp    x1, debug_over
        add     x1, x1, debug_over
        str     xzr, [x1]
        b       pause_leave
pause_out
        bl      _debug_cursor_off
        mov     x1, #1
        adrp    x0, debug_need_stacks
        add     x0, x0, debug_need_stacks
        str     x1, [x0]
        adrp    x1, debug_over
        add     x1, x1, debug_over
        str     xzr, [x1]
        adrp    x1, debug_out
        add     x1, x1, debug_out
        str     x23, [x1]
        b       pause_leave
pause_key_abort
        bl      _debug_cursor_off
        bl      _debug_clear_step
        adrp    x0, str_dbg_abort
        add     x0, x0, str_dbg_abort
        bl      _emit_z
        bl      _debug_disarm
        bl      host_debug_paint
        b       pause_leave
pause_go
        bl      _debug_cursor_off
        bl      _debug_clear_step
        adrp    x1, debug_bp_go
        add     x1, x1, debug_bp_go
        ldr     x0, [x1]
        cbnz    x0, pause_leave
        adrp    x1, debug_runto_ip
        add     x1, x1, debug_runto_ip
        ldr     x0, [x1]
        cbnz    x0, pause_leave
        mov     x28, #0
        adrp    x1, debug_armed
        add     x1, x1, debug_armed
        str     xzr, [x1]
        adrp    x1, debug_bp_go
        add     x1, x1, debug_bp_go
        str     xzr, [x1]
        adrp    x1, debug_runto_ip
        add     x1, x1, debug_runto_ip
        str     xzr, [x1]
        bl      host_debug_paint
pause_leave
        adrp    x0, debug_armed
        add     x0, x0, debug_armed
        ldr     x28, [x0]
        ldp     x19, x20, [sp, #16]
        ldp     x21, x22, [sp, #32]
        ldp     x23, x24, [sp, #48]
        ldp     x29, x30, [sp], #64
        ret

_debug_disarm
        mov     x2, #-1
        adrp    x1, debug_abort
        add     x1, x1, debug_abort
        str     x2, [x1]
        mov     x28, #0
        adrp    x1, debug_armed
        add     x1, x1, debug_armed
        str     xzr, [x1]
        adrp    x1, debug_bp_go
        add     x1, x1, debug_bp_go
        str     xzr, [x1]
        adrp    x1, debug_runto_ip
        add     x1, x1, debug_runto_ip
        str     xzr, [x1]
        adrp    x1, debug_runto_off
        add     x1, x1, debug_runto_off
        str     xzr, [x1]
        adrp    x1, debug_runto_status
        add     x1, x1, debug_runto_status
        str     xzr, [x1]
        adrp    x1, debug_over
        add     x1, x1, debug_over
        str     xzr, [x1]
        adrp    x1, debug_out
        add     x1, x1, debug_out
        str     xzr, [x1]
        adrp    x1, debug_break_asap
        add     x1, x1, debug_break_asap
        str     xzr, [x1]
        ret

_debug_clear_step
        stp     x29, x30, [sp, #-16]!
        adrp    x0, debug_need_stacks
        add     x0, x0, debug_need_stacks
        str     xzr, [x0]
        adrp    x0, debug_need_intro
        add     x0, x0, debug_need_intro
        str     xzr, [x0]
        bl      _debug_end_line
        adrp    x0, debug_help_shown
        add     x0, x0, debug_help_shown
        str     xzr, [x0]
        adrp    x1, debug_midline
        add     x1, x1, debug_midline
        str     xzr, [x1]
        adrp    x1, debug_over
        add     x1, x1, debug_over
        str     xzr, [x1]
        adrp    x1, debug_out
        add     x1, x1, debug_out
        str     xzr, [x1]
        ldp     x29, x30, [sp], #16
        ret

_debug_end_line
        stp     x29, x30, [sp, #-16]!
        adrp    x1, debug_midline
        add     x1, x1, debug_midline
        ldr     x0, [x1]
        cbz     x0, end_line_done
        str     xzr, [x1]
        mov     x0, #10
        bl      _putchar
end_line_done
        ldp     x29, x30, [sp], #16
        ret

_emit_z
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        mov     x19, x0
emit_z_loop
        ldrb    w0, [x19], #1
        cbz     w0, emit_z_done
        bl      _putchar
        b       emit_z_loop
emit_z_done
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_debug_call_xt
        cbz     x0, call_xt_ret
        adrp    x2, debug_call_depth
        add     x2, x2, debug_call_depth
        ldr     x3, [x2]
        cmp     x3, #DEBUG_CALL_MAX
        b.hs    call_xt_ret
        adrp    x1, debug_vmsave_stack
        add     x1, x1, debug_vmsave_stack
        mov     x4, #DEBUG_VMSAVE_SIZE
        mul     x4, x3, x4
        add     x1, x1, x4
        add     x3, x3, #1
        str     x3, [x2]
        stp     x19, x20, [x1]
        stp     x21, x22, [x1, #16]
        stp     x23, x24, [x1, #32]
        stp     x29, x30, [x1, #48]
        str     x28, [x1, #64]
        sub     x4, x3, #1
        mov     x5, #4096
        adrp    x23, debug_nest_rstack
        add     x23, x23, debug_nest_rstack
        mul     x4, x4, x5
        add     x23, x23, x4
        add     x23, x23, x5
        mov     x28, #0
        adrp    x19, debug_ret_ipcell
        add     x19, x19, debug_ret_ipcell
        mov     x21, x0
        ldr     x1, [x21]
        br      x1
call_xt_ret
        ret

        ALIGN 4
XDBG_CALL_DONE
        adrp    x1, debug_call_tos
        add     x1, x1, debug_call_tos
        str     x20, [x1]
        adrp    x2, debug_call_depth
        add     x2, x2, debug_call_depth
        ldr     x3, [x2]
        cbz     x3, call_done_ret
        sub     x3, x3, #1
        str     x3, [x2]
        adrp    x1, debug_vmsave_stack
        add     x1, x1, debug_vmsave_stack
        mov     x4, #DEBUG_VMSAVE_SIZE
        mul     x4, x3, x4
        add     x1, x1, x4
        ldp     x19, x20, [x1]
        ldp     x21, x22, [x1, #16]
        ldp     x23, x24, [x1, #32]
        ldp     x29, x30, [x1, #48]
        ldr     x28, [x1, #64]
call_done_ret
        ret

_debug_ds_isolate
        stp     x29, x30, [sp, #-16]!
        stp     x19, x21, [sp, #-16]!
        adrp    x19, data_stack
        add     x19, x19, data_stack
        add     x19, x19, #1, lsl #12
        adrp    x0, debug_dsave_tos
        add     x0, x0, debug_dsave_tos
        str     x20, [x0]
        adrp    x0, debug_dsave_dsp
        add     x0, x0, debug_dsave_dsp
        str     x22, [x0]
        mov     x1, #0
        cmp     x22, x19
        b.hs    ds_iso_store
        sub     x1, x19, x22
        lsr     x1, x1, #3
        cmp     x1, #DBG_DSAVE_MAX
        b.ls    ds_iso_copy
        mov     x1, #DBG_DSAVE_MAX
ds_iso_copy
        adrp    x0, debug_dsave_buf
        add     x0, x0, debug_dsave_buf
        mov     x2, #0
ds_iso_loop
        cmp     x2, x1
        b.hs    ds_iso_store
        ldr     x3, [x22, x2, lsl #3]
        str     x3, [x0, x2, lsl #3]
        add     x2, x2, #1
        b       ds_iso_loop
ds_iso_store
        adrp    x0, debug_dsave_n
        add     x0, x0, debug_dsave_n
        str     x1, [x0]
        mov     x22, x19
        mov     x20, #0
        ldp     x19, x21, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_debug_ds_restore
        stp     x29, x30, [sp, #-16]!
        stp     x19, x21, [sp, #-16]!
        adrp    x0, debug_dsave_n
        add     x0, x0, debug_dsave_n
        ldr     x1, [x0]
        adrp    x0, debug_dsave_dsp
        add     x0, x0, debug_dsave_dsp
        ldr     x22, [x0]
        adrp    x0, debug_dsave_tos
        add     x0, x0, debug_dsave_tos
        ldr     x20, [x0]
        cbz     x1, ds_res_done
        adrp    x0, debug_dsave_buf
        add     x0, x0, debug_dsave_buf
        mov     x2, #0
ds_res_loop
        cmp     x2, x1
        b.hs    ds_res_done
        ldr     x3, [x0, x2, lsl #3]
        str     x3, [x22, x2, lsl #3]
        add     x2, x2, #1
        b       ds_res_loop
ds_res_done
        ldp     x19, x21, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_debug_sync_view
        stp     x29, x30, [sp, #-16]!
        adrp    x0, debug_cfa
        add     x0, x0, debug_cfa
        ldr     x0, [x0]
        cbnz    x0, sync_have
        mov     x0, x19
        adrp    x1, debug_xt
        add     x1, x1, debug_xt
        ldr     x1, [x1]
        bl      _debug_resolve_enclosing
sync_have
        cbz     x0, sync_done
        adrp    x1, debug_view_cfa
        add     x1, x1, debug_view_cfa
        ldr     x2, [x1]
        cmp     x0, x2
        b.eq    sync_done
        stp     x0, x1, [sp, #-16]!
        adrp    x24, debug_view_name
        add     x24, x24, debug_view_name
        strb    wzr, [x24]
        tst     x0, #7
        b.ne    sync_drop
        ldr     x1, [x0, #-8]
        and     x1, x1, #0xFFFF
        cbz     x1, sync_drop
        lsr     x4, x1, #12
        cbnz    x4, sync_drop
        sub     x0, x0, x1
        ldrb    w1, [x0], #1
        and     w1, w1, #NFA_LEN_MASK
        cbz     w1, sync_drop
        cmp     w1, #31
        b.ls    sync_len_ok
        mov     w1, #31
sync_len_ok
        strb    w1, [x24], #1
        mov     x2, #0
sync_copy
        cmp     x2, x1
        b.hs    sync_copied
        ldrb    w3, [x0, x2]
        strb    w3, [x24, x2]
        add     x2, x2, #1
        b       sync_copy
sync_copied
        adrp    x0, debug_show_xt
        add     x0, x0, debug_show_xt
        ldr     x0, [x0]
        cbz     x0, sync_drop
        adrp    x1, debug_view_name
        add     x1, x1, debug_view_name
        ldrb    w2, [x1], #1
        cbz     w2, sync_drop
        adrp    x3, debug_sync_ok
        add     x3, x3, debug_sync_ok
        str     xzr, [x3]
        stp     x1, x2, [sp, #-16]!
        bl      _debug_ds_isolate
        ldp     x1, x2, [sp], #16
        str     x20, [x22, #-8]!
        mov     x20, x1
        str     x20, [x22, #-8]!
        mov     x20, x2
        adrp    x0, debug_show_xt
        add     x0, x0, debug_show_xt
        ldr     x0, [x0]
        bl      _debug_call_xt
        bl      _debug_ds_restore
        adrp    x3, debug_sync_ok
        add     x3, x3, debug_sync_ok
        ldr     x0, [x3]
        str     xzr, [x3]
        cbz     x0, sync_drop
        ldp     x0, x1, [sp], #16
        str     x0, [x1]
        b       sync_done
sync_drop
        add     sp, sp, #16
sync_done
        ldp     x29, x30, [sp], #16
        ret

_debug_wheel
        stp     x29, x30, [sp, #-16]!
        adrp    x1, debug_wheel_xt
        add     x1, x1, debug_wheel_xt
        ldr     x1, [x1]
        cbz     x1, wheel_done
        stp     x0, x1, [sp, #-16]!
        bl      _debug_ds_isolate
        ldp     x0, x1, [sp], #16
        str     x20, [x22, #-8]!
        mov     x20, x0
        mov     x0, x1
        bl      _debug_call_xt
        bl      _debug_ds_restore
        bl      host_debug_paint
wheel_done
        ldp     x29, x30, [sp], #16
        ret

_debug_highlight
        stp     x29, x30, [sp, #-16]!
        adrp    x0, debug_ip
        add     x0, x0, debug_ip
        ldr     x0, [x0]
        adrp    x1, tw_continue_cell
        add     x1, x1, tw_continue_cell
        cmp     x0, x1
        b.eq    hl_done
        adrp    x0, debug_hl_xt
        add     x0, x0, debug_hl_xt
        ldr     x0, [x0]
        cbz     x0, hl_done
        adrp    x1, debug_name
        add     x1, x1, debug_name
        ldrb    w2, [x1], #1
        cbz     w2, hl_done
        stp     x1, x2, [sp, #-16]!
        bl      _debug_ds_isolate
        ldp     x1, x2, [sp], #16
        str     x20, [x22, #-8]!
        mov     x20, x1
        str     x20, [x22, #-8]!
        mov     x20, x2
        adrp    x0, debug_hl_xt
        add     x0, x0, debug_hl_xt
        ldr     x0, [x0]
        bl      _debug_call_xt
        bl      _debug_ds_restore
hl_done
        ldp     x29, x30, [sp], #16
        ret

_debug_capture
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        adrp    x19, data_stack
        add     x19, x19, data_stack
        add     x19, x19, #1, lsl #12
        adrp    x9, debug_scnt
        add     x9, x9, debug_scnt
        cmp     x22, x19
        b.hs    cap_s_empty
        sub     x21, x19, x22
        lsr     x21, x21, #3
        cmp     x21, #16
        b.ls    cap_s_n
        mov     x21, #16
cap_s_n
        str     x21, [x9]
        adrp    x24, debug_sbuf
        add     x24, x24, debug_sbuf
        cbz     x21, cap_r
        sub     x1, x21, #1
        str     x20, [x24, x1, lsl #3]
        cbz     x1, cap_r
        mov     x0, #0
cap_s_loop
        cmp     x0, x1
        b.hs    cap_r
        sub     x2, x1, x0
        sub     x2, x2, #1
        ldr     x3, [x22, x2, lsl #3]
        str     x3, [x24, x0, lsl #3]
        add     x0, x0, #1
        b       cap_s_loop
cap_s_empty
        str     xzr, [x9]
cap_r
        adrp    x19, return_stack
        add     x19, x19, return_stack
        add     x19, x19, #1, lsl #12
        adrp    x10, debug_floor
        add     x10, x10, debug_floor
        ldr     x10, [x10]
        cbz     x10, cap_r_clip
        cmp     x10, x19
        b.hi    cap_r_clip
        cmp     x10, x23
        b.ls    cap_r_clip
        mov     x19, x10
cap_r_clip
        adrp    x24, debug_rbuf
        add     x24, x24, debug_rbuf
        adrp    x10, throw_handler
        add     x10, x10, throw_handler
        ldr     x10, [x10]
        cmp     x23, x19
        b.hs    cap_r_empty
        sub     x21, x19, x23
        lsr     x21, x21, #3
        mov     x0, #0
        mov     x1, #0
cap_r_loop
        cmp     x0, x21
        b.hs    cap_r_store
        add     x2, x23, x0, lsl #3
        cmp     x2, x10
        b.ne    cap_r_keep
        add     x0, x0, #6
        b       cap_r_loop
cap_r_keep
        cmp     x1, #16
        b.hs    cap_r_store
        ldr     x2, [x23, x0, lsl #3]
        str     x2, [x24, x1, lsl #3]
        add     x1, x1, #1
        add     x0, x0, #1
        b       cap_r_loop
cap_r_empty
        mov     x1, #0
cap_r_store
        adrp    x9, debug_rcnt
        add     x9, x9, debug_rcnt
        str     x1, [x9]
        adrp    x0, debug_xt
        add     x0, x0, debug_xt
        ldr     x0, [x0]
        adrp    x19, debug_name
        add     x19, x19, debug_name
        strb    wzr, [x19]
        cbz     x0, cap_done
        adrp    x1, tw_continue_cfa
        add     x1, x1, tw_continue_cfa
        cmp     x0, x1
        b.eq    cap_done
        tst     x0, #7
        b.ne    cap_done
        ldr     x1, [x0, #-8]
        and     x1, x1, #0xFFFF
        cbz     x1, cap_done
        lsr     x4, x1, #12
        cbnz    x4, cap_done
        sub     x0, x0, x1
        ldrb    w1, [x0], #1
        and     w1, w1, #NFA_LEN_MASK
        cbz     w1, cap_done
        cmp     w1, #31
        b.ls    cap_name_ok
        mov     w1, #31
cap_name_ok
        strb    w1, [x19], #1
        mov     x2, #0
cap_name_loop
        cmp     x2, x1
        b.hs    cap_done
        ldrb    w3, [x0, x2]
        strb    w3, [x19, x2]
        add     x2, x2, #1
        b       cap_name_loop
cap_done
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_debug_resolve_enclosing
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        mov     x19, x0
        mov     x20, x1
        adrp    x0, catch_ok_cell
        add     x0, x0, catch_ok_cell
        cmp     x19, x0
        b.eq    res_catch
        adrp    x0, tw_continue_cell
        add     x0, x0, tw_continue_cell
        cmp     x19, x0
        b.ne    res_scan
        ldr     x0, [x23, #8]
        cbz     x0, res_none
        tst     x0, #7
        b.ne    res_none
        ldr     x1, [x0]
        adrp    x2, DOCOL
        add     x2, x2, DOCOL
        cmp     x1, x2
        b.ne    res_none
        mov     x1, #0
        b       res_out
res_catch
        mov     x0, x20
        cbz     x0, res_none
        tst     x0, #7
        b.ne    res_none
        ldr     x1, [x0]
        adrp    x2, DOCOL
        add     x2, x2, DOCOL
        cmp     x1, x2
        b.ne    res_none
        mov     x1, #0
        b       res_out
res_scan
        mov     x0, x19
        bl      _ip_find_colon
        cbnz    x0, res_out
        mov     x0, x20
        cbz     x0, res_none
        tst     x0, #7
        b.ne    res_none
        ldr     x1, [x0]
        adrp    x2, DOCOL
        add     x2, x2, DOCOL
        cmp     x1, x2
        b.ne    res_none
        mov     x1, #0
        b       res_out
res_none
        mov     x0, #0
        mov     x1, #0
res_out
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_ip_find_colon
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!
        mov     x20, x0
        mov     x21, #0
        mov     x22, #0
        adrp    x19, wordlist_reg_n
        add     x19, x19, wordlist_reg_n
        ldr     x19, [x19]
        adrp    x23, wordlist_reg
        add     x23, x23, wordlist_reg
        mov     x24, #0
ip_wid_loop
        cmp     x24, x19
        b.hs    ip_wid_done
        ldr     x0, [x23, x24, lsl #3]
        bl      _ip_scan_wid
        add     x24, x24, #1
        b       ip_wid_loop
ip_wid_done
        ; FORTH-WORDLIST is latest_var and is not in WORDLISTS.
        ; (VIEW-OPEN) stays in FORTH, so step-into must see those threads.
        ; Closest body still wins over an earlier SYSVOC neighbor.
        adrp    x0, latest_var
        add     x0, x0, latest_var
        bl      _ip_scan_wid
        mov     x0, x21
        cbz     x21, ip_no_off
        sub     x1, x20, x22
        b       ip_find_out
ip_no_off
        mov     x1, #0
ip_find_out
        ldp     x23, x24, [sp], #16
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_ip_scan_wid
        cbz     x0, scan_ret
        mov     x9, #0
scan_thread
        cmp     x9, #DICT_THREADS
        b.hs    scan_ret
        ldr     x10, [x0, x9, lsl #3]
scan_link
        cbz     x10, scan_next_thread
        tst     x10, #7
        b.ne    scan_next_thread
        ldr     x11, [x10]
        adrp    x12, DOCOL
        add     x12, x12, DOCOL
        cmp     x11, x12
        b.ne    scan_lfa
        add     x11, x10, #8
        cmp     x11, x20
        b.hi    scan_lfa
        sub     x12, x20, x11
        lsr     x13, x12, #20
        cbnz    x13, scan_lfa
        cbz     x21, scan_take
        cmp     x11, x22
        b.ls    scan_lfa
scan_take
        mov     x22, x11
        mov     x21, x10
scan_lfa
        ldr     x10, [x10, #-16]
        b       scan_link
scan_next_thread
        add     x9, x9, #1
        b       scan_thread
scan_ret
        ret

_debug_print_inline_suffix
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        adrp    x0, debug_xt
        add     x0, x0, debug_xt
        ldr     x19, [x0]
        cbz     x19, inl_done
        adrp    x0, debug_inline
        add     x0, x0, debug_inline
        ldr     x20, [x0]
        adrp    x1, cfa_lit
        add     x1, x1, cfa_lit
        ldr     x1, [x1]
        cmp     x19, x1
        b.ne    inl_branch
        mov     x0, #32
        bl      _putchar
        mov     x0, x20
        cbz     x0, inl_number
        tst     x0, #7
        b.ne    inl_number
        adrp    x1, user_dict_area
        add     x1, x1, user_dict_area
        cmp     x0, x1
        b.lo    inl_number
        adrp    x1, here_ptr
        add     x1, x1, here_ptr
        ldr     x1, [x1]
        cmp     x0, x1
        b.hs    inl_number
        ldr     x1, [x0, #-8]
        and     x1, x1, #0xFFFF
        cbz     x1, inl_number
        lsr     x4, x1, #12
        cbnz    x4, inl_number
        sub     x2, x0, x1
        cbz     x2, inl_number
        adrp    x3, user_dict_area
        add     x3, x3, user_dict_area
        cmp     x2, x3
        b.lo    inl_number
        ldrb    w2, [x2]
        and     w2, w2, #NFA_LEN_MASK
        cbz     w2, inl_number
        cmp     w2, #64
        b.hs    inl_number
        bl      _print_xt_name
        b       inl_done
inl_number
        mov     x0, x20
        bl      _print_signed
        b       inl_done
inl_branch
        adrp    x1, cfa_branch
        add     x1, x1, cfa_branch
        ldr     x1, [x1]
        cmp     x19, x1
        b.eq    inl_cells
        adrp    x1, cfa_0branch
        add     x1, x1, cfa_0branch
        ldr     x1, [x1]
        cmp     x19, x1
        b.eq    inl_cells
        adrp    x1, cfa_loop
        add     x1, x1, cfa_loop
        ldr     x1, [x1]
        cmp     x19, x1
        b.eq    inl_cells
        adrp    x1, cfa_plusloop
        add     x1, x1, cfa_plusloop
        ldr     x1, [x1]
        cmp     x19, x1
        b.ne    inl_done
inl_cells
        mov     x0, #32
        bl      _putchar
        asr     x20, x20, #3
        tbnz    x20, #63, inl_neg
        mov     x0, #'+'
        bl      _putchar
        mov     x0, x20
        bl      _print_unsigned
        b       inl_cells_word
inl_neg
        mov     x0, x20
        bl      _print_signed
inl_cells_word
        mov     x0, #32
        bl      _putchar
        mov     x0, #'C'
        bl      _putchar
        mov     x0, #'E'
        bl      _putchar
        mov     x0, #'L'
        bl      _putchar
        mov     x0, #'L'
        bl      _putchar
        mov     x0, #'S'
        bl      _putchar
inl_done
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_debug_xt_intoable
        cbz     x0, into_no
        tst     x0, #7
        b.ne    into_no
        ldr     x1, [x0]
        adrp    x0, DOCOL
        add     x0, x0, DOCOL
        cmp     x1, x0
        b.eq    into_yes
        adrp    x0, DODOES
        add     x0, x0, DODOES
        cmp     x1, x0
        b.eq    into_yes
        adrp    x0, XEXECUTE
        add     x0, x0, XEXECUTE
        cmp     x1, x0
        b.eq    into_yes
        adrp    x0, XCATCH
        add     x0, x0, XCATCH
        cmp     x1, x0
        b.eq    into_yes
into_no
        mov     x0, #0
        ret
into_yes
        mov     x0, #1
        ret

_print_xt_name
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        cbz     x0, pxn_q
        adrp    x1, tw_continue_cfa
        add     x1, x1, tw_continue_cfa
        cmp     x0, x1
        b.ne    pxn_check
        adrp    x0, str_traverse
        add     x0, x0, str_traverse
        bl      _emit_z
        b       pxn_done
pxn_check
        tst     x0, #7
        b.ne    pxn_q
        ldr     x1, [x0, #-8]
        and     x1, x1, #0xFFFF
        cbz     x1, pxn_q
        lsr     x4, x1, #12
        cbnz    x4, pxn_q
        sub     x19, x0, x1
        ldrb    w20, [x19], #1
        and     w20, w20, #NFA_LEN_MASK
        cbz     w20, pxn_q
        cmp     w20, #64
        b.hs    pxn_q
        mov     x1, #0
pxn_scan
        cmp     x1, x20
        b.hs    pxn_print
        ldrb    w0, [x19, x1]
        cmp     w0, #32
        b.lo    pxn_q
        cmp     w0, #126
        b.hi    pxn_q
        add     x1, x1, #1
        b       pxn_scan
pxn_print
        mov     x1, #0
pxn_out
        cmp     x1, x20
        b.hs    pxn_done
        ldrb    w0, [x19, x1]
        stp     x1, x20, [sp, #-16]!
        bl      _putchar
        ldp     x1, x20, [sp], #16
        add     x1, x1, #1
        b       pxn_out
pxn_done
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
pxn_q
        mov     x0, #63
        bl      _putchar
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_debug_note_byte
        adrp    x1, debug_armed
        add     x1, x1, debug_armed
        ldr     x1, [x1]
        cbz     x1, note_ret
        adrp    x2, debug_line_col
        add     x2, x2, debug_line_col
        adrp    x3, debug_midline
        add     x3, x3, debug_midline
        cmp     w0, #10
        b.ne    note_not_nl
        str     xzr, [x2]
        str     xzr, [x3]
        ret
note_not_nl
        cmp     w0, #8
        b.ne    note_glyph
        ldr     x1, [x2]
        cbz     x1, note_bs_flag
        sub     x1, x1, #1
        str     x1, [x2]
note_bs_flag
        ldr     x1, [x2]
        cmp     x1, #0
        b.eq    note_bs_zero
        mov     x1, #1
        b       note_bs_store
note_bs_zero
        mov     x1, #0
note_bs_store
        str     x1, [x3]
        ret
note_glyph
        and     w1, w0, #0xC0
        cmp     w1, #0x80
        b.eq    note_ret
        ldr     x1, [x2]
        add     x1, x1, #1
        str     x1, [x2]
        mov     x1, #1
        str     x1, [x3]
note_ret
        ret

_debug_pad_to_stack_col
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        adrp    x0, debug_line_col
        add     x0, x0, debug_line_col
        ldr     x19, [x0]
        cmp     x19, #DEBUG_STACK_COL
        b.eq    pad_done
        b.hi    pad_one
        mov     x0, #DEBUG_STACK_COL
        sub     x19, x0, x19
pad_loop
        cbz     x19, pad_done
        sub     x19, x19, #1
        mov     x0, #32
        bl      _putchar
        b       pad_loop
pad_one
        mov     x0, #32
        bl      _putchar
pad_done
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_debug_cursor_on
        stp     x29, x30, [sp, #-16]!
        adrp    x0, debug_line_col
        add     x0, x0, debug_line_col
        ldr     x1, [x0]
        adrp    x0, debug_stack_anchor
        add     x0, x0, debug_stack_anchor
        str     x1, [x0]
        mov     x0, #0xE2
        bl      _putchar
        mov     x0, #0x96
        bl      _putchar
        mov     x0, #0x88
        bl      _putchar
        mov     x1, #1
        adrp    x0, debug_cursor_on
        add     x0, x0, debug_cursor_on
        str     x1, [x0]
        ldp     x29, x30, [sp], #16
        ret

_debug_cursor_off
        stp     x29, x30, [sp, #-16]!
        adrp    x0, debug_cursor_on
        add     x0, x0, debug_cursor_on
        ldr     x1, [x0]
        cbz     x1, cursor_off_done
        str     xzr, [x0]
        mov     x0, #8
        bl      _putchar
        adrp    x0, debug_stack_anchor
        add     x0, x0, debug_stack_anchor
        ldr     x1, [x0]
        adrp    x0, debug_line_col
        add     x0, x0, debug_line_col
        str     x1, [x0]
cursor_off_done
        ldp     x29, x30, [sp], #16
        ret

_debug_print_SR
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        adrp    x0, debug_field_len
        add     x0, x0, debug_field_len
        str     xzr, [x0]
        mov     x1, #1
        adrp    x0, debug_field_count
        add     x0, x0, debug_field_count
        str     x1, [x0]
        mov     x0, #83
        bl      _putchar
        bl      _debug_print_dots
        adrp    x0, debug_field_len
        add     x0, x0, debug_field_len
        ldr     x19, [x0]
        cmp     x19, #45
        b.hs    sr_past
        mov     x0, #45
        sub     x19, x0, x19
sr_pad
        cbz     x19, sr_r
        sub     x19, x19, #1
        mov     x0, #32
        bl      _putchar
        b       sr_pad
sr_past
        b.eq    sr_r
        mov     x0, #32
        bl      _putchar
sr_r
        mov     x0, #82
        bl      _putchar
        bl      _debug_print_rstack
        adrp    x0, debug_field_count
        add     x0, x0, debug_field_count
        str     xzr, [x0]
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_debug_print_dots
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        adrp    x19, data_stack
        add     x19, x19, data_stack
        add     x19, x19, #1, lsl #12
        cmp     x22, x19
        b.hs    dpd_empty
        sub     x21, x19, x22
        lsr     x21, x21, #3
        mov     x0, #40
        bl      _putchar
        mov     x0, x21
        bl      _print_unsigned
        mov     x0, #41
        bl      _putchar
        mov     x0, #58
        bl      _putchar
        mov     x0, #32
        bl      _putchar
        cmp     x21, #6
        b.ls    dpd_under
        mov     x0, #'.'
        bl      _putchar
        mov     x0, #'.'
        bl      _putchar
        mov     x0, #'.'
        bl      _putchar
        mov     x0, #32
        bl      _putchar
dpd_under
        cmp     x21, #1
        b.eq    dpd_tos
        sub     x19, x21, #1
        cmp     x19, #5
        b.ls    dpd_mem
        mov     x19, #5
dpd_mem
        cbz     x19, dpd_tos
        sub     x19, x19, #1
        lsl     x0, x19, #3
        ldr     x0, [x22, x0]
        bl      _print_signed
        mov     x0, #32
        bl      _putchar
        b       dpd_mem
dpd_tos
        mov     x0, x20
        bl      _print_signed
        mov     x0, #32
        bl      _putchar
        b       dpd_done
dpd_empty
        mov     x0, #40
        bl      _putchar
        mov     x0, #48
        bl      _putchar
        mov     x0, #41
        bl      _putchar
        mov     x0, #58
        bl      _putchar
dpd_done
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_debug_print_rstack
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        sub     sp, sp, #32
        adrp    x19, return_stack
        add     x19, x19, return_stack
        add     x19, x19, #1, lsl #12
        adrp    x0, debug_floor
        add     x0, x0, debug_floor
        ldr     x0, [x0]
        cbz     x0, dpr_clip
        cmp     x0, x19
        b.hi    dpr_clip
        cmp     x0, x23
        b.ls    dpr_clip
        mov     x19, x0
dpr_clip
        cmp     x23, x19
        b.hs    dpr_empty
        sub     x21, x19, x23
        lsr     x21, x21, #3
        adrp    x22, throw_handler
        add     x22, x22, throw_handler
        ldr     x22, [x22]
        mov     x19, #0
        mov     x20, #0
dpr_count
        cmp     x20, x21
        b.hs    dpr_counted
        add     x0, x23, x20, lsl #3
        cmp     x0, x22
        b.ne    dpr_one
        add     x20, x20, #6
        b       dpr_count
dpr_one
        add     x19, x19, #1
        add     x20, x20, #1
        b       dpr_count
dpr_counted
        cbz     x19, dpr_empty
        mov     x0, #40
        bl      _putchar
        mov     x0, x19
        bl      _print_unsigned
        mov     x0, #41
        bl      _putchar
        mov     x0, #58
        bl      _putchar
        mov     x0, #32
        bl      _putchar
        mov     x20, #0
        mov     x19, #0
dpr_show
        cmp     x20, x21
        b.hs    dpr_done
        cmp     x19, #4
        b.hs    dpr_ellip
        add     x0, x23, x20, lsl #3
        cmp     x0, x22
        b.ne    dpr_show_one
        add     x20, x20, #6
        b       dpr_show
dpr_show_one
        ldr     x0, [x23, x20, lsl #3]
        bl      _print_unsigned
        mov     x0, #32
        bl      _putchar
        add     x20, x20, #1
        add     x19, x19, #1
        b       dpr_show
dpr_ellip
        mov     x0, #'.'
        bl      _putchar
        mov     x0, #'.'
        bl      _putchar
        mov     x0, #'.'
        bl      _putchar
        b       dpr_done
dpr_empty
        mov     x0, #40
        bl      _putchar
        mov     x0, #48
        bl      _putchar
        mov     x0, #41
        bl      _putchar
        mov     x0, #58
        bl      _putchar
dpr_done
        add     sp, sp, #32
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

_view_register_path
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        mov     x19, x0
        mov     x20, x1
        cmp     x20, #0
        b.le    vrp_fail
        cmp     x20, #255
        b.ls    vrp_len_ok
        mov     x20, #255
vrp_len_ok
        adrp    x21, view_file_n
        add     x21, x21, view_file_n
        ldr     x22, [x21]
        mov     x3, #1
vrp_search
        cmp     x3, x22
        b.hi    vrp_append
        sub     x4, x3, #1
        mov     x5, #VIEW_PATH_MAX
        mul     x4, x4, x5
        adrp    x5, view_paths
        add     x5, x5, view_paths
        add     x5, x5, x4
        ldrb    w6, [x5]
        cmp     x6, x20
        b.ne    vrp_next
        mov     x7, #0
vrp_cmp
        cmp     x7, x20
        b.hs    vrp_found
        add     x8, x5, #1
        ldrb    w9, [x8, x7]
        ldrb    w10, [x19, x7]
        cmp     w9, w10
        b.ne    vrp_next
        add     x7, x7, #1
        b       vrp_cmp
vrp_next
        add     x3, x3, #1
        b       vrp_search
vrp_append
        cmp     x22, #VIEW_FILE_MAX
        b.hs    vrp_fail
        add     x22, x22, #1
        str     x22, [x21]
        mov     x3, x22
        sub     x4, x3, #1
        mov     x5, #VIEW_PATH_MAX
        mul     x4, x4, x5
        adrp    x5, view_paths
        add     x5, x5, view_paths
        add     x5, x5, x4
        strb    w20, [x5]
        mov     x7, #0
vrp_store
        cmp     x7, x20
        b.hs    vrp_found
        ldrb    w9, [x19, x7]
        add     x8, x5, #1
        strb    w9, [x8, x7]
        add     x7, x7, #1
        b       vrp_store
vrp_found
        mov     x0, x3
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
vrp_fail
        mov     x0, #0
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

; x0 = 1-based line in the current SOURCE, or 0 when no file is registered
; or the source is the console. Leaf: clobbers x1-x4 only.
_view_line_now
        adrp    x0, view_src_id
        add     x0, x0, view_src_id
        ldr     x0, [x0]
        cbz     x0, _vln_none
        adrp    x0, source_id
        add     x0, x0, source_id
        ldr     x0, [x0]
        cbz     x0, _vln_none
        b       _source_line_now
_vln_none
        mov     x0, #0
        ret

; x0 = 1-based line. Counts LF from the file origin through >IN.
_source_line_now
        adrp    x1, source_base
        add     x1, x1, source_base
        ldr     x1, [x1]
        adrp    x2, to_in
        add     x2, x2, to_in
        ldr     x2, [x2]
        adrp    x4, line_mode
        add     x4, x4, line_mode
        ldr     x4, [x4]
        cbz     x4, _source_line_at
        adrp    x3, line_origin
        add     x3, x3, line_origin
        ldr     x3, [x3]
        add     x4, x1, x2
        sub     x2, x4, x3
        mov     x1, x3
_source_line_at
        mov     x0, #1
        mov     x3, #0
_sla_loop
        cmp     x3, x2
        b.hs    _sla_done
        ldrb    w4, [x1, x3]
        cmp     w4, #10
        b.ne    _sla_next
        add     x0, x0, #1
_sla_next
        add     x3, x3, #1
        b       _sla_loop
_sla_done
        ret

; Register include_name_pending and store its file id in view_src_id.
_view_set_src_from_pending
        stp     x29, x30, [sp, #-16]!
        adrp    x0, include_name_len
        add     x0, x0, include_name_len
        ldr     x1, [x0]
        cbz     x1, _vset_clear
        adrp    x0, include_name_pending
        add     x0, x0, include_name_pending
        bl      _view_register_path
        adrp    x1, view_src_id
        add     x1, x1, view_src_id
        str     x0, [x1]
        ldp     x29, x30, [sp], #16
        ret
_vset_clear
        adrp    x1, view_src_id
        add     x1, x1, view_src_id
        str     xzr, [x1]
        ldp     x29, x30, [sp], #16
        ret

; Nest the current file id. Eight levels, same depth as the source stack.
_view_push_src_id
        adrp    x0, view_src_id
        add     x0, x0, view_src_id
        ldr     x1, [x0]
        adrp    x2, view_id_sp
        add     x2, x2, view_id_sp
        ldr     x3, [x2]
        cmp     x3, #8
        b.hs    _vpush_full
        adrp    x4, view_id_stack
        add     x4, x4, view_id_stack
        str     x1, [x4, x3, lsl #3]
        add     x3, x3, #1
        str     x3, [x2]
_vpush_full
        ret

_view_pop_src_id
        adrp    x2, view_id_sp
        add     x2, x2, view_id_sp
        ldr     x3, [x2]
        cbz     x3, _vpop_empty
        sub     x3, x3, #1
        str     x3, [x2]
        adrp    x4, view_id_stack
        add     x4, x4, view_id_stack
        ldr     x1, [x4, x3, lsl #3]
        adrp    x0, view_src_id
        add     x0, x0, view_src_id
        str     x1, [x0]
        ret
_vpop_empty
        adrp    x0, view_src_id
        add     x0, x0, view_src_id
        str     xzr, [x0]
        ret

_getchar
        stp     x29, x30, [sp, #-16]!
        adrp    x1, key_fn
        add     x1, x1, key_fn
        ldr     x1, [x1]
        cbz     x1, getchar_none
        blr     x1
        b       getchar_out
getchar_none
        mov     x0, #-1
getchar_out
        ldp     x29, x30, [sp], #16
        ret

        AREA |.rdata|, DATA, READONLY, ALIGN=3
str_dbg_keys    DCB "[Space/o/Return=over i=into u=out Esc/q=abort g=go h=help]", 0
str_dbg_abort   DCB "DEBUG aborted", 10, 0
str_dbg_done    DCB "DEBUG done", 10, 0
str_traverse    DCB "(TRAVERSE)", 0

        AREA |.data|, DATA, READWRITE, ALIGN=8
debug_armed         DCQ 0
tdebug_armed        DCQ 0
debug_midline       DCQ 0
debug_field_count   DCQ 0
debug_field_len     DCQ 0
debug_help_shown    DCQ 0
debug_cursor_on     DCQ 0
debug_need_stacks   DCQ 0
debug_need_intro    DCQ 0
debug_line_col      DCQ 0
debug_stack_anchor  DCQ 0
debug_busy          DCQ 0
debug_floor         DCQ 0
debug_bp_go         DCQ 0
debug_runto_ip      DCQ 0
debug_runto_off     DCQ 0
debug_runto_status  DCQ 0
debug_break_asap    DCQ 0
debug_break_min_cfa DCQ 0
debug_bp_xts        SPACE 64
debug_bp_en         SPACE 64
debug_over          DCQ 0
debug_out           DCQ 0
debug_abort         DCQ 0
debug_show_xt       DCQ 0
debug_sync_ok       DCQ 0
debug_hl_xt         DCQ 0
debug_wheel_xt      DCQ 0
debug_pause_xt      DCQ 0
debug_pause_rsp     DCQ 0
debug_key_xt        DCQ 0
debug_key_raw       DCQ 0
debug_key_mode      DCQ 0
debug_call_tos      DCQ 0
debug_view_cfa      DCQ 0
debug_view_name     SPACE 32
debug_call_depth    DCQ 0
        ALIGN 8
debug_vmsave_stack  SPACE 288
debug_ret_cfa       DCQ XDBG_CALL_DONE
debug_ret_ipcell    DCQ debug_ret_cfa
debug_skip_nl       DCQ 0
debug_xt            DCQ 0
debug_inline        DCQ 0
debug_ip            DCQ 0
debug_cfa           DCQ 0
debug_body_cells    DCQ 0
debug_scnt          DCQ 0
debug_sbuf          SPACE 128
debug_rcnt          DCQ 0
debug_rbuf          SPACE 128
debug_name          SPACE 32
debug_rlab          SPACE 512
debug_dsave_tos     DCQ 0
debug_dsave_dsp     DCQ 0
debug_dsave_n       DCQ 0
debug_dsave_buf     SPACE 512
        ALIGN 8
debug_nest_rstack   SPACE 16384
view_src_id         DCQ 0
view_file_n         DCQ 0
view_paths          SPACE 65536
view_id_sp          DCQ 0
view_id_stack       SPACE 64
include_name_len    DCQ 0
include_name_pending SPACE 256

        END
