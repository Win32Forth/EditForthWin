; Primitives kernel2.fth compiles and runs. Labels match the Mac kernel.
; An end argument of 0 means the Mac catalog has no end label.
; File, block, debug, and float words are present so the file can compile.
; OPEN-FILE and the other file words bl _file_op_call in (SA-FILES).
; REFILL returns false
; on EVALUATE. In (LINE-SOURCE) it advances to the next line. When BLK is
; set, backslash ends at the next 64-character boundary and REFILL loads
; the following block.

        INCLUDE Forth/kernel/arm64/vm.inc

        EXTERN next_debug
        EXTERN debug_break_asap
        INCLUDE Forth/kernel/arm64/boot_words.inc

        AREA |.text|, CODE, READONLY, ALIGN=4

        EXTERN data_stack
        EXTERN here_ptr
        EXTERN state_var
        EXTERN last_cfa
        EXTERN base_var
        EXTERN search_order
        EXTERN search_order_n
        EXTERN latest_var
        EXTERN user_dict_area
        EXTERN user_dict_size_cell
        EXTERN grow_memory_used
        EXTERN wordlist_reg
        EXTERN wordlist_reg_n
        EXTERN source_base
        EXTERN source_cur
        EXTERN source_end
        EXTERN to_in
        EXTERN pad_buffer
        EXTERN redef_warn
        EXTERN block_file
        EXTERN block_upd
        EXTERN block_nr
        EXTERN block_buf
        EXTERN scr_var
        EXTERN cfa_lit
        EXTERN cfa_exit
        EXTERN cfa_slit
        EXTERN cfa_flit
        EXTERN throw_handler
        EXTERN catch_ok_cell
        EXTERN tw_continue_cell
        EXTERN bootptr_start
        EXTERN bootptr_end
        EXTERN key_fn
        EXTERN _getchar
        EXTERN debug_busy
        EXTERN _next_word
        EXTERN _find_word
        EXTERN _compile_cell
        EXTERN _local_lookup
        EXTERN _local_compile_reset
        EXTERN _local_add_name
        EXTERN _local_finalize_compile
        EXTERN cfa_local_store
        EXTERN local_declaring
        EXTERN local_init_count
        EXTERN local_init_reverse
        EXTERN _cursor_load
        EXTERN _cursor_commit
        EXTERN _putchar
        EXTERN _print_unsigned
        EXTERN _sa_putchar
        EXTERN _sa_print_unsigned
        EXTERN emit_cstr
        EXTERN emit_str
        EXTERN XTYPE
        EXTERN host_ms
        EXTERN _file_op_call
        EXTERN host_read
        EXTERN host_repos
        EXTERN host_alloc
        EXTERN host_free
        EXTERN host_resolve
        EXTERN host_begin_load
        EXTERN host_end_load
        EXTERN host_register
        EXTERN host_was_included
        EXTERN host_accept
        EXTERN host_resize
        EXTERN host_sleep
        EXTERN host_time_date
        EXTERN host_chdir
        EXTERN host_edit
        EXTERN host_edit_at
        EXTERN host_system
        EXTERN host_fromlib
        EXTERN host_fromlib_off
        EXTERN host_fromlib_query
        EXTERN facility_op_hook
        EXTERN host_facility_xy
        EXTERN host_clip_set
        EXTERN host_clip_get
        EXTERN file_echo
        EXTERN host_library_path
        EXTERN library_path_buf
        EXTERN cfa_execute
        EXTERN cfa_comma
        EXTERN XROLL
        EXTERN host_bi_mul
        EXTERN host_bi_divmod
        EXTERN host_bi_isqrt
        EXTERN host_pwd
        EXTERN host_cwd
        EXTERN host_dir
        EXTERN host_last_included
        EXTERN host_dot_included
        EXTERN _float_op_call
        EXTERN host_include_dialog
        EXTERN host_alloc_exec
        EXTERN host_free_exec
        EXTERN host_mprotect
        EXTERN host_icache_inval
        EXTERN host_native_ret7
        EXTERN native_dsp_end
        EXTERN jit_exec_mode
        EXTERN current_var
        EXTERN words_user_base
        EXTERN blk_var
        EXTERN forget_cut
        EXTERN _quit_exit
        EXTERN _do_quit
        EXTERN _interpret_loop
        EXTERN _interpret_empty
        EXTERN _push_source
        EXTERN _arm_lines
        EXTERN _eval_resume_push
        EXTERN _take_line
        EXTERN line_mode
        EXTERN line_limit
        EXTERN line_next
        EXTERN source_id
        EXTERN source_sp
        EXTERN eval_resume_sp
        EXTERN resolve_buf
        EXTERN include_name_pending
        EXTERN include_name_len
        EXTERN _view_push_src_id
        EXTERN _view_set_src_from_pending
        EXTERN msg_allot
        EXTERN msg_huh

        EXPORT XCATCH
        EXPORT XCATCH_OK
        EXPORT XTW_CONTINUE
        EXPORT XEXECUTE
        EXPORT _udivmod128

; ---------------------------------------------------------------------
; Stack, logic, compare
; ---------------------------------------------------------------------

        BOOT_WORD TUCK, TUCK ( x1 x2 -- x2 x1 x2 ) copy TOS under the second, 0, XTUCK, XTUCK_END
XTUCK
        ldr     x0, [x22]
        str     x20, [x22]
        str     x0, [x22, #-8]!
XTUCK_END
        NEXT

        BOOT_WORD PICK, PICK ( xu ... x0 u -- xu ... x0 xu ) copy the uth cell, 0, XPICK, XPICK_END
XPICK
        lsl     x0, x20, #3
        ldr     x0, [x22, x0]
        mov     x20, x0
XPICK_END
        NEXT

        BOOT_WORD 2>R, 2>R ( n1 n2 -- ) two to the return stack, 0, X2TOR, X2TOR_END
X2TOR
        ldr     x0, [x22], #8
        str     x0, [x23, #-8]!
        str     x20, [x23, #-8]!
        ldr     x20, [x22], #8
X2TOR_END
        NEXT

        BOOT_WORD 2R>, 2R> ( -- n1 n2 ) two from the return stack, 0, X2RTO, X2RTO_END
X2RTO
        str     x20, [x22, #-8]!
        ldr     x0, [x23], #8
        ldr     x1, [x23], #8
        str     x1, [x22, #-8]!
        mov     x20, x0
X2RTO_END
        NEXT

        BOOT_WORD 2R@, 2R@ ( -- n1 n2 ) copy two from the return stack, 0, X2RFETCH, X2RFETCH_END
X2RFETCH
        str     x20, [x22, #-8]!
        ldr     x0, [x23]
        ldr     x1, [x23, #8]
        str     x1, [x22, #-8]!
        mov     x20, x0
X2RFETCH_END
        NEXT

        BOOT_WORD 2ROT, 2ROT ( x1 x2 x3 x4 x5 x6 -- x3 x4 x5 x6 x1 x2 ) rotate three pairs, 0, XTWOROT, XTWOROT_END
XTWOROT
        ldr     x5, [x22], #8
        ldr     x4, [x22], #8
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        str     x3, [x22, #-8]!
        str     x4, [x22, #-8]!
        str     x5, [x22, #-8]!
        str     x20, [x22, #-8]!
        str     x1, [x22, #-8]!
        mov     x20, x2
XTWOROT_END
        NEXT

        BOOT_WORD 1-, 1- ( n -- n-1 ) decrement, 0, XONEMINUS, XONEMINUS_END
XONEMINUS
        sub     x20, x20, #1
XONEMINUS_END
        NEXT

        BOOT_WORD NEGATE, NEGATE ( n -- -n ) negate, 0, XNEGATE, XNEGATE_END
XNEGATE
        neg     x20, x20
XNEGATE_END
        NEXT

        BOOT_WORD ABS, ABS ( n -- u ) absolute value, 0, XABS, XABS_END
XABS
        cmp     x20, #0
        csneg   x20, x20, x20, ge
XABS_END
        NEXT

        BOOT_WORD MIN, MIN ( n1 n2 -- min ) minimum, 0, XMIN, XMIN_END
XMIN
        ldr     x0, [x22], #8
        cmp     x0, x20
        csel    x20, x0, x20, lt
XMIN_END
        NEXT

        BOOT_WORD MAX, MAX ( n1 n2 -- max ) maximum, 0, XMAX, XMAX_END
XMAX
        ldr     x0, [x22], #8
        cmp     x0, x20
        csel    x20, x0, x20, gt
XMAX_END
        NEXT

        BOOT_WORD XOR, XOR ( n1 n2 -- n ) bitwise xor, 0, XXOR, XXOR_END
XXOR
        ldr     x0, [x22], #8
        eor     x20, x20, x0
XXOR_END
        NEXT

        BOOT_WORD LSHIFT, LSHIFT ( n bits -- n ) logical left shift, 0, XLSHIFT, XLSHIFT_END
XLSHIFT
        ldr     x0, [x22], #8
        lsl     x20, x0, x20
XLSHIFT_END
        NEXT

        BOOT_WORD <>, <> ( n1 n2 -- flag ) not equal, 0, XNEQUAL, XNEQUAL_END
XNEQUAL
        ldr     x0, [x22], #8
        cmp     x0, x20
        csetm   x20, ne
XNEQUAL_END
        NEXT

        BOOT_WORD U<, U< ( u1 u2 -- flag ) unsigned less, 0, XULESS, XULESS_END
XULESS
        ldr     x0, [x22], #8
        cmp     x0, x20
        csetm   x20, lo
XULESS_END
        NEXT

        BOOT_WORD U>, U> ( u1 u2 -- flag ) unsigned greater, 0, XUGREATER, XUGREATER_END
XUGREATER
        ldr     x0, [x22], #8
        cmp     x0, x20
        csetm   x20, hi
XUGREATER_END
        NEXT

        BOOT_WORD 0<, 0< ( n -- flag ) negative?, 0, XZLESS, XZLESS_END
XZLESS
        cmp     x20, #0
        csetm   x20, lt
XZLESS_END
        NEXT

        BOOT_WORD 0<>, 0<> ( x -- flag ) not zero?, 0, XZNOTEQUAL, XZNOTEQUAL_END
XZNOTEQUAL
        cmp     x20, #0
        csetm   x20, ne
XZNOTEQUAL_END
        NEXT

        BOOT_WORD 0>, 0> ( n -- flag ) positive?, 0, XZGREATER, XZGREATER_END
XZGREATER
        cmp     x20, #0
        csetm   x20, gt
XZGREATER_END
        NEXT

        BOOT_WORD WITHIN, WITHIN ( n1 n2 n3 -- flag ) n2 <= n1 < n3 with unsigned wrap, 0, XWITHIN, XWITHIN_END
XWITHIN
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        sub     x1, x1, x2
        sub     x20, x20, x2
        cmp     x1, x20
        csetm   x20, lo
XWITHIN_END
        NEXT

        BOOT_WORD TRUE, TRUE ( -- -1 ) true flag, 0, XTRUE, XTRUE_END
XTRUE
        str     x20, [x22, #-8]!
        mov     x20, #-1
XTRUE_END
        NEXT

        BOOT_WORD FALSE, FALSE ( -- 0 ) false flag, 0, XFALSE, XFALSE_END
XFALSE
        str     x20, [x22, #-8]!
        mov     x20, #0
XFALSE_END
        NEXT

; ---------------------------------------------------------------------
; Memory, pictured scratch, dictionary space
; ---------------------------------------------------------------------

        BOOT_WORD +!, +! ( n addr -- ) add to memory, 0, XPLUSSTORE, XPLUSSTORE_END
XPLUSSTORE
        ldr     x0, [x22], #8
        ldr     x1, [x20]
        add     x1, x1, x0
        str     x1, [x20]
        ldr     x20, [x22], #8
XPLUSSTORE_END
        NEXT

        BOOT_WORD PAD, PAD ( -- addr ) transient scratch of 1024 bytes, 0, XPAD, XPAD_END
XPAD
        str     x20, [x22, #-8]!
        adrp    x0, pad_buffer
        add     x0, x0, pad_buffer
        mov     x20, x0
XPAD_END
        NEXT

        BOOT_WORD UNUSED, UNUSED ( -- u ) bytes from HERE to the dictionary end, 0, XUNUSED, XUNUSED_END
XUNUSED
        adrp    x0, here_ptr
        add     x0, x0, here_ptr
        ldr     x1, [x0]
        adrp    x0, user_dict_area
        add     x0, x0, user_dict_area
        adrp    x2, user_dict_size_cell
        add     x2, x2, user_dict_size_cell
        ldr     x2, [x2]
        add     x0, x0, x2
        subs    x0, x0, x1
        b.hs    _unused_ok
        mov     x0, #0
_unused_ok
        str     x20, [x22, #-8]!
        mov     x20, x0
XUNUSED_END
        NEXT

        BOOT_WORD USER-DICT, USER-DICT ( -- addr ) base of user dictionary, 0, XUSER_DICT, 0
XUSER_DICT
        str     x20, [x22, #-8]!
        adrp    x0, user_dict_area
        add     x0, x0, user_dict_area
        mov     x20, x0
        NEXT

; Once per session. No shrink. 1 MiB through 256 MiB. The base stays put.
        BOOT_WORD GROWMEMORYMB, GROWMEMORYMB ( n -- ) grow user dictionary to n MiB once per session with no shrink and a max of 256, 0, XGROWMEMORYMB, 0
XGROWMEMORYMB
        mov     x0, x20
        ldr     x20, [x22], #8
        adrp    x1, grow_memory_used
        add     x1, x1, grow_memory_used
        ldr     x2, [x1]
        cbnz    x2, _gmm_already
        cmp     x0, #1
        b.lt    _gmm_small
        cmp     x0, #256
        b.hi    _gmm_big
        lsl     x3, x0, #20
        adrp    x4, user_dict_size_cell
        add     x4, x4, user_dict_size_cell
        ldr     x5, [x4]
        cmp     x3, x5
        b.ls    _gmm_shrink
        str     x3, [x4]
        mov     x2, #1
        str     x2, [x1]
        NEXT
_gmm_already
        adrp    x0, str_gmm_already
        add     x0, x0, str_gmm_already
        b       _gmm_fail
_gmm_small
        adrp    x0, str_gmm_small
        add     x0, x0, str_gmm_small
        b       _gmm_fail
_gmm_big
        adrp    x0, str_gmm_big
        add     x0, x0, str_gmm_big
        b       _gmm_fail
_gmm_shrink
        adrp    x0, str_gmm_shrink
        add     x0, x0, str_gmm_shrink
_gmm_fail
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      emit_cstr
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        b       _quit_exit

        BOOT_WORD_CCOMMA  ( b -- ) compile a byte, 0, XCCOMMA, 0
XCCOMMA
        mov     w0, w20
        ldr     x20, [x22], #8
        adrp    x1, here_ptr
        add     x1, x1, here_ptr
        ldr     x2, [x1]
        add     x3, x2, #1
        adrp    x4, user_dict_area
        add     x4, x4, user_dict_area
        cmp     x3, x4
        b.lo    _ccomma_fail
        adrp    x5, user_dict_size_cell
        add     x5, x5, user_dict_size_cell
        ldr     x5, [x5]
        add     x5, x4, x5
        cmp     x3, x5
        b.hi    _ccomma_fail
        strb    w0, [x2]
        str     x3, [x1]
        NEXT
_ccomma_fail
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        adrp    x0, msg_allot
        add     x0, x0, msg_allot
        bl      emit_cstr
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        b       _quit_exit

        BOOT_WORD 2@, 2@ ( addr -- n1 n2 ) fetch two cells, 0, XTWOFETCH, XTWOFETCH_END
XTWOFETCH
        mov     x0, x20
        ldr     x1, [x0, #8]
        ldr     x20, [x0]
        str     x1, [x22, #-8]!
XTWOFETCH_END
        NEXT

        BOOT_WORD 2!, 2! ( n1 n2 addr -- ) store two cells, 0, XTWOSTORE, XTWOSTORE_END
XTWOSTORE
        mov     x0, x20
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        ldr     x20, [x22], #8
        str     x2, [x0]
        str     x1, [x0, #8]
XTWOSTORE_END
        NEXT

; ---------------------------------------------------------------------
; Loops
; ---------------------------------------------------------------------

        BOOT_WORD I, I ( -- n ) current DO loop index, 0, XI, XI_END
XI
        str     x20, [x22, #-8]!
        ldr     x20, [x23]
XI_END
        NEXT

        BOOT_WORD J, J ( -- n ) outer DO loop index, 0, XJ, XJ_END
XJ
        str     x20, [x22, #-8]!
        ldr     x20, [x23, #16]
XJ_END
        NEXT

        BOOT_WORD UNLOOP, UNLOOP ( -- ) discard the current DO loop, 0, XUNLOOP, XUNLOOP_END
XUNLOOP
        add     x23, x23, #16
XUNLOOP_END
        NEXT

; ---------------------------------------------------------------------
; Arithmetic, doubles, pictured divide
; ---------------------------------------------------------------------

        BOOT_WORD /MOD, /MOD ( n1 n2 -- rem quot ) remainder and quotient, 0, XSLMOD, XSLMOD_END
XSLMOD
        ldr     x0, [x22], #8
        sdiv    x1, x0, x20
        msub    x2, x1, x20, x0
        str     x2, [x22, #-8]!
        mov     x20, x1
XSLMOD_END
        NEXT

        BOOT_WORD UM*, UM* ( u1 u2 -- ud ) unsigned double multiply, 0, XUMSTAR, XUMSTAR_END
XUMSTAR
        mov     x1, x20
        ldr     x0, [x22], #8
        mul     x2, x0, x1
        umulh   x20, x0, x1
        str     x2, [x22, #-8]!
XUMSTAR_END
        NEXT

        BOOT_WORD M*, M* ( n1 n2 -- d ) signed double multiply, 0, XMSTAR, XMSTAR_END
XMSTAR
        mov     x1, x20
        ldr     x0, [x22], #8
        mul     x2, x0, x1
        smulh   x20, x0, x1
        str     x2, [x22, #-8]!
XMSTAR_END
        NEXT

        BOOT_WORD D+, D+ ( d1 d2 -- d3 ) double add, 0, XDPLUS, XDPLUS_END
XDPLUS
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        adds    x1, x1, x3
        adc     x20, x2, x20
        str     x1, [x22, #-8]!
XDPLUS_END
        NEXT

        BOOT_WORD DNEGATE, DNEGATE ( d1 -- d2 ) negate a double, 0, XDNEGATE, XDNEGATE_END
XDNEGATE
        ldr     x1, [x22]
        mov     x0, xzr
        subs    x1, x0, x1
        sbc     x20, x0, x20
        str     x1, [x22]
XDNEGATE_END
        NEXT

        BOOT_WORD DABS, DABS ( d -- ud ) absolute value of a double, 0, XDABS, XDABS_END
XDABS
        tbnz    x20, #63, _dabs_neg
        NEXT
_dabs_neg
        ldr     x1, [x22]
        mov     x0, xzr
        subs    x1, x0, x1
        sbc     x20, x0, x20
        str     x1, [x22]
XDABS_END
        NEXT

        BOOT_WORD D0<, D0< ( d -- flag ) double negative?, 0, XD0LESS, XD0LESS_END
XD0LESS
        cmp     x20, #0
        csetm   x20, lt
        add     x22, x22, #8
XD0LESS_END
        NEXT

        BOOT_WORD S>D, S>D ( n -- d ) sign extend single to double, 0, XSTOD, XSTOD_END
XSTOD
        str     x20, [x22, #-8]!
        asr     x20, x20, #63
XSTOD_END
        NEXT

        BOOT_WORD D-, D- ( d1 d2 -- d3 ) double subtract, 0, XDMINUS, XDMINUS_END
XDMINUS
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        subs    x1, x1, x3
        sbc     x20, x2, x20
        str     x1, [x22, #-8]!
XDMINUS_END
        NEXT

        BOOT_WORD D2*, D2* ( xd1 -- xd2 ) shift double left 1, 0, XD2STAR, XD2STAR_END
XD2STAR
        ldr     x1, [x22]
        lsl     x20, x20, #1
        orr     x20, x20, x1, lsr #63
        lsl     x1, x1, #1
        str     x1, [x22]
XD2STAR_END
        NEXT

        BOOT_WORD D2/, D2/ ( xd1 -- xd2 ) arithmetic shift double right 1, 0, XD2SLASH, XD2SLASH_END
XD2SLASH
        ldr     x1, [x22]
        extr    x1, x20, x1, #1
        asr     x20, x20, #1
        str     x1, [x22]
XD2SLASH_END
        NEXT

        BOOT_WORD D0=, D0= ( xd -- flag ) double equal zero?, 0, XD0EQUAL, XD0EQUAL_END
XD0EQUAL
        ldr     x1, [x22], #8
        orr     x1, x1, x20
        cmp     x1, #0
        csetm   x20, eq
XD0EQUAL_END
        NEXT

        BOOT_WORD D=, D= ( xd1 xd2 -- flag ) double equal?, 0, XDEQUAL, XDEQUAL_END
XDEQUAL
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        cmp     x1, x3
        ccmp    x2, x20, #0, eq
        csetm   x20, eq
XDEQUAL_END
        NEXT

        BOOT_WORD D<, D< ( d1 d2 -- flag ) signed double less, 0, XDLESS, XDLESS_END
XDLESS
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        cmp     x2, x20
        b.lt    _dless_yes
        b.gt    _dless_no
        cmp     x1, x3
        csetm   x20, lo
        NEXT
_dless_yes
        mov     x20, #-1
        NEXT
_dless_no
        mov     x20, #0
XDLESS_END
        NEXT

        BOOT_WORD DU<, DU< ( ud1 ud2 -- flag ) unsigned double less, 0, XDULESS, XDULESS_END
XDULESS
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        cmp     x2, x20
        b.lo    _duless_yes
        b.hi    _duless_no
        cmp     x1, x3
        csetm   x20, lo
        NEXT
_duless_yes
        mov     x20, #-1
        NEXT
_duless_no
        mov     x20, #0
XDULESS_END
        NEXT

        BOOT_WORD DMIN, DMIN ( d1 d2 -- d3 ) minimum of two doubles, 0, XDMIN, XDMIN_END
XDMIN
        ldr     x3, [x22]
        ldr     x2, [x22, #8]
        ldr     x1, [x22, #16]
        cmp     x2, x20
        b.lt    _dmin_d1
        b.gt    _dmin_d2
        cmp     x1, x3
        b.ls    _dmin_d1
_dmin_d2
        str     x3, [x22, #16]
        add     x22, x22, #16
        NEXT
_dmin_d1
        mov     x20, x2
        add     x22, x22, #16
XDMIN_END
        NEXT

        BOOT_WORD DMAX, DMAX ( d1 d2 -- d3 ) maximum of two doubles, 0, XDMAX, XDMAX_END
XDMAX
        ldr     x3, [x22]
        ldr     x2, [x22, #8]
        ldr     x1, [x22, #16]
        cmp     x2, x20
        b.gt    _dmax_d1
        b.lt    _dmax_d2
        cmp     x1, x3
        b.hs    _dmax_d1
_dmax_d2
        str     x3, [x22, #16]
        add     x22, x22, #16
        NEXT
_dmax_d1
        mov     x20, x2
        add     x22, x22, #16
XDMAX_END
        NEXT

        BOOT_WORD D>S, D>S ( d -- n ) double to single, 0, XDTOS, XDTOS_END
XDTOS
        ldr     x20, [x22], #8
XDTOS_END
        NEXT

        BOOT_WORD M+, M+ ( d1 n -- d2 ) add single to double, 0, XMPLUS, XMPLUS_END
XMPLUS
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        asr     x3, x20, #63
        adds    x1, x1, x20
        adc     x20, x2, x3
        str     x1, [x22, #-8]!
XMPLUS_END
        NEXT

; x0=ulo, x1=uhi, x2=divisor. Returns x3=quot, x4=rem. 128-bit restoring divide.
_udivmod128
        cbz     x2, _udm_bad
        cmp     x1, x2
        b.hs    _udm_bad
        mov     x3, xzr
        mov     x4, xzr
        mov     x5, #128
_udm_bit
        sub     x5, x5, #1
        cmp     x5, #64
        b.hs    _udm_hi
        lsr     x6, x0, x5
        b       _udm_got
_udm_hi
        sub     x7, x5, #64
        lsr     x6, x1, x7
_udm_got
        and     x6, x6, #1
        lsr     x7, x4, #63
        lsl     x4, x4, #1
        orr     x4, x4, x6
        lsl     x3, x3, #1
        cbnz    x7, _udm_sub
        cmp     x4, x2
        b.lo    _udm_next
_udm_sub
        sub     x4, x4, x2
        orr     x3, x3, #1
_udm_next
        cbnz    x5, _udm_bit
        ret
_udm_bad
        mov     x3, #-1
        mov     x4, x0
        ret

        BOOT_WORD UM/MOD, UM/MOD ( ud u -- rem quot ) unsigned divmod, 0, XUMMOD, XUMMOD_END
XUMMOD
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x2, x20
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        bl      _udivmod128
        str     x4, [x22, #-8]!
        mov     x20, x3
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XUMMOD_END
        NEXT

        BOOT_WORD SM/REM, SM/REM ( d n -- rem quot ) symmetric divmod, 0, XSMREM, XSMREM_END
XSMREM
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x5, x20
        ldr     x4, [x22], #8
        ldr     x3, [x22], #8
        cmp     x4, #0
        cset    x6, lt
        cmp     x5, #0
        cset    x7, lt
        stp     x6, x7, [sp, #-16]!
        mov     x0, x3
        mov     x1, x4
        cbz     x6, _sm_absd
        mvn     x0, x0
        mvn     x1, x1
        adds    x0, x0, #1
        adc     x1, x1, xzr
_sm_absd
        mov     x2, x5
        cbz     x7, _sm_absn
        neg     x2, x2
_sm_absn
        cbz     x2, _sm_div0
        bl      _udivmod128
        ldp     x6, x7, [sp], #16
        cbz     x6, _sm_quotsign
        neg     x4, x4
_sm_quotsign
        eor     x8, x6, x7
        cbz     x8, _sm_push
        neg     x3, x3
_sm_push
        str     x4, [x22, #-8]!
        mov     x20, x3
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT
_sm_div0
        add     sp, sp, #16
        str     xzr, [x22, #-8]!
        mov     x20, #-1
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XSMREM_END
        NEXT

        BOOT_WORD FM/MOD, FM/MOD ( d n -- rem quot ) floored divmod, 0, XFMMOD, XFMMOD_END
XFMMOD
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        mov     x5, x20
        ldr     x4, [x22], #8
        ldr     x3, [x22], #8
        cmp     x4, #0
        cset    x6, lt
        cmp     x5, #0
        cset    x7, lt
        stp     x6, x7, [sp, #48]
        str     x5, [sp, #64]
        mov     x0, x3
        mov     x1, x4
        cbz     x6, _fm_absd
        mvn     x0, x0
        mvn     x1, x1
        adds    x0, x0, #1
        adc     x1, x1, xzr
_fm_absd
        mov     x2, x5
        cbz     x7, _fm_absn
        neg     x2, x2
_fm_absn
        cbz     x2, _fm_div0
        bl      _udivmod128
        ldp     x6, x7, [sp, #48]
        ldr     x5, [sp, #64]
        cbz     x6, _fm_remsign
        neg     x4, x4
_fm_remsign
        eor     x8, x6, x7
        cbz     x8, _fm_floor
        neg     x3, x3
_fm_floor
        cbz     x4, _fm_push
        eor     x8, x4, x5
        tbz     x8, #63, _fm_push
        sub     x3, x3, #1
        add     x4, x4, x5
_fm_push
        str     x4, [x22, #-8]!
        mov     x20, x3
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        NEXT
_fm_div0
        str     xzr, [x22, #-8]!
        mov     x20, #-1
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
XFMMOD_END
        NEXT

        BOOT_WORD SEARCH, SEARCH ( c-addr1 u1 c-addr2 u2 -- c-addr3 u3 flag ) find substring, 0, XSEARCH, XSEARCH_END
XSEARCH
        mov     x3, x20
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        mov     x9, x0
        mov     x10, x1
        mov     x4, #0
        cbz     x3, _search_hit
_search_off
        subs    x5, x1, x4
        b.lo    _search_miss
        cmp     x5, x3
        b.lo    _search_miss
        mov     x6, #0
_search_cmp
        cmp     x6, x3
        b.hs    _search_hit
        add     x7, x0, x4
        ldrb    w8, [x7, x6]
        ldrb    w11, [x2, x6]
        cmp     w8, w11
        b.ne    _search_next
        add     x6, x6, #1
        b       _search_cmp
_search_next
        add     x4, x4, #1
        b       _search_off
_search_hit
        add     x0, x0, x4
        sub     x1, x1, x4
        str     x0, [x22, #-8]!
        str     x1, [x22, #-8]!
        mov     x20, #-1
        NEXT
_search_miss
        str     x9, [x22, #-8]!
        str     x10, [x22, #-8]!
        mov     x20, #0
XSEARCH_END
        NEXT

        BOOT_WORD CONTAINS, CONTAINS ( hay-a hay-u ned-a ned-u -- flag ) case-insensitive substring, 0, XCONTAINS, XCONTAINS_END
XCONTAINS
        mov     x4, x20
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        cbz     x4, _cont_yes
        cmp     x2, x4
        b.lo    _cont_no
        sub     x5, x2, x4
        add     x5, x5, #1
        mov     x6, #0
_cont_i
        cmp     x6, x5
        b.hs    _cont_no
        mov     x7, #0
_cont_j
        cmp     x7, x4
        b.hs    _cont_yes
        add     x8, x1, x6
        add     x8, x8, x7
        ldrb    w9, [x8]
        ldrb    w10, [x3, x7]
        cmp     w9, #'a'
        b.lo    _cont_hfold
        cmp     w9, #'z'
        b.hi    _cont_hfold
        sub     w9, w9, #32
_cont_hfold
        cmp     w10, #'a'
        b.lo    _cont_nfold
        cmp     w10, #'z'
        b.hi    _cont_nfold
        sub     w10, w10, #32
_cont_nfold
        cmp     w9, w10
        b.ne    _cont_next_i
        add     x7, x7, #1
        b       _cont_j
_cont_next_i
        add     x6, x6, #1
        b       _cont_i
_cont_yes
        mov     x20, #-1
        NEXT
_cont_no
        mov     x20, #0
XCONTAINS_END
        NEXT

; ---------------------------------------------------------------------
; Output
; ---------------------------------------------------------------------

        BOOT_WORD U., U. ( u -- ) print unsigned with a trailing space, 0, XUDOT, XUDOT_END
XUDOT
        mov     x0, x20
        ldr     x20, [x22], #8
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _sa_print_unsigned
        mov     x0, #32
        bl      _sa_putchar
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XUDOT_END
        NEXT

        BOOT_WORD SPACES, SPACES ( n -- ) emit n spaces, 0, XSPACES, XSPACES_END
XSPACES
        mov     x1, x20
        ldr     x20, [x22], #8
        cmp     x1, #0
        b.le    XSPACES_END
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
_spaces_loop
        str     x1, [sp, #48]
        mov     x0, #32
        bl      _putchar
        ldr     x1, [sp, #48]
        subs    x1, x1, #1
        b.ne    _spaces_loop
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XSPACES_END
        NEXT

        BOOT_WORD MS@, MS@ ( -- u ) milliseconds since the host started, 0, XMSFETCH, XMSFETCH_END
XMSFETCH
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      host_ms
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x20, [x22, #-8]!
        mov     x20, x0
XMSFETCH_END
        NEXT

        BOOT_WORD MS, MS ( u -- ) wait that many milliseconds, 0, XMS, XMS_END
XMS
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x0, x20
        ldr     x20, [x22], #8
        bl      host_sleep
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XMS_END
        NEXT

        BOOT_WORD_TIME_DATE  ( -- sec min hour day month year ) local wall time, 0, XTIME_DATE, XTIME_DATE_END
XTIME_DATE
        sub     sp, sp, #112
        stp     x29, x30, [sp, #32]
        add     x0, sp, #48
        bl      host_time_date
        ldr     x0, [sp, #48]
        ldr     x1, [sp, #56]
        ldr     x2, [sp, #64]
        ldr     x3, [sp, #72]
        ldr     x4, [sp, #80]
        ldr     x5, [sp, #88]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #112
        str     x20, [x22, #-8]!
        str     x0, [x22, #-8]!
        str     x1, [x22, #-8]!
        str     x2, [x22, #-8]!
        str     x3, [x22, #-8]!
        str     x4, [x22, #-8]!
        mov     x20, x5
XTIME_DATE_END
        NEXT

        BOOT_WORD KEY, KEY ( -- c ) next character from the host, 0, XKEY, XKEY_END
XKEY
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        adrp    x1, key_fn
        add     x1, x1, key_fn
        ldr     x1, [x1]
        cbz     x1, _key_none
        blr     x1
        b       _key_push
_key_none
        mov     x0, #0
_key_push
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x20, [x22, #-8]!
        mov     x20, x0
XKEY_END
        NEXT

        BOOT_WORD EKEY, EKEY ( -- u ) next key event, 0, XEKEY, XEKEY_END
XEKEY
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _getchar
        adrp    x1, debug_busy
        add     x1, x1, debug_busy
        ldr     x1, [x1]
        cbz     x1, ekey_push
        mov     x28, #0
ekey_push
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x20, [x22, #-8]!
        mov     x20, x0
XEKEY_END
        NEXT

        BOOT_WORD KEY?, KEY? ( -- flag ) true if a key is waiting, 0, XKEYQ, XKEYQ_END
XKEYQ
        str     x20, [x22, #-8]!
        mov     x20, #0
XKEYQ_END
        NEXT

; ---------------------------------------------------------------------
; Interpreter words
; ---------------------------------------------------------------------

        BOOT_WORD FIND, FIND ( c-addr -- c-addr 0 | xt 1 | xt -1 ) find a counted name, 0, XFIND, 0
XFIND
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x2, x20
        ldrb    w1, [x2]
        add     x0, x2, #1
        bl      _find_word
        cbz     x0, _xfind_not
        tbnz    x1, #63, _xfind_imm
        mov     x4, #-1
        b       _xfind_flag
_xfind_imm
        mov     x4, #1
_xfind_flag
        mov     x20, x0
        str     x20, [x22, #-8]!
        mov     x20, x4
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT
_xfind_not
        str     x20, [x22, #-8]!
        mov     x20, #0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

        BOOT_WORD ', ' ( name -- xt ) xt of the next name, 0, XTICK, 0
XTICK
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        bl      _next_word
        cbz     x1, _tick_fail
        stp     x0, x1, [sp, #48]
        bl      _find_word
        cbz     x0, _tick_fail
        str     x20, [x22, #-8]!
        mov     x20, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        NEXT
_tick_fail
        ldp     x0, x1, [sp, #48]
        cbz     x1, _tick_mark
        bl      emit_str
_tick_mark
        adrp    x0, msg_huh
        add     x0, x0, msg_huh
        bl      emit_cstr
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        b       _quit_exit

        BOOT_WORD EXECUTE, EXECUTE ( xt -- ) run the word at xt, 0, XEXECUTE, XEXECUTE_END
XEXECUTE
        mov     x21, x20
        adrp    x0, data_stack
        add     x0, x0, data_stack
        add     x0, x0, #1, lsl #12
        cmp     x22, x0
        b.hs    _exec_empty
        ldr     x20, [x22], #8
        b       _exec_go
_exec_empty
        mov     x20, #0
_exec_go
        ldr     x1, [x21]
        br      x1
XEXECUTE_END

        BOOT_WORD LITERAL, LITERAL ( x -- ) compile x as a literal, FLAG_IMM, XLITERAL, 0
XLITERAL
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        str     x20, [sp, #48]
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        bl      _compile_cell
        ldr     x0, [sp, #48]
        bl      _compile_cell
        ldr     x20, [x22], #8
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        NEXT

        BOOT_WORD >IN, >IN ( -- addr ) input offset from the source base, 0, XTOIN, 0
XTOIN
        str     x20, [x22, #-8]!
        adrp    x0, to_in
        add     x0, x0, to_in
        mov     x20, x0
        NEXT

        BOOT_WORD PARSE-NAME, PARSE-NAME ( -- c-addr u ) next blank-delimited name, 0, XPARSE_NAME, 0
XPARSE_NAME
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _parse_name_raw
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x20, [x22, #-8]!
        mov     x20, x2
        str     x20, [x22, #-8]!
        mov     x20, x5
        NEXT

; x0 = block number. Read that block into block_buf. No file, or a
; failed seek, blanks the buffer. Updates block_nr and clears block_upd.
_block_load_nr
        stp     x29, x30, [sp, #-32]!
        str     x19, [sp, #16]
        mov     x19, x0
        adrp    x0, block_nr
        add     x0, x0, block_nr
        str     x19, [x0]
        adrp    x0, block_file
        add     x0, x0, block_file
        ldr     x0, [x0]
        cbz     x0, _bln_blank
        lsl     x1, x19, #10
        mov     x2, #0
        bl      host_repos
        cbnz    x0, _bln_blank
        adrp    x0, block_buf
        add     x0, x0, block_buf
        mov     x1, #1024
        adrp    x2, block_file
        add     x2, x2, block_file
        ldr     x2, [x2]
        bl      host_read
        cmp     x0, #0
        b.lt    _bln_blank
        cmp     x0, #1024
        b.hs    _bln_done
        adrp    x1, block_buf
        add     x1, x1, block_buf
        add     x1, x1, x0
        mov     x2, #1024
        sub     x2, x2, x0
        mov     w3, #32
_bln_pad
        cbz     x2, _bln_done
        strb    w3, [x1], #1
        sub     x2, x2, #1
        b       _bln_pad
_bln_blank
        adrp    x0, block_buf
        add     x0, x0, block_buf
        mov     x1, #1024
        mov     w2, #32
_bln_fill
        cbz     x1, _bln_done
        strb    w2, [x0], #1
        sub     x1, x1, #1
        b       _bln_fill
_bln_done
        adrp    x0, block_upd
        add     x0, x0, block_upd
        str     xzr, [x0]
        ldr     x19, [sp, #16]
        ldp     x29, x30, [sp], #32
        ret

        BOOT_WORD REFILL, REFILL ( -- flag ) next line when a file is the source, 0, XREFILL, 0
XREFILL
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        adrp    x0, blk_var
        add     x0, x0, blk_var
        ldr     x0, [x0]
        cbnz    x0, _refill_block
        adrp    x0, line_mode
        add     x0, x0, line_mode
        ldr     x0, [x0]
        cbz     x0, _refill_no
        bl      _take_line
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x20, [x22, #-8]!
        cmp     x0, #0
        csetm   x20, ne
        NEXT
_refill_no
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x20, [x22, #-8]!
        mov     x20, #0
        NEXT
_refill_block
        adrp    x0, blk_var
        add     x0, x0, blk_var
        ldr     x1, [x0]
        add     x1, x1, #1
        str     x1, [x0]
        mov     x0, x1
        bl      _block_load_nr
        adrp    x0, block_buf
        add     x0, x0, block_buf
        adrp    x2, source_base
        add     x2, x2, source_base
        str     x0, [x2]
        adrp    x2, source_cur
        add     x2, x2, source_cur
        str     x0, [x2]
        add     x0, x0, #1024
        adrp    x2, source_end
        add     x2, x2, source_end
        str     x0, [x2]
        adrp    x2, to_in
        add     x2, x2, to_in
        str     xzr, [x2]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x20, [x22, #-8]!
        mov     x20, #-1
        NEXT

        BOOT_WORD EXIT-ADDR, EXIT-ADDR ( -- xt ) xt of EXIT, 0, XEXIT_ADDR, 0
XEXIT_ADDR
        adrp    x0, cfa_exit
        add     x0, x0, cfa_exit
        ldr     x0, [x0]
        str     x20, [x22, #-8]!
        mov     x20, x0
        NEXT

        BOOT_WORD SLIT-ADDR, SLIT-ADDR ( -- xt ) xt of the compiled string runtime, 0, XSLIT_ADDR, 0
XSLIT_ADDR
        adrp    x0, cfa_slit
        add     x0, x0, cfa_slit
        ldr     x0, [x0]
        str     x20, [x22, #-8]!
        mov     x20, x0
        NEXT

        BOOT_WORD_DOTQ  print text until a quote, FLAG_IMM, XDOTQ, 0
XDOTQ
        sub     sp, sp, #96
        stp     x29, x30, [sp, #32]
        bl      _cursor_load
        mov     x9, x0
        adrp    x3, source_end
        add     x3, x3, source_end
        ldr     x6, [x3]
        mov     x1, x9
_dq_scan
        cmp     x1, x6
        b.hs    _dq_len
        ldrb    w3, [x1]
        cbz     w3, _dq_len
        cmp     w3, #34
        b.eq    _dq_hit
        add     x1, x1, #1
        b       _dq_scan
_dq_hit
        sub     x5, x1, x9
        add     x1, x1, #1
        b       _dq_commit
_dq_len
        sub     x5, x1, x9
_dq_commit
        mov     x0, x1
        bl      _cursor_commit
        adrp    x0, state_var
        add     x0, x0, state_var
        ldr     x0, [x0]
        cbnz    x0, _dq_comp
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        str     x20, [x22, #-8]!
        mov     x20, x9
        str     x20, [x22, #-8]!
        mov     x20, x5
        b       XTYPE
_dq_comp
        stp     x9, x5, [sp, #48]
        adrp    x0, cfa_slit
        add     x0, x0, cfa_slit
        ldr     x0, [x0]
        bl      _compile_cell
        ldr     x0, [sp, #56]
        bl      _compile_cell
        ldr     x5, [sp, #56]
        ldr     x9, [sp, #48]
        adrp    x0, here_ptr
        add     x0, x0, here_ptr
        ldr     x1, [x0]
        mov     x3, #0
_dq_cpy
        cmp     x3, x5
        b.ge    _dq_align
        ldrb    w4, [x9, x3]
        strb    w4, [x1, x3]
        add     x3, x3, #1
        b       _dq_cpy
_dq_align
        add     x1, x1, x5
        add     x1, x1, #7
        bic     x1, x1, #7
        str     x1, [x0]
        adrp    x0, str_type
        add     x0, x0, str_type
        mov     x1, #4
        bl      _find_word
        cbz     x0, _dq_fail
        bl      _compile_cell
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT
_dq_fail
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        b       _quit_exit

; x2 = c-addr, x5 = u. Skips leading whitespace and consumes one trailing blank.
_parse_name_raw
        stp     x29, x30, [sp, #-16]!
        bl      _cursor_load
        mov     x2, x0
        adrp    x9, source_end
        add     x9, x9, source_end
        ldr     x9, [x9]
_pn_skip
        cmp     x2, x9
        b.hs    _pn_empty
        ldrb    w4, [x2]
        cbz     w4, _pn_empty
        cmp     w4, #32
        b.eq    _pn_sk
        cmp     w4, #9
        b.eq    _pn_sk
        cmp     w4, #10
        b.eq    _pn_sk
        cmp     w4, #13
        b.eq    _pn_sk
        b       _pn_start
_pn_sk
        add     x2, x2, #1
        b       _pn_skip
_pn_start
        mov     x3, x2
_pn_scan
        cmp     x2, x9
        b.hs    _pn_end
        ldrb    w4, [x2]
        cbz     w4, _pn_end
        cmp     w4, #32
        b.eq    _pn_end
        cmp     w4, #9
        b.eq    _pn_end
        cmp     w4, #10
        b.eq    _pn_end
        cmp     w4, #13
        b.eq    _pn_end
        add     x2, x2, #1
        b       _pn_scan
_pn_end
        sub     x5, x2, x3
        cmp     x2, x9
        b.hs    _pn_commit
        ldrb    w4, [x2]
        cbz     w4, _pn_commit
        add     x2, x2, #1
_pn_commit
        mov     x0, x2
        mov     x2, x3
        bl      _cursor_commit
        ldp     x29, x30, [sp], #16
        ret
_pn_empty
        mov     x0, x2
        bl      _cursor_commit
        mov     x2, x0
        mov     x5, #0
        ldp     x29, x30, [sp], #16
        ret

        BOOT_WORD TO, TO ( x name -- ) store into a VALUE or DEFER, FLAG_IMM, XTO_IMM, XTO_IMM_END
XTO_IMM
        sub     sp, sp, #128
        stp     x29, x30, [sp, #32]
        bl      _next_word
        cbz     x1, _to_fail
        stp     x0, x1, [sp, #48]
        adrp    x2, state_var
        add     x2, x2, state_var
        ldr     x2, [x2]
        cbz     x2, _to_interp
        ldp     x0, x1, [sp, #48]
        bl      _local_lookup
        cmp     x0, #-1
        b.eq    _to_compile_value
        str     x0, [sp, #96]
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        bl      _compile_cell
        ldr     x0, [sp, #96]
        bl      _compile_cell
        adrp    x0, cfa_local_store
        add     x0, x0, cfa_local_store
        ldr     x0, [x0]
        bl      _compile_cell
        b       _to_leave
_to_compile_value
        ldp     x0, x1, [sp, #48]
        bl      _find_word
        cbz     x0, _to_fail
        add     x0, x0, #16
        str     x0, [sp, #64]
        ldr     x1, [x0, #-8]
        cbz     x1, _to_bang
        ldr     x3, [x1]
        str     x3, [sp, #72]
        adrp    x0, str_twofetch
        add     x0, x0, str_twofetch
        mov     x1, #2
        bl      _find_word
        ldr     x3, [sp, #72]
        cmp     x0, x3
        b.ne    _to_bang
        adrp    x0, str_twostore
        add     x0, x0, str_twostore
        mov     x1, #2
        b       _to_plant
_to_bang
        adrp    x0, str_bang
        add     x0, x0, str_bang
        mov     x1, #1
_to_plant
        stp     x0, x1, [sp, #80]
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        bl      _compile_cell
        ldr     x0, [sp, #64]
        bl      _compile_cell
        ldp     x0, x1, [sp, #80]
        bl      _find_word
        cbz     x0, _to_fail
        bl      _compile_cell
        b       _to_leave
_to_interp
        ldp     x0, x1, [sp, #48]
        bl      _find_word
        cbz     x0, _to_fail
        add     x0, x0, #16
        adrp    x3, data_stack
        add     x3, x3, data_stack
        add     x3, x3, #1, lsl #12
        mov     x4, x3
        sub     x3, x3, x22
        lsr     x3, x3, #3
        cmp     x3, #2
        b.lo    _to_one
        str     x20, [x0]
        ldr     x1, [x22], #8
        str     x1, [x0, #8]
        b       _to_pop
_to_one
        str     x20, [x0]
_to_pop
        cmp     x22, x4
        b.hs    _to_empty
        ldr     x20, [x22], #8
        b       _to_leave
_to_empty
        mov     x20, #0
_to_leave
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #128
XTO_IMM_END
        NEXT
_to_fail
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #128
        adrp    x0, msg_huh
        add     x0, x0, msg_huh
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      emit_cstr
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        b       _quit_exit

        BOOT_WORD COMPARE, COMPARE ( c-addr1 u1 c-addr2 u2 -- n ) -1 0 or 1, 0, XCOMPARE, XCOMPARE_END
XCOMPARE
        mov     x3, x20
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        cmp     x1, x3
        csel    x4, x1, x3, lo
        mov     x5, #0
_cmp_loop
        cmp     x5, x4
        b.hs    _cmp_len
        ldrb    w6, [x0, x5]
        ldrb    w7, [x2, x5]
        cmp     w6, w7
        b.ne    _cmp_diff
        add     x5, x5, #1
        b       _cmp_loop
_cmp_diff
        mov     x20, #1
        b.hi    XCOMPARE_END
        mov     x20, #-1
        NEXT
_cmp_len
        cmp     x1, x3
        b.eq    _cmp_eq
        mov     x20, #1
        b.hi    XCOMPARE_END
        mov     x20, #-1
        NEXT
_cmp_eq
        mov     x20, #0
XCOMPARE_END
        NEXT

; ---------------------------------------------------------------------
; Search order and wordlists
; ---------------------------------------------------------------------

        BOOT_WORD LATEST, LATEST ( -- addr ) FORTH wordlist head array, 0, XLATEST, 0
XLATEST
        str     x20, [x22, #-8]!
        adrp    x0, latest_var
        add     x0, x0, latest_var
        mov     x20, x0
        NEXT

        BOOT_WORD FORTH-WORDLIST, FORTH-WORDLIST ( -- wid ) main FORTH word list, 0, XFORTH_WORDLIST, 0
XFORTH_WORDLIST
        str     x20, [x22, #-8]!
        adrp    x0, latest_var
        add     x0, x0, latest_var
        mov     x20, x0
        NEXT

        BOOT_WORD WORDLISTS, WORDLISTS ( -- addr n ) registered wordlist table, 0, XWORDLISTS, 0
XWORDLISTS
        str     x20, [x22, #-8]!
        adrp    x0, wordlist_reg
        add     x0, x0, wordlist_reg
        str     x0, [x22, #-8]!
        adrp    x0, wordlist_reg_n
        add     x0, x0, wordlist_reg_n
        ldr     x20, [x0]
        NEXT

        BOOT_WORD ALSO, ALSO ( -- ) duplicate the first search-order entry, 0, XALSO, 0
XALSO
        adrp    x0, search_order_n
        add     x0, x0, search_order_n
        ldr     x1, [x0]
        cbz     x1, _also_done
        cmp     x1, #8
        b.hs    _also_done
        adrp    x2, search_order
        add     x2, x2, search_order
        ldr     x3, [x2]
        mov     x4, x1
_also_shift
        cbz     x4, _also_put
        sub     x4, x4, #1
        ldr     x5, [x2, x4, lsl #3]
        add     x6, x4, #1
        str     x5, [x2, x6, lsl #3]
        b       _also_shift
_also_put
        str     x3, [x2]
        add     x1, x1, #1
        str     x1, [x0]
_also_done
        NEXT

        BOOT_WORD REDEF-WARNING, REDEF-WARNING ( -- addr ) nonzero warns on redefine, 0, XREDEF_WARNING, 0
XREDEF_WARNING
        str     x20, [x22, #-8]!
        adrp    x0, redef_warn
        add     x0, x0, redef_warn
        mov     x20, x0
        NEXT

        BOOT_WORD TRAVERSE-WORDLIST, TRAVERSE-WORDLIST ( i*x xt wid -- j*x ) visit each name, 0, XTRAVERSE_WORDLIST, 0
XTRAVERSE_WORDLIST
        mov     x5, x20
        ldr     x6, [x22], #8
        ldr     x20, [x22], #8
        str     x19, [x23, #-8]!
        str     x5, [x23, #-8]!
        mov     x7, #0
        str     x7, [x23, #-8]!
        str     x6, [x23, #-8]!
        ldr     x7, [x5]
_tw_loop
        cbz     x7, _tw_advance
        ldr     x8, [x7, #-16]
        ldr     x0, [x7, #-8]
        and     x0, x0, #0xFFFF
        sub     x0, x7, x0
        ldrb    w0, [x0]
        tst     w0, #0x80
        b.ne    _tw_skip
        and     w0, w0, #0x7F
        cbz     w0, _tw_skip
        ldr     x6, [x23]
        str     x8, [x23, #-8]!
        str     x20, [x22, #-8]!
        mov     x20, x7
        mov     x21, x6
        adrp    x19, tw_continue_cell
        add     x19, x19, tw_continue_cell
        ldr     x1, [x21]
        br      x1
_tw_skip
        mov     x7, x8
        b       _tw_loop
_tw_advance
        ldr     x6, [x23], #8
        ldr     x7, [x23], #8
        ldr     x5, [x23], #8
        add     x7, x7, #1
        cmp     x7, #16
        b.hs    _tw_done
        str     x5, [x23, #-8]!
        str     x7, [x23, #-8]!
        str     x6, [x23, #-8]!
        add     x0, x5, x7, lsl #3
        ldr     x7, [x0]
        b       _tw_loop
_tw_done
        ldr     x19, [x23], #8
        NEXT

XTW_CONTINUE
        ldr     x8, [x23], #8
        ldr     x6, [x23]
        cbz     x20, _tw_stop
        ldr     x20, [x22], #8
        mov     x7, x8
        cbz     x7, _tw_advance
        b       _tw_loop
_tw_stop
        ldr     x20, [x22], #8
        ldr     x6, [x23], #8
        ldr     x7, [x23], #8
        ldr     x5, [x23], #8
        ldr     x19, [x23], #8
        NEXT

; ---------------------------------------------------------------------
; CATCH / TO support already above. UTF-8, boot table, float address.
; ---------------------------------------------------------------------

; Frame, deepest first: eval_resume_sp, prev, TOS, DSP, source_sp, IP.
; throw_handler points at saved IP. Success does not pop SOURCE.
        BOOT_WORD CATCH, CATCH ( xt -- n ) run xt and push 0 or the throw code, 0, XCATCH, XCATCH_END
XCATCH
        mov     x5, x20
        adrp    x0, data_stack
        add     x0, x0, data_stack
        add     x0, x0, #1, lsl #12
        cmp     x22, x0
        b.hs    _catch_empty
        ldr     x20, [x22], #8
        b       _catch_save
_catch_empty
        mov     x20, #0
_catch_save
        adrp    x7, throw_handler
        add     x7, x7, throw_handler
        ldr     x2, [x7]
        adrp    x3, eval_resume_sp
        add     x3, x3, eval_resume_sp
        ldr     x3, [x3]
        str     x3, [x23, #-8]!
        str     x2, [x23, #-8]!
        str     x20, [x23, #-8]!
        str     x22, [x23, #-8]!
        adrp    x2, source_sp
        add     x2, x2, source_sp
        ldr     x2, [x2]
        str     x2, [x23, #-8]!
        str     x19, [x23, #-8]!
        str     x23, [x7]
        adrp    x19, catch_ok_cell
        add     x19, x19, catch_ok_cell
        mov     x21, x5
        ldr     x1, [x21]
        br      x1
XCATCH_END

        BOOT_WORD (CATCH-OK), (CATCH-OK) ( -- 0 ) CATCH success path, 0, XCATCH_OK, XCATCH_OK_END
XCATCH_OK
        adrp    x7, throw_handler
        add     x7, x7, throw_handler
        ldr     x1, [x7]
        cbz     x1, _cok_push
        mov     x23, x1
        ldr     x19, [x23], #8
        add     x23, x23, #24
        ldr     x0, [x23], #8
        str     x0, [x7]
        add     x23, x23, #8
_cok_push
        str     x20, [x22, #-8]!
        mov     x20, #0
XCATCH_OK_END
        NEXT

        BOOT_WORD XC!+, XC!+ ( xchar xc-addr1 -- xc-addr2 ) store one UTF-8 xchar, 0, XXC_STORE_PLUS, XXC_STORE_PLUS_END
XXC_STORE_PLUS
        mov     x0, x20
        ldr     x1, [x22], #8
        movz    x2, #0xFFFF
        movk    x2, #0x10, lsl #16
        cmp     x1, x2
        csel    x1, x2, x1, hi
        cmp     x1, #0x7F
        b.ls    _xcsp_1
        cmp     x1, #0x7FF
        b.ls    _xcsp_2
        movz    x2, #0xFFFF
        cmp     x1, x2
        b.ls    _xcsp_3
        lsr     x2, x1, #18
        orr     w2, w2, #0xF0
        strb    w2, [x0], #1
        lsr     x2, x1, #12
        and     w2, w2, #0x3F
        orr     w2, w2, #0x80
        strb    w2, [x0], #1
        lsr     x2, x1, #6
        and     w2, w2, #0x3F
        orr     w2, w2, #0x80
        strb    w2, [x0], #1
        and     w2, w1, #0x3F
        orr     w2, w2, #0x80
        strb    w2, [x0], #1
        mov     x20, x0
        NEXT
_xcsp_3
        lsr     x2, x1, #12
        orr     w2, w2, #0xE0
        strb    w2, [x0], #1
        lsr     x2, x1, #6
        and     w2, w2, #0x3F
        orr     w2, w2, #0x80
        strb    w2, [x0], #1
        and     w2, w1, #0x3F
        orr     w2, w2, #0x80
        strb    w2, [x0], #1
        mov     x20, x0
        NEXT
_xcsp_2
        lsr     x2, x1, #6
        orr     w2, w2, #0xC0
        strb    w2, [x0], #1
        and     w2, w1, #0x3F
        orr     w2, w2, #0x80
        strb    w2, [x0], #1
        mov     x20, x0
        NEXT
_xcsp_1
        strb    w1, [x0], #1
        mov     x20, x0
XXC_STORE_PLUS_END
        NEXT

        BOOT_WORD XC@+, XC@+ ( xc-addr1 -- xc-addr2 xchar ) fetch one UTF-8 xchar, 0, XXC_FETCH_PLUS, XXC_FETCH_PLUS_END
XXC_FETCH_PLUS
        mov     x0, x20
        ldrb    w1, [x0], #1
        cmp     w1, #0x80
        b.lo    _xcfp_1
        cmp     w1, #0xE0
        b.lo    _xcfp_2
        cmp     w1, #0xF0
        b.lo    _xcfp_3
        and     w2, w1, #0x07
        ldrb    w3, [x0], #1
        and     w3, w3, #0x3F
        lsl     w2, w2, #6
        orr     w2, w2, w3
        ldrb    w3, [x0], #1
        and     w3, w3, #0x3F
        lsl     w2, w2, #6
        orr     w2, w2, w3
        ldrb    w3, [x0], #1
        and     w3, w3, #0x3F
        lsl     w2, w2, #6
        orr     w2, w2, w3
        str     x0, [x22, #-8]!
        mov     x20, x2
        NEXT
_xcfp_3
        and     w2, w1, #0x0F
        ldrb    w3, [x0], #1
        and     w3, w3, #0x3F
        lsl     w2, w2, #6
        orr     w2, w2, w3
        ldrb    w3, [x0], #1
        and     w3, w3, #0x3F
        lsl     w2, w2, #6
        orr     w2, w2, w3
        str     x0, [x22, #-8]!
        mov     x20, x2
        NEXT
_xcfp_2
        and     w2, w1, #0x1F
        ldrb    w3, [x0], #1
        and     w3, w3, #0x3F
        lsl     w2, w2, #6
        orr     w2, w2, w3
        str     x0, [x22, #-8]!
        mov     x20, x2
        NEXT
_xcfp_1
        str     x0, [x22, #-8]!
        mov     x20, x1
XXC_FETCH_PLUS_END
        NEXT

        BOOT_WORD BOOT-WORD-TABLE, BOOT-WORD-TABLE ( -- addr ) start of the boot-word pointer table, 0, XBOOT_WORD_TABLE, XBOOT_WORD_TABLE_END
XBOOT_WORD_TABLE
        str     x20, [x22, #-8]!
        adrp    x20, bootptr_start
        add     x20, x20, bootptr_start
XBOOT_WORD_TABLE_END
        NEXT

        BOOT_WORD BOOT-WORD-TABLE-END, BOOT-WORD-TABLE-END ( -- addr ) end of the boot-word pointer table, 0, XBW_TABLE_LIM, XBW_TABLE_LIM_END
XBW_TABLE_LIM
        str     x20, [x22, #-8]!
        adrp    x20, bootptr_end
        add     x20, x20, bootptr_end
XBW_TABLE_LIM_END
        NEXT

        BOOT_WORD FLIT, FLIT ( -- ) push the inline float bits, 0, XFLIT, XFLIT_END
XFLIT
        ldr     x1, [x19], #8
        mov     x0, #101
        mov     x2, #0
        mov     x3, #0
        mov     x4, #0
        mov     x5, #0
        bl      _float_op_call
XFLIT_END
        NEXT

        BOOT_WORD FLIT-ADDR, FLIT-ADDR ( -- xt ) xt of FLIT, 0, XFLIT_ADDR, XFLIT_ADDR_END
XFLIT_ADDR
        adrp    x0, cfa_flit
        add     x0, x0, cfa_flit
        ldr     x0, [x0]
        str     x20, [x22, #-8]!
        mov     x20, x0
XFLIT_ADDR_END
        NEXT

        BOOT_WORD (F-OP), (F-OP) ( i*x op -- j*x ) float host multiplex, 0, XFLOAT_OP, XFLOAT_OP_END
XFLOAT_OP
        mov     x9, x20
        ldr     x20, [x22], #8
        mov     x1, #0
        mov     x2, #0
        mov     x3, #0
        mov     x4, #0
        mov     x5, #0
        cmp     x9, #22
        b.eq    _fo_a1
        cmp     x9, #23
        b.eq    _fo_a1
        cmp     x9, #24
        b.eq    _fo_a1
        cmp     x9, #25
        b.eq    _fo_a1
        cmp     x9, #26
        b.eq    _fo_a1
        cmp     x9, #27
        b.eq    _fo_a1
        cmp     x9, #28
        b.eq    _fo_a1
        cmp     x9, #37
        b.eq    _fo_a1
        cmp     x9, #39
        b.eq    _fo_a1
        cmp     x9, #40
        b.eq    _fo_a1
        cmp     x9, #41
        b.eq    _fo_a1
        cmp     x9, #42
        b.eq    _fo_a1
        cmp     x9, #43
        b.eq    _fo_a1
        cmp     x9, #44
        b.eq    _fo_a1
        cmp     x9, #70
        b.eq    _fo_a1
        cmp     x9, #71
        b.eq    _fo_a1
        cmp     x9, #72
        b.eq    _fo_a1
        cmp     x9, #73
        b.eq    _fo_a1
        cmp     x9, #74
        b.eq    _fo_a1
        cmp     x9, #75
        b.eq    _fo_a1
        cmp     x9, #30
        b.eq    _fo_d2
        cmp     x9, #32
        b.eq    _fo_cu
        cmp     x9, #38
        b.eq    _fo_cu
        b       _fo_go
_fo_a1
        mov     x1, x20
        ldr     x20, [x22], #8
        b       _fo_go
_fo_d2
        mov     x2, x20
        ldr     x1, [x22], #8
        ldr     x20, [x22], #8
        b       _fo_go
_fo_cu
        mov     x2, x20
        ldr     x5, [x22], #8
        ldr     x20, [x22], #8
_fo_go
        str     x9, [x23, #-8]!
        mov     x0, x9
        bl      _float_op_call
        ldr     x9, [x23], #8
        cmp     x9, #31
        b.eq    _fo_push2
        cmp     x9, #38
        b.eq    _fo_push3
        cmp     x9, #1
        b.eq    _fo_push1
        cmp     x9, #15
        b.eq    _fo_push1
        cmp     x9, #16
        b.eq    _fo_push1
        cmp     x9, #17
        b.eq    _fo_push1
        cmp     x9, #18
        b.eq    _fo_push1
        cmp     x9, #19
        b.eq    _fo_push1
        cmp     x9, #20
        b.eq    _fo_push1
        cmp     x9, #21
        b.eq    _fo_push1
        cmp     x9, #29
        b.eq    _fo_push1
        cmp     x9, #32
        b.eq    _fo_push1
        cmp     x9, #36
        b.eq    _fo_push1
        cmp     x9, #39
        b.eq    _fo_push1
        cmp     x9, #40
        b.eq    _fo_push1
        cmp     x9, #41
        b.eq    _fo_push1
        cmp     x9, #42
        b.eq    _fo_push1
        cmp     x9, #43
        b.eq    _fo_push1
        cmp     x9, #44
        b.eq    _fo_push1
        cmp     x9, #70
        b.eq    _fo_push1
        cmp     x9, #71
        b.eq    _fo_push1
        cmp     x9, #72
        b.eq    _fo_push1
        cmp     x9, #73
        b.eq    _fo_push1
        cmp     x9, #74
        b.eq    _fo_push1
        cmp     x9, #75
        b.eq    _fo_push1
        cmp     x9, #102
        b.eq    _fo_push1
        b       _fo_none
_fo_push1
        str     x20, [x22, #-8]!
        mov     x20, x6
        b       _fo_none
_fo_push2
        str     x20, [x22, #-8]!
        str     x6, [x22, #-8]!
        mov     x20, x7
        b       _fo_none
_fo_push3
        str     x20, [x22, #-8]!
        str     x6, [x22, #-8]!
        str     x7, [x22, #-8]!
        mov     x20, x8
_fo_none
XFLOAT_OP_END
        NEXT

        BOOT_WORD (LOCAL), (LOCAL) ( c-addr u -- ) declare a local or end the local list, 0, XLOCAL_PAREN, XLOCAL_PAREN_END
XLOCAL_PAREN
        stp     x29, x30, [sp, #-16]!
        adrp    x0, state_var
        add     x0, x0, state_var
        ldr     x0, [x0]
        cbz     x0, _lp_leave
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        cbz     x1, _lp_last
        adrp    x2, local_declaring
        add     x2, x2, local_declaring
        ldr     x3, [x2]
        cbnz    x3, _lp_add
        stp     x0, x1, [sp, #-16]!
        bl      _local_compile_reset
        ldp     x0, x1, [sp], #16
        adrp    x3, local_init_reverse
        add     x3, x3, local_init_reverse
        str     xzr, [x3]
        mov     x3, #1
        adrp    x2, local_declaring
        add     x2, x2, local_declaring
        str     x3, [x2]
_lp_add
        bl      _local_add_name
        adrp    x2, local_init_count
        add     x2, x2, local_init_count
        ldr     x3, [x2]
        add     x3, x3, #1
        str     x3, [x2]
        b       _lp_leave
_lp_last
        adrp    x2, local_declaring
        add     x2, x2, local_declaring
        ldr     x3, [x2]
        cbnz    x3, _lp_fin
        bl      _local_compile_reset
        adrp    x3, local_init_reverse
        add     x3, x3, local_init_reverse
        str     xzr, [x3]
_lp_fin
        bl      _local_finalize_compile
        adrp    x2, local_declaring
        add     x2, x2, local_declaring
        str     xzr, [x2]
_lp_leave
        ldp     x29, x30, [sp], #16
XLOCAL_PAREN_END
        NEXT

        BOOT_WORD TEXTEDIT, TEXTEDIT ( -- ) open the next file name in the editor, 0, XTEXTEDIT, 0
XTEXTEDIT
        stp     x29, x30, [sp, #-16]!
        bl      _parse_filespec
        bl      host_edit
        ldp     x29, x30, [sp], #16
        NEXT

; EDIT-AT ( c-addr u line -- ). Line 0 opens the file. Does not change cwd.
        BOOT_WORD EDIT-AT, EDIT-AT ( c-addr u line -- ) open path at line in the editor, 0, XEDIT_AT, 0
XEDIT_AT
        mov     x3, x20
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        adrp    x9, data_stack
        add     x9, x9, data_stack
        add     x9, x9, #1, lsl #12
        cmp     x22, x9
        b.hs    _eat_empty
        ldr     x20, [x22], #8
        b       _eat_call
_eat_empty
        mov     x20, #0
_eat_call
        mov     x0, x1
        mov     x1, x2
        mov     x2, x3
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      host_edit_at
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

; End label follows NEXT, matching the Mac SYSTEM row.
        BOOT_WORD SYSTEM, SYSTEM ( c-addr u -- n ) run a shell command and return the exit code or -1, 0, XSYSTEM, XSYSTEM_END
XSYSTEM
        mov     x1, x20
        ldr     x0, [x22], #8
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      host_system
        str     x0, [sp, #48]
        ldp     x29, x30, [sp, #32]
        ldr     x20, [sp, #48]
        add     sp, sp, #64
        NEXT
XSYSTEM_END

; VIEW-PATH, DBG-ON, and DBG-OFF live with the stepper in prims_dbg.asm.

; ---------------------------------------------------------------------
; File and block names. Stack effects match the Mac words.
; File ids are 1-based host slots. ior is 0 or -1.
; ---------------------------------------------------------------------

        BOOT_WORD R/O, R/O ( -- fam ) read-only file access method, 0, XRO, XRO_END
XRO
        str     x20, [x22, #-8]!
        mov     x20, #1
XRO_END
        NEXT

        BOOT_WORD R/W, R/W ( -- fam ) read-write file access method, 0, XRW, XRW_END
XRW
        str     x20, [x22, #-8]!
        mov     x20, #3
XRW_END
        NEXT

        BOOT_WORD W/O, W/O ( -- fam ) write-only file access method, 0, XW_O, XW_O_END
XW_O
        str     x20, [x22, #-8]!
        mov     x20, #2
XW_O_END
        NEXT

        BOOT_WORD BIN, BIN ( fam -- fam ) binary access is the same fam here, 0, XBIN, 0
XBIN
        NEXT

        BOOT_WORD OPEN-FILE, OPEN-FILE ( c-addr u fam -- fileid ior ) open an existing file, 0, XOPEN_FILE, XOPEN_FILE_END
XOPEN_FILE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x3, x20
        ldr     x2, [x22], #8
        ldr     x5, [x22], #8
        mov     x0, #1
        mov     x1, #0
        mov     x4, #0
        bl      _file_op_call
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x6, [x22, #-8]!
        mov     x20, x0
XOPEN_FILE_END
        NEXT

        BOOT_WORD CREATE-FILE, CREATE-FILE ( c-addr u fam -- fileid ior ) create or truncate a file, 0, XCREATE_FILE, XCREATE_FILE_END
XCREATE_FILE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x3, x20
        ldr     x2, [x22], #8
        ldr     x5, [x22], #8
        mov     x0, #2
        mov     x1, #0
        mov     x4, #0
        bl      _file_op_call
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x6, [x22, #-8]!
        mov     x20, x0
XCREATE_FILE_END
        NEXT

        BOOT_WORD FILE-SIZE, FILE-SIZE ( fileid -- ud ior ) size of an open file, 0, XFILE_SIZE, XFILE_SIZE_END
XFILE_SIZE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        mov     x0, #9
        mov     x2, #0
        mov     x3, #0
        mov     x4, #0
        mov     x5, #0
        bl      _file_op_call
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x6, [x22, #-8]!
        str     x7, [x22, #-8]!
        mov     x20, x0
XFILE_SIZE_END
        NEXT

        BOOT_WORD CLOSE-FILE, CLOSE-FILE ( fileid -- ior ) close an open file, 0, XCLOSE_FILE, XCLOSE_FILE_END
XCLOSE_FILE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        mov     x0, #3
        mov     x2, #0
        mov     x3, #0
        mov     x4, #0
        mov     x5, #0
        bl      _file_op_call
        mov     x20, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XCLOSE_FILE_END
        NEXT

        BOOT_WORD ALLOCATE, ALLOCATE ( u -- a-addr ior ) allocate heap memory, 0, XALLOCATE, XALLOCATE_END
XALLOCATE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x0, x20
        bl      host_alloc
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        cbz     x0, _alloc_fail
        str     x0, [x22, #-8]!
        mov     x20, #0
        b       _alloc_leave
_alloc_fail
        str     xzr, [x22, #-8]!
        mov     x20, #-1
_alloc_leave
XALLOCATE_END
        NEXT

        BOOT_WORD FREE, FREE ( a-addr -- ior ) release heap memory, 0, XFREE, XFREE_END
XFREE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x0, x20
        bl      host_free
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        mov     x20, #0
XFREE_END
        NEXT

        BOOT_WORD RESIZE, RESIZE ( a-addr1 u -- a-addr2 ior ) resize heap memory, 0, XRESIZE, XRESIZE_END
XRESIZE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x0, [x22], #8
        str     x0, [sp, #48]
        bl      host_resize
        ldr     x1, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        cbz     x0, _resize_fail
        str     x0, [x22, #-8]!
        mov     x20, #0
        NEXT
_resize_fail
        str     x1, [x22, #-8]!
        mov     x20, #-1
XRESIZE_END
        NEXT

        BOOT_WORD READ-FILE, READ-FILE ( c-addr u1 fileid -- u2 ior ) read from an open file, 0, XREAD_FILE, XREAD_FILE_END
XREAD_FILE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x2, [x22], #8
        ldr     x5, [x22], #8
        mov     x0, #4
        mov     x3, #0
        mov     x4, #0
        bl      _file_op_call
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x6, [x22, #-8]!
        mov     x20, x0
XREAD_FILE_END
        NEXT

        BOOT_WORD WRITE-FILE, WRITE-FILE ( c-addr u fileid -- ior ) write to an open file, 0, XWRITE_FILE, XWRITE_FILE_END
XWRITE_FILE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x2, [x22], #8
        ldr     x5, [x22], #8
        mov     x0, #5
        mov     x3, #0
        mov     x4, #0
        bl      _file_op_call
        mov     x20, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XWRITE_FILE_END
        NEXT

        BOOT_WORD REPOSITION-FILE, REPOSITION-FILE ( ud fileid -- ior ) seek in an open file, 0, XREPOSITION_FILE, XREPOSITION_FILE_END
XREPOSITION_FILE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        mov     x0, #10
        mov     x4, #0
        mov     x5, #0
        bl      _file_op_call
        mov     x20, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XREPOSITION_FILE_END
        NEXT

        BOOT_WORD FLUSH-FILE, FLUSH-FILE ( fileid -- ior ) flush an open file, 0, XFLUSH_FILE, XFLUSH_FILE_END
XFLUSH_FILE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        mov     x0, #15
        mov     x2, #0
        mov     x3, #0
        mov     x4, #0
        mov     x5, #0
        bl      _file_op_call
        mov     x20, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XFLUSH_FILE_END
        NEXT

        BOOT_WORD READ-LINE, READ-LINE ( c-addr u1 fileid -- u2 flag ior ) read one line. flag is true when a line was read, 0, XREAD_LINE, XREAD_LINE_END
XREAD_LINE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x2, [x22], #8
        ldr     x5, [x22], #8
        mov     x0, #6
        mov     x3, #0
        mov     x4, #0
        bl      _file_op_call
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x6, [x22, #-8]!
        str     x7, [x22, #-8]!
        mov     x20, x0
XREAD_LINE_END
        NEXT

        BOOT_WORD WRITE-LINE, WRITE-LINE ( c-addr u fileid -- ior ) write the bytes and a newline, 0, XWRITE_LINE, XWRITE_LINE_END
XWRITE_LINE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x2, [x22], #8
        ldr     x5, [x22], #8
        mov     x0, #7
        mov     x3, #0
        mov     x4, #0
        bl      _file_op_call
        mov     x20, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XWRITE_LINE_END
        NEXT

        BOOT_WORD FILE-POSITION, FILE-POSITION ( fileid -- ud ior ) byte offset in an open file, 0, XFILE_POSITION, XFILE_POSITION_END
XFILE_POSITION
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        mov     x0, #8
        mov     x2, #0
        mov     x3, #0
        mov     x4, #0
        mov     x5, #0
        bl      _file_op_call
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x6, [x22, #-8]!
        str     x7, [x22, #-8]!
        mov     x20, x0
XFILE_POSITION_END
        NEXT

        BOOT_WORD RESIZE-FILE, RESIZE-FILE ( ud fileid -- ior ) set the length of an open file, 0, XRESIZE_FILE, XRESIZE_FILE_END
XRESIZE_FILE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        mov     x0, #11
        mov     x4, #0
        mov     x5, #0
        bl      _file_op_call
        mov     x20, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XRESIZE_FILE_END
        NEXT

        BOOT_WORD DELETE-FILE, DELETE-FILE ( c-addr u -- ior ) delete a named file, 0, XDELETE_FILE, XDELETE_FILE_END
XDELETE_FILE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x2, x20
        ldr     x5, [x22], #8
        mov     x0, #12
        mov     x1, #0
        mov     x3, #0
        mov     x4, #0
        bl      _file_op_call
        mov     x20, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XDELETE_FILE_END
        NEXT

        BOOT_WORD RENAME-FILE, RENAME-FILE ( c-addr1 u1 c-addr2 u2 -- ior ) rename a file, 0, XRENAME_FILE, XRENAME_FILE_END
XRENAME_FILE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x4, x20
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x5, [x22], #8
        mov     x0, #13
        mov     x1, #0
        bl      _file_op_call
        mov     x20, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XRENAME_FILE_END
        NEXT

        BOOT_WORD FILE-STATUS, FILE-STATUS ( c-addr u -- x ior ) attributes of a named file, 0, XFILE_STATUS, XFILE_STATUS_END
XFILE_STATUS
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x2, x20
        ldr     x5, [x22], #8
        mov     x0, #14
        mov     x1, #0
        mov     x3, #0
        mov     x4, #0
        bl      _file_op_call
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x6, [x22, #-8]!
        mov     x20, x0
XFILE_STATUS_END
        NEXT

        BOOT_WORD (LINE-SOURCE), (LINE-SOURCE) ( c-addr u -- ) interpret one line per SOURCE, 0, XLINE_SOURCE, 0
XLINE_SOURCE
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        stp     x0, x1, [sp, #48]
        bl      _push_source
        bl      _view_push_src_id
        bl      _view_set_src_from_pending
        ldp     x0, x1, [sp, #48]
        bl      _arm_lines
        adrp    x0, source_id
        add     x0, x0, source_id
        mov     x1, #2
        neg     x1, x1
        str     x1, [x0]
        adrp    x0, blk_var
        add     x0, x0, blk_var
        str     xzr, [x0]
        bl      _eval_resume_push
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        b       _interpret_empty

        BOOT_WORD RESOLVE-KEY, RESOLVE-KEY ( c-addr u -- c-addr u ) absolute path for a load name, 0, XRESOLVE_KEY, 0
XRESOLVE_KEY
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x0, [x22], #8
        cbz     x1, _resolve_empty
        adrp    x2, resolve_buf
        add     x2, x2, resolve_buf
        mov     x3, #256
        bl      host_resolve
        mov     x1, x0
        cmp     x1, #255
        b.ls    _rk_cap
        mov     x1, #255
_rk_cap
        adrp    x3, include_name_len
        add     x3, x3, include_name_len
        str     x1, [x3]
        cbz     x1, _rk_copied
        adrp    x2, resolve_buf
        add     x2, x2, resolve_buf
        adrp    x3, include_name_pending
        add     x3, x3, include_name_pending
        mov     x4, #0
_rk_cp
        cmp     x4, x1
        b.hs    _rk_copied
        ldrb    w5, [x2, x4]
        strb    w5, [x3, x4]
        add     x4, x4, #1
        b       _rk_cp
_rk_copied
        adrp    x2, resolve_buf
        add     x2, x2, resolve_buf
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x2, [x22, #-8]!
        mov     x20, x0
        NEXT
_resolve_empty
        adrp    x1, include_name_len
        add     x1, x1, include_name_len
        str     xzr, [x1]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x0, [x22, #-8]!
        mov     x20, #0
        NEXT

        BOOT_WORD BEGIN-LOAD-CWD, BEGIN-LOAD-CWD ( c-addr u -- ) push the directory of this path, 0, XBEGIN_LOAD_CWD, 0
XBEGIN_LOAD_CWD
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        bl      host_begin_load
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

        BOOT_WORD END-LOAD-CWD, END-LOAD-CWD ( -- ) pop the directory pushed for this load, 0, XEND_LOAD_CWD, 0
XEND_LOAD_CWD
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      host_end_load
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

        BOOT_WORD REGISTER-INCLUDED-STR, REGISTER-INCLUDED-STR ( c-addr u -- ) remember a loaded path, 0, XREG_INCLUDED, 0
XREG_INCLUDED
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        bl      host_register
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

; x0 = c-addr, x1 = u. u is 0 when no filespec remains. Quoted paths keep spaces.
_parse_filespec
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _cursor_load
        mov     x2, x0
        adrp    x9, source_end
        add     x9, x9, source_end
        ldr     x9, [x9]
_pfs_skip
        cmp     x2, x9
        b.hs    _pfs_empty
        ldrb    w4, [x2]
        cmp     w4, #32
        b.eq    _pfs_sk
        cmp     w4, #9
        b.eq    _pfs_sk
        cmp     w4, #10
        b.eq    _pfs_sk
        cmp     w4, #13
        b.eq    _pfs_sk
        b       _pfs_body
_pfs_sk
        add     x2, x2, #1
        b       _pfs_skip
_pfs_body
        cmp     w4, #34
        b.ne    _pfs_word
        add     x3, x2, #1
_pfs_q
        add     x2, x2, #1
        cmp     x2, x9
        b.hs    _pfs_qend
        ldrb    w4, [x2]
        cmp     w4, #34
        b.ne    _pfs_q
        sub     x5, x2, x3
        add     x2, x2, #1
        b       _pfs_out
_pfs_qend
        sub     x5, x2, x3
        b       _pfs_out
_pfs_word
        mov     x0, x2
        bl      _cursor_commit
        bl      _parse_name_raw
        mov     x0, x2
        mov     x1, x5
        b       _pfs_ret
_pfs_out
        mov     x0, x2
        mov     x2, x3
        bl      _cursor_commit
        mov     x0, x2
        mov     x1, x5
        b       _pfs_ret
_pfs_empty
        mov     x0, x2
        bl      _cursor_commit
        mov     x1, #0
_pfs_ret
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        ret

        BOOT_WORD PARSE-FILESPEC, PARSE-FILESPEC ( -- c-addr u ) next file name or quoted path, 0, XPARSE_FILESPEC, 0
XPARSE_FILESPEC
        stp     x29, x30, [sp, #-16]!
        bl      _parse_filespec
        ldp     x29, x30, [sp], #16
        str     x20, [x22, #-8]!
        str     x0, [x22, #-8]!
        mov     x20, x1
        NEXT

        BOOT_WORD FROMLIB, FROMLIB ( -- ) arm the next relative load to use Library, 0, XFROMLIB, 0
XFROMLIB
        stp     x29, x30, [sp, #-16]!
        bl      host_fromlib
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD FROM-LIBRARY, FROM-LIBRARY ( -- ) same as FROMLIB, 0, XFROM_LIBRARY, 0
XFROM_LIBRARY
        stp     x29, x30, [sp, #-16]!
        bl      host_fromlib
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD FROMLIB-OFF, FROMLIB-OFF ( -- ) clear an armed FROMLIB, 0, XFROMLIB_OFF, 0
XFROMLIB_OFF
        stp     x29, x30, [sp, #-16]!
        bl      host_fromlib_off
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD FROMLIB?, FROMLIB? ( -- flag ) true when FROMLIB is armed, 0, XFROMLIB_Q, XFROMLIB_Q_END
XFROMLIB_Q
        stp     x29, x30, [sp, #-16]!
        bl      host_fromlib_query
        ldp     x29, x30, [sp], #16
        DPUSH
XFROMLIB_Q_END
        NEXT

        BOOT_WORD FILE-ECHO, FILE-ECHO ( -- addr ) echo INCLUDE and FLOAD lines with a line number, 0, XFILE_ECHO, 0
XFILE_ECHO
        adrp    x0, file_echo
        add     x0, x0, file_echo
        DPUSH
        NEXT

        BOOT_WORD CLS, CLS ( -- ) clear the host console, 0, XCLS, XCLS_END
XCLS
        mov     x0, #9
        mov     x1, #0
        mov     x2, #0
        b       _facility_op_go
XCLS_END

        BOOT_WORD BI-MUL, BI-MUL ( a b r -- ) BIG-INTEGER host multiply, 0, XBIMUL, XBIMUL_END
XBIMUL
        mov     x2, x20
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_bi_mul
        ldp     x29, x30, [sp], #16
XBIMUL_END
        NEXT

        BOOT_WORD BI-DIVMOD, BI-DIVMOD ( num den quot rem work -- ) BIG-INTEGER host divmod, 0, XBIDIVMOD, XBIDIVMOD_END
XBIDIVMOD
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_bi_divmod
        ldp     x29, x30, [sp], #16
XBIDIVMOD_END
        NEXT

        BOOT_WORD BI-ISQRT, BI-ISQRT ( a r quot rem work t1 t2 -- ) BIG-INTEGER host isqrt, 0, XBIISQRT, XBIISQRT_END
XBIISQRT
        ldr     x0, [x22], #8
        ldr     x0, [x22], #8
        ldr     x0, [x22], #8
        ldr     x0, [x22], #8
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_bi_isqrt
        ldp     x29, x30, [sp], #16
XBIISQRT_END
        NEXT

        BOOT_WORD CHDIR, CHDIR ( -- ) change directory. a bare call waits for a dialog, 0, XCHDIR, 0
XCHDIR
        stp     x29, x30, [sp, #-16]!
        bl      _parse_filespec
        cbz     x1, _chdir_done
        bl      host_chdir
_chdir_done
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD PWD, PWD ( -- ) print the current directory, 0, XPWD, 0
XPWD
        stp     x29, x30, [sp, #-16]!
        bl      host_pwd
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD CWD@, CWD@ ( c-addr max -- u ) copy the current directory, 0, XCWD_FETCH, 0
XCWD_FETCH
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x0, [x22], #8
        bl      host_cwd
        mov     x20, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT
XCWD_FETCH_END

        BOOT_WORD DIR, DIR ( -- ) list files. a bare call lists the current directory, 0, XDIR, 0
XDIR
        stp     x29, x30, [sp, #-16]!
        bl      _parse_filespec
        bl      host_dir
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD LAST-INCLUDED, LAST-INCLUDED ( -- c-addr u ) path of the last included file, 0, XLAST_INCLUDED, XLAST_INCLUDED_END
XLAST_INCLUDED
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        add     x0, sp, #48
        add     x1, sp, #56
        bl      host_last_included
        ldr     x0, [sp, #48]
        ldr     x1, [sp, #56]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x20, [x22, #-8]!
        str     x0, [x22, #-8]!
        mov     x20, x1
XLAST_INCLUDED_END
        NEXT

        BOOT_WORD .INCLUDED, .INCLUDED ( -- ) list files registered by INCLUDE/REQUIRED, 0, XDOT_INCLUDED, 0
XDOT_INCLUDED
        stp     x29, x30, [sp, #-16]!
        bl      host_dot_included
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD (INCLUDE), (INCLUDE) ( -- ) bare INCLUDE opens a file dialog, 0, XINCLUDE_PAREN, 0
XINCLUDE_PAREN
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        add     x0, sp, #48
        bl      host_include_dialog
        cbz     x0, _inc_none
        str     x0, [sp, #56]
        ldr     x1, [sp, #48]
        str     x1, [sp, #64]
        adrp    x0, req_included_name
        add     x0, x0, req_included_name
        mov     x1, #8
        bl      _find_word
        cbz     x0, _inc_none
        ldr     x2, [sp, #64]
        ldr     x3, [sp, #56]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        str     x20, [x22, #-8]!
        str     x2, [x22, #-8]!
        mov     x20, x3
        mov     x21, x0
        ldr     x5, [x21]
        br      x5
_inc_none
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        NEXT

        BOOT_WORD REQUIRED, REQUIRED ( c-addr u -- ) INCLUDED unless this path was loaded, 0, XREQUIRED, 0
XREQUIRED
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x1, x20
        ldr     x0, [x22], #8
        cbz     x1, _req_drop
        adrp    x2, resolve_buf
        add     x2, x2, resolve_buf
        mov     x3, #256
        bl      host_resolve
        cbz     x0, _req_drop
        str     x0, [sp, #48]
        adrp    x0, resolve_buf
        add     x0, x0, resolve_buf
        ldr     x1, [sp, #48]
        bl      host_was_included
        cbnz    x0, _req_drop
        adrp    x0, req_included_name
        add     x0, x0, req_included_name
        mov     x1, #8
        bl      _find_word
        cbz     x0, _req_drop
        ldr     x1, [sp, #48]
        adrp    x2, resolve_buf
        add     x2, x2, resolve_buf
        str     x2, [x22, #-8]!
        mov     x20, x1
        mov     x21, x0
        ldr     x5, [x21]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        br      x5
_req_drop
        ldr     x20, [x22], #8
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

        BOOT_WORD FORGET, FORGET ( name -- ) remove that word and everything newer, 0, XFORGET, 0
XFORGET
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        bl      _next_word
        cbz     x1, _forget_empty
        stp     x0, x1, [sp, #48]
        bl      _find_word
        cbz     x0, _forget_undef
        adrp    x1, words_user_base
        add     x1, x1, words_user_base
        ldr     x1, [x1]
        cbnz    x1, _forget_fence
        adrp    x1, user_dict_area
        add     x1, x1, user_dict_area
_forget_fence
        cmp     x0, x1
        b.lo    _forget_prot
        adrp    x2, forget_cut
        add     x2, x2, forget_cut
        str     x0, [x2]
        adrp    x1, here_ptr
        add     x1, x1, here_ptr
        str     x0, [x1]
        adrp    x0, latest_var
        add     x0, x0, latest_var
        ldr     x1, [x2]
        bl      _prune_wid
        adrp    x3, current_var
        add     x3, x3, current_var
        ldr     x0, [x3]
        cbz     x0, _forget_search
        adrp    x2, forget_cut
        add     x2, x2, forget_cut
        ldr     x1, [x2]
        bl      _prune_wid
_forget_search
        adrp    x2, search_order_n
        add     x2, x2, search_order_n
        ldr     x2, [x2]
        adrp    x3, search_order
        add     x3, x3, search_order
        mov     x4, #0
_forget_sloop
        cmp     x4, x2
        b.hs    _forget_regs
        ldr     x0, [x3, x4, lsl #3]
        cbz     x0, _forget_snext
        stp     x2, x3, [sp, #-16]!
        stp     x4, xzr, [sp, #-16]!
        adrp    x1, forget_cut
        add     x1, x1, forget_cut
        ldr     x1, [x1]
        bl      _prune_wid
        ldp     x4, xzr, [sp], #16
        ldp     x2, x3, [sp], #16
_forget_snext
        add     x4, x4, #1
        b       _forget_sloop
_forget_regs
        adrp    x2, wordlist_reg_n
        add     x2, x2, wordlist_reg_n
        ldr     x2, [x2]
        adrp    x3, wordlist_reg
        add     x3, x3, wordlist_reg
        mov     x4, #0
_forget_rloop
        cmp     x4, x2
        b.hs    _forget_done
        ldr     x0, [x3, x4, lsl #3]
        cbz     x0, _forget_rnext
        stp     x2, x3, [sp, #-16]!
        stp     x4, xzr, [sp, #-16]!
        adrp    x1, forget_cut
        add     x1, x1, forget_cut
        ldr     x1, [x1]
        bl      _prune_wid
        ldp     x4, xzr, [sp], #16
        ldp     x2, x3, [sp], #16
_forget_rnext
        add     x4, x4, #1
        b       _forget_rloop
_forget_done
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        NEXT
_forget_prot
        adrp    x0, str_protected
        add     x0, x0, str_protected
        bl      emit_cstr
        b       _forget_done
_forget_empty
        adrp    x0, msg_huh
        add     x0, x0, msg_huh
        bl      emit_cstr
        b       _forget_done
_forget_undef
        ldp     x0, x1, [sp, #48]
        bl      emit_str
        adrp    x0, msg_huh
        add     x0, x0, msg_huh
        bl      emit_cstr
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        b       _quit_exit

; x0 = wid base. x1 = cut CFA. Unlink heads whose CFA is at or past the cut.
_prune_wid
        cbz     x0, _prune_ret
        mov     x3, x0
        mov     x4, x1
        mov     x5, #0
_prune_thread
        cmp     x5, #16
        b.hs    _prune_ret
        add     x0, x3, x5, lsl #3
_prune_head
        ldr     x2, [x0]
        cbz     x2, _prune_next
        cmp     x2, x4
        b.lo    _prune_next
        ldr     x2, [x2, #-16]
        str     x2, [x0]
        b       _prune_head
_prune_next
        add     x5, x5, #1
        b       _prune_thread
_prune_ret
        ret

        BOOT_WORD BLOCK-FILE, BLOCK-FILE ( -- addr ) current block fileid, 0, XBLOCK_FILE, 0
XBLOCK_FILE
        str     x20, [x22, #-8]!
        adrp    x0, block_file
        add     x0, x0, block_file
        mov     x20, x0
        NEXT

        BOOT_WORD (BLOCK-BUF), (BLOCK-BUF) ( -- addr ) 1024-byte block buffer, 0, XBLOCK_BUF, 0
XBLOCK_BUF
        str     x20, [x22, #-8]!
        adrp    x0, block_buf
        add     x0, x0, block_buf
        mov     x20, x0
        NEXT

        BOOT_WORD (BLOCK-UPD), (BLOCK-UPD) ( -- addr ) block-buffer dirty flag, 0, XBLOCK_UPD, 0
XBLOCK_UPD
        str     x20, [x22, #-8]!
        adrp    x0, block_upd
        add     x0, x0, block_upd
        mov     x20, x0
        NEXT

        BOOT_WORD (BLOCK-NR), (BLOCK-NR) ( -- addr ) current block number, 0, XBLOCK_NR, 0
XBLOCK_NR
        str     x20, [x22, #-8]!
        adrp    x0, block_nr
        add     x0, x0, block_nr
        mov     x20, x0
        NEXT

        BOOT_WORD BLK, BLK ( -- addr ) block being loaded or zero, 0, XBLK, 0
XBLK
        str     x20, [x22, #-8]!
        adrp    x0, blk_var
        add     x0, x0, blk_var
        mov     x20, x0
        NEXT

        BOOT_WORD SCR, SCR ( -- addr ) last listed block number, 0, XSCR, 0
XSCR
        str     x20, [x22, #-8]!
        adrp    x0, scr_var
        add     x0, x0, scr_var
        mov     x20, x0
        NEXT

        BOOT_WORD (LOAD-ENTER), (LOAD-ENTER) ( u -- u ) save SOURCE and set BLK, 0, XLOAD_ENTER, 0
XLOAD_ENTER
        stp     x29, x30, [sp, #-16]!
        bl      _push_source
        ldp     x29, x30, [sp], #16
        adrp    x0, blk_var
        add     x0, x0, blk_var
        str     x20, [x0]
        NEXT

        BOOT_WORD (LOAD-RUN), (LOAD-RUN) ( c-addr u -- ) interpret a block buffer, 0, XLOAD_RUN, 0
XLOAD_RUN
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        stp     x0, x1, [sp, #48]
        ldp     x0, x1, [sp, #48]
        adrp    x2, source_base
        add     x2, x2, source_base
        str     x0, [x2]
        adrp    x2, source_cur
        add     x2, x2, source_cur
        str     x0, [x2]
        add     x0, x0, x1
        adrp    x2, source_end
        add     x2, x2, source_end
        str     x0, [x2]
        adrp    x2, to_in
        add     x2, x2, to_in
        str     xzr, [x2]
        adrp    x2, line_mode
        add     x2, x2, line_mode
        str     xzr, [x2]
        adrp    x2, source_id
        add     x2, x2, source_id
        mov     x3, #-1
        str     x3, [x2]
        bl      _eval_resume_push
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        b       _interpret_loop

        BOOT_WORD ], ] ( -- ) enter compile mode, 0, XRBRA, 0
XRBRA
        adrp    x0, state_var
        add     x0, x0, state_var
        mov     x1, #1
        str     x1, [x0]
        NEXT

        BOOT_WORD [, [ ( -- ) enter interpret mode, FLAG_IMM, XLBRA, 0
XLBRA
        adrp    x0, state_var
        add     x0, x0, state_var
        str     xzr, [x0]
        NEXT

        BOOT_WORD EVALUATE, EVALUATE ( i*x c-addr u -- j*x ) interpret the string as Forth source, 0, XEVALUATE, 0
XEVALUATE
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        stp     x0, x1, [sp, #48]
        bl      _push_source
        cbz     x0, _ev_fail
        ldp     x0, x1, [sp, #48]
        adrp    x2, source_base
        add     x2, x2, source_base
        str     x0, [x2]
        adrp    x2, source_cur
        add     x2, x2, source_cur
        str     x0, [x2]
        add     x0, x0, x1
        adrp    x2, source_end
        add     x2, x2, source_end
        str     x0, [x2]
        adrp    x2, to_in
        add     x2, x2, to_in
        str     xzr, [x2]
        adrp    x2, line_mode
        add     x2, x2, line_mode
        str     xzr, [x2]
        adrp    x2, source_id
        add     x2, x2, source_id
        mov     x3, #-1
        str     x3, [x2]
        adrp    x2, blk_var
        add     x2, x2, blk_var
        str     xzr, [x2]
        bl      _eval_resume_push
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        b       _interpret_loop
_ev_fail
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        NEXT

        BOOT_WORD QUIT, QUIT ( -- ) empty the return stack and return to the outer interpreter, 0, XQUIT, XQUIT_END
XQUIT
        b       _do_quit
XQUIT_END

        BOOT_WORD_BS_S  stop the rest of this source, FLAG_IMM, XBACKSLASH_S, 0
XBACKSLASH_S
        adrp    x0, line_mode
        add     x0, x0, line_mode
        ldr     x0, [x0]
        cbz     x0, _bs_pin
        adrp    x0, line_limit
        add     x0, x0, line_limit
        ldr     x1, [x0]
        adrp    x0, line_next
        add     x0, x0, line_next
        str     x1, [x0]
_bs_pin
        adrp    x0, source_base
        add     x0, x0, source_base
        ldr     x0, [x0]
        adrp    x1, source_end
        add     x1, x1, source_end
        ldr     x1, [x1]
        sub     x2, x1, x0
        adrp    x0, to_in
        add     x0, x0, to_in
        str     x2, [x0]
        adrp    x0, source_cur
        add     x0, x0, source_cur
        str     x1, [x0]
        NEXT

        BOOT_WORD SOURCE-ID, SOURCE-ID ( -- id ) 0 console -1 evaluate -2 file, 0, XSOURCE_ID, 0
XSOURCE_ID
        adrp    x0, source_id
        add     x0, x0, source_id
        ldr     x0, [x0]
        DPUSH
        NEXT

        BOOT_WORD ACCEPT, ACCEPT ( c-addr +n1 -- +n2 ) read a line into the buffer, 0, XACCEPT, XACCEPT_END
XACCEPT
        mov     x1, x20
        ldr     x0, [x22], #8
        cmp     x1, #0
        b.gt    _acc_read
        mov     x20, #0
        b       XACCEPT_END
_acc_read
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      host_accept
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        mov     x20, x0
XACCEPT_END
        NEXT

        BOOT_WORD >NUMBER, >NUMBER ( ud1 c-addr1 u1 -- ud2 c-addr2 u2 ) convert digits in the current base, 0, XTONUMBER, XTONUMBER_END
XTONUMBER
        mov     x4, x20
        ldr     x3, [x22], #8
        ldr     x2, [x22], #8
        ldr     x1, [x22], #8
        adrp    x5, base_var
        add     x5, x5, base_var
        ldr     x5, [x5]
        cmp     x5, #2
        b.lo    _tn_base10
        cmp     x5, #36
        b.ls    _tn_loop
_tn_base10
        mov     x5, #10
_tn_loop
        cbz     x4, _tn_done
        ldrb    w6, [x3]
        sub     w7, w6, #48
        cmp     w7, #9
        b.ls    _tn_dig
        cmp     w6, #'a'
        b.lo    _tn_up
        cmp     w6, #'z'
        b.hi    _tn_done
        sub     w6, w6, #32
_tn_up
        sub     w7, w6, #'A'
        cmp     w7, #25
        b.hi    _tn_done
        add     w7, w7, #10
_tn_dig
        cmp     x7, x5
        b.hs    _tn_done
        mul     x8, x1, x5
        umulh   x9, x1, x5
        mul     x10, x2, x5
        add     x9, x9, x10
        adds    x1, x8, x7
        adc     x2, x9, xzr
        add     x3, x3, #1
        sub     x4, x4, #1
        b       _tn_loop
_tn_done
        str     x1, [x22, #-8]!
        str     x2, [x22, #-8]!
        str     x3, [x22, #-8]!
        mov     x20, x4
XTONUMBER_END
        NEXT

ENV_COUNT       EQU 31

        BOOT_WORD ENVIRONMENT?, ENVIRONMENT? ( c-addr u -- false | i*x true ) query an environment string, 0, XENVIRONMENT_Q, 0
XENVIRONMENT_Q
        mov     x1, x20
        ldr     x0, [x22], #8
        mov     x4, #0
_env_next
        cmp     x4, #ENV_COUNT
        b.hs    _env_no
        adrp    x5, env_name_ptrs
        add     x5, x5, env_name_ptrs
        ldr     x5, [x5, x4, lsl #3]
        mov     x6, #0
_env_len
        ldrb    w7, [x5, x6]
        cbz     w7, _env_len_done
        add     x6, x6, #1
        b       _env_len
_env_len_done
        cmp     x6, x1
        b.ne    _env_cont
        mov     x7, #0
_env_cmp
        cmp     x7, x6
        b.eq    _env_yes
        ldrb    w8, [x5, x7]
        ldrb    w9, [x0, x7]
        cmp     w8, w9
        b.ne    _env_cont
        add     x7, x7, #1
        b       _env_cmp
_env_cont
        add     x4, x4, #1
        b       _env_next
_env_yes
        adrp    x5, env_kinds
        add     x5, x5, env_kinds
        ldrb    w5, [x5, x4]
        adrp    x6, env_values
        add     x6, x6, env_values
        ldr     x6, [x6, x4, lsl #3]
        cbz     w5, _env_flag
        cmp     w5, #2
        b.eq    _env_string
        str     x6, [x22, #-8]!
        mov     x20, #-1
        NEXT
_env_string
        mov     x0, #0
_env_slen
        ldrb    w1, [x6, x0]
        cbz     w1, _env_spush
        add     x0, x0, #1
        b       _env_slen
_env_spush
        str     x6, [x22, #-8]!
        str     x0, [x22, #-8]!
        mov     x20, #-1
        NEXT
_env_flag
        mov     x20, x6
        NEXT
_env_no
        mov     x20, #0
        NEXT

        BOOT_WORD SAVE-INPUT, SAVE-INPUT ( -- xn .. x1 n ) save the current input source, 0, XSAVE_INPUT, 0
XSAVE_INPUT
        str     x20, [x22, #-8]!
        adrp    x0, source_base
        add     x0, x0, source_base
        ldr     x20, [x0]
        str     x20, [x22, #-8]!
        adrp    x1, source_end
        add     x1, x1, source_end
        ldr     x1, [x1]
        sub     x20, x1, x20
        str     x20, [x22, #-8]!
        adrp    x0, to_in
        add     x0, x0, to_in
        ldr     x20, [x0]
        str     x20, [x22, #-8]!
        adrp    x0, source_id
        add     x0, x0, source_id
        ldr     x20, [x0]
        str     x20, [x22, #-8]!
        adrp    x0, blk_var
        add     x0, x0, blk_var
        ldr     x20, [x0]
        str     x20, [x22, #-8]!
        mov     x20, #5
        NEXT

        BOOT_WORD RESTORE-INPUT, RESTORE-INPUT ( xn .. x1 n -- flag ) restore input source. 0 means ok, 0, XRESTORE_INPUT, 0
XRESTORE_INPUT
        cmp     x20, #5
        b.eq    _ri_n5
        cmp     x20, #4
        b.ne    _ri_fail
        mov     x5, #0
        b       _ri_common
_ri_n5
        ldr     x5, [x22], #8
_ri_common
        ldr     x0, [x22], #8
        ldr     x1, [x22], #8
        ldr     x2, [x22], #8
        ldr     x3, [x22], #8
        ldr     x20, [x22], #8
        adrp    x4, blk_var
        add     x4, x4, blk_var
        str     x5, [x4]
        cbz     x5, _ri_apply
        sub     sp, sp, #64
        stp     x29, x30, [sp, #16]
        stp     x0, x1, [sp, #32]
        str     x20, [sp, #48]
        mov     x0, x5
        bl      _block_load_nr
        ldp     x0, x1, [sp, #32]
        ldr     x20, [sp, #48]
        ldp     x29, x30, [sp, #16]
        add     sp, sp, #64
        adrp    x3, block_buf
        add     x3, x3, block_buf
        mov     x2, #1024
_ri_apply
        adrp    x4, source_base
        add     x4, x4, source_base
        str     x3, [x4]
        adrp    x4, source_cur
        add     x4, x4, source_cur
        add     x6, x3, x1
        str     x6, [x4]
        add     x6, x3, x2
        adrp    x4, source_end
        add     x4, x4, source_end
        str     x6, [x4]
        adrp    x4, to_in
        add     x4, x4, to_in
        str     x1, [x4]
        adrp    x4, source_id
        add     x4, x4, source_id
        str     x0, [x4]
        adrp    x4, line_mode
        add     x4, x4, line_mode
        ldr     x4, [x4]
        cbz     x4, _ri_ok
        adrp    x4, line_limit
        add     x4, x4, line_limit
        ldr     x5, [x4]
        add     x3, x3, x2
        cmp     x3, x5
        b.hs    _ri_next
        ldrb    w4, [x3]
        cmp     w4, #10
        b.eq    _ri_nl
        cmp     w4, #13
        b.ne    _ri_next
        add     x4, x3, #1
        cmp     x4, x5
        b.hs    _ri_next
        ldrb    w6, [x4]
        cmp     w6, #10
        b.ne    _ri_next
        add     x3, x4, #1
        b       _ri_next
_ri_nl
        add     x3, x3, #1
_ri_next
        adrp    x4, line_next
        add     x4, x4, line_next
        str     x3, [x4]
_ri_ok
        str     x20, [x22, #-8]!
        mov     x20, #0
        NEXT
_ri_fail
        mov     x1, x20
        ldr     x20, [x22], #8
_ri_drop
        cbz     x1, _ri_bad
        ldr     x20, [x22], #8
        sub     x1, x1, #1
        b       _ri_drop
_ri_bad
        str     x20, [x22, #-8]!
        mov     x20, #-1
        NEXT

        BOOT_WORD N>R, N>R ( xn .. x1 n -- ) ( R: -- xn .. x1 n ) move n items and the count to the return stack, 0, XNTOR, 0
XNTOR
        mov     x5, x20
        mov     x1, x5
_ntor_loop
        cbz     x1, _ntor_count
        ldr     x2, [x22], #8
        str     x2, [x23, #-8]!
        sub     x1, x1, #1
        b       _ntor_loop
_ntor_count
        str     x5, [x23, #-8]!
        ldr     x20, [x22], #8
        NEXT

        BOOT_WORD NR>, NR> ( -- xn .. x1 n ) ( R: xn .. x1 n -- ) restore n items and the count, 0, XNRFROM, 0
XNRFROM
        ldr     x5, [x23], #8
        str     x20, [x22, #-8]!
        mov     x1, x5
_nrfrom_loop
        cbz     x1, _nrfrom_count
        ldr     x2, [x23], #8
        str     x2, [x22, #-8]!
        sub     x1, x1, #1
        b       _nrfrom_loop
_nrfrom_count
        mov     x20, x5
        NEXT

        BOOT_WORD CS-PICK, CS-PICK ( i*x u -- i*x x_u ) copy the uth control-flow item, 0, XCSPICK, 0
XCSPICK
        b       XPICK

        BOOT_WORD CS-ROLL, CS-ROLL ( xu .. x0 u -- xu-1 .. x0 xu ) rotate the uth control-flow item to the top, 0, XCSROLL, 0
XCSROLL
        b       XROLL

        BOOT_WORD NAME>INTERPRET, NAME>INTERPRET ( nt -- xt | 0 ) interpretation xt for a name token, 0, XNAME_INTERPRET, 0
XNAME_INTERPRET
        NEXT

        BOOT_WORD NAME>COMPILE, NAME>COMPILE ( nt -- x xt ) compilation semantics pair for a name token, 0, XNAME_COMPILE, 0
XNAME_COMPILE
        mov     x5, x20
        ldr     x0, [x5, #-8]
        tbnz    x0, #63, _nc_imm
        adrp    x1, cfa_comma
        add     x1, x1, cfa_comma
        ldr     x1, [x1]
        str     x5, [x22, #-8]!
        mov     x20, x1
        NEXT
_nc_imm
        adrp    x1, cfa_execute
        add     x1, x1, cfa_execute
        ldr     x1, [x1]
        str     x5, [x22, #-8]!
        mov     x20, x1
        NEXT

        BOOT_WORD LIBRARY-PATH, LIBRARY-PATH ( -- c-addr u ) absolute Library directory, 0, XLIBRARY_PATH, XLIBRARY_PATH_END
XLIBRARY_PATH
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        adrp    x0, library_path_buf
        add     x0, x0, library_path_buf
        mov     x1, #1024
        bl      host_library_path
        mov     x1, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        adrp    x0, library_path_buf
        add     x0, x0, library_path_buf
        str     x20, [x22, #-8]!
        mov     x20, x0
        str     x20, [x22, #-8]!
        mov     x20, x1
XLIBRARY_PATH_END
        NEXT

        BOOT_WORD PAGE, PAGE ( -- ) clear facility terminal and home cursor, 0, XPAGE, XPAGE_END
XPAGE
        mov     x0, #1
        mov     x1, #0
        mov     x2, #0
        b       _facility_op_go
XPAGE_END

        BOOT_WORD AT-XY, AT-XY ( u1 u2 -- ) facility cursor to column u1 row u2, 0, XAT_XY, XAT_XY_END
XAT_XY
        mov     x2, x20
        ldr     x1, [x22], #8
        ldr     x20, [x22], #8
        mov     x0, #2
        b       _facility_op_go
XAT_XY_END

        BOOT_WORD AT-XY?, AT-XY? ( -- col row ) facility cursor position, 0, XAT_XY_Q, XAT_XY_Q_END
XAT_XY_Q
        sub     sp, sp, #32
        stp     x29, x30, [sp, #16]
        mov     x0, sp
        add     x1, sp, #8
        str     xzr, [sp]
        str     xzr, [sp, #8]
        bl      host_facility_xy
        ldr     x1, [sp]
        ldr     x2, [sp, #8]
        ldp     x29, x30, [sp, #16]
        add     sp, sp, #32
        str     x20, [x22, #-8]!
        mov     x20, x1
        str     x20, [x22, #-8]!
        mov     x20, x2
XAT_XY_Q_END
        NEXT

        BOOT_WORD CLIP!, CLIP! ( c-addr u -- ) set host clipboard, 0, XCLIP_STORE, XCLIP_STORE_END
XCLIP_STORE
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_clip_set
        ldp     x29, x30, [sp], #16
        NEXT
XCLIP_STORE_END

        BOOT_WORD CLIP@, CLIP@ ( c-addr max -- u ) fetch host clipboard, 0, XCLIP_FETCH, XCLIP_FETCH_END
XCLIP_FETCH
        mov     x1, x20
        ldr     x0, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_clip_get
        ldp     x29, x30, [sp], #16
        mov     x20, x0
        NEXT
XCLIP_FETCH_END

        BOOT_WORD TERMINAL-REFRESH, TERMINAL-REFRESH ( -- ) paint facility terminal to host console, 0, XTERM_REFRESH, 0
XTERM_REFRESH
        mov     x0, #3
        mov     x1, #0
        mov     x2, #0
        b       _facility_op_go

        BOOT_WORD FACILITY-OFF, FACILITY-OFF ( -- ) leave facility terminal mode, 0, XFACILITY_OFF, 0
XFACILITY_OFF
        mov     x0, #4
        mov     x1, #0
        mov     x2, #0
        b       _facility_op_go

        BOOT_WORD (FACILITY-SIZE), (FACILITY-SIZE) ( cols rows -- ) resize facility terminal grid, 0, XFACILITY_SIZE, XFACILITY_SIZE_END
XFACILITY_SIZE
        mov     x2, x20
        ldr     x1, [x22], #8
        ldr     x20, [x22], #8
        mov     x0, #5
        b       _facility_op_go
XFACILITY_SIZE_END

        BOOT_WORD FACILITY-REV, FACILITY-REV ( f -- ) reverse-video on or off for facility EMIT, 0, XFACILITY_REV, XFACILITY_REV_END
XFACILITY_REV
        mov     x1, x20
        ldr     x20, [x22], #8
        mov     x0, #6
        mov     x2, #0
        b       _facility_op_go
XFACILITY_REV_END

        BOOT_WORD (XFACILITY-OP-GO), (XFACILITY-OP-GO) ( -- ) facility host hook x0=op x1 x2=args, 0, XFACILITY_OP_GO, XFACILITY_OP_GO_END
XFACILITY_OP_GO
_facility_op_go
        adrp    x9, facility_op_hook
        add     x9, x9, facility_op_hook
        ldr     x9, [x9]
        cbz     x9, fac_op_done
        stp     x29, x30, [sp, #-16]!
        blr     x9
        ldp     x29, x30, [sp], #16
fac_op_done
XFACILITY_OP_GO_END
        NEXT

; x0 = arg, x1 = dsp, x2 = code. Returns the native x0. Restores the VM
; registers a leaf is allowed to scratch, including x19.
_call_native_regs
        stp     x29, x30, [sp, #-128]!
        stp     x19, x20, [sp, #16]
        stp     x21, x22, [sp, #32]
        stp     x23, x24, [sp, #48]
        stp     x28, x18, [sp, #64]
        stp     x0, x1, [sp, #80]
        str     x2, [sp, #96]
        mov     x0, x2
        mov     x1, #64
        bl      host_icache_inval
        ldp     x0, x1, [sp, #80]
        ldr     x2, [sp, #96]
        mov     x19, x1
        blr     x2
        ldp     x28, x18, [sp, #64]
        ldp     x23, x24, [sp, #48]
        ldp     x21, x22, [sp, #32]
        ldp     x19, x20, [sp, #16]
        ldp     x29, x30, [sp], #128
        ret

        BOOT_WORD MPROTECT, MPROTECT ( addr u prot -- ior ) protect pages prot 1=R 2=W 4=X, 0, XMPROTECT, 0
XMPROTECT
        mov     x2, x20
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_mprotect
        ldp     x29, x30, [sp], #16
        mov     x20, x0
        NEXT

        BOOT_WORD ICACHE-INVAL, ICACHE-INVAL ( addr u -- ) flush the instruction cache for a range, 0, XICACHE_INVAL, 0
XICACHE_INVAL
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_icache_inval
        ldp     x29, x30, [sp], #16
        NEXT

        BOOT_WORD CALL-NATIVE, CALL-NATIVE ( x0 dsp code -- x0' ) call native code and save the VM, 0, XCALL_NATIVE, 0
XCALL_NATIVE
        mov     x2, x20
        ldr     x1, [x22], #8
        ldr     x0, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      _call_native_regs
        ldp     x29, x30, [sp], #16
        mov     x20, x0
        NEXT

        BOOT_WORD CALL-NATIVE-LEAF, CALL-NATIVE-LEAF ( code -- x0' ) call code with x0=0 and a BSS DSP, 0, XCALL_NATIVE_LEAF, 0
XCALL_NATIVE_LEAF
        mov     x2, x20
        adrp    x1, native_dsp_end
        add     x1, x1, native_dsp_end
        sub     x1, x1, #64
        mov     x0, #0
        stp     x29, x30, [sp, #-16]!
        bl      _call_native_regs
        ldp     x29, x30, [sp], #16
        mov     x20, x0
        NEXT

        BOOT_WORD ALLOCATE-EXEC, ALLOCATE-EXEC ( u -- a-addr ior ) RW buffer for later R+X, 0, XALLOCATE_EXEC, 0
XALLOCATE_EXEC
        mov     x0, x20
        cbnz    x0, _ax_size
        mov     x0, #0x1000
_ax_size
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        add     x1, sp, #48
        str     xzr, [sp, #48]
        bl      host_alloc_exec
        ldr     x1, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        str     x1, [x22, #-8]!
        mov     x20, x0
        NEXT

        BOOT_WORD FREE-EXEC, FREE-EXEC ( a-addr u -- ior ) release an ALLOCATE-EXEC buffer, 0, XFREE_EXEC, 0
XFREE_EXEC
        mov     x1, x20
        ldr     x0, [x22], #8
        stp     x29, x30, [sp, #-16]!
        bl      host_free_exec
        ldp     x29, x30, [sp], #16
        mov     x20, x0
        NEXT

        BOOT_WORD JIT-WPROTECT, JIT-WPROTECT ( f -- ) record write or execute mode for this thread, 0, XJIT_WPROTECT, 0
XJIT_WPROTECT
        cmp     x20, #0
        cset    x1, ne
        adrp    x0, jit_exec_mode
        add     x0, x0, jit_exec_mode
        str     x1, [x0]
        ldr     x20, [x22], #8
        NEXT

        BOOT_WORD NATIVE-SMOKE, NATIVE-SMOKE ( -- ior ) test RW map then RX call, 0, XNATIVE_SMOKE, 0
XNATIVE_SMOKE
        sub     sp, sp, #96
        stp     x29, x30, [sp, #32]
        mov     x0, #0x1000
        add     x1, sp, #48
        str     xzr, [sp, #48]
        bl      host_alloc_exec
        cbnz    x0, _ns_bad
        ldr     x0, [sp, #48]
        str     x0, [sp, #56]
        bl      host_native_ret7
        ldr     x0, [sp, #56]
        mov     x1, #0x1000
        mov     x2, #5
        bl      host_mprotect
        cbnz    x0, _ns_free
        ldr     x0, [sp, #56]
        mov     x1, #0x1000
        bl      host_icache_inval
        mov     x0, #0
        adrp    x1, native_dsp_end
        add     x1, x1, native_dsp_end
        sub     x1, x1, #64
        ldr     x2, [sp, #56]
        bl      _call_native_regs
        str     x0, [sp, #64]
        ldr     x0, [sp, #56]
        mov     x1, #0x1000
        bl      host_free_exec
        cbnz    x0, _ns_bad
        ldr     x0, [sp, #64]
        cmp     x0, #7
        b.ne    _ns_bad
        mov     x0, #0
        b       _ns_out
_ns_free
        ldr     x0, [sp, #56]
        mov     x1, #0x1000
        bl      host_free_exec
_ns_bad
        mov     x0, #-1
_ns_out
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        str     x20, [x22, #-8]!
        mov     x20, x0
        NEXT

next_debug_gate
        adrp    x16, next_debug
        add     x16, x16, next_debug
        br      x16

        AREA |.rdata|, DATA, READONLY

req_included_name DCB   "INCLUDED"
str_protected   DCB     "protected (system word)", 10, 0
str_gmm_already DCB     "? GROWMEMORYMB already used (once per session)", 10, 0
str_gmm_small   DCB     "? GROWMEMORYMB needs at least 1 MB", 10, 0
str_gmm_big     DCB     "? GROWMEMORYMB exceeds maximum (256 MB)", 10, 0
str_gmm_shrink  DCB     "? GROWMEMORYMB cannot shrink memory", 10, 0
str_bang        DCB     "!", 0
str_twostore    DCB     "2!", 0
str_twofetch    DCB     "2@", 0
str_type        DCB     "TYPE", 0

; ENVIRONMENT? rows. Kind 1 returns the value then true. Kind 2 returns
; a string then true. A zero value still means the query was found.
        ALIGN 8
env_name_ptrs
        DCQ     env_n_counted
        DCQ     env_n_aub
        DCQ     env_n_core
        DCQ     env_n_core_ext
        DCQ     env_n_floored
        DCQ     env_n_maxchar
        DCQ     env_n_maxn
        DCQ     env_n_maxu
        DCQ     env_n_rstack
        DCQ     env_n_stack
        DCQ     env_n_floating
        DCQ     env_n_float_ext
        DCQ     env_n_floating_stack
        DCQ     env_n_max_float
        DCQ     env_n_string
        DCQ     env_n_facility
        DCQ     env_n_facility_ext
        DCQ     env_n_locals
        DCQ     env_n_nlocals
        DCQ     env_n_xchar
        DCQ     env_n_xchar_enc
        DCQ     env_n_max_xchar
        DCQ     env_n_xchar_maxmem
        DCQ     env_n_double
        DCQ     env_n_exception
        DCQ     env_n_mem
        DCQ     env_n_search
        DCQ     env_n_wordlists
        DCQ     env_n_block
        DCQ     env_n_file
        DCQ     env_n_file_ext
env_values
        DCQ     255
        DCQ     8
        DCQ     -1
        DCQ     -1
        DCQ     0
        DCQ     255
        DCQ     0x7FFFFFFFFFFFFFFF
        DCQ     -1
        DCQ     512
        DCQ     512
        DCQ     -1
        DCQ     -1
        DCQ     16
        DCQ     0x7FEFFFFFFFFFFFFF
        DCQ     -1
        DCQ     0
        DCQ     0
        DCQ     -1
        DCQ     32
        DCQ     0
        DCQ     env_s_utf8
        DCQ     0x10FFFF
        DCQ     4
        DCQ     -1
        DCQ     -1
        DCQ     -1
        DCQ     -1
        DCQ     8
        DCQ     -1
        DCQ     -1
        DCQ     -1
env_kinds
        DCB     1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
        DCB     2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
env_n_counted   DCB "/COUNTED-STRING", 0
env_n_aub       DCB "ADDRESS-UNIT-BITS", 0
env_n_core      DCB "CORE", 0
env_n_core_ext  DCB "CORE-EXT", 0
env_n_floored   DCB "FLOORED", 0
env_n_maxchar   DCB "MAX-CHAR", 0
env_n_maxn      DCB "MAX-N", 0
env_n_maxu      DCB "MAX-U", 0
env_n_rstack    DCB "RETURN-STACK-CELLS", 0
env_n_stack     DCB "STACK-CELLS", 0
env_n_floating  DCB "FLOATING", 0
env_n_float_ext DCB "FLOAT-EXT", 0
env_n_floating_stack DCB "FLOATING-STACK", 0
env_n_max_float DCB "MAX-FLOAT", 0
env_n_string    DCB "STRING", 0
env_n_facility  DCB "FACILITY", 0
env_n_facility_ext DCB "FACILITY-EXT", 0
env_n_locals    DCB "LOCALS", 0
env_n_nlocals   DCB "#LOCALS", 0
env_n_xchar     DCB "EXTENDED-CHARACTER", 0
env_n_xchar_enc DCB "XCHAR-ENCODING", 0
env_n_max_xchar DCB "MAX-XCHAR", 0
env_n_xchar_maxmem DCB "XCHAR-MAXMEM", 0
env_n_double    DCB "DOUBLE", 0
env_n_exception DCB "EXCEPTION", 0
env_n_mem       DCB "MEMORY-ALLOCATION", 0
env_n_search    DCB "SEARCH-ORDER", 0
env_n_wordlists DCB "WORDLISTS", 0
env_n_block     DCB "BLOCK", 0
env_n_file      DCB "FILE", 0
env_n_file_ext  DCB "FILE-EXT", 0
env_s_utf8      DCB "UTF-8", 0

        END
