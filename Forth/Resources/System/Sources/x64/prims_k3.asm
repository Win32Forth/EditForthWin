; Generated from Forth/kernel/arm64/prims_k3.asm. Do not edit.
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
EXTRN DODOES:PROC
EXTRN _compile_cell:PROC
EXTRN _cursor_commit:PROC
EXTRN _cursor_load:PROC
EXTRN _dict_hash:PROC
EXTRN _next_word:PROC
EXTRN _print_unsigned:PROC
EXTRN _putchar:PROC
EXTRN cfa_lit:BYTE
EXTRN cfa_local_init:BYTE
EXTRN cfa_loop:BYTE
EXTRN cfa_plusloop:BYTE
EXTRN cfa_slit:BYTE
EXTRN debug_break_asap:BYTE
EXTRN emit_cstr:PROC
EXTRN emit_str:PROC
EXTRN here_ptr:BYTE
EXTRN host_app_blit:PROC
EXTRN host_app_cblit:PROC
EXTRN host_app_close:PROC
EXTRN host_app_file_choose:PROC
EXTRN host_app_file_path:PROC
EXTRN host_app_file_save_as:PROC
EXTRN host_app_file_slurp:PROC
EXTRN host_app_file_spew:PROC
EXTRN host_app_img_choose:PROC
EXTRN host_app_img_load:PROC
EXTRN host_app_img_render:PROC
EXTRN host_app_img_size:PROC
EXTRN host_app_key:PROC
EXTRN host_app_keyq:PROC
EXTRN host_app_mouse:PROC
EXTRN host_app_name:PROC
EXTRN host_app_open:PROC
EXTRN host_app_pblit:PROC
EXTRN host_app_pump:PROC
EXTRN host_app_size:PROC
EXTRN host_app_tone:PROC
EXTRN host_oop_call:PROC
EXTRN latest_var:BYTE
EXTRN local_brace_phase:BYTE
EXTRN local_declaring:BYTE
EXTRN local_frame_depth:BYTE
EXTRN local_frame_n:BYTE
EXTRN local_frame_rsp:BYTE
EXTRN local_frames:BYTE
EXTRN local_init_count:BYTE
EXTRN local_init_reverse:BYTE
EXTRN local_name_count:BYTE
EXTRN local_names:BYTE
EXTRN next_debug:PROC
EXTRN search_order:BYTE
EXTRN search_order_n:BYTE
EXTRN slit_esc_buf:BYTE
EXTRN slit_esc_buf2:BYTE
EXTRN slit_esc_which:BYTE
EXTRN source_base:BYTE
EXTRN source_end:BYTE
EXTRN state_var:BYTE
EXTRN words_cfa:BYTE
EXTRN words_filter:BYTE
EXTRN words_filter_len:BYTE
EXTRN words_nk_tmp:BYTE
EXTRN words_user_base:BYTE
.CODE
PUBLIC _local_compile_reset
PUBLIC _local_add_name
PUBLIC _local_lookup
PUBLIC _local_finalize_compile
PUBLIC _local_frame_try_exit
PUBLIC XLOCAL_INIT
PUBLIC XLOCAL_AT
PUBLIC XLOCAL_STORE
PUBLIC XLOCAL_BRACE
PUBLIC XSEARCH_WORDLIST
PUBLIC XSOURCE
PUBLIC XLEAVE
PUBLIC XTWOSTAR
PUBLIC XTWOSLASH
PUBLIC XLFETCH
PUBLIC XLSTORE
PUBLIC _record_words_user_base_once
PUBLIC _words_name_ptr
PUBLIC _words_cfa_cmp
PUBLIC _words_filter_match
PUBLIC _print_wid_name
BWSTR SEGMENT ALIGN(1) READ
nm_XLOCAL_INIT:
    ; DCB "LOCAL-INIT", 0
    DB "LOCAL-INIT", 0
hl_XLOCAL_INIT:
    ; DCB "LOCAL-INIT ( n nInit rev -- ) create a locals frame", 0
    DB "LOCAL-INIT ( n nInit rev -- ) create a locals frame", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOCAL_INIT:
    ; DCQ     nm_XLOCAL_INIT, hl_XLOCAL_INIT
    DQ OFFSET nm_XLOCAL_INIT, OFFSET hl_XLOCAL_INIT
    ; DCQ     0
    DQ 0
    ; DCQ     XLOCAL_INIT, XLOCAL_INIT_END
    DQ OFFSET XLOCAL_INIT, OFFSET XLOCAL_INIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOCAL_INIT
    DQ OFFSET row_XLOCAL_INIT
BOOTPTR ENDS
.CODE
XLOCAL_INIT:
    ; mov     x2, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x2, rax
    ; ldr     x1, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
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
    ; cmp     x0, #LOCAL_MAX
    mov rax, QWORD PTR arm_x0
    cmp rax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _li_n_ok
    cmp BYTE PTR arm_c, 0
    je _li_n_ok
    cmp BYTE PTR arm_z, 0
    jne _li_n_ok
    ; mov     x0, #LOCAL_MAX
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
_li_n_ok:
    ; cmp     x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _li_i_ok
    cmp BYTE PTR arm_c, 0
    je _li_i_ok
    cmp BYTE PTR arm_z, 0
    jne _li_i_ok
    ; mov     x1, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x1, rax
_li_i_ok:
    ; lea x3, local_frame_depth
    lea rax, local_frame_depth
    mov QWORD PTR arm_x3, rax
    ; ldr     x4, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cmp     x4, #LOCAL_FRAME_MAX
    mov rax, QWORD PTR arm_x4
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _li_overflow
    cmp BYTE PTR arm_c, 0
    jne _li_overflow
    ; mov     x5, #LOCAL_MAX
    mov rax, 20h
    mov QWORD PTR arm_x5, rax
    ; mul     x5, x5, x4
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x4
    imul rax, rcx
    mov QWORD PTR arm_x5, rax
    ; lsl     x5, x5, #3
    mov rax, QWORD PTR arm_x5
    shl rax, 3
    mov QWORD PTR arm_x5, rax
    ; lea x6, local_frames
    lea rax, local_frames
    mov QWORD PTR arm_x6, rax
    ; add     x6, x6, x5
    mov rax, QWORD PTR arm_x6
    mov rcx, QWORD PTR arm_x5
    add rax, rcx
    mov QWORD PTR arm_x6, rax
    ; mov     x7, #0
    mov rax, 0
    mov QWORD PTR arm_x7, rax
_li_zero:
    ; cmp     x7, x0
    mov rax, QWORD PTR arm_x7
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _li_fill
    cmp BYTE PTR arm_c, 0
    jne _li_fill
    ; lsl     x8, x7, #3
    mov rax, QWORD PTR arm_x7
    shl rax, 3
    mov QWORD PTR arm_x8, rax
    ; str     xzr, [x6, x8]
    mov r10, QWORD PTR arm_x6
    mov rax, QWORD PTR arm_x8
    add r10, rax
    mov QWORD PTR [r10], 0
    ; add     x7, x7, #1
    mov rax, QWORD PTR arm_x7
    add rax, 1
    mov QWORD PTR arm_x7, rax
    ; b       _li_zero
    jmp _li_zero
_li_fill:
    ; cbz     x2, _li_forward
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je _li_forward
    ; mov     x7, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x7, rax
_li_rev:
    ; cbz     x7, _li_mark
    mov rax, QWORD PTR arm_x7
    cmp rax, 0
    je _li_mark
    ; sub     x7, x7, #1
    mov rax, QWORD PTR arm_x7
    sub rax, 1
    mov QWORD PTR arm_x7, rax
    ; lsl     x8, x7, #3
    mov rax, QWORD PTR arm_x7
    shl rax, 3
    mov QWORD PTR arm_x8, rax
    ; str     x20, [x6, x8]
    mov r10, QWORD PTR arm_x6
    mov rax, QWORD PTR arm_x8
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
    ; b       _li_rev
    jmp _li_rev
_li_forward:
    ; mov     x7, #0
    mov rax, 0
    mov QWORD PTR arm_x7, rax
_li_fwd:
    ; cmp     x7, x1
    mov rax, QWORD PTR arm_x7
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _li_mark
    cmp BYTE PTR arm_c, 0
    jne _li_mark
    ; lsl     x8, x7, #3
    mov rax, QWORD PTR arm_x7
    shl rax, 3
    mov QWORD PTR arm_x8, rax
    ; str     x20, [x6, x8]
    mov r10, QWORD PTR arm_x6
    mov rax, QWORD PTR arm_x8
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
    ; add     x7, x7, #1
    mov rax, QWORD PTR arm_x7
    add rax, 1
    mov QWORD PTR arm_x7, rax
    ; b       _li_fwd
    jmp _li_fwd
_li_mark:
    ; lea x5, local_frame_rsp
    lea rax, local_frame_rsp
    mov QWORD PTR arm_x5, rax
    ; lsl     x8, x4, #3
    mov rax, QWORD PTR arm_x4
    shl rax, 3
    mov QWORD PTR arm_x8, rax
    ; str     x23, [x5, x8]
    mov r10, QWORD PTR arm_x5
    mov rax, QWORD PTR arm_x8
    add r10, rax
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10], rax
    ; lea x5, local_frame_n
    lea rax, local_frame_n
    mov QWORD PTR arm_x5, rax
    ; str     x0, [x5, x8]
    mov r10, QWORD PTR arm_x5
    mov rax, QWORD PTR arm_x8
    add r10, rax
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; add     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; str     x4, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10], rax
    ; b       XLOCAL_INIT_END
    jmp XLOCAL_INIT_END
_li_overflow:
    ; mov     x7, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x7, rax
_li_drain:
    ; cbz     x7, XLOCAL_INIT_END
    mov rax, QWORD PTR arm_x7
    cmp rax, 0
    je XLOCAL_INIT_END
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; sub     x7, x7, #1
    mov rax, QWORD PTR arm_x7
    sub rax, 1
    mov QWORD PTR arm_x7, rax
    ; b       _li_drain
    jmp _li_drain
XLOCAL_INIT_END:
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
nm_XLOCAL_AT:
    ; DCB "(LOCAL@)", 0
    DB "(LOCAL@)", 0
hl_XLOCAL_AT:
    ; DCB "(LOCAL@) ( idx -- x ) fetch a local", 0
    DB "(LOCAL@) ( idx -- x ) fetch a local", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOCAL_AT:
    ; DCQ     nm_XLOCAL_AT, hl_XLOCAL_AT
    DQ OFFSET nm_XLOCAL_AT, OFFSET hl_XLOCAL_AT
    ; DCQ     0
    DQ 0
    ; DCQ     XLOCAL_AT, XLOCAL_AT_END
    DQ OFFSET XLOCAL_AT, OFFSET XLOCAL_AT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOCAL_AT
    DQ OFFSET row_XLOCAL_AT
BOOTPTR ENDS
.CODE
XLOCAL_AT:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; lea x1, local_frame_depth
    lea rax, local_frame_depth
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _lat_none
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _lat_none
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #LOCAL_MAX
    mov rax, 20h
    mov QWORD PTR arm_x2, rax
    ; mul     x2, x2, x1
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x1
    imul rax, rcx
    mov QWORD PTR arm_x2, rax
    ; lsl     x2, x2, #3
    mov rax, QWORD PTR arm_x2
    shl rax, 3
    mov QWORD PTR arm_x2, rax
    ; lea x3, local_frames
    lea rax, local_frames
    mov QWORD PTR arm_x3, rax
    ; add     x3, x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x3, rax
    ; lea x2, local_frame_n
    lea rax, local_frame_n
    mov QWORD PTR arm_x2, rax
    ; lsl     x4, x1, #3
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    mov QWORD PTR arm_x4, rax
    ; ldr     x2, [x2, x4]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x4
    add r10, rax
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
    ; b.hs    _lat_none
    cmp BYTE PTR arm_c, 0
    jne _lat_none
    ; lsl     x4, x0, #3
    mov rax, QWORD PTR arm_x0
    shl rax, 3
    mov QWORD PTR arm_x4, rax
    ; ldr     x20, [x3, x4]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; b       XLOCAL_AT_END
    jmp XLOCAL_AT_END
_lat_none:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XLOCAL_AT_END:
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
nm_XLOCAL_STORE:
    ; DCB "(LOCAL!)", 0
    DB "(LOCAL!)", 0
hl_XLOCAL_STORE:
    ; DCB "(LOCAL!) ( x idx -- ) store a local", 0
    DB "(LOCAL!) ( x idx -- ) store a local", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOCAL_STORE:
    ; DCQ     nm_XLOCAL_STORE, hl_XLOCAL_STORE
    DQ OFFSET nm_XLOCAL_STORE, OFFSET hl_XLOCAL_STORE
    ; DCQ     0
    DQ 0
    ; DCQ     XLOCAL_STORE, XLOCAL_STORE_END
    DQ OFFSET XLOCAL_STORE, OFFSET XLOCAL_STORE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOCAL_STORE
    DQ OFFSET row_XLOCAL_STORE
BOOTPTR ENDS
.CODE
XLOCAL_STORE:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
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
    ; lea x2, local_frame_depth
    lea rax, local_frame_depth
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, XLOCAL_STORE_END
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je XLOCAL_STORE_END
    ; sub     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    sub rax, 1
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #LOCAL_MAX
    mov rax, 20h
    mov QWORD PTR arm_x3, rax
    ; mul     x3, x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    imul rax, rcx
    mov QWORD PTR arm_x3, rax
    ; lsl     x3, x3, #3
    mov rax, QWORD PTR arm_x3
    shl rax, 3
    mov QWORD PTR arm_x3, rax
    ; lea x4, local_frames
    lea rax, local_frames
    mov QWORD PTR arm_x4, rax
    ; add     x4, x4, x3
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x3
    add rax, rcx
    mov QWORD PTR arm_x4, rax
    ; lea x3, local_frame_n
    lea rax, local_frame_n
    mov QWORD PTR arm_x3, rax
    ; lsl     x5, x2, #3
    mov rax, QWORD PTR arm_x2
    shl rax, 3
    mov QWORD PTR arm_x5, rax
    ; ldr     x3, [x3, x5]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x5
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cmp     x0, x3
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    XLOCAL_STORE_END
    cmp BYTE PTR arm_c, 0
    jne XLOCAL_STORE_END
    ; lsl     x5, x0, #3
    mov rax, QWORD PTR arm_x0
    shl rax, 3
    mov QWORD PTR arm_x5, rax
    ; str     x1, [x4, x5]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x5
    add r10, rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
XLOCAL_STORE_END:
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
nm_XLOCAL_BRACE:
    ; DCB "{:", 0
    DB "{:", 0
hl_XLOCAL_BRACE:
    ; DCB "declare locals until :}", 0
    DB "declare locals until :}", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOCAL_BRACE:
    ; DCQ     nm_XLOCAL_BRACE, hl_XLOCAL_BRACE
    DQ OFFSET nm_XLOCAL_BRACE, OFFSET hl_XLOCAL_BRACE
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XLOCAL_BRACE, 0
    DQ OFFSET XLOCAL_BRACE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOCAL_BRACE
    DQ OFFSET row_XLOCAL_BRACE
BOOTPTR ENDS
.CODE
XLOCAL_BRACE:
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
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _lb_leave
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _lb_leave
    ; bl      _local_compile_reset
    lea rax, xret_1
    mov QWORD PTR arm_x30, rax
    jmp _local_compile_reset
    xret_1:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; lea x1, local_init_reverse
    lea rax, local_init_reverse
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x1, local_brace_phase
    lea rax, local_brace_phase
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
_lb_loop:
    ; bl      _next_word
    lea rax, xret_2
    mov QWORD PTR arm_x30, rax
    jmp _next_word
    xret_2:
    ; cbz     x1, _lb_done
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _lb_done
    ; cmp     x1, #2
    mov rax, QWORD PTR arm_x1
    cmp rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _lb_bar
    cmp BYTE PTR arm_z, 0
    je _lb_bar
    ; ldrb    w2, [x0]
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cmp     w2, #':'
    mov eax, DWORD PTR arm_x2
    cmp eax, 3Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _lb_bar
    cmp BYTE PTR arm_z, 0
    je _lb_bar
    ; ldrb    w2, [x0, #1]
    mov r10, QWORD PTR arm_x0
    add r10, 1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cmp     w2, #'}'
    mov eax, DWORD PTR arm_x2
    cmp eax, 7Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _lb_done
    cmp BYTE PTR arm_z, 0
    jne _lb_done
_lb_bar:
    ; cmp     x1, #1
    mov rax, QWORD PTR arm_x1
    cmp rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _lb_dash
    cmp BYTE PTR arm_z, 0
    je _lb_dash
    ; ldrb    w2, [x0]
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cmp     w2, #'|'
    mov eax, DWORD PTR arm_x2
    cmp eax, 7Ch
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _lb_dash
    cmp BYTE PTR arm_z, 0
    je _lb_dash
    ; mov     x2, #1
    mov rax, 1
    mov QWORD PTR arm_x2, rax
    ; lea x3, local_brace_phase
    lea rax, local_brace_phase
    mov QWORD PTR arm_x3, rax
    ; str     x2, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; b       _lb_loop
    jmp _lb_loop
_lb_dash:
    ; cmp     x1, #2
    mov rax, QWORD PTR arm_x1
    cmp rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _lb_name
    cmp BYTE PTR arm_z, 0
    je _lb_name
    ; ldrb    w2, [x0]
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cmp     w2, #'-'
    mov eax, DWORD PTR arm_x2
    cmp eax, 2Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _lb_name
    cmp BYTE PTR arm_z, 0
    je _lb_name
    ; ldrb    w2, [x0, #1]
    mov r10, QWORD PTR arm_x0
    add r10, 1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cmp     w2, #'-'
    mov eax, DWORD PTR arm_x2
    cmp eax, 2Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _lb_name
    cmp BYTE PTR arm_z, 0
    je _lb_name
    ; mov     x2, #2
    mov rax, 2
    mov QWORD PTR arm_x2, rax
    ; lea x3, local_brace_phase
    lea rax, local_brace_phase
    mov QWORD PTR arm_x3, rax
    ; str     x2, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; b       _lb_loop
    jmp _lb_loop
_lb_name:
    ; lea x3, local_brace_phase
    lea rax, local_brace_phase
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cmp     x3, #2
    mov rax, QWORD PTR arm_x3
    cmp rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _lb_loop
    cmp BYTE PTR arm_z, 0
    jne _lb_loop
    ; bl      _local_add_name
    lea rax, xret_3
    mov QWORD PTR arm_x30, rax
    jmp _local_add_name
    xret_3:
    ; lea x3, local_brace_phase
    lea rax, local_brace_phase
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbnz    x3, _lb_loop
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    jne _lb_loop
    ; lea x2, local_init_count
    lea rax, local_init_count
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; b       _lb_loop
    jmp _lb_loop
_lb_done:
    ; bl      _local_finalize_compile
    lea rax, xret_4
    mov QWORD PTR arm_x30, rax
    jmp _local_finalize_compile
    xret_4:
_lb_leave:
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
nm_XLOCAL_COMPILE_RESET:
    ; DCB "(LOCAL-COMPILE-RESET)", 0
    DB "(LOCAL-COMPILE-RESET)", 0
hl_XLOCAL_COMPILE_RESET:
    ; DCB "(LOCAL-COMPILE-RESET) ( -- ) clear locals compile state", 0
    DB "(LOCAL-COMPILE-RESET) ( -- ) clear locals compile state", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOCAL_COMPILE_RESET:
    ; DCQ     nm_XLOCAL_COMPILE_RESET, hl_XLOCAL_COMPILE_RESET
    DQ OFFSET nm_XLOCAL_COMPILE_RESET, OFFSET hl_XLOCAL_COMPILE_RESET
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     XLOCAL_COMPILE_RESET, XLOCAL_COMPILE_RESET_END
    DQ OFFSET XLOCAL_COMPILE_RESET, OFFSET XLOCAL_COMPILE_RESET_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOCAL_COMPILE_RESET
    DQ OFFSET row_XLOCAL_COMPILE_RESET
BOOTPTR ENDS
.CODE
XLOCAL_COMPILE_RESET:
_local_compile_reset:
    ; lea x0, local_name_count
    lea rax, local_name_count
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, local_init_count
    lea rax, local_init_count
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, local_init_reverse
    lea rax, local_init_reverse
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, local_declaring
    lea rax, local_declaring
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; ret
    jmp QWORD PTR arm_x30
XLOCAL_COMPILE_RESET_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XLOCAL_ADD_NAME:
    ; DCB "(LOCAL-ADD-NAME)", 0
    DB "(LOCAL-ADD-NAME)", 0
hl_XLOCAL_ADD_NAME:
    ; DCB "(LOCAL-ADD-NAME) ( -- ) add one local name", 0
    DB "(LOCAL-ADD-NAME) ( -- ) add one local name", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOCAL_ADD_NAME:
    ; DCQ     nm_XLOCAL_ADD_NAME, hl_XLOCAL_ADD_NAME
    DQ OFFSET nm_XLOCAL_ADD_NAME, OFFSET hl_XLOCAL_ADD_NAME
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     XLOCAL_ADD_NAME, XLOCAL_ADD_NAME_END
    DQ OFFSET XLOCAL_ADD_NAME, OFFSET XLOCAL_ADD_NAME_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOCAL_ADD_NAME
    DQ OFFSET row_XLOCAL_ADD_NAME
BOOTPTR ENDS
.CODE
XLOCAL_ADD_NAME:
_local_add_name:
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
    ; lea x0, local_name_count
    lea rax, local_name_count
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, #LOCAL_MAX
    mov rax, QWORD PTR arm_x1
    cmp rax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _lan_done
    cmp BYTE PTR arm_c, 0
    jne _lan_done
    ; mov     x2, #LOCAL_NAME_STR
    mov rax, 20h
    mov QWORD PTR arm_x2, rax
    ; mul     x2, x2, x1
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x1
    imul rax, rcx
    mov QWORD PTR arm_x2, rax
    ; lea x3, local_names
    lea rax, local_names
    mov QWORD PTR arm_x3, rax
    ; add     x3, x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x3, rax
    ; cmp     x20, #31
    mov rax, QWORD PTR arm_x20
    cmp rax, 1Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _lan_len
    cmp BYTE PTR arm_c, 0
    je _lan_len
    cmp BYTE PTR arm_z, 0
    jne _lan_len
    ; mov     x20, #31
    mov rax, 1Fh
    mov QWORD PTR arm_x20, rax
_lan_len:
    ; strb    w20, [x3], #1
    mov r10, QWORD PTR arm_x3
    mov eax, DWORD PTR arm_x20
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
_lan_cp:
    ; cmp     x2, x20
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _lan_count
    cmp BYTE PTR arm_c, 0
    jne _lan_count
    ; ldrb    w4, [x19, x2]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR arm_x2
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cmp     w4, #'a'
    mov eax, DWORD PTR arm_x4
    cmp eax, 61h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _lan_st
    cmp BYTE PTR arm_c, 0
    je _lan_st
    ; cmp     w4, #'z'
    mov eax, DWORD PTR arm_x4
    cmp eax, 7Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _lan_st
    cmp BYTE PTR arm_c, 0
    je xsk_5
    cmp BYTE PTR arm_z, 0
    je _lan_st
    xsk_5:
    ; sub     w4, w4, #32
    mov eax, DWORD PTR arm_x4
    sub eax, 20h
    mov QWORD PTR arm_x4, rax
_lan_st:
    ; strb    w4, [x3, x2]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x2
    add r10, rax
    mov eax, DWORD PTR arm_x4
    mov BYTE PTR [r10], al
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
    ; b       _lan_cp
    jmp _lan_cp
_lan_count:
    ; lea x0, local_name_count
    lea rax, local_name_count
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
_lan_done:
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
XLOCAL_ADD_NAME_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XLOCAL_LOOKUP:
    ; DCB "(LOCAL-LOOKUP)", 0
    DB "(LOCAL-LOOKUP)", 0
hl_XLOCAL_LOOKUP:
    ; DCB "(LOCAL-LOOKUP) ( -- ) local name index or -1", 0
    DB "(LOCAL-LOOKUP) ( -- ) local name index or -1", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOCAL_LOOKUP:
    ; DCQ     nm_XLOCAL_LOOKUP, hl_XLOCAL_LOOKUP
    DQ OFFSET nm_XLOCAL_LOOKUP, OFFSET hl_XLOCAL_LOOKUP
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     XLOCAL_LOOKUP, XLOCAL_LOOKUP_END
    DQ OFFSET XLOCAL_LOOKUP, OFFSET XLOCAL_LOOKUP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOCAL_LOOKUP
    DQ OFFSET row_XLOCAL_LOOKUP
BOOTPTR ENDS
.CODE
XLOCAL_LOOKUP:
_local_lookup:
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
    ; lea x0, local_name_count
    lea rax, local_name_count
    mov QWORD PTR arm_x0, rax
    ; ldr     x21, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    ; mov     x22, #0
    mov rax, 0
    mov QWORD PTR arm_x22, rax
_ll_loop:
    ; cmp     x22, x21
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x21
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _ll_miss
    cmp BYTE PTR arm_c, 0
    jne _ll_miss
    ; mov     x2, #LOCAL_NAME_STR
    mov rax, 20h
    mov QWORD PTR arm_x2, rax
    ; mul     x2, x2, x22
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x22
    imul rax, rcx
    mov QWORD PTR arm_x2, rax
    ; lea x3, local_names
    lea rax, local_names
    mov QWORD PTR arm_x3, rax
    ; add     x3, x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x3, rax
    ; ldrb    w2, [x3], #1
    mov r10, QWORD PTR arm_x3
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; cmp     x2, x20
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _ll_next
    cmp BYTE PTR arm_z, 0
    je _ll_next
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
_ll_cmp:
    ; cmp     x4, x20
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _ll_hit
    cmp BYTE PTR arm_c, 0
    jne _ll_hit
    ; ldrb    w5, [x3, x4]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; ldrb    w6, [x19, x4]
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR arm_x4
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; cmp     w6, #'a'
    mov eax, DWORD PTR arm_x6
    cmp eax, 61h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _ll_fold
    cmp BYTE PTR arm_c, 0
    je _ll_fold
    ; cmp     w6, #'z'
    mov eax, DWORD PTR arm_x6
    cmp eax, 7Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _ll_fold
    cmp BYTE PTR arm_c, 0
    je xsk_6
    cmp BYTE PTR arm_z, 0
    je _ll_fold
    xsk_6:
    ; sub     w6, w6, #32
    mov eax, DWORD PTR arm_x6
    sub eax, 20h
    mov QWORD PTR arm_x6, rax
_ll_fold:
    ; cmp     w5, w6
    mov eax, DWORD PTR arm_x5
    mov ecx, DWORD PTR arm_x6
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _ll_next
    cmp BYTE PTR arm_z, 0
    je _ll_next
    ; add     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; b       _ll_cmp
    jmp _ll_cmp
_ll_next:
    ; add     x22, x22, #1
    mov rax, QWORD PTR arm_x22
    add rax, 1
    mov QWORD PTR arm_x22, rax
    ; b       _ll_loop
    jmp _ll_loop
_ll_miss:
    ; mov     x0, #-1
    mov rax, -1
    mov QWORD PTR arm_x0, rax
    ; b       _ll_out
    jmp _ll_out
_ll_hit:
    ; mov     x0, x22
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR arm_x0, rax
_ll_out:
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
    ; ret
    jmp QWORD PTR arm_x30
XLOCAL_LOOKUP_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XLOCAL_FINALIZE:
    ; DCB "(LOCAL-FINALIZE)", 0
    DB "(LOCAL-FINALIZE)", 0
hl_XLOCAL_FINALIZE:
    ; DCB "(LOCAL-FINALIZE) ( -- ) compile LOCAL-INIT", 0
    DB "(LOCAL-FINALIZE) ( -- ) compile LOCAL-INIT", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOCAL_FINALIZE:
    ; DCQ     nm_XLOCAL_FINALIZE, hl_XLOCAL_FINALIZE
    DQ OFFSET nm_XLOCAL_FINALIZE, OFFSET hl_XLOCAL_FINALIZE
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     XLOCAL_FINALIZE, XLOCAL_FINALIZE_END
    DQ OFFSET XLOCAL_FINALIZE, OFFSET XLOCAL_FINALIZE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOCAL_FINALIZE
    DQ OFFSET row_XLOCAL_FINALIZE
BOOTPTR ENDS
.CODE
XLOCAL_FINALIZE:
_local_finalize_compile:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_7
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_7:
    ; lea x0, local_name_count
    lea rax, local_name_count
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_8
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_8:
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_9
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_9:
    ; lea x0, local_init_count
    lea rax, local_init_count
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_10
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_10:
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_11
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_11:
    ; lea x0, local_init_reverse
    lea rax, local_init_reverse
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_12
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_12:
    ; lea x0, cfa_local_init
    lea rax, cfa_local_init
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_13
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_13:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
XLOCAL_FINALIZE_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XLOCAL_FRAME_TRY_EXIT:
    ; DCB "(LOCAL-FRAME-EXIT)", 0
    DB "(LOCAL-FRAME-EXIT)", 0
hl_XLOCAL_FRAME_TRY_EXIT:
    ; DCB "(LOCAL-FRAME-EXIT) ( -- ) pop locals frame when RSP matches", 0
    DB "(LOCAL-FRAME-EXIT) ( -- ) pop locals frame when RSP matches", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOCAL_FRAME_TRY_EXIT:
    ; DCQ     nm_XLOCAL_FRAME_TRY_EXIT, hl_XLOCAL_FRAME_TRY_EXIT
    DQ OFFSET nm_XLOCAL_FRAME_TRY_EXIT, OFFSET hl_XLOCAL_FRAME_TRY_EXIT
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     XLOCAL_FRAME_TRY_EXIT, XLOCAL_FRAME_TRY_EXIT_END
    DQ OFFSET XLOCAL_FRAME_TRY_EXIT, OFFSET XLOCAL_FRAME_TRY_EXIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOCAL_FRAME_TRY_EXIT
    DQ OFFSET row_XLOCAL_FRAME_TRY_EXIT
BOOTPTR ENDS
.CODE
XLOCAL_FRAME_TRY_EXIT:
_local_frame_try_exit:
    ; lea x0, local_frame_depth
    lea rax, local_frame_depth
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _lfe_done
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _lfe_done
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x2, local_frame_rsp
    lea rax, local_frame_rsp
    mov QWORD PTR arm_x2, rax
    ; lsl     x3, x1, #3
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    mov QWORD PTR arm_x3, rax
    ; ldr     x2, [x2, x3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cmp     x2, x23
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x23
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _lfe_done
    cmp BYTE PTR arm_z, 0
    je _lfe_done
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
_lfe_done:
    ; ret
    jmp QWORD PTR arm_x30
XLOCAL_FRAME_TRY_EXIT_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XSEARCH_WORDLIST:
    ; DCB "SEARCH-WORDLIST", 0
    DB "SEARCH-WORDLIST", 0
hl_XSEARCH_WORDLIST:
    ; DCB "SEARCH-WORDLIST ( c-addr u wid -- 0 | xt 1 | xt -1 ) find in one wordlist", 0
    DB "SEARCH-WORDLIST ( c-addr u wid -- 0 | xt 1 | xt -1 ) find in one wordlist", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSEARCH_WORDLIST:
    ; DCQ     nm_XSEARCH_WORDLIST, hl_XSEARCH_WORDLIST
    DQ OFFSET nm_XSEARCH_WORDLIST, OFFSET hl_XSEARCH_WORDLIST
    ; DCQ     0
    DQ 0
    ; DCQ     XSEARCH_WORDLIST, 0
    DQ OFFSET XSEARCH_WORDLIST, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSEARCH_WORDLIST
    DQ OFFSET row_XSEARCH_WORDLIST
BOOTPTR ENDS
.CODE
XSEARCH_WORDLIST:
    ; mov     x9, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x9, rax
    ; ldr     x8, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x8, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x7, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x7, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cbz     x9, _swl_zero
    mov rax, QWORD PTR arm_x9
    cmp rax, 0
    je _swl_zero
    ; cbz     x8, _swl_zero
    mov rax, QWORD PTR arm_x8
    cmp rax, 0
    je _swl_zero
    ; stp     x7, x8, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x8
    mov QWORD PTR [r10+8], rax
    ; str     x9, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR [r10], rax
    ; mov     x0, x7
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x8
    mov rax, QWORD PTR arm_x8
    mov QWORD PTR arm_x1, rax
    ; mov     x12, x30
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR arm_x12, rax
    ; bl      _dict_hash
    lea rax, xret_14
    mov QWORD PTR arm_x30, rax
    jmp _dict_hash
    xret_14:
    ; mov     x30, x12
    mov rax, QWORD PTR arm_x12
    mov QWORD PTR arm_x30, rax
    ; mov     x10, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x10, rax
    ; ldr     x9, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
    add rsp, 10h
    ; ldp     x7, x8, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x7, rax
    mov QWORD PTR arm_x8, rcx
    add rsp, 10h
    ; add     x9, x9, x10, lsl #3
    mov rax, QWORD PTR arm_x9
    mov rcx, QWORD PTR arm_x10
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR arm_x9, rax
    ; ldr     x11, [x9]
    mov r10, QWORD PTR arm_x9
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x11, rax
_swl_loop:
    ; cbz     x11, _swl_zero
    mov rax, QWORD PTR arm_x11
    cmp rax, 0
    je _swl_zero
    ; ldr     x2, [x11, #-8]
    mov r10, QWORD PTR arm_x11
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; and     x3, x2, #0xFFFF
    mov rax, QWORD PTR arm_x2
    and rax, 0FFFFh
    mov QWORD PTR arm_x3, rax
    ; sub     x4, x11, x3
    mov rax, QWORD PTR arm_x11
    mov rcx, QWORD PTR arm_x3
    sub rax, rcx
    mov QWORD PTR arm_x4, rax
    ; ldrb    w3, [x4], #1
    mov r10, QWORD PTR arm_x4
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; tbnz    w3, #7, _swl_next
    mov eax, DWORD PTR arm_x3
    bt rax, 7
    jc _swl_next
    ; and     w3, w3, #0x7F
    mov eax, DWORD PTR arm_x3
    and eax, 7Fh
    mov QWORD PTR arm_x3, rax
    ; cmp     x3, x8
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x8
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _swl_next
    cmp BYTE PTR arm_z, 0
    je _swl_next
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
_swl_cmp:
    ; cmp     x5, x8
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x8
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _swl_hit
    cmp BYTE PTR arm_c, 0
    jne _swl_hit
    ; ldrb    w6, [x4, x5]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x5
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; ldrb    w10, [x7, x5]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR arm_x5
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x10, rax
    ; cmp     w10, #'a'
    mov eax, DWORD PTR arm_x10
    cmp eax, 61h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _swl_fold
    cmp BYTE PTR arm_c, 0
    je _swl_fold
    ; cmp     w10, #'z'
    mov eax, DWORD PTR arm_x10
    cmp eax, 7Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _swl_fold
    cmp BYTE PTR arm_c, 0
    je xsk_15
    cmp BYTE PTR arm_z, 0
    je _swl_fold
    xsk_15:
    ; sub     w10, w10, #32
    mov eax, DWORD PTR arm_x10
    sub eax, 20h
    mov QWORD PTR arm_x10, rax
_swl_fold:
    ; cmp     w6, w10
    mov eax, DWORD PTR arm_x6
    mov ecx, DWORD PTR arm_x10
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _swl_next
    cmp BYTE PTR arm_z, 0
    je _swl_next
    ; add     x5, x5, #1
    mov rax, QWORD PTR arm_x5
    add rax, 1
    mov QWORD PTR arm_x5, rax
    ; b       _swl_cmp
    jmp _swl_cmp
_swl_hit:
    ; ldr     x1, [x11, #-8]
    mov r10, QWORD PTR arm_x11
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; tbnz    x1, #63, _swl_imm
    mov rax, QWORD PTR arm_x1
    bt rax, 63
    jc _swl_imm
    ; mov     x4, #-1
    mov rax, -1
    mov QWORD PTR arm_x4, rax
    ; b       _swl_push
    jmp _swl_push
_swl_imm:
    ; mov     x4, #1
    mov rax, 1
    mov QWORD PTR arm_x4, rax
_swl_push:
    ; str     x11, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x11
    mov QWORD PTR [r10], rax
    ; mov     x20, x4
    mov rax, QWORD PTR arm_x4
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
_swl_next:
    ; ldr     x11, [x11, #-16]
    mov r10, QWORD PTR arm_x11
    add r10, -16
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x11, rax
    ; b       _swl_loop
    jmp _swl_loop
_swl_zero:
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
nm_XSOURCE:
    ; DCB "SOURCE", 0
    DB "SOURCE", 0
hl_XSOURCE:
    ; DCB "SOURCE ( -- c-addr u ) current input buffer and length", 0
    DB "SOURCE ( -- c-addr u ) current input buffer and length", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSOURCE:
    ; DCQ     nm_XSOURCE, hl_XSOURCE
    DQ OFFSET nm_XSOURCE, OFFSET hl_XSOURCE
    ; DCQ     0
    DQ 0
    ; DCQ     XSOURCE, 0
    DQ OFFSET XSOURCE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSOURCE
    DQ OFFSET row_XSOURCE
BOOTPTR ENDS
.CODE
XSOURCE:
    ; lea x0, source_base
    lea rax, source_base
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; lea x1, source_end
    lea rax, source_end
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; sub     x1, x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    sub rax, rcx
    mov QWORD PTR arm_x1, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; str     x0, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
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
nm_XLEAVE:
    ; DCB "LEAVE", 0
    DB "LEAVE", 0
hl_XLEAVE:
    ; DCB "LEAVE ( -- ) exit the current DO loop", 0
    DB "LEAVE ( -- ) exit the current DO loop", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLEAVE:
    ; DCQ     nm_XLEAVE, hl_XLEAVE
    DQ OFFSET nm_XLEAVE, OFFSET hl_XLEAVE
    ; DCQ     0
    DQ 0
    ; DCQ     XLEAVE, XLEAVE_END
    DQ OFFSET XLEAVE, OFFSET XLEAVE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLEAVE
    DQ OFFSET row_XLEAVE
BOOTPTR ENDS
.CODE
XLEAVE:
    ; add     x23, x23, #16
    mov rax, QWORD PTR arm_x23
    add rax, 10h
    mov QWORD PTR arm_x23, rax
    ; lea x1, cfa_loop
    lea rax, cfa_loop
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_plusloop
    lea rax, cfa_plusloop
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
_leave_scan:
    ; ldr     x0, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _leave_skip
    cmp BYTE PTR arm_z, 0
    jne _leave_skip
    ; cmp     x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _leave_scan
    cmp BYTE PTR arm_z, 0
    je _leave_scan
_leave_skip:
    ; add     x19, x19, #8
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
XLEAVE_END:
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
nm_XTWOSTAR:
    ; DCB "2*", 0
    DB "2*", 0
hl_XTWOSTAR:
    ; DCB "2* ( x1 -- x2 ) shift left one bit", 0
    DB "2* ( x1 -- x2 ) shift left one bit", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTWOSTAR:
    ; DCQ     nm_XTWOSTAR, hl_XTWOSTAR
    DQ OFFSET nm_XTWOSTAR, OFFSET hl_XTWOSTAR
    ; DCQ     0
    DQ 0
    ; DCQ     XTWOSTAR, XTWOSTAR_END
    DQ OFFSET XTWOSTAR, OFFSET XTWOSTAR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTWOSTAR
    DQ OFFSET row_XTWOSTAR
BOOTPTR ENDS
.CODE
XTWOSTAR:
    ; lsl     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    shl rax, 1
    mov QWORD PTR arm_x20, rax
XTWOSTAR_END:
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
nm_XTWOSLASH:
    ; DCB "2/", 0
    DB "2/", 0
hl_XTWOSLASH:
    ; DCB "2/ ( x1 -- x2 ) arithmetic shift right one bit", 0
    DB "2/ ( x1 -- x2 ) arithmetic shift right one bit", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTWOSLASH:
    ; DCQ     nm_XTWOSLASH, hl_XTWOSLASH
    DQ OFFSET nm_XTWOSLASH, OFFSET hl_XTWOSLASH
    ; DCQ     0
    DQ 0
    ; DCQ     XTWOSLASH, XTWOSLASH_END
    DQ OFFSET XTWOSLASH, OFFSET XTWOSLASH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTWOSLASH
    DQ OFFSET row_XTWOSLASH
BOOTPTR ENDS
.CODE
XTWOSLASH:
    ; asr     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    sar rax, 1
    mov QWORD PTR arm_x20, rax
XTWOSLASH_END:
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
nm_XLFETCH:
    ; DCB "L@", 0
    DB "L@", 0
hl_XLFETCH:
    ; DCB "L@ ( addr -- u ) fetch 32 bits zero-extended", 0
    DB "L@ ( addr -- u ) fetch 32 bits zero-extended", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLFETCH:
    ; DCQ     nm_XLFETCH, hl_XLFETCH
    DQ OFFSET nm_XLFETCH, OFFSET hl_XLFETCH
    ; DCQ     0
    DQ 0
    ; DCQ     XLFETCH, XLFETCH_END
    DQ OFFSET XLFETCH, OFFSET XLFETCH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLFETCH
    DQ OFFSET row_XLFETCH
BOOTPTR ENDS
.CODE
XLFETCH:
    ; ldr     w20, [x20]
    mov r10, QWORD PTR arm_x20
    mov eax, DWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
XLFETCH_END:
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
nm_XLSTORE:
    ; DCB "L!", 0
    DB "L!", 0
hl_XLSTORE:
    ; DCB "L! ( u addr -- ) store 32 bits", 0
    DB "L! ( u addr -- ) store 32 bits", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLSTORE:
    ; DCQ     nm_XLSTORE, hl_XLSTORE
    DQ OFFSET nm_XLSTORE, OFFSET hl_XLSTORE
    ; DCQ     0
    DQ 0
    ; DCQ     XLSTORE, XLSTORE_END
    DQ OFFSET XLSTORE, OFFSET XLSTORE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLSTORE
    DQ OFFSET row_XLSTORE
BOOTPTR ENDS
.CODE
XLSTORE:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; str     w0, [x20]
    mov r10, QWORD PTR arm_x20
    mov eax, DWORD PTR arm_x0
    mov DWORD PTR [r10], eax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
XLSTORE_END:
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
nm_XAPP_OPEN:
    ; DCB "(APP-OPEN)", 0
    DB "(APP-OPEN)", 0
hl_XAPP_OPEN:
    ; DCB "(APP-OPEN) ( cols rows -- ior ) open a character graphics window", 0
    DB "(APP-OPEN) ( cols rows -- ior ) open a character graphics window", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_OPEN:
    ; DCQ     nm_XAPP_OPEN, hl_XAPP_OPEN
    DQ OFFSET nm_XAPP_OPEN, OFFSET hl_XAPP_OPEN
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_OPEN, XAPP_OPEN_END
    DQ OFFSET XAPP_OPEN, OFFSET XAPP_OPEN_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_OPEN
    DQ OFFSET row_XAPP_OPEN
BOOTPTR ENDS
.CODE
XAPP_OPEN:
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
    ; bl      host_app_open
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
    call host_app_open
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
XAPP_OPEN_END:
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
nm_XOOP_CALL:
    ; DCB "(OOP-CALL)", 0
    DB "(OOP-CALL)", 0
hl_XOOP_CALL:
    ; DCB "(OOP-CALL) ( a b c d op -- n ) OOP window host", 0
    DB "(OOP-CALL) ( a b c d op -- n ) OOP window host", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XOOP_CALL:
    ; DCQ     nm_XOOP_CALL, hl_XOOP_CALL
    DQ OFFSET nm_XOOP_CALL, OFFSET hl_XOOP_CALL
    ; DCQ     0
    DQ 0
    ; DCQ     XOOP_CALL, XOOP_CALL_END
    DQ OFFSET XOOP_CALL, OFFSET XOOP_CALL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XOOP_CALL
    DQ OFFSET row_XOOP_CALL
BOOTPTR ENDS
.CODE
XOOP_CALL:
    ; mov     x4, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x4, rax
    ; ldr     x3, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
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
    ; bl      host_oop_call
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
    call host_oop_call
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
XOOP_CALL_END:
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
nm_XAPP_CLOSE:
    ; DCB "(APP-CLOSE)", 0
    DB "(APP-CLOSE)", 0
hl_XAPP_CLOSE:
    ; DCB "(APP-CLOSE) ( -- ) close the character graphics window", 0
    DB "(APP-CLOSE) ( -- ) close the character graphics window", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_CLOSE:
    ; DCQ     nm_XAPP_CLOSE, hl_XAPP_CLOSE
    DQ OFFSET nm_XAPP_CLOSE, OFFSET hl_XAPP_CLOSE
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_CLOSE, XAPP_CLOSE_END
    DQ OFFSET XAPP_CLOSE, OFFSET XAPP_CLOSE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_CLOSE
    DQ OFFSET row_XAPP_CLOSE
BOOTPTR ENDS
.CODE
XAPP_CLOSE:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_app_close
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
    call host_app_close
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
XAPP_CLOSE_END:
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
nm_XAPP_BLIT:
    ; DCB "(APP-BLIT)", 0
    DB "(APP-BLIT)", 0
hl_XAPP_BLIT:
    ; DCB "(APP-BLIT) ( c-addr u -- ) blit the character buffer to the window", 0
    DB "(APP-BLIT) ( c-addr u -- ) blit the character buffer to the window", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_BLIT:
    ; DCQ     nm_XAPP_BLIT, hl_XAPP_BLIT
    DQ OFFSET nm_XAPP_BLIT, OFFSET hl_XAPP_BLIT
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_BLIT, XAPP_BLIT_END
    DQ OFFSET XAPP_BLIT, OFFSET XAPP_BLIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_BLIT
    DQ OFFSET row_XAPP_BLIT
BOOTPTR ENDS
.CODE
XAPP_BLIT:
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
    ; bl      host_app_blit
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
    call host_app_blit
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
XAPP_BLIT_END:
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
nm_XAPP_PBLIT:
    ; DCB "(APP-PBLIT)", 0
    DB "(APP-PBLIT)", 0
hl_XAPP_PBLIT:
    ; DCB "(APP-PBLIT) ( c-addr u -- ) blit a 1-bit pixel map to the window", 0
    DB "(APP-PBLIT) ( c-addr u -- ) blit a 1-bit pixel map to the window", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_PBLIT:
    ; DCQ     nm_XAPP_PBLIT, hl_XAPP_PBLIT
    DQ OFFSET nm_XAPP_PBLIT, OFFSET hl_XAPP_PBLIT
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_PBLIT, XAPP_PBLIT_END
    DQ OFFSET XAPP_PBLIT, OFFSET XAPP_PBLIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_PBLIT
    DQ OFFSET row_XAPP_PBLIT
BOOTPTR ENDS
.CODE
XAPP_PBLIT:
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
    ; bl      host_app_pblit
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
    call host_app_pblit
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
XAPP_PBLIT_END:
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
nm_XAPP_CBLIT:
    ; DCB "(APP-CBLIT)", 0
    DB "(APP-CBLIT)", 0
hl_XAPP_CBLIT:
    ; DCB "(APP-CBLIT) ( c-addr u depth -- ) blit pixels of depth 1 8 or 32", 0
    DB "(APP-CBLIT) ( c-addr u depth -- ) blit pixels of depth 1 8 or 32", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_CBLIT:
    ; DCQ     nm_XAPP_CBLIT, hl_XAPP_CBLIT
    DQ OFFSET nm_XAPP_CBLIT, OFFSET hl_XAPP_CBLIT
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_CBLIT, XAPP_CBLIT_END
    DQ OFFSET XAPP_CBLIT, OFFSET XAPP_CBLIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_CBLIT
    DQ OFFSET row_XAPP_CBLIT
BOOTPTR ENDS
.CODE
XAPP_CBLIT:
    ; mov     x2, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x2, rax
    ; ldr     x1, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
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
    ; bl      host_app_cblit
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
    call host_app_cblit
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
XAPP_CBLIT_END:
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
nm_XAPP_KEYQ:
    ; DCB "(APP-KEY?)", 0
    DB "(APP-KEY?)", 0
hl_XAPP_KEYQ:
    ; DCB "(APP-KEY?) ( -- flag ) true when a graphics key is waiting", 0
    DB "(APP-KEY?) ( -- flag ) true when a graphics key is waiting", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_KEYQ:
    ; DCQ     nm_XAPP_KEYQ, hl_XAPP_KEYQ
    DQ OFFSET nm_XAPP_KEYQ, OFFSET hl_XAPP_KEYQ
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_KEYQ, XAPP_KEYQ_END
    DQ OFFSET XAPP_KEYQ, OFFSET XAPP_KEYQ_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_KEYQ
    DQ OFFSET row_XAPP_KEYQ
BOOTPTR ENDS
.CODE
XAPP_KEYQ:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_app_keyq
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
    call host_app_keyq
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
XAPP_KEYQ_END:
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
nm_XAPP_KEY:
    ; DCB "(APP-KEY)", 0
    DB "(APP-KEY)", 0
hl_XAPP_KEY:
    ; DCB "(APP-KEY) ( -- c ) next graphics key or -1 on timeout", 0
    DB "(APP-KEY) ( -- c ) next graphics key or -1 on timeout", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_KEY:
    ; DCQ     nm_XAPP_KEY, hl_XAPP_KEY
    DQ OFFSET nm_XAPP_KEY, OFFSET hl_XAPP_KEY
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_KEY, XAPP_KEY_END
    DQ OFFSET XAPP_KEY, OFFSET XAPP_KEY_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_KEY
    DQ OFFSET row_XAPP_KEY
BOOTPTR ENDS
.CODE
XAPP_KEY:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_app_key
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
    call host_app_key
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
XAPP_KEY_END:
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
nm_XAPP_NAME:
    ; DCB "(APP-NAME)", 0
    DB "(APP-NAME)", 0
hl_XAPP_NAME:
    ; DCB "(APP-NAME) ( c-addr u -- ) set the graphics window title", 0
    DB "(APP-NAME) ( c-addr u -- ) set the graphics window title", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_NAME:
    ; DCQ     nm_XAPP_NAME, hl_XAPP_NAME
    DQ OFFSET nm_XAPP_NAME, OFFSET hl_XAPP_NAME
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_NAME, XAPP_NAME_END
    DQ OFFSET XAPP_NAME, OFFSET XAPP_NAME_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_NAME
    DQ OFFSET row_XAPP_NAME
BOOTPTR ENDS
.CODE
XAPP_NAME:
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
    ; bl      host_app_name
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
    call host_app_name
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
XAPP_NAME_END:
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
nm_XAPP_TONE:
    ; DCB "(APP-TONE)", 0
    DB "(APP-TONE)", 0
hl_XAPP_TONE:
    ; DCB "(APP-TONE) ( freq dur -- ) play a tone for dur tenths of a second", 0
    DB "(APP-TONE) ( freq dur -- ) play a tone for dur tenths of a second", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_TONE:
    ; DCQ     nm_XAPP_TONE, hl_XAPP_TONE
    DQ OFFSET nm_XAPP_TONE, OFFSET hl_XAPP_TONE
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_TONE, XAPP_TONE_END
    DQ OFFSET XAPP_TONE, OFFSET XAPP_TONE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_TONE
    DQ OFFSET row_XAPP_TONE
BOOTPTR ENDS
.CODE
XAPP_TONE:
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
    ; bl      host_app_tone
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
    call host_app_tone
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
XAPP_TONE_END:
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
nm_XAPP_PUMP:
    ; DCB "(APP-PUMP)", 0
    DB "(APP-PUMP)", 0
hl_XAPP_PUMP:
    ; DCB "(APP-PUMP) ( -- ) yield so the graphics window can run", 0
    DB "(APP-PUMP) ( -- ) yield so the graphics window can run", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_PUMP:
    ; DCQ     nm_XAPP_PUMP, hl_XAPP_PUMP
    DQ OFFSET nm_XAPP_PUMP, OFFSET hl_XAPP_PUMP
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_PUMP, XAPP_PUMP_END
    DQ OFFSET XAPP_PUMP, OFFSET XAPP_PUMP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_PUMP
    DQ OFFSET row_XAPP_PUMP
BOOTPTR ENDS
.CODE
XAPP_PUMP:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_app_pump
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
    call host_app_pump
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
XAPP_PUMP_END:
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
nm_XAPP_MOUSE:
    ; DCB "(APP-MOUSE)", 0
    DB "(APP-MOUSE)", 0
hl_XAPP_MOUSE:
    ; DCB "(APP-MOUSE) ( -- x y buttons ) graphics mouse in plot coordinates", 0
    DB "(APP-MOUSE) ( -- x y buttons ) graphics mouse in plot coordinates", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_MOUSE:
    ; DCQ     nm_XAPP_MOUSE, hl_XAPP_MOUSE
    DQ OFFSET nm_XAPP_MOUSE, OFFSET hl_XAPP_MOUSE
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_MOUSE, XAPP_MOUSE_END
    DQ OFFSET XAPP_MOUSE, OFFSET XAPP_MOUSE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_MOUSE
    DQ OFFSET row_XAPP_MOUSE
BOOTPTR ENDS
.CODE
XAPP_MOUSE:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; sub     sp, sp, #32
    mov rax, rsp
    sub rax, 20h
    mov rsp, rax
    ; mov     x0, sp
    mov rax, rsp
    mov QWORD PTR arm_x0, rax
    ; add     x1, sp, #8
    mov rax, rsp
    add rax, 8
    mov QWORD PTR arm_x1, rax
    ; add     x2, sp, #16
    mov rax, rsp
    add rax, 10h
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [sp]
    lea r10, [rsp]
    mov QWORD PTR [r10], 0
    ; str     xzr, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; str     xzr, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov QWORD PTR [r10], 0
    ; bl      host_app_mouse
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
    call host_app_mouse
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldr     x0, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; add     sp, sp, #32
    mov rax, rsp
    add rax, 20h
    mov rsp, rax
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
    ; str     x0, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; str     x1, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; mov     x20, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x20, rax
XAPP_MOUSE_END:
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
nm_XAPP_SIZE:
    ; DCB "(APP-SIZE?)", 0
    DB "(APP-SIZE?)", 0
hl_XAPP_SIZE:
    ; DCB "(APP-SIZE?) ( -- cols rows flag ) pending grid after a resize", 0
    DB "(APP-SIZE?) ( -- cols rows flag ) pending grid after a resize", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_SIZE:
    ; DCQ     nm_XAPP_SIZE, hl_XAPP_SIZE
    DQ OFFSET nm_XAPP_SIZE, OFFSET hl_XAPP_SIZE
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_SIZE, XAPP_SIZE_END
    DQ OFFSET XAPP_SIZE, OFFSET XAPP_SIZE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_SIZE
    DQ OFFSET row_XAPP_SIZE
BOOTPTR ENDS
.CODE
XAPP_SIZE:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; sub     sp, sp, #32
    mov rax, rsp
    sub rax, 20h
    mov rsp, rax
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
    ; bl      host_app_size
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
    call host_app_size
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
    ; add     sp, sp, #32
    mov rax, rsp
    add rax, 20h
    mov rsp, rax
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
    ; str     x1, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; str     x2, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XAPP_SIZE_END:
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
nm_XAPP_IMG_CHOOSE:
    ; DCB "(APP-IMG-CHOOSE)", 0
    DB "(APP-IMG-CHOOSE)", 0
hl_XAPP_IMG_CHOOSE:
    ; DCB "(APP-IMG-CHOOSE) ( -- ior ) choose an image file", 0
    DB "(APP-IMG-CHOOSE) ( -- ior ) choose an image file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_IMG_CHOOSE:
    ; DCQ     nm_XAPP_IMG_CHOOSE, hl_XAPP_IMG_CHOOSE
    DQ OFFSET nm_XAPP_IMG_CHOOSE, OFFSET hl_XAPP_IMG_CHOOSE
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_IMG_CHOOSE, XAPP_IMG_CHOOSE_END
    DQ OFFSET XAPP_IMG_CHOOSE, OFFSET XAPP_IMG_CHOOSE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_IMG_CHOOSE
    DQ OFFSET row_XAPP_IMG_CHOOSE
BOOTPTR ENDS
.CODE
XAPP_IMG_CHOOSE:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_app_img_choose
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
    call host_app_img_choose
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
XAPP_IMG_CHOOSE_END:
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
nm_XAPP_IMG_LOAD:
    ; DCB "(APP-IMG-LOAD)", 0
    DB "(APP-IMG-LOAD)", 0
hl_XAPP_IMG_LOAD:
    ; DCB "(APP-IMG-LOAD) ( c-addr u -- ior ) load an image from a path", 0
    DB "(APP-IMG-LOAD) ( c-addr u -- ior ) load an image from a path", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_IMG_LOAD:
    ; DCQ     nm_XAPP_IMG_LOAD, hl_XAPP_IMG_LOAD
    DQ OFFSET nm_XAPP_IMG_LOAD, OFFSET hl_XAPP_IMG_LOAD
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_IMG_LOAD, XAPP_IMG_LOAD_END
    DQ OFFSET XAPP_IMG_LOAD, OFFSET XAPP_IMG_LOAD_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_IMG_LOAD
    DQ OFFSET row_XAPP_IMG_LOAD
BOOTPTR ENDS
.CODE
XAPP_IMG_LOAD:
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
    ; bl      host_app_img_load
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
    call host_app_img_load
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
XAPP_IMG_LOAD_END:
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
nm_XAPP_IMG_SIZE:
    ; DCB "(APP-IMG-SIZE)", 0
    DB "(APP-IMG-SIZE)", 0
hl_XAPP_IMG_SIZE:
    ; DCB "(APP-IMG-SIZE) ( -- w h ) loaded image size in pixels", 0
    DB "(APP-IMG-SIZE) ( -- w h ) loaded image size in pixels", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_IMG_SIZE:
    ; DCQ     nm_XAPP_IMG_SIZE, hl_XAPP_IMG_SIZE
    DQ OFFSET nm_XAPP_IMG_SIZE, OFFSET hl_XAPP_IMG_SIZE
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_IMG_SIZE, XAPP_IMG_SIZE_END
    DQ OFFSET XAPP_IMG_SIZE, OFFSET XAPP_IMG_SIZE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_IMG_SIZE
    DQ OFFSET row_XAPP_IMG_SIZE
BOOTPTR ENDS
.CODE
XAPP_IMG_SIZE:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; sub     sp, sp, #32
    mov rax, rsp
    sub rax, 20h
    mov rsp, rax
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
    ; bl      host_app_img_size
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
    call host_app_img_size
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldr     x0, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; add     sp, sp, #32
    mov rax, rsp
    add rax, 20h
    mov rsp, rax
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
    ; str     x0, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; mov     x20, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x20, rax
XAPP_IMG_SIZE_END:
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
nm_XAPP_IMG_RENDER:
    ; DCB "(APP-IMG-RENDER)", 0
    DB "(APP-IMG-RENDER)", 0
hl_XAPP_IMG_RENDER:
    ; DCB "(APP-IMG-RENDER) ( c-addr w h cx cy zoom100 -- ior ) render the image into BGRA", 0
    DB "(APP-IMG-RENDER) ( c-addr w h cx cy zoom100 -- ior ) render the image into BGRA", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_IMG_RENDER:
    ; DCQ     nm_XAPP_IMG_RENDER, hl_XAPP_IMG_RENDER
    DQ OFFSET nm_XAPP_IMG_RENDER, OFFSET hl_XAPP_IMG_RENDER
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_IMG_RENDER, XAPP_IMG_RENDER_END
    DQ OFFSET XAPP_IMG_RENDER, OFFSET XAPP_IMG_RENDER_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_IMG_RENDER
    DQ OFFSET row_XAPP_IMG_RENDER
BOOTPTR ENDS
.CODE
XAPP_IMG_RENDER:
    ; mov     x5, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x5, rax
    ; ldr     x4, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x4, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x3, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
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
    ; bl      host_app_img_render
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
    call host_app_img_render
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
XAPP_IMG_RENDER_END:
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
nm_XAPP_FILE_CHOOSE:
    ; DCB "(APP-FILE-CHOOSE)", 0
    DB "(APP-FILE-CHOOSE)", 0
hl_XAPP_FILE_CHOOSE:
    ; DCB "(APP-FILE-CHOOSE) ( -- ior ) choose a file and stage its path", 0
    DB "(APP-FILE-CHOOSE) ( -- ior ) choose a file and stage its path", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_FILE_CHOOSE:
    ; DCQ     nm_XAPP_FILE_CHOOSE, hl_XAPP_FILE_CHOOSE
    DQ OFFSET nm_XAPP_FILE_CHOOSE, OFFSET hl_XAPP_FILE_CHOOSE
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_FILE_CHOOSE, XAPP_FILE_CHOOSE_END
    DQ OFFSET XAPP_FILE_CHOOSE, OFFSET XAPP_FILE_CHOOSE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_FILE_CHOOSE
    DQ OFFSET row_XAPP_FILE_CHOOSE
BOOTPTR ENDS
.CODE
XAPP_FILE_CHOOSE:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_app_file_choose
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
    call host_app_file_choose
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
XAPP_FILE_CHOOSE_END:
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
nm_XAPP_FILE_SAVE_AS:
    ; DCB "(APP-FILE-SAVE-AS)", 0
    DB "(APP-FILE-SAVE-AS)", 0
hl_XAPP_FILE_SAVE_AS:
    ; DCB "(APP-FILE-SAVE-AS) ( -- ior ) choose a save path and stage it", 0
    DB "(APP-FILE-SAVE-AS) ( -- ior ) choose a save path and stage it", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_FILE_SAVE_AS:
    ; DCQ     nm_XAPP_FILE_SAVE_AS, hl_XAPP_FILE_SAVE_AS
    DQ OFFSET nm_XAPP_FILE_SAVE_AS, OFFSET hl_XAPP_FILE_SAVE_AS
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_FILE_SAVE_AS, XAPP_FILE_SAVE_AS_END
    DQ OFFSET XAPP_FILE_SAVE_AS, OFFSET XAPP_FILE_SAVE_AS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_FILE_SAVE_AS
    DQ OFFSET row_XAPP_FILE_SAVE_AS
BOOTPTR ENDS
.CODE
XAPP_FILE_SAVE_AS:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_app_file_save_as
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
    call host_app_file_save_as
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
XAPP_FILE_SAVE_AS_END:
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
nm_XAPP_FILE_PATH:
    ; DCB "(APP-FILE-PATH)", 0
    DB "(APP-FILE-PATH)", 0
hl_XAPP_FILE_PATH:
    ; DCB "(APP-FILE-PATH) ( c-addr u -- u2 ) copy the staged file path", 0
    DB "(APP-FILE-PATH) ( c-addr u -- u2 ) copy the staged file path", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_FILE_PATH:
    ; DCQ     nm_XAPP_FILE_PATH, hl_XAPP_FILE_PATH
    DQ OFFSET nm_XAPP_FILE_PATH, OFFSET hl_XAPP_FILE_PATH
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_FILE_PATH, XAPP_FILE_PATH_END
    DQ OFFSET XAPP_FILE_PATH, OFFSET XAPP_FILE_PATH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_FILE_PATH
    DQ OFFSET row_XAPP_FILE_PATH
BOOTPTR ENDS
.CODE
XAPP_FILE_PATH:
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
    ; bl      host_app_file_path
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
    call host_app_file_path
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
XAPP_FILE_PATH_END:
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
nm_XAPP_FILE_SLURP:
    ; DCB "(APP-FILE-SLURP)", 0
    DB "(APP-FILE-SLURP)", 0
hl_XAPP_FILE_SLURP:
    ; DCB "(APP-FILE-SLURP) ( c-addr max -- u ior ) read the staged file", 0
    DB "(APP-FILE-SLURP) ( c-addr max -- u ior ) read the staged file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_FILE_SLURP:
    ; DCQ     nm_XAPP_FILE_SLURP, hl_XAPP_FILE_SLURP
    DQ OFFSET nm_XAPP_FILE_SLURP, OFFSET hl_XAPP_FILE_SLURP
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_FILE_SLURP, XAPP_FILE_SLURP_END
    DQ OFFSET XAPP_FILE_SLURP, OFFSET XAPP_FILE_SLURP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_FILE_SLURP
    DQ OFFSET row_XAPP_FILE_SLURP
BOOTPTR ENDS
.CODE
XAPP_FILE_SLURP:
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
    ; sub     sp, sp, #16
    mov rax, rsp
    sub rax, 10h
    mov rsp, rax
    ; mov     x2, sp
    mov rax, rsp
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [sp]
    lea r10, [rsp]
    mov QWORD PTR [r10], 0
    ; bl      host_app_file_slurp
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
    call host_app_file_slurp
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldr     x1, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; add     sp, sp, #16
    mov rax, rsp
    add rax, 10h
    mov rsp, rax
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
    ; str     x1, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XAPP_FILE_SLURP_END:
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
nm_XAPP_FILE_SPEW:
    ; DCB "(APP-FILE-SPEW)", 0
    DB "(APP-FILE-SPEW)", 0
hl_XAPP_FILE_SPEW:
    ; DCB "(APP-FILE-SPEW) ( c-addr u -- ior ) write bytes to the staged file", 0
    DB "(APP-FILE-SPEW) ( c-addr u -- ior ) write bytes to the staged file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAPP_FILE_SPEW:
    ; DCQ     nm_XAPP_FILE_SPEW, hl_XAPP_FILE_SPEW
    DQ OFFSET nm_XAPP_FILE_SPEW, OFFSET hl_XAPP_FILE_SPEW
    ; DCQ     0
    DQ 0
    ; DCQ     XAPP_FILE_SPEW, XAPP_FILE_SPEW_END
    DQ OFFSET XAPP_FILE_SPEW, OFFSET XAPP_FILE_SPEW_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAPP_FILE_SPEW
    DQ OFFSET row_XAPP_FILE_SPEW
BOOTPTR ENDS
.CODE
XAPP_FILE_SPEW:
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
    ; bl      host_app_file_spew
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
    call host_app_file_spew
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
XAPP_FILE_SPEW_END:
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
nm_XSESCAPE:
    ; DCB "S", 0x5C, 0x22, 0
    DB "S", 5Ch, 22h, 0
hl_XSESCAPE:
    ; DCB "S", 0x5C, 0x22, "escaped string", 0
    DB "S", 5Ch, 22h, "escaped string", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSESCAPE:
    ; DCQ     nm_XSESCAPE, hl_XSESCAPE
    DQ OFFSET nm_XSESCAPE, OFFSET hl_XSESCAPE
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XSESCAPE, 0
    DQ OFFSET XSESCAPE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSESCAPE
    DQ OFFSET row_XSESCAPE
BOOTPTR ENDS
.CODE
XSESCAPE:
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
    lea rax, xret_16
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_16:
    ; mov     x1, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x1, rax
    ; lea x6, source_end
    lea rax, source_end
    mov QWORD PTR arm_x6, rax
    ; ldr     x6, [x6]
    mov r10, QWORD PTR arm_x6
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; lea x8, slit_esc_which
    lea rax, slit_esc_which
    mov QWORD PTR arm_x8, rax
    ; ldr     x4, [x8]
    mov r10, QWORD PTR arm_x8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbnz    x4, _se_buf2
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    jne _se_buf2
    ; lea x7, slit_esc_buf
    lea rax, slit_esc_buf
    mov QWORD PTR arm_x7, rax
    ; mov     x4, #1
    mov rax, 1
    mov QWORD PTR arm_x4, rax
    ; str     x4, [x8]
    mov r10, QWORD PTR arm_x8
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10], rax
    ; b       _se_ready
    jmp _se_ready
_se_buf2:
    ; lea x7, slit_esc_buf2
    lea rax, slit_esc_buf2
    mov QWORD PTR arm_x7, rax
    ; str     xzr, [x8]
    mov r10, QWORD PTR arm_x8
    mov QWORD PTR [r10], 0
_se_ready:
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
_se_loop:
    ; cmp     x1, x6
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x6
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _se_done
    cmp BYTE PTR arm_c, 0
    jne _se_done
    ; ldrb    w2, [x1], #1
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; cmp     w2, #34
    mov eax, DWORD PTR arm_x2
    cmp eax, 22h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_done
    cmp BYTE PTR arm_z, 0
    jne _se_done
    ; cmp     w2, #92
    mov eax, DWORD PTR arm_x2
    cmp eax, 5Ch
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _se_put
    cmp BYTE PTR arm_z, 0
    je _se_put
    ; cmp     x1, x6
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x6
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _se_done
    cmp BYTE PTR arm_c, 0
    jne _se_done
    ; ldrb    w2, [x1], #1
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; cmp     w2, #'a'
    mov eax, DWORD PTR arm_x2
    cmp eax, 61h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_a
    cmp BYTE PTR arm_z, 0
    jne _se_a
    ; cmp     w2, #'b'
    mov eax, DWORD PTR arm_x2
    cmp eax, 62h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_b
    cmp BYTE PTR arm_z, 0
    jne _se_b
    ; cmp     w2, #'e'
    mov eax, DWORD PTR arm_x2
    cmp eax, 65h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_e
    cmp BYTE PTR arm_z, 0
    jne _se_e
    ; cmp     w2, #'f'
    mov eax, DWORD PTR arm_x2
    cmp eax, 66h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_f
    cmp BYTE PTR arm_z, 0
    jne _se_f
    ; cmp     w2, #'l'
    mov eax, DWORD PTR arm_x2
    cmp eax, 6Ch
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_l
    cmp BYTE PTR arm_z, 0
    jne _se_l
    ; cmp     w2, #'m'
    mov eax, DWORD PTR arm_x2
    cmp eax, 6Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_m
    cmp BYTE PTR arm_z, 0
    jne _se_m
    ; cmp     w2, #'n'
    mov eax, DWORD PTR arm_x2
    cmp eax, 6Eh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_n
    cmp BYTE PTR arm_z, 0
    jne _se_n
    ; cmp     w2, #'q'
    mov eax, DWORD PTR arm_x2
    cmp eax, 71h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_q
    cmp BYTE PTR arm_z, 0
    jne _se_q
    ; cmp     w2, #'r'
    mov eax, DWORD PTR arm_x2
    cmp eax, 72h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_r
    cmp BYTE PTR arm_z, 0
    jne _se_r
    ; cmp     w2, #'t'
    mov eax, DWORD PTR arm_x2
    cmp eax, 74h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_t
    cmp BYTE PTR arm_z, 0
    jne _se_t
    ; cmp     w2, #'v'
    mov eax, DWORD PTR arm_x2
    cmp eax, 76h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_v
    cmp BYTE PTR arm_z, 0
    jne _se_v
    ; cmp     w2, #'z'
    mov eax, DWORD PTR arm_x2
    cmp eax, 7Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_z
    cmp BYTE PTR arm_z, 0
    jne _se_z
    ; cmp     w2, #34
    mov eax, DWORD PTR arm_x2
    cmp eax, 22h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_q
    cmp BYTE PTR arm_z, 0
    jne _se_q
    ; cmp     w2, #92
    mov eax, DWORD PTR arm_x2
    cmp eax, 5Ch
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_put
    cmp BYTE PTR arm_z, 0
    jne _se_put
    ; cmp     w2, #'x'
    mov eax, DWORD PTR arm_x2
    cmp eax, 78h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _se_hex
    cmp BYTE PTR arm_z, 0
    jne _se_hex
    ; b       _se_put
    jmp _se_put
_se_a:
    ; mov     w2, #7
    mov eax, 7
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_b:
    ; mov     w2, #8
    mov eax, 8
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_e:
    ; mov     w2, #27
    mov eax, 1Bh
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_f:
    ; mov     w2, #12
    mov eax, 0Ch
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_l:
    ; mov     w2, #10
    mov eax, 0Ah
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_n:
    ; mov     w2, #10
    mov eax, 0Ah
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_q:
    ; mov     w2, #34
    mov eax, 22h
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_r:
    ; mov     w2, #13
    mov eax, 0Dh
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_t:
    ; mov     w2, #9
    mov eax, 9
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_v:
    ; mov     w2, #11
    mov eax, 0Bh
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_z:
    ; mov     w2, #0
    mov eax, 0
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_m:
    ; cmp     x5, #254
    mov rax, QWORD PTR arm_x5
    cmp rax, 0FEh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _se_loop
    cmp BYTE PTR arm_c, 0
    jne _se_loop
    ; mov     w2, #13
    mov eax, 0Dh
    mov QWORD PTR arm_x2, rax
    ; strb    w2, [x7, x5]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR arm_x5
    add r10, rax
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    ; add     x5, x5, #1
    mov rax, QWORD PTR arm_x5
    add rax, 1
    mov QWORD PTR arm_x5, rax
    ; mov     w2, #10
    mov eax, 0Ah
    mov QWORD PTR arm_x2, rax
    ; b       _se_put
    jmp _se_put
_se_hex:
    ; mov     w3, #0
    mov eax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #2
    mov rax, 2
    mov QWORD PTR arm_x4, rax
_se_hx:
    ; cbz     x4, _se_hexput
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    je _se_hexput
    ; cmp     x1, x6
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x6
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _se_hexput
    cmp BYTE PTR arm_c, 0
    jne _se_hexput
    ; ldrb    w2, [x1]
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; sub     w8, w2, #'0'
    mov eax, DWORD PTR arm_x2
    sub eax, 30h
    mov QWORD PTR arm_x8, rax
    ; cmp     w8, #9
    mov eax, DWORD PTR arm_x8
    cmp eax, 9
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _se_hok
    cmp BYTE PTR arm_c, 0
    je _se_hok
    cmp BYTE PTR arm_z, 0
    jne _se_hok
    ; sub     w8, w2, #'A'
    mov eax, DWORD PTR arm_x2
    sub eax, 41h
    mov QWORD PTR arm_x8, rax
    ; cmp     w8, #5
    mov eax, DWORD PTR arm_x8
    cmp eax, 5
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _se_hu
    cmp BYTE PTR arm_c, 0
    je _se_hu
    cmp BYTE PTR arm_z, 0
    jne _se_hu
    ; sub     w8, w2, #'a'
    mov eax, DWORD PTR arm_x2
    sub eax, 61h
    mov QWORD PTR arm_x8, rax
    ; cmp     w8, #5
    mov eax, DWORD PTR arm_x8
    cmp eax, 5
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _se_hexput
    cmp BYTE PTR arm_c, 0
    je xsk_17
    cmp BYTE PTR arm_z, 0
    je _se_hexput
    xsk_17:
_se_hu:
    ; add     w8, w8, #10
    mov eax, DWORD PTR arm_x8
    add eax, 0Ah
    mov QWORD PTR arm_x8, rax
_se_hok:
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; lsl     w3, w3, #4
    mov eax, DWORD PTR arm_x3
    shl eax, 4
    mov QWORD PTR arm_x3, rax
    ; orr     w3, w3, w8
    mov eax, DWORD PTR arm_x3
    mov ecx, DWORD PTR arm_x8
    or eax, ecx
    mov QWORD PTR arm_x3, rax
    ; sub     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    sub rax, 1
    mov QWORD PTR arm_x4, rax
    ; b       _se_hx
    jmp _se_hx
_se_hexput:
    ; mov     w2, w3
    mov eax, DWORD PTR arm_x3
    mov QWORD PTR arm_x2, rax
_se_put:
    ; cmp     x5, #255
    mov rax, QWORD PTR arm_x5
    cmp rax, 0FFh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _se_loop
    cmp BYTE PTR arm_c, 0
    jne _se_loop
    ; strb    w2, [x7, x5]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR arm_x5
    add r10, rax
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    ; add     x5, x5, #1
    mov rax, QWORD PTR arm_x5
    add rax, 1
    mov QWORD PTR arm_x5, rax
    ; b       _se_loop
    jmp _se_loop
_se_done:
    ; stp     x7, x5, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10+8], rax
    ; mov     x0, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x0, rax
    ; bl      _cursor_commit
    lea rax, xret_18
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_18:
    ; ldp     x7, x5, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x7, rax
    mov QWORD PTR arm_x5, rcx
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, _se_comp
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _se_comp
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; str     x7, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x7
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
_se_comp:
    ; stp     x7, x5, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x7
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
    lea rax, xret_19
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_19:
    ; ldr     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_20
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_20:
    ; ldp     x7, x5, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x7, rax
    mov QWORD PTR arm_x5, rcx
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
_se_cpy:
    ; cmp     x3, x5
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ge    _se_align
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _se_align
    ; ldrb    w4, [x7, x3]
    mov r10, QWORD PTR arm_x7
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
    ; b       _se_cpy
    jmp _se_cpy
_se_align:
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
nm_XWORDS:
    ; DCB "WORDS", 0
    DB "WORDS", 0
hl_XWORDS:
    ; DCB "WORDS ( [filter] -- ) list first search-order wordlist sorted", 0
    DB "WORDS ( [filter] -- ) list first search-order wordlist sorted", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XWORDS:
    ; DCQ     nm_XWORDS, hl_XWORDS
    DQ OFFSET nm_XWORDS, OFFSET hl_XWORDS
    ; DCQ     0
    DQ 0
    ; DCQ     XWORDS, 0
    DQ OFFSET XWORDS, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XWORDS
    DQ OFFSET row_XWORDS
BOOTPTR ENDS
.CODE
XWORDS:
    ; sub     sp, sp, #112
    mov rax, rsp
    sub rax, 70h
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
    ; stp     x23, x24, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x24
    mov QWORD PTR [r10+8], rax
    ; stp     x25, x26, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR [r10+8], rax
    ; bl      _next_word
    lea rax, xret_21
    mov QWORD PTR arm_x30, rax
    jmp _next_word
    xret_21:
    ; mov     x2, #63
    mov rax, 3Fh
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
    je xsk_24
    cmp BYTE PTR arm_z, 0
    je xsk_22
    xsk_24:
    mov rax, QWORD PTR arm_x1
    jmp xsk_23
    xsk_22:
    mov rax, QWORD PTR arm_x2
    xsk_23:
    mov QWORD PTR arm_x1, rax
    ; lea x2, words_filter_len
    lea rax, words_filter_len
    mov QWORD PTR arm_x2, rax
    ; str     x1, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x3, words_filter
    lea rax, words_filter
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
_xw_filt:
    ; cmp     x4, x1
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _xw_wid
    cmp BYTE PTR arm_c, 0
    jne _xw_wid
    ; ldrb    w5, [x0, x4]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x4
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; cmp     w5, #'a'
    mov eax, DWORD PTR arm_x5
    cmp eax, 61h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _xw_filt_st
    cmp BYTE PTR arm_c, 0
    je _xw_filt_st
    ; cmp     w5, #'z'
    mov eax, DWORD PTR arm_x5
    cmp eax, 7Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _xw_filt_st
    cmp BYTE PTR arm_c, 0
    je xsk_25
    cmp BYTE PTR arm_z, 0
    je _xw_filt_st
    xsk_25:
    ; sub     w5, w5, #32
    mov eax, DWORD PTR arm_x5
    sub eax, 20h
    mov QWORD PTR arm_x5, rax
_xw_filt_st:
    ; strb    w5, [x3, x4]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    add r10, rax
    mov eax, DWORD PTR arm_x5
    mov BYTE PTR [r10], al
    ; add     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; b       _xw_filt
    jmp _xw_filt
_xw_wid:
    ; lea x0, search_order_n
    lea rax, search_order_n
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _xw_forth
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _xw_forth
    ; lea x0, search_order
    lea rax, search_order
    mov QWORD PTR arm_x0, rax
    ; ldr     x19, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    ; b       _xw_pass1
    jmp _xw_pass1
_xw_forth:
    ; lea x19, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x19, rax
_xw_pass1:
    ; lea x21, words_cfa
    lea rax, words_cfa
    mov QWORD PTR arm_x21, rax
    ; mov     x22, #0
    mov rax, 0
    mov QWORD PTR arm_x22, rax
    ; mov     x25, #0
    mov rax, 0
    mov QWORD PTR arm_x25, rax
_xw_t1:
    ; cmp     x25, #16
    mov rax, QWORD PTR arm_x25
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _xw_nk
    cmp BYTE PTR arm_c, 0
    jne _xw_nk
    ; add     x0, x19, x25, lsl #3
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x25
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
_xw_c1:
    ; cbz     x20, _xw_n1
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    je _xw_n1
    ; cmp     x22, #WORDS_MAX
    mov rax, QWORD PTR arm_x22
    cmp rax, 400h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _xw_nk
    cmp BYTE PTR arm_c, 0
    jne _xw_nk
    ; lea x0, words_user_base
    lea rax, words_user_base
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _xw_kfilt
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _xw_kfilt
    ; cmp     x20, x0
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _xw_link1
    cmp BYTE PTR arm_c, 0
    jne _xw_link1
_xw_kfilt:
    ; lea x0, words_filter_len
    lea rax, words_filter_len
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _xw_keep1
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _xw_keep1
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      _words_name_ptr
    lea rax, xret_26
    mov QWORD PTR arm_x30, rax
    jmp _words_name_ptr
    xret_26:
    ; bl      _words_filter_match
    lea rax, xret_27
    mov QWORD PTR arm_x30, rax
    jmp _words_filter_match
    xret_27:
    ; cbz     x0, _xw_link1
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _xw_link1
_xw_keep1:
    ; str     x20, [x21, x22, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x22
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; add     x22, x22, #1
    mov rax, QWORD PTR arm_x22
    add rax, 1
    mov QWORD PTR arm_x22, rax
_xw_link1:
    ; ldr     x20, [x20, #-16]
    mov r10, QWORD PTR arm_x20
    add r10, -16
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; b       _xw_c1
    jmp _xw_c1
_xw_n1:
    ; add     x25, x25, #1
    mov rax, QWORD PTR arm_x25
    add rax, 1
    mov QWORD PTR arm_x25, rax
    ; b       _xw_t1
    jmp _xw_t1
_xw_nk:
    ; lea x0, words_nk_tmp
    lea rax, words_nk_tmp
    mov QWORD PTR arm_x0, rax
    ; str     x22, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10], rax
    ; lea x0, words_user_base
    lea rax, words_user_base
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _xw_rev
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _xw_rev
    ; mov     x25, #0
    mov rax, 0
    mov QWORD PTR arm_x25, rax
_xw_t2:
    ; cmp     x25, #16
    mov rax, QWORD PTR arm_x25
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _xw_rev
    cmp BYTE PTR arm_c, 0
    jne _xw_rev
    ; add     x0, x19, x25, lsl #3
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x25
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
_xw_c2:
    ; cbz     x20, _xw_n2
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    je _xw_n2
    ; cmp     x22, #WORDS_MAX
    mov rax, QWORD PTR arm_x22
    cmp rax, 400h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _xw_rev
    cmp BYTE PTR arm_c, 0
    jne _xw_rev
    ; lea x0, words_user_base
    lea rax, words_user_base
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x20, x0
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _xw_link2
    cmp BYTE PTR arm_c, 0
    je _xw_link2
    ; lea x0, words_filter_len
    lea rax, words_filter_len
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _xw_keep2
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _xw_keep2
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      _words_name_ptr
    lea rax, xret_28
    mov QWORD PTR arm_x30, rax
    jmp _words_name_ptr
    xret_28:
    ; bl      _words_filter_match
    lea rax, xret_29
    mov QWORD PTR arm_x30, rax
    jmp _words_filter_match
    xret_29:
    ; cbz     x0, _xw_link2
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _xw_link2
_xw_keep2:
    ; str     x20, [x21, x22, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x22
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; add     x22, x22, #1
    mov rax, QWORD PTR arm_x22
    add rax, 1
    mov QWORD PTR arm_x22, rax
_xw_link2:
    ; ldr     x20, [x20, #-16]
    mov r10, QWORD PTR arm_x20
    add r10, -16
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; b       _xw_c2
    jmp _xw_c2
_xw_n2:
    ; add     x25, x25, #1
    mov rax, QWORD PTR arm_x25
    add rax, 1
    mov QWORD PTR arm_x25, rax
    ; b       _xw_t2
    jmp _xw_t2
_xw_rev:
    ; lea x0, words_nk_tmp
    lea rax, words_nk_tmp
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x22, x0
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _xw_sort
    cmp BYTE PTR arm_c, 0
    je _xw_sort
    cmp BYTE PTR arm_z, 0
    jne _xw_sort
    ; sub     x1, x22, #1
    mov rax, QWORD PTR arm_x22
    sub rax, 1
    mov QWORD PTR arm_x1, rax
_xw_rev_loop:
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ge    _xw_sort
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _xw_sort
    ; ldr     x2, [x21, x0, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x0
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x21, x1, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x21, x0, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x0
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; str     x2, [x21, x1, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _xw_rev_loop
    jmp _xw_rev_loop
_xw_sort:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
_xw_sort_i:
    ; lea x0, words_nk_tmp
    lea rax, words_nk_tmp
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
    ; b.hs    _xw_hdr
    cmp BYTE PTR arm_c, 0
    jne _xw_hdr
    ; ldr     x2, [x21, x1, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; mov     x3, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x3, rax
_xw_sort_j:
    ; cbz     x3, _xw_sort_put
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    je _xw_sort_put
    ; sub     x4, x3, #1
    mov rax, QWORD PTR arm_x3
    sub rax, 1
    mov QWORD PTR arm_x4, rax
    ; ldr     x5, [x21, x4, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x4
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; stp     x1, x2, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10+8], rax
    ; stp     x3, x4, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10+8], rax
    ; mov     x0, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x1, rax
    ; bl      _words_cfa_cmp
    lea rax, xret_30
    mov QWORD PTR arm_x30, rax
    jmp _words_cfa_cmp
    xret_30:
    ; ldp     x3, x4, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x3, rax
    mov QWORD PTR arm_x4, rcx
    add rsp, 10h
    ; ldp     x1, x2, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x1, rax
    mov QWORD PTR arm_x2, rcx
    add rsp, 10h
    ; cmp     x0, #0
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.le    _xw_sort_put
    cmp BYTE PTR arm_z, 0
    jne _xw_sort_put
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne _xw_sort_put
    ; ldr     x5, [x21, x4, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x4
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; str     x5, [x21, x3, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x3
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10], rax
    ; mov     x3, x4
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR arm_x3, rax
    ; b       _xw_sort_j
    jmp _xw_sort_j
_xw_sort_put:
    ; str     x2, [x21, x3, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x3
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _xw_sort_i
    jmp _xw_sort_i
_xw_hdr:
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_31
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_31:
    ; lea x0, str_words_hdr1
    lea rax, str_words_hdr1
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_32
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_32:
    ; mov     x0, x19
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR arm_x0, rax
    ; bl      _print_wid_name
    lea rax, xret_33
    mov QWORD PTR arm_x30, rax
    jmp _print_wid_name
    xret_33:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_34
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_34:
    ; mov     x0, #'('
    mov rax, 28h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_35
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_35:
    ; mov     x0, x22
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR arm_x0, rax
    ; bl      _print_unsigned
    lea rax, xret_36
    mov QWORD PTR arm_x30, rax
    jmp _print_unsigned
    xret_36:
    ; mov     x0, #')'
    mov rax, 29h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_37
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_37:
    ; lea x0, str_words_hdr2
    lea rax, str_words_hdr2
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_38
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_38:
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_39
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_39:
    ; lea x0, words_nk_tmp
    lea rax, words_nk_tmp
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _xw_user
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _xw_user
    ; lea x0, str_words_sys
    lea rax, str_words_sys
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_40
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_40:
    ; mov     x23, #0
    mov rax, 0
    mov QWORD PTR arm_x23, rax
    ; mov     x24, #0
    mov rax, 0
    mov QWORD PTR arm_x24, rax
_xw_sys_i:
    ; lea x0, words_nk_tmp
    lea rax, words_nk_tmp
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x23, x0
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _xw_sys_nl
    cmp BYTE PTR arm_c, 0
    jne _xw_sys_nl
    ; ldr     x0, [x21, x23, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x23
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _words_name_ptr
    lea rax, xret_41
    mov QWORD PTR arm_x30, rax
    jmp _words_name_ptr
    xret_41:
    ; cbz     x1, _xw_sys_sp
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _xw_sys_sp
    ; stp     x23, x24, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x24
    mov QWORD PTR [r10+8], rax
    ; bl      emit_str
    lea rax, xret_42
    mov QWORD PTR arm_x30, rax
    jmp emit_str
    xret_42:
    ; ldp     x23, x24, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x23, rax
    mov QWORD PTR arm_x24, rcx
    add rsp, 10h
_xw_sys_sp:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_43
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_43:
    ; add     x24, x24, #1
    mov rax, QWORD PTR arm_x24
    add rax, 1
    mov QWORD PTR arm_x24, rax
    ; cmp     x24, #8
    mov rax, QWORD PTR arm_x24
    cmp rax, 8
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _xw_sys_next
    cmp BYTE PTR arm_c, 0
    je _xw_sys_next
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_44
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_44:
    ; mov     x24, #0
    mov rax, 0
    mov QWORD PTR arm_x24, rax
_xw_sys_next:
    ; add     x23, x23, #1
    mov rax, QWORD PTR arm_x23
    add rax, 1
    mov QWORD PTR arm_x23, rax
    ; b       _xw_sys_i
    jmp _xw_sys_i
_xw_sys_nl:
    ; cbz     x24, _xw_user
    mov rax, QWORD PTR arm_x24
    cmp rax, 0
    je _xw_user
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_45
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_45:
_xw_user:
    ; lea x0, words_nk_tmp
    lea rax, words_nk_tmp
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x22, x0
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _xw_done
    cmp BYTE PTR arm_c, 0
    je _xw_done
    cmp BYTE PTR arm_z, 0
    jne _xw_done
    ; lea x0, str_words_user
    lea rax, str_words_user
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_46
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_46:
    ; lea x0, words_nk_tmp
    lea rax, words_nk_tmp
    mov QWORD PTR arm_x0, rax
    ; ldr     x23, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x23, rax
    ; mov     x24, #0
    mov rax, 0
    mov QWORD PTR arm_x24, rax
_xw_user_i:
    ; cmp     x23, x22
    mov rax, QWORD PTR arm_x23
    mov rcx, QWORD PTR arm_x22
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _xw_user_nl
    cmp BYTE PTR arm_c, 0
    jne _xw_user_nl
    ; ldr     x0, [x21, x23, lsl #3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x23
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _words_name_ptr
    lea rax, xret_47
    mov QWORD PTR arm_x30, rax
    jmp _words_name_ptr
    xret_47:
    ; cbz     x1, _xw_user_sp
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _xw_user_sp
    ; stp     x23, x24, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x24
    mov QWORD PTR [r10+8], rax
    ; bl      emit_str
    lea rax, xret_48
    mov QWORD PTR arm_x30, rax
    jmp emit_str
    xret_48:
    ; ldp     x23, x24, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x23, rax
    mov QWORD PTR arm_x24, rcx
    add rsp, 10h
_xw_user_sp:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_49
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_49:
    ; add     x24, x24, #1
    mov rax, QWORD PTR arm_x24
    add rax, 1
    mov QWORD PTR arm_x24, rax
    ; cmp     x24, #8
    mov rax, QWORD PTR arm_x24
    cmp rax, 8
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _xw_user_next
    cmp BYTE PTR arm_c, 0
    je _xw_user_next
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_50
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_50:
    ; mov     x24, #0
    mov rax, 0
    mov QWORD PTR arm_x24, rax
_xw_user_next:
    ; add     x23, x23, #1
    mov rax, QWORD PTR arm_x23
    add rax, 1
    mov QWORD PTR arm_x23, rax
    ; b       _xw_user_i
    jmp _xw_user_i
_xw_user_nl:
    ; cbz     x24, _xw_done
    mov rax, QWORD PTR arm_x24
    cmp rax, 0
    je _xw_done
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_51
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_51:
_xw_done:
    ; ldp     x25, x26, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x25, rax
    mov QWORD PTR arm_x26, rcx
    ; ldp     x23, x24, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x23, rax
    mov QWORD PTR arm_x24, rcx
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
    ; add     sp, sp, #112
    mov rax, rsp
    add rax, 70h
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
_record_words_user_base_once:
    ; lea x0, words_user_base
    lea rax, words_user_base
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, _rec_done
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne _rec_done
    ; lea x1, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
_rec_done:
    ; ret
    jmp QWORD PTR arm_x30
_words_name_ptr:
    ; ldr     x1, [x0, #-8]
    mov r10, QWORD PTR arm_x0
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; and     x1, x1, #0xFFFF
    mov rax, QWORD PTR arm_x1
    and rax, 0FFFFh
    mov QWORD PTR arm_x1, rax
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
    ; tst     w1, #0x80
    mov eax, DWORD PTR arm_x1
    test eax, 80h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.eq    _wnp_len
    cmp BYTE PTR arm_z, 0
    jne _wnp_len
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; ret
    jmp QWORD PTR arm_x30
_wnp_len:
    ; and     w1, w1, #0x7F
    mov eax, DWORD PTR arm_x1
    and eax, 7Fh
    mov QWORD PTR arm_x1, rax
    ; ret
    jmp QWORD PTR arm_x30
_words_cfa_cmp:
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
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
    ; mov     x20, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x20, rax
    ; bl      _words_name_ptr
    lea rax, xret_52
    mov QWORD PTR arm_x30, rax
    jmp _words_name_ptr
    xret_52:
    ; mov     x21, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x21, rax
    ; mov     x22, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x22, rax
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      _words_name_ptr
    lea rax, xret_53
    mov QWORD PTR arm_x30, rax
    jmp _words_name_ptr
    xret_53:
    ; mov     x2, x22
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR arm_x2, rax
    ; cmp     x2, x1
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csel    x2, x1, x2, hi
    cmp BYTE PTR arm_c, 0
    je xsk_56
    cmp BYTE PTR arm_z, 0
    je xsk_54
    xsk_56:
    mov rax, QWORD PTR arm_x2
    jmp xsk_55
    xsk_54:
    mov rax, QWORD PTR arm_x1
    xsk_55:
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
_wcmp_ch:
    ; cmp     x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _wcmp_len
    cmp BYTE PTR arm_c, 0
    jne _wcmp_len
    ; ldrb    w4, [x21, x3]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR arm_x3
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; ldrb    w5, [x0, x3]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; cmp     w4, #'a'
    mov eax, DWORD PTR arm_x4
    cmp eax, 61h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _wcmp_b
    cmp BYTE PTR arm_c, 0
    je _wcmp_b
    ; cmp     w4, #'z'
    mov eax, DWORD PTR arm_x4
    cmp eax, 7Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _wcmp_b
    cmp BYTE PTR arm_c, 0
    je xsk_57
    cmp BYTE PTR arm_z, 0
    je _wcmp_b
    xsk_57:
    ; sub     w4, w4, #32
    mov eax, DWORD PTR arm_x4
    sub eax, 20h
    mov QWORD PTR arm_x4, rax
_wcmp_b:
    ; cmp     w5, #'a'
    mov eax, DWORD PTR arm_x5
    cmp eax, 61h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _wcmp_eq
    cmp BYTE PTR arm_c, 0
    je _wcmp_eq
    ; cmp     w5, #'z'
    mov eax, DWORD PTR arm_x5
    cmp eax, 7Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _wcmp_eq
    cmp BYTE PTR arm_c, 0
    je xsk_58
    cmp BYTE PTR arm_z, 0
    je _wcmp_eq
    xsk_58:
    ; sub     w5, w5, #32
    mov eax, DWORD PTR arm_x5
    sub eax, 20h
    mov QWORD PTR arm_x5, rax
_wcmp_eq:
    ; cmp     w4, w5
    mov eax, DWORD PTR arm_x4
    mov ecx, DWORD PTR arm_x5
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _wcmp_diff
    cmp BYTE PTR arm_z, 0
    je _wcmp_diff
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _wcmp_ch
    jmp _wcmp_ch
_wcmp_len:
    ; cmp     x22, x1
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _wcmp_zero
    cmp BYTE PTR arm_z, 0
    jne _wcmp_zero
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; b.hs    _wcmp_out
    cmp BYTE PTR arm_c, 0
    jne _wcmp_out
    ; mov     x0, #-1
    mov rax, -1
    mov QWORD PTR arm_x0, rax
    ; b       _wcmp_out
    jmp _wcmp_out
_wcmp_diff:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; cmp     w4, w5
    mov eax, DWORD PTR arm_x4
    mov ecx, DWORD PTR arm_x5
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _wcmp_out
    cmp BYTE PTR arm_c, 0
    jne _wcmp_out
    ; mov     x0, #-1
    mov rax, -1
    mov QWORD PTR arm_x0, rax
    ; b       _wcmp_out
    jmp _wcmp_out
_wcmp_zero:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
_wcmp_out:
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
    ; ret
    jmp QWORD PTR arm_x30
_words_filter_match:
    ; lea x2, words_filter_len
    lea rax, words_filter_len
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, _wfm_yes
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je _wfm_yes
    ; lea x3, words_filter
    lea rax, words_filter
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
_wfm_start:
    ; add     x5, x4, x2
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x5, rax
    ; cmp     x5, x1
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _wfm_no
    cmp BYTE PTR arm_c, 0
    je xsk_59
    cmp BYTE PTR arm_z, 0
    je _wfm_no
    xsk_59:
    ; mov     x6, #0
    mov rax, 0
    mov QWORD PTR arm_x6, rax
_wfm_i:
    ; cmp     x6, x2
    mov rax, QWORD PTR arm_x6
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _wfm_yes
    cmp BYTE PTR arm_c, 0
    jne _wfm_yes
    ; add     x7, x4, x6
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x6
    add rax, rcx
    mov QWORD PTR arm_x7, rax
    ; ldrb    w8, [x0, x7]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x7
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x8, rax
    ; cmp     w8, #'a'
    mov eax, DWORD PTR arm_x8
    cmp eax, 61h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _wfm_cmp
    cmp BYTE PTR arm_c, 0
    je _wfm_cmp
    ; cmp     w8, #'z'
    mov eax, DWORD PTR arm_x8
    cmp eax, 7Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _wfm_cmp
    cmp BYTE PTR arm_c, 0
    je xsk_60
    cmp BYTE PTR arm_z, 0
    je _wfm_cmp
    xsk_60:
    ; sub     w8, w8, #32
    mov eax, DWORD PTR arm_x8
    sub eax, 20h
    mov QWORD PTR arm_x8, rax
_wfm_cmp:
    ; ldrb    w9, [x3, x6]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x6
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x9, rax
    ; cmp     w8, w9
    mov eax, DWORD PTR arm_x8
    mov ecx, DWORD PTR arm_x9
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _wfm_next
    cmp BYTE PTR arm_z, 0
    je _wfm_next
    ; add     x6, x6, #1
    mov rax, QWORD PTR arm_x6
    add rax, 1
    mov QWORD PTR arm_x6, rax
    ; b       _wfm_i
    jmp _wfm_i
_wfm_next:
    ; add     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; b       _wfm_start
    jmp _wfm_start
_wfm_no:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_wfm_yes:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_print_wid_name:
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
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
    ; lea x1, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x1, rax
    ; cmp     x19, x1
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _pwn_scan
    cmp BYTE PTR arm_z, 0
    je _pwn_scan
    ; lea x0, str_forth_name
    lea rax, str_forth_name
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_61
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_61:
    ; b       _pwn_done
    jmp _pwn_done
_pwn_scan:
    ; lea x22, DODOES
    lea rax, DODOES
    mov QWORD PTR arm_x22, rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
_pwn_thread:
    ; cmp     x20, #16
    mov rax, QWORD PTR arm_x20
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _pwn_anon
    cmp BYTE PTR arm_c, 0
    jne _pwn_anon
    ; lea x0, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x0, rax
    ; add     x0, x0, x20, lsl #3
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; ldr     x21, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
_pwn_cfa:
    ; cbz     x21, _pwn_next_th
    mov rax, QWORD PTR arm_x21
    cmp rax, 0
    je _pwn_next_th
    ; ldr     x0, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x0, x22
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x22
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _pwn_link
    cmp BYTE PTR arm_z, 0
    je _pwn_link
    ; add     x0, x21, #16
    mov rax, QWORD PTR arm_x21
    add rax, 10h
    mov QWORD PTR arm_x0, rax
    ; cmp     x0, x19
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x19
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _pwn_link
    cmp BYTE PTR arm_z, 0
    je _pwn_link
    ; ldr     x0, [x21, #-8]
    mov r10, QWORD PTR arm_x21
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; and     x0, x0, #0xFFFF
    mov rax, QWORD PTR arm_x0
    and rax, 0FFFFh
    mov QWORD PTR arm_x0, rax
    ; sub     x0, x21, x0
    mov rax, QWORD PTR arm_x21
    mov rcx, QWORD PTR arm_x0
    sub rax, rcx
    mov QWORD PTR arm_x0, rax
    ; ldrb    w1, [x0], #1
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w1, w1, #0x7F
    mov eax, DWORD PTR arm_x1
    and eax, 7Fh
    mov QWORD PTR arm_x1, rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; mov     x21, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x21, rax
    ; mov     x22, #0
    mov rax, 0
    mov QWORD PTR arm_x22, rax
_pwn_ch:
    ; cmp     x22, x21
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x21
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _pwn_done
    cmp BYTE PTR arm_c, 0
    jne _pwn_done
    ; ldrb    w0, [x20, x22]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR arm_x22
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_62
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_62:
    ; add     x22, x22, #1
    mov rax, QWORD PTR arm_x22
    add rax, 1
    mov QWORD PTR arm_x22, rax
    ; b       _pwn_ch
    jmp _pwn_ch
_pwn_link:
    ; ldr     x21, [x21, #-16]
    mov r10, QWORD PTR arm_x21
    add r10, -16
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    ; b       _pwn_cfa
    jmp _pwn_cfa
_pwn_next_th:
    ; add     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    add rax, 1
    mov QWORD PTR arm_x20, rax
    ; b       _pwn_thread
    jmp _pwn_thread
_pwn_anon:
    ; lea x0, str_wid
    lea rax, str_wid
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_63
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_63:
_pwn_done:
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
str_forth_name:
    ; DCB "FORTH", 0
    DB "FORTH", 0
str_wid:
    ; DCB "wid", 0
    DB "wid", 0
str_words_hdr1:
    ; DCB "--- ", 0
    DB "--- ", 0
str_words_hdr2:
    ; DCB " ---", 0
    DB " ---", 0
str_words_sys:
    ; DCB "EditForthWin System Words", 10, 0
    DB "EditForthWin System Words", 0Ah, 0
str_words_user:
    ; DCB "EditForthWin User Words", 10, 0
    DB "EditForthWin User Words", 0Ah, 0
END
