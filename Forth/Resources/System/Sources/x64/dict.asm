; Generated from Forth/kernel/arm64/dict.asm. Do not edit.
OPTION CASEMAP:NONE
EXTRN arm_excl:QWORD
EXTRN arm_excl_addr:QWORD
EXTRN arm_excl_val:QWORD
EXTRN DOCOL:PROC
EXTRN _core_console_only:PROC
EXTRN _here_reserve_exact:PROC
EXTRN _local_compile_reset:PROC
EXTRN _print_string_svc:PROC
EXTRN _task_dp_bounds:PROC
EXTRN _task_require_dict:PROC
EXTRN _task_stop_or_abandon:PROC
EXTRN _view_line_now:PROC
EXTRN base_var:BYTE
EXTRN current_var:BYTE
EXTRN debug_break_asap:BYTE
EXTRN emit_cstr:PROC
EXTRN exit_cfa:BYTE
EXTRN here_ptr:BYTE
EXTRN last_cfa:BYTE
EXTRN next_debug:PROC
EXTRN noname_xt:BYTE
EXTRN pending_help_addr:BYTE
EXTRN pending_help_len:BYTE
EXTRN search_order:BYTE
EXTRN search_order_n:BYTE
EXTRN state_var:BYTE
EXTRN str_dict_full:BYTE
EXTRN up_var:BYTE
EXTRN view_src_id:BYTE
.CODE
PUBLIC _dict_hash
PUBLIC _header_build
PUBLIC _nfa_from_cfa
PUBLIC _nfa_smudge_cfa
PUBLIC _nfa_reveal_cfa
PUBLIC _find_word
PUBLIC _parse_number
PUBLIC _next_word
PUBLIC _cursor_load
PUBLIC _cursor_commit
PUBLIC _compile_cell
PUBLIC _strlen
PUBLIC _take_pending_help
PUBLIC XCOLON
PUBLIC XSEMI
_dict_hash:
    ; mov     x2, #5381
    mov rax, 1505h
    mov QWORD PTR [r15+16], rax
    ; cbz     x1, _dict_hash_empty
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _dict_hash_empty
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR [r15+24], rax
_dict_hash_1:
    ; cmp     x3, x1
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _dict_hash_2
    cmp BYTE PTR [r15+250], 0
    jne _dict_hash_2
    ; ldrb    w4, [x0, x3]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+24]
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; cmp     w4, #'a'
    mov eax, DWORD PTR [r15+32]
    cmp eax, 61h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _dict_hash_11
    cmp BYTE PTR [r15+250], 0
    je _dict_hash_11
    ; cmp     w4, #'z'
    mov eax, DWORD PTR [r15+32]
    cmp eax, 7Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _dict_hash_11
    cmp BYTE PTR [r15+250], 0
    je xsk_1
    cmp BYTE PTR [r15+249], 0
    je _dict_hash_11
    xsk_1:
    ; sub     w4, w4, #32
    mov eax, DWORD PTR [r15+32]
    sub eax, 20h
    mov QWORD PTR [r15+32], rax
_dict_hash_11:
    ; lsl     x5, x2, #5
    mov rax, QWORD PTR [r15+16]
    shl rax, 5
    mov QWORD PTR [r15+40], rax
    ; add     x2, x5, x2
    mov rax, QWORD PTR [r15+40]
    mov rcx, QWORD PTR [r15+16]
    add rax, rcx
    mov QWORD PTR [r15+16], rax
    ; add     x2, x2, x4
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+32]
    add rax, rcx
    mov QWORD PTR [r15+16], rax
    ; add     x3, x3, #1
    mov rax, QWORD PTR [r15+24]
    add rax, 1
    mov QWORD PTR [r15+24], rax
    ; b       _dict_hash_1
    jmp _dict_hash_1
_dict_hash_2:
    ; mov     x0, #16
    mov rax, 10h
    mov QWORD PTR [r15+0], rax
    ; udiv    x1, x2, x0
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+0]
    cmp rcx, 0
    je xdiv0_3
    xor rdx, rdx
    div rcx
    jmp xdiv_2
    xdiv0_3:
    xor eax, eax
    xdiv_2:
    mov QWORD PTR [r15+8], rax
    ; msub    x0, x1, x0, x2
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+0]
    imul rax, rcx
    mov rcx, QWORD PTR [r15+16]
    sub rcx, rax
    mov rax, rcx
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_dict_hash_empty:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_header_build:
    ; sub     sp, sp, #128
    mov rax, rsp
    sub rax, 80h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r15+168]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+176]
    mov QWORD PTR [r10+8], rax
    ; stp     x23, x24, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR [r15+184]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+192]
    mov QWORD PTR [r10+8], rax
    ; str     x5, [sp, #112]
    lea r10, [rsp]
    add r10, 70h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; mov     x19, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+152], rax
    ; mov     x20, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+160], rax
    ; mov     x21, x2
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r15+168], rax
    ; mov     x22, x3
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r15+176], rax
    ; mov     x23, x4
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [r15+184], rax
    ; bl      _task_require_dict
    lea rax, xret_4
    mov QWORD PTR [r15+240], rax
    jmp _task_require_dict
    xret_4:
    ; bl      _task_dp_bounds
    lea rax, xret_5
    mov QWORD PTR [r15+240], rax
    jmp _task_dp_bounds
    xret_5:
    ; mov     x9, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+72], rax
    ; lea x6, here_ptr
    lea rax, here_ptr
    mov QWORD PTR [r15+48], rax
    ; cmp     x9, x6
    mov rax, QWORD PTR [r15+72]
    mov rcx, QWORD PTR [r15+48]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _hb_here
    cmp BYTE PTR [r15+249], 0
    jne _hb_here
    ; ldr     x8, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+64], rax
    ; add     x7, x8, #512
    mov rax, QWORD PTR [r15+64]
    add rax, 200h
    mov QWORD PTR [r15+56], rax
    ; cmp     x7, x8
    mov rax, QWORD PTR [r15+56]
    mov rcx, QWORD PTR [r15+64]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _hb_full
    cmp BYTE PTR [r15+250], 0
    je _hb_full
    ; cmp     x7, x1
    mov rax, QWORD PTR [r15+56]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _hb_full
    cmp BYTE PTR [r15+250], 0
    je xsk_6
    cmp BYTE PTR [r15+249], 0
    je _hb_full
    xsk_6:
_hb_here:
    ; lea x24, current_var
    lea rax, current_var
    mov QWORD PTR [r15+192], rax
    ; ldr     x24, [x24]
    mov r10, QWORD PTR [r15+192]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+192], rax
    ; ldr     x6, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+48], rax
    ; mov     x8, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+64], rax
    ; cmp     x22, #255
    mov rax, QWORD PTR [r15+176]
    cmp rax, 0FFh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ls    _hb_help_ok
    cmp BYTE PTR [r15+250], 0
    je _hb_help_ok
    cmp BYTE PTR [r15+249], 0
    jne _hb_help_ok
    ; mov     x22, #255
    mov rax, 0FFh
    mov QWORD PTR [r15+176], rax
_hb_help_ok:
    ; strb    w22, [x6], #1
    mov r10, QWORD PTR [r15+48]
    mov eax, DWORD PTR [r15+176]
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR [r15+48]
    add rax, 1
    mov QWORD PTR [r15+48], rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR [r15+16], rax
_hb_help_cp:
    ; cmp     x2, x22
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+176]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _hb_help_pad
    cmp BYTE PTR [r15+250], 0
    jne _hb_help_pad
    ; ldrb    w3, [x21, x2]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r15+16]
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; strb    w3, [x6], #1
    mov r10, QWORD PTR [r15+48]
    mov eax, DWORD PTR [r15+24]
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR [r15+48]
    add rax, 1
    mov QWORD PTR [r15+48], rax
    ; add     x2, x2, #1
    mov rax, QWORD PTR [r15+16]
    add rax, 1
    mov QWORD PTR [r15+16], rax
    ; b       _hb_help_cp
    jmp _hb_help_cp
_hb_help_pad:
    ; sub     x2, x6, x8
    mov rax, QWORD PTR [r15+48]
    mov rcx, QWORD PTR [r15+64]
    sub rax, rcx
    mov QWORD PTR [r15+16], rax
_hb_help_al:
    ; tst     x2, #7
    mov rax, QWORD PTR [r15+16]
    test rax, 7
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setc BYTE PTR [r15+250]
    ; b.eq    _hb_name
    cmp BYTE PTR [r15+249], 0
    jne _hb_name
    ; strb    wzr, [x6], #1
    mov r10, QWORD PTR [r15+48]
    mov BYTE PTR [r10], 0
    mov rax, QWORD PTR [r15+48]
    add rax, 1
    mov QWORD PTR [r15+48], rax
    ; add     x2, x2, #1
    mov rax, QWORD PTR [r15+16]
    add rax, 1
    mov QWORD PTR [r15+16], rax
    ; b       _hb_help_al
    jmp _hb_help_al
_hb_name:
    ; mov     x7, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+56], rax
    ; cmp     x20, #127
    mov rax, QWORD PTR [r15+160]
    cmp rax, 7Fh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ls    _hb_nlen
    cmp BYTE PTR [r15+250], 0
    je _hb_nlen
    cmp BYTE PTR [r15+249], 0
    jne _hb_nlen
    ; mov     x20, #127
    mov rax, 7Fh
    mov QWORD PTR [r15+160], rax
_hb_nlen:
    ; and     w20, w20, #0x7F
    mov eax, DWORD PTR [r15+160]
    and eax, 7Fh
    mov QWORD PTR [r15+160], rax
    ; strb    w20, [x6], #1
    mov r10, QWORD PTR [r15+48]
    mov eax, DWORD PTR [r15+160]
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR [r15+48]
    add rax, 1
    mov QWORD PTR [r15+48], rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR [r15+16], rax
_hb_name_cp:
    ; cmp     x2, x20
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+160]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _hb_name_pad
    cmp BYTE PTR [r15+250], 0
    jne _hb_name_pad
    ; ldrb    w3, [x19, x2]
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r15+16]
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; cmp     w3, #'a'
    mov eax, DWORD PTR [r15+24]
    cmp eax, 61h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _hb_name_st
    cmp BYTE PTR [r15+250], 0
    je _hb_name_st
    ; cmp     w3, #'z'
    mov eax, DWORD PTR [r15+24]
    cmp eax, 7Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _hb_name_st
    cmp BYTE PTR [r15+250], 0
    je xsk_7
    cmp BYTE PTR [r15+249], 0
    je _hb_name_st
    xsk_7:
    ; sub     w3, w3, #32
    mov eax, DWORD PTR [r15+24]
    sub eax, 20h
    mov QWORD PTR [r15+24], rax
_hb_name_st:
    ; strb    w3, [x6], #1
    mov r10, QWORD PTR [r15+48]
    mov eax, DWORD PTR [r15+24]
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR [r15+48]
    add rax, 1
    mov QWORD PTR [r15+48], rax
    ; add     x2, x2, #1
    mov rax, QWORD PTR [r15+16]
    add rax, 1
    mov QWORD PTR [r15+16], rax
    ; b       _hb_name_cp
    jmp _hb_name_cp
_hb_name_pad:
    ; sub     x2, x6, x7
    mov rax, QWORD PTR [r15+48]
    mov rcx, QWORD PTR [r15+56]
    sub rax, rcx
    mov QWORD PTR [r15+16], rax
_hb_name_al:
    ; tst     x2, #7
    mov rax, QWORD PTR [r15+16]
    test rax, 7
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setc BYTE PTR [r15+250]
    ; b.eq    _hb_link
    cmp BYTE PTR [r15+249], 0
    jne _hb_link
    ; strb    wzr, [x6], #1
    mov r10, QWORD PTR [r15+48]
    mov BYTE PTR [r10], 0
    mov rax, QWORD PTR [r15+48]
    add rax, 1
    mov QWORD PTR [r15+48], rax
    ; add     x2, x2, #1
    mov rax, QWORD PTR [r15+16]
    add rax, 1
    mov QWORD PTR [r15+16], rax
    ; b       _hb_name_al
    jmp _hb_name_al
_hb_link:
    ; mov     x0, x19
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r15+0], rax
    ; mov     x1, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+8], rax
    ; bl      _dict_hash
    lea rax, xret_8
    mov QWORD PTR [r15+240], rax
    jmp _dict_hash
    xret_8:
    ; add     x10, x24, x0, lsl #3
    mov rax, QWORD PTR [r15+192]
    mov rcx, QWORD PTR [r15+0]
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR [r15+80], rax
    ; ldr     x1, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x6], #8
    mov r10, QWORD PTR [r15+48]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR [r15+48]
    add rax, 8
    mov QWORD PTR [r15+48], rax
    ; str     xzr, [x6], #8
    mov r10, QWORD PTR [r15+48]
    mov QWORD PTR [r10], 0
    mov rax, QWORD PTR [r15+48]
    add rax, 8
    mov QWORD PTR [r15+48], rax
    ; mov     x0, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+0], rax
    ; str     x23, [x6], #8
    mov r10, QWORD PTR [r15+48]
    mov rax, QWORD PTR [r15+184]
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR [r15+48]
    add rax, 8
    mov QWORD PTR [r15+48], rax
    ; sub     x1, x0, x7
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+56]
    sub rax, rcx
    mov QWORD PTR [r15+8], rax
    ; and     x1, x1, #0xFFFF
    mov rax, QWORD PTR [r15+8]
    and rax, 0FFFFh
    mov QWORD PTR [r15+8], rax
    ; sub     x2, x0, x8
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+64]
    sub rax, rcx
    mov QWORD PTR [r15+16], rax
    ; and     x2, x2, #0xFFFF
    mov rax, QWORD PTR [r15+16]
    and rax, 0FFFFh
    mov QWORD PTR [r15+16], rax
    ; lsl     x2, x2, #16
    mov rax, QWORD PTR [r15+16]
    shl rax, 16
    mov QWORD PTR [r15+16], rax
    ; orr     x1, x1, x2
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+16]
    or rax, rcx
    mov QWORD PTR [r15+8], rax
    ; stp     x0, x1, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10+8], rax
    ; bl      _view_line_now
    lea rax, xret_9
    mov QWORD PTR [r15+240], rax
    jmp _view_line_now
    xret_9:
    ; mov     x3, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+24], rax
    ; lea x2, view_src_id
    lea rax, view_src_id
    mov QWORD PTR [r15+16], rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; ldp     x0, x1, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+0], rax
    mov QWORD PTR [r15+8], rcx
    ; and     x3, x3, #0xFFFF
    mov rax, QWORD PTR [r15+24]
    and rax, 0FFFFh
    mov QWORD PTR [r15+24], rax
    ; lsl     x3, x3, #32
    mov rax, QWORD PTR [r15+24]
    shl rax, 32
    mov QWORD PTR [r15+24], rax
    ; orr     x1, x1, x3
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+24]
    or rax, rcx
    mov QWORD PTR [r15+8], rax
    ; mov     x4, #0x1FFF
    mov rax, 1FFFh
    mov QWORD PTR [r15+32], rax
    ; and     x2, x2, x4
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+32]
    and rax, rcx
    mov QWORD PTR [r15+16], rax
    ; lsl     x2, x2, #48
    mov rax, QWORD PTR [r15+16]
    shl rax, 48
    mov QWORD PTR [r15+16], rax
    ; orr     x1, x1, x2
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+16]
    or rax, rcx
    mov QWORD PTR [r15+8], rax
    ; ldr     x5, [sp, #112]
    lea r10, [rsp]
    add r10, 70h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; orr     x1, x1, x5
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+40]
    or rax, rcx
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #-8]
    mov r10, QWORD PTR [r15+0]
    add r10, -8
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; str     x6, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r10], rax
    ; str     x0, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; lea x2, last_cfa
    lea rax, last_cfa
    mov QWORD PTR [r15+16], rax
    ; str     x0, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ldp     x23, x24, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+184], rax
    mov QWORD PTR [r15+192], rcx
    ; ldp     x21, x22, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+168], rax
    mov QWORD PTR [r15+176], rcx
    ; ldp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+152], rax
    mov QWORD PTR [r15+160], rcx
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    ; add     sp, sp, #128
    mov rax, rsp
    add rax, 80h
    mov rsp, rax
    ; ret
    jmp QWORD PTR [r15+240]
_hb_full:
    ; ldp     x23, x24, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+184], rax
    mov QWORD PTR [r15+192], rcx
    ; ldp     x21, x22, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+168], rax
    mov QWORD PTR [r15+176], rcx
    ; ldp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+152], rax
    mov QWORD PTR [r15+160], rcx
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    ; add     sp, sp, #128
    mov rax, rsp
    add rax, 80h
    mov rsp, rax
    ; lea x0, str_dict_full
    lea rax, str_dict_full
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_10
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_10:
    ; b       _task_stop_or_abandon
    jmp _task_stop_or_abandon
_nfa_from_cfa:
    ; ldr     x1, [x0, #-8]
    mov r10, QWORD PTR [r15+0]
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; and     x1, x1, #0xFFFF
    mov rax, QWORD PTR [r15+8]
    and rax, 0FFFFh
    mov QWORD PTR [r15+8], rax
    ; sub     x0, x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    sub rax, rcx
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_nfa_smudge_cfa:
    ; ldr     x1, [x0, #-8]
    mov r10, QWORD PTR [r15+0]
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; and     x1, x1, #0xFFFF
    mov rax, QWORD PTR [r15+8]
    and rax, 0FFFFh
    mov QWORD PTR [r15+8], rax
    ; sub     x1, x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    sub rax, rcx
    mov QWORD PTR [r15+8], rax
    ; ldrb    w2, [x1]
    mov r10, QWORD PTR [r15+8]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; orr     w2, w2, #0x80
    mov eax, DWORD PTR [r15+16]
    or eax, 80h
    mov QWORD PTR [r15+16], rax
    ; strb    w2, [x1]
    mov r10, QWORD PTR [r15+8]
    mov eax, DWORD PTR [r15+16]
    mov BYTE PTR [r10], al
    ; ret
    jmp QWORD PTR [r15+240]
_nfa_reveal_cfa:
    ; ldr     x1, [x0, #-8]
    mov r10, QWORD PTR [r15+0]
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; and     x1, x1, #0xFFFF
    mov rax, QWORD PTR [r15+8]
    and rax, 0FFFFh
    mov QWORD PTR [r15+8], rax
    ; sub     x1, x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    sub rax, rcx
    mov QWORD PTR [r15+8], rax
    ; ldrb    w2, [x1]
    mov r10, QWORD PTR [r15+8]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; and     w2, w2, #0x7F
    mov eax, DWORD PTR [r15+16]
    and eax, 7Fh
    mov QWORD PTR [r15+16], rax
    ; strb    w2, [x1]
    mov r10, QWORD PTR [r15+8]
    mov eax, DWORD PTR [r15+16]
    mov BYTE PTR [r10], al
    ; ret
    jmp QWORD PTR [r15+240]
_find_word:
    ; mov     x6, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+48], rax
    ; mov     x7, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+56], rax
    ; mov     x12, x30
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r15+96], rax
    ; bl      _dict_hash
    lea rax, xret_11
    mov QWORD PTR [r15+240], rax
    jmp _dict_hash
    xret_11:
    ; mov     x30, x12
    mov rax, QWORD PTR [r15+96]
    mov QWORD PTR [r15+240], rax
    ; mov     x14, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+112], rax
    ; lea x10, search_order_n
    lea rax, search_order_n
    mov QWORD PTR [r15+80], rax
    ; ldr     x11, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+88], rax
    ; mov     x13, #0
    mov rax, 0
    mov QWORD PTR [r15+104], rax
_find_wids:
    ; cmp     x13, x11
    mov rax, QWORD PTR [r15+104]
    mov rcx, QWORD PTR [r15+88]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _find_miss
    cmp BYTE PTR [r15+250], 0
    jne _find_miss
    ; lea x10, search_order
    lea rax, search_order
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10, x13, lsl #3]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r15+104]
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _find_next_wid
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _find_next_wid
    ; add     x4, x10, x14, lsl #3
    mov rax, QWORD PTR [r15+80]
    mov rcx, QWORD PTR [r15+112]
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR [r15+32], rax
    ; ldr     x4, [x4]
    mov r10, QWORD PTR [r15+32]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+32], rax
_find_loop:
    ; cbz     x4, _find_next_wid
    mov rax, QWORD PTR [r15+32]
    cmp rax, 0
    je _find_next_wid
    ; ldr     x5, [x4, #-8]
    mov r10, QWORD PTR [r15+32]
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; and     x8, x5, #0xFFFF
    mov rax, QWORD PTR [r15+40]
    and rax, 0FFFFh
    mov QWORD PTR [r15+64], rax
    ; sub     x8, x4, x8
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+64]
    sub rax, rcx
    mov QWORD PTR [r15+64], rax
    ; ldrb    w9, [x8]
    mov r10, QWORD PTR [r15+64]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+72], rax
    ; tbnz    w9, #7, _find_link
    mov eax, DWORD PTR [r15+72]
    bt rax, 7
    jc _find_link
    ; and     w9, w9, #0x7F
    mov eax, DWORD PTR [r15+72]
    and eax, 7Fh
    mov QWORD PTR [r15+72], rax
    ; cmp     w9, w7
    mov eax, DWORD PTR [r15+72]
    mov ecx, DWORD PTR [r15+56]
    cmp eax, ecx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _find_link
    cmp BYTE PTR [r15+249], 0
    je _find_link
    ; mov     x9, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+72], rax
    ; add     x10, x8, #1
    mov rax, QWORD PTR [r15+64]
    add rax, 1
    mov QWORD PTR [r15+80], rax
    ; mov     x15, x7
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [r15+120], rax
_find_cmp:
    ; cbz     x15, _find_hit
    mov rax, QWORD PTR [r15+120]
    cmp rax, 0
    je _find_hit
    ; ldrb    w12, [x9], #1
    mov r10, QWORD PTR [r15+72]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+96], rax
    mov rax, QWORD PTR [r15+72]
    add rax, 1
    mov QWORD PTR [r15+72], rax
    ; ldrb    w16, [x10], #1
    mov r10, QWORD PTR [r15+80]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+128], rax
    mov rax, QWORD PTR [r15+80]
    add rax, 1
    mov QWORD PTR [r15+80], rax
    ; cmp     w12, #'a'
    mov eax, DWORD PTR [r15+96]
    cmp eax, 61h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _find_fold
    cmp BYTE PTR [r15+250], 0
    je _find_fold
    ; cmp     w12, #'z'
    mov eax, DWORD PTR [r15+96]
    cmp eax, 7Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _find_fold
    cmp BYTE PTR [r15+250], 0
    je xsk_12
    cmp BYTE PTR [r15+249], 0
    je _find_fold
    xsk_12:
    ; sub     w12, w12, #32
    mov eax, DWORD PTR [r15+96]
    sub eax, 20h
    mov QWORD PTR [r15+96], rax
_find_fold:
    ; cmp     w12, w16
    mov eax, DWORD PTR [r15+96]
    mov ecx, DWORD PTR [r15+128]
    cmp eax, ecx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _find_link
    cmp BYTE PTR [r15+249], 0
    je _find_link
    ; sub     x15, x15, #1
    mov rax, QWORD PTR [r15+120]
    sub rax, 1
    mov QWORD PTR [r15+120], rax
    ; b       _find_cmp
    jmp _find_cmp
_find_hit:
    ; ldr     x1, [x4, #-8]
    mov r10, QWORD PTR [r15+32]
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; mov     x0, x4
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_find_link:
    ; ldr     x4, [x4, #-16]
    mov r10, QWORD PTR [r15+32]
    add r10, -16
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; b       _find_loop
    jmp _find_loop
_find_next_wid:
    ; add     x13, x13, #1
    mov rax, QWORD PTR [r15+104]
    add rax, 1
    mov QWORD PTR [r15+104], rax
    ; b       _find_wids
    jmp _find_wids
_find_miss:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR [r15+8], rax
    ; ret
    jmp QWORD PTR [r15+240]
_parse_number:
    ; cbz     x1, _pnum_no
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _pnum_no
    ; mov     x9, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+72], rax
    ; mov     x10, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+80], rax
    ; mov     x11, #0
    mov rax, 0
    mov QWORD PTR [r15+88], rax
    ; mov     x12, #0
    mov rax, 0
    mov QWORD PTR [r15+96], rax
    ; add     x3, x9, x10
    mov rax, QWORD PTR [r15+72]
    mov rcx, QWORD PTR [r15+80]
    add rax, rcx
    mov QWORD PTR [r15+24], rax
    ; ldrb    w4, [x3, #-1]
    mov r10, QWORD PTR [r15+24]
    add r10, -1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; cmp     w4, #46
    mov eax, DWORD PTR [r15+32]
    cmp eax, 2Eh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _pnum_base
    cmp BYTE PTR [r15+249], 0
    je _pnum_base
    ; mov     x12, #1
    mov rax, 1
    mov QWORD PTR [r15+96], rax
    ; sub     x10, x10, #1
    mov rax, QWORD PTR [r15+80]
    sub rax, 1
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _pnum_no
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _pnum_no
_pnum_base:
    ; lea x5, base_var
    lea rax, base_var
    mov QWORD PTR [r15+40], rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; cmp     x5, #2
    mov rax, QWORD PTR [r15+40]
    cmp rax, 2
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _pnum_b10
    cmp BYTE PTR [r15+250], 0
    je _pnum_b10
    ; cmp     x5, #36
    mov rax, QWORD PTR [r15+40]
    cmp rax, 24h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ls    _pnum_bok
    cmp BYTE PTR [r15+250], 0
    je _pnum_bok
    cmp BYTE PTR [r15+249], 0
    jne _pnum_bok
_pnum_b10:
    ; mov     x5, #10
    mov rax, 0Ah
    mov QWORD PTR [r15+40], rax
_pnum_bok:
    ; ldrb    w3, [x9]
    mov r10, QWORD PTR [r15+72]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; cmp     w3, #'-'
    mov eax, DWORD PTR [r15+24]
    cmp eax, 2Dh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _pnum_pref
    cmp BYTE PTR [r15+249], 0
    je _pnum_pref
    ; mov     x11, #1
    mov rax, 1
    mov QWORD PTR [r15+88], rax
    ; add     x9, x9, #1
    mov rax, QWORD PTR [r15+72]
    add rax, 1
    mov QWORD PTR [r15+72], rax
    ; sub     x10, x10, #1
    mov rax, QWORD PTR [r15+80]
    sub rax, 1
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _pnum_no
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _pnum_no
    ; ldrb    w3, [x9]
    mov r10, QWORD PTR [r15+72]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+24], rax
_pnum_pref:
    ; cmp     w3, #'#'
    mov eax, DWORD PTR [r15+24]
    cmp eax, 23h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _pnum_hex
    cmp BYTE PTR [r15+249], 0
    je _pnum_hex
    ; mov     x5, #10
    mov rax, 0Ah
    mov QWORD PTR [r15+40], rax
    ; b       _pnum_ate
    jmp _pnum_ate
_pnum_hex:
    ; cmp     w3, #'$'
    mov eax, DWORD PTR [r15+24]
    cmp eax, 24h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _pnum_bin
    cmp BYTE PTR [r15+249], 0
    je _pnum_bin
    ; mov     x5, #16
    mov rax, 10h
    mov QWORD PTR [r15+40], rax
    ; b       _pnum_ate
    jmp _pnum_ate
_pnum_bin:
    ; cmp     w3, #'%'
    mov eax, DWORD PTR [r15+24]
    cmp eax, 25h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _pnum_digs
    cmp BYTE PTR [r15+249], 0
    je _pnum_digs
    ; mov     x5, #2
    mov rax, 2
    mov QWORD PTR [r15+40], rax
_pnum_ate:
    ; add     x9, x9, #1
    mov rax, QWORD PTR [r15+72]
    add rax, 1
    mov QWORD PTR [r15+72], rax
    ; sub     x10, x10, #1
    mov rax, QWORD PTR [r15+80]
    sub rax, 1
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _pnum_no
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _pnum_no
    ; cbnz    x11, _pnum_digs
    mov rax, QWORD PTR [r15+88]
    cmp rax, 0
    jne _pnum_digs
    ; ldrb    w3, [x9]
    mov r10, QWORD PTR [r15+72]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; cmp     w3, #'-'
    mov eax, DWORD PTR [r15+24]
    cmp eax, 2Dh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _pnum_digs
    cmp BYTE PTR [r15+249], 0
    je _pnum_digs
    ; mov     x11, #1
    mov rax, 1
    mov QWORD PTR [r15+88], rax
    ; add     x9, x9, #1
    mov rax, QWORD PTR [r15+72]
    add rax, 1
    mov QWORD PTR [r15+72], rax
    ; sub     x10, x10, #1
    mov rax, QWORD PTR [r15+80]
    sub rax, 1
    mov QWORD PTR [r15+80], rax
_pnum_digs:
    ; cbz     x10, _pnum_no
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _pnum_no
    ; mov     x6, #0
    mov rax, 0
    mov QWORD PTR [r15+48], rax
    ; mov     x7, #0
    mov rax, 0
    mov QWORD PTR [r15+56], rax
_pnum_loop:
    ; cbz     x10, _pnum_done
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _pnum_done
    ; ldrb    w3, [x9], #1
    mov r10, QWORD PTR [r15+72]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+24], rax
    mov rax, QWORD PTR [r15+72]
    add rax, 1
    mov QWORD PTR [r15+72], rax
    ; sub     x10, x10, #1
    mov rax, QWORD PTR [r15+80]
    sub rax, 1
    mov QWORD PTR [r15+80], rax
    ; sub     w4, w3, #'0'
    mov eax, DWORD PTR [r15+24]
    sub eax, 30h
    mov QWORD PTR [r15+32], rax
    ; cmp     w4, #9
    mov eax, DWORD PTR [r15+32]
    cmp eax, 9
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ls    _pnum_digit
    cmp BYTE PTR [r15+250], 0
    je _pnum_digit
    cmp BYTE PTR [r15+249], 0
    jne _pnum_digit
    ; cmp     w3, #'a'
    mov eax, DWORD PTR [r15+24]
    cmp eax, 61h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _pnum_upper
    cmp BYTE PTR [r15+250], 0
    je _pnum_upper
    ; cmp     w3, #'z'
    mov eax, DWORD PTR [r15+24]
    cmp eax, 7Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _pnum_no
    cmp BYTE PTR [r15+250], 0
    je xsk_13
    cmp BYTE PTR [r15+249], 0
    je _pnum_no
    xsk_13:
    ; sub     w4, w3, #'a'
    mov eax, DWORD PTR [r15+24]
    sub eax, 61h
    mov QWORD PTR [r15+32], rax
    ; add     w4, w4, #10
    mov eax, DWORD PTR [r15+32]
    add eax, 0Ah
    mov QWORD PTR [r15+32], rax
    ; b       _pnum_digit
    jmp _pnum_digit
_pnum_upper:
    ; cmp     w3, #'A'
    mov eax, DWORD PTR [r15+24]
    cmp eax, 41h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _pnum_no
    cmp BYTE PTR [r15+250], 0
    je _pnum_no
    ; cmp     w3, #'Z'
    mov eax, DWORD PTR [r15+24]
    cmp eax, 5Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _pnum_no
    cmp BYTE PTR [r15+250], 0
    je xsk_14
    cmp BYTE PTR [r15+249], 0
    je _pnum_no
    xsk_14:
    ; sub     w4, w3, #'A'
    mov eax, DWORD PTR [r15+24]
    sub eax, 41h
    mov QWORD PTR [r15+32], rax
    ; add     w4, w4, #10
    mov eax, DWORD PTR [r15+32]
    add eax, 0Ah
    mov QWORD PTR [r15+32], rax
_pnum_digit:
    ; cmp     x4, x5
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+40]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _pnum_no
    cmp BYTE PTR [r15+250], 0
    jne _pnum_no
    ; mul     x6, x6, x5
    mov rax, QWORD PTR [r15+48]
    mov rcx, QWORD PTR [r15+40]
    imul rax, rcx
    mov QWORD PTR [r15+48], rax
    ; add     x6, x6, x4
    mov rax, QWORD PTR [r15+48]
    mov rcx, QWORD PTR [r15+32]
    add rax, rcx
    mov QWORD PTR [r15+48], rax
    ; add     x7, x7, #1
    mov rax, QWORD PTR [r15+56]
    add rax, 1
    mov QWORD PTR [r15+56], rax
    ; b       _pnum_loop
    jmp _pnum_loop
_pnum_done:
    ; cbz     x7, _pnum_no
    mov rax, QWORD PTR [r15+56]
    cmp rax, 0
    je _pnum_no
    ; cbz     x11, _pnum_pos
    mov rax, QWORD PTR [r15+88]
    cmp rax, 0
    je _pnum_pos
    ; neg     x6, x6
    mov rax, QWORD PTR [r15+48]
    neg rax
    mov QWORD PTR [r15+48], rax
_pnum_pos:
    ; cbz     x12, _pnum_yes
    mov rax, QWORD PTR [r15+96]
    cmp rax, 0
    je _pnum_yes
    ; asr     x2, x6, #63
    mov rax, QWORD PTR [r15+48]
    sar rax, 63
    mov QWORD PTR [r15+16], rax
    ; mov     x1, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+8], rax
    ; mov     x0, #2
    mov rax, 2
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_pnum_yes:
    ; mov     x1, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+8], rax
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_pnum_no:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_cursor_load:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_1
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_1
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_1:
    ; ldr     x0, [x16, #TU_SRC_ADDR]
    mov r10, QWORD PTR [r15+128]
    add r10, 68h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_3
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_3
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_3:
    ; ldr     x1, [x16, #TU_TO_IN]
    mov r10, QWORD PTR [r15+128]
    add r10, 78h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; add     x0, x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    add rax, rcx
    mov QWORD PTR [r15+0], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_5
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_5
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_5:
    ; str     x0, [x16, #TU_WORD_CURSOR]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B8h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ret
    jmp QWORD PTR [r15+240]
_cursor_commit:
    ; stp     x0, x1, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10+8], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_7
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_7
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_7:
    ; str     x0, [x16, #TU_WORD_CURSOR]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B8h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_9
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_9
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_9:
    ; ldr     x1, [x16, #TU_SRC_ADDR]
    mov r10, QWORD PTR [r15+128]
    add r10, 68h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; sub     x0, x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    sub rax, rcx
    mov QWORD PTR [r15+0], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_11
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_11
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_11:
    ; str     x0, [x16, #TU_TO_IN]
    mov r10, QWORD PTR [r15+128]
    add r10, 78h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ldp     x0, x1, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+0], rax
    mov QWORD PTR [r15+8], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_next_word:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; bl      _cursor_load
    lea rax, xret_15
    mov QWORD PTR [r15+240], rax
    jmp _cursor_load
    xret_15:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_13
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_13
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_13:
    ; ldr     x3, [x16, #TU_SRC_ADDR]
    mov r10, QWORD PTR [r15+128]
    add r10, 68h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; ldr     x17, [x16, #TU_SRC_LEN]
    mov r10, QWORD PTR [r15+128]
    add r10, 70h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+136], rax
    ; add     x3, x3, x17
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+136]
    add rax, rcx
    mov QWORD PTR [r15+24], rax
_nw_skip:
    ; cmp     x0, x3
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _nw_none
    cmp BYTE PTR [r15+250], 0
    jne _nw_none
    ; ldrb    w4, [x0]
    mov r10, QWORD PTR [r15+0]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; cmp     w4, #32
    mov eax, DWORD PTR [r15+32]
    cmp eax, 20h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_adv
    cmp BYTE PTR [r15+249], 0
    jne _nw_adv
    ; cmp     w4, #9
    mov eax, DWORD PTR [r15+32]
    cmp eax, 9
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_adv
    cmp BYTE PTR [r15+249], 0
    jne _nw_adv
    ; cmp     w4, #10
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_adv
    cmp BYTE PTR [r15+249], 0
    jne _nw_adv
    ; cmp     w4, #13
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Dh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_adv
    cmp BYTE PTR [r15+249], 0
    jne _nw_adv
    ; b       _nw_tok
    jmp _nw_tok
_nw_adv:
    ; add     x0, x0, #1
    mov rax, QWORD PTR [r15+0]
    add rax, 1
    mov QWORD PTR [r15+0], rax
    ; b       _nw_skip
    jmp _nw_skip
_nw_tok:
    ; mov     x1, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+8], rax
_nw_scan:
    ; cmp     x0, x3
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _nw_have
    cmp BYTE PTR [r15+250], 0
    jne _nw_have
    ; ldrb    w4, [x0]
    mov r10, QWORD PTR [r15+0]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; cmp     w4, #32
    mov eax, DWORD PTR [r15+32]
    cmp eax, 20h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_have
    cmp BYTE PTR [r15+249], 0
    jne _nw_have
    ; cmp     w4, #9
    mov eax, DWORD PTR [r15+32]
    cmp eax, 9
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_have
    cmp BYTE PTR [r15+249], 0
    jne _nw_have
    ; cmp     w4, #10
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_have
    cmp BYTE PTR [r15+249], 0
    jne _nw_have
    ; cmp     w4, #13
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Dh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_have
    cmp BYTE PTR [r15+249], 0
    jne _nw_have
    ; add     x0, x0, #1
    mov rax, QWORD PTR [r15+0]
    add rax, 1
    mov QWORD PTR [r15+0], rax
    ; b       _nw_scan
    jmp _nw_scan
_nw_have:
    ; mov     x4, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+32], rax
    ; cmp     x0, x3
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _nw_store
    cmp BYTE PTR [r15+250], 0
    jne _nw_store
    ; ldrb    w5, [x0]
    mov r10, QWORD PTR [r15+0]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; cmp     w5, #32
    mov eax, DWORD PTR [r15+40]
    cmp eax, 20h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_eat
    cmp BYTE PTR [r15+249], 0
    jne _nw_eat
    ; cmp     w5, #9
    mov eax, DWORD PTR [r15+40]
    cmp eax, 9
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_eat
    cmp BYTE PTR [r15+249], 0
    jne _nw_eat
    ; cmp     w5, #10
    mov eax, DWORD PTR [r15+40]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_eat
    cmp BYTE PTR [r15+249], 0
    jne _nw_eat
    ; cmp     w5, #13
    mov eax, DWORD PTR [r15+40]
    cmp eax, 0Dh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _nw_eat
    cmp BYTE PTR [r15+249], 0
    jne _nw_eat
    ; b       _nw_store
    jmp _nw_store
_nw_eat:
    ; add     x0, x0, #1
    mov rax, QWORD PTR [r15+0]
    add rax, 1
    mov QWORD PTR [r15+0], rax
_nw_store:
    ; bl      _cursor_commit
    lea rax, xret_16
    mov QWORD PTR [r15+240], rax
    jmp _cursor_commit
    xret_16:
    ; sub     x1, x4, x1
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+8]
    sub rax, rcx
    mov QWORD PTR [r15+8], rax
    ; sub     x0, x4, x1
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+8]
    sub rax, rcx
    mov QWORD PTR [r15+0], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_nw_none:
    ; bl      _cursor_commit
    lea rax, xret_17
    mov QWORD PTR [r15+240], rax
    jmp _cursor_commit
    xret_17:
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR [r15+8], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
BWSTR SEGMENT ALIGN(1) READ
nm_XCOMPILE_CELL:
    ; DCB "(COMPILE-CELL)", 0
    DB "(COMPILE-CELL)", 0
hl_XCOMPILE_CELL:
    ; DCB "(COMPILE-CELL) ( -- ) compile cell at HERE (bounds-checked)", 0
    DB "(COMPILE-CELL) ( -- ) compile cell at HERE (bounds-checked)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCOMPILE_CELL:
    ; DCQ     nm_XCOMPILE_CELL, hl_XCOMPILE_CELL
    DQ OFFSET nm_XCOMPILE_CELL, OFFSET hl_XCOMPILE_CELL
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     XCOMPILE_CELL, XCOMPILE_CELL_END
    DQ OFFSET XCOMPILE_CELL, OFFSET XCOMPILE_CELL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCOMPILE_CELL
    DQ OFFSET row_XCOMPILE_CELL
BOOTPTR ENDS
.CODE
XCOMPILE_CELL:
_compile_cell:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; str     x0, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x0, #8
    mov rax, 8
    mov QWORD PTR [r15+0], rax
    ; bl      _here_reserve_exact
    lea rax, xret_18
    mov QWORD PTR [r15+240], rax
    jmp _here_reserve_exact
    xret_18:
    ; ldr     x1, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    add rsp, 10h
    ; str     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
XCOMPILE_CELL_END:
_strlen:
    ; mov     x1, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+8], rax
_strlen_loop:
    ; ldrb    w2, [x0], #1
    mov r10, QWORD PTR [r15+0]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+16], rax
    mov rax, QWORD PTR [r15+0]
    add rax, 1
    mov QWORD PTR [r15+0], rax
    ; cbnz    w2, _strlen_loop
    mov eax, DWORD PTR [r15+16]
    cmp rax, 0
    jne _strlen_loop
    ; sub     x0, x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    sub rax, rcx
    mov QWORD PTR [r15+0], rax
    ; sub     x0, x0, #1
    mov rax, QWORD PTR [r15+0]
    sub rax, 1
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_take_pending_help:
    ; lea x0, pending_help_addr
    lea rax, pending_help_addr
    mov QWORD PTR [r15+0], rax
    ; ldr     x2, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; lea x1, pending_help_len
    lea rax, pending_help_len
    mov QWORD PTR [r15+8], rax
    ; ldr     x3, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; cbnz    x2, _tph_ok
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0
    jne _tph_ok
    ; lea x2, boot_h_empty
    lea rax, boot_h_empty
    mov QWORD PTR [r15+16], rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR [r15+24], rax
_tph_ok:
    ; ret
    jmp QWORD PTR [r15+240]
BWSTR SEGMENT ALIGN(1) READ
nm_XCOLON:
    ; DCB ":", 0
    DB ":", 0
hl_XCOLON:
    ; DCB "( 'name' -- ) start colon definition", 0
    DB "( 'name' -- ) start colon definition", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCOLON:
    ; DCQ     nm_XCOLON, hl_XCOLON
    DQ OFFSET nm_XCOLON, OFFSET hl_XCOLON
    ; DCQ     0
    DQ 0
    ; DCQ     XCOLON, 0
    DQ OFFSET XCOLON, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCOLON
    DQ OFFSET row_XCOLON
BOOTPTR ENDS
.CODE
XCOLON:
    ; bl      _core_console_only
    lea rax, xret_19
    mov QWORD PTR [r15+240], rax
    jmp _core_console_only
    xret_19:
    ; sub     sp, sp, #96
    mov rax, rsp
    sub rax, 60h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; bl      _local_compile_reset
    lea rax, xret_20
    mov QWORD PTR [r15+240], rax
    jmp _local_compile_reset
    xret_20:
    ; bl      _next_word
    lea rax, xret_21
    mov QWORD PTR [r15+240], rax
    jmp _next_word
    xret_21:
    ; cbz     x1, _colon_fail
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _colon_fail
    ; stp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10+8], rax
    ; bl      _take_pending_help
    lea rax, xret_22
    mov QWORD PTR [r15+240], rax
    jmp _take_pending_help
    xret_22:
    ; ldp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+0], rax
    mov QWORD PTR [r15+8], rcx
    ; lea x4, DOCOL
    lea rax, DOCOL
    mov QWORD PTR [r15+32], rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR [r15+40], rax
    ; bl      _header_build
    lea rax, xret_23
    mov QWORD PTR [r15+240], rax
    jmp _header_build
    xret_23:
    ; bl      _nfa_smudge_cfa
    lea rax, xret_24
    mov QWORD PTR [r15+240], rax
    jmp _nfa_smudge_cfa
    xret_24:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_25
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_25:
    ; lea x1, state_var
    lea rax, state_var
    mov QWORD PTR [r15+8], rax
    ; mov     x2, #1
    mov rax, 1
    mov QWORD PTR [r15+16], rax
    ; str     x2, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r10], rax
    ; lea x1, noname_xt
    lea rax, noname_xt
    mov QWORD PTR [r15+8], rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
_colon_fail:
    ; lea x0, msg_huh
    lea rax, msg_huh
    mov QWORD PTR [r15+0], rax
    ; bl      emit_cstr
    lea rax, xret_26
    mov QWORD PTR [r15+240], rax
    jmp emit_cstr
    xret_26:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSEMI:
    ; DCB 0x3B, 0
    DB 3Bh, 0
hl_XSEMI:
    ; DCB 0x3B, "( -- ) end colon definition (immediate)", 0
    DB 3Bh, "( -- ) end colon definition (immediate)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSEMI:
    ; DCQ     nm_XSEMI, hl_XSEMI
    DQ OFFSET nm_XSEMI, OFFSET hl_XSEMI
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XSEMI, 0
    DQ OFFSET XSEMI, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSEMI
    DQ OFFSET row_XSEMI
BOOTPTR ENDS
.CODE
XSEMI:
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; lea x0, exit_cfa
    lea rax, exit_cfa
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_27
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_27:
    ; lea x0, last_cfa
    lea rax, last_cfa
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; bl      _nfa_reveal_cfa
    lea rax, xret_28
    mov QWORD PTR [r15+240], rax
    jmp _nfa_reveal_cfa
    xret_28:
    ; lea x1, state_var
    lea rax, state_var
    mov QWORD PTR [r15+8], rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; bl      _local_compile_reset
    lea rax, xret_29
    mov QWORD PTR [r15+240], rax
    jmp _local_compile_reset
    xret_29:
    ; lea x0, noname_xt
    lea rax, noname_xt
    mov QWORD PTR [r15+0], rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, _semi_done
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _semi_done
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; mov     x20, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+160], rax
_semi_done:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XNONAME:
    ; DCB ":NONAME", 0
    DB ":NONAME", 0
hl_XNONAME:
    ; DCB ":NONAME ( -- xt ) anonymous colon definition. semicolon leaves the xt", 0
    DB ":NONAME ( -- xt ) anonymous colon definition. semicolon leaves the xt", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XNONAME:
    ; DCQ     nm_XNONAME, hl_XNONAME
    DQ OFFSET nm_XNONAME, OFFSET hl_XNONAME
    ; DCQ     0
    DQ 0
    ; DCQ     XNONAME, 0
    DQ OFFSET XNONAME, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XNONAME
    DQ OFFSET row_XNONAME
BOOTPTR ENDS
.CODE
XNONAME:
    ; bl      _core_console_only
    lea rax, xret_30
    mov QWORD PTR [r15+240], rax
    jmp _core_console_only
    xret_30:
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; bl      _local_compile_reset
    lea rax, xret_31
    mov QWORD PTR [r15+240], rax
    jmp _local_compile_reset
    xret_31:
    ; bl      _take_pending_help
    lea rax, xret_32
    mov QWORD PTR [r15+240], rax
    jmp _take_pending_help
    xret_32:
    ; lea x0, boot_h_empty
    lea rax, boot_h_empty
    mov QWORD PTR [r15+0], rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR [r15+8], rax
    ; lea x4, DOCOL
    lea rax, DOCOL
    mov QWORD PTR [r15+32], rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR [r15+40], rax
    ; bl      _header_build
    lea rax, xret_33
    mov QWORD PTR [r15+240], rax
    jmp _header_build
    xret_33:
    ; bl      _nfa_smudge_cfa
    lea rax, xret_34
    mov QWORD PTR [r15+240], rax
    jmp _nfa_smudge_cfa
    xret_34:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_35
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_35:
    ; lea x1, last_cfa
    lea rax, last_cfa
    mov QWORD PTR [r15+8], rax
    ; ldr     x2, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; lea x1, noname_xt
    lea rax, noname_xt
    mov QWORD PTR [r15+8], rax
    ; str     x2, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r10], rax
    ; lea x1, state_var
    lea rax, state_var
    mov QWORD PTR [r15+8], rax
    ; mov     x2, #1
    mov rax, 1
    mov QWORD PTR [r15+16], rax
    ; str     x2, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r10], rax
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
next_debug_gate:
    ; lea x16, next_debug
    lea rax, next_debug
    mov QWORD PTR [r15+128], rax
    ; br      x16
    mov rax, QWORD PTR [r15+128]
    jmp rax
.CONST
boot_h_empty:
    ; DCB    0
    DB 0
msg_huh:
    ; DCB     " ?", 10, 0
    DB " ?", 0Ah, 0
END
