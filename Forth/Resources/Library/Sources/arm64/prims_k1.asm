; Primitives kernel1.fth compiles and runs. Labels and end marks match
; the Mac kernel. An end argument of 0 means the Mac catalog has no end label.

        INCLUDE Forth/kernel/arm64/vm.inc

        EXTERN next_debug
        EXTERN debug_break_asap
        INCLUDE Forth/kernel/arm64/boot_words.inc

        AREA |.text|, CODE, READONLY, ALIGN=4

        EXTERN source_base
        EXTERN source_cur
        EXTERN source_end
        EXTERN to_in
        EXTERN blk_var
        EXTERN _cursor_load
        EXTERN _cursor_commit
        EXTERN _take_line
        EXTERN line_mode
        EXTERN throw_handler
        EXTERN here_ptr
        EXTERN user_dict_size_cell
        EXTERN xchar_emit_buf
        EXTERN state_var
        EXTERN last_cfa
        EXTERN base_var
        EXTERN current_var
        EXTERN search_order
        EXTERN search_order_n
        EXTERN latest_var
        EXTERN data_stack
        EXTERN user_dict_area
        EXTERN word_scratch
        EXTERN pending_help_addr
        EXTERN pending_help_len
        EXTERN cfa_lit
        EXTERN cfa_branch
        EXTERN cfa_0branch
        EXTERN cfa_does
        EXTERN cfa_slit
        EXTERN cfa_cstr
        EXTERN pad_buffer
        EXTERN wordlist_reg
        EXTERN wordlist_reg_n
        EXTERN DOCOL
        EXTERN _next_word
        EXTERN _find_word
        EXTERN _compile_cell
        EXTERN _header_build
        EXTERN _nfa_reveal_cfa
        EXTERN _take_pending_help
        EXTERN emit_str
        EXTERN emit_cstr
        EXTERN _putchar
        EXTERN _print_wid_name
        EXTERN _print_signed
        EXTERN _quit_exit
        EXTERN _throw_unwind_to_sp
        EXTERN eval_resume_sp

        EXPORT DOVAR
        EXPORT DOCON
        EXPORT DODOES
        EXPORT XTHROW
        EXPORT XBranch
        EXPORT X0Branch
        EXPORT XTYPE
        EXPORT msg_allot

; ---------------------------------------------------------------------
; Stack, logic, memory
; ---------------------------------------------------------------------

        BOOT_WORD ?DUP, ?DUP ( n -- n n | 0 ) dup if non-zero, 0, XQDUP, XQDUP_END
XQDUP
        cbz     x20, XQDUP_END
        str     x20, [x22, #-8]!
XQDUP_END
        NEXT

        BOOT_WORD ROT, ROT ( a b c -- b c a ) rotate top three, 0, XROT, XROT_END
XROT
        ldr     x0, [x22]
        ldr     x1, [x22, #8]
        str     x0, [x22, #8]
        str     x20, [x22]
        mov     x20, x1
XROT_END
        NEXT

        BOOT_WORD -ROT, -ROT ( a b c -- c a b ) reverse-rotate top three, 0, XNROT, XNROT_END
XNROT
        ldr     x0, [x22]
        ldr     x1, [x22, #8]
        str     x20, [x22, #8]
        str     x1, [x22]
        mov     x20, x0
XNROT_END
        NEXT

        EXPORT XROLL
        BOOT_WORD ROLL, ROLL ( xu ... x0 u -- xu ) move the uth cell to TOS, 0, XROLL, XROLL_END
XROLL
        mov     x1, x20
        ldr     x20, [x22], #8
        cbz     x1, XROLL_END
        sub     x2, x1, #1
        lsl     x2, x2, #3
        ldr     x3, [x22, x2]
        mov     x0, x20
        mov     x4, x2
_roll_shift
        cbz     x4, _roll_put
        sub     x5, x4, #8
        ldr     x6, [x22, x5]
        str     x6, [x22, x4]
        mov     x4, x5
        b       _roll_shift
_roll_put
        str     x0, [x22]
        mov     x20, x3
XROLL_END
        NEXT

        BOOT_WORD NIP, NIP ( x1 x2 -- x2 ) drop the cell under TOS, 0, XNIP, XNIP_END
XNIP
        ldr     x0, [x22], #8
XNIP_END
        NEXT

        BOOT_WORD >R, >R ( n -- ) ( R: -- n ) to return stack, 0, XTOR, XTOR_END
XTOR
        str     x20, [x23, #-8]!
        ldr     x20, [x22], #8
XTOR_END
        NEXT

        BOOT_WORD R>, R> ( -- n ) ( R: n -- ) from return stack, 0, XRTO, XRTO_END
XRTO
        str     x20, [x22, #-8]!
        ldr     x20, [x23], #8
XRTO_END
        NEXT

        BOOT_WORD R@, R@ ( -- n ) ( R: n -- n ) copy top of return stack, 0, XRFETCH, XRFETCH_END
XRFETCH
        str     x20, [x22, #-8]!
        ldr     x20, [x23]
XRFETCH_END
        NEXT

        BOOT_WORD 1+, 1+ ( n -- n+1 ) increment, 0, XONEPLUS, XONEPLUS_END
XONEPLUS
        add     x20, x20, #1
XONEPLUS_END
        NEXT

        BOOT_WORD AND, AND ( n1 n2 -- n ) bitwise and, 0, XAND, XAND_END
XAND
        ldr     x0, [x22], #8
        and     x20, x20, x0
XAND_END
        NEXT

        BOOT_WORD OR, OR ( n1 n2 -- n ) bitwise or, 0, XORR, XORR_END
XORR
        ldr     x0, [x22], #8
        orr     x20, x20, x0
XORR_END
        NEXT

        BOOT_WORD INVERT, INVERT ( n -- ~n ) bitwise invert, 0, XINVERT, XINVERT_END
XINVERT
        mvn     x20, x20
XINVERT_END
        NEXT

        BOOT_WORD RSHIFT, RSHIFT ( n bits -- n ) logical right shift, 0, XRSHIFT, XRSHIFT_END
XRSHIFT
        ldr     x0, [x22], #8
        lsr     x20, x0, x20
XRSHIFT_END
        NEXT

        BOOT_WORD =, = ( n1 n2 -- flag ) equal, 0, XEQUAL, XEQUAL_END
XEQUAL
        ldr     x0, [x22], #8
        cmp     x0, x20
        csetm   x20, eq
XEQUAL_END
        NEXT

        BOOT_WORD <, < ( n1 n2 -- flag ) less than, 0, XLESS, XLESS_END
XLESS
        ldr     x0, [x22], #8
        cmp     x0, x20
        csetm   x20, lt
XLESS_END
        NEXT

        BOOT_WORD >, > ( n1 n2 -- flag ) greater than, 0, XGREATER, XGREATER_END
XGREATER
        ldr     x0, [x22], #8
        cmp     x0, x20
        csetm   x20, gt
XGREATER_END
        NEXT

        BOOT_WORD 0=, 0= ( n -- flag ) zero?, 0, XZEQUAL, XZEQUAL_END
XZEQUAL
        cmp     x20, #0
        csetm   x20, eq
XZEQUAL_END
        NEXT

        BOOT_WORD @, @ ( addr -- n ) fetch cell, 0, XFETCH, XFETCH_END
XFETCH
        ldr     x20, [x20]
XFETCH_END
        NEXT

        BOOT_WORD !, ! ( n addr -- ) store cell, 0, XSTORE, XSTORE_END
XSTORE
        ldr     x0, [x22], #8
        str     x0, [x20]
        ldr     x20, [x22], #8
XSTORE_END
        NEXT

        BOOT_WORD C@, C@ ( addr -- byte ) fetch byte, 0, XCFETCH, XCFETCH_END
XCFETCH
        ldrb    w20, [x20]
XCFETCH_END
        NEXT

        BOOT_WORD C!, C! ( byte addr -- ) store byte, 0, XCSTORE, XCSTORE_END
XCSTORE
        ldr     x0, [x22], #8
        strb    w0, [x20]
        ldr     x20, [x22], #8
XCSTORE_END
        NEXT

        BOOT_WORD BL, BL ( -- c ) ASCII blank, 0, XBL, XBL_END
XBL
        mov     x0, #32
        DPUSH
XBL_END
        NEXT

        BOOT_WORD EMIT, EMIT ( c -- ) emit one character, 0, XEMIT, XEMIT_END
XEMIT
        mov     x0, x20
        ldr     x20, [x22], #8
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _putchar
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XEMIT_END
        NEXT

        BOOT_WORD TYPE, TYPE ( addr len -- ) type string, 0, XTYPE, XTYPE_END
XTYPE
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        cbz     x1, XTYPE_END
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        stp     x0, x1, [sp, #48]
        ldp     x0, x1, [sp, #48]
        bl      emit_str
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
XTYPE_END
        NEXT

; XEMIT ( xchar -- ) encode UTF-8 into xchar_emit_buf and TYPE it.
; The EMIT primitive already owns the label XEMIT. This word is XXCHAR_EMIT.
        BOOT_WORD XEMIT, XEMIT ( xchar -- ) emit UTF-8 xchar to console, 0, XXCHAR_EMIT, XXCHAR_EMIT_END
XXCHAR_EMIT
        mov     x1, x20
        ldr     x20, [x22], #8
        movz    x2, #0xFFFF
        movk    x2, #0x10, lsl #16
        cmp     x1, x2
        csel    x1, x2, x1, hi
        adrp    x0, xchar_emit_buf
        add     x0, x0, xchar_emit_buf
        mov     x3, x0
        cmp     x1, #0x7F
        b.ls    _xe_1
        cmp     x1, #0x7FF
        b.ls    _xe_2
        movz    x4, #0xFFFF
        cmp     x1, x4
        b.ls    _xe_3
        lsr     x4, x1, #18
        orr     w4, w4, #0xF0
        strb    w4, [x0], #1
        lsr     x4, x1, #12
        and     w4, w4, #0x3F
        orr     w4, w4, #0x80
        strb    w4, [x0], #1
        lsr     x4, x1, #6
        and     w4, w4, #0x3F
        orr     w4, w4, #0x80
        strb    w4, [x0], #1
        and     w4, w1, #0x3F
        orr     w4, w4, #0x80
        strb    w4, [x0], #1
        b       _xe_9
_xe_3
        lsr     x4, x1, #12
        orr     w4, w4, #0xE0
        strb    w4, [x0], #1
        lsr     x4, x1, #6
        and     w4, w4, #0x3F
        orr     w4, w4, #0x80
        strb    w4, [x0], #1
        and     w4, w1, #0x3F
        orr     w4, w4, #0x80
        strb    w4, [x0], #1
        b       _xe_9
_xe_2
        lsr     x4, x1, #6
        orr     w4, w4, #0xC0
        strb    w4, [x0], #1
        and     w4, w1, #0x3F
        orr     w4, w4, #0x80
        strb    w4, [x0], #1
        b       _xe_9
_xe_1
        strb    w1, [x0], #1
_xe_9
        sub     x1, x0, x3
        mov     x0, x3
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      emit_str
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XXCHAR_EMIT_END
        NEXT

; ---------------------------------------------------------------------
; Dictionary and compiler
; ---------------------------------------------------------------------

        BOOT_WORD DP, DP ( -- addr ) dictionary pointer variable, 0, XDP, XDP_END
XDP
        adrp    x0, here_ptr
        add     x0, x0, here_ptr
        DPUSH
XDP_END
        NEXT

        BOOT_WORD HERE, HERE ( -- addr ) current dictionary pointer, 0, XHERE, XHERE_END
XHERE
        adrp    x0, here_ptr
        add     x0, x0, here_ptr
        ldr     x0, [x0]
        DPUSH
XHERE_END
        NEXT

        BOOT_WORD ALLOT, ALLOT ( n -- ) allocate n bytes in dictionary, 0, XALLOT, XALLOT_END
XALLOT
        mov     x0, x20
        ldr     x20, [x22], #8
        adrp    x1, here_ptr
        add     x1, x1, here_ptr
        ldr     x2, [x1]
        add     x3, x2, x0
        adrp    x4, user_dict_area
        add     x4, x4, user_dict_area
        cmp     x3, x4
        b.lo    _allot_fail
        adrp    x5, user_dict_size_cell
        add     x5, x5, user_dict_size_cell
        ldr     x5, [x5]
        add     x5, x4, x5
        cmp     x3, x5
        b.hi    _allot_fail
        str     x3, [x1]
        b       XALLOT_END
_allot_fail
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        adrp    x0, msg_allot
        add     x0, x0, msg_allot
        bl      emit_cstr
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        b       _quit_exit
XALLOT_END
        NEXT

        BOOT_WORD_COMMA  ( n -- ) compile a cell, 0, XCOMMA, 0
XCOMMA
        mov     x0, x20
        ldr     x20, [x22], #8
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _compile_cell
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

        BOOT_WORD IMMEDIATE, IMMEDIATE ( -- ) mark latest word as immediate, 0, XIMMEDIATE, 0
XIMMEDIATE
        adrp    x0, last_cfa
        add     x0, x0, last_cfa
        ldr     x0, [x0]
        cbz     x0, _imm_done
        ldr     x1, [x0, #-8]
        mov     x2, #1
        lsl     x2, x2, #63
        orr     x1, x1, x2
        str     x1, [x0, #-8]
_imm_done
        NEXT

        BOOT_WORD SETDOC, SETDOC ( c-addr u -- ) pending help for next defining word, 0, XSETDOC, 0
XSETDOC
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
_setdoc_skip
        cbz     x1, _setdoc_store
        ldrb    w2, [x0]
        cmp     w2, #32
        b.eq    _setdoc_adv
        cmp     w2, #9
        b.ne    _setdoc_store
_setdoc_adv
        add     x0, x0, #1
        sub     x1, x1, #1
        b       _setdoc_skip
_setdoc_store
        adrp    x2, pending_help_addr
        add     x2, x2, pending_help_addr
        str     x0, [x2]
        adrp    x2, pending_help_len
        add     x2, x2, pending_help_len
        str     x1, [x2]
        NEXT

        BOOT_WORD CREATE, CREATE ( 'name' -- ) create a word that pushes its data field, 0, XCREATE, 0
XCREATE
        sub     sp, sp, #96
        stp     x29, x30, [sp, #32]
        bl      _next_word
        cbz     x1, _create_fail
        stp     x0, x1, [sp, #48]
        bl      _take_pending_help
        ldp     x0, x1, [sp, #48]
        adrp    x4, DOVAR
        add     x4, x4, DOVAR
        mov     x5, #0
        bl      _header_build
        adrp    x1, here_ptr
        add     x1, x1, here_ptr
        ldr     x0, [x1]
        str     xzr, [x0], #8
        str     x0, [x1]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT
_create_fail
        adrp    x0, msg_huh_k1
        add     x0, x0, msg_huh_k1
        bl      emit_cstr
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT

        BOOT_WORD STATE, STATE ( -- addr ) compilation state variable, 0, XSTATE, 0
XSTATE
        adrp    x0, state_var
        add     x0, x0, state_var
        DPUSH
        NEXT

        BOOT_WORD BASE, BASE ( -- addr ) current numeric base variable, 0, XBASE, XBASE_END
XBASE
        adrp    x0, base_var
        add     x0, x0, base_var
        DPUSH
XBASE_END
        NEXT

        BOOT_WORD LAST, LAST ( -- xt ) CFA of most recently defined word, 0, XLAST, 0
XLAST
        adrp    x0, last_cfa
        add     x0, x0, last_cfa
        ldr     x0, [x0]
        DPUSH
        NEXT

        BOOT_WORD (REGISTER-WID), (REGISTER-WID) ( wid -- ) register a wordlist, 0, XREGWID, 0
XREGWID
        mov     x0, x20
        ldr     x20, [x22], #8
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _wordlist_register
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

; x0 = wid. Ignore a duplicate or a full table (32 entries).
_wordlist_register
        adrp    x1, wordlist_reg_n
        add     x1, x1, wordlist_reg_n
        ldr     x2, [x1]
        adrp    x3, wordlist_reg
        add     x3, x3, wordlist_reg
        mov     x4, #0
_wreg_scan
        cmp     x4, x2
        b.hs    _wreg_add
        ldr     x5, [x3, x4, lsl #3]
        cmp     x5, x0
        b.eq    _wreg_done
        add     x4, x4, #1
        b       _wreg_scan
_wreg_add
        cmp     x2, #32
        b.hs    _wreg_done
        str     x0, [x3, x2, lsl #3]
        add     x2, x2, #1
        str     x2, [x1]
_wreg_done
        ret

; ---------------------------------------------------------------------
; Search order. wid1 (search_order[0]) is searched first. Max 8.
; ---------------------------------------------------------------------

        BOOT_WORD GET-ORDER, GET-ORDER ( -- widn ... wid1 n ) copy search order, 0, XGET_ORDER, 0
XGET_ORDER
        adrp    x0, search_order_n
        add     x0, x0, search_order_n
        ldr     x1, [x0]
        adrp    x2, search_order
        add     x2, x2, search_order
        mov     x3, x1
_get_ord_loop
        cbz     x3, _get_ord_n
        sub     x3, x3, #1
        ldr     x4, [x2, x3, lsl #3]
        str     x20, [x22, #-8]!
        mov     x20, x4
        b       _get_ord_loop
_get_ord_n
        str     x20, [x22, #-8]!
        mov     x20, x1
        NEXT

        BOOT_WORD SET-ORDER, SET-ORDER ( widn ... wid1 n -- ) replace search order, 0, XSET_ORDER, 0
XSET_ORDER
        mov     x1, x20
        ldr     x20, [x22], #8
        cmn     x1, #1
        b.eq    XONLY
        cmp     x1, #0
        b.lt    _set_ord_bad
        cmp     x1, #8
        b.hi    _set_ord_bad
        adrp    x0, search_order_n
        add     x0, x0, search_order_n
        str     x1, [x0]
        adrp    x2, search_order
        add     x2, x2, search_order
        mov     x3, #0
_set_ord_loop
        cmp     x3, x1
        b.hs    _set_ord_bad
        str     x20, [x2, x3, lsl #3]
        ldr     x20, [x22], #8
        add     x3, x3, #1
        b       _set_ord_loop
_set_ord_bad
        NEXT

        BOOT_WORD PUSH-ORDER, PUSH-ORDER ( wid -- ) prepend wid to search order, 0, XPUSH_ORDER, 0
XPUSH_ORDER
        adrp    x0, search_order_n
        add     x0, x0, search_order_n
        ldr     x1, [x0]
        cmp     x1, #8
        b.hs    _push_ord_drop
        adrp    x2, search_order
        add     x2, x2, search_order
        mov     x3, x1
_push_ord_shift
        cbz     x3, _push_ord_store
        sub     x3, x3, #1
        ldr     x4, [x2, x3, lsl #3]
        add     x5, x3, #1
        str     x4, [x2, x5, lsl #3]
        b       _push_ord_shift
_push_ord_store
        str     x20, [x2]
        add     x1, x1, #1
        str     x1, [x0]
_push_ord_drop
        ldr     x20, [x22], #8
        NEXT

        BOOT_WORD DEFINITIONS, DEFINITIONS ( -- ) CURRENT = first in search order, 0, XDEFINITIONS, 0
XDEFINITIONS
        adrp    x0, search_order_n
        add     x0, x0, search_order_n
        ldr     x0, [x0]
        cbz     x0, _def_done
        adrp    x1, search_order
        add     x1, x1, search_order
        ldr     x1, [x1]
        adrp    x0, current_var
        add     x0, x0, current_var
        str     x1, [x0]
_def_done
        NEXT

        BOOT_WORD ONLY, ONLY ( -- ) search order = FORTH only, 0, XONLY, 0
XONLY
        adrp    x0, latest_var
        add     x0, x0, latest_var
        adrp    x1, search_order
        add     x1, x1, search_order
        str     x0, [x1]
        mov     x0, #1
        adrp    x1, search_order_n
        add     x1, x1, search_order_n
        str     x0, [x1]
        NEXT

        BOOT_WORD FORTH, FORTH ( -- ) set first search-order entry to FORTH, 0, XFORTH, 0
XFORTH
        adrp    x0, latest_var
        add     x0, x0, latest_var
        adrp    x1, search_order
        add     x1, x1, search_order
        str     x0, [x1]
        adrp    x1, search_order_n
        add     x1, x1, search_order_n
        ldr     x2, [x1]
        cbnz    x2, _forth_done
        mov     x2, #1
        str     x2, [x1]
_forth_done
        NEXT

        BOOT_WORD CURRENT, CURRENT ( -- addr ) compilation wordlist variable, 0, XCURRENT, 0
XCURRENT
        adrp    x0, current_var
        add     x0, x0, current_var
        DPUSH
        NEXT

        BOOT_WORD GET-CURRENT, GET-CURRENT ( -- wid ) wid of the compilation wordlist, 0, XGET_CURRENT, 0
XGET_CURRENT
        adrp    x0, current_var
        add     x0, x0, current_var
        ldr     x0, [x0]
        DPUSH
        NEXT

        BOOT_WORD SET-CURRENT, SET-CURRENT ( wid -- ) set the compilation wordlist, 0, XSET_CURRENT, 0
XSET_CURRENT
        adrp    x0, current_var
        add     x0, x0, current_var
        str     x20, [x0]
        ldr     x20, [x22], #8
        NEXT

        BOOT_WORD WORDLIST, WORDLIST ( -- wid ) create empty word list, 0, XWORDLIST, 0
XWORDLIST
        adrp    x0, here_ptr
        add     x0, x0, here_ptr
        ldr     x1, [x0]
        add     x1, x1, #7
        bic     x1, x1, #7
        add     x3, x1, #128
        adrp    x4, user_dict_area
        add     x4, x4, user_dict_area
        cmp     x3, x4
        b.lo    _allot_fail
        adrp    x5, user_dict_size_cell
        add     x5, x5, user_dict_size_cell
        ldr     x5, [x5]
        add     x5, x4, x5
        cmp     x3, x5
        b.hi    _allot_fail
        mov     x2, x1
        mov     x5, #16
_wl_zero
        str     xzr, [x1], #8
        subs    x5, x5, #1
        b.ne    _wl_zero
        str     x1, [x0]
        mov     x0, x2
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _wordlist_register
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        DPUSH
        NEXT

        BOOT_WORD PREVIOUS, PREVIOUS ( -- ) drop first search-order entry, 0, XPREVIOUS, 0
XPREVIOUS
        adrp    x0, search_order_n
        add     x0, x0, search_order_n
        ldr     x1, [x0]
        cmp     x1, #1
        b.ls    _prev_done
        adrp    x2, search_order
        add     x2, x2, search_order
        mov     x3, #0
_prev_shift
        add     x4, x3, #1
        cmp     x4, x1
        b.hs    _prev_store
        ldr     x5, [x2, x4, lsl #3]
        str     x5, [x2, x3, lsl #3]
        add     x3, x3, #1
        b       _prev_shift
_prev_store
        sub     x1, x1, #1
        str     x1, [x0]
_prev_done
        NEXT

        BOOT_WORD ORDER, ORDER ( -- ) print search order and CURRENT, 0, XORDER, 0
XORDER
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        stp     x21, x22, [sp, #64]
        adrp    x0, str_search_order
        add     x0, x0, str_search_order
        bl      emit_cstr
        adrp    x0, search_order_n
        add     x0, x0, search_order_n
        ldr     x19, [x0]
        adrp    x20, search_order
        add     x20, x20, search_order
        mov     x21, #0
_ord_loop
        cmp     x21, x19
        b.hs    _ord_nl
        ldr     x0, [x20, x21, lsl #3]
        bl      _print_wid_name
        mov     x0, #32
        bl      _putchar
        add     x21, x21, #1
        b       _ord_loop
_ord_nl
        mov     x0, #10
        bl      _putchar
        adrp    x0, str_comp_wl
        add     x0, x0, str_comp_wl
        bl      emit_cstr
        adrp    x0, current_var
        add     x0, x0, current_var
        ldr     x0, [x0]
        bl      _print_wid_name
        mov     x0, #10
        bl      _putchar
        ldp     x21, x22, [sp, #64]
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        NEXT

        BOOT_WORD CELL, CELL ( -- n ) address unit size in bytes, 0, XCELL, XCELL_END
XCELL
        mov     x0, #8
        DPUSH
XCELL_END
        NEXT

        BOOT_WORD CELLS, CELLS ( n -- n ) cells to address units, 0, XCELLS, XCELLS_END
XCELLS
        lsl     x20, x20, #3
XCELLS_END
        NEXT

; Depth is the cells under TOS. The cached top is not counted, so an
; untouched stack reports 0. SP0 is data_stack+4096. A pointer outside
; that range is repaired to empty before the measurement.
        BOOT_WORD DEPTH, DEPTH ( -- +n ) data stack depth in cells, 0, XDEPTH, XDEPTH_END
XDEPTH
        adrp    x1, data_stack
        add     x1, x1, data_stack
        add     x0, x1, #1, lsl #12
        cmp     x22, x0
        b.hi    _depth_fix
        cmp     x22, x1
        b.lo    _depth_fix
        b       _depth_n
_depth_fix
        mov     x22, x0
        mov     x20, #0
_depth_n
        sub     x0, x0, x22
        lsr     x0, x0, #3
        str     x20, [x22, #-8]!
        mov     x20, x0
XDEPTH_END
        NEXT

        BOOT_WORD CLEARSTACK, CLEARSTACK ( -- ) empty the data stack, 0, XCLEARSTACK, XCLEARSTACK_END
XCLEARSTACK
        adrp    x22, data_stack
        add     x22, x22, data_stack
        add     x22, x22, #1, lsl #12
        mov     x20, #0
XCLEARSTACK_END
        NEXT

        BOOT_WORD SP0, SP0 ( -- addr ) empty data-stack pointer, 0, XSP0, XSP0_END
XSP0
        adrp    x1, data_stack
        add     x1, x1, data_stack
        add     x0, x1, #1, lsl #12
        cmp     x22, x0
        b.hi    _sp0_fix
        cmp     x22, x1
        b.lo    _sp0_fix
        b       _sp0_push
_sp0_fix
        mov     x22, x0
        mov     x20, #0
_sp0_push
        str     x20, [x22, #-8]!
        mov     x20, x0
XSP0_END
        NEXT

        BOOT_WORD SP@, SP@ ( -- addr ) current data-stack pointer under TOS, 0, XSPFETCH, XSPFETCH_END
XSPFETCH
        mov     x0, x22
        str     x20, [x22, #-8]!
        mov     x20, x0
XSPFETCH_END
        NEXT

        BOOT_WORD SP!, SP! ( addr -- ) set the data-stack pointer, 0, XSPSTORE, XSPSTORE_END
XSPSTORE
        mov     x22, x20
        mov     x20, #0
XSPSTORE_END
        NEXT

        BOOT_WORD DICT-THREADS, DICT-THREADS ( -- n ) hash threads per wordlist, 0, XDICT_THREADS, 0
XDICT_THREADS
        mov     x0, #16
        DPUSH
        NEXT

; ---------------------------------------------------------------------
; Compile-time addresses and control flow
; ---------------------------------------------------------------------

        BOOT_WORD ['], ['] ( -- xt ) compile xt of next name, FLAG_IMM, XBRACKET_TICK, 0
XBRACKET_TICK
        sub     sp, sp, #96
        stp     x29, x30, [sp, #32]
        bl      _next_word
        cbz     x1, _btick_fail
        stp     x0, x1, [sp, #48]
        bl      _find_word
        cbz     x0, _btick_fail
        str     x0, [sp, #64]
        adrp    x1, state_var
        add     x1, x1, state_var
        ldr     x1, [x1]
        cbz     x1, _btick_interp
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        bl      _compile_cell
        ldr     x0, [sp, #64]
        bl      _compile_cell
        b       _btick_leave
_btick_interp
        ldr     x0, [sp, #64]
        DPUSH
_btick_leave
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT
_btick_fail
        adrp    x0, msg_huh_k1
        add     x0, x0, msg_huh_k1
        bl      emit_cstr
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        b       _quit_exit

        BOOT_WORD LIT-ADDR, LIT-ADDR ( -- xt ) xt of LIT, 0, XLIT_ADDR, 0
XLIT_ADDR
        adrp    x0, cfa_lit
        add     x0, x0, cfa_lit
        ldr     x0, [x0]
        DPUSH
        NEXT

        BOOT_WORD 0BRANCH-ADDR, 0BRANCH-ADDR ( -- xt ) xt of 0BRANCH, 0, X0BRANCH_ADDR, 0
X0BRANCH_ADDR
        adrp    x0, cfa_0branch
        add     x0, x0, cfa_0branch
        ldr     x0, [x0]
        DPUSH
        NEXT

        BOOT_WORD BRANCH-ADDR, BRANCH-ADDR ( -- xt ) xt of BRANCH, 0, XBRANCH_ADDR, 0
XBRANCH_ADDR
        adrp    x0, cfa_branch
        add     x0, x0, cfa_branch
        ldr     x0, [x0]
        DPUSH
        NEXT

        BOOT_WORD DOCOL-ADDR, DOCOL-ADDR ( -- addr ) address of DOCOL code, 0, XDOCOL_ADDR, 0
XDOCOL_ADDR
        adrp    x0, DOCOL
        add     x0, x0, DOCOL
        DPUSH
        NEXT

        BOOT_WORD DOCON-ADDR, DOCON-ADDR ( -- addr ) address of DOCON code, 0, XDOCON_ADDR, 0
XDOCON_ADDR
        adrp    x0, DOCON
        add     x0, x0, DOCON
        DPUSH
        NEXT

        BOOT_WORD BRANCH, BRANCH ( -- ) unconditional branch, 0, XBranch, XBranch_END
XBranch
        ldr     x0, [x19]
        add     x19, x19, x0
XBranch_END
        NEXT

        BOOT_WORD 0BRANCH, 0BRANCH ( flag -- ) branch if zero, 0, X0Branch, X0Branch_END
X0Branch
        adrp    x1, data_stack
        add     x1, x1, data_stack
        add     x1, x1, #1, lsl #12
        cbz     x20, _0br_true
        cmp     x22, x1
        b.hs    _0br_empty_skip
        ldr     x20, [x22], #8
        b       _0br_skip
_0br_empty_skip
        mov     x20, #0
        mov     x22, x1
_0br_skip
        add     x19, x19, #8
        NEXT
_0br_true
        cmp     x22, x1
        b.hs    _0br_empty_take
        ldr     x20, [x22], #8
        b       _0br_take
_0br_empty_take
        mov     x20, #0
        mov     x22, x1
_0br_take
        ldr     x0, [x19]
        add     x19, x19, x0
X0Branch_END
        NEXT

        BOOT_WORD (DOVAR), (DOVAR) CREATE/VARIABLE runtime, 0, DOVAR, DOVAR_END
DOVAR
        str     x20, [x22, #-8]!
        add     x20, x21, #16
DOVAR_END
        NEXT

        BOOT_WORD (DOCON), (DOCON) CONSTANT runtime, 0, DOCON, DOCON_END
DOCON
        str     x20, [x22, #-8]!
        ldr     x20, [x21, #16]
DOCON_END
        NEXT

        BOOT_WORD (DODOES), (DODOES) DOES> runtime, 0, DODOES, DODOES_END
DODOES
        str     x19, [x23, #-8]!
        ldr     x19, [x21, #8]
        add     x0, x21, #16
        str     x20, [x22, #-8]!
        mov     x20, x0
DODOES_END
        NEXT

        BOOT_WORD (DO), (DO) ( limit start -- ) runtime for DO, 0, XDO_RT, XDO_RT_END
XDO_RT
        ldr     x0, [x22], #8
        str     x0, [x23, #-8]!
        str     x20, [x23, #-8]!
        ldr     x20, [x22], #8
XDO_RT_END
        NEXT

        BOOT_WORD (?DO), (?DO) ( limit start -- ) runtime for ?DO, 0, XQDO_RT, XQDO_RT_END
XQDO_RT
        ldr     x0, [x22], #8
        cmp     x20, x0
        b.eq    _qdo_skip
        str     x0, [x23, #-8]!
        str     x20, [x23, #-8]!
        ldr     x20, [x22], #8
        add     x19, x19, #8
        NEXT
_qdo_skip
        ldr     x20, [x22], #8
        ldr     x0, [x19]
        add     x19, x19, x0
XQDO_RT_END
        NEXT

        BOOT_WORD (LOOP), (LOOP) ( -- ) runtime for LOOP, 0, XLOOP_RT, XLOOP_RT_END
XLOOP_RT
        ldr     x0, [x23], #8
        ldr     x1, [x23], #8
        cmp     x0, x1
        b.ge    _loop_done
        add     x0, x0, #1
        cmp     x0, x1
        b.eq    _loop_done
        str     x1, [x23, #-8]!
        str     x0, [x23, #-8]!
        ldr     x2, [x19]
        add     x19, x19, x2
        NEXT
_loop_done
        add     x19, x19, #8
XLOOP_RT_END
        NEXT

        BOOT_WORD (+LOOP), (+LOOP) ( n -- ) runtime for +LOOP, 0, XPLUSLOOP_RT, XPLUSLOOP_RT_END
XPLUSLOOP_RT
        ldr     x0, [x23], #8
        ldr     x1, [x23], #8
        mov     x2, x20
        ldr     x20, [x22], #8
        sub     x3, x0, x1
        add     x4, x3, x2
        eor     x5, x3, x4
        eor     x6, x3, x2
        ands    x5, x5, x6
        b.mi    _pl_done
        add     x0, x0, x2
        str     x1, [x23, #-8]!
        str     x0, [x23, #-8]!
        ldr     x2, [x19]
        add     x19, x19, x2
        NEXT
_pl_done
        add     x19, x19, #8
XPLUSLOOP_RT_END
        NEXT

        BOOT_WORD (DOES>), (DOES>) ( -- ) patch latest CREATE word and return, 0, XDOES_RT, XDOES_RT_END
XDOES_RT
        adrp    x0, last_cfa
        add     x0, x0, last_cfa
        ldr     x0, [x0]
        cbz     x0, _xdoes_ret
        adrp    x1, DODOES
        add     x1, x1, DODOES
        str     x1, [x0]
        str     x19, [x0, #8]
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _nfa_reveal_cfa
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
_xdoes_ret
        ldr     x19, [x23], #8
XDOES_RT_END
        NEXT

        BOOT_WORD DOES>, DOES> ( -- ) modify last CREATE'd word (immediate), FLAG_IMM, XDOES, 0
XDOES
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        adrp    x0, cfa_does
        add     x0, x0, cfa_does
        ldr     x0, [x0]
        bl      _compile_cell
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

        BOOT_WORD THROW, THROW ( n -- ) raise exception n (0 is a no-op), 0, XTHROW, 0
XTHROW
        cbz     x20, _throw_zero
        adrp    x7, throw_handler
        add     x7, x7, throw_handler
        ldr     x1, [x7]
        cbz     x1, _throw_uncaught
        mov     x5, x20
        mov     x23, x1
        ldr     x19, [x23], #8
        ldr     x6, [x23], #8
        mov     x4, x22
        ldr     x22, [x23], #8
        ldr     x8, [x23], #8
        ; Deeper than CATCH: the live top is the cell under the saved DSP.
        ; Shallower or equal keeps the CATCH snapshot.
        cmp     x4, x22
        b.hs    _throw_tos_snap
        ldr     x8, [x22, #-8]
_throw_tos_snap
        mov     x20, x8
        ldr     x0, [x23], #8
        str     x0, [x7]
        ldr     x0, [x23], #8
        adrp    x3, eval_resume_sp
        add     x3, x3, eval_resume_sp
        str     x0, [x3]
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        stp     x5, x20, [sp, #48]
        stp     x19, x22, [sp, #64]
        mov     x0, x6
        bl      _throw_unwind_to_sp
        ldp     x19, x22, [sp, #64]
        ldp     x5, x20, [sp, #48]
        adrp    x0, state_var
        add     x0, x0, state_var
        str     xzr, [x0]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        str     x20, [x22, #-8]!
        mov     x20, x5
        NEXT
_throw_uncaught
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        str     x20, [sp, #48]
        adrp    x0, msg_throw
        add     x0, x0, msg_throw
        bl      emit_cstr
        ldr     x0, [sp, #48]
        bl      _print_signed
        mov     x0, #10
        bl      _putchar
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        b       _quit_exit
_throw_zero
        ldr     x20, [x22], #8
        NEXT

; ---------------------------------------------------------------------
; Parse
; ---------------------------------------------------------------------

        BOOT_WORD PARSE, PARSE ( char -- c-addr u ) parse through delimiter, 0, XPARSE, XPARSE_END
XPARSE
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     w7, w20
        ldr     x20, [x22], #8
        bl      _cursor_load
        mov     x9, x0
        adrp    x3, source_end
        add     x3, x3, source_end
        ldr     x6, [x3]
        mov     x3, x9
_parse_scan
        cmp     x3, x6
        b.hs    _parse_eos
        ldrb    w4, [x3]
        cbz     w4, _parse_eos
        cmp     w4, w7
        b.eq    _parse_found
        add     x3, x3, #1
        b       _parse_scan
_parse_found
        sub     x5, x3, x9
        add     x3, x3, #1
        b       _parse_commit
_parse_eos
        sub     x5, x3, x9
_parse_commit
        mov     x0, x3
        bl      _cursor_commit
        str     x20, [x22, #-8]!
        mov     x20, x9
        str     x20, [x22, #-8]!
        mov     x20, x5
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XPARSE_END
        NEXT

        BOOT_WORD WORD, WORD ( char -- addr ) counted string in transient buffer, 0, XWORD, XWORD_END
XWORD
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     w7, w20
        bl      _cursor_load
        adrp    x3, source_end
        add     x3, x3, source_end
        ldr     x9, [x3]
_word_skip
        cmp     x0, x9
        b.hs    _word_empty
        ldrb    w4, [x0]
        cbz     w4, _word_empty
        cmp     w7, #32
        b.ne    _word_skip_exact
        cmp     w4, #32
        b.eq    _word_adv
        cmp     w4, #9
        b.eq    _word_adv
        cmp     w4, #10
        b.eq    _word_adv
        cmp     w4, #13
        b.eq    _word_adv
        b       _word_start
_word_skip_exact
        cmp     w4, w7
        b.ne    _word_start
_word_adv
        add     x0, x0, #1
        b       _word_skip
_word_start
        mov     x3, x0
_word_scan
        cmp     x0, x9
        b.hs    _word_end
        ldrb    w4, [x0]
        cbz     w4, _word_end
        cmp     w7, #32
        b.ne    _word_scan_exact
        cmp     w4, #32
        b.eq    _word_end
        cmp     w4, #9
        b.eq    _word_end
        cmp     w4, #10
        b.eq    _word_end
        cmp     w4, #13
        b.eq    _word_end
        add     x0, x0, #1
        b       _word_scan
_word_scan_exact
        cmp     w4, w7
        b.eq    _word_end
        add     x0, x0, #1
        b       _word_scan
_word_end
        sub     x5, x0, x3
        cmp     x0, x9
        b.hs    _word_store
        ldrb    w4, [x0]
        cbz     w4, _word_store
        add     x0, x0, #1
        cmp     w7, #32
        b.ne    _word_store
        cmp     w4, #13
        b.ne    _word_store
        cmp     x0, x9
        b.hs    _word_store
        ldrb    w4, [x0]
        cmp     w4, #10
        b.ne    _word_store
        add     x0, x0, #1
_word_store
        cmp     x5, #63
        b.ls    _word_len_ok
        mov     x5, #63
_word_len_ok
        bl      _cursor_commit
        adrp    x6, word_scratch
        add     x6, x6, word_scratch
        strb    w5, [x6]
        mov     x1, #0
_word_copy
        cmp     x1, x5
        b.ge    _word_done
        ldrb    w4, [x3, x1]
        add     x8, x6, #1
        strb    w4, [x8, x1]
        add     x1, x1, #1
        b       _word_copy
_word_done
        mov     x20, x6
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT
_word_empty
        bl      _cursor_commit
        adrp    x6, word_scratch
        add     x6, x6, word_scratch
        strb    wzr, [x6]
        mov     x20, x6
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XWORD_END
        NEXT

        BOOT_WORD .(, .( ( -- ) print text until ) (immediate), FLAG_IMM, XDOTPAREN, 0
XDOTPAREN
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     w7, #41
        bl      _cursor_load
        mov     x9, x0
        adrp    x3, source_end
        add     x3, x3, source_end
        ldr     x6, [x3]
        mov     x3, x9
_dotp_scan
        cmp     x3, x6
        b.hs    _dotp_eos
        ldrb    w4, [x3]
        cbz     w4, _dotp_eos
        cmp     w4, w7
        b.eq    _dotp_found
        add     x3, x3, #1
        b       _dotp_scan
_dotp_found
        sub     x5, x3, x9
        add     x3, x3, #1
        b       _dotp_go
_dotp_eos
        sub     x5, x3, x9
_dotp_go
        mov     x0, x3
        bl      _cursor_commit
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        str     x20, [x22, #-8]!
        mov     x20, x9
        str     x20, [x22, #-8]!
        mov     x20, x5
        b       XTYPE

        BOOT_WORD_BSLASH  ( -- ) comment to end of line (immediate), FLAG_IMM, XBACKSLASH, 0
XBACKSLASH
        adrp    x0, blk_var
        add     x0, x0, blk_var
        ldr     x0, [x0]
        cbnz    x0, _bs_block
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _cursor_load
        mov     x10, x0
        adrp    x3, source_end
        add     x3, x3, source_end
        ldr     x9, [x3]
_bs_loop
        cmp     x10, x9
        b.hs    _bs_done
        ldrb    w4, [x10]
        cbz     w4, _bs_done
        cmp     w4, #10
        b.eq    _bs_done
        cmp     w4, #13
        b.eq    _bs_done
        add     x10, x10, #1
        b       _bs_loop
_bs_done
        mov     x0, x10
        bl      _cursor_commit
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT
_bs_block
        adrp    x0, to_in
        add     x0, x0, to_in
        ldr     x1, [x0]
        adrp    x2, source_base
        add     x2, x2, source_base
        ldr     x3, [x2]
        adrp    x2, source_end
        add     x2, x2, source_end
        ldr     x2, [x2]
        sub     x2, x2, x3
        lsr     x5, x1, #6
        add     x5, x5, #1
        lsl     x5, x5, #6
        cmp     x5, x2
        b.ls    _bs_blk_ok
        mov     x5, x2
_bs_blk_ok
        str     x5, [x0]
        add     x3, x3, x5
        adrp    x0, source_cur
        add     x0, x0, source_cur
        str     x3, [x0]
        NEXT

        BOOT_WORD (, ( -- ) comment until ) (immediate), FLAG_IMM, XPAREN, 0
XPAREN
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _cursor_load
        mov     x10, x0
        adrp    x3, source_end
        add     x3, x3, source_end
        ldr     x9, [x3]
_par_loop
        cmp     x10, x9
        b.hs    _par_eol
        ldrb    w4, [x10]
        cbz     w4, _par_eol
        cmp     w4, #41
        b.eq    _par_found
        add     x10, x10, #1
        b       _par_loop
_par_found
        add     x10, x10, #1
        b       _par_store
_par_eol
        adrp    x0, line_mode
        add     x0, x0, line_mode
        ldr     x0, [x0]
        cbz     x0, _par_store
        bl      _take_line
        cbz     x0, _par_eof
        bl      _cursor_load
        mov     x10, x0
        adrp    x3, source_end
        add     x3, x3, source_end
        ldr     x9, [x3]
        b       _par_loop
_par_eof
        bl      _cursor_load
        mov     x10, x0
_par_store
        mov     x0, x10
        bl      _cursor_commit
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

        BOOT_WORD_SLIT  ( -- c-addr u ) runtime for a compiled quote string, 0, XSLIT, XSLIT_END
XSLIT
        ldr     x0, [x19], #8
        str     x20, [x22, #-8]!
        mov     x20, x19
        str     x20, [x22, #-8]!
        mov     x20, x0
        add     x19, x19, x0
        add     x19, x19, #7
        bic     x19, x19, #7
XSLIT_END
        NEXT

        BOOT_WORD_SQUOTE  ( -- c-addr u ) quote-delimited string (immediate), FLAG_IMM, XSQUOTE, 0
XSQUOTE
        sub     sp, sp, #96
        stp     x29, x30, [sp, #32]
        bl      _cursor_load
        mov     x1, x0
        adrp    x3, source_end
        add     x3, x3, source_end
        ldr     x6, [x3]
        mov     x9, x1
_sq_scan
        cmp     x1, x6
        b.hs    _sq_eos
        ldrb    w3, [x1]
        cbz     w3, _sq_eos
        cmp     w3, #34
        b.eq    _sq_found
        add     x1, x1, #1
        b       _sq_scan
_sq_found
        sub     x5, x1, x9
        add     x1, x1, #1
        b       _sq_commit
_sq_eos
        sub     x5, x1, x9
_sq_commit
        mov     x0, x1
        bl      _cursor_commit
        adrp    x0, state_var
        add     x0, x0, state_var
        ldr     x0, [x0]
        cbnz    x0, _sq_comp
        str     x20, [x22, #-8]!
        mov     x20, x9
        str     x20, [x22, #-8]!
        mov     x20, x5
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT
_sq_comp
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
_sq_cpy
        cmp     x3, x5
        b.ge    _sq_align
        ldrb    w4, [x9, x3]
        strb    w4, [x1, x3]
        add     x3, x3, #1
        b       _sq_cpy
_sq_align
        add     x1, x1, x5
        add     x1, x1, #7
        bic     x1, x1, #7
        str     x1, [x0]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT

        BOOT_WORD_CSTR  ( -- c-addr ) runtime for a compiled counted string, 0, XCSTR, XCSTR_END
XCSTR
        str     x20, [x22, #-8]!
        mov     x20, x19
        ldrb    w0, [x19]
        add     x19, x19, x0
        add     x19, x19, #1
        add     x19, x19, #7
        bic     x19, x19, #7
XCSTR_END
        NEXT

        BOOT_WORD_CQUOTE  ( -- c-addr ) compile a quote-delimited counted string, FLAG_IMM, XCQUOTE, 0
XCQUOTE
        sub     sp, sp, #96
        stp     x29, x30, [sp, #32]
        bl      _cursor_load
        mov     x1, x0
        adrp    x3, source_end
        add     x3, x3, source_end
        ldr     x6, [x3]
        mov     x9, x1
_cq_scan
        cmp     x1, x6
        b.hs    _cq_eos
        ldrb    w3, [x1]
        cbz     w3, _cq_eos
        cmp     w3, #34
        b.eq    _cq_found
        add     x1, x1, #1
        b       _cq_scan
_cq_found
        sub     x5, x1, x9
        add     x1, x1, #1
        b       _cq_commit
_cq_eos
        sub     x5, x1, x9
_cq_commit
        mov     x0, x1
        bl      _cursor_commit
        cmp     x5, #255
        b.ls    _cq_lenok
        mov     x5, #255
_cq_lenok
        adrp    x0, state_var
        add     x0, x0, state_var
        ldr     x0, [x0]
        cbnz    x0, _cq_comp
        adrp    x0, pad_buffer
        add     x0, x0, pad_buffer
        strb    w5, [x0]
        mov     x3, #0
_cq_ipad
        cmp     x3, x5
        b.ge    _cq_idone
        ldrb    w4, [x9, x3]
        add     x6, x0, #1
        strb    w4, [x6, x3]
        add     x3, x3, #1
        b       _cq_ipad
_cq_idone
        str     x20, [x22, #-8]!
        mov     x20, x0
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT
_cq_comp
        stp     x9, x5, [sp, #48]
        adrp    x0, cfa_cstr
        add     x0, x0, cfa_cstr
        ldr     x0, [x0]
        bl      _compile_cell
        ldr     x5, [sp, #56]
        ldr     x9, [sp, #48]
        adrp    x0, here_ptr
        add     x0, x0, here_ptr
        ldr     x1, [x0]
        strb    w5, [x1], #1
        mov     x3, #0
_cq_cpy
        cmp     x3, x5
        b.ge    _cq_align
        ldrb    w4, [x9, x3]
        strb    w4, [x1, x3]
        add     x3, x3, #1
        b       _cq_cpy
_cq_align
        add     x1, x1, x5
        add     x1, x1, #7
        bic     x1, x1, #7
        str     x1, [x0]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT

next_debug_gate
        adrp    x16, next_debug
        add     x16, x16, next_debug
        br      x16

        AREA |.rdata|, DATA, READONLY

msg_allot   DCB     "ALLOT: dictionary full (need more USER-DICT space)", 10, 0
msg_throw   DCB     " throw ", 0
msg_huh_k1  DCB     " ?", 10, 0
str_search_order DCB "Search order: ", 0
str_comp_wl DCB     "Compilation wordlist: ", 0

        END
