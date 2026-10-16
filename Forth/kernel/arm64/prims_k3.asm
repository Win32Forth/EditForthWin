; Words the cold files after kernel2.fth need at load time.
; {: locals and SEARCH-WORDLIST run while vocemit.fth and vocsys.fth
; move headers. SOURCE, LEAVE, 2*, 2/, and L@/L! are referenced from
; definitions. The (APP-*) words call the graphics host.

        INCLUDE Forth/kernel/arm64/vm.inc

        EXTERN next_debug
        EXTERN debug_break_asap
        INCLUDE Forth/kernel/arm64/boot_words.inc

        AREA |.text|, CODE, READONLY, ALIGN=4

LOCAL_MAX       EQU 32
LOCAL_NAME_STR  EQU 32
LOCAL_FRAME_MAX EQU 16

        EXTERN state_var
        EXTERN source_base
        EXTERN source_end
        EXTERN data_stack
        EXTERN cfa_lit
        EXTERN cfa_local_init
        EXTERN cfa_local_at
        EXTERN cfa_local_store
        EXTERN cfa_loop
        EXTERN cfa_plusloop
        EXTERN local_name_count
        EXTERN local_init_count
        EXTERN local_init_reverse
        EXTERN local_declaring
        EXTERN local_brace_phase
        EXTERN local_names
        EXTERN local_frame_depth
        EXTERN local_frames
        EXTERN local_frame_rsp
        EXTERN local_frame_n
        EXTERN _next_word
        EXTERN _dict_hash
        EXTERN _compile_cell
        EXTERN _cursor_load
        EXTERN _cursor_commit
        EXTERN here_ptr
        EXTERN host_app_open
        EXTERN host_app_close
        EXTERN host_app_blit
        EXTERN host_app_pblit
        EXTERN host_app_cblit
        EXTERN host_app_keyq
        EXTERN host_app_key
        EXTERN host_app_name
        EXTERN host_app_tone
        EXTERN host_app_pump
        EXTERN host_app_mouse
        EXTERN host_app_size
        EXTERN host_app_img_choose
        EXTERN host_app_img_load
        EXTERN host_app_img_size
        EXTERN host_app_img_render
        EXTERN host_app_file_choose
        EXTERN host_app_file_save_as
        EXTERN host_app_file_path
        EXTERN host_app_file_slurp
        EXTERN host_app_file_spew
        EXTERN host_oop_call
        EXTERN cfa_slit
        EXTERN slit_esc_buf
        EXTERN slit_esc_buf2
        EXTERN slit_esc_which
        EXTERN _putchar
        EXTERN emit_str
        EXTERN emit_cstr
        EXTERN _print_unsigned
        EXTERN latest_var
        EXTERN search_order
        EXTERN search_order_n
        EXTERN DODOES
        EXTERN words_user_base
        EXTERN words_filter
        EXTERN words_filter_len
        EXTERN words_nk_tmp
        EXTERN words_cfa

        EXPORT _local_compile_reset
        EXPORT _local_add_name
        EXPORT _local_lookup
        EXPORT _local_finalize_compile
        EXPORT _local_frame_try_exit
        EXPORT XLOCAL_INIT
        EXPORT XLOCAL_AT
        EXPORT XLOCAL_STORE
        EXPORT XLOCAL_BRACE
        EXPORT XSEARCH_WORDLIST
        EXPORT XSOURCE
        EXPORT XLEAVE
        EXPORT XTWOSTAR
        EXPORT XTWOSLASH
        EXPORT XLFETCH
        EXPORT XLSTORE
        EXPORT _record_words_user_base_once
        EXPORT _words_name_ptr
        EXPORT _words_cfa_cmp
        EXPORT _words_filter_match
        EXPORT _print_wid_name

        BOOT_WORD LOCAL-INIT, LOCAL-INIT ( n nInit rev -- ) create a locals frame, 0, XLOCAL_INIT, XLOCAL_INIT_END
XLOCAL_INIT
        mov     x2, x20
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        cmp     x0, #LOCAL_MAX
        b.ls    _li_n_ok
        mov     x0, #LOCAL_MAX
_li_n_ok
        cmp     x1, x0
        b.ls    _li_i_ok
        mov     x1, x0
_li_i_ok
        adrp    x3, local_frame_depth
        add     x3, x3, local_frame_depth
        ldr     x4, [x3]
        cmp     x4, #LOCAL_FRAME_MAX
        b.hs    _li_overflow
        mov     x5, #LOCAL_MAX
        mul     x5, x5, x4
        lsl     x5, x5, #3
        adrp    x6, local_frames
        add     x6, x6, local_frames
        add     x6, x6, x5
        mov     x7, #0
_li_zero
        cmp     x7, x0
        b.hs    _li_fill
        lsl     x8, x7, #3
        str     xzr, [x6, x8]
        add     x7, x7, #1
        b       _li_zero
_li_fill
        cbz     x2, _li_forward
        mov     x7, x1
_li_rev
        cbz     x7, _li_mark
        sub     x7, x7, #1
        lsl     x8, x7, #3
        str     x20, [x6, x8]
        ldr     x20, [x22], #8
        b       _li_rev
_li_forward
        mov     x7, #0
_li_fwd
        cmp     x7, x1
        b.hs    _li_mark
        lsl     x8, x7, #3
        str     x20, [x6, x8]
        ldr     x20, [x22], #8
        add     x7, x7, #1
        b       _li_fwd
_li_mark
        adrp    x5, local_frame_rsp
        add     x5, x5, local_frame_rsp
        lsl     x8, x4, #3
        str     x23, [x5, x8]
        adrp    x5, local_frame_n
        add     x5, x5, local_frame_n
        str     x0, [x5, x8]
        add     x4, x4, #1
        str     x4, [x3]
        b       XLOCAL_INIT_END
_li_overflow
        mov     x7, x1
_li_drain
        cbz     x7, XLOCAL_INIT_END
        ldr     x20, [x22], #8
        sub     x7, x7, #1
        b       _li_drain
XLOCAL_INIT_END
        NEXT

        BOOT_WORD (LOCAL@), (LOCAL@) ( idx -- x ) fetch a local, 0, XLOCAL_AT, XLOCAL_AT_END
XLOCAL_AT
        mov     x0, x20
        adrp    x1, local_frame_depth
        add     x1, x1, local_frame_depth
        ldr     x1, [x1]
        cbz     x1, _lat_none
        sub     x1, x1, #1
        mov     x2, #LOCAL_MAX
        mul     x2, x2, x1
        lsl     x2, x2, #3
        adrp    x3, local_frames
        add     x3, x3, local_frames
        add     x3, x3, x2
        adrp    x2, local_frame_n
        add     x2, x2, local_frame_n
        lsl     x4, x1, #3
        ldr     x2, [x2, x4]
        cmp     x0, x2
        b.hs    _lat_none
        lsl     x4, x0, #3
        ldr     x20, [x3, x4]
        b       XLOCAL_AT_END
_lat_none
        mov     x20, #0
XLOCAL_AT_END
        NEXT

        BOOT_WORD (LOCAL!), (LOCAL!) ( x idx -- ) store a local, 0, XLOCAL_STORE, XLOCAL_STORE_END
XLOCAL_STORE
        mov     x0, x20
        ldr     x1, [x22], #8
        ldr     x20, [x22], #8
        adrp    x2, local_frame_depth
        add     x2, x2, local_frame_depth
        ldr     x2, [x2]
        cbz     x2, XLOCAL_STORE_END
        sub     x2, x2, #1
        mov     x3, #LOCAL_MAX
        mul     x3, x3, x2
        lsl     x3, x3, #3
        adrp    x4, local_frames
        add     x4, x4, local_frames
        add     x4, x4, x3
        adrp    x3, local_frame_n
        add     x3, x3, local_frame_n
        lsl     x5, x2, #3
        ldr     x3, [x3, x5]
        cmp     x0, x3
        b.hs    XLOCAL_STORE_END
        lsl     x5, x0, #3
        str     x1, [x4, x5]
XLOCAL_STORE_END
        NEXT

        BOOT_WORD {:, declare locals until :}, FLAG_IMM, XLOCAL_BRACE, 0
XLOCAL_BRACE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        adrp    x0, state_var
        add     x0, x0, state_var
        ldr     x0, [x0]
        cbz     x0, _lb_leave
        bl      _local_compile_reset
        mov     x0, #1
        adrp    x1, local_init_reverse
        add     x1, x1, local_init_reverse
        str     x0, [x1]
        adrp    x1, local_brace_phase
        add     x1, x1, local_brace_phase
        str     xzr, [x1]
_lb_loop
        bl      _next_word
        cbz     x1, _lb_done
        cmp     x1, #2
        b.ne    _lb_bar
        ldrb    w2, [x0]
        cmp     w2, #':'
        b.ne    _lb_bar
        ldrb    w2, [x0, #1]
        cmp     w2, #'}'
        b.eq    _lb_done
_lb_bar
        cmp     x1, #1
        b.ne    _lb_dash
        ldrb    w2, [x0]
        cmp     w2, #'|'
        b.ne    _lb_dash
        mov     x2, #1
        adrp    x3, local_brace_phase
        add     x3, x3, local_brace_phase
        str     x2, [x3]
        b       _lb_loop
_lb_dash
        cmp     x1, #2
        b.ne    _lb_name
        ldrb    w2, [x0]
        cmp     w2, #'-'
        b.ne    _lb_name
        ldrb    w2, [x0, #1]
        cmp     w2, #'-'
        b.ne    _lb_name
        mov     x2, #2
        adrp    x3, local_brace_phase
        add     x3, x3, local_brace_phase
        str     x2, [x3]
        b       _lb_loop
_lb_name
        adrp    x3, local_brace_phase
        add     x3, x3, local_brace_phase
        ldr     x3, [x3]
        cmp     x3, #2
        b.eq    _lb_loop
        bl      _local_add_name
        adrp    x3, local_brace_phase
        add     x3, x3, local_brace_phase
        ldr     x3, [x3]
        cbnz    x3, _lb_loop
        adrp    x2, local_init_count
        add     x2, x2, local_init_count
        ldr     x3, [x2]
        add     x3, x3, #1
        str     x3, [x2]
        b       _lb_loop
_lb_done
        bl      _local_finalize_compile
_lb_leave
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

        BOOT_WORD (LOCAL-COMPILE-RESET), (LOCAL-COMPILE-RESET) ( -- ) clear locals compile state, FLAG_EMM, XLOCAL_COMPILE_RESET, XLOCAL_COMPILE_RESET_END
XLOCAL_COMPILE_RESET
_local_compile_reset
        adrp    x0, local_name_count
        add     x0, x0, local_name_count
        str     xzr, [x0]
        adrp    x0, local_init_count
        add     x0, x0, local_init_count
        str     xzr, [x0]
        adrp    x0, local_init_reverse
        add     x0, x0, local_init_reverse
        str     xzr, [x0]
        adrp    x0, local_declaring
        add     x0, x0, local_declaring
        str     xzr, [x0]
        ret
XLOCAL_COMPILE_RESET_END

        BOOT_WORD (LOCAL-ADD-NAME), (LOCAL-ADD-NAME) ( -- ) add one local name, FLAG_EMM, XLOCAL_ADD_NAME, XLOCAL_ADD_NAME_END
XLOCAL_ADD_NAME
_local_add_name
        stp     x29, x30, [sp, #-16]!
        stp     x19, x20, [sp, #-16]!
        mov     x19, x0
        mov     x20, x1
        adrp    x0, local_name_count
        add     x0, x0, local_name_count
        ldr     x1, [x0]
        cmp     x1, #LOCAL_MAX
        b.hs    _lan_done
        mov     x2, #LOCAL_NAME_STR
        mul     x2, x2, x1
        adrp    x3, local_names
        add     x3, x3, local_names
        add     x3, x3, x2
        cmp     x20, #31
        b.ls    _lan_len
        mov     x20, #31
_lan_len
        strb    w20, [x3], #1
        mov     x2, #0
_lan_cp
        cmp     x2, x20
        b.hs    _lan_count
        ldrb    w4, [x19, x2]
        cmp     w4, #'a'
        b.lo    _lan_st
        cmp     w4, #'z'
        b.hi    _lan_st
        sub     w4, w4, #32
_lan_st
        strb    w4, [x3, x2]
        add     x2, x2, #1
        b       _lan_cp
_lan_count
        adrp    x0, local_name_count
        add     x0, x0, local_name_count
        ldr     x1, [x0]
        add     x1, x1, #1
        str     x1, [x0]
_lan_done
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
XLOCAL_ADD_NAME_END

        BOOT_WORD (LOCAL-LOOKUP), (LOCAL-LOOKUP) ( -- ) local name index or -1, FLAG_EMM, XLOCAL_LOOKUP, XLOCAL_LOOKUP_END
XLOCAL_LOOKUP
_local_lookup
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        mov     x19, x0
        mov     x20, x1
        adrp    x0, local_name_count
        add     x0, x0, local_name_count
        ldr     x21, [x0]
        mov     x22, #0
_ll_loop
        cmp     x22, x21
        b.hs    _ll_miss
        mov     x2, #LOCAL_NAME_STR
        mul     x2, x2, x22
        adrp    x3, local_names
        add     x3, x3, local_names
        add     x3, x3, x2
        ldrb    w2, [x3], #1
        cmp     x2, x20
        b.ne    _ll_next
        mov     x4, #0
_ll_cmp
        cmp     x4, x20
        b.hs    _ll_hit
        ldrb    w5, [x3, x4]
        ldrb    w6, [x19, x4]
        cmp     w6, #'a'
        b.lo    _ll_fold
        cmp     w6, #'z'
        b.hi    _ll_fold
        sub     w6, w6, #32
_ll_fold
        cmp     w5, w6
        b.ne    _ll_next
        add     x4, x4, #1
        b       _ll_cmp
_ll_next
        add     x22, x22, #1
        b       _ll_loop
_ll_miss
        mov     x0, #-1
        b       _ll_out
_ll_hit
        mov     x0, x22
_ll_out
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ret
XLOCAL_LOOKUP_END

        BOOT_WORD (LOCAL-FINALIZE), (LOCAL-FINALIZE) ( -- ) compile LOCAL-INIT, FLAG_EMM, XLOCAL_FINALIZE, XLOCAL_FINALIZE_END
XLOCAL_FINALIZE
_local_finalize_compile
        stp     x29, x30, [sp, #-16]!
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        bl      _compile_cell
        adrp    x0, local_name_count
        add     x0, x0, local_name_count
        ldr     x0, [x0]
        bl      _compile_cell
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        bl      _compile_cell
        adrp    x0, local_init_count
        add     x0, x0, local_init_count
        ldr     x0, [x0]
        bl      _compile_cell
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        bl      _compile_cell
        adrp    x0, local_init_reverse
        add     x0, x0, local_init_reverse
        ldr     x0, [x0]
        bl      _compile_cell
        adrp    x0, cfa_local_init
        add     x0, x0, cfa_local_init
        ldr     x0, [x0]
        bl      _compile_cell
        ldp     x29, x30, [sp], #16
        ret
XLOCAL_FINALIZE_END

        BOOT_WORD (LOCAL-FRAME-EXIT), (LOCAL-FRAME-EXIT) ( -- ) pop locals frame when RSP matches, FLAG_EMM, XLOCAL_FRAME_TRY_EXIT, XLOCAL_FRAME_TRY_EXIT_END
XLOCAL_FRAME_TRY_EXIT
_local_frame_try_exit
        adrp    x0, local_frame_depth
        add     x0, x0, local_frame_depth
        ldr     x1, [x0]
        cbz     x1, _lfe_done
        sub     x1, x1, #1
        adrp    x2, local_frame_rsp
        add     x2, x2, local_frame_rsp
        lsl     x3, x1, #3
        ldr     x2, [x2, x3]
        cmp     x2, x23
        b.ne    _lfe_done
        str     x1, [x0]
_lfe_done
        ret
XLOCAL_FRAME_TRY_EXIT_END

        BOOT_WORD SEARCH-WORDLIST, SEARCH-WORDLIST ( c-addr u wid -- 0 | xt 1 | xt -1 ) find in one wordlist, 0, XSEARCH_WORDLIST, 0
XSEARCH_WORDLIST
        mov     x9, x20
        ldr     x8, [x22], #8
        ldr     x7, [x22], #8
        cbz     x9, _swl_zero
        cbz     x8, _swl_zero
        stp     x7, x8, [sp, #-16]!
        str     x9, [sp, #-16]!
        mov     x0, x7
        mov     x1, x8
        mov     x12, x30
        bl      _dict_hash
        mov     x30, x12
        mov     x10, x0
        ldr     x9, [sp], #16
        ldp     x7, x8, [sp], #16
        add     x9, x9, x10, lsl #3
        ldr     x11, [x9]
_swl_loop
        cbz     x11, _swl_zero
        ldr     x2, [x11, #-8]
        and     x3, x2, #0xFFFF
        sub     x4, x11, x3
        ldrb    w3, [x4], #1
        tbnz    w3, #7, _swl_next
        and     w3, w3, #0x7F
        cmp     x3, x8
        b.ne    _swl_next
        mov     x5, #0
_swl_cmp
        cmp     x5, x8
        b.hs    _swl_hit
        ldrb    w6, [x4, x5]
        ldrb    w10, [x7, x5]
        cmp     w10, #'a'
        b.lo    _swl_fold
        cmp     w10, #'z'
        b.hi    _swl_fold
        sub     w10, w10, #32
_swl_fold
        cmp     w6, w10
        b.ne    _swl_next
        add     x5, x5, #1
        b       _swl_cmp
_swl_hit
        ldr     x1, [x11, #-8]
        tbnz    x1, #63, _swl_imm
        mov     x4, #-1
        b       _swl_push
_swl_imm
        mov     x4, #1
_swl_push
        str     x11, [x22, #-8]!
        mov     x20, x4
        NEXT
_swl_next
        ldr     x11, [x11, #-16]
        b       _swl_loop
_swl_zero
        mov     x20, #0
        NEXT

        BOOT_WORD SOURCE, SOURCE ( -- c-addr u ) current input buffer and length, 0, XSOURCE, 0
XSOURCE
        adrp    x0, source_base
        add     x0, x0, source_base
        ldr     x0, [x0]
        adrp    x1, source_end
        add     x1, x1, source_end
        ldr     x1, [x1]
        sub     x1, x1, x0
        str     x20, [x22, #-8]!
        str     x0, [x22, #-8]!
        mov     x20, x1
        NEXT

        BOOT_WORD LEAVE, LEAVE ( -- ) exit the current DO loop, 0, XLEAVE, XLEAVE_END
XLEAVE
        add     x23, x23, #16
        adrp    x1, cfa_loop
        add     x1, x1, cfa_loop
        ldr     x1, [x1]
        adrp    x2, cfa_plusloop
        add     x2, x2, cfa_plusloop
        ldr     x2, [x2]
_leave_scan
        ldr     x0, [x19], #8
        cmp     x0, x1
        b.eq    _leave_skip
        cmp     x0, x2
        b.ne    _leave_scan
_leave_skip
        add     x19, x19, #8
XLEAVE_END
        NEXT

        BOOT_WORD 2*, 2* ( x1 -- x2 ) shift left one bit, 0, XTWOSTAR, XTWOSTAR_END
XTWOSTAR
        lsl     x20, x20, #1
XTWOSTAR_END
        NEXT

        BOOT_WORD 2/, 2/ ( x1 -- x2 ) arithmetic shift right one bit, 0, XTWOSLASH, XTWOSLASH_END
XTWOSLASH
        asr     x20, x20, #1
XTWOSLASH_END
        NEXT

        BOOT_WORD L@, L@ ( addr -- u ) fetch 32 bits zero-extended, 0, XLFETCH, XLFETCH_END
XLFETCH
        ldr     w20, [x20]
XLFETCH_END
        NEXT

        BOOT_WORD L!, L! ( u addr -- ) store 32 bits, 0, XLSTORE, XLSTORE_END
XLSTORE
        ldr     x0, [x22], #8
        str     w0, [x20]
        ldr     x20, [x22], #8
XLSTORE_END
        NEXT

        BOOT_WORD (APP-OPEN), (APP-OPEN) ( cols rows -- ior ) open a character graphics window, 0, XAPP_OPEN, XAPP_OPEN_END
XAPP_OPEN
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_app_open
        ldp     x29, x30, [sp], #16
        DPUSH
XAPP_OPEN_END
        NEXT

        BOOT_WORD (OOP-CALL), (OOP-CALL) ( a b c d op -- n ) OOP window host, 0, XOOP_CALL, XOOP_CALL_END
XOOP_CALL
        mov     x4, x20
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_oop_call
        ldp     x29, x30, [sp], #16
        DPUSH
XOOP_CALL_END
        NEXT

        BOOT_WORD (APP-CLOSE), (APP-CLOSE) ( -- ) close the character graphics window, 0, XAPP_CLOSE, XAPP_CLOSE_END
XAPP_CLOSE
        stp     x29, x30, [sp, #-16]!
        bl      host_app_close
        ldp     x29, x30, [sp], #16
XAPP_CLOSE_END
        NEXT

        BOOT_WORD (APP-BLIT), (APP-BLIT) ( c-addr u -- ) blit the character buffer to the window, 0, XAPP_BLIT, XAPP_BLIT_END
XAPP_BLIT
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_app_blit
        ldp     x29, x30, [sp], #16
XAPP_BLIT_END
        NEXT

        BOOT_WORD (APP-PBLIT), (APP-PBLIT) ( c-addr u -- ) blit a 1-bit pixel map to the window, 0, XAPP_PBLIT, XAPP_PBLIT_END
XAPP_PBLIT
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_app_pblit
        ldp     x29, x30, [sp], #16
XAPP_PBLIT_END
        NEXT

        BOOT_WORD (APP-CBLIT), (APP-CBLIT) ( c-addr u depth -- ) blit pixels of depth 1 8 or 32, 0, XAPP_CBLIT, XAPP_CBLIT_END
XAPP_CBLIT
        mov     x2, x20
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_app_cblit
        ldp     x29, x30, [sp], #16
XAPP_CBLIT_END
        NEXT

        BOOT_WORD (APP-KEY?), (APP-KEY?) ( -- flag ) true when a graphics key is waiting, 0, XAPP_KEYQ, XAPP_KEYQ_END
XAPP_KEYQ
        stp     x29, x30, [sp, #-16]!
        bl      host_app_keyq
        ldp     x29, x30, [sp], #16
        DPUSH
XAPP_KEYQ_END
        NEXT

        BOOT_WORD (APP-KEY), (APP-KEY) ( -- c ) next graphics key or -1 on timeout, 0, XAPP_KEY, XAPP_KEY_END
XAPP_KEY
        stp     x29, x30, [sp, #-16]!
        bl      host_app_key
        ldp     x29, x30, [sp], #16
        DPUSH
XAPP_KEY_END
        NEXT

        BOOT_WORD (APP-NAME), (APP-NAME) ( c-addr u -- ) set the graphics window title, 0, XAPP_NAME, XAPP_NAME_END
XAPP_NAME
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_app_name
        ldp     x29, x30, [sp], #16
XAPP_NAME_END
        NEXT

        BOOT_WORD (APP-TONE), (APP-TONE) ( freq dur -- ) play a tone for dur tenths of a second, 0, XAPP_TONE, XAPP_TONE_END
XAPP_TONE
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_app_tone
        ldp     x29, x30, [sp], #16
XAPP_TONE_END
        NEXT

        BOOT_WORD (APP-PUMP), (APP-PUMP) ( -- ) yield so the graphics window can run, 0, XAPP_PUMP, XAPP_PUMP_END
XAPP_PUMP
        stp     x29, x30, [sp, #-16]!
        bl      host_app_pump
        ldp     x29, x30, [sp], #16
XAPP_PUMP_END
        NEXT

        BOOT_WORD (APP-MOUSE), (APP-MOUSE) ( -- x y buttons ) graphics mouse in plot coordinates, 0, XAPP_MOUSE, XAPP_MOUSE_END
XAPP_MOUSE
        stp     x29, x30, [sp, #-16]!
        sub     sp, sp, #32
        mov     x0, sp
        add     x1, sp, #8
        add     x2, sp, #16
        str     xzr, [sp]
        str     xzr, [sp, #8]
        str     xzr, [sp, #16]
        bl      host_app_mouse
        ldr     x0, [sp]
        ldr     x1, [sp, #8]
        ldr     x2, [sp, #16]
        add     sp, sp, #32
        ldp     x29, x30, [sp], #16
        str     x20, [x22, #-8]!
        str     x0, [x22, #-8]!
        str     x1, [x22, #-8]!
        mov     x20, x2
XAPP_MOUSE_END
        NEXT

        BOOT_WORD (APP-SIZE?), (APP-SIZE?) ( -- cols rows flag ) pending grid after a resize, 0, XAPP_SIZE, XAPP_SIZE_END
XAPP_SIZE
        stp     x29, x30, [sp, #-16]!
        sub     sp, sp, #32
        mov     x0, sp
        add     x1, sp, #8
        str     xzr, [sp]
        str     xzr, [sp, #8]
        bl      host_app_size
        ldr     x1, [sp]
        ldr     x2, [sp, #8]
        add     sp, sp, #32
        ldp     x29, x30, [sp], #16
        str     x20, [x22, #-8]!
        str     x1, [x22, #-8]!
        str     x2, [x22, #-8]!
        mov     x20, x0
XAPP_SIZE_END
        NEXT

        BOOT_WORD (APP-IMG-CHOOSE), (APP-IMG-CHOOSE) ( -- ior ) choose an image file, 0, XAPP_IMG_CHOOSE, XAPP_IMG_CHOOSE_END
XAPP_IMG_CHOOSE
        stp     x29, x30, [sp, #-16]!
        bl      host_app_img_choose
        ldp     x29, x30, [sp], #16
        DPUSH
XAPP_IMG_CHOOSE_END
        NEXT

        BOOT_WORD (APP-IMG-LOAD), (APP-IMG-LOAD) ( c-addr u -- ior ) load an image from a path, 0, XAPP_IMG_LOAD, XAPP_IMG_LOAD_END
XAPP_IMG_LOAD
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_app_img_load
        ldp     x29, x30, [sp], #16
        DPUSH
XAPP_IMG_LOAD_END
        NEXT

        BOOT_WORD (APP-IMG-SIZE), (APP-IMG-SIZE) ( -- w h ) loaded image size in pixels, 0, XAPP_IMG_SIZE, XAPP_IMG_SIZE_END
XAPP_IMG_SIZE
        stp     x29, x30, [sp, #-16]!
        sub     sp, sp, #32
        mov     x0, sp
        add     x1, sp, #8
        str     xzr, [sp]
        str     xzr, [sp, #8]
        bl      host_app_img_size
        ldr     x0, [sp]
        ldr     x1, [sp, #8]
        add     sp, sp, #32
        ldp     x29, x30, [sp], #16
        str     x20, [x22, #-8]!
        str     x0, [x22, #-8]!
        mov     x20, x1
XAPP_IMG_SIZE_END
        NEXT

        BOOT_WORD (APP-IMG-RENDER), (APP-IMG-RENDER) ( c-addr w h cx cy zoom100 -- ior ) render the image into BGRA, 0, XAPP_IMG_RENDER, XAPP_IMG_RENDER_END
XAPP_IMG_RENDER
        mov     x5, x20
        ldr     x4, [x22], #8
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_app_img_render
        ldp     x29, x30, [sp], #16
        DPUSH
XAPP_IMG_RENDER_END
        NEXT

        BOOT_WORD (APP-FILE-CHOOSE), (APP-FILE-CHOOSE) ( -- ior ) choose a file and stage its path, 0, XAPP_FILE_CHOOSE, XAPP_FILE_CHOOSE_END
XAPP_FILE_CHOOSE
        stp     x29, x30, [sp, #-16]!
        bl      host_app_file_choose
        ldp     x29, x30, [sp], #16
        DPUSH
XAPP_FILE_CHOOSE_END
        NEXT

        BOOT_WORD (APP-FILE-SAVE-AS), (APP-FILE-SAVE-AS) ( -- ior ) choose a save path and stage it, 0, XAPP_FILE_SAVE_AS, XAPP_FILE_SAVE_AS_END
XAPP_FILE_SAVE_AS
        stp     x29, x30, [sp, #-16]!
        bl      host_app_file_save_as
        ldp     x29, x30, [sp], #16
        DPUSH
XAPP_FILE_SAVE_AS_END
        NEXT

        BOOT_WORD (APP-FILE-PATH), (APP-FILE-PATH) ( c-addr u -- u2 ) copy the staged file path, 0, XAPP_FILE_PATH, XAPP_FILE_PATH_END
XAPP_FILE_PATH
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_app_file_path
        ldp     x29, x30, [sp], #16
        DPUSH
XAPP_FILE_PATH_END
        NEXT

        BOOT_WORD (APP-FILE-SLURP), (APP-FILE-SLURP) ( c-addr max -- u ior ) read the staged file, 0, XAPP_FILE_SLURP, XAPP_FILE_SLURP_END
XAPP_FILE_SLURP
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        sub     sp, sp, #16
        mov     x2, sp
        str     xzr, [sp]
        bl      host_app_file_slurp
        ldr     x1, [sp]
        add     sp, sp, #16
        ldp     x29, x30, [sp], #16
        str     x20, [x22, #-8]!
        str     x1, [x22, #-8]!
        mov     x20, x0
XAPP_FILE_SLURP_END
        NEXT

        BOOT_WORD (APP-FILE-SPEW), (APP-FILE-SPEW) ( c-addr u -- ior ) write bytes to the staged file, 0, XAPP_FILE_SPEW, XAPP_FILE_SPEW_END
XAPP_FILE_SPEW
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_app_file_spew
        ldp     x29, x30, [sp], #16
        DPUSH
XAPP_FILE_SPEW_END
        NEXT

        BOOT_WORD_SESCAPE  escaped string, FLAG_IMM, XSESCAPE, 0
XSESCAPE
        sub     sp, sp, #96
        stp     x29, x30, [sp, #32]
        bl      _cursor_load
        mov     x1, x0
        adrp    x6, source_end
        add     x6, x6, source_end
        ldr     x6, [x6]
        adrp    x8, slit_esc_which
        add     x8, x8, slit_esc_which
        ldr     x4, [x8]
        cbnz    x4, _se_buf2
        adrp    x7, slit_esc_buf
        add     x7, x7, slit_esc_buf
        mov     x4, #1
        str     x4, [x8]
        b       _se_ready
_se_buf2
        adrp    x7, slit_esc_buf2
        add     x7, x7, slit_esc_buf2
        str     xzr, [x8]
_se_ready
        mov     x5, #0
_se_loop
        cmp     x1, x6
        b.hs    _se_done
        ldrb    w2, [x1], #1
        cmp     w2, #34
        b.eq    _se_done
        cmp     w2, #92
        b.ne    _se_put
        cmp     x1, x6
        b.hs    _se_done
        ldrb    w2, [x1], #1
        cmp     w2, #'a'
        b.eq    _se_a
        cmp     w2, #'b'
        b.eq    _se_b
        cmp     w2, #'e'
        b.eq    _se_e
        cmp     w2, #'f'
        b.eq    _se_f
        cmp     w2, #'l'
        b.eq    _se_l
        cmp     w2, #'m'
        b.eq    _se_m
        cmp     w2, #'n'
        b.eq    _se_n
        cmp     w2, #'q'
        b.eq    _se_q
        cmp     w2, #'r'
        b.eq    _se_r
        cmp     w2, #'t'
        b.eq    _se_t
        cmp     w2, #'v'
        b.eq    _se_v
        cmp     w2, #'z'
        b.eq    _se_z
        cmp     w2, #34
        b.eq    _se_q
        cmp     w2, #92
        b.eq    _se_put
        cmp     w2, #'x'
        b.eq    _se_hex
        b       _se_put
_se_a
        mov     w2, #7
        b       _se_put
_se_b
        mov     w2, #8
        b       _se_put
_se_e
        mov     w2, #27
        b       _se_put
_se_f
        mov     w2, #12
        b       _se_put
_se_l
        mov     w2, #10
        b       _se_put
_se_n
        mov     w2, #10
        b       _se_put
_se_q
        mov     w2, #34
        b       _se_put
_se_r
        mov     w2, #13
        b       _se_put
_se_t
        mov     w2, #9
        b       _se_put
_se_v
        mov     w2, #11
        b       _se_put
_se_z
        mov     w2, #0
        b       _se_put
_se_m
        cmp     x5, #254
        b.hs    _se_loop
        mov     w2, #13
        strb    w2, [x7, x5]
        add     x5, x5, #1
        mov     w2, #10
        b       _se_put
_se_hex
        mov     w3, #0
        mov     x4, #2
_se_hx
        cbz     x4, _se_hexput
        cmp     x1, x6
        b.hs    _se_hexput
        ldrb    w2, [x1]
        sub     w8, w2, #'0'
        cmp     w8, #9
        b.ls    _se_hok
        sub     w8, w2, #'A'
        cmp     w8, #5
        b.ls    _se_hu
        sub     w8, w2, #'a'
        cmp     w8, #5
        b.hi    _se_hexput
_se_hu
        add     w8, w8, #10
_se_hok
        add     x1, x1, #1
        lsl     w3, w3, #4
        orr     w3, w3, w8
        sub     x4, x4, #1
        b       _se_hx
_se_hexput
        mov     w2, w3
_se_put
        cmp     x5, #255
        b.hs    _se_loop
        strb    w2, [x7, x5]
        add     x5, x5, #1
        b       _se_loop
_se_done
        stp     x7, x5, [sp, #48]
        mov     x0, x1
        bl      _cursor_commit
        ldp     x7, x5, [sp, #48]
        adrp    x0, state_var
        add     x0, x0, state_var
        ldr     x0, [x0]
        cbnz    x0, _se_comp
        str     x20, [x22, #-8]!
        str     x7, [x22, #-8]!
        mov     x20, x5
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT
_se_comp
        stp     x7, x5, [sp, #48]
        adrp    x0, cfa_slit
        add     x0, x0, cfa_slit
        ldr     x0, [x0]
        bl      _compile_cell
        ldr     x0, [sp, #56]
        bl      _compile_cell
        ldp     x7, x5, [sp, #48]
        adrp    x0, here_ptr
        add     x0, x0, here_ptr
        ldr     x1, [x0]
        mov     x3, #0
_se_cpy
        cmp     x3, x5
        b.ge    _se_align
        ldrb    w4, [x7, x3]
        strb    w4, [x1, x3]
        add     x3, x3, #1
        b       _se_cpy
_se_align
        add     x1, x1, x5
        add     x1, x1, #7
        bic     x1, x1, #7
        str     x1, [x0]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT

; WORDS lists search_order[0] only. Kernel CFAs sit below words_user_base
; (HERE at the end of the cold interpret) and are sorted. Later CFAs stay
; in load order. The Mac row has no end label, so the end field is 0.
WORDS_MAX       EQU 1024

        BOOT_WORD WORDS, WORDS ( [filter] -- ) list first search-order wordlist sorted, 0, XWORDS, 0
XWORDS
        sub     sp, sp, #112
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        stp     x21, x22, [sp, #64]
        stp     x23, x24, [sp, #80]
        stp     x25, x26, [sp, #96]
        bl      _next_word
        mov     x2, #63
        cmp     x1, x2
        csel    x1, x2, x1, hi
        adrp    x2, words_filter_len
        add     x2, x2, words_filter_len
        str     x1, [x2]
        adrp    x3, words_filter
        add     x3, x3, words_filter
        mov     x4, #0
_xw_filt
        cmp     x4, x1
        b.hs    _xw_wid
        ldrb    w5, [x0, x4]
        cmp     w5, #'a'
        b.lo    _xw_filt_st
        cmp     w5, #'z'
        b.hi    _xw_filt_st
        sub     w5, w5, #32
_xw_filt_st
        strb    w5, [x3, x4]
        add     x4, x4, #1
        b       _xw_filt
_xw_wid
        adrp    x0, search_order_n
        add     x0, x0, search_order_n
        ldr     x0, [x0]
        cbz     x0, _xw_forth
        adrp    x0, search_order
        add     x0, x0, search_order
        ldr     x19, [x0]
        b       _xw_pass1
_xw_forth
        adrp    x19, latest_var
        add     x19, x19, latest_var
_xw_pass1
        adrp    x21, words_cfa
        add     x21, x21, words_cfa
        mov     x22, #0
        mov     x25, #0
_xw_t1
        cmp     x25, #16
        b.hs    _xw_nk
        add     x0, x19, x25, lsl #3
        ldr     x20, [x0]
_xw_c1
        cbz     x20, _xw_n1
        cmp     x22, #WORDS_MAX
        b.hs    _xw_nk
        adrp    x0, words_user_base
        add     x0, x0, words_user_base
        ldr     x0, [x0]
        cbz     x0, _xw_kfilt
        cmp     x20, x0
        b.hs    _xw_link1
_xw_kfilt
        adrp    x0, words_filter_len
        add     x0, x0, words_filter_len
        ldr     x0, [x0]
        cbz     x0, _xw_keep1
        mov     x0, x20
        bl      _words_name_ptr
        bl      _words_filter_match
        cbz     x0, _xw_link1
_xw_keep1
        str     x20, [x21, x22, lsl #3]
        add     x22, x22, #1
_xw_link1
        ldr     x20, [x20, #-16]
        b       _xw_c1
_xw_n1
        add     x25, x25, #1
        b       _xw_t1
_xw_nk
        adrp    x0, words_nk_tmp
        add     x0, x0, words_nk_tmp
        str     x22, [x0]
        adrp    x0, words_user_base
        add     x0, x0, words_user_base
        ldr     x0, [x0]
        cbz     x0, _xw_rev
        mov     x25, #0
_xw_t2
        cmp     x25, #16
        b.hs    _xw_rev
        add     x0, x19, x25, lsl #3
        ldr     x20, [x0]
_xw_c2
        cbz     x20, _xw_n2
        cmp     x22, #WORDS_MAX
        b.hs    _xw_rev
        adrp    x0, words_user_base
        add     x0, x0, words_user_base
        ldr     x0, [x0]
        cmp     x20, x0
        b.lo    _xw_link2
        adrp    x0, words_filter_len
        add     x0, x0, words_filter_len
        ldr     x0, [x0]
        cbz     x0, _xw_keep2
        mov     x0, x20
        bl      _words_name_ptr
        bl      _words_filter_match
        cbz     x0, _xw_link2
_xw_keep2
        str     x20, [x21, x22, lsl #3]
        add     x22, x22, #1
_xw_link2
        ldr     x20, [x20, #-16]
        b       _xw_c2
_xw_n2
        add     x25, x25, #1
        b       _xw_t2
_xw_rev
        adrp    x0, words_nk_tmp
        add     x0, x0, words_nk_tmp
        ldr     x0, [x0]
        cmp     x22, x0
        b.ls    _xw_sort
        sub     x1, x22, #1
_xw_rev_loop
        cmp     x0, x1
        b.ge    _xw_sort
        ldr     x2, [x21, x0, lsl #3]
        ldr     x3, [x21, x1, lsl #3]
        str     x3, [x21, x0, lsl #3]
        str     x2, [x21, x1, lsl #3]
        add     x0, x0, #1
        sub     x1, x1, #1
        b       _xw_rev_loop
_xw_sort
        mov     x1, #1
_xw_sort_i
        adrp    x0, words_nk_tmp
        add     x0, x0, words_nk_tmp
        ldr     x0, [x0]
        cmp     x1, x0
        b.hs    _xw_hdr
        ldr     x2, [x21, x1, lsl #3]
        mov     x3, x1
_xw_sort_j
        cbz     x3, _xw_sort_put
        sub     x4, x3, #1
        ldr     x5, [x21, x4, lsl #3]
        stp     x1, x2, [sp, #-16]!
        stp     x3, x4, [sp, #-16]!
        mov     x0, x5
        mov     x1, x2
        bl      _words_cfa_cmp
        ldp     x3, x4, [sp], #16
        ldp     x1, x2, [sp], #16
        cmp     x0, #0
        b.le    _xw_sort_put
        ldr     x5, [x21, x4, lsl #3]
        str     x5, [x21, x3, lsl #3]
        mov     x3, x4
        b       _xw_sort_j
_xw_sort_put
        str     x2, [x21, x3, lsl #3]
        add     x1, x1, #1
        b       _xw_sort_i
_xw_hdr
        mov     x0, #10
        bl      _putchar
        adrp    x0, str_words_hdr1
        add     x0, x0, str_words_hdr1
        bl      emit_cstr
        mov     x0, x19
        bl      _print_wid_name
        mov     x0, #32
        bl      _putchar
        mov     x0, #'('
        bl      _putchar
        mov     x0, x22
        bl      _print_unsigned
        mov     x0, #')'
        bl      _putchar
        adrp    x0, str_words_hdr2
        add     x0, x0, str_words_hdr2
        bl      emit_cstr
        mov     x0, #10
        bl      _putchar
        adrp    x0, words_nk_tmp
        add     x0, x0, words_nk_tmp
        ldr     x0, [x0]
        cbz     x0, _xw_user
        adrp    x0, str_words_sys
        add     x0, x0, str_words_sys
        bl      emit_cstr
        mov     x23, #0
        mov     x24, #0
_xw_sys_i
        adrp    x0, words_nk_tmp
        add     x0, x0, words_nk_tmp
        ldr     x0, [x0]
        cmp     x23, x0
        b.hs    _xw_sys_nl
        ldr     x0, [x21, x23, lsl #3]
        bl      _words_name_ptr
        cbz     x1, _xw_sys_sp
        stp     x23, x24, [sp, #-16]!
        bl      emit_str
        ldp     x23, x24, [sp], #16
_xw_sys_sp
        mov     x0, #32
        bl      _putchar
        add     x24, x24, #1
        cmp     x24, #8
        b.lo    _xw_sys_next
        mov     x0, #10
        bl      _putchar
        mov     x24, #0
_xw_sys_next
        add     x23, x23, #1
        b       _xw_sys_i
_xw_sys_nl
        cbz     x24, _xw_user
        mov     x0, #10
        bl      _putchar
_xw_user
        adrp    x0, words_nk_tmp
        add     x0, x0, words_nk_tmp
        ldr     x0, [x0]
        cmp     x22, x0
        b.ls    _xw_done
        adrp    x0, str_words_user
        add     x0, x0, str_words_user
        bl      emit_cstr
        adrp    x0, words_nk_tmp
        add     x0, x0, words_nk_tmp
        ldr     x23, [x0]
        mov     x24, #0
_xw_user_i
        cmp     x23, x22
        b.hs    _xw_user_nl
        ldr     x0, [x21, x23, lsl #3]
        bl      _words_name_ptr
        cbz     x1, _xw_user_sp
        stp     x23, x24, [sp, #-16]!
        bl      emit_str
        ldp     x23, x24, [sp], #16
_xw_user_sp
        mov     x0, #32
        bl      _putchar
        add     x24, x24, #1
        cmp     x24, #8
        b.lo    _xw_user_next
        mov     x0, #10
        bl      _putchar
        mov     x24, #0
_xw_user_next
        add     x23, x23, #1
        b       _xw_user_i
_xw_user_nl
        cbz     x24, _xw_done
        mov     x0, #10
        bl      _putchar
_xw_done
        ldp     x25, x26, [sp, #96]
        ldp     x23, x24, [sp, #80]
        ldp     x21, x22, [sp, #64]
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #112
        NEXT

; First completed interpret is the cold blob. Later finishes leave the fence.
_record_words_user_base_once
        adrp    x0, words_user_base
        add     x0, x0, words_user_base
        ldr     x1, [x0]
        cbnz    x1, _rec_done
        adrp    x1, here_ptr
        add     x1, x1, here_ptr
        ldr     x1, [x1]
        str     x1, [x0]
_rec_done
        ret

; x0=CFA -> x0=name chars, x1=len. Smudged or empty returns x1=0.
_words_name_ptr
        ldr     x1, [x0, #-8]
        and     x1, x1, #0xFFFF
        sub     x0, x0, x1
        ldrb    w1, [x0], #1
        tst     w1, #0x80
        b.eq    _wnp_len
        mov     x1, #0
        ret
_wnp_len
        and     w1, w1, #0x7F
        ret

; x0=cfaA, x1=cfaB -> x0 sign of the case-folded name compare.
; Equal prefix: the shorter name is first.
_words_cfa_cmp
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        stp     x21, x22, [sp, #64]
        mov     x19, x0
        mov     x20, x1
        bl      _words_name_ptr
        mov     x21, x0
        mov     x22, x1
        mov     x0, x20
        bl      _words_name_ptr
        mov     x2, x22
        cmp     x2, x1
        csel    x2, x1, x2, hi
        mov     x3, #0
_wcmp_ch
        cmp     x3, x2
        b.hs    _wcmp_len
        ldrb    w4, [x21, x3]
        ldrb    w5, [x0, x3]
        cmp     w4, #'a'
        b.lo    _wcmp_b
        cmp     w4, #'z'
        b.hi    _wcmp_b
        sub     w4, w4, #32
_wcmp_b
        cmp     w5, #'a'
        b.lo    _wcmp_eq
        cmp     w5, #'z'
        b.hi    _wcmp_eq
        sub     w5, w5, #32
_wcmp_eq
        cmp     w4, w5
        b.ne    _wcmp_diff
        add     x3, x3, #1
        b       _wcmp_ch
_wcmp_len
        cmp     x22, x1
        b.eq    _wcmp_zero
        mov     x0, #1
        b.hs    _wcmp_out
        mov     x0, #-1
        b       _wcmp_out
_wcmp_diff
        mov     x0, #1
        cmp     w4, w5
        b.hs    _wcmp_out
        mov     x0, #-1
        b       _wcmp_out
_wcmp_zero
        mov     x0, #0
_wcmp_out
        ldp     x21, x22, [sp, #64]
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        ret

; x0=name chars, x1=name len. x0=1 when the filter is empty or a substring.
_words_filter_match
        adrp    x2, words_filter_len
        add     x2, x2, words_filter_len
        ldr     x2, [x2]
        cbz     x2, _wfm_yes
        adrp    x3, words_filter
        add     x3, x3, words_filter
        mov     x4, #0
_wfm_start
        add     x5, x4, x2
        cmp     x5, x1
        b.hi    _wfm_no
        mov     x6, #0
_wfm_i
        cmp     x6, x2
        b.hs    _wfm_yes
        add     x7, x4, x6
        ldrb    w8, [x0, x7]
        cmp     w8, #'a'
        b.lo    _wfm_cmp
        cmp     w8, #'z'
        b.hi    _wfm_cmp
        sub     w8, w8, #32
_wfm_cmp
        ldrb    w9, [x3, x6]
        cmp     w8, w9
        b.ne    _wfm_next
        add     x6, x6, #1
        b       _wfm_i
_wfm_next
        add     x4, x4, #1
        b       _wfm_start
_wfm_no
        mov     x0, #0
        ret
_wfm_yes
        mov     x0, #1
        ret

; x0=wid. Prints FORTH, the VOCABULARY whose body is that wid, or wid.
_print_wid_name
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        stp     x21, x22, [sp, #64]
        mov     x19, x0
        adrp    x1, latest_var
        add     x1, x1, latest_var
        cmp     x19, x1
        b.ne    _pwn_scan
        adrp    x0, str_forth_name
        add     x0, x0, str_forth_name
        bl      emit_cstr
        b       _pwn_done
_pwn_scan
        adrp    x22, DODOES
        add     x22, x22, DODOES
        mov     x20, #0
_pwn_thread
        cmp     x20, #16
        b.hs    _pwn_anon
        adrp    x0, latest_var
        add     x0, x0, latest_var
        add     x0, x0, x20, lsl #3
        ldr     x21, [x0]
_pwn_cfa
        cbz     x21, _pwn_next_th
        ldr     x0, [x21]
        cmp     x0, x22
        b.ne    _pwn_link
        add     x0, x21, #16
        cmp     x0, x19
        b.ne    _pwn_link
        ldr     x0, [x21, #-8]
        and     x0, x0, #0xFFFF
        sub     x0, x21, x0
        ldrb    w1, [x0], #1
        and     w1, w1, #0x7F
        mov     x20, x0
        mov     x21, x1
        mov     x22, #0
_pwn_ch
        cmp     x22, x21
        b.hs    _pwn_done
        ldrb    w0, [x20, x22]
        bl      _putchar
        add     x22, x22, #1
        b       _pwn_ch
_pwn_link
        ldr     x21, [x21, #-16]
        b       _pwn_cfa
_pwn_next_th
        add     x20, x20, #1
        b       _pwn_thread
_pwn_anon
        adrp    x0, str_wid
        add     x0, x0, str_wid
        bl      emit_cstr
_pwn_done
        ldp     x21, x22, [sp, #64]
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        ret

next_debug_gate
        adrp    x16, next_debug
        add     x16, x16, next_debug
        br      x16

        AREA |.rdata|, DATA, READONLY, ALIGN=3

str_forth_name  DCB "FORTH", 0
str_wid         DCB "wid", 0
str_words_hdr1  DCB "--- ", 0
str_words_hdr2  DCB " ---", 0
str_words_sys   DCB "EditForthWin System Words", 10, 0
str_words_user  DCB "EditForthWin User Words", 10, 0

        END
