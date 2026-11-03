; Header layout matches the Mac kernel, low to high:
;   HFA   counted help, padded to 8
;   NFA   counted name (uppercase, bit7 = SMUDGE), padded to 8
;   LFA   previous CFA of this hash thread     at CFA-16
;   FFA   flags                                at CFA-8
;         bits 0-15 NFA_OFF, 16-31 HFA_OFF
;         bits 32-47 source line, bits 48-60 source file id
;         bits 61-63 INLINE, EMM, IMMEDIATE
;   CFA   code address
;   HERE is CFA+8 on return. Colon allots one cell so the body is CFA+16.
; latest_var is DICT_THREADS (16) heads. x24 = &latest_var.

        INCLUDE Forth/kernel/arm64/vm.inc

        EXTERN next_debug
        EXTERN debug_break_asap
        INCLUDE Forth/kernel/arm64/boot_words.inc

        AREA |.text|, CODE, READONLY, ALIGN=4

        EXTERN latest_var
        EXTERN last_cfa
        EXTERN noname_xt
        EXTERN here_ptr
        EXTERN state_var
        EXTERN source_cur
        EXTERN source_end
        EXTERN source_base
        EXTERN to_in
        EXTERN current_var
        EXTERN search_order
        EXTERN search_order_n
        EXTERN base_var
        EXTERN pending_help_addr
        EXTERN pending_help_len
        EXTERN _view_line_now
        EXTERN view_src_id
        EXTERN exit_cfa
        EXTERN emit_cstr
        EXTERN DOCOL
        EXPORT _dict_hash
        EXPORT _header_build
        EXPORT _nfa_from_cfa
        EXPORT _nfa_smudge_cfa
        EXPORT _nfa_reveal_cfa
        EXPORT _find_word
        EXPORT _parse_number
        EXPORT _next_word
        EXPORT _cursor_load
        EXPORT _cursor_commit
        EXPORT _compile_cell
        EXPORT _strlen
        EXPORT _take_pending_help
        EXTERN _local_compile_reset
        EXPORT XCOLON
        EXPORT XSEMI

; x0=name, x1=len -> x0 = thread in 0..15. Case-folded djb2, same as the Mac.
_dict_hash
        mov     x2, #5381
        cbz     x1, _dict_hash_empty
        mov     x3, #0
_dict_hash_1
        cmp     x3, x1
        b.hs    _dict_hash_2
        ldrb    w4, [x0, x3]
        cmp     w4, #'a'
        b.lo    _dict_hash_11
        cmp     w4, #'z'
        b.hi    _dict_hash_11
        sub     w4, w4, #32
_dict_hash_11
        lsl     x5, x2, #5
        add     x2, x5, x2
        add     x2, x2, x4
        add     x3, x3, #1
        b       _dict_hash_1
_dict_hash_2
        mov     x0, #16
        udiv    x1, x2, x0
        msub    x0, x1, x0, x2
        ret
_dict_hash_empty
        mov     x0, #0
        ret

; x0=name, x1=nlen, x2=help, x3=hlen, x4=code, x5=FLAG_*.
; Returns x0=CFA. Saves and restores x19-x24.
_header_build PROC
        sub     sp, sp, #128
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        stp     x21, x22, [sp, #64]
        stp     x23, x24, [sp, #80]
        str     x5, [sp, #112]
        mov     x19, x0
        mov     x20, x1
        mov     x21, x2
        mov     x22, x3
        mov     x23, x4
        adrp    x24, current_var
        add     x24, x24, current_var
        ldr     x24, [x24]
        adrp    x9, here_ptr
        add     x9, x9, here_ptr
        ldr     x6, [x9]
        mov     x8, x6
        cmp     x22, #255
        b.ls    _hb_help_ok
        mov     x22, #255
_hb_help_ok
        strb    w22, [x6], #1
        mov     x2, #0
_hb_help_cp
        cmp     x2, x22
        b.hs    _hb_help_pad
        ldrb    w3, [x21, x2]
        strb    w3, [x6], #1
        add     x2, x2, #1
        b       _hb_help_cp
_hb_help_pad
        sub     x2, x6, x8
_hb_help_al
        tst     x2, #7
        b.eq    _hb_name
        strb    wzr, [x6], #1
        add     x2, x2, #1
        b       _hb_help_al
_hb_name
        mov     x7, x6
        cmp     x20, #127
        b.ls    _hb_nlen
        mov     x20, #127
_hb_nlen
        and     w20, w20, #0x7F
        strb    w20, [x6], #1
        mov     x2, #0
_hb_name_cp
        cmp     x2, x20
        b.hs    _hb_name_pad
        ldrb    w3, [x19, x2]
        cmp     w3, #'a'
        b.lo    _hb_name_st
        cmp     w3, #'z'
        b.hi    _hb_name_st
        sub     w3, w3, #32
_hb_name_st
        strb    w3, [x6], #1
        add     x2, x2, #1
        b       _hb_name_cp
_hb_name_pad
        sub     x2, x6, x7
_hb_name_al
        tst     x2, #7
        b.eq    _hb_link
        strb    wzr, [x6], #1
        add     x2, x2, #1
        b       _hb_name_al
_hb_link
        mov     x0, x19
        mov     x1, x20
        bl      _dict_hash
        add     x10, x24, x0, lsl #3
        ldr     x1, [x10]
        str     x1, [x6], #8
        str     xzr, [x6], #8
        mov     x0, x6
        str     x23, [x6], #8
        sub     x1, x0, x7
        and     x1, x1, #0xFFFF
        sub     x2, x0, x8
        and     x2, x2, #0xFFFF
        lsl     x2, x2, #16
        orr     x1, x1, x2
        ; Line and file id. _view_line_now is a leaf, so HERE and the
        ; link slot in x6, x9, and x10 stay live. x0 is the CFA.
        stp     x0, x1, [sp, #96]
        bl      _view_line_now
        mov     x3, x0
        adrp    x2, view_src_id
        add     x2, x2, view_src_id
        ldr     x2, [x2]
        ldp     x0, x1, [sp, #96]
        and     x3, x3, #0xFFFF
        lsl     x3, x3, #32
        orr     x1, x1, x3
        mov     x4, #0x1FFF
        and     x2, x2, x4
        lsl     x2, x2, #48
        orr     x1, x1, x2
        ldr     x5, [sp, #112]
        orr     x1, x1, x5
        str     x1, [x0, #-8]
        str     x6, [x9]
        str     x0, [x10]
        adrp    x2, last_cfa
        add     x2, x2, last_cfa
        str     x0, [x2]
        ldp     x23, x24, [sp, #80]
        ldp     x21, x22, [sp, #64]
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #128
        ret
        ENDP

; x0=CFA -> x0=NFA. Clobbers x1.
_nfa_from_cfa
        ldr     x1, [x0, #-8]
        and     x1, x1, #0xFFFF
        sub     x0, x0, x1
        ret

; x0=CFA. Sets NFA smudge bit.
_nfa_smudge_cfa
        ldr     x1, [x0, #-8]
        and     x1, x1, #0xFFFF
        sub     x1, x0, x1
        ldrb    w2, [x1]
        orr     w2, w2, #0x80
        strb    w2, [x1]
        ret

; x0=CFA. Clears NFA smudge bit.
_nfa_reveal_cfa
        ldr     x1, [x0, #-8]
        and     x1, x1, #0xFFFF
        sub     x1, x0, x1
        ldrb    w2, [x1]
        and     w2, w2, #0x7F
        strb    w2, [x1]
        ret

; x0=token, x1=len. x0=CFA or 0, x1=flags. Preserves x19-x24.
; Walks search_order. _dict_hash clobbers x0-x5, so the token stays in x6/x7.
_find_word
        mov     x6, x0
        mov     x7, x1
        mov     x12, x30
        bl      _dict_hash
        mov     x30, x12
        mov     x14, x0
        adrp    x10, search_order_n
        add     x10, x10, search_order_n
        ldr     x11, [x10]
        mov     x13, #0
_find_wids
        cmp     x13, x11
        b.hs    _find_miss
        adrp    x10, search_order
        add     x10, x10, search_order
        ldr     x10, [x10, x13, lsl #3]
        cbz     x10, _find_next_wid
        add     x4, x10, x14, lsl #3
        ldr     x4, [x4]
_find_loop
        cbz     x4, _find_next_wid
        ldr     x5, [x4, #-8]
        and     x8, x5, #0xFFFF
        sub     x8, x4, x8
        ldrb    w9, [x8]
        tbnz    w9, #7, _find_link
        and     w9, w9, #0x7F
        cmp     w9, w7
        b.ne    _find_link
        mov     x9, x6
        add     x10, x8, #1
        mov     x15, x7
_find_cmp
        cbz     x15, _find_hit
        ldrb    w12, [x9], #1
        ldrb    w16, [x10], #1
        cmp     w12, #'a'
        b.lo    _find_fold
        cmp     w12, #'z'
        b.hi    _find_fold
        sub     w12, w12, #32
_find_fold
        cmp     w12, w16
        b.ne    _find_link
        sub     x15, x15, #1
        b       _find_cmp
_find_hit
        ldr     x1, [x4, #-8]
        mov     x0, x4
        ret
_find_link
        ldr     x4, [x4, #-16]
        b       _find_loop
_find_next_wid
        add     x13, x13, #1
        b       _find_wids
_find_miss
        mov     x0, #0
        mov     x1, #0
        ret

; x0=addr, x1=len.
; x0=1 and x1=value for a single cell.
; x0=2, x1=lo, x2=hi when the token ends in '.'
; x0=0 on failure.
; Honors BASE (2..36). Optional # $ % prefixes and a leading sign.
; A trailing dot is a double. The high cell is the sign extension.
; Does not clobber the VM registers.
_parse_number
        cbz     x1, _pnum_no
        mov     x9, x0
        mov     x10, x1
        mov     x11, #0
        mov     x12, #0
        add     x3, x9, x10
        ldrb    w4, [x3, #-1]
        cmp     w4, #46
        b.ne    _pnum_base
        mov     x12, #1
        sub     x10, x10, #1
        cbz     x10, _pnum_no
_pnum_base
        adrp    x5, base_var
        add     x5, x5, base_var
        ldr     x5, [x5]
        cmp     x5, #2
        b.lo    _pnum_b10
        cmp     x5, #36
        b.ls    _pnum_bok
_pnum_b10
        mov     x5, #10
_pnum_bok
        ldrb    w3, [x9]
        cmp     w3, #'-'
        b.ne    _pnum_pref
        mov     x11, #1
        add     x9, x9, #1
        sub     x10, x10, #1
        cbz     x10, _pnum_no
        ldrb    w3, [x9]
_pnum_pref
        cmp     w3, #'#'
        b.ne    _pnum_hex
        mov     x5, #10
        b       _pnum_ate
_pnum_hex
        cmp     w3, #'$'
        b.ne    _pnum_bin
        mov     x5, #16
        b       _pnum_ate
_pnum_bin
        cmp     w3, #'%'
        b.ne    _pnum_digs
        mov     x5, #2
_pnum_ate
        add     x9, x9, #1
        sub     x10, x10, #1
        cbz     x10, _pnum_no
        cbnz    x11, _pnum_digs
        ldrb    w3, [x9]
        cmp     w3, #'-'
        b.ne    _pnum_digs
        mov     x11, #1
        add     x9, x9, #1
        sub     x10, x10, #1
_pnum_digs
        cbz     x10, _pnum_no
        mov     x6, #0
        mov     x7, #0
_pnum_loop
        cbz     x10, _pnum_done
        ldrb    w3, [x9], #1
        sub     x10, x10, #1
        sub     w4, w3, #'0'
        cmp     w4, #9
        b.ls    _pnum_digit
        cmp     w3, #'a'
        b.lo    _pnum_upper
        cmp     w3, #'z'
        b.hi    _pnum_no
        sub     w4, w3, #'a'
        add     w4, w4, #10
        b       _pnum_digit
_pnum_upper
        cmp     w3, #'A'
        b.lo    _pnum_no
        cmp     w3, #'Z'
        b.hi    _pnum_no
        sub     w4, w3, #'A'
        add     w4, w4, #10
_pnum_digit
        cmp     x4, x5
        b.hs    _pnum_no
        mul     x6, x6, x5
        add     x6, x6, x4
        add     x7, x7, #1
        b       _pnum_loop
_pnum_done
        cbz     x7, _pnum_no
        cbz     x11, _pnum_pos
        neg     x6, x6
_pnum_pos
        cbz     x12, _pnum_yes
        asr     x2, x6, #63
        mov     x1, x6
        mov     x0, #2
        ret
_pnum_yes
        mov     x1, x6
        mov     x0, #1
        ret
_pnum_no
        mov     x0, #0
        ret

; x0 = source_base + >IN. Also refreshes source_cur. Clobbers x1.
_cursor_load
        adrp    x0, source_base
        add     x0, x0, source_base
        ldr     x0, [x0]
        adrp    x1, to_in
        add     x1, x1, to_in
        ldr     x1, [x1]
        add     x0, x0, x1
        adrp    x1, source_cur
        add     x1, x1, source_cur
        str     x0, [x1]
        ret

; x0 = absolute cursor. Writes source_cur and >IN. Preserves x0 and x1.
_cursor_commit
        stp     x0, x1, [sp, #-16]!
        adrp    x1, source_cur
        add     x1, x1, source_cur
        str     x0, [x1]
        adrp    x1, source_base
        add     x1, x1, source_base
        ldr     x1, [x1]
        sub     x0, x0, x1
        adrp    x1, to_in
        add     x1, x1, to_in
        str     x0, [x1]
        ldp     x0, x1, [sp], #16
        ret

; x0=addr, x1=len. x1=0 at end of the line. Preserves x19-x24.
; >IN is the cursor. A high-level >IN ! is a plain store into that cell.
_next_word
        stp     x29, x30, [sp, #-16]!
        bl      _cursor_load
        adrp    x3, source_end
        add     x3, x3, source_end
        ldr     x3, [x3]
_nw_skip
        cmp     x0, x3
        b.hs    _nw_none
        ldrb    w4, [x0]
        cmp     w4, #32
        b.eq    _nw_adv
        cmp     w4, #9
        b.eq    _nw_adv
        cmp     w4, #10
        b.eq    _nw_adv
        cmp     w4, #13
        b.eq    _nw_adv
        b       _nw_tok
_nw_adv
        add     x0, x0, #1
        b       _nw_skip
_nw_tok
        mov     x1, x0
_nw_scan
        cmp     x0, x3
        b.hs    _nw_have
        ldrb    w4, [x0]
        cmp     w4, #32
        b.eq    _nw_have
        cmp     w4, #9
        b.eq    _nw_have
        cmp     w4, #10
        b.eq    _nw_have
        cmp     w4, #13
        b.eq    _nw_have
        add     x0, x0, #1
        b       _nw_scan
_nw_have
        mov     x4, x0
        cmp     x0, x3
        b.hs    _nw_store
        ldrb    w5, [x0]
        cmp     w5, #32
        b.eq    _nw_eat
        cmp     w5, #9
        b.eq    _nw_eat
        cmp     w5, #10
        b.eq    _nw_eat
        cmp     w5, #13
        b.eq    _nw_eat
        b       _nw_store
_nw_eat
        add     x0, x0, #1
_nw_store
        bl      _cursor_commit
        sub     x1, x4, x1
        sub     x0, x4, x1
        ldp     x29, x30, [sp], #16
        ret
_nw_none
        bl      _cursor_commit
        mov     x1, #0
        ldp     x29, x30, [sp], #16
        ret

; x0 = cell appended at HERE.
_compile_cell
        adrp    x1, here_ptr
        add     x1, x1, here_ptr
        ldr     x2, [x1]
        str     x0, [x2], #8
        str     x2, [x1]
        ret

; x0 = string. Returns length in x0.
_strlen
        mov     x1, x0
_strlen_loop
        ldrb    w2, [x0], #1
        cbnz    w2, _strlen_loop
        sub     x0, x0, x1
        sub     x0, x0, #1
        ret

; x2=help addr, x3=help length. Clears the pending help.
_take_pending_help
        adrp    x0, pending_help_addr
        add     x0, x0, pending_help_addr
        ldr     x2, [x0]
        adrp    x1, pending_help_len
        add     x1, x1, pending_help_len
        ldr     x3, [x1]
        str     xzr, [x0]
        str     xzr, [x1]
        cbnz    x2, _tph_ok
        adrp    x2, boot_h_empty
        add     x2, x2, boot_h_empty
        mov     x3, #0
_tph_ok
        ret

        BOOT_WORD :, ( 'name' -- ) start colon definition, 0, XCOLON, 0
XCOLON
        sub     sp, sp, #96
        stp     x29, x30, [sp, #32]
        bl      _local_compile_reset
        bl      _next_word
        cbz     x1, _colon_fail
        stp     x0, x1, [sp, #48]
        bl      _take_pending_help
        ldp     x0, x1, [sp, #48]
        adrp    x4, DOCOL
        add     x4, x4, DOCOL
        mov     x5, #0
        bl      _header_build
        bl      _nfa_smudge_cfa
        adrp    x1, here_ptr
        add     x1, x1, here_ptr
        ldr     x2, [x1]
        str     xzr, [x2], #8
        str     x2, [x1]
        adrp    x1, state_var
        add     x1, x1, state_var
        mov     x2, #1
        str     x2, [x1]
        adrp    x1, noname_xt
        add     x1, x1, noname_xt
        str     xzr, [x1]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT

_colon_fail
        adrp    x0, msg_huh
        add     x0, x0, msg_huh
        bl      emit_cstr
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        NEXT

        BOOT_WORD_SEMI  ( -- ) end colon definition (immediate), FLAG_IMM, XSEMI, 0
XSEMI
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        adrp    x0, exit_cfa
        add     x0, x0, exit_cfa
        ldr     x0, [x0]
        bl      _compile_cell
        adrp    x0, last_cfa
        add     x0, x0, last_cfa
        ldr     x0, [x0]
        bl      _nfa_reveal_cfa
        adrp    x1, state_var
        add     x1, x1, state_var
        str     xzr, [x1]
        bl      _local_compile_reset
        adrp    x0, noname_xt
        add     x0, x0, noname_xt
        ldr     x1, [x0]
        cbz     x1, _semi_done
        str     xzr, [x0]
        str     x20, [x22, #-8]!
        mov     x20, x1
_semi_done
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

        BOOT_WORD :NONAME, :NONAME ( -- xt ) anonymous colon definition. semicolon leaves the xt, 0, XNONAME, 0
XNONAME
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _local_compile_reset
        bl      _take_pending_help
        adrp    x0, boot_h_empty
        add     x0, x0, boot_h_empty
        mov     x1, #0
        adrp    x4, DOCOL
        add     x4, x4, DOCOL
        mov     x5, #0
        bl      _header_build
        bl      _nfa_smudge_cfa
        adrp    x1, here_ptr
        add     x1, x1, here_ptr
        ldr     x2, [x1]
        str     xzr, [x2], #8
        str     x2, [x1]
        adrp    x1, last_cfa
        add     x1, x1, last_cfa
        ldr     x2, [x1]
        adrp    x1, noname_xt
        add     x1, x1, noname_xt
        str     x2, [x1]
        adrp    x1, state_var
        add     x1, x1, state_var
        mov     x2, #1
        str     x2, [x1]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

next_debug_gate
        adrp    x16, next_debug
        add     x16, x16, next_debug
        br      x16

        AREA |.rdata|, DATA, READONLY

boot_h_empty DCB    0
msg_huh     DCB     " ?", 10, 0

        END
