; kernel_init builds the dictionary from the BOOT_WORD pointer table,
; then interprets forth_init_str (kernel1.fth then kernel2.fth).
; kernel_eval interprets one buffer. Labels match the Mac kernel.
; Execute trampoline: IP points at restart_cell, whose code is XRESTART.

        INCLUDE Forth/kernel/arm64/vm.inc

        EXTERN next_debug
        EXTERN debug_break_asap

        AREA |.text|, CODE, READONLY, ALIGN=4

        EXTERN emit_hook
        EXTERN key_hook
        EXTERN facility_op_hook
        EXTERN kernel_inited
        EXTERN bye_flag
        EXTERN latest_var
        EXTERN last_cfa
        EXTERN here_ptr
        EXTERN state_var
        EXTERN vm_tos
        EXTERN vm_dsp
        EXTERN vm_rsp
        EXTERN debug_armed
        EXTERN source_cur
        EXTERN source_end
        EXTERN source_base
        EXTERN to_in
        EXTERN throw_handler
        EXTERN line_mode
        EXTERN line_origin
        EXTERN line_limit
        EXTERN line_next
        EXTERN source_id
        EXTERN view_src_id
        EXTERN view_id_sp
        EXTERN _view_pop_src_id
        EXTERN file_echo
        EXTERN file_echo_pos
        EXTERN file_echo_stack
        EXTERN blk_var
        EXTERN blk_stack
        EXTERN source_sp
        EXTERN source_stack
        EXTERN local_frame_depth
        EXTERN eval_resume_sp
        EXTERN eval_resume_stack
        EXTERN cfa_exit
        EXTERN cfa_lit
        EXTERN cfa_branch
        EXTERN cfa_0branch
        EXTERN cfa_does
        EXTERN cfa_slit
        EXTERN cfa_cstr
        EXTERN cfa_execute
        EXTERN cfa_comma
        EXTERN cfa_flit
        EXTERN cfa_local_init
        EXTERN cfa_local_at
        EXTERN cfa_local_store
        EXTERN cfa_loop
        EXTERN cfa_plusloop
        EXTERN _local_lookup
        EXTERN _local_compile_reset
        EXTERN noname_xt
        EXTERN restart_cell
        EXTERN data_stack
        EXTERN return_stack
        EXTERN user_dict_area
        EXTERN _header_build
        EXTERN _strlen
        EXTERN _find_word
        EXTERN _parse_number
        EXTERN host_float_op
        EXTERN XTHROW
        EXTERN _next_word
        EXTERN _compile_cell
        EXTERN _record_words_user_base_once
        EXTERN emit_str
        EXTERN emit_cstr
        EXTERN _putchar
        EXTERN _print_unsigned
        EXTERN forth_init_str
        EXTERN forth_init_end
        EXPORT kernel_init
        EXPORT _kernel_init
        EXPORT kernel_eval
        EXPORT _kernel_eval
        EXPORT kernel_set_emit
        EXPORT _kernel_set_emit
        EXPORT kernel_set_key
        EXPORT _kernel_set_key
        EXPORT kernel_set_facility_op
        EXPORT _kernel_set_facility_op
        EXPORT _kernel_cold_common
        EXPORT _boot_kernel
        EXPORT _boot_cache_cfa
        EXPORT _zcmp
        EXPORT _vm_save
        EXPORT _vm_load
        EXPORT _vm_reset_stacks
        EXPORT _interpret_loop
        EXPORT _try_find
        EXPORT _exec_found
        EXPORT _compile_entry
        EXPORT _compile_lit
        EXPORT _try_number_after_find
        EXPORT _interpret_empty
        EXPORT _embed_finish
        EXPORT _do_quit
        EXPORT _arm_lines
        EXPORT _take_line
        EXPORT _push_source
        EXPORT _pop_source
        EXPORT _eval_resume_push
        EXPORT _eval_resume_pop
        EXPORT _throw_unwind_to_sp
        EXPORT _quit_exit
        EXPORT _embed_bye_return
        EXPORT _embed_ret_x0

_kernel_set_emit
kernel_set_emit PROC
        adrp    x1, emit_hook
        add     x1, x1, emit_hook
        str     x0, [x1]
        ret
        ENDP

_kernel_set_key
kernel_set_key PROC
        adrp    x1, key_hook
        add     x1, x1, key_hook
        str     x0, [x1]
        ret
        ENDP

_kernel_set_facility_op
kernel_set_facility_op PROC
        adrp    x1, facility_op_hook
        add     x1, x1, facility_op_hook
        str     x0, [x1]
        ret
        ENDP

_kernel_init
kernel_init PROC
        sub     sp, sp, #128
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        stp     x21, x22, [sp, #64]
        stp     x23, x24, [sp, #80]
        stp     x25, x26, [sp, #96]
        stp     x27, x28, [sp, #112]
        adrp    x0, kernel_inited
        add     x0, x0, kernel_inited
        ldr     x1, [x0]
        cbnz    x1, _kinit_already
        bl      _kernel_cold_common
        bl      _vm_save
        mov     x1, #1
        adrp    x0, kernel_inited
        add     x0, x0, kernel_inited
        str     x1, [x0]
        adrp    x0, forth_init_str
        add     x0, x0, forth_init_str
        adrp    x1, forth_init_end
        add     x1, x1, forth_init_end
        sub     x1, x1, x0
        sub     x1, x1, #1
        adrp    x2, source_base
        add     x2, x2, source_base
        str     x0, [x2]
        adrp    x2, to_in
        add     x2, x2, to_in
        str     xzr, [x2]
        adrp    x2, source_cur
        add     x2, x2, source_cur
        str     x0, [x2]
        adrp    x2, source_end
        add     x2, x2, source_end
        add     x0, x0, x1
        str     x0, [x2]
        adrp    x2, throw_handler
        add     x2, x2, throw_handler
        str     xzr, [x2]
        adrp    x2, bye_flag
        add     x2, x2, bye_flag
        str     xzr, [x2]
        b       _interpret_loop
_kinit_already
        mov     x0, #0
        b       _embed_ret_x0
        ENDP

; Stacks, empty hash threads, HERE, then the boot catalog.
; Leaves x20, x22, x23, and x24 ready for the interpreter.
_kernel_cold_common PROC
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        adrp    x22, data_stack
        add     x22, x22, data_stack
        add     x22, x22, #1, lsl #12
        adrp    x23, return_stack
        add     x23, x23, return_stack
        add     x23, x23, #1, lsl #12
        adrp    x24, latest_var
        add     x24, x24, latest_var
        mov     x20, #0
        mov     x28, #0
        mov     x0, x24
        mov     x1, #16
_cold_clear
        str     xzr, [x0], #8
        subs    x1, x1, #1
        b.ne    _cold_clear
        adrp    x0, last_cfa
        add     x0, x0, last_cfa
        str     xzr, [x0]
        adrp    x0, here_ptr
        add     x0, x0, here_ptr
        adrp    x1, user_dict_area
        add     x1, x1, user_dict_area
        str     x1, [x0]
        adrp    x0, state_var
        add     x0, x0, state_var
        str     xzr, [x0]
        adrp    x0, bye_flag
        add     x0, x0, bye_flag
        str     xzr, [x0]
        bl      _boot_kernel
        adrp    x24, latest_var
        add     x24, x24, latest_var
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        ret
        ENDP

; Walk |.bootptr| from bootptr_start to bootptr_end.
; Each cell is a pointer to {name, help, flags, code, end}.
_boot_kernel PROC
        sub     sp, sp, #112
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        stp     x21, x22, [sp, #64]
        stp     x23, x24, [sp, #80]
        str     x25, [sp, #96]
        adrp    x19, bootptr_start
        add     x19, x19, bootptr_start
        adrp    x25, bootptr_end
        add     x25, x25, bootptr_end
_bk_loop
        cmp     x19, x25
        b.hs    _bk_done
        ldr     x7, [x19], #8
        cbz     x7, _bk_loop
        ldr     x20, [x7]
        cbz     x20, _bk_loop
        ldr     x21, [x7, #8]
        ldr     x22, [x7, #16]
        ldr     x23, [x7, #24]
        mov     x0, x20
        bl      _strlen
        str     x0, [sp, #104]
        mov     x0, x21
        bl      _strlen
        mov     x3, x0
        ldr     x1, [sp, #104]
        mov     x0, x20
        mov     x2, x21
        mov     x4, x23
        mov     x5, x22
        bl      _header_build
        mov     x21, x0
        mov     x0, x20
        bl      _boot_cache_cfa
        b       _bk_loop
_bk_done
        ldr     x25, [sp, #96]
        ldp     x23, x24, [sp, #80]
        ldp     x21, x22, [sp, #64]
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #112
        ret
        ENDP

        EXTERN bootptr_start
        EXTERN bootptr_end

; x0 = name, x21 = CFA. Caches the xts the compiler plants.
_boot_cache_cfa PROC
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        mov     x19, x0
        mov     x20, x21
        adrp    x1, boot_cmp_lit
        add     x1, x1, boot_cmp_lit
        adrp    x2, cfa_lit
        add     x2, x2, cfa_lit
        bl      _bcc_match
        adrp    x1, boot_cmp_exit
        add     x1, x1, boot_cmp_exit
        adrp    x2, cfa_exit
        add     x2, x2, cfa_exit
        bl      _bcc_match
        adrp    x1, boot_cmp_branch
        add     x1, x1, boot_cmp_branch
        adrp    x2, cfa_branch
        add     x2, x2, cfa_branch
        bl      _bcc_match
        adrp    x1, boot_cmp_0branch
        add     x1, x1, boot_cmp_0branch
        adrp    x2, cfa_0branch
        add     x2, x2, cfa_0branch
        bl      _bcc_match
        adrp    x1, boot_cmp_does
        add     x1, x1, boot_cmp_does
        adrp    x2, cfa_does
        add     x2, x2, cfa_does
        bl      _bcc_match
        adrp    x1, boot_cmp_slit
        add     x1, x1, boot_cmp_slit
        adrp    x2, cfa_slit
        add     x2, x2, cfa_slit
        bl      _bcc_match
        adrp    x1, boot_cmp_cstr
        add     x1, x1, boot_cmp_cstr
        adrp    x2, cfa_cstr
        add     x2, x2, cfa_cstr
        bl      _bcc_match
        adrp    x1, boot_cmp_execute
        add     x1, x1, boot_cmp_execute
        adrp    x2, cfa_execute
        add     x2, x2, cfa_execute
        bl      _bcc_match
        adrp    x1, boot_cmp_comma
        add     x1, x1, boot_cmp_comma
        adrp    x2, cfa_comma
        add     x2, x2, cfa_comma
        bl      _bcc_match
        adrp    x1, boot_cmp_flit
        add     x1, x1, boot_cmp_flit
        adrp    x2, cfa_flit
        add     x2, x2, cfa_flit
        bl      _bcc_match
        adrp    x1, boot_cmp_linit
        add     x1, x1, boot_cmp_linit
        adrp    x2, cfa_local_init
        add     x2, x2, cfa_local_init
        bl      _bcc_match
        adrp    x1, boot_cmp_lat
        add     x1, x1, boot_cmp_lat
        adrp    x2, cfa_local_at
        add     x2, x2, cfa_local_at
        bl      _bcc_match
        adrp    x1, boot_cmp_lstore
        add     x1, x1, boot_cmp_lstore
        adrp    x2, cfa_local_store
        add     x2, x2, cfa_local_store
        bl      _bcc_match
        adrp    x1, boot_cmp_loop
        add     x1, x1, boot_cmp_loop
        adrp    x2, cfa_loop
        add     x2, x2, cfa_loop
        bl      _bcc_match
        adrp    x1, boot_cmp_ploop
        add     x1, x1, boot_cmp_ploop
        adrp    x2, cfa_plusloop
        add     x2, x2, cfa_plusloop
        bl      _bcc_match
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        ret
        ENDP

; x19 = name, x1 = expected, x2 = cache cell. Preserves x19 and x20.
_bcc_match
        stp     x29, x30, [sp, #-16]!
        stp     x2, x19, [sp, #-16]!
        mov     x0, x19
        bl      _zcmp
        ldp     x2, x19, [sp], #16
        cbnz    x0, _bcc_match_no
        str     x20, [x2]
_bcc_match_no
        ldp     x29, x30, [sp], #16
        ret

; x0 and x1 are C strings. x0 = 0 when they match.
_zcmp
        ldrb    w2, [x0], #1
        ldrb    w3, [x1], #1
        cmp     w2, w3
        b.ne    _zcmp_ne
        cbnz    w2, _zcmp
        mov     x0, #0
        ret
_zcmp_ne
        mov     x0, #1
        ret

_kernel_eval
kernel_eval PROC
        sub     sp, sp, #128
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        stp     x21, x22, [sp, #64]
        stp     x23, x24, [sp, #80]
        stp     x25, x26, [sp, #96]
        stp     x27, x28, [sp, #112]
        adrp    x2, kernel_inited
        add     x2, x2, kernel_inited
        ldr     x2, [x2]
        cbnz    x2, _eval_go
        mov     x0, #2
        neg     x0, x0
        b       _embed_ret_x0
_eval_go
        adrp    x2, source_base
        add     x2, x2, source_base
        str     x0, [x2]
        adrp    x2, to_in
        add     x2, x2, to_in
        str     xzr, [x2]
        adrp    x2, source_cur
        add     x2, x2, source_cur
        str     x0, [x2]
        adrp    x2, source_end
        add     x2, x2, source_end
        add     x0, x0, x1
        str     x0, [x2]
        adrp    x2, throw_handler
        add     x2, x2, throw_handler
        str     xzr, [x2]
        adrp    x2, bye_flag
        add     x2, x2, bye_flag
        str     xzr, [x2]
        adrp    x2, line_mode
        add     x2, x2, line_mode
        str     xzr, [x2]
        adrp    x2, source_id
        add     x2, x2, source_id
        str     xzr, [x2]
        adrp    x2, source_sp
        add     x2, x2, source_sp
        str     xzr, [x2]
        adrp    x2, view_src_id
        add     x2, x2, view_src_id
        str     xzr, [x2]
        adrp    x2, view_id_sp
        add     x2, x2, view_id_sp
        str     xzr, [x2]
        adrp    x2, eval_resume_sp
        add     x2, x2, eval_resume_sp
        str     xzr, [x2]
        bl      _vm_load
        b       _interpret_loop

_interpret_loop
        adrp    x24, latest_var
        add     x24, x24, latest_var
        bl      _check_stack
        bl      _file_echo_upto_cursor
        bl      _next_word
        cbz     x1, _interpret_empty
        mov     x25, x0
        mov     x26, x1
        b       _try_find

_try_find
        adrp    x2, state_var
        add     x2, x2, state_var
        ldr     x2, [x2]
        cbz     x2, _try_find_dict
        mov     x0, x25
        mov     x1, x26
        bl      _local_lookup
        cmp     x0, #-1
        b.eq    _try_find_dict
        mov     x25, x0
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        bl      _compile_cell
        mov     x0, x25
        bl      _compile_cell
        adrp    x0, cfa_local_at
        add     x0, x0, cfa_local_at
        ldr     x0, [x0]
        bl      _compile_cell
        b       _interpret_loop
_try_find_dict
        mov     x0, x25
        mov     x1, x26
        bl      _find_word
        cbz     x0, _try_number_after_find
        mov     x2, x0
        mov     x3, x1
        tbnz    x3, #63, _exec_found
        adrp    x6, state_var
        add     x6, x6, state_var
        ldr     x6, [x6]
        cbnz    x6, _compile_entry
_exec_found
        adrp    x19, restart_cell
        add     x19, x19, restart_cell
        mov     x21, x2
        ldr     x5, [x21]
        br      x5

_compile_entry
        mov     x0, x2
        bl      _compile_cell
        b       _interpret_loop

_try_number_after_find
        mov     x0, x25
        mov     x1, x26
        bl      _parse_number
        cbz     x0, _try_charlit
        cmp     x0, #2
        b.eq    _number_double
        adrp    x2, state_var
        add     x2, x2, state_var
        ldr     x2, [x2]
        cbnz    x2, _compile_lit
        mov     x0, x1
        DPUSH
        b       _interpret_loop

_compile_lit
        mov     x25, x1
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        bl      _compile_cell
        mov     x0, x25
        bl      _compile_cell
        b       _interpret_loop

_number_double
        adrp    x3, state_var
        add     x3, x3, state_var
        ldr     x3, [x3]
        cbnz    x3, _compile_dlit
        str     x20, [x22, #-8]!
        str     x1, [x22, #-8]!
        mov     x20, x2
        b       _interpret_loop

_compile_dlit
        stp     x1, x2, [sp, #-16]!
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        bl      _compile_cell
        ldr     x0, [sp]
        bl      _compile_cell
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        bl      _compile_cell
        ldr     x0, [sp, #8]
        bl      _compile_cell
        add     sp, sp, #16
        b       _interpret_loop

; 'c' is a character literal. Length 3, apostrophe on both ends.
_try_charlit
        cmp     x26, #3
        b.ne    _try_float
        ldrb    w2, [x25]
        cmp     w2, #39
        b.ne    _try_float
        ldrb    w2, [x25, #2]
        cmp     w2, #39
        b.ne    _try_float
        ldrb    w1, [x25, #1]
        adrp    x2, state_var
        add     x2, x2, state_var
        ldr     x2, [x2]
        cbnz    x2, _compile_lit
        mov     x0, x1
        DPUSH
        b       _interpret_loop

; 1.5E0 and 1E-12. A trailing-dot double already returned from _parse_number.
_try_float
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        mov     x0, #100
        mov     x1, #0
        mov     x2, x26
        mov     x3, #0
        mov     x4, #0
        mov     x5, x25
        add     x6, sp, #48
        str     xzr, [sp, #48]
        str     xzr, [sp, #56]
        str     xzr, [sp, #64]
        bl      host_float_op
        ldr     x6, [sp, #48]
        ldr     x7, [sp, #56]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        cbz     x6, _interpret_undef
        mov     x26, x7
        adrp    x2, state_var
        add     x2, x2, state_var
        ldr     x2, [x2]
        cbnz    x2, _compile_flit
        mov     x1, x26
        mov     x0, #101
        mov     x2, #0
        mov     x3, #0
        mov     x4, #0
        mov     x5, #0
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        add     x6, sp, #48
        str     xzr, [sp, #48]
        str     xzr, [sp, #56]
        str     xzr, [sp, #64]
        bl      host_float_op
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        b       _interpret_loop

_compile_flit
        mov     x25, x26
        adrp    x0, cfa_flit
        add     x0, x0, cfa_flit
        ldr     x0, [x0]
        bl      _compile_cell
        mov     x0, x25
        bl      _compile_cell
        b       _interpret_loop

_interpret_undef
        mov     x0, x25
        mov     x1, x26
        bl      emit_str
        adrp    x0, msg_huh
        add     x0, x0, msg_huh
        bl      emit_cstr
        adrp    x7, throw_handler
        add     x7, x7, throw_handler
        ldr     x1, [x7]
        cbz     x1, _undef_abandon
        mov     x20, #-13
        b       XTHROW

; No CATCH around this evaluate (the console). Stop on this token.
; Compiling goes off and both stacks are emptied. A loaded file has a
; CATCH, so it still receives THROW -13.
_undef_abandon
        adrp    x22, data_stack
        add     x22, x22, data_stack
        add     x22, x22, #1, lsl #12
        mov     x20, #0
        bl      _local_compile_reset
        adrp    x0, noname_xt
        add     x0, x0, noname_xt
        str     xzr, [x0]
        b       _do_quit

_interpret_empty
        adrp    x0, line_mode
        add     x0, x0, line_mode
        ldr     x0, [x0]
        cbz     x0, _ie_whole
        bl      _take_line
        cbnz    x0, _interpret_loop
        b       _ie_pop
_ie_whole
        adrp    x0, source_sp
        add     x0, x0, source_sp
        ldr     x0, [x0]
        cbz     x0, _embed_finish
_ie_pop
        adrp    x0, source_id
        add     x0, x0, source_id
        ldr     x25, [x0]
        bl      _pop_source
        cbz     x0, _embed_finish
        cmp     x25, #0
        b.gt    _ie_view_pop
        cmn     x25, #2
        b.ne    _ie_after_view
_ie_view_pop
        bl      _view_pop_src_id
_ie_after_view
        cmn     x25, #1
        b.eq    _ie_resume
        cmn     x25, #2
        b.ne    _interpret_loop
_ie_resume
        bl      _eval_resume_pop
        cbz     x0, _interpret_loop
        mov     x19, x0
        NEXT

; QUIT returns to the host loop. The data stack stays. The return
; stack, CATCH frame, and nested SOURCE do not.
_do_quit
        adrp    x23, return_stack
        add     x23, x23, return_stack
        add     x23, x23, #1, lsl #12
        adrp    x0, throw_handler
        add     x0, x0, throw_handler
        str     xzr, [x0]
        adrp    x0, state_var
        add     x0, x0, state_var
        str     xzr, [x0]
        adrp    x0, source_sp
        add     x0, x0, source_sp
        str     xzr, [x0]
        adrp    x0, eval_resume_sp
        add     x0, x0, eval_resume_sp
        str     xzr, [x0]
        adrp    x0, source_id
        add     x0, x0, source_id
        str     xzr, [x0]
        adrp    x0, view_src_id
        add     x0, x0, view_src_id
        str     xzr, [x0]
        adrp    x0, view_id_sp
        add     x0, x0, view_id_sp
        str     xzr, [x0]
        adrp    x0, line_mode
        add     x0, x0, line_mode
        str     xzr, [x0]
        adrp    x0, blk_var
        add     x0, x0, blk_var
        str     xzr, [x0]
        adrp    x0, local_frame_depth
        add     x0, x0, local_frame_depth
        str     xzr, [x0]
        bl      _vm_save
        mov     x0, #0
        b       _embed_ret_x0

_embed_finish
        bl      _record_words_user_base_once
        bl      _vm_save
        mov     x0, #0
        b       _embed_ret_x0

_quit_exit
        b       _embed_bye_return

_embed_bye_return
        bl      _vm_save
        mov     x0, #1
        b       _embed_ret_x0

_embed_ret_x0
        ldp     x27, x28, [sp, #112]
        ldp     x25, x26, [sp, #96]
        ldp     x23, x24, [sp, #80]
        ldp     x21, x22, [sp, #64]
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #128
        ret
        ENDP

; Between outer-interpreter words. Empty is data_stack+4096.
; Above that is underflow. Below data_stack is overflow.
; . on an empty stack has already printed the cached 0 and a space.
; Kept outside kernel_eval so ret returns to the interpreter, not to C.
_check_stack
        adrp    x0, data_stack
        add     x0, x0, data_stack
        add     x1, x0, #1, lsl #12
        cmp     x22, x1
        b.hi    _stack_underflow
        cmp     x22, x0
        b.lo    _stack_overflow
        ret

_stack_underflow
        adrp    x0, msg_underflow
        add     x0, x0, msg_underflow
        bl      emit_cstr
        b       _stack_reset_abandon

_stack_overflow
        adrp    x0, msg_overflow
        add     x0, x0, msg_overflow
        bl      emit_cstr
_stack_reset_abandon
        b       _undef_abandon

; FILE-ECHO. Echo source lines of a file load up through the line that
; holds the next token. Each line is "NNNNN| " plus the text. source-id
; -2 is (LINE-SOURCE). A positive id is a classic file buffer.
_file_echo_upto_cursor
        stp     x29, x30, [sp, #-16]!
        adrp    x0, file_echo
        add     x0, x0, file_echo
        ldr     x0, [x0]
        cbz     x0, _fe_done
        adrp    x0, source_id
        add     x0, x0, source_id
        ldr     x0, [x0]
        cmp     x0, #0
        b.gt    _fe_on
        cmn     x0, #2
        b.ne    _fe_done
_fe_on
        sub     sp, sp, #48
        adrp    x4, line_mode
        add     x4, x4, line_mode
        ldr     x4, [x4]
        cbz     x4, _fe_src
        adrp    x1, line_origin
        add     x1, x1, line_origin
        ldr     x1, [x1]
        adrp    x2, line_limit
        add     x2, x2, line_limit
        ldr     x2, [x2]
        b       _fe_bounds
_fe_src
        adrp    x1, source_base
        add     x1, x1, source_base
        ldr     x1, [x1]
        adrp    x2, source_end
        add     x2, x2, source_end
        ldr     x2, [x2]
_fe_bounds
        str     x1, [sp]
        str     x2, [sp, #8]
        adrp    x0, source_cur
        add     x0, x0, source_cur
        ldr     x0, [x0]
        cmp     x0, x1
        b.hs    _fe_clamp_hi
        mov     x0, x1
_fe_clamp_hi
        cmp     x0, x2
        b.ls    _fe_skip
        mov     x0, x2
_fe_skip
        cmp     x0, x2
        b.hs    _fe_eol
        ldrb    w3, [x0]
        cbz     w3, _fe_eol
        cmp     w3, #32
        b.eq    _fe_skip1
        cmp     w3, #9
        b.eq    _fe_skip1
        cmp     w3, #10
        b.eq    _fe_skip1
        cmp     w3, #13
        b.eq    _fe_skip1
        b       _fe_eol
_fe_skip1
        add     x0, x0, #1
        b       _fe_skip
_fe_eol
        mov     x3, x0
_fe_eol_scan
        cmp     x3, x2
        b.hs    _fe_eol_ok
        ldrb    w4, [x3]
        cbz     w4, _fe_eol_ok
        cmp     w4, #10
        b.eq    _fe_eol_ok
        cmp     w4, #13
        b.eq    _fe_eol_ok
        add     x3, x3, #1
        b       _fe_eol_scan
_fe_eol_ok
        str     x3, [sp, #16]
        adrp    x4, file_echo_pos
        add     x4, x4, file_echo_pos
        ldr     x0, [x4]
        ldr     x1, [sp]
        cmp     x0, x1
        b.hs    _fe_pos_hi
        mov     x0, x1
_fe_pos_hi
        ldr     x2, [sp, #8]
        cmp     x0, x2
        b.ls    _fe_pos_ok
        mov     x0, x2
_fe_pos_ok
        str     x0, [sp, #24]
        ldr     x3, [sp, #16]
        cmp     x0, x3
        b.hs    _fe_drop
_fe_line
        ldr     x0, [sp, #24]
        ldr     x3, [sp, #16]
        cmp     x0, x3
        b.hs    _fe_drop
        ldr     x1, [sp]
        cmp     x0, x1
        b.eq    _fe_num
        ldrb    w4, [x0, #-1]
        cmp     w4, #10
        b.eq    _fe_num
        cmp     w4, #13
        b.eq    _fe_num
        b       _fe_text
_fe_num
        mov     x4, #1
        mov     x3, x1
_fe_count
        cmp     x3, x0
        b.hs    _fe_count_done
        ldrb    w5, [x3]
        cmp     w5, #10
        b.ne    _fe_count_next
        add     x4, x4, #1
_fe_count_next
        add     x3, x3, #1
        b       _fe_count
_fe_count_done
        mov     x0, x4
        bl      _fe_emit_lineno
_fe_text
        ldr     x0, [sp, #24]
        ldr     x2, [sp, #8]
        mov     x3, x0
_fe_text_scan
        cmp     x3, x2
        b.hs    _fe_text_write
        ldrb    w4, [x3]
        cbz     w4, _fe_text_write
        cmp     w4, #10
        b.eq    _fe_text_write
        cmp     w4, #13
        b.eq    _fe_text_write
        add     x3, x3, #1
        b       _fe_text_scan
_fe_text_write
        mov     x1, x3
        ldr     x0, [sp, #24]
        subs    x1, x1, x0
        b.eq    _fe_advance
        str     x3, [sp, #32]
        bl      emit_str
        ldr     x3, [sp, #32]
_fe_advance
        ldr     x2, [sp, #8]
        mov     x1, x3
        cmp     x3, x2
        b.hs    _fe_store
        ldrb    w0, [x3]
        cmp     w0, #10
        b.eq    _fe_one
        cmp     w0, #13
        b.ne    _fe_store
        add     x1, x3, #1
        cmp     x1, x2
        b.hs    _fe_store
        ldrb    w0, [x1]
        cmp     w0, #10
        b.ne    _fe_store
        add     x1, x1, #1
        b       _fe_store
_fe_one
        add     x1, x3, #1
_fe_store
        str     x1, [sp, #24]
        adrp    x4, file_echo_pos
        add     x4, x4, file_echo_pos
        str     x1, [x4]
        mov     x0, #10
        bl      _putchar
        b       _fe_line
_fe_drop
        add     sp, sp, #48
_fe_done
        ldp     x29, x30, [sp], #16
        ret

_fe_emit_lineno
        stp     x29, x30, [sp, #-32]!
        str     x0, [sp, #16]
        mov     x1, #1
        mov     x2, #10
_fe_digits
        cmp     x0, x2
        b.lo    _fe_pad
        add     x1, x1, #1
        mov     x3, #10
        mul     x2, x2, x3
        cmp     x1, #5
        b.lo    _fe_digits
_fe_pad
        mov     x2, #5
        subs    x2, x2, x1
        b.ls    _fe_print
_fe_spaces
        mov     x0, #32
        str     x2, [sp, #24]
        bl      _putchar
        ldr     x2, [sp, #24]
        subs    x2, x2, #1
        b.ne    _fe_spaces
_fe_print
        ldr     x0, [sp, #16]
        bl      _print_unsigned
        mov     x0, #124
        bl      _putchar
        mov     x0, #32
        bl      _putchar
        ldp     x29, x30, [sp], #32
        ret

; Line window over an included file. Eight quads per source frame:
; base, end, >IN, source-id, line_mode, origin, limit, next.
; file_echo_pos is reset to the start of this file image.
_arm_lines
        adrp    x2, file_echo_pos
        add     x2, x2, file_echo_pos
        str     x0, [x2]
        adrp    x2, line_origin
        add     x2, x2, line_origin
        str     x0, [x2]
        add     x3, x0, x1
        adrp    x2, line_limit
        add     x2, x2, line_limit
        str     x3, [x2]
        adrp    x2, line_next
        add     x2, x2, line_next
        str     x0, [x2]
        mov     x3, #1
        adrp    x2, line_mode
        add     x2, x2, line_mode
        str     x3, [x2]
        ret

_take_line
        adrp    x2, line_next
        add     x2, x2, line_next
        ldr     x0, [x2]
        adrp    x3, line_limit
        add     x3, x3, line_limit
        ldr     x3, [x3]
        cmp     x0, x3
        b.hs    _tl_eof
        mov     x1, x0
_tl_scan
        cmp     x1, x3
        b.hs    _tl_eos
        ldrb    w4, [x1]
        cmp     w4, #10
        b.eq    _tl_lf
        cmp     w4, #13
        b.eq    _tl_cr
        add     x1, x1, #1
        b       _tl_scan
_tl_lf
        mov     x5, x1
        add     x1, x1, #1
        b       _tl_set
_tl_cr
        mov     x5, x1
        add     x1, x1, #1
        cmp     x1, x3
        b.hs    _tl_set
        ldrb    w4, [x1]
        cmp     w4, #10
        b.ne    _tl_set
        add     x1, x1, #1
        b       _tl_set
_tl_eos
        mov     x5, x1
_tl_set
        adrp    x2, line_next
        add     x2, x2, line_next
        str     x1, [x2]
        adrp    x2, source_base
        add     x2, x2, source_base
        str     x0, [x2]
        adrp    x2, source_end
        add     x2, x2, source_end
        str     x5, [x2]
        adrp    x2, to_in
        add     x2, x2, to_in
        str     xzr, [x2]
        adrp    x2, source_cur
        add     x2, x2, source_cur
        str     x0, [x2]
        mov     x0, #1
        ret
_tl_eof
        mov     x0, #0
        ret

_push_source
        adrp    x0, source_sp
        add     x0, x0, source_sp
        ldr     x1, [x0]
        cmp     x1, #8
        b.hs    _ps_full
        lsl     x3, x1, #6
        adrp    x2, source_stack
        add     x2, x2, source_stack
        add     x2, x2, x3
        adrp    x3, source_base
        add     x3, x3, source_base
        ldr     x3, [x3]
        str     x3, [x2], #8
        adrp    x3, source_end
        add     x3, x3, source_end
        ldr     x3, [x3]
        str     x3, [x2], #8
        adrp    x3, to_in
        add     x3, x3, to_in
        ldr     x3, [x3]
        str     x3, [x2], #8
        adrp    x3, source_id
        add     x3, x3, source_id
        ldr     x3, [x3]
        str     x3, [x2], #8
        adrp    x3, line_mode
        add     x3, x3, line_mode
        ldr     x3, [x3]
        str     x3, [x2], #8
        adrp    x3, line_origin
        add     x3, x3, line_origin
        ldr     x3, [x3]
        str     x3, [x2], #8
        adrp    x3, line_limit
        add     x3, x3, line_limit
        ldr     x3, [x3]
        str     x3, [x2], #8
        adrp    x3, line_next
        add     x3, x3, line_next
        ldr     x3, [x3]
        str     x3, [x2]
        adrp    x3, file_echo_pos
        add     x3, x3, file_echo_pos
        ldr     x3, [x3]
        adrp    x2, file_echo_stack
        add     x2, x2, file_echo_stack
        str     x3, [x2, x1, lsl #3]
        adrp    x3, blk_var
        add     x3, x3, blk_var
        ldr     x3, [x3]
        adrp    x2, blk_stack
        add     x2, x2, blk_stack
        str     x3, [x2, x1, lsl #3]
        add     x1, x1, #1
        str     x1, [x0]
        mov     x0, #1
        ret
_ps_full
        mov     x0, #0
        ret

_pop_source
        adrp    x0, source_sp
        add     x0, x0, source_sp
        ldr     x1, [x0]
        cbz     x1, _pop_empty
        sub     x1, x1, #1
        str     x1, [x0]
        lsl     x3, x1, #6
        adrp    x2, source_stack
        add     x2, x2, source_stack
        add     x2, x2, x3
        ldr     x3, [x2], #8
        adrp    x0, source_base
        add     x0, x0, source_base
        str     x3, [x0]
        mov     x4, x3
        ldr     x3, [x2], #8
        adrp    x0, source_end
        add     x0, x0, source_end
        str     x3, [x0]
        ldr     x3, [x2], #8
        adrp    x0, to_in
        add     x0, x0, to_in
        str     x3, [x0]
        add     x4, x4, x3
        adrp    x0, source_cur
        add     x0, x0, source_cur
        str     x4, [x0]
        ldr     x3, [x2], #8
        adrp    x0, source_id
        add     x0, x0, source_id
        str     x3, [x0]
        ldr     x3, [x2], #8
        adrp    x0, line_mode
        add     x0, x0, line_mode
        str     x3, [x0]
        ldr     x3, [x2], #8
        adrp    x0, line_origin
        add     x0, x0, line_origin
        str     x3, [x0]
        ldr     x3, [x2], #8
        adrp    x0, line_limit
        add     x0, x0, line_limit
        str     x3, [x0]
        ldr     x3, [x2]
        adrp    x0, line_next
        add     x0, x0, line_next
        str     x3, [x0]
        adrp    x2, file_echo_stack
        add     x2, x2, file_echo_stack
        ldr     x3, [x2, x1, lsl #3]
        adrp    x0, file_echo_pos
        add     x0, x0, file_echo_pos
        str     x3, [x0]
        adrp    x2, blk_stack
        add     x2, x2, blk_stack
        ldr     x3, [x2, x1, lsl #3]
        adrp    x0, blk_var
        add     x0, x0, blk_var
        str     x3, [x0]
        mov     x0, #1
        ret
_pop_empty
        mov     x0, #0
        ret

_eval_resume_push
        adrp    x0, eval_resume_sp
        add     x0, x0, eval_resume_sp
        ldr     x1, [x0]
        cmp     x1, #8
        b.hs    _erp_full
        adrp    x2, eval_resume_stack
        add     x2, x2, eval_resume_stack
        lsl     x3, x1, #3
        str     x19, [x2, x3]
        add     x1, x1, #1
        str     x1, [x0]
_erp_full
        ret

_eval_resume_pop
        adrp    x0, eval_resume_sp
        add     x0, x0, eval_resume_sp
        ldr     x1, [x0]
        cbz     x1, _erpop_empty
        sub     x1, x1, #1
        str     x1, [x0]
        adrp    x2, eval_resume_stack
        add     x2, x2, eval_resume_stack
        lsl     x3, x1, #3
        ldr     x0, [x2, x3]
        ret
_erpop_empty
        mov     x0, #0
        ret

; x0 = source_sp to restore. Pop frames above that level.
_throw_unwind_to_sp
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        str     x0, [sp, #48]
_tu_loop
        adrp    x0, source_sp
        add     x0, x0, source_sp
        ldr     x1, [x0]
        ldr     x2, [sp, #48]
        cmp     x1, x2
        b.ls    _tu_done
        adrp    x0, source_id
        add     x0, x0, source_id
        ldr     x0, [x0]
        str     x0, [sp, #56]
        bl      _pop_source
        cbz     x0, _tu_done
        ldr     x0, [sp, #56]
        cmp     x0, #0
        b.gt    _tu_view
        cmn     x0, #2
        b.ne    _tu_loop
_tu_view
        bl      _view_pop_src_id
        b       _tu_loop
_tu_done
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        ret

_vm_save
        adrp    x0, vm_tos
        add     x0, x0, vm_tos
        str     x20, [x0]
        adrp    x0, vm_dsp
        add     x0, x0, vm_dsp
        str     x22, [x0]
        adrp    x0, vm_rsp
        add     x0, x0, vm_rsp
        str     x23, [x0]
        ret

_vm_load
        adrp    x24, latest_var
        add     x24, x24, latest_var
        adrp    x0, vm_tos
        add     x0, x0, vm_tos
        ldr     x20, [x0]
        adrp    x0, vm_dsp
        add     x0, x0, vm_dsp
        ldr     x22, [x0]
        adrp    x0, vm_rsp
        add     x0, x0, vm_rsp
        ldr     x23, [x0]
        adrp    x0, debug_armed
        add     x0, x0, debug_armed
        ldr     x28, [x0]
        cbnz    x22, _vm_load_ok
        b       _vm_reset_stacks
_vm_load_ok
        ret

_vm_reset_stacks
        adrp    x22, data_stack
        add     x22, x22, data_stack
        add     x22, x22, #1, lsl #12
        mov     x20, #0
        adrp    x23, return_stack
        add     x23, x23, return_stack
        add     x23, x23, #1, lsl #12
        adrp    x24, latest_var
        add     x24, x24, latest_var
        adrp    x0, state_var
        add     x0, x0, state_var
        str     xzr, [x0]
        ret

next_debug_gate
        adrp    x16, next_debug
        add     x16, x16, next_debug
        br      x16

        AREA |.rdata|, DATA, READONLY, ALIGN=8

msg_huh         DCB     " ?", 10, 0
msg_underflow   DCB     "stack underflow", 10, 0
msg_overflow    DCB     "stack overflow", 10, 0
        ALIGN   8
boot_cmp_lit    DCB     "LIT", 0
boot_cmp_exit   DCB     "EXIT", 0
boot_cmp_branch DCB     "BRANCH", 0
boot_cmp_0branch DCB    "0BRANCH", 0
boot_cmp_does   DCB     "(DOES>)", 0
boot_cmp_slit   DCB     "(S", 0x22, ")", 0
boot_cmp_cstr   DCB     "(C", 0x22, ")", 0
boot_cmp_execute DCB    "EXECUTE", 0
boot_cmp_comma  DCB     0x2C, 0
boot_cmp_flit   DCB     "FLIT", 0
boot_cmp_linit  DCB     "LOCAL-INIT", 0
boot_cmp_lat    DCB     "(LOCAL@)", 0
boot_cmp_lstore DCB     "(LOCAL!)", 0
boot_cmp_loop   DCB     "(LOOP)", 0
boot_cmp_ploop  DCB     "(+LOOP)", 0

        END
