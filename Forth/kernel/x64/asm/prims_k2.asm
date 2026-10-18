; Generated from Forth/kernel/arm64/prims_k2.asm. Do not edit.
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
EXTRN XROLL:PROC
EXTRN XTYPE:PROC
EXTRN _arm_lines:PROC
EXTRN _compile_cell:PROC
EXTRN _cursor_commit:PROC
EXTRN _cursor_load:PROC
EXTRN _do_quit:PROC
EXTRN _eval_resume_push:PROC
EXTRN _file_op_call:PROC
EXTRN _find_word:PROC
EXTRN _float_op_call:PROC
EXTRN _getchar:PROC
EXTRN _interpret_empty:PROC
EXTRN _interpret_loop:PROC
EXTRN _local_add_name:PROC
EXTRN _local_compile_reset:PROC
EXTRN _local_finalize_compile:PROC
EXTRN _local_lookup:PROC
EXTRN _next_word:PROC
EXTRN _push_source:PROC
EXTRN _putchar:PROC
EXTRN _quit_exit:PROC
EXTRN _sa_print_unsigned:PROC
EXTRN _sa_putchar:PROC
EXTRN _take_line:PROC
EXTRN _view_push_src_id:PROC
EXTRN _view_set_src_from_pending:PROC
EXTRN base_var:BYTE
EXTRN blk_var:BYTE
EXTRN block_buf:BYTE
EXTRN block_file:BYTE
EXTRN block_nr:BYTE
EXTRN block_upd:BYTE
EXTRN bootptr_end:BYTE
EXTRN bootptr_start:BYTE
EXTRN catch_ok_cell:BYTE
EXTRN cfa_comma:BYTE
EXTRN cfa_execute:BYTE
EXTRN cfa_exit:BYTE
EXTRN cfa_flit:BYTE
EXTRN cfa_lit:BYTE
EXTRN cfa_local_store:BYTE
EXTRN cfa_slit:BYTE
EXTRN current_var:BYTE
EXTRN data_stack:BYTE
EXTRN debug_break_asap:BYTE
EXTRN debug_busy:BYTE
EXTRN emit_cstr:PROC
EXTRN emit_str:PROC
EXTRN eval_resume_sp:BYTE
EXTRN facility_op_hook:BYTE
EXTRN file_echo:BYTE
EXTRN forget_cut:BYTE
EXTRN grow_memory_used:BYTE
EXTRN here_ptr:BYTE
EXTRN host_accept:PROC
EXTRN host_alloc:PROC
EXTRN host_alloc_exec:PROC
EXTRN host_begin_load:PROC
EXTRN host_bi_divmod:PROC
EXTRN host_bi_isqrt:PROC
EXTRN host_bi_mul:PROC
EXTRN host_chdir:PROC
EXTRN host_clip_get:PROC
EXTRN host_clip_set:PROC
EXTRN host_cwd:PROC
EXTRN host_dir:PROC
EXTRN host_dot_included:PROC
EXTRN host_edit:PROC
EXTRN host_edit_at:PROC
EXTRN host_end_load:PROC
EXTRN host_facility_xy:PROC
EXTRN host_free:PROC
EXTRN host_free_exec:PROC
EXTRN host_fromlib:PROC
EXTRN host_fromlib_off:PROC
EXTRN host_fromlib_query:PROC
EXTRN host_icache_inval:PROC
EXTRN host_include_dialog:PROC
EXTRN host_last_included:PROC
EXTRN host_library_path:PROC
EXTRN host_mprotect:PROC
EXTRN host_ms:PROC
EXTRN host_native_ret7:PROC
EXTRN host_pwd:PROC
EXTRN host_read:PROC
EXTRN host_register:PROC
EXTRN host_repos:PROC
EXTRN host_resize:PROC
EXTRN host_resolve:PROC
EXTRN host_sleep:PROC
EXTRN host_system:PROC
EXTRN host_time_date:PROC
EXTRN host_was_included:PROC
EXTRN include_name_len:BYTE
EXTRN include_name_pending:BYTE
EXTRN jit_exec_mode:BYTE
EXTRN key_fn:BYTE
EXTRN latest_var:BYTE
EXTRN library_path_buf:BYTE
EXTRN line_limit:BYTE
EXTRN line_mode:BYTE
EXTRN line_next:BYTE
EXTRN local_declaring:BYTE
EXTRN local_init_count:BYTE
EXTRN local_init_reverse:BYTE
EXTRN msg_allot:BYTE
EXTRN msg_huh:BYTE
EXTRN native_dsp_end:BYTE
EXTRN next_debug:PROC
EXTRN pad_buffer:BYTE
EXTRN redef_warn:BYTE
EXTRN resolve_buf:BYTE
EXTRN scr_var:BYTE
EXTRN search_order:BYTE
EXTRN search_order_n:BYTE
EXTRN source_base:BYTE
EXTRN source_cur:BYTE
EXTRN source_end:BYTE
EXTRN source_id:BYTE
EXTRN source_sp:BYTE
EXTRN state_var:BYTE
EXTRN throw_handler:BYTE
EXTRN to_in:BYTE
EXTRN tw_continue_cell:BYTE
EXTRN user_dict_area:BYTE
EXTRN user_dict_size_cell:BYTE
EXTRN wordlist_reg:BYTE
EXTRN wordlist_reg_n:BYTE
EXTRN words_user_base:BYTE
.CODE
PUBLIC XCATCH
PUBLIC XCATCH_OK
PUBLIC XTW_CONTINUE
PUBLIC XEXECUTE
PUBLIC _udivmod128
BWSTR SEGMENT ALIGN(1) READ
nm_XTUCK:
    ; DCB "TUCK", 0
    DB "TUCK", 0
hl_XTUCK:
    ; DCB "TUCK ( x1 x2 -- x2 x1 x2 ) copy TOS under the second", 0
    DB "TUCK ( x1 x2 -- x2 x1 x2 ) copy TOS under the second", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTUCK:
    ; DCQ     nm_XTUCK, hl_XTUCK
    DQ OFFSET nm_XTUCK, OFFSET hl_XTUCK
    ; DCQ     0
    DQ 0
    ; DCQ     XTUCK, XTUCK_END
    DQ OFFSET XTUCK, OFFSET XTUCK_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTUCK
    DQ OFFSET row_XTUCK
BOOTPTR ENDS
.CODE
XTUCK:
    ; ldr     x0, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x22]
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
XTUCK_END:
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
nm_XPICK:
    ; DCB "PICK", 0
    DB "PICK", 0
hl_XPICK:
    ; DCB "PICK ( xu ... x0 u -- xu ... x0 xu ) copy the uth cell", 0
    DB "PICK ( xu ... x0 u -- xu ... x0 xu ) copy the uth cell", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPICK:
    ; DCQ     nm_XPICK, hl_XPICK
    DQ OFFSET nm_XPICK, OFFSET hl_XPICK
    ; DCQ     0
    DQ 0
    ; DCQ     XPICK, XPICK_END
    DQ OFFSET XPICK, OFFSET XPICK_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPICK
    DQ OFFSET row_XPICK
BOOTPTR ENDS
.CODE
XPICK:
    ; lsl     x0, x20, #3
    mov rax, QWORD PTR arm_x20
    shl rax, 3
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x22, x0]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XPICK_END:
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
nm_X2TOR:
    ; DCB "2>R", 0
    DB "2>R", 0
hl_X2TOR:
    ; DCB "2>R ( n1 n2 -- ) two to the return stack", 0
    DB "2>R ( n1 n2 -- ) two to the return stack", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_X2TOR:
    ; DCQ     nm_X2TOR, hl_X2TOR
    DQ OFFSET nm_X2TOR, OFFSET hl_X2TOR
    ; DCQ     0
    DQ 0
    ; DCQ     X2TOR, X2TOR_END
    DQ OFFSET X2TOR, OFFSET X2TOR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_X2TOR
    DQ OFFSET row_X2TOR
BOOTPTR ENDS
.CODE
X2TOR:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; str     x0, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; str     x20, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
X2TOR_END:
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
nm_X2RTO:
    ; DCB "2R>", 0
    DB "2R>", 0
hl_X2RTO:
    ; DCB "2R> ( -- n1 n2 ) two from the return stack", 0
    DB "2R> ( -- n1 n2 ) two from the return stack", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_X2RTO:
    ; DCQ     nm_X2RTO, hl_X2RTO
    DQ OFFSET nm_X2RTO, OFFSET hl_X2RTO
    ; DCQ     0
    DQ 0
    ; DCQ     X2RTO, X2RTO_END
    DQ OFFSET X2RTO, OFFSET X2RTO_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_X2RTO
    DQ OFFSET row_X2RTO
BOOTPTR ENDS
.CODE
X2RTO:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x0, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; ldr     x1, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
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
X2RTO_END:
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
nm_X2RFETCH:
    ; DCB "2R@", 0
    DB "2R@", 0
hl_X2RFETCH:
    ; DCB "2R@ ( -- n1 n2 ) copy two from the return stack", 0
    DB "2R@ ( -- n1 n2 ) copy two from the return stack", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_X2RFETCH:
    ; DCQ     nm_X2RFETCH, hl_X2RFETCH
    DQ OFFSET nm_X2RFETCH, OFFSET hl_X2RFETCH
    ; DCQ     0
    DQ 0
    ; DCQ     X2RFETCH, X2RFETCH_END
    DQ OFFSET X2RFETCH, OFFSET X2RFETCH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_X2RFETCH
    DQ OFFSET row_X2RFETCH
BOOTPTR ENDS
.CODE
X2RFETCH:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x0, [x23]
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x23, #8]
    mov r10, QWORD PTR arm_x23
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
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
X2RFETCH_END:
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
nm_XTWOROT:
    ; DCB "2ROT", 0
    DB "2ROT", 0
hl_XTWOROT:
    ; DCB "2ROT ( x1 x2 x3 x4 x5 x6 -- x3 x4 x5 x6 x1 x2 ) rotate three pairs", 0
    DB "2ROT ( x1 x2 x3 x4 x5 x6 -- x3 x4 x5 x6 x1 x2 ) rotate three pairs", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTWOROT:
    ; DCQ     nm_XTWOROT, hl_XTWOROT
    DQ OFFSET nm_XTWOROT, OFFSET hl_XTWOROT
    ; DCQ     0
    DQ 0
    ; DCQ     XTWOROT, XTWOROT_END
    DQ OFFSET XTWOROT, OFFSET XTWOROT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTWOROT
    DQ OFFSET row_XTWOROT
BOOTPTR ENDS
.CODE
XTWOROT:
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
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
    ; str     x3, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; str     x4, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10], rax
    ; str     x5, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10], rax
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
    ; mov     x20, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x20, rax
XTWOROT_END:
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
nm_XONEMINUS:
    ; DCB "1-", 0
    DB "1-", 0
hl_XONEMINUS:
    ; DCB "1- ( n -- n-1 ) decrement", 0
    DB "1- ( n -- n-1 ) decrement", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XONEMINUS:
    ; DCQ     nm_XONEMINUS, hl_XONEMINUS
    DQ OFFSET nm_XONEMINUS, OFFSET hl_XONEMINUS
    ; DCQ     0
    DQ 0
    ; DCQ     XONEMINUS, XONEMINUS_END
    DQ OFFSET XONEMINUS, OFFSET XONEMINUS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XONEMINUS
    DQ OFFSET row_XONEMINUS
BOOTPTR ENDS
.CODE
XONEMINUS:
    ; sub     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    sub rax, 1
    mov QWORD PTR arm_x20, rax
XONEMINUS_END:
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
nm_XNEGATE:
    ; DCB "NEGATE", 0
    DB "NEGATE", 0
hl_XNEGATE:
    ; DCB "NEGATE ( n -- -n ) negate", 0
    DB "NEGATE ( n -- -n ) negate", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XNEGATE:
    ; DCQ     nm_XNEGATE, hl_XNEGATE
    DQ OFFSET nm_XNEGATE, OFFSET hl_XNEGATE
    ; DCQ     0
    DQ 0
    ; DCQ     XNEGATE, XNEGATE_END
    DQ OFFSET XNEGATE, OFFSET XNEGATE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XNEGATE
    DQ OFFSET row_XNEGATE
BOOTPTR ENDS
.CODE
XNEGATE:
    ; neg     x20, x20
    mov rax, QWORD PTR arm_x20
    neg rax
    mov QWORD PTR arm_x20, rax
XNEGATE_END:
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
nm_XABS:
    ; DCB "ABS", 0
    DB "ABS", 0
hl_XABS:
    ; DCB "ABS ( n -- u ) absolute value", 0
    DB "ABS ( n -- u ) absolute value", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XABS:
    ; DCQ     nm_XABS, hl_XABS
    DQ OFFSET nm_XABS, OFFSET hl_XABS
    ; DCQ     0
    DQ 0
    ; DCQ     XABS, XABS_END
    DQ OFFSET XABS, OFFSET XABS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XABS
    DQ OFFSET row_XABS
BOOTPTR ENDS
.CODE
XABS:
    ; cmp     x20, #0
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csneg   x20, x20, x20, ge
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je xsk_1
    mov rax, QWORD PTR arm_x20
    neg rax
    jmp xsk_2
    xsk_1:
    mov rax, QWORD PTR arm_x20
    xsk_2:
    mov QWORD PTR arm_x20, rax
XABS_END:
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
nm_XMIN:
    ; DCB "MIN", 0
    DB "MIN", 0
hl_XMIN:
    ; DCB "MIN ( n1 n2 -- min ) minimum", 0
    DB "MIN ( n1 n2 -- min ) minimum", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMIN:
    ; DCQ     nm_XMIN, hl_XMIN
    DQ OFFSET nm_XMIN, OFFSET hl_XMIN
    ; DCQ     0
    DQ 0
    ; DCQ     XMIN, XMIN_END
    DQ OFFSET XMIN, OFFSET XMIN_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMIN
    DQ OFFSET row_XMIN
BOOTPTR ENDS
.CODE
XMIN:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cmp     x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csel    x20, x0, x20, lt
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne xsk_3
    mov rax, QWORD PTR arm_x20
    jmp xsk_4
    xsk_3:
    mov rax, QWORD PTR arm_x0
    xsk_4:
    mov QWORD PTR arm_x20, rax
XMIN_END:
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
nm_XMAX:
    ; DCB "MAX", 0
    DB "MAX", 0
hl_XMAX:
    ; DCB "MAX ( n1 n2 -- max ) maximum", 0
    DB "MAX ( n1 n2 -- max ) maximum", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMAX:
    ; DCQ     nm_XMAX, hl_XMAX
    DQ OFFSET nm_XMAX, OFFSET hl_XMAX
    ; DCQ     0
    DQ 0
    ; DCQ     XMAX, XMAX_END
    DQ OFFSET XMAX, OFFSET XMAX_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMAX
    DQ OFFSET row_XMAX
BOOTPTR ENDS
.CODE
XMAX:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cmp     x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csel    x20, x0, x20, gt
    cmp BYTE PTR arm_z, 0
    jne xsk_7
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je xsk_5
    xsk_7:
    mov rax, QWORD PTR arm_x20
    jmp xsk_6
    xsk_5:
    mov rax, QWORD PTR arm_x0
    xsk_6:
    mov QWORD PTR arm_x20, rax
XMAX_END:
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
nm_XXOR:
    ; DCB "XOR", 0
    DB "XOR", 0
hl_XXOR:
    ; DCB "XOR ( n1 n2 -- n ) bitwise xor", 0
    DB "XOR ( n1 n2 -- n ) bitwise xor", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XXOR:
    ; DCQ     nm_XXOR, hl_XXOR
    DQ OFFSET nm_XXOR, OFFSET hl_XXOR
    ; DCQ     0
    DQ 0
    ; DCQ     XXOR, XXOR_END
    DQ OFFSET XXOR, OFFSET XXOR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XXOR
    DQ OFFSET row_XXOR
BOOTPTR ENDS
.CODE
XXOR:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; eor     x20, x20, x0
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x0
    xor rax, rcx
    mov QWORD PTR arm_x20, rax
XXOR_END:
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
nm_XLSHIFT:
    ; DCB "LSHIFT", 0
    DB "LSHIFT", 0
hl_XLSHIFT:
    ; DCB "LSHIFT ( n bits -- n ) logical left shift", 0
    DB "LSHIFT ( n bits -- n ) logical left shift", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLSHIFT:
    ; DCQ     nm_XLSHIFT, hl_XLSHIFT
    DQ OFFSET nm_XLSHIFT, OFFSET hl_XLSHIFT
    ; DCQ     0
    DQ 0
    ; DCQ     XLSHIFT, XLSHIFT_END
    DQ OFFSET XLSHIFT, OFFSET XLSHIFT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLSHIFT
    DQ OFFSET row_XLSHIFT
BOOTPTR ENDS
.CODE
XLSHIFT:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; lsl     x20, x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    shl rax, cl
    mov QWORD PTR arm_x20, rax
XLSHIFT_END:
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
nm_XNEQUAL:
    ; DCB "<>", 0
    DB "<>", 0
hl_XNEQUAL:
    ; DCB "<> ( n1 n2 -- flag ) not equal", 0
    DB "<> ( n1 n2 -- flag ) not equal", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XNEQUAL:
    ; DCQ     nm_XNEQUAL, hl_XNEQUAL
    DQ OFFSET nm_XNEQUAL, OFFSET hl_XNEQUAL
    ; DCQ     0
    DQ 0
    ; DCQ     XNEQUAL, XNEQUAL_END
    DQ OFFSET XNEQUAL, OFFSET XNEQUAL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XNEQUAL
    DQ OFFSET row_XNEQUAL
BOOTPTR ENDS
.CODE
XNEQUAL:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cmp     x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, ne
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    jne xsk_8
    mov rax, -1
    xsk_8:
    mov QWORD PTR arm_x20, rax
XNEQUAL_END:
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
nm_XULESS:
    ; DCB "U<", 0
    DB "U<", 0
hl_XULESS:
    ; DCB "U< ( u1 u2 -- flag ) unsigned less", 0
    DB "U< ( u1 u2 -- flag ) unsigned less", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XULESS:
    ; DCQ     nm_XULESS, hl_XULESS
    DQ OFFSET nm_XULESS, OFFSET hl_XULESS
    ; DCQ     0
    DQ 0
    ; DCQ     XULESS, XULESS_END
    DQ OFFSET XULESS, OFFSET XULESS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XULESS
    DQ OFFSET row_XULESS
BOOTPTR ENDS
.CODE
XULESS:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cmp     x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, lo
    xor eax, eax
    cmp BYTE PTR arm_c, 0
    jne xsk_9
    mov rax, -1
    xsk_9:
    mov QWORD PTR arm_x20, rax
XULESS_END:
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
nm_XUGREATER:
    ; DCB "U>", 0
    DB "U>", 0
hl_XUGREATER:
    ; DCB "U> ( u1 u2 -- flag ) unsigned greater", 0
    DB "U> ( u1 u2 -- flag ) unsigned greater", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XUGREATER:
    ; DCQ     nm_XUGREATER, hl_XUGREATER
    DQ OFFSET nm_XUGREATER, OFFSET hl_XUGREATER
    ; DCQ     0
    DQ 0
    ; DCQ     XUGREATER, XUGREATER_END
    DQ OFFSET XUGREATER, OFFSET XUGREATER_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XUGREATER
    DQ OFFSET row_XUGREATER
BOOTPTR ENDS
.CODE
XUGREATER:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cmp     x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, hi
    xor eax, eax
    cmp BYTE PTR arm_c, 0
    je xsk_10
    cmp BYTE PTR arm_z, 0
    jne xsk_10
    mov rax, -1
    xsk_10:
    mov QWORD PTR arm_x20, rax
XUGREATER_END:
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
nm_XZLESS:
    ; DCB "0<", 0
    DB "0<", 0
hl_XZLESS:
    ; DCB "0< ( n -- flag ) negative?", 0
    DB "0< ( n -- flag ) negative?", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XZLESS:
    ; DCQ     nm_XZLESS, hl_XZLESS
    DQ OFFSET nm_XZLESS, OFFSET hl_XZLESS
    ; DCQ     0
    DQ 0
    ; DCQ     XZLESS, XZLESS_END
    DQ OFFSET XZLESS, OFFSET XZLESS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XZLESS
    DQ OFFSET row_XZLESS
BOOTPTR ENDS
.CODE
XZLESS:
    ; cmp     x20, #0
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, lt
    xor eax, eax
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je xsk_11
    mov rax, -1
    xsk_11:
    mov QWORD PTR arm_x20, rax
XZLESS_END:
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
nm_XZNOTEQUAL:
    ; DCB "0<>", 0
    DB "0<>", 0
hl_XZNOTEQUAL:
    ; DCB "0<> ( x -- flag ) not zero?", 0
    DB "0<> ( x -- flag ) not zero?", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XZNOTEQUAL:
    ; DCQ     nm_XZNOTEQUAL, hl_XZNOTEQUAL
    DQ OFFSET nm_XZNOTEQUAL, OFFSET hl_XZNOTEQUAL
    ; DCQ     0
    DQ 0
    ; DCQ     XZNOTEQUAL, XZNOTEQUAL_END
    DQ OFFSET XZNOTEQUAL, OFFSET XZNOTEQUAL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XZNOTEQUAL
    DQ OFFSET row_XZNOTEQUAL
BOOTPTR ENDS
.CODE
XZNOTEQUAL:
    ; cmp     x20, #0
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, ne
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    jne xsk_12
    mov rax, -1
    xsk_12:
    mov QWORD PTR arm_x20, rax
XZNOTEQUAL_END:
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
nm_XZGREATER:
    ; DCB "0>", 0
    DB "0>", 0
hl_XZGREATER:
    ; DCB "0> ( n -- flag ) positive?", 0
    DB "0> ( n -- flag ) positive?", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XZGREATER:
    ; DCQ     nm_XZGREATER, hl_XZGREATER
    DQ OFFSET nm_XZGREATER, OFFSET hl_XZGREATER
    ; DCQ     0
    DQ 0
    ; DCQ     XZGREATER, XZGREATER_END
    DQ OFFSET XZGREATER, OFFSET XZGREATER_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XZGREATER
    DQ OFFSET row_XZGREATER
BOOTPTR ENDS
.CODE
XZGREATER:
    ; cmp     x20, #0
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, gt
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    jne xsk_13
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne xsk_13
    mov rax, -1
    xsk_13:
    mov QWORD PTR arm_x20, rax
XZGREATER_END:
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
nm_XWITHIN:
    ; DCB "WITHIN", 0
    DB "WITHIN", 0
hl_XWITHIN:
    ; DCB "WITHIN ( n1 n2 n3 -- flag ) n2 <= n1 < n3 with unsigned wrap", 0
    DB "WITHIN ( n1 n2 n3 -- flag ) n2 <= n1 < n3 with unsigned wrap", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XWITHIN:
    ; DCQ     nm_XWITHIN, hl_XWITHIN
    DQ OFFSET nm_XWITHIN, OFFSET hl_XWITHIN
    ; DCQ     0
    DQ 0
    ; DCQ     XWITHIN, XWITHIN_END
    DQ OFFSET XWITHIN, OFFSET XWITHIN_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XWITHIN
    DQ OFFSET row_XWITHIN
BOOTPTR ENDS
.CODE
XWITHIN:
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
    ; sub     x1, x1, x2
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x2
    sub rax, rcx
    mov QWORD PTR arm_x1, rax
    ; sub     x20, x20, x2
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x2
    sub rax, rcx
    mov QWORD PTR arm_x20, rax
    ; cmp     x1, x20
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, lo
    xor eax, eax
    cmp BYTE PTR arm_c, 0
    jne xsk_14
    mov rax, -1
    xsk_14:
    mov QWORD PTR arm_x20, rax
XWITHIN_END:
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
nm_XTRUE:
    ; DCB "TRUE", 0
    DB "TRUE", 0
hl_XTRUE:
    ; DCB "TRUE ( -- -1 ) true flag", 0
    DB "TRUE ( -- -1 ) true flag", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTRUE:
    ; DCQ     nm_XTRUE, hl_XTRUE
    DQ OFFSET nm_XTRUE, OFFSET hl_XTRUE
    ; DCQ     0
    DQ 0
    ; DCQ     XTRUE, XTRUE_END
    DQ OFFSET XTRUE, OFFSET XTRUE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTRUE
    DQ OFFSET row_XTRUE
BOOTPTR ENDS
.CODE
XTRUE:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, #-1
    mov rax, -1
    mov QWORD PTR arm_x20, rax
XTRUE_END:
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
nm_XFALSE:
    ; DCB "FALSE", 0
    DB "FALSE", 0
hl_XFALSE:
    ; DCB "FALSE ( -- 0 ) false flag", 0
    DB "FALSE ( -- 0 ) false flag", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFALSE:
    ; DCQ     nm_XFALSE, hl_XFALSE
    DQ OFFSET nm_XFALSE, OFFSET hl_XFALSE
    ; DCQ     0
    DQ 0
    ; DCQ     XFALSE, XFALSE_END
    DQ OFFSET XFALSE, OFFSET XFALSE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFALSE
    DQ OFFSET row_XFALSE
BOOTPTR ENDS
.CODE
XFALSE:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XFALSE_END:
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
nm_XPLUSSTORE:
    ; DCB "+!", 0
    DB "+!", 0
hl_XPLUSSTORE:
    ; DCB "+! ( n addr -- ) add to memory", 0
    DB "+! ( n addr -- ) add to memory", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPLUSSTORE:
    ; DCQ     nm_XPLUSSTORE, hl_XPLUSSTORE
    DQ OFFSET nm_XPLUSSTORE, OFFSET hl_XPLUSSTORE
    ; DCQ     0
    DQ 0
    ; DCQ     XPLUSSTORE, XPLUSSTORE_END
    DQ OFFSET XPLUSSTORE, OFFSET XPLUSSTORE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPLUSSTORE
    DQ OFFSET row_XPLUSSTORE
BOOTPTR ENDS
.CODE
XPLUSSTORE:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x1, [x20]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; add     x1, x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    add rax, rcx
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x20]
    mov r10, QWORD PTR arm_x20
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
XPLUSSTORE_END:
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
nm_XPAD:
    ; DCB "PAD", 0
    DB "PAD", 0
hl_XPAD:
    ; DCB "PAD ( -- addr ) transient scratch of 1024 bytes", 0
    DB "PAD ( -- addr ) transient scratch of 1024 bytes", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPAD:
    ; DCQ     nm_XPAD, hl_XPAD
    DQ OFFSET nm_XPAD, OFFSET hl_XPAD
    ; DCQ     0
    DQ 0
    ; DCQ     XPAD, XPAD_END
    DQ OFFSET XPAD, OFFSET XPAD_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPAD
    DQ OFFSET row_XPAD
BOOTPTR ENDS
.CODE
XPAD:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, pad_buffer
    lea rax, pad_buffer
    mov QWORD PTR arm_x0, rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XPAD_END:
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
nm_XUNUSED:
    ; DCB "UNUSED", 0
    DB "UNUSED", 0
hl_XUNUSED:
    ; DCB "UNUSED ( -- u ) bytes from HERE to the dictionary end", 0
    DB "UNUSED ( -- u ) bytes from HERE to the dictionary end", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XUNUSED:
    ; DCQ     nm_XUNUSED, hl_XUNUSED
    DQ OFFSET nm_XUNUSED, OFFSET hl_XUNUSED
    ; DCQ     0
    DQ 0
    ; DCQ     XUNUSED, XUNUSED_END
    DQ OFFSET XUNUSED, OFFSET XUNUSED_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XUNUSED
    DQ OFFSET row_XUNUSED
BOOTPTR ENDS
.CODE
XUNUSED:
    ; lea x0, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x0, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR arm_x0, rax
    ; lea x2, user_dict_size_cell
    lea rax, user_dict_size_cell
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; add     x0, x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; subs    x0, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    sub rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x0, rax
    ; b.hs    _unused_ok
    cmp BYTE PTR arm_c, 0
    jne _unused_ok
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
_unused_ok:
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
XUNUSED_END:
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
nm_XUSER_DICT:
    ; DCB "USER-DICT", 0
    DB "USER-DICT", 0
hl_XUSER_DICT:
    ; DCB "USER-DICT ( -- addr ) base of user dictionary", 0
    DB "USER-DICT ( -- addr ) base of user dictionary", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XUSER_DICT:
    ; DCQ     nm_XUSER_DICT, hl_XUSER_DICT
    DQ OFFSET nm_XUSER_DICT, OFFSET hl_XUSER_DICT
    ; DCQ     0
    DQ 0
    ; DCQ     XUSER_DICT, 0
    DQ OFFSET XUSER_DICT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XUSER_DICT
    DQ OFFSET row_XUSER_DICT
BOOTPTR ENDS
.CODE
XUSER_DICT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR arm_x0, rax
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
nm_XGROWMEMORYMB:
    ; DCB "GROWMEMORYMB", 0
    DB "GROWMEMORYMB", 0
hl_XGROWMEMORYMB:
    ; DCB "GROWMEMORYMB ( n -- ) grow user dictionary to n MiB once per session with no shrink and a max of 256", 0
    DB "GROWMEMORYMB ( n -- ) grow user dictionary to n MiB once per session with no shrink and a max of 256", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XGROWMEMORYMB:
    ; DCQ     nm_XGROWMEMORYMB, hl_XGROWMEMORYMB
    DQ OFFSET nm_XGROWMEMORYMB, OFFSET hl_XGROWMEMORYMB
    ; DCQ     0
    DQ 0
    ; DCQ     XGROWMEMORYMB, 0
    DQ OFFSET XGROWMEMORYMB, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XGROWMEMORYMB
    DQ OFFSET row_XGROWMEMORYMB
BOOTPTR ENDS
.CODE
XGROWMEMORYMB:
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
    ; lea x1, grow_memory_used
    lea rax, grow_memory_used
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbnz    x2, _gmm_already
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    jne _gmm_already
    ; cmp     x0, #1
    mov rax, QWORD PTR arm_x0
    cmp rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lt    _gmm_small
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne _gmm_small
    ; cmp     x0, #256
    mov rax, QWORD PTR arm_x0
    cmp rax, 100h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _gmm_big
    cmp BYTE PTR arm_c, 0
    je xsk_15
    cmp BYTE PTR arm_z, 0
    je _gmm_big
    xsk_15:
    ; lsl     x3, x0, #20
    mov rax, QWORD PTR arm_x0
    shl rax, 20
    mov QWORD PTR arm_x3, rax
    ; lea x4, user_dict_size_cell
    lea rax, user_dict_size_cell
    mov QWORD PTR arm_x4, rax
    ; ldr     x5, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; cmp     x3, x5
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _gmm_shrink
    cmp BYTE PTR arm_c, 0
    je _gmm_shrink
    cmp BYTE PTR arm_z, 0
    jne _gmm_shrink
    ; str     x3, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; mov     x2, #1
    mov rax, 1
    mov QWORD PTR arm_x2, rax
    ; str     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x2
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
_gmm_already:
    ; lea x0, str_gmm_already
    lea rax, str_gmm_already
    mov QWORD PTR arm_x0, rax
    ; b       _gmm_fail
    jmp _gmm_fail
_gmm_small:
    ; lea x0, str_gmm_small
    lea rax, str_gmm_small
    mov QWORD PTR arm_x0, rax
    ; b       _gmm_fail
    jmp _gmm_fail
_gmm_big:
    ; lea x0, str_gmm_big
    lea rax, str_gmm_big
    mov QWORD PTR arm_x0, rax
    ; b       _gmm_fail
    jmp _gmm_fail
_gmm_shrink:
    ; lea x0, str_gmm_shrink
    lea rax, str_gmm_shrink
    mov QWORD PTR arm_x0, rax
_gmm_fail:
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
    ; bl      emit_cstr
    lea rax, xret_16
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_16:
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
    ; b       _quit_exit
    jmp _quit_exit
BWSTR SEGMENT ALIGN(1) READ
nm_XCCOMMA:
    ; DCB "C", 0x2C, 0
    DB "C", 2Ch, 0
hl_XCCOMMA:
    ; DCB "C", 0x2C, "( b -- ) compile a byte", 0
    DB "C", 2Ch, "( b -- ) compile a byte", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCCOMMA:
    ; DCQ     nm_XCCOMMA, hl_XCCOMMA
    DQ OFFSET nm_XCCOMMA, OFFSET hl_XCCOMMA
    ; DCQ     0
    DQ 0
    ; DCQ     XCCOMMA, 0
    DQ OFFSET XCCOMMA, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCCOMMA
    DQ OFFSET row_XCCOMMA
BOOTPTR ENDS
.CODE
XCCOMMA:
    ; mov     w0, w20
    mov eax, DWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; lea x1, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; add     x3, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; lea x4, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR arm_x4, rax
    ; cmp     x3, x4
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x4
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _ccomma_fail
    cmp BYTE PTR arm_c, 0
    je _ccomma_fail
    ; lea x5, user_dict_size_cell
    lea rax, user_dict_size_cell
    mov QWORD PTR arm_x5, rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR arm_x5
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; add     x5, x4, x5
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x5
    add rax, rcx
    mov QWORD PTR arm_x5, rax
    ; cmp     x3, x5
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _ccomma_fail
    cmp BYTE PTR arm_c, 0
    je xsk_17
    cmp BYTE PTR arm_z, 0
    je _ccomma_fail
    xsk_17:
    ; strb    w0, [x2]
    mov r10, QWORD PTR arm_x2
    mov eax, DWORD PTR arm_x0
    mov BYTE PTR [r10], al
    ; str     x3, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x3
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
_ccomma_fail:
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
    ; lea x0, msg_allot
    lea rax, msg_allot
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_18
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_18:
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
    ; b       _quit_exit
    jmp _quit_exit
BWSTR SEGMENT ALIGN(1) READ
nm_XTWOFETCH:
    ; DCB "2@", 0
    DB "2@", 0
hl_XTWOFETCH:
    ; DCB "2@ ( addr -- n1 n2 ) fetch two cells", 0
    DB "2@ ( addr -- n1 n2 ) fetch two cells", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTWOFETCH:
    ; DCQ     nm_XTWOFETCH, hl_XTWOFETCH
    DQ OFFSET nm_XTWOFETCH, OFFSET hl_XTWOFETCH
    ; DCQ     0
    DQ 0
    ; DCQ     XTWOFETCH, XTWOFETCH_END
    DQ OFFSET XTWOFETCH, OFFSET XTWOFETCH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTWOFETCH
    DQ OFFSET row_XTWOFETCH
BOOTPTR ENDS
.CODE
XTWOFETCH:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0, #8]
    mov r10, QWORD PTR arm_x0
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; str     x1, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
XTWOFETCH_END:
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
nm_XTWOSTORE:
    ; DCB "2!", 0
    DB "2!", 0
hl_XTWOSTORE:
    ; DCB "2! ( n1 n2 addr -- ) store two cells", 0
    DB "2! ( n1 n2 addr -- ) store two cells", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTWOSTORE:
    ; DCQ     nm_XTWOSTORE, hl_XTWOSTORE
    DQ OFFSET nm_XTWOSTORE, OFFSET hl_XTWOSTORE
    ; DCQ     0
    DQ 0
    ; DCQ     XTWOSTORE, XTWOSTORE_END
    DQ OFFSET XTWOSTORE, OFFSET XTWOSTORE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTWOSTORE
    DQ OFFSET row_XTWOSTORE
BOOTPTR ENDS
.CODE
XTWOSTORE:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
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
    ; str     x2, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; str     x1, [x0, #8]
    mov r10, QWORD PTR arm_x0
    add r10, 8
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
XTWOSTORE_END:
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
nm_XI:
    ; DCB "I", 0
    DB "I", 0
hl_XI:
    ; DCB "I ( -- n ) current DO loop index", 0
    DB "I ( -- n ) current DO loop index", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XI:
    ; DCQ     nm_XI, hl_XI
    DQ OFFSET nm_XI, OFFSET hl_XI
    ; DCQ     0
    DQ 0
    ; DCQ     XI, XI_END
    DQ OFFSET XI, OFFSET XI_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XI
    DQ OFFSET row_XI
BOOTPTR ENDS
.CODE
XI:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x23]
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
XI_END:
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
nm_XJ:
    ; DCB "J", 0
    DB "J", 0
hl_XJ:
    ; DCB "J ( -- n ) outer DO loop index", 0
    DB "J ( -- n ) outer DO loop index", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XJ:
    ; DCQ     nm_XJ, hl_XJ
    DQ OFFSET nm_XJ, OFFSET hl_XJ
    ; DCQ     0
    DQ 0
    ; DCQ     XJ, XJ_END
    DQ OFFSET XJ, OFFSET XJ_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XJ
    DQ OFFSET row_XJ
BOOTPTR ENDS
.CODE
XJ:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x23, #16]
    mov r10, QWORD PTR arm_x23
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
XJ_END:
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
nm_XUNLOOP:
    ; DCB "UNLOOP", 0
    DB "UNLOOP", 0
hl_XUNLOOP:
    ; DCB "UNLOOP ( -- ) discard the current DO loop", 0
    DB "UNLOOP ( -- ) discard the current DO loop", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XUNLOOP:
    ; DCQ     nm_XUNLOOP, hl_XUNLOOP
    DQ OFFSET nm_XUNLOOP, OFFSET hl_XUNLOOP
    ; DCQ     0
    DQ 0
    ; DCQ     XUNLOOP, XUNLOOP_END
    DQ OFFSET XUNLOOP, OFFSET XUNLOOP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XUNLOOP
    DQ OFFSET row_XUNLOOP
BOOTPTR ENDS
.CODE
XUNLOOP:
    ; add     x23, x23, #16
    mov rax, QWORD PTR arm_x23
    add rax, 10h
    mov QWORD PTR arm_x23, rax
XUNLOOP_END:
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
nm_XSLMOD:
    ; DCB "/MOD", 0
    DB "/MOD", 0
hl_XSLMOD:
    ; DCB "/MOD ( n1 n2 -- rem quot ) remainder and quotient", 0
    DB "/MOD ( n1 n2 -- rem quot ) remainder and quotient", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSLMOD:
    ; DCQ     nm_XSLMOD, hl_XSLMOD
    DQ OFFSET nm_XSLMOD, OFFSET hl_XSLMOD
    ; DCQ     0
    DQ 0
    ; DCQ     XSLMOD, XSLMOD_END
    DQ OFFSET XSLMOD, OFFSET XSLMOD_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSLMOD
    DQ OFFSET row_XSLMOD
BOOTPTR ENDS
.CODE
XSLMOD:
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
    je xdiv0_20
    cmp rcx, -1
    jne xdivov_21
    mov r8, 8000000000000000h
    cmp rax, r8
    je xdiv_19
    xdivov_21:
    cqo
    idiv rcx
    jmp xdiv_19
    xdiv0_20:
    xor eax, eax
    xdiv_19:
    mov QWORD PTR arm_x1, rax
    ; msub    x2, x1, x20, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x20
    imul rax, rcx
    mov rcx, QWORD PTR arm_x0
    sub rcx, rax
    mov rax, rcx
    mov QWORD PTR arm_x2, rax
    ; str     x2, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; mov     x20, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x20, rax
XSLMOD_END:
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
nm_XUMSTAR:
    ; DCB "UM*", 0
    DB "UM*", 0
hl_XUMSTAR:
    ; DCB "UM* ( u1 u2 -- ud ) unsigned double multiply", 0
    DB "UM* ( u1 u2 -- ud ) unsigned double multiply", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XUMSTAR:
    ; DCQ     nm_XUMSTAR, hl_XUMSTAR
    DQ OFFSET nm_XUMSTAR, OFFSET hl_XUMSTAR
    ; DCQ     0
    DQ 0
    ; DCQ     XUMSTAR, XUMSTAR_END
    DQ OFFSET XUMSTAR, OFFSET XUMSTAR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XUMSTAR
    DQ OFFSET row_XUMSTAR
BOOTPTR ENDS
.CODE
XUMSTAR:
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
    ; mul     x2, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    imul rax, rcx
    mov QWORD PTR arm_x2, rax
    ; umulh   x20, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    mul rcx
    mov rax, rdx
    mov QWORD PTR arm_x20, rax
    ; str     x2, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
XUMSTAR_END:
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
nm_XMSTAR:
    ; DCB "M*", 0
    DB "M*", 0
hl_XMSTAR:
    ; DCB "M* ( n1 n2 -- d ) signed double multiply", 0
    DB "M* ( n1 n2 -- d ) signed double multiply", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMSTAR:
    ; DCQ     nm_XMSTAR, hl_XMSTAR
    DQ OFFSET nm_XMSTAR, OFFSET hl_XMSTAR
    ; DCQ     0
    DQ 0
    ; DCQ     XMSTAR, XMSTAR_END
    DQ OFFSET XMSTAR, OFFSET XMSTAR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMSTAR
    DQ OFFSET row_XMSTAR
BOOTPTR ENDS
.CODE
XMSTAR:
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
    ; mul     x2, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    imul rax, rcx
    mov QWORD PTR arm_x2, rax
    ; smulh   x20, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    imul rcx
    mov rax, rdx
    mov QWORD PTR arm_x20, rax
    ; str     x2, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
XMSTAR_END:
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
nm_XDPLUS:
    ; DCB "D+", 0
    DB "D+", 0
hl_XDPLUS:
    ; DCB "D+ ( d1 d2 -- d3 ) double add", 0
    DB "D+ ( d1 d2 -- d3 ) double add", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDPLUS:
    ; DCQ     nm_XDPLUS, hl_XDPLUS
    DQ OFFSET nm_XDPLUS, OFFSET hl_XDPLUS
    ; DCQ     0
    DQ 0
    ; DCQ     XDPLUS, XDPLUS_END
    DQ OFFSET XDPLUS, OFFSET XDPLUS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDPLUS
    DQ OFFSET row_XDPLUS
BOOTPTR ENDS
.CODE
XDPLUS:
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
    ; adds    x1, x1, x3
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x3
    add rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    mov QWORD PTR arm_x1, rax
    ; adc     x20, x2, x20
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x20
    mov dl, BYTE PTR arm_c
    add dl, 255
    adc rax, rcx
    mov QWORD PTR arm_x20, rax
    ; str     x1, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
XDPLUS_END:
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
nm_XDNEGATE:
    ; DCB "DNEGATE", 0
    DB "DNEGATE", 0
hl_XDNEGATE:
    ; DCB "DNEGATE ( d1 -- d2 ) negate a double", 0
    DB "DNEGATE ( d1 -- d2 ) negate a double", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDNEGATE:
    ; DCQ     nm_XDNEGATE, hl_XDNEGATE
    DQ OFFSET nm_XDNEGATE, OFFSET hl_XDNEGATE
    ; DCQ     0
    DQ 0
    ; DCQ     XDNEGATE, XDNEGATE_END
    DQ OFFSET XDNEGATE, OFFSET XDNEGATE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDNEGATE
    DQ OFFSET row_XDNEGATE
BOOTPTR ENDS
.CODE
XDNEGATE:
    ; ldr     x1, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; mov     x0, xzr
    xor eax, eax
    mov QWORD PTR arm_x0, rax
    ; subs    x1, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    sub rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x1, rax
    ; sbc     x20, x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    mov dl, BYTE PTR arm_c
    xor dl, 1
    add dl, 255
    sbb rax, rcx
    mov QWORD PTR arm_x20, rax
    ; str     x1, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
XDNEGATE_END:
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
nm_XDABS:
    ; DCB "DABS", 0
    DB "DABS", 0
hl_XDABS:
    ; DCB "DABS ( d -- ud ) absolute value of a double", 0
    DB "DABS ( d -- ud ) absolute value of a double", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDABS:
    ; DCQ     nm_XDABS, hl_XDABS
    DQ OFFSET nm_XDABS, OFFSET hl_XDABS
    ; DCQ     0
    DQ 0
    ; DCQ     XDABS, XDABS_END
    DQ OFFSET XDABS, OFFSET XDABS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDABS
    DQ OFFSET row_XDABS
BOOTPTR ENDS
.CODE
XDABS:
    ; tbnz    x20, #63, _dabs_neg
    mov rax, QWORD PTR arm_x20
    bt rax, 63
    jc _dabs_neg
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
_dabs_neg:
    ; ldr     x1, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; mov     x0, xzr
    xor eax, eax
    mov QWORD PTR arm_x0, rax
    ; subs    x1, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    sub rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x1, rax
    ; sbc     x20, x0, x20
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x20
    mov dl, BYTE PTR arm_c
    xor dl, 1
    add dl, 255
    sbb rax, rcx
    mov QWORD PTR arm_x20, rax
    ; str     x1, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
XDABS_END:
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
nm_XD0LESS:
    ; DCB "D0<", 0
    DB "D0<", 0
hl_XD0LESS:
    ; DCB "D0< ( d -- flag ) double negative?", 0
    DB "D0< ( d -- flag ) double negative?", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XD0LESS:
    ; DCQ     nm_XD0LESS, hl_XD0LESS
    DQ OFFSET nm_XD0LESS, OFFSET hl_XD0LESS
    ; DCQ     0
    DQ 0
    ; DCQ     XD0LESS, XD0LESS_END
    DQ OFFSET XD0LESS, OFFSET XD0LESS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XD0LESS
    DQ OFFSET row_XD0LESS
BOOTPTR ENDS
.CODE
XD0LESS:
    ; cmp     x20, #0
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, lt
    xor eax, eax
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je xsk_22
    mov rax, -1
    xsk_22:
    mov QWORD PTR arm_x20, rax
    ; add     x22, x22, #8
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
XD0LESS_END:
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
nm_XSTOD:
    ; DCB "S>D", 0
    DB "S>D", 0
hl_XSTOD:
    ; DCB "S>D ( n -- d ) sign extend single to double", 0
    DB "S>D ( n -- d ) sign extend single to double", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSTOD:
    ; DCQ     nm_XSTOD, hl_XSTOD
    DQ OFFSET nm_XSTOD, OFFSET hl_XSTOD
    ; DCQ     0
    DQ 0
    ; DCQ     XSTOD, XSTOD_END
    DQ OFFSET XSTOD, OFFSET XSTOD_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSTOD
    DQ OFFSET row_XSTOD
BOOTPTR ENDS
.CODE
XSTOD:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; asr     x20, x20, #63
    mov rax, QWORD PTR arm_x20
    sar rax, 63
    mov QWORD PTR arm_x20, rax
XSTOD_END:
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
nm_XDMINUS:
    ; DCB "D-", 0
    DB "D-", 0
hl_XDMINUS:
    ; DCB "D- ( d1 d2 -- d3 ) double subtract", 0
    DB "D- ( d1 d2 -- d3 ) double subtract", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDMINUS:
    ; DCQ     nm_XDMINUS, hl_XDMINUS
    DQ OFFSET nm_XDMINUS, OFFSET hl_XDMINUS
    ; DCQ     0
    DQ 0
    ; DCQ     XDMINUS, XDMINUS_END
    DQ OFFSET XDMINUS, OFFSET XDMINUS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDMINUS
    DQ OFFSET row_XDMINUS
BOOTPTR ENDS
.CODE
XDMINUS:
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
    ; subs    x1, x1, x3
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x3
    sub rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x1, rax
    ; sbc     x20, x2, x20
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x20
    mov dl, BYTE PTR arm_c
    xor dl, 1
    add dl, 255
    sbb rax, rcx
    mov QWORD PTR arm_x20, rax
    ; str     x1, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
XDMINUS_END:
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
nm_XD2STAR:
    ; DCB "D2*", 0
    DB "D2*", 0
hl_XD2STAR:
    ; DCB "D2* ( xd1 -- xd2 ) shift double left 1", 0
    DB "D2* ( xd1 -- xd2 ) shift double left 1", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XD2STAR:
    ; DCQ     nm_XD2STAR, hl_XD2STAR
    DQ OFFSET nm_XD2STAR, OFFSET hl_XD2STAR
    ; DCQ     0
    DQ 0
    ; DCQ     XD2STAR, XD2STAR_END
    DQ OFFSET XD2STAR, OFFSET XD2STAR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XD2STAR
    DQ OFFSET row_XD2STAR
BOOTPTR ENDS
.CODE
XD2STAR:
    ; ldr     x1, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lsl     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    shl rax, 1
    mov QWORD PTR arm_x20, rax
    ; orr     x20, x20, x1, lsr #63
    mov rax, QWORD PTR arm_x20
    mov rcx, QWORD PTR arm_x1
    shr rcx, 63
    or rax, rcx
    mov QWORD PTR arm_x20, rax
    ; lsl     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    shl rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
XD2STAR_END:
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
nm_XD2SLASH:
    ; DCB "D2/", 0
    DB "D2/", 0
hl_XD2SLASH:
    ; DCB "D2/ ( xd1 -- xd2 ) arithmetic shift double right 1", 0
    DB "D2/ ( xd1 -- xd2 ) arithmetic shift double right 1", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XD2SLASH:
    ; DCQ     nm_XD2SLASH, hl_XD2SLASH
    DQ OFFSET nm_XD2SLASH, OFFSET hl_XD2SLASH
    ; DCQ     0
    DQ 0
    ; DCQ     XD2SLASH, XD2SLASH_END
    DQ OFFSET XD2SLASH, OFFSET XD2SLASH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XD2SLASH
    DQ OFFSET row_XD2SLASH
BOOTPTR ENDS
.CODE
XD2SLASH:
    ; ldr     x1, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; extr    x1, x20, x1, #1
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x20
    mov rdx, rcx
    shrd rax, rdx, 1
    mov QWORD PTR arm_x1, rax
    ; asr     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    sar rax, 1
    mov QWORD PTR arm_x20, rax
    ; str     x1, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
XD2SLASH_END:
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
nm_XD0EQUAL:
    ; DCB "D0=", 0
    DB "D0=", 0
hl_XD0EQUAL:
    ; DCB "D0= ( xd -- flag ) double equal zero?", 0
    DB "D0= ( xd -- flag ) double equal zero?", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XD0EQUAL:
    ; DCQ     nm_XD0EQUAL, hl_XD0EQUAL
    DQ OFFSET nm_XD0EQUAL, OFFSET hl_XD0EQUAL
    ; DCQ     0
    DQ 0
    ; DCQ     XD0EQUAL, XD0EQUAL_END
    DQ OFFSET XD0EQUAL, OFFSET XD0EQUAL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XD0EQUAL
    DQ OFFSET row_XD0EQUAL
BOOTPTR ENDS
.CODE
XD0EQUAL:
    ; ldr     x1, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; orr     x1, x1, x20
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x20
    or rax, rcx
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, #0
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, eq
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    je xsk_23
    mov rax, -1
    xsk_23:
    mov QWORD PTR arm_x20, rax
XD0EQUAL_END:
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
nm_XDEQUAL:
    ; DCB "D=", 0
    DB "D=", 0
hl_XDEQUAL:
    ; DCB "D= ( xd1 xd2 -- flag ) double equal?", 0
    DB "D= ( xd1 xd2 -- flag ) double equal?", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDEQUAL:
    ; DCQ     nm_XDEQUAL, hl_XDEQUAL
    DQ OFFSET nm_XDEQUAL, OFFSET hl_XDEQUAL
    ; DCQ     0
    DQ 0
    ; DCQ     XDEQUAL, XDEQUAL_END
    DQ OFFSET XDEQUAL, OFFSET XDEQUAL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDEQUAL
    DQ OFFSET row_XDEQUAL
BOOTPTR ENDS
.CODE
XDEQUAL:
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
    ; cmp     x1, x3
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; ccmp    x2, x20, #0, eq
    cmp BYTE PTR arm_z, 0
    jne xsk_24
    mov BYTE PTR arm_n, 0
    mov BYTE PTR arm_z, 0
    mov BYTE PTR arm_c, 0
    mov BYTE PTR arm_v, 0
    jmp xsk_25
    xsk_24:
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    xsk_25:
    ; csetm   x20, eq
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    je xsk_26
    mov rax, -1
    xsk_26:
    mov QWORD PTR arm_x20, rax
XDEQUAL_END:
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
nm_XDLESS:
    ; DCB "D<", 0
    DB "D<", 0
hl_XDLESS:
    ; DCB "D< ( d1 d2 -- flag ) signed double less", 0
    DB "D< ( d1 d2 -- flag ) signed double less", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDLESS:
    ; DCQ     nm_XDLESS, hl_XDLESS
    DQ OFFSET nm_XDLESS, OFFSET hl_XDLESS
    ; DCQ     0
    DQ 0
    ; DCQ     XDLESS, XDLESS_END
    DQ OFFSET XDLESS, OFFSET XDLESS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDLESS
    DQ OFFSET row_XDLESS
BOOTPTR ENDS
.CODE
XDLESS:
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
    ; cmp     x2, x20
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lt    _dless_yes
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne _dless_yes
    ; b.gt    _dless_no
    cmp BYTE PTR arm_z, 0
    jne xsk_27
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _dless_no
    xsk_27:
    ; cmp     x1, x3
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, lo
    xor eax, eax
    cmp BYTE PTR arm_c, 0
    jne xsk_28
    mov rax, -1
    xsk_28:
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
_dless_yes:
    ; mov     x20, #-1
    mov rax, -1
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
_dless_no:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XDLESS_END:
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
nm_XDULESS:
    ; DCB "DU<", 0
    DB "DU<", 0
hl_XDULESS:
    ; DCB "DU< ( ud1 ud2 -- flag ) unsigned double less", 0
    DB "DU< ( ud1 ud2 -- flag ) unsigned double less", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDULESS:
    ; DCQ     nm_XDULESS, hl_XDULESS
    DQ OFFSET nm_XDULESS, OFFSET hl_XDULESS
    ; DCQ     0
    DQ 0
    ; DCQ     XDULESS, XDULESS_END
    DQ OFFSET XDULESS, OFFSET XDULESS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDULESS
    DQ OFFSET row_XDULESS
BOOTPTR ENDS
.CODE
XDULESS:
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
    ; cmp     x2, x20
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _duless_yes
    cmp BYTE PTR arm_c, 0
    je _duless_yes
    ; b.hi    _duless_no
    cmp BYTE PTR arm_c, 0
    je xsk_29
    cmp BYTE PTR arm_z, 0
    je _duless_no
    xsk_29:
    ; cmp     x1, x3
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, lo
    xor eax, eax
    cmp BYTE PTR arm_c, 0
    jne xsk_30
    mov rax, -1
    xsk_30:
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
_duless_yes:
    ; mov     x20, #-1
    mov rax, -1
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
_duless_no:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XDULESS_END:
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
nm_XDMIN:
    ; DCB "DMIN", 0
    DB "DMIN", 0
hl_XDMIN:
    ; DCB "DMIN ( d1 d2 -- d3 ) minimum of two doubles", 0
    DB "DMIN ( d1 d2 -- d3 ) minimum of two doubles", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDMIN:
    ; DCQ     nm_XDMIN, hl_XDMIN
    DQ OFFSET nm_XDMIN, OFFSET hl_XDMIN
    ; DCQ     0
    DQ 0
    ; DCQ     XDMIN, XDMIN_END
    DQ OFFSET XDMIN, OFFSET XDMIN_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDMIN
    DQ OFFSET row_XDMIN
BOOTPTR ENDS
.CODE
XDMIN:
    ; ldr     x3, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; ldr     x2, [x22, #8]
    mov r10, QWORD PTR arm_x22
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; ldr     x1, [x22, #16]
    mov r10, QWORD PTR arm_x22
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x2, x20
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lt    _dmin_d1
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne _dmin_d1
    ; b.gt    _dmin_d2
    cmp BYTE PTR arm_z, 0
    jne xsk_31
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _dmin_d2
    xsk_31:
    ; cmp     x1, x3
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _dmin_d1
    cmp BYTE PTR arm_c, 0
    je _dmin_d1
    cmp BYTE PTR arm_z, 0
    jne _dmin_d1
_dmin_d2:
    ; str     x3, [x22, #16]
    mov r10, QWORD PTR arm_x22
    add r10, 10h
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; add     x22, x22, #16
    mov rax, QWORD PTR arm_x22
    add rax, 10h
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
_dmin_d1:
    ; mov     x20, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x20, rax
    ; add     x22, x22, #16
    mov rax, QWORD PTR arm_x22
    add rax, 10h
    mov QWORD PTR arm_x22, rax
XDMIN_END:
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
nm_XDMAX:
    ; DCB "DMAX", 0
    DB "DMAX", 0
hl_XDMAX:
    ; DCB "DMAX ( d1 d2 -- d3 ) maximum of two doubles", 0
    DB "DMAX ( d1 d2 -- d3 ) maximum of two doubles", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDMAX:
    ; DCQ     nm_XDMAX, hl_XDMAX
    DQ OFFSET nm_XDMAX, OFFSET hl_XDMAX
    ; DCQ     0
    DQ 0
    ; DCQ     XDMAX, XDMAX_END
    DQ OFFSET XDMAX, OFFSET XDMAX_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDMAX
    DQ OFFSET row_XDMAX
BOOTPTR ENDS
.CODE
XDMAX:
    ; ldr     x3, [x22]
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; ldr     x2, [x22, #8]
    mov r10, QWORD PTR arm_x22
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; ldr     x1, [x22, #16]
    mov r10, QWORD PTR arm_x22
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x2, x20
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x20
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.gt    _dmax_d1
    cmp BYTE PTR arm_z, 0
    jne xsk_32
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _dmax_d1
    xsk_32:
    ; b.lt    _dmax_d2
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne _dmax_d2
    ; cmp     x1, x3
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _dmax_d1
    cmp BYTE PTR arm_c, 0
    jne _dmax_d1
_dmax_d2:
    ; str     x3, [x22, #16]
    mov r10, QWORD PTR arm_x22
    add r10, 10h
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; add     x22, x22, #16
    mov rax, QWORD PTR arm_x22
    add rax, 10h
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
_dmax_d1:
    ; mov     x20, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x20, rax
    ; add     x22, x22, #16
    mov rax, QWORD PTR arm_x22
    add rax, 10h
    mov QWORD PTR arm_x22, rax
XDMAX_END:
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
nm_XDTOS:
    ; DCB "D>S", 0
    DB "D>S", 0
hl_XDTOS:
    ; DCB "D>S ( d -- n ) double to single", 0
    DB "D>S ( d -- n ) double to single", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDTOS:
    ; DCQ     nm_XDTOS, hl_XDTOS
    DQ OFFSET nm_XDTOS, OFFSET hl_XDTOS
    ; DCQ     0
    DQ 0
    ; DCQ     XDTOS, XDTOS_END
    DQ OFFSET XDTOS, OFFSET XDTOS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDTOS
    DQ OFFSET row_XDTOS
BOOTPTR ENDS
.CODE
XDTOS:
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
XDTOS_END:
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
nm_XMPLUS:
    ; DCB "M+", 0
    DB "M+", 0
hl_XMPLUS:
    ; DCB "M+ ( d1 n -- d2 ) add single to double", 0
    DB "M+ ( d1 n -- d2 ) add single to double", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMPLUS:
    ; DCQ     nm_XMPLUS, hl_XMPLUS
    DQ OFFSET nm_XMPLUS, OFFSET hl_XMPLUS
    ; DCQ     0
    DQ 0
    ; DCQ     XMPLUS, XMPLUS_END
    DQ OFFSET XMPLUS, OFFSET XMPLUS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMPLUS
    DQ OFFSET row_XMPLUS
BOOTPTR ENDS
.CODE
XMPLUS:
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
    ; asr     x3, x20, #63
    mov rax, QWORD PTR arm_x20
    sar rax, 63
    mov QWORD PTR arm_x3, rax
    ; adds    x1, x1, x20
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x20
    add rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    mov QWORD PTR arm_x1, rax
    ; adc     x20, x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    mov dl, BYTE PTR arm_c
    add dl, 255
    adc rax, rcx
    mov QWORD PTR arm_x20, rax
    ; str     x1, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
XMPLUS_END:
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
_udivmod128:
    ; cbz     x2, _udm_bad
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je _udm_bad
    ; cmp     x1, x2
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _udm_bad
    cmp BYTE PTR arm_c, 0
    jne _udm_bad
    ; mov     x3, xzr
    xor eax, eax
    mov QWORD PTR arm_x3, rax
    ; mov     x4, xzr
    xor eax, eax
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #128
    mov rax, 80h
    mov QWORD PTR arm_x5, rax
_udm_bit:
    ; sub     x5, x5, #1
    mov rax, QWORD PTR arm_x5
    sub rax, 1
    mov QWORD PTR arm_x5, rax
    ; cmp     x5, #64
    mov rax, QWORD PTR arm_x5
    cmp rax, 40h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _udm_hi
    cmp BYTE PTR arm_c, 0
    jne _udm_hi
    ; lsr     x6, x0, x5
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x5
    shr rax, cl
    mov QWORD PTR arm_x6, rax
    ; b       _udm_got
    jmp _udm_got
_udm_hi:
    ; sub     x7, x5, #64
    mov rax, QWORD PTR arm_x5
    sub rax, 40h
    mov QWORD PTR arm_x7, rax
    ; lsr     x6, x1, x7
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x7
    shr rax, cl
    mov QWORD PTR arm_x6, rax
_udm_got:
    ; and     x6, x6, #1
    mov rax, QWORD PTR arm_x6
    and rax, 1
    mov QWORD PTR arm_x6, rax
    ; lsr     x7, x4, #63
    mov rax, QWORD PTR arm_x4
    shr rax, 63
    mov QWORD PTR arm_x7, rax
    ; lsl     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    shl rax, 1
    mov QWORD PTR arm_x4, rax
    ; orr     x4, x4, x6
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x6
    or rax, rcx
    mov QWORD PTR arm_x4, rax
    ; lsl     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    shl rax, 1
    mov QWORD PTR arm_x3, rax
    ; cbnz    x7, _udm_sub
    mov rax, QWORD PTR arm_x7
    cmp rax, 0
    jne _udm_sub
    ; cmp     x4, x2
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _udm_next
    cmp BYTE PTR arm_c, 0
    je _udm_next
_udm_sub:
    ; sub     x4, x4, x2
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x2
    sub rax, rcx
    mov QWORD PTR arm_x4, rax
    ; orr     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    or rax, 1
    mov QWORD PTR arm_x3, rax
_udm_next:
    ; cbnz    x5, _udm_bit
    mov rax, QWORD PTR arm_x5
    cmp rax, 0
    jne _udm_bit
    ; ret
    jmp QWORD PTR arm_x30
_udm_bad:
    ; mov     x3, #-1
    mov rax, -1
    mov QWORD PTR arm_x3, rax
    ; mov     x4, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x4, rax
    ; ret
    jmp QWORD PTR arm_x30
BWSTR SEGMENT ALIGN(1) READ
nm_XUMMOD:
    ; DCB "UM/MOD", 0
    DB "UM/MOD", 0
hl_XUMMOD:
    ; DCB "UM/MOD ( ud u -- rem quot ) unsigned divmod", 0
    DB "UM/MOD ( ud u -- rem quot ) unsigned divmod", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XUMMOD:
    ; DCQ     nm_XUMMOD, hl_XUMMOD
    DQ OFFSET nm_XUMMOD, OFFSET hl_XUMMOD
    ; DCQ     0
    DQ 0
    ; DCQ     XUMMOD, XUMMOD_END
    DQ OFFSET XUMMOD, OFFSET XUMMOD_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XUMMOD
    DQ OFFSET row_XUMMOD
BOOTPTR ENDS
.CODE
XUMMOD:
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
    ; bl      _udivmod128
    lea rax, xret_33
    mov QWORD PTR arm_x30, rax
    jmp _udivmod128
    xret_33:
    ; str     x4, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10], rax
    ; mov     x20, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x20, rax
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
XUMMOD_END:
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
nm_XSMREM:
    ; DCB "SM/REM", 0
    DB "SM/REM", 0
hl_XSMREM:
    ; DCB "SM/REM ( d n -- rem quot ) symmetric divmod", 0
    DB "SM/REM ( d n -- rem quot ) symmetric divmod", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSMREM:
    ; DCQ     nm_XSMREM, hl_XSMREM
    DQ OFFSET nm_XSMREM, OFFSET hl_XSMREM
    ; DCQ     0
    DQ 0
    ; DCQ     XSMREM, XSMREM_END
    DQ OFFSET XSMREM, OFFSET XSMREM_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSMREM
    DQ OFFSET row_XSMREM
BOOTPTR ENDS
.CODE
XSMREM:
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
    ; cmp     x4, #0
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; cset    x6, lt
    xor eax, eax
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je xsk_34
    mov eax, 1
    xsk_34:
    mov QWORD PTR arm_x6, rax
    ; cmp     x5, #0
    mov rax, QWORD PTR arm_x5
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; cset    x7, lt
    xor eax, eax
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je xsk_35
    mov eax, 1
    xsk_35:
    mov QWORD PTR arm_x7, rax
    ; stp     x6, x7, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [r10+8], rax
    ; mov     x0, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x4
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR arm_x1, rax
    ; cbz     x6, _sm_absd
    mov rax, QWORD PTR arm_x6
    cmp rax, 0
    je _sm_absd
    ; mvn     x0, x0
    mov rax, QWORD PTR arm_x0
    not rax
    mov QWORD PTR arm_x0, rax
    ; mvn     x1, x1
    mov rax, QWORD PTR arm_x1
    not rax
    mov QWORD PTR arm_x1, rax
    ; adds    x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    mov QWORD PTR arm_x0, rax
    ; adc     x1, x1, xzr
    mov rax, QWORD PTR arm_x1
    xor ecx, ecx
    mov dl, BYTE PTR arm_c
    add dl, 255
    adc rax, rcx
    mov QWORD PTR arm_x1, rax
_sm_absd:
    ; mov     x2, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x2, rax
    ; cbz     x7, _sm_absn
    mov rax, QWORD PTR arm_x7
    cmp rax, 0
    je _sm_absn
    ; neg     x2, x2
    mov rax, QWORD PTR arm_x2
    neg rax
    mov QWORD PTR arm_x2, rax
_sm_absn:
    ; cbz     x2, _sm_div0
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je _sm_div0
    ; bl      _udivmod128
    lea rax, xret_36
    mov QWORD PTR arm_x30, rax
    jmp _udivmod128
    xret_36:
    ; ldp     x6, x7, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x6, rax
    mov QWORD PTR arm_x7, rcx
    add rsp, 10h
    ; cbz     x6, _sm_quotsign
    mov rax, QWORD PTR arm_x6
    cmp rax, 0
    je _sm_quotsign
    ; neg     x4, x4
    mov rax, QWORD PTR arm_x4
    neg rax
    mov QWORD PTR arm_x4, rax
_sm_quotsign:
    ; eor     x8, x6, x7
    mov rax, QWORD PTR arm_x6
    mov rcx, QWORD PTR arm_x7
    xor rax, rcx
    mov QWORD PTR arm_x8, rax
    ; cbz     x8, _sm_push
    mov rax, QWORD PTR arm_x8
    cmp rax, 0
    je _sm_push
    ; neg     x3, x3
    mov rax, QWORD PTR arm_x3
    neg rax
    mov QWORD PTR arm_x3, rax
_sm_push:
    ; str     x4, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10], rax
    ; mov     x20, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x20, rax
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
_sm_div0:
    ; add     sp, sp, #16
    mov rax, rsp
    add rax, 10h
    mov rsp, rax
    ; str     xzr, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov QWORD PTR [r10], 0
    ; mov     x20, #-1
    mov rax, -1
    mov QWORD PTR arm_x20, rax
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
XSMREM_END:
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
nm_XFMMOD:
    ; DCB "FM/MOD", 0
    DB "FM/MOD", 0
hl_XFMMOD:
    ; DCB "FM/MOD ( d n -- rem quot ) floored divmod", 0
    DB "FM/MOD ( d n -- rem quot ) floored divmod", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFMMOD:
    ; DCQ     nm_XFMMOD, hl_XFMMOD
    DQ OFFSET nm_XFMMOD, OFFSET hl_XFMMOD
    ; DCQ     0
    DQ 0
    ; DCQ     XFMMOD, XFMMOD_END
    DQ OFFSET XFMMOD, OFFSET XFMMOD_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFMMOD
    DQ OFFSET row_XFMMOD
BOOTPTR ENDS
.CODE
XFMMOD:
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
    ; cmp     x4, #0
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; cset    x6, lt
    xor eax, eax
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je xsk_37
    mov eax, 1
    xsk_37:
    mov QWORD PTR arm_x6, rax
    ; cmp     x5, #0
    mov rax, QWORD PTR arm_x5
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; cset    x7, lt
    xor eax, eax
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je xsk_38
    mov eax, 1
    xsk_38:
    mov QWORD PTR arm_x7, rax
    ; stp     x6, x7, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [r10+8], rax
    ; str     x5, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10], rax
    ; mov     x0, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x4
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR arm_x1, rax
    ; cbz     x6, _fm_absd
    mov rax, QWORD PTR arm_x6
    cmp rax, 0
    je _fm_absd
    ; mvn     x0, x0
    mov rax, QWORD PTR arm_x0
    not rax
    mov QWORD PTR arm_x0, rax
    ; mvn     x1, x1
    mov rax, QWORD PTR arm_x1
    not rax
    mov QWORD PTR arm_x1, rax
    ; adds    x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    mov QWORD PTR arm_x0, rax
    ; adc     x1, x1, xzr
    mov rax, QWORD PTR arm_x1
    xor ecx, ecx
    mov dl, BYTE PTR arm_c
    add dl, 255
    adc rax, rcx
    mov QWORD PTR arm_x1, rax
_fm_absd:
    ; mov     x2, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x2, rax
    ; cbz     x7, _fm_absn
    mov rax, QWORD PTR arm_x7
    cmp rax, 0
    je _fm_absn
    ; neg     x2, x2
    mov rax, QWORD PTR arm_x2
    neg rax
    mov QWORD PTR arm_x2, rax
_fm_absn:
    ; cbz     x2, _fm_div0
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je _fm_div0
    ; bl      _udivmod128
    lea rax, xret_39
    mov QWORD PTR arm_x30, rax
    jmp _udivmod128
    xret_39:
    ; ldp     x6, x7, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x6, rax
    mov QWORD PTR arm_x7, rcx
    ; ldr     x5, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; cbz     x6, _fm_remsign
    mov rax, QWORD PTR arm_x6
    cmp rax, 0
    je _fm_remsign
    ; neg     x4, x4
    mov rax, QWORD PTR arm_x4
    neg rax
    mov QWORD PTR arm_x4, rax
_fm_remsign:
    ; eor     x8, x6, x7
    mov rax, QWORD PTR arm_x6
    mov rcx, QWORD PTR arm_x7
    xor rax, rcx
    mov QWORD PTR arm_x8, rax
    ; cbz     x8, _fm_floor
    mov rax, QWORD PTR arm_x8
    cmp rax, 0
    je _fm_floor
    ; neg     x3, x3
    mov rax, QWORD PTR arm_x3
    neg rax
    mov QWORD PTR arm_x3, rax
_fm_floor:
    ; cbz     x4, _fm_push
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    je _fm_push
    ; eor     x8, x4, x5
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x5
    xor rax, rcx
    mov QWORD PTR arm_x8, rax
    ; tbz     x8, #63, _fm_push
    mov rax, QWORD PTR arm_x8
    bt rax, 63
    jnc _fm_push
    ; sub     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    sub rax, 1
    mov QWORD PTR arm_x3, rax
    ; add     x4, x4, x5
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x5
    add rax, rcx
    mov QWORD PTR arm_x4, rax
_fm_push:
    ; str     x4, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10], rax
    ; mov     x20, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x20, rax
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
_fm_div0:
    ; str     xzr, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov QWORD PTR [r10], 0
    ; mov     x20, #-1
    mov rax, -1
    mov QWORD PTR arm_x20, rax
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
XFMMOD_END:
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
nm_XSEARCH:
    ; DCB "SEARCH", 0
    DB "SEARCH", 0
hl_XSEARCH:
    ; DCB "SEARCH ( c-addr1 u1 c-addr2 u2 -- c-addr3 u3 flag ) find substring", 0
    DB "SEARCH ( c-addr1 u1 c-addr2 u2 -- c-addr3 u3 flag ) find substring", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSEARCH:
    ; DCQ     nm_XSEARCH, hl_XSEARCH
    DQ OFFSET nm_XSEARCH, OFFSET hl_XSEARCH
    ; DCQ     0
    DQ 0
    ; DCQ     XSEARCH, XSEARCH_END
    DQ OFFSET XSEARCH, OFFSET XSEARCH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSEARCH
    DQ OFFSET row_XSEARCH
BOOTPTR ENDS
.CODE
XSEARCH:
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
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x9, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x9, rax
    ; mov     x10, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x10, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; cbz     x3, _search_hit
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    je _search_hit
_search_off:
    ; subs    x5, x1, x4
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x4
    sub rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x5, rax
    ; b.lo    _search_miss
    cmp BYTE PTR arm_c, 0
    je _search_miss
    ; cmp     x5, x3
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _search_miss
    cmp BYTE PTR arm_c, 0
    je _search_miss
    ; mov     x6, #0
    mov rax, 0
    mov QWORD PTR arm_x6, rax
_search_cmp:
    ; cmp     x6, x3
    mov rax, QWORD PTR arm_x6
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _search_hit
    cmp BYTE PTR arm_c, 0
    jne _search_hit
    ; add     x7, x0, x4
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x4
    add rax, rcx
    mov QWORD PTR arm_x7, rax
    ; ldrb    w8, [x7, x6]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR arm_x6
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x8, rax
    ; ldrb    w11, [x2, x6]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x6
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x11, rax
    ; cmp     w8, w11
    mov eax, DWORD PTR arm_x8
    mov ecx, DWORD PTR arm_x11
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _search_next
    cmp BYTE PTR arm_z, 0
    je _search_next
    ; add     x6, x6, #1
    mov rax, QWORD PTR arm_x6
    add rax, 1
    mov QWORD PTR arm_x6, rax
    ; b       _search_cmp
    jmp _search_cmp
_search_next:
    ; add     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; b       _search_off
    jmp _search_off
_search_hit:
    ; add     x0, x0, x4
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x4
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; sub     x1, x1, x4
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x4
    sub rax, rcx
    mov QWORD PTR arm_x1, rax
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
    ; mov     x20, #-1
    mov rax, -1
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
_search_miss:
    ; str     x9, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR [r10], rax
    ; str     x10, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x10
    mov QWORD PTR [r10], rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XSEARCH_END:
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
nm_XCONTAINS:
    ; DCB "CONTAINS", 0
    DB "CONTAINS", 0
hl_XCONTAINS:
    ; DCB "CONTAINS ( hay-a hay-u ned-a ned-u -- flag ) case-insensitive substring", 0
    DB "CONTAINS ( hay-a hay-u ned-a ned-u -- flag ) case-insensitive substring", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCONTAINS:
    ; DCQ     nm_XCONTAINS, hl_XCONTAINS
    DQ OFFSET nm_XCONTAINS, OFFSET hl_XCONTAINS
    ; DCQ     0
    DQ 0
    ; DCQ     XCONTAINS, XCONTAINS_END
    DQ OFFSET XCONTAINS, OFFSET XCONTAINS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCONTAINS
    DQ OFFSET row_XCONTAINS
BOOTPTR ENDS
.CODE
XCONTAINS:
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
    ; cbz     x4, _cont_yes
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    je _cont_yes
    ; cmp     x2, x4
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x4
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _cont_no
    cmp BYTE PTR arm_c, 0
    je _cont_no
    ; sub     x5, x2, x4
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x4
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
    ; add     x5, x5, #1
    mov rax, QWORD PTR arm_x5
    add rax, 1
    mov QWORD PTR arm_x5, rax
    ; mov     x6, #0
    mov rax, 0
    mov QWORD PTR arm_x6, rax
_cont_i:
    ; cmp     x6, x5
    mov rax, QWORD PTR arm_x6
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _cont_no
    cmp BYTE PTR arm_c, 0
    jne _cont_no
    ; mov     x7, #0
    mov rax, 0
    mov QWORD PTR arm_x7, rax
_cont_j:
    ; cmp     x7, x4
    mov rax, QWORD PTR arm_x7
    mov rcx, QWORD PTR arm_x4
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _cont_yes
    cmp BYTE PTR arm_c, 0
    jne _cont_yes
    ; add     x8, x1, x6
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x6
    add rax, rcx
    mov QWORD PTR arm_x8, rax
    ; add     x8, x8, x7
    mov rax, QWORD PTR arm_x8
    mov rcx, QWORD PTR arm_x7
    add rax, rcx
    mov QWORD PTR arm_x8, rax
    ; ldrb    w9, [x8]
    mov r10, QWORD PTR arm_x8
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x9, rax
    ; ldrb    w10, [x3, x7]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x7
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x10, rax
    ; cmp     w9, #'a'
    mov eax, DWORD PTR arm_x9
    cmp eax, 61h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _cont_hfold
    cmp BYTE PTR arm_c, 0
    je _cont_hfold
    ; cmp     w9, #'z'
    mov eax, DWORD PTR arm_x9
    cmp eax, 7Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _cont_hfold
    cmp BYTE PTR arm_c, 0
    je xsk_40
    cmp BYTE PTR arm_z, 0
    je _cont_hfold
    xsk_40:
    ; sub     w9, w9, #32
    mov eax, DWORD PTR arm_x9
    sub eax, 20h
    mov QWORD PTR arm_x9, rax
_cont_hfold:
    ; cmp     w10, #'a'
    mov eax, DWORD PTR arm_x10
    cmp eax, 61h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _cont_nfold
    cmp BYTE PTR arm_c, 0
    je _cont_nfold
    ; cmp     w10, #'z'
    mov eax, DWORD PTR arm_x10
    cmp eax, 7Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _cont_nfold
    cmp BYTE PTR arm_c, 0
    je xsk_41
    cmp BYTE PTR arm_z, 0
    je _cont_nfold
    xsk_41:
    ; sub     w10, w10, #32
    mov eax, DWORD PTR arm_x10
    sub eax, 20h
    mov QWORD PTR arm_x10, rax
_cont_nfold:
    ; cmp     w9, w10
    mov eax, DWORD PTR arm_x9
    mov ecx, DWORD PTR arm_x10
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _cont_next_i
    cmp BYTE PTR arm_z, 0
    je _cont_next_i
    ; add     x7, x7, #1
    mov rax, QWORD PTR arm_x7
    add rax, 1
    mov QWORD PTR arm_x7, rax
    ; b       _cont_j
    jmp _cont_j
_cont_next_i:
    ; add     x6, x6, #1
    mov rax, QWORD PTR arm_x6
    add rax, 1
    mov QWORD PTR arm_x6, rax
    ; b       _cont_i
    jmp _cont_i
_cont_yes:
    ; mov     x20, #-1
    mov rax, -1
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
_cont_no:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XCONTAINS_END:
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
nm_XUDOT:
    ; DCB "U.", 0
    DB "U.", 0
hl_XUDOT:
    ; DCB "U. ( u -- ) print unsigned with a trailing space", 0
    DB "U. ( u -- ) print unsigned with a trailing space", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XUDOT:
    ; DCQ     nm_XUDOT, hl_XUDOT
    DQ OFFSET nm_XUDOT, OFFSET hl_XUDOT
    ; DCQ     0
    DQ 0
    ; DCQ     XUDOT, XUDOT_END
    DQ OFFSET XUDOT, OFFSET XUDOT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XUDOT
    DQ OFFSET row_XUDOT
BOOTPTR ENDS
.CODE
XUDOT:
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
    ; bl      _sa_print_unsigned
    lea rax, xret_42
    mov QWORD PTR arm_x30, rax
    jmp _sa_print_unsigned
    xret_42:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _sa_putchar
    lea rax, xret_43
    mov QWORD PTR arm_x30, rax
    jmp _sa_putchar
    xret_43:
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
XUDOT_END:
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
nm_XSPACES:
    ; DCB "SPACES", 0
    DB "SPACES", 0
hl_XSPACES:
    ; DCB "SPACES ( n -- ) emit n spaces", 0
    DB "SPACES ( n -- ) emit n spaces", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSPACES:
    ; DCQ     nm_XSPACES, hl_XSPACES
    DQ OFFSET nm_XSPACES, OFFSET hl_XSPACES
    ; DCQ     0
    DQ 0
    ; DCQ     XSPACES, XSPACES_END
    DQ OFFSET XSPACES, OFFSET XSPACES_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSPACES
    DQ OFFSET row_XSPACES
BOOTPTR ENDS
.CODE
XSPACES:
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
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
    ; b.le    XSPACES_END
    cmp BYTE PTR arm_z, 0
    jne XSPACES_END
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne XSPACES_END
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
_spaces_loop:
    ; str     x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_44
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_44:
    ; ldr     x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; subs    x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x1, rax
    ; b.ne    _spaces_loop
    cmp BYTE PTR arm_z, 0
    je _spaces_loop
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
XSPACES_END:
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
nm_XMSFETCH:
    ; DCB "MS@", 0
    DB "MS@", 0
hl_XMSFETCH:
    ; DCB "MS@ ( -- u ) milliseconds since the host started", 0
    DB "MS@ ( -- u ) milliseconds since the host started", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMSFETCH:
    ; DCQ     nm_XMSFETCH, hl_XMSFETCH
    DQ OFFSET nm_XMSFETCH, OFFSET hl_XMSFETCH
    ; DCQ     0
    DQ 0
    ; DCQ     XMSFETCH, XMSFETCH_END
    DQ OFFSET XMSFETCH, OFFSET XMSFETCH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMSFETCH
    DQ OFFSET row_XMSFETCH
BOOTPTR ENDS
.CODE
XMSFETCH:
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
    ; bl      host_ms
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
    call host_ms
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
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
XMSFETCH_END:
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
nm_XMS:
    ; DCB "MS", 0
    DB "MS", 0
hl_XMS:
    ; DCB "MS ( u -- ) wait that many milliseconds", 0
    DB "MS ( u -- ) wait that many milliseconds", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMS:
    ; DCQ     nm_XMS, hl_XMS
    DQ OFFSET nm_XMS, OFFSET hl_XMS
    ; DCQ     0
    DQ 0
    ; DCQ     XMS, XMS_END
    DQ OFFSET XMS, OFFSET XMS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMS
    DQ OFFSET row_XMS
BOOTPTR ENDS
.CODE
XMS:
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
    ; bl      host_sleep
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
    call host_sleep
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
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
XMS_END:
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
nm_XTIME_DATE:
    ; DCB "TIME", 0x26, "DATE", 0
    DB "TIME", 26h, "DATE", 0
hl_XTIME_DATE:
    ; DCB "TIME", 0x26, "DATE", "( -- sec min hour day month year ) local wall time", 0
    DB "TIME", 26h, "DATE", "( -- sec min hour day month year ) local wall time", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTIME_DATE:
    ; DCQ     nm_XTIME_DATE, hl_XTIME_DATE
    DQ OFFSET nm_XTIME_DATE, OFFSET hl_XTIME_DATE
    ; DCQ     0
    DQ 0
    ; DCQ     XTIME_DATE, XTIME_DATE_END
    DQ OFFSET XTIME_DATE, OFFSET XTIME_DATE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTIME_DATE
    DQ OFFSET row_XTIME_DATE
BOOTPTR ENDS
.CODE
XTIME_DATE:
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
    ; add     x0, sp, #48
    mov rax, rsp
    add rax, 30h
    mov QWORD PTR arm_x0, rax
    ; bl      host_time_date
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
    call host_time_date
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldr     x0, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [sp, #72]
    lea r10, [rsp]
    add r10, 48h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; ldr     x4, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; ldr     x5, [sp, #88]
    lea r10, [rsp]
    add r10, 58h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
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
    ; str     x2, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; str     x3, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; str     x4, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10], rax
    ; mov     x20, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x20, rax
XTIME_DATE_END:
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
nm_XKEY:
    ; DCB "KEY", 0
    DB "KEY", 0
hl_XKEY:
    ; DCB "KEY ( -- c ) next character from the host", 0
    DB "KEY ( -- c ) next character from the host", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XKEY:
    ; DCQ     nm_XKEY, hl_XKEY
    DQ OFFSET nm_XKEY, OFFSET hl_XKEY
    ; DCQ     0
    DQ 0
    ; DCQ     XKEY, XKEY_END
    DQ OFFSET XKEY, OFFSET XKEY_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XKEY
    DQ OFFSET row_XKEY
BOOTPTR ENDS
.CODE
XKEY:
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
    ; lea x1, key_fn
    lea rax, key_fn
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _key_none
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _key_none
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
    ; b       _key_push
    jmp _key_push
_key_none:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
_key_push:
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
XKEY_END:
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
nm_XEKEY:
    ; DCB "EKEY", 0
    DB "EKEY", 0
hl_XEKEY:
    ; DCB "EKEY ( -- u ) next key event", 0
    DB "EKEY ( -- u ) next key event", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XEKEY:
    ; DCQ     nm_XEKEY, hl_XEKEY
    DQ OFFSET nm_XEKEY, OFFSET hl_XEKEY
    ; DCQ     0
    DQ 0
    ; DCQ     XEKEY, XEKEY_END
    DQ OFFSET XEKEY, OFFSET XEKEY_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XEKEY
    DQ OFFSET row_XEKEY
BOOTPTR ENDS
.CODE
XEKEY:
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
    ; bl      _getchar
    lea rax, xret_45
    mov QWORD PTR arm_x30, rax
    jmp _getchar
    xret_45:
    ; lea x1, debug_busy
    lea rax, debug_busy
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, ekey_push
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je ekey_push
    ; mov     x28, #0
    mov rax, 0
    mov QWORD PTR arm_x28, rax
ekey_push:
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
XEKEY_END:
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
nm_XKEYQ:
    ; DCB "KEY?", 0
    DB "KEY?", 0
hl_XKEYQ:
    ; DCB "KEY? ( -- flag ) true if a key is waiting", 0
    DB "KEY? ( -- flag ) true if a key is waiting", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XKEYQ:
    ; DCQ     nm_XKEYQ, hl_XKEYQ
    DQ OFFSET nm_XKEYQ, OFFSET hl_XKEYQ
    ; DCQ     0
    DQ 0
    ; DCQ     XKEYQ, XKEYQ_END
    DQ OFFSET XKEYQ, OFFSET XKEYQ_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XKEYQ
    DQ OFFSET row_XKEYQ
BOOTPTR ENDS
.CODE
XKEYQ:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XKEYQ_END:
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
nm_XFIND:
    ; DCB "FIND", 0
    DB "FIND", 0
hl_XFIND:
    ; DCB "FIND ( c-addr -- c-addr 0 | xt 1 | xt -1 ) find a counted name", 0
    DB "FIND ( c-addr -- c-addr 0 | xt 1 | xt -1 ) find a counted name", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFIND:
    ; DCQ     nm_XFIND, hl_XFIND
    DQ OFFSET nm_XFIND, OFFSET hl_XFIND
    ; DCQ     0
    DQ 0
    ; DCQ     XFIND, 0
    DQ OFFSET XFIND, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFIND
    DQ OFFSET row_XFIND
BOOTPTR ENDS
.CODE
XFIND:
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
    ; mov     x2, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x2, rax
    ; ldrb    w1, [x2]
    mov r10, QWORD PTR arm_x2
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; add     x0, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; bl      _find_word
    lea rax, xret_46
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_46:
    ; cbz     x0, _xfind_not
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _xfind_not
    ; tbnz    x1, #63, _xfind_imm
    mov rax, QWORD PTR arm_x1
    bt rax, 63
    jc _xfind_imm
    ; mov     x4, #-1
    mov rax, -1
    mov QWORD PTR arm_x4, rax
    ; b       _xfind_flag
    jmp _xfind_flag
_xfind_imm:
    ; mov     x4, #1
    mov rax, 1
    mov QWORD PTR arm_x4, rax
_xfind_flag:
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x4
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR arm_x20, rax
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
_xfind_not:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
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
nm_XTICK:
    ; DCB "'", 0
    DB "'", 0
hl_XTICK:
    ; DCB "' ( name -- xt ) xt of the next name", 0
    DB "' ( name -- xt ) xt of the next name", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTICK:
    ; DCQ     nm_XTICK, hl_XTICK
    DQ OFFSET nm_XTICK, OFFSET hl_XTICK
    ; DCQ     0
    DQ 0
    ; DCQ     XTICK, 0
    DQ OFFSET XTICK, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTICK
    DQ OFFSET row_XTICK
BOOTPTR ENDS
.CODE
XTICK:
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
    ; bl      _next_word
    lea rax, xret_47
    mov QWORD PTR arm_x30, rax
    jmp _next_word
    xret_47:
    ; cbz     x1, _tick_fail
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _tick_fail
    ; stp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; bl      _find_word
    lea rax, xret_48
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_48:
    ; cbz     x0, _tick_fail
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _tick_fail
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
_tick_fail:
    ; ldp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; cbz     x1, _tick_mark
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _tick_mark
    ; bl      emit_str
    lea rax, xret_49
    mov QWORD PTR arm_x30, rax
    jmp emit_str
    xret_49:
_tick_mark:
    ; lea x0, msg_huh
    lea rax, msg_huh
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_50
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_50:
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
    ; b       _quit_exit
    jmp _quit_exit
BWSTR SEGMENT ALIGN(1) READ
nm_XEXECUTE:
    ; DCB "EXECUTE", 0
    DB "EXECUTE", 0
hl_XEXECUTE:
    ; DCB "EXECUTE ( xt -- ) run the word at xt", 0
    DB "EXECUTE ( xt -- ) run the word at xt", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XEXECUTE:
    ; DCQ     nm_XEXECUTE, hl_XEXECUTE
    DQ OFFSET nm_XEXECUTE, OFFSET hl_XEXECUTE
    ; DCQ     0
    DQ 0
    ; DCQ     XEXECUTE, XEXECUTE_END
    DQ OFFSET XEXECUTE, OFFSET XEXECUTE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XEXECUTE
    DQ OFFSET row_XEXECUTE
BOOTPTR ENDS
.CODE
XEXECUTE:
    ; mov     x21, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x21, rax
    ; lea x0, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x0, rax
    ; add     x0, x0, #1, lsl #12
    mov rax, QWORD PTR arm_x0
    add rax, 1000h
    mov QWORD PTR arm_x0, rax
    ; cmp     x22, x0
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _exec_empty
    cmp BYTE PTR arm_c, 0
    jne _exec_empty
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; b       _exec_go
    jmp _exec_go
_exec_empty:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
_exec_go:
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
XEXECUTE_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XLITERAL:
    ; DCB "LITERAL", 0
    DB "LITERAL", 0
hl_XLITERAL:
    ; DCB "LITERAL ( x -- ) compile x as a literal", 0
    DB "LITERAL ( x -- ) compile x as a literal", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLITERAL:
    ; DCQ     nm_XLITERAL, hl_XLITERAL
    DQ OFFSET nm_XLITERAL, OFFSET hl_XLITERAL
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XLITERAL, 0
    DQ OFFSET XLITERAL, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLITERAL
    DQ OFFSET row_XLITERAL
BOOTPTR ENDS
.CODE
XLITERAL:
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
    ; str     x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_51
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_51:
    ; ldr     x0, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_52
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_52:
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
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
nm_XTOIN:
    ; DCB ">IN", 0
    DB ">IN", 0
hl_XTOIN:
    ; DCB ">IN ( -- addr ) input offset from the source base", 0
    DB ">IN ( -- addr ) input offset from the source base", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTOIN:
    ; DCQ     nm_XTOIN, hl_XTOIN
    DQ OFFSET nm_XTOIN, OFFSET hl_XTOIN
    ; DCQ     0
    DQ 0
    ; DCQ     XTOIN, 0
    DQ OFFSET XTOIN, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTOIN
    DQ OFFSET row_XTOIN
BOOTPTR ENDS
.CODE
XTOIN:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, to_in
    lea rax, to_in
    mov QWORD PTR arm_x0, rax
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
nm_XPARSE_NAME:
    ; DCB "PARSE-NAME", 0
    DB "PARSE-NAME", 0
hl_XPARSE_NAME:
    ; DCB "PARSE-NAME ( -- c-addr u ) next blank-delimited name", 0
    DB "PARSE-NAME ( -- c-addr u ) next blank-delimited name", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPARSE_NAME:
    ; DCQ     nm_XPARSE_NAME, hl_XPARSE_NAME
    DQ OFFSET nm_XPARSE_NAME, OFFSET hl_XPARSE_NAME
    ; DCQ     0
    DQ 0
    ; DCQ     XPARSE_NAME, 0
    DQ OFFSET XPARSE_NAME, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPARSE_NAME
    DQ OFFSET row_XPARSE_NAME
BOOTPTR ENDS
.CODE
XPARSE_NAME:
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
    ; bl      _parse_name_raw
    lea rax, xret_53
    mov QWORD PTR arm_x30, rax
    jmp _parse_name_raw
    xret_53:
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
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x5
    mov rax, QWORD PTR arm_x5
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
_block_load_nr:
    ; stp     x29, x30, [sp, #-32]!
    add rsp, -32
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; str     x19, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10], rax
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
    ; lea x0, block_nr
    lea rax, block_nr
    mov QWORD PTR arm_x0, rax
    ; str     x19, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10], rax
    ; lea x0, block_file
    lea rax, block_file
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _bln_blank
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _bln_blank
    ; lsl     x1, x19, #10
    mov rax, QWORD PTR arm_x19
    shl rax, 10
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; bl      host_repos
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
    call host_repos
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; cbnz    x0, _bln_blank
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _bln_blank
    ; lea x0, block_buf
    lea rax, block_buf
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #1024
    mov rax, 400h
    mov QWORD PTR arm_x1, rax
    ; lea x2, block_file
    lea rax, block_file
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; bl      host_read
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
    call host_read
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; cmp     x0, #0
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lt    _bln_blank
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne _bln_blank
    ; cmp     x0, #1024
    mov rax, QWORD PTR arm_x0
    cmp rax, 400h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _bln_done
    cmp BYTE PTR arm_c, 0
    jne _bln_done
    ; lea x1, block_buf
    lea rax, block_buf
    mov QWORD PTR arm_x1, rax
    ; add     x1, x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    add rax, rcx
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #1024
    mov rax, 400h
    mov QWORD PTR arm_x2, rax
    ; sub     x2, x2, x0
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x0
    sub rax, rcx
    mov QWORD PTR arm_x2, rax
    ; mov     w3, #32
    mov eax, 20h
    mov QWORD PTR arm_x3, rax
_bln_pad:
    ; cbz     x2, _bln_done
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je _bln_done
    ; strb    w3, [x1], #1
    mov r10, QWORD PTR arm_x1
    mov eax, DWORD PTR arm_x3
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; sub     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    sub rax, 1
    mov QWORD PTR arm_x2, rax
    ; b       _bln_pad
    jmp _bln_pad
_bln_blank:
    ; lea x0, block_buf
    lea rax, block_buf
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #1024
    mov rax, 400h
    mov QWORD PTR arm_x1, rax
    ; mov     w2, #32
    mov eax, 20h
    mov QWORD PTR arm_x2, rax
_bln_fill:
    ; cbz     x1, _bln_done
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _bln_done
    ; strb    w2, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _bln_fill
    jmp _bln_fill
_bln_done:
    ; lea x0, block_upd
    lea rax, block_upd
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; ldr     x19, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    ; ldp     x29, x30, [sp], #32
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 20h
    ; ret
    jmp QWORD PTR arm_x30
BWSTR SEGMENT ALIGN(1) READ
nm_XREFILL:
    ; DCB "REFILL", 0
    DB "REFILL", 0
hl_XREFILL:
    ; DCB "REFILL ( -- flag ) next line when a file is the source", 0
    DB "REFILL ( -- flag ) next line when a file is the source", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XREFILL:
    ; DCQ     nm_XREFILL, hl_XREFILL
    DQ OFFSET nm_XREFILL, OFFSET hl_XREFILL
    ; DCQ     0
    DQ 0
    ; DCQ     XREFILL, 0
    DQ OFFSET XREFILL, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XREFILL
    DQ OFFSET row_XREFILL
BOOTPTR ENDS
.CODE
XREFILL:
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
    ; lea x0, blk_var
    lea rax, blk_var
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, _refill_block
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _refill_block
    ; lea x0, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _refill_no
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _refill_no
    ; bl      _take_line
    lea rax, xret_54
    mov QWORD PTR arm_x30, rax
    jmp _take_line
    xret_54:
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
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; cmp     x0, #0
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csetm   x20, ne
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    jne xsk_55
    mov rax, -1
    xsk_55:
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
_refill_no:
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
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
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
_refill_block:
    ; lea x0, blk_var
    lea rax, blk_var
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
    ; mov     x0, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x0, rax
    ; bl      _block_load_nr
    lea rax, xret_56
    mov QWORD PTR arm_x30, rax
    jmp _block_load_nr
    xret_56:
    ; lea x0, block_buf
    lea rax, block_buf
    mov QWORD PTR arm_x0, rax
    ; lea x2, source_base
    lea rax, source_base
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, source_cur
    lea rax, source_cur
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; add     x0, x0, #1024
    mov rax, QWORD PTR arm_x0
    add rax, 400h
    mov QWORD PTR arm_x0, rax
    ; lea x2, source_end
    lea rax, source_end
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, to_in
    lea rax, to_in
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
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
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, #-1
    mov rax, -1
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
nm_XEXIT_ADDR:
    ; DCB "EXIT-ADDR", 0
    DB "EXIT-ADDR", 0
hl_XEXIT_ADDR:
    ; DCB "EXIT-ADDR ( -- xt ) xt of EXIT", 0
    DB "EXIT-ADDR ( -- xt ) xt of EXIT", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XEXIT_ADDR:
    ; DCQ     nm_XEXIT_ADDR, hl_XEXIT_ADDR
    DQ OFFSET nm_XEXIT_ADDR, OFFSET hl_XEXIT_ADDR
    ; DCQ     0
    DQ 0
    ; DCQ     XEXIT_ADDR, 0
    DQ OFFSET XEXIT_ADDR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XEXIT_ADDR
    DQ OFFSET row_XEXIT_ADDR
BOOTPTR ENDS
.CODE
XEXIT_ADDR:
    ; lea x0, cfa_exit
    lea rax, cfa_exit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
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
nm_XSLIT_ADDR:
    ; DCB "SLIT-ADDR", 0
    DB "SLIT-ADDR", 0
hl_XSLIT_ADDR:
    ; DCB "SLIT-ADDR ( -- xt ) xt of the compiled string runtime", 0
    DB "SLIT-ADDR ( -- xt ) xt of the compiled string runtime", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSLIT_ADDR:
    ; DCQ     nm_XSLIT_ADDR, hl_XSLIT_ADDR
    DQ OFFSET nm_XSLIT_ADDR, OFFSET hl_XSLIT_ADDR
    ; DCQ     0
    DQ 0
    ; DCQ     XSLIT_ADDR, 0
    DQ OFFSET XSLIT_ADDR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSLIT_ADDR
    DQ OFFSET row_XSLIT_ADDR
BOOTPTR ENDS
.CODE
XSLIT_ADDR:
    ; lea x0, cfa_slit
    lea rax, cfa_slit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
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
nm_XDOTQ:
    ; DCB ".", 0x22, 0
    DB ".", 22h, 0
hl_XDOTQ:
    ; DCB ".", 0x22, "print text until a quote", 0
    DB ".", 22h, "print text until a quote", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDOTQ:
    ; DCQ     nm_XDOTQ, hl_XDOTQ
    DQ OFFSET nm_XDOTQ, OFFSET hl_XDOTQ
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XDOTQ, 0
    DQ OFFSET XDOTQ, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDOTQ
    DQ OFFSET row_XDOTQ
BOOTPTR ENDS
.CODE
XDOTQ:
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
    lea rax, xret_57
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_57:
    ; mov     x9, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x9, rax
    ; lea x3, source_end
    lea rax, source_end
    mov QWORD PTR arm_x3, rax
    ; ldr     x6, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; mov     x1, x9
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR arm_x1, rax
_dq_scan:
    ; cmp     x1, x6
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x6
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _dq_len
    cmp BYTE PTR arm_c, 0
    jne _dq_len
    ; ldrb    w3, [x1]
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbz     w3, _dq_len
    mov eax, DWORD PTR arm_x3
    cmp rax, 0
    je _dq_len
    ; cmp     w3, #34
    mov eax, DWORD PTR arm_x3
    cmp eax, 22h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _dq_hit
    cmp BYTE PTR arm_z, 0
    jne _dq_hit
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _dq_scan
    jmp _dq_scan
_dq_hit:
    ; sub     x5, x1, x9
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x9
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _dq_commit
    jmp _dq_commit
_dq_len:
    ; sub     x5, x1, x9
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x9
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
_dq_commit:
    ; mov     x0, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x0, rax
    ; bl      _cursor_commit
    lea rax, xret_58
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_58:
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, _dq_comp
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _dq_comp
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
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x9
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR arm_x20, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x20, rax
    ; b       XTYPE
    jmp XTYPE
_dq_comp:
    ; stp     x9, x5, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x9
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
    lea rax, xret_59
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_59:
    ; ldr     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_60
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_60:
    ; ldr     x5, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; ldr     x9, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
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
_dq_cpy:
    ; cmp     x3, x5
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ge    _dq_align
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _dq_align
    ; ldrb    w4, [x9, x3]
    mov r10, QWORD PTR arm_x9
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
    ; b       _dq_cpy
    jmp _dq_cpy
_dq_align:
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
    ; lea x0, str_type
    lea rax, str_type
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #4
    mov rax, 4
    mov QWORD PTR arm_x1, rax
    ; bl      _find_word
    lea rax, xret_61
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_61:
    ; cbz     x0, _dq_fail
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _dq_fail
    ; bl      _compile_cell
    lea rax, xret_62
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_62:
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
_dq_fail:
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
    ; b       _quit_exit
    jmp _quit_exit
_parse_name_raw:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _cursor_load
    lea rax, xret_63
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_63:
    ; mov     x2, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x2, rax
    ; lea x9, source_end
    lea rax, source_end
    mov QWORD PTR arm_x9, rax
    ; ldr     x9, [x9]
    mov r10, QWORD PTR arm_x9
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
_pn_skip:
    ; cmp     x2, x9
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _pn_empty
    cmp BYTE PTR arm_c, 0
    jne _pn_empty
    ; ldrb    w4, [x2]
    mov r10, QWORD PTR arm_x2
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _pn_empty
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _pn_empty
    ; cmp     w4, #32
    mov eax, DWORD PTR arm_x4
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pn_sk
    cmp BYTE PTR arm_z, 0
    jne _pn_sk
    ; cmp     w4, #9
    mov eax, DWORD PTR arm_x4
    cmp eax, 9
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pn_sk
    cmp BYTE PTR arm_z, 0
    jne _pn_sk
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pn_sk
    cmp BYTE PTR arm_z, 0
    jne _pn_sk
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pn_sk
    cmp BYTE PTR arm_z, 0
    jne _pn_sk
    ; b       _pn_start
    jmp _pn_start
_pn_sk:
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
    ; b       _pn_skip
    jmp _pn_skip
_pn_start:
    ; mov     x3, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x3, rax
_pn_scan:
    ; cmp     x2, x9
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _pn_end
    cmp BYTE PTR arm_c, 0
    jne _pn_end
    ; ldrb    w4, [x2]
    mov r10, QWORD PTR arm_x2
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _pn_end
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _pn_end
    ; cmp     w4, #32
    mov eax, DWORD PTR arm_x4
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pn_end
    cmp BYTE PTR arm_z, 0
    jne _pn_end
    ; cmp     w4, #9
    mov eax, DWORD PTR arm_x4
    cmp eax, 9
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pn_end
    cmp BYTE PTR arm_z, 0
    jne _pn_end
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pn_end
    cmp BYTE PTR arm_z, 0
    jne _pn_end
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pn_end
    cmp BYTE PTR arm_z, 0
    jne _pn_end
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
    ; b       _pn_scan
    jmp _pn_scan
_pn_end:
    ; sub     x5, x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
    ; cmp     x2, x9
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _pn_commit
    cmp BYTE PTR arm_c, 0
    jne _pn_commit
    ; ldrb    w4, [x2]
    mov r10, QWORD PTR arm_x2
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _pn_commit
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _pn_commit
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
_pn_commit:
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
    ; mov     x2, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x2, rax
    ; bl      _cursor_commit
    lea rax, xret_64
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_64:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_pn_empty:
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
    ; bl      _cursor_commit
    lea rax, xret_65
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_65:
    ; mov     x2, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x2, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
BWSTR SEGMENT ALIGN(1) READ
nm_XTO_IMM:
    ; DCB "TO", 0
    DB "TO", 0
hl_XTO_IMM:
    ; DCB "TO ( x name -- ) store into a VALUE or DEFER", 0
    DB "TO ( x name -- ) store into a VALUE or DEFER", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTO_IMM:
    ; DCQ     nm_XTO_IMM, hl_XTO_IMM
    DQ OFFSET nm_XTO_IMM, OFFSET hl_XTO_IMM
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XTO_IMM, XTO_IMM_END
    DQ OFFSET XTO_IMM, OFFSET XTO_IMM_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTO_IMM
    DQ OFFSET row_XTO_IMM
BOOTPTR ENDS
.CODE
XTO_IMM:
    ; sub     sp, sp, #128
    mov rax, rsp
    sub rax, 80h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _next_word
    lea rax, xret_66
    mov QWORD PTR arm_x30, rax
    jmp _next_word
    xret_66:
    ; cbz     x1, _to_fail
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _to_fail
    ; stp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; lea x2, state_var
    lea rax, state_var
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, _to_interp
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je _to_interp
    ; ldp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; bl      _local_lookup
    lea rax, xret_67
    mov QWORD PTR arm_x30, rax
    jmp _local_lookup
    xret_67:
    ; cmp     x0, #-1
    mov rax, QWORD PTR arm_x0
    cmp rax, -1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _to_compile_value
    cmp BYTE PTR arm_z, 0
    jne _to_compile_value
    ; str     x0, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_68
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_68:
    ; ldr     x0, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_69
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_69:
    ; lea x0, cfa_local_store
    lea rax, cfa_local_store
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_70
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_70:
    ; b       _to_leave
    jmp _to_leave
_to_compile_value:
    ; ldp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; bl      _find_word
    lea rax, xret_71
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_71:
    ; cbz     x0, _to_fail
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _to_fail
    ; add     x0, x0, #16
    mov rax, QWORD PTR arm_x0
    add rax, 10h
    mov QWORD PTR arm_x0, rax
    ; str     x0, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldr     x1, [x0, #-8]
    mov r10, QWORD PTR arm_x0
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _to_bang
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _to_bang
    ; ldr     x3, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [sp, #72]
    lea r10, [rsp]
    add r10, 48h
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; lea x0, str_twofetch
    lea rax, str_twofetch
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #2
    mov rax, 2
    mov QWORD PTR arm_x1, rax
    ; bl      _find_word
    lea rax, xret_72
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_72:
    ; ldr     x3, [sp, #72]
    lea r10, [rsp]
    add r10, 48h
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
    ; b.ne    _to_bang
    cmp BYTE PTR arm_z, 0
    je _to_bang
    ; lea x0, str_twostore
    lea rax, str_twostore
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #2
    mov rax, 2
    mov QWORD PTR arm_x1, rax
    ; b       _to_plant
    jmp _to_plant
_to_bang:
    ; lea x0, str_bang
    lea rax, str_bang
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
_to_plant:
    ; stp     x0, x1, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_73
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_73:
    ; ldr     x0, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_74
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_74:
    ; ldp     x0, x1, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; bl      _find_word
    lea rax, xret_75
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_75:
    ; cbz     x0, _to_fail
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _to_fail
    ; bl      _compile_cell
    lea rax, xret_76
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_76:
    ; b       _to_leave
    jmp _to_leave
_to_interp:
    ; ldp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; bl      _find_word
    lea rax, xret_77
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_77:
    ; cbz     x0, _to_fail
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _to_fail
    ; add     x0, x0, #16
    mov rax, QWORD PTR arm_x0
    add rax, 10h
    mov QWORD PTR arm_x0, rax
    ; lea x3, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x3, rax
    ; add     x3, x3, #1, lsl #12
    mov rax, QWORD PTR arm_x3
    add rax, 1000h
    mov QWORD PTR arm_x3, rax
    ; mov     x4, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x4, rax
    ; sub     x3, x3, x22
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x22
    sub rax, rcx
    mov QWORD PTR arm_x3, rax
    ; lsr     x3, x3, #3
    mov rax, QWORD PTR arm_x3
    shr rax, 3
    mov QWORD PTR arm_x3, rax
    ; cmp     x3, #2
    mov rax, QWORD PTR arm_x3
    cmp rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _to_one
    cmp BYTE PTR arm_c, 0
    je _to_one
    ; str     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; ldr     x1, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; str     x1, [x0, #8]
    mov r10, QWORD PTR arm_x0
    add r10, 8
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; b       _to_pop
    jmp _to_pop
_to_one:
    ; str     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
_to_pop:
    ; cmp     x22, x4
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x4
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _to_empty
    cmp BYTE PTR arm_c, 0
    jne _to_empty
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; b       _to_leave
    jmp _to_leave
_to_empty:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
_to_leave:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #128
    mov rax, rsp
    add rax, 80h
    mov rsp, rax
XTO_IMM_END:
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
_to_fail:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #128
    mov rax, rsp
    add rax, 80h
    mov rsp, rax
    ; lea x0, msg_huh
    lea rax, msg_huh
    mov QWORD PTR arm_x0, rax
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
    ; bl      emit_cstr
    lea rax, xret_78
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_78:
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
    ; b       _quit_exit
    jmp _quit_exit
BWSTR SEGMENT ALIGN(1) READ
nm_XCOMPARE:
    ; DCB "COMPARE", 0
    DB "COMPARE", 0
hl_XCOMPARE:
    ; DCB "COMPARE ( c-addr1 u1 c-addr2 u2 -- n ) -1 0 or 1", 0
    DB "COMPARE ( c-addr1 u1 c-addr2 u2 -- n ) -1 0 or 1", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCOMPARE:
    ; DCQ     nm_XCOMPARE, hl_XCOMPARE
    DQ OFFSET nm_XCOMPARE, OFFSET hl_XCOMPARE
    ; DCQ     0
    DQ 0
    ; DCQ     XCOMPARE, XCOMPARE_END
    DQ OFFSET XCOMPARE, OFFSET XCOMPARE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCOMPARE
    DQ OFFSET row_XCOMPARE
BOOTPTR ENDS
.CODE
XCOMPARE:
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
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; cmp     x1, x3
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; csel    x4, x1, x3, lo
    cmp BYTE PTR arm_c, 0
    je xsk_79
    mov rax, QWORD PTR arm_x3
    jmp xsk_80
    xsk_79:
    mov rax, QWORD PTR arm_x1
    xsk_80:
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
_cmp_loop:
    ; cmp     x5, x4
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x4
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _cmp_len
    cmp BYTE PTR arm_c, 0
    jne _cmp_len
    ; ldrb    w6, [x0, x5]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x5
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; ldrb    w7, [x2, x5]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x5
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x7, rax
    ; cmp     w6, w7
    mov eax, DWORD PTR arm_x6
    mov ecx, DWORD PTR arm_x7
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _cmp_diff
    cmp BYTE PTR arm_z, 0
    je _cmp_diff
    ; add     x5, x5, #1
    mov rax, QWORD PTR arm_x5
    add rax, 1
    mov QWORD PTR arm_x5, rax
    ; b       _cmp_loop
    jmp _cmp_loop
_cmp_diff:
    ; mov     x20, #1
    mov rax, 1
    mov QWORD PTR arm_x20, rax
    ; b.hi    XCOMPARE_END
    cmp BYTE PTR arm_c, 0
    je xsk_81
    cmp BYTE PTR arm_z, 0
    je XCOMPARE_END
    xsk_81:
    ; mov     x20, #-1
    mov rax, -1
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
_cmp_len:
    ; cmp     x1, x3
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _cmp_eq
    cmp BYTE PTR arm_z, 0
    jne _cmp_eq
    ; mov     x20, #1
    mov rax, 1
    mov QWORD PTR arm_x20, rax
    ; b.hi    XCOMPARE_END
    cmp BYTE PTR arm_c, 0
    je xsk_82
    cmp BYTE PTR arm_z, 0
    je XCOMPARE_END
    xsk_82:
    ; mov     x20, #-1
    mov rax, -1
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
_cmp_eq:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XCOMPARE_END:
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
nm_XLATEST:
    ; DCB "LATEST", 0
    DB "LATEST", 0
hl_XLATEST:
    ; DCB "LATEST ( -- addr ) FORTH wordlist head array", 0
    DB "LATEST ( -- addr ) FORTH wordlist head array", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLATEST:
    ; DCQ     nm_XLATEST, hl_XLATEST
    DQ OFFSET nm_XLATEST, OFFSET hl_XLATEST
    ; DCQ     0
    DQ 0
    ; DCQ     XLATEST, 0
    DQ OFFSET XLATEST, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLATEST
    DQ OFFSET row_XLATEST
BOOTPTR ENDS
.CODE
XLATEST:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x0, rax
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
nm_XFORTH_WORDLIST:
    ; DCB "FORTH-WORDLIST", 0
    DB "FORTH-WORDLIST", 0
hl_XFORTH_WORDLIST:
    ; DCB "FORTH-WORDLIST ( -- wid ) main FORTH word list", 0
    DB "FORTH-WORDLIST ( -- wid ) main FORTH word list", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFORTH_WORDLIST:
    ; DCQ     nm_XFORTH_WORDLIST, hl_XFORTH_WORDLIST
    DQ OFFSET nm_XFORTH_WORDLIST, OFFSET hl_XFORTH_WORDLIST
    ; DCQ     0
    DQ 0
    ; DCQ     XFORTH_WORDLIST, 0
    DQ OFFSET XFORTH_WORDLIST, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFORTH_WORDLIST
    DQ OFFSET row_XFORTH_WORDLIST
BOOTPTR ENDS
.CODE
XFORTH_WORDLIST:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x0, rax
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
nm_XWORDLISTS:
    ; DCB "WORDLISTS", 0
    DB "WORDLISTS", 0
hl_XWORDLISTS:
    ; DCB "WORDLISTS ( -- addr n ) registered wordlist table", 0
    DB "WORDLISTS ( -- addr n ) registered wordlist table", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XWORDLISTS:
    ; DCQ     nm_XWORDLISTS, hl_XWORDLISTS
    DQ OFFSET nm_XWORDLISTS, OFFSET hl_XWORDLISTS
    ; DCQ     0
    DQ 0
    ; DCQ     XWORDLISTS, 0
    DQ OFFSET XWORDLISTS, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XWORDLISTS
    DQ OFFSET row_XWORDLISTS
BOOTPTR ENDS
.CODE
XWORDLISTS:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, wordlist_reg
    lea rax, wordlist_reg
    mov QWORD PTR arm_x0, rax
    ; str     x0, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x0, wordlist_reg_n
    lea rax, wordlist_reg_n
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR arm_x0
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
nm_XALSO:
    ; DCB "ALSO", 0
    DB "ALSO", 0
hl_XALSO:
    ; DCB "ALSO ( -- ) duplicate the first search-order entry", 0
    DB "ALSO ( -- ) duplicate the first search-order entry", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XALSO:
    ; DCQ     nm_XALSO, hl_XALSO
    DQ OFFSET nm_XALSO, OFFSET hl_XALSO
    ; DCQ     0
    DQ 0
    ; DCQ     XALSO, 0
    DQ OFFSET XALSO, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XALSO
    DQ OFFSET row_XALSO
BOOTPTR ENDS
.CODE
XALSO:
    ; lea x0, search_order_n
    lea rax, search_order_n
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _also_done
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _also_done
    ; cmp     x1, #8
    mov rax, QWORD PTR arm_x1
    cmp rax, 8
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _also_done
    cmp BYTE PTR arm_c, 0
    jne _also_done
    ; lea x2, search_order
    lea rax, search_order
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; mov     x4, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x4, rax
_also_shift:
    ; cbz     x4, _also_put
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    je _also_put
    ; sub     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    sub rax, 1
    mov QWORD PTR arm_x4, rax
    ; ldr     x5, [x2, x4, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x4
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; add     x6, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x6, rax
    ; str     x5, [x2, x6, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x6
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10], rax
    ; b       _also_shift
    jmp _also_shift
_also_put:
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
_also_done:
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
nm_XREDEF_WARNING:
    ; DCB "REDEF-WARNING", 0
    DB "REDEF-WARNING", 0
hl_XREDEF_WARNING:
    ; DCB "REDEF-WARNING ( -- addr ) nonzero warns on redefine", 0
    DB "REDEF-WARNING ( -- addr ) nonzero warns on redefine", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XREDEF_WARNING:
    ; DCQ     nm_XREDEF_WARNING, hl_XREDEF_WARNING
    DQ OFFSET nm_XREDEF_WARNING, OFFSET hl_XREDEF_WARNING
    ; DCQ     0
    DQ 0
    ; DCQ     XREDEF_WARNING, 0
    DQ OFFSET XREDEF_WARNING, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XREDEF_WARNING
    DQ OFFSET row_XREDEF_WARNING
BOOTPTR ENDS
.CODE
XREDEF_WARNING:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, redef_warn
    lea rax, redef_warn
    mov QWORD PTR arm_x0, rax
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
nm_XTRAVERSE_WORDLIST:
    ; DCB "TRAVERSE-WORDLIST", 0
    DB "TRAVERSE-WORDLIST", 0
hl_XTRAVERSE_WORDLIST:
    ; DCB "TRAVERSE-WORDLIST ( i*x xt wid -- j*x ) visit each name", 0
    DB "TRAVERSE-WORDLIST ( i*x xt wid -- j*x ) visit each name", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTRAVERSE_WORDLIST:
    ; DCQ     nm_XTRAVERSE_WORDLIST, hl_XTRAVERSE_WORDLIST
    DQ OFFSET nm_XTRAVERSE_WORDLIST, OFFSET hl_XTRAVERSE_WORDLIST
    ; DCQ     0
    DQ 0
    ; DCQ     XTRAVERSE_WORDLIST, 0
    DQ OFFSET XTRAVERSE_WORDLIST, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTRAVERSE_WORDLIST
    DQ OFFSET row_XTRAVERSE_WORDLIST
BOOTPTR ENDS
.CODE
XTRAVERSE_WORDLIST:
    ; mov     x5, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x5, rax
    ; ldr     x6, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
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
    ; str     x19, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10], rax
    ; str     x5, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10], rax
    ; mov     x7, #0
    mov rax, 0
    mov QWORD PTR arm_x7, rax
    ; str     x7, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [r10], rax
    ; str     x6, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; ldr     x7, [x5]
    mov r10, QWORD PTR arm_x5
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x7, rax
_tw_loop:
    ; cbz     x7, _tw_advance
    mov rax, QWORD PTR arm_x7
    cmp rax, 0
    je _tw_advance
    ; ldr     x8, [x7, #-16]
    mov r10, QWORD PTR arm_x7
    add r10, -16
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x8, rax
    ; ldr     x0, [x7, #-8]
    mov r10, QWORD PTR arm_x7
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; and     x0, x0, #0xFFFF
    mov rax, QWORD PTR arm_x0
    and rax, 0FFFFh
    mov QWORD PTR arm_x0, rax
    ; sub     x0, x7, x0
    mov rax, QWORD PTR arm_x7
    mov rcx, QWORD PTR arm_x0
    sub rax, rcx
    mov QWORD PTR arm_x0, rax
    ; ldrb    w0, [x0]
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; tst     w0, #0x80
    mov eax, DWORD PTR arm_x0
    test eax, 80h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    _tw_skip
    cmp BYTE PTR arm_z, 0
    je _tw_skip
    ; and     w0, w0, #0x7F
    mov eax, DWORD PTR arm_x0
    and eax, 7Fh
    mov QWORD PTR arm_x0, rax
    ; cbz     w0, _tw_skip
    mov eax, DWORD PTR arm_x0
    cmp rax, 0
    je _tw_skip
    ; ldr     x6, [x23]
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; str     x8, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x8
    mov QWORD PTR [r10], rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x7
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR arm_x20, rax
    ; mov     x21, x6
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR arm_x21, rax
    ; lea x19, tw_continue_cell
    lea rax, tw_continue_cell
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_tw_skip:
    ; mov     x7, x8
    mov rax, QWORD PTR arm_x8
    mov QWORD PTR arm_x7, rax
    ; b       _tw_loop
    jmp _tw_loop
_tw_advance:
    ; ldr     x6, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; ldr     x7, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x7, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; ldr     x5, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; add     x7, x7, #1
    mov rax, QWORD PTR arm_x7
    add rax, 1
    mov QWORD PTR arm_x7, rax
    ; cmp     x7, #16
    mov rax, QWORD PTR arm_x7
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _tw_done
    cmp BYTE PTR arm_c, 0
    jne _tw_done
    ; str     x5, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10], rax
    ; str     x7, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [r10], rax
    ; str     x6, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; add     x0, x5, x7, lsl #3
    mov rax, QWORD PTR arm_x5
    mov rcx, QWORD PTR arm_x7
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; ldr     x7, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x7, rax
    ; b       _tw_loop
    jmp _tw_loop
_tw_done:
    ; ldr     x19, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
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
XTW_CONTINUE:
    ; ldr     x8, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x8, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; ldr     x6, [x23]
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; cbz     x20, _tw_stop
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    je _tw_stop
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x7, x8
    mov rax, QWORD PTR arm_x8
    mov QWORD PTR arm_x7, rax
    ; cbz     x7, _tw_advance
    mov rax, QWORD PTR arm_x7
    cmp rax, 0
    je _tw_advance
    ; b       _tw_loop
    jmp _tw_loop
_tw_stop:
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x6, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; ldr     x7, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x7, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; ldr     x5, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; ldr     x19, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
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
nm_XCATCH:
    ; DCB "CATCH", 0
    DB "CATCH", 0
hl_XCATCH:
    ; DCB "CATCH ( xt -- n ) run xt and push 0 or the throw code", 0
    DB "CATCH ( xt -- n ) run xt and push 0 or the throw code", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCATCH:
    ; DCQ     nm_XCATCH, hl_XCATCH
    DQ OFFSET nm_XCATCH, OFFSET hl_XCATCH
    ; DCQ     0
    DQ 0
    ; DCQ     XCATCH, XCATCH_END
    DQ OFFSET XCATCH, OFFSET XCATCH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCATCH
    DQ OFFSET row_XCATCH
BOOTPTR ENDS
.CODE
XCATCH:
    ; mov     x5, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x5, rax
    ; lea x0, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x0, rax
    ; add     x0, x0, #1, lsl #12
    mov rax, QWORD PTR arm_x0
    add rax, 1000h
    mov QWORD PTR arm_x0, rax
    ; cmp     x22, x0
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _catch_empty
    cmp BYTE PTR arm_c, 0
    jne _catch_empty
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; b       _catch_save
    jmp _catch_save
_catch_empty:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
_catch_save:
    ; lea x7, throw_handler
    lea rax, throw_handler
    mov QWORD PTR arm_x7, rax
    ; ldr     x2, [x7]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; lea x3, eval_resume_sp
    lea rax, eval_resume_sp
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; str     x2, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; str     x20, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; str     x22, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10], rax
    ; lea x2, source_sp
    lea rax, source_sp
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; str     x2, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; str     x19, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10], rax
    ; str     x23, [x7]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10], rax
    ; lea x19, catch_ok_cell
    lea rax, catch_ok_cell
    mov QWORD PTR arm_x19, rax
    ; mov     x21, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x21, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
XCATCH_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XCATCH_OK:
    ; DCB "(CATCH-OK)", 0
    DB "(CATCH-OK)", 0
hl_XCATCH_OK:
    ; DCB "(CATCH-OK) ( -- 0 ) CATCH success path", 0
    DB "(CATCH-OK) ( -- 0 ) CATCH success path", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCATCH_OK:
    ; DCQ     nm_XCATCH_OK, hl_XCATCH_OK
    DQ OFFSET nm_XCATCH_OK, OFFSET hl_XCATCH_OK
    ; DCQ     0
    DQ 0
    ; DCQ     XCATCH_OK, XCATCH_OK_END
    DQ OFFSET XCATCH_OK, OFFSET XCATCH_OK_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCATCH_OK
    DQ OFFSET row_XCATCH_OK
BOOTPTR ENDS
.CODE
XCATCH_OK:
    ; lea x7, throw_handler
    lea rax, throw_handler
    mov QWORD PTR arm_x7, rax
    ; ldr     x1, [x7]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _cok_push
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _cok_push
    ; mov     x23, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x23, rax
    ; ldr     x19, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x19, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; add     x23, x23, #24
    mov rax, QWORD PTR arm_x23
    add rax, 18h
    mov QWORD PTR arm_x23, rax
    ; ldr     x0, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; str     x0, [x7]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; add     x23, x23, #8
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
_cok_push:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XCATCH_OK_END:
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
nm_XXC_STORE_PLUS:
    ; DCB "XC!+", 0
    DB "XC!+", 0
hl_XXC_STORE_PLUS:
    ; DCB "XC!+ ( xchar xc-addr1 -- xc-addr2 ) store one UTF-8 xchar", 0
    DB "XC!+ ( xchar xc-addr1 -- xc-addr2 ) store one UTF-8 xchar", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XXC_STORE_PLUS:
    ; DCQ     nm_XXC_STORE_PLUS, hl_XXC_STORE_PLUS
    DQ OFFSET nm_XXC_STORE_PLUS, OFFSET hl_XXC_STORE_PLUS
    ; DCQ     0
    DQ 0
    ; DCQ     XXC_STORE_PLUS, XXC_STORE_PLUS_END
    DQ OFFSET XXC_STORE_PLUS, OFFSET XXC_STORE_PLUS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XXC_STORE_PLUS
    DQ OFFSET row_XXC_STORE_PLUS
BOOTPTR ENDS
.CODE
XXC_STORE_PLUS:
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
    ; movz    x2, #0xFFFF
    mov rax, 0FFFFh
    mov QWORD PTR arm_x2, rax
    ; movk    x2, #0x10, lsl #16
    mov rax, QWORD PTR arm_x2
    mov rcx, 0FFFFFFFF0000FFFFh
    and rax, rcx
    mov rcx, 100000h
    or rax, rcx
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
    je xsk_85
    cmp BYTE PTR arm_z, 0
    je xsk_83
    xsk_85:
    mov rax, QWORD PTR arm_x1
    jmp xsk_84
    xsk_83:
    mov rax, QWORD PTR arm_x2
    xsk_84:
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, #0x7F
    mov rax, QWORD PTR arm_x1
    cmp rax, 7Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _xcsp_1
    cmp BYTE PTR arm_c, 0
    je _xcsp_1
    cmp BYTE PTR arm_z, 0
    jne _xcsp_1
    ; cmp     x1, #0x7FF
    mov rax, QWORD PTR arm_x1
    cmp rax, 7FFh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _xcsp_2
    cmp BYTE PTR arm_c, 0
    je _xcsp_2
    cmp BYTE PTR arm_z, 0
    jne _xcsp_2
    ; movz    x2, #0xFFFF
    mov rax, 0FFFFh
    mov QWORD PTR arm_x2, rax
    ; cmp     x1, x2
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _xcsp_3
    cmp BYTE PTR arm_c, 0
    je _xcsp_3
    cmp BYTE PTR arm_z, 0
    jne _xcsp_3
    ; lsr     x2, x1, #18
    mov rax, QWORD PTR arm_x1
    shr rax, 18
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, #0xF0
    mov eax, DWORD PTR arm_x2
    or eax, 0F0h
    mov QWORD PTR arm_x2, rax
    ; strb    w2, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; lsr     x2, x1, #12
    mov rax, QWORD PTR arm_x1
    shr rax, 12
    mov QWORD PTR arm_x2, rax
    ; and     w2, w2, #0x3F
    mov eax, DWORD PTR arm_x2
    and eax, 3Fh
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, #0x80
    mov eax, DWORD PTR arm_x2
    or eax, 80h
    mov QWORD PTR arm_x2, rax
    ; strb    w2, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; lsr     x2, x1, #6
    mov rax, QWORD PTR arm_x1
    shr rax, 6
    mov QWORD PTR arm_x2, rax
    ; and     w2, w2, #0x3F
    mov eax, DWORD PTR arm_x2
    and eax, 3Fh
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, #0x80
    mov eax, DWORD PTR arm_x2
    or eax, 80h
    mov QWORD PTR arm_x2, rax
    ; strb    w2, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w2, w1, #0x3F
    mov eax, DWORD PTR arm_x1
    and eax, 3Fh
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, #0x80
    mov eax, DWORD PTR arm_x2
    or eax, 80h
    mov QWORD PTR arm_x2, rax
    ; strb    w2, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
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
_xcsp_3:
    ; lsr     x2, x1, #12
    mov rax, QWORD PTR arm_x1
    shr rax, 12
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, #0xE0
    mov eax, DWORD PTR arm_x2
    or eax, 0E0h
    mov QWORD PTR arm_x2, rax
    ; strb    w2, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; lsr     x2, x1, #6
    mov rax, QWORD PTR arm_x1
    shr rax, 6
    mov QWORD PTR arm_x2, rax
    ; and     w2, w2, #0x3F
    mov eax, DWORD PTR arm_x2
    and eax, 3Fh
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, #0x80
    mov eax, DWORD PTR arm_x2
    or eax, 80h
    mov QWORD PTR arm_x2, rax
    ; strb    w2, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w2, w1, #0x3F
    mov eax, DWORD PTR arm_x1
    and eax, 3Fh
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, #0x80
    mov eax, DWORD PTR arm_x2
    or eax, 80h
    mov QWORD PTR arm_x2, rax
    ; strb    w2, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
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
_xcsp_2:
    ; lsr     x2, x1, #6
    mov rax, QWORD PTR arm_x1
    shr rax, 6
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, #0xC0
    mov eax, DWORD PTR arm_x2
    or eax, 0C0h
    mov QWORD PTR arm_x2, rax
    ; strb    w2, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w2, w1, #0x3F
    mov eax, DWORD PTR arm_x1
    and eax, 3Fh
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, #0x80
    mov eax, DWORD PTR arm_x2
    or eax, 80h
    mov QWORD PTR arm_x2, rax
    ; strb    w2, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x2
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
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
_xcsp_1:
    ; strb    w1, [x0], #1
    mov r10, QWORD PTR arm_x0
    mov eax, DWORD PTR arm_x1
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XXC_STORE_PLUS_END:
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
nm_XXC_FETCH_PLUS:
    ; DCB "XC@+", 0
    DB "XC@+", 0
hl_XXC_FETCH_PLUS:
    ; DCB "XC@+ ( xc-addr1 -- xc-addr2 xchar ) fetch one UTF-8 xchar", 0
    DB "XC@+ ( xc-addr1 -- xc-addr2 xchar ) fetch one UTF-8 xchar", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XXC_FETCH_PLUS:
    ; DCQ     nm_XXC_FETCH_PLUS, hl_XXC_FETCH_PLUS
    DQ OFFSET nm_XXC_FETCH_PLUS, OFFSET hl_XXC_FETCH_PLUS
    ; DCQ     0
    DQ 0
    ; DCQ     XXC_FETCH_PLUS, XXC_FETCH_PLUS_END
    DQ OFFSET XXC_FETCH_PLUS, OFFSET XXC_FETCH_PLUS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XXC_FETCH_PLUS
    DQ OFFSET row_XXC_FETCH_PLUS
BOOTPTR ENDS
.CODE
XXC_FETCH_PLUS:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; ldrb    w1, [x0], #1
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; cmp     w1, #0x80
    mov eax, DWORD PTR arm_x1
    cmp eax, 80h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _xcfp_1
    cmp BYTE PTR arm_c, 0
    je _xcfp_1
    ; cmp     w1, #0xE0
    mov eax, DWORD PTR arm_x1
    cmp eax, 0E0h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _xcfp_2
    cmp BYTE PTR arm_c, 0
    je _xcfp_2
    ; cmp     w1, #0xF0
    mov eax, DWORD PTR arm_x1
    cmp eax, 0F0h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _xcfp_3
    cmp BYTE PTR arm_c, 0
    je _xcfp_3
    ; and     w2, w1, #0x07
    mov eax, DWORD PTR arm_x1
    and eax, 7
    mov QWORD PTR arm_x2, rax
    ; ldrb    w3, [x0], #1
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w3, w3, #0x3F
    mov eax, DWORD PTR arm_x3
    and eax, 3Fh
    mov QWORD PTR arm_x3, rax
    ; lsl     w2, w2, #6
    mov eax, DWORD PTR arm_x2
    shl eax, 6
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, w3
    mov eax, DWORD PTR arm_x2
    mov ecx, DWORD PTR arm_x3
    or eax, ecx
    mov QWORD PTR arm_x2, rax
    ; ldrb    w3, [x0], #1
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w3, w3, #0x3F
    mov eax, DWORD PTR arm_x3
    and eax, 3Fh
    mov QWORD PTR arm_x3, rax
    ; lsl     w2, w2, #6
    mov eax, DWORD PTR arm_x2
    shl eax, 6
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, w3
    mov eax, DWORD PTR arm_x2
    mov ecx, DWORD PTR arm_x3
    or eax, ecx
    mov QWORD PTR arm_x2, rax
    ; ldrb    w3, [x0], #1
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w3, w3, #0x3F
    mov eax, DWORD PTR arm_x3
    and eax, 3Fh
    mov QWORD PTR arm_x3, rax
    ; lsl     w2, w2, #6
    mov eax, DWORD PTR arm_x2
    shl eax, 6
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, w3
    mov eax, DWORD PTR arm_x2
    mov ecx, DWORD PTR arm_x3
    or eax, ecx
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
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
_xcfp_3:
    ; and     w2, w1, #0x0F
    mov eax, DWORD PTR arm_x1
    and eax, 0Fh
    mov QWORD PTR arm_x2, rax
    ; ldrb    w3, [x0], #1
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w3, w3, #0x3F
    mov eax, DWORD PTR arm_x3
    and eax, 3Fh
    mov QWORD PTR arm_x3, rax
    ; lsl     w2, w2, #6
    mov eax, DWORD PTR arm_x2
    shl eax, 6
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, w3
    mov eax, DWORD PTR arm_x2
    mov ecx, DWORD PTR arm_x3
    or eax, ecx
    mov QWORD PTR arm_x2, rax
    ; ldrb    w3, [x0], #1
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w3, w3, #0x3F
    mov eax, DWORD PTR arm_x3
    and eax, 3Fh
    mov QWORD PTR arm_x3, rax
    ; lsl     w2, w2, #6
    mov eax, DWORD PTR arm_x2
    shl eax, 6
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, w3
    mov eax, DWORD PTR arm_x2
    mov ecx, DWORD PTR arm_x3
    or eax, ecx
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
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
_xcfp_2:
    ; and     w2, w1, #0x1F
    mov eax, DWORD PTR arm_x1
    and eax, 1Fh
    mov QWORD PTR arm_x2, rax
    ; ldrb    w3, [x0], #1
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; and     w3, w3, #0x3F
    mov eax, DWORD PTR arm_x3
    and eax, 3Fh
    mov QWORD PTR arm_x3, rax
    ; lsl     w2, w2, #6
    mov eax, DWORD PTR arm_x2
    shl eax, 6
    mov QWORD PTR arm_x2, rax
    ; orr     w2, w2, w3
    mov eax, DWORD PTR arm_x2
    mov ecx, DWORD PTR arm_x3
    or eax, ecx
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
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
_xcfp_1:
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
XXC_FETCH_PLUS_END:
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
nm_XBOOT_WORD_TABLE:
    ; DCB "BOOT-WORD-TABLE", 0
    DB "BOOT-WORD-TABLE", 0
hl_XBOOT_WORD_TABLE:
    ; DCB "BOOT-WORD-TABLE ( -- addr ) start of the boot-word pointer table", 0
    DB "BOOT-WORD-TABLE ( -- addr ) start of the boot-word pointer table", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBOOT_WORD_TABLE:
    ; DCQ     nm_XBOOT_WORD_TABLE, hl_XBOOT_WORD_TABLE
    DQ OFFSET nm_XBOOT_WORD_TABLE, OFFSET hl_XBOOT_WORD_TABLE
    ; DCQ     0
    DQ 0
    ; DCQ     XBOOT_WORD_TABLE, XBOOT_WORD_TABLE_END
    DQ OFFSET XBOOT_WORD_TABLE, OFFSET XBOOT_WORD_TABLE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBOOT_WORD_TABLE
    DQ OFFSET row_XBOOT_WORD_TABLE
BOOTPTR ENDS
.CODE
XBOOT_WORD_TABLE:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, bootptr_start
    lea rax, bootptr_start
    mov QWORD PTR arm_x20, rax
XBOOT_WORD_TABLE_END:
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
nm_XBW_TABLE_LIM:
    ; DCB "BOOT-WORD-TABLE-END", 0
    DB "BOOT-WORD-TABLE-END", 0
hl_XBW_TABLE_LIM:
    ; DCB "BOOT-WORD-TABLE-END ( -- addr ) end of the boot-word pointer table", 0
    DB "BOOT-WORD-TABLE-END ( -- addr ) end of the boot-word pointer table", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBW_TABLE_LIM:
    ; DCQ     nm_XBW_TABLE_LIM, hl_XBW_TABLE_LIM
    DQ OFFSET nm_XBW_TABLE_LIM, OFFSET hl_XBW_TABLE_LIM
    ; DCQ     0
    DQ 0
    ; DCQ     XBW_TABLE_LIM, XBW_TABLE_LIM_END
    DQ OFFSET XBW_TABLE_LIM, OFFSET XBW_TABLE_LIM_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBW_TABLE_LIM
    DQ OFFSET row_XBW_TABLE_LIM
BOOTPTR ENDS
.CODE
XBW_TABLE_LIM:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x20, bootptr_end
    lea rax, bootptr_end
    mov QWORD PTR arm_x20, rax
XBW_TABLE_LIM_END:
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
nm_XFLIT:
    ; DCB "FLIT", 0
    DB "FLIT", 0
hl_XFLIT:
    ; DCB "FLIT ( -- ) push the inline float bits", 0
    DB "FLIT ( -- ) push the inline float bits", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFLIT:
    ; DCQ     nm_XFLIT, hl_XFLIT
    DQ OFFSET nm_XFLIT, OFFSET hl_XFLIT
    ; DCQ     0
    DQ 0
    ; DCQ     XFLIT, XFLIT_END
    DQ OFFSET XFLIT, OFFSET XFLIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFLIT
    DQ OFFSET row_XFLIT
BOOTPTR ENDS
.CODE
XFLIT:
    ; ldr     x1, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; mov     x0, #101
    mov rax, 65h
    mov QWORD PTR arm_x0, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
    ; bl      _float_op_call
    lea rax, xret_86
    mov QWORD PTR arm_x30, rax
    jmp _float_op_call
    xret_86:
XFLIT_END:
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
nm_XFLIT_ADDR:
    ; DCB "FLIT-ADDR", 0
    DB "FLIT-ADDR", 0
hl_XFLIT_ADDR:
    ; DCB "FLIT-ADDR ( -- xt ) xt of FLIT", 0
    DB "FLIT-ADDR ( -- xt ) xt of FLIT", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFLIT_ADDR:
    ; DCQ     nm_XFLIT_ADDR, hl_XFLIT_ADDR
    DQ OFFSET nm_XFLIT_ADDR, OFFSET hl_XFLIT_ADDR
    ; DCQ     0
    DQ 0
    ; DCQ     XFLIT_ADDR, XFLIT_ADDR_END
    DQ OFFSET XFLIT_ADDR, OFFSET XFLIT_ADDR_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFLIT_ADDR
    DQ OFFSET row_XFLIT_ADDR
BOOTPTR ENDS
.CODE
XFLIT_ADDR:
    ; lea x0, cfa_flit
    lea rax, cfa_flit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
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
XFLIT_ADDR_END:
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
nm_XFLOAT_OP:
    ; DCB "(F-OP)", 0
    DB "(F-OP)", 0
hl_XFLOAT_OP:
    ; DCB "(F-OP) ( i*x op -- j*x ) float host multiplex", 0
    DB "(F-OP) ( i*x op -- j*x ) float host multiplex", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFLOAT_OP:
    ; DCQ     nm_XFLOAT_OP, hl_XFLOAT_OP
    DQ OFFSET nm_XFLOAT_OP, OFFSET hl_XFLOAT_OP
    ; DCQ     0
    DQ 0
    ; DCQ     XFLOAT_OP, XFLOAT_OP_END
    DQ OFFSET XFLOAT_OP, OFFSET XFLOAT_OP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFLOAT_OP
    DQ OFFSET row_XFLOAT_OP
BOOTPTR ENDS
.CODE
XFLOAT_OP:
    ; mov     x9, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x9, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
    ; cmp     x9, #22
    mov rax, QWORD PTR arm_x9
    cmp rax, 16h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #23
    mov rax, QWORD PTR arm_x9
    cmp rax, 17h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #24
    mov rax, QWORD PTR arm_x9
    cmp rax, 18h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #25
    mov rax, QWORD PTR arm_x9
    cmp rax, 19h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #26
    mov rax, QWORD PTR arm_x9
    cmp rax, 1Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #27
    mov rax, QWORD PTR arm_x9
    cmp rax, 1Bh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #28
    mov rax, QWORD PTR arm_x9
    cmp rax, 1Ch
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #37
    mov rax, QWORD PTR arm_x9
    cmp rax, 25h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #39
    mov rax, QWORD PTR arm_x9
    cmp rax, 27h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #40
    mov rax, QWORD PTR arm_x9
    cmp rax, 28h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #41
    mov rax, QWORD PTR arm_x9
    cmp rax, 29h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #42
    mov rax, QWORD PTR arm_x9
    cmp rax, 2Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #43
    mov rax, QWORD PTR arm_x9
    cmp rax, 2Bh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #44
    mov rax, QWORD PTR arm_x9
    cmp rax, 2Ch
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #70
    mov rax, QWORD PTR arm_x9
    cmp rax, 46h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #71
    mov rax, QWORD PTR arm_x9
    cmp rax, 47h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #72
    mov rax, QWORD PTR arm_x9
    cmp rax, 48h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #73
    mov rax, QWORD PTR arm_x9
    cmp rax, 49h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #74
    mov rax, QWORD PTR arm_x9
    cmp rax, 4Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #75
    mov rax, QWORD PTR arm_x9
    cmp rax, 4Bh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_a1
    cmp BYTE PTR arm_z, 0
    jne _fo_a1
    ; cmp     x9, #30
    mov rax, QWORD PTR arm_x9
    cmp rax, 1Eh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_d2
    cmp BYTE PTR arm_z, 0
    jne _fo_d2
    ; cmp     x9, #32
    mov rax, QWORD PTR arm_x9
    cmp rax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_cu
    cmp BYTE PTR arm_z, 0
    jne _fo_cu
    ; cmp     x9, #38
    mov rax, QWORD PTR arm_x9
    cmp rax, 26h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_cu
    cmp BYTE PTR arm_z, 0
    jne _fo_cu
    ; b       _fo_go
    jmp _fo_go
_fo_a1:
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; b       _fo_go
    jmp _fo_go
_fo_d2:
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
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; b       _fo_go
    jmp _fo_go
_fo_cu:
    ; mov     x2, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x2, rax
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
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
_fo_go:
    ; str     x9, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR [r10], rax
    ; mov     x0, x9
    mov rax, QWORD PTR arm_x9
    mov QWORD PTR arm_x0, rax
    ; bl      _float_op_call
    lea rax, xret_87
    mov QWORD PTR arm_x30, rax
    jmp _float_op_call
    xret_87:
    ; ldr     x9, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; cmp     x9, #31
    mov rax, QWORD PTR arm_x9
    cmp rax, 1Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push2
    cmp BYTE PTR arm_z, 0
    jne _fo_push2
    ; cmp     x9, #38
    mov rax, QWORD PTR arm_x9
    cmp rax, 26h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push3
    cmp BYTE PTR arm_z, 0
    jne _fo_push3
    ; cmp     x9, #1
    mov rax, QWORD PTR arm_x9
    cmp rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #15
    mov rax, QWORD PTR arm_x9
    cmp rax, 0Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #16
    mov rax, QWORD PTR arm_x9
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #17
    mov rax, QWORD PTR arm_x9
    cmp rax, 11h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #18
    mov rax, QWORD PTR arm_x9
    cmp rax, 12h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #19
    mov rax, QWORD PTR arm_x9
    cmp rax, 13h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #20
    mov rax, QWORD PTR arm_x9
    cmp rax, 14h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #21
    mov rax, QWORD PTR arm_x9
    cmp rax, 15h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #29
    mov rax, QWORD PTR arm_x9
    cmp rax, 1Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #32
    mov rax, QWORD PTR arm_x9
    cmp rax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #36
    mov rax, QWORD PTR arm_x9
    cmp rax, 24h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #39
    mov rax, QWORD PTR arm_x9
    cmp rax, 27h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #40
    mov rax, QWORD PTR arm_x9
    cmp rax, 28h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #41
    mov rax, QWORD PTR arm_x9
    cmp rax, 29h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #42
    mov rax, QWORD PTR arm_x9
    cmp rax, 2Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #43
    mov rax, QWORD PTR arm_x9
    cmp rax, 2Bh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #44
    mov rax, QWORD PTR arm_x9
    cmp rax, 2Ch
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #70
    mov rax, QWORD PTR arm_x9
    cmp rax, 46h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #71
    mov rax, QWORD PTR arm_x9
    cmp rax, 47h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #72
    mov rax, QWORD PTR arm_x9
    cmp rax, 48h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #73
    mov rax, QWORD PTR arm_x9
    cmp rax, 49h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #74
    mov rax, QWORD PTR arm_x9
    cmp rax, 4Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #75
    mov rax, QWORD PTR arm_x9
    cmp rax, 4Bh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; cmp     x9, #102
    mov rax, QWORD PTR arm_x9
    cmp rax, 66h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fo_push1
    cmp BYTE PTR arm_z, 0
    jne _fo_push1
    ; b       _fo_none
    jmp _fo_none
_fo_push1:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, x6
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR arm_x20, rax
    ; b       _fo_none
    jmp _fo_none
_fo_push2:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; str     x6, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; mov     x20, x7
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR arm_x20, rax
    ; b       _fo_none
    jmp _fo_none
_fo_push3:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; str     x6, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; str     x7, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [r10], rax
    ; mov     x20, x8
    mov rax, QWORD PTR arm_x8
    mov QWORD PTR arm_x20, rax
_fo_none:
XFLOAT_OP_END:
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
nm_XLOCAL_PAREN:
    ; DCB "(LOCAL)", 0
    DB "(LOCAL)", 0
hl_XLOCAL_PAREN:
    ; DCB "(LOCAL) ( c-addr u -- ) declare a local or end the local list", 0
    DB "(LOCAL) ( c-addr u -- ) declare a local or end the local list", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOCAL_PAREN:
    ; DCQ     nm_XLOCAL_PAREN, hl_XLOCAL_PAREN
    DQ OFFSET nm_XLOCAL_PAREN, OFFSET hl_XLOCAL_PAREN
    ; DCQ     0
    DQ 0
    ; DCQ     XLOCAL_PAREN, XLOCAL_PAREN_END
    DQ OFFSET XLOCAL_PAREN, OFFSET XLOCAL_PAREN_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOCAL_PAREN
    DQ OFFSET row_XLOCAL_PAREN
BOOTPTR ENDS
.CODE
XLOCAL_PAREN:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
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
    ; cbz     x0, _lp_leave
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _lp_leave
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
    ; cbz     x1, _lp_last
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _lp_last
    ; lea x2, local_declaring
    lea rax, local_declaring
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbnz    x3, _lp_add
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    jne _lp_add
    ; stp     x0, x1, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; bl      _local_compile_reset
    lea rax, xret_88
    mov QWORD PTR arm_x30, rax
    jmp _local_compile_reset
    xret_88:
    ; ldp     x0, x1, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    add rsp, 10h
    ; lea x3, local_init_reverse
    lea rax, local_init_reverse
    mov QWORD PTR arm_x3, rax
    ; str     xzr, [x3]
    mov r10, QWORD PTR arm_x3
    mov QWORD PTR [r10], 0
    ; mov     x3, #1
    mov rax, 1
    mov QWORD PTR arm_x3, rax
    ; lea x2, local_declaring
    lea rax, local_declaring
    mov QWORD PTR arm_x2, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
_lp_add:
    ; bl      _local_add_name
    lea rax, xret_89
    mov QWORD PTR arm_x30, rax
    jmp _local_add_name
    xret_89:
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
    ; b       _lp_leave
    jmp _lp_leave
_lp_last:
    ; lea x2, local_declaring
    lea rax, local_declaring
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbnz    x3, _lp_fin
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    jne _lp_fin
    ; bl      _local_compile_reset
    lea rax, xret_90
    mov QWORD PTR arm_x30, rax
    jmp _local_compile_reset
    xret_90:
    ; lea x3, local_init_reverse
    lea rax, local_init_reverse
    mov QWORD PTR arm_x3, rax
    ; str     xzr, [x3]
    mov r10, QWORD PTR arm_x3
    mov QWORD PTR [r10], 0
_lp_fin:
    ; bl      _local_finalize_compile
    lea rax, xret_91
    mov QWORD PTR arm_x30, rax
    jmp _local_finalize_compile
    xret_91:
    ; lea x2, local_declaring
    lea rax, local_declaring
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
_lp_leave:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
XLOCAL_PAREN_END:
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
nm_XTEXTEDIT:
    ; DCB "TEXTEDIT", 0
    DB "TEXTEDIT", 0
hl_XTEXTEDIT:
    ; DCB "TEXTEDIT ( -- ) open the next file name in the editor", 0
    DB "TEXTEDIT ( -- ) open the next file name in the editor", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTEXTEDIT:
    ; DCQ     nm_XTEXTEDIT, hl_XTEXTEDIT
    DQ OFFSET nm_XTEXTEDIT, OFFSET hl_XTEXTEDIT
    ; DCQ     0
    DQ 0
    ; DCQ     XTEXTEDIT, 0
    DQ OFFSET XTEXTEDIT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTEXTEDIT
    DQ OFFSET row_XTEXTEDIT
BOOTPTR ENDS
.CODE
XTEXTEDIT:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _parse_filespec
    lea rax, xret_92
    mov QWORD PTR arm_x30, rax
    jmp _parse_filespec
    xret_92:
    ; bl      host_edit
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
    call host_edit
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
nm_XEDIT_AT:
    ; DCB "EDIT-AT", 0
    DB "EDIT-AT", 0
hl_XEDIT_AT:
    ; DCB "EDIT-AT ( c-addr u line -- ) open path at line in the editor", 0
    DB "EDIT-AT ( c-addr u line -- ) open path at line in the editor", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XEDIT_AT:
    ; DCQ     nm_XEDIT_AT, hl_XEDIT_AT
    DQ OFFSET nm_XEDIT_AT, OFFSET hl_XEDIT_AT
    ; DCQ     0
    DQ 0
    ; DCQ     XEDIT_AT, 0
    DQ OFFSET XEDIT_AT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XEDIT_AT
    DQ OFFSET row_XEDIT_AT
BOOTPTR ENDS
.CODE
XEDIT_AT:
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
    ; lea x9, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x9, rax
    ; add     x9, x9, #1, lsl #12
    mov rax, QWORD PTR arm_x9
    add rax, 1000h
    mov QWORD PTR arm_x9, rax
    ; cmp     x22, x9
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _eat_empty
    cmp BYTE PTR arm_c, 0
    jne _eat_empty
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; b       _eat_call
    jmp _eat_call
_eat_empty:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
_eat_call:
    ; mov     x0, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x1, rax
    ; mov     x2, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x2, rax
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
    ; bl      host_edit_at
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
    call host_edit_at
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
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
nm_XSYSTEM:
    ; DCB "SYSTEM", 0
    DB "SYSTEM", 0
hl_XSYSTEM:
    ; DCB "SYSTEM ( c-addr u -- n ) run a shell command and return the exit code or -1", 0
    DB "SYSTEM ( c-addr u -- n ) run a shell command and return the exit code or -1", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSYSTEM:
    ; DCQ     nm_XSYSTEM, hl_XSYSTEM
    DQ OFFSET nm_XSYSTEM, OFFSET hl_XSYSTEM
    ; DCQ     0
    DQ 0
    ; DCQ     XSYSTEM, XSYSTEM_END
    DQ OFFSET XSYSTEM, OFFSET XSYSTEM_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSYSTEM
    DQ OFFSET row_XSYSTEM
BOOTPTR ENDS
.CODE
XSYSTEM:
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
    ; bl      host_system
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
    call host_system
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; str     x0, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; ldr     x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
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
XSYSTEM_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XRO:
    ; DCB "R/O", 0
    DB "R/O", 0
hl_XRO:
    ; DCB "R/O ( -- fam ) read-only file access method", 0
    DB "R/O ( -- fam ) read-only file access method", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRO:
    ; DCQ     nm_XRO, hl_XRO
    DQ OFFSET nm_XRO, OFFSET hl_XRO
    ; DCQ     0
    DQ 0
    ; DCQ     XRO, XRO_END
    DQ OFFSET XRO, OFFSET XRO_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRO
    DQ OFFSET row_XRO
BOOTPTR ENDS
.CODE
XRO:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, #1
    mov rax, 1
    mov QWORD PTR arm_x20, rax
XRO_END:
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
nm_XRW:
    ; DCB "R/W", 0
    DB "R/W", 0
hl_XRW:
    ; DCB "R/W ( -- fam ) read-write file access method", 0
    DB "R/W ( -- fam ) read-write file access method", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRW:
    ; DCQ     nm_XRW, hl_XRW
    DQ OFFSET nm_XRW, OFFSET hl_XRW
    ; DCQ     0
    DQ 0
    ; DCQ     XRW, XRW_END
    DQ OFFSET XRW, OFFSET XRW_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRW
    DQ OFFSET row_XRW
BOOTPTR ENDS
.CODE
XRW:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, #3
    mov rax, 3
    mov QWORD PTR arm_x20, rax
XRW_END:
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
nm_XW_O:
    ; DCB "W/O", 0
    DB "W/O", 0
hl_XW_O:
    ; DCB "W/O ( -- fam ) write-only file access method", 0
    DB "W/O ( -- fam ) write-only file access method", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XW_O:
    ; DCQ     nm_XW_O, hl_XW_O
    DQ OFFSET nm_XW_O, OFFSET hl_XW_O
    ; DCQ     0
    DQ 0
    ; DCQ     XW_O, XW_O_END
    DQ OFFSET XW_O, OFFSET XW_O_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XW_O
    DQ OFFSET row_XW_O
BOOTPTR ENDS
.CODE
XW_O:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, #2
    mov rax, 2
    mov QWORD PTR arm_x20, rax
XW_O_END:
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
nm_XBIN:
    ; DCB "BIN", 0
    DB "BIN", 0
hl_XBIN:
    ; DCB "BIN ( fam -- fam ) binary access is the same fam here", 0
    DB "BIN ( fam -- fam ) binary access is the same fam here", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBIN:
    ; DCQ     nm_XBIN, hl_XBIN
    DQ OFFSET nm_XBIN, OFFSET hl_XBIN
    ; DCQ     0
    DQ 0
    ; DCQ     XBIN, 0
    DQ OFFSET XBIN, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBIN
    DQ OFFSET row_XBIN
BOOTPTR ENDS
.CODE
XBIN:
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
nm_XOPEN_FILE:
    ; DCB "OPEN-FILE", 0
    DB "OPEN-FILE", 0
hl_XOPEN_FILE:
    ; DCB "OPEN-FILE ( c-addr u fam -- fileid ior ) open an existing file", 0
    DB "OPEN-FILE ( c-addr u fam -- fileid ior ) open an existing file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XOPEN_FILE:
    ; DCQ     nm_XOPEN_FILE, hl_XOPEN_FILE
    DQ OFFSET nm_XOPEN_FILE, OFFSET hl_XOPEN_FILE
    ; DCQ     0
    DQ 0
    ; DCQ     XOPEN_FILE, XOPEN_FILE_END
    DQ OFFSET XOPEN_FILE, OFFSET XOPEN_FILE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XOPEN_FILE
    DQ OFFSET row_XOPEN_FILE
BOOTPTR ENDS
.CODE
XOPEN_FILE:
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
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; bl      _file_op_call
    lea rax, xret_93
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_93:
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
    ; str     x6, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XOPEN_FILE_END:
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
nm_XCREATE_FILE:
    ; DCB "CREATE-FILE", 0
    DB "CREATE-FILE", 0
hl_XCREATE_FILE:
    ; DCB "CREATE-FILE ( c-addr u fam -- fileid ior ) create or truncate a file", 0
    DB "CREATE-FILE ( c-addr u fam -- fileid ior ) create or truncate a file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCREATE_FILE:
    ; DCQ     nm_XCREATE_FILE, hl_XCREATE_FILE
    DQ OFFSET nm_XCREATE_FILE, OFFSET hl_XCREATE_FILE
    ; DCQ     0
    DQ 0
    ; DCQ     XCREATE_FILE, XCREATE_FILE_END
    DQ OFFSET XCREATE_FILE, OFFSET XCREATE_FILE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCREATE_FILE
    DQ OFFSET row_XCREATE_FILE
BOOTPTR ENDS
.CODE
XCREATE_FILE:
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
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #2
    mov rax, 2
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; bl      _file_op_call
    lea rax, xret_94
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_94:
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
    ; str     x6, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XCREATE_FILE_END:
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
nm_XFILE_SIZE:
    ; DCB "FILE-SIZE", 0
    DB "FILE-SIZE", 0
hl_XFILE_SIZE:
    ; DCB "FILE-SIZE ( fileid -- ud ior ) size of an open file", 0
    DB "FILE-SIZE ( fileid -- ud ior ) size of an open file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFILE_SIZE:
    ; DCQ     nm_XFILE_SIZE, hl_XFILE_SIZE
    DQ OFFSET nm_XFILE_SIZE, OFFSET hl_XFILE_SIZE
    ; DCQ     0
    DQ 0
    ; DCQ     XFILE_SIZE, XFILE_SIZE_END
    DQ OFFSET XFILE_SIZE, OFFSET XFILE_SIZE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFILE_SIZE
    DQ OFFSET row_XFILE_SIZE
BOOTPTR ENDS
.CODE
XFILE_SIZE:
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
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; mov     x0, #9
    mov rax, 9
    mov QWORD PTR arm_x0, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
    ; bl      _file_op_call
    lea rax, xret_95
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_95:
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
    ; str     x6, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; str     x7, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XFILE_SIZE_END:
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
nm_XCLOSE_FILE:
    ; DCB "CLOSE-FILE", 0
    DB "CLOSE-FILE", 0
hl_XCLOSE_FILE:
    ; DCB "CLOSE-FILE ( fileid -- ior ) close an open file", 0
    DB "CLOSE-FILE ( fileid -- ior ) close an open file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCLOSE_FILE:
    ; DCQ     nm_XCLOSE_FILE, hl_XCLOSE_FILE
    DQ OFFSET nm_XCLOSE_FILE, OFFSET hl_XCLOSE_FILE
    ; DCQ     0
    DQ 0
    ; DCQ     XCLOSE_FILE, XCLOSE_FILE_END
    DQ OFFSET XCLOSE_FILE, OFFSET XCLOSE_FILE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCLOSE_FILE
    DQ OFFSET row_XCLOSE_FILE
BOOTPTR ENDS
.CODE
XCLOSE_FILE:
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
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; mov     x0, #3
    mov rax, 3
    mov QWORD PTR arm_x0, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
    ; bl      _file_op_call
    lea rax, xret_96
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_96:
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
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
XCLOSE_FILE_END:
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
nm_XALLOCATE:
    ; DCB "ALLOCATE", 0
    DB "ALLOCATE", 0
hl_XALLOCATE:
    ; DCB "ALLOCATE ( u -- a-addr ior ) allocate heap memory", 0
    DB "ALLOCATE ( u -- a-addr ior ) allocate heap memory", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XALLOCATE:
    ; DCQ     nm_XALLOCATE, hl_XALLOCATE
    DQ OFFSET nm_XALLOCATE, OFFSET hl_XALLOCATE
    ; DCQ     0
    DQ 0
    ; DCQ     XALLOCATE, XALLOCATE_END
    DQ OFFSET XALLOCATE, OFFSET XALLOCATE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XALLOCATE
    DQ OFFSET row_XALLOCATE
BOOTPTR ENDS
.CODE
XALLOCATE:
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
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      host_alloc
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
    call host_alloc
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
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
    ; cbz     x0, _alloc_fail
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _alloc_fail
    ; str     x0, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
    ; b       _alloc_leave
    jmp _alloc_leave
_alloc_fail:
    ; str     xzr, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov QWORD PTR [r10], 0
    ; mov     x20, #-1
    mov rax, -1
    mov QWORD PTR arm_x20, rax
_alloc_leave:
XALLOCATE_END:
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
nm_XFREE:
    ; DCB "FREE", 0
    DB "FREE", 0
hl_XFREE:
    ; DCB "FREE ( a-addr -- ior ) release heap memory", 0
    DB "FREE ( a-addr -- ior ) release heap memory", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFREE:
    ; DCQ     nm_XFREE, hl_XFREE
    DQ OFFSET nm_XFREE, OFFSET hl_XFREE
    ; DCQ     0
    DQ 0
    ; DCQ     XFREE, XFREE_END
    DQ OFFSET XFREE, OFFSET XFREE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFREE
    DQ OFFSET row_XFREE
BOOTPTR ENDS
.CODE
XFREE:
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
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      host_free
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
    call host_free
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
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
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
XFREE_END:
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
nm_XRESIZE:
    ; DCB "RESIZE", 0
    DB "RESIZE", 0
hl_XRESIZE:
    ; DCB "RESIZE ( a-addr1 u -- a-addr2 ior ) resize heap memory", 0
    DB "RESIZE ( a-addr1 u -- a-addr2 ior ) resize heap memory", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRESIZE:
    ; DCQ     nm_XRESIZE, hl_XRESIZE
    DQ OFFSET nm_XRESIZE, OFFSET hl_XRESIZE
    ; DCQ     0
    DQ 0
    ; DCQ     XRESIZE, XRESIZE_END
    DQ OFFSET XRESIZE, OFFSET XRESIZE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRESIZE
    DQ OFFSET row_XRESIZE
BOOTPTR ENDS
.CODE
XRESIZE:
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
    ; str     x0, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; bl      host_resize
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
    call host_resize
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldr     x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
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
    ; cbz     x0, _resize_fail
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _resize_fail
    ; str     x0, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
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
_resize_fail:
    ; str     x1, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; mov     x20, #-1
    mov rax, -1
    mov QWORD PTR arm_x20, rax
XRESIZE_END:
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
nm_XREAD_FILE:
    ; DCB "READ-FILE", 0
    DB "READ-FILE", 0
hl_XREAD_FILE:
    ; DCB "READ-FILE ( c-addr u1 fileid -- u2 ior ) read from an open file", 0
    DB "READ-FILE ( c-addr u1 fileid -- u2 ior ) read from an open file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XREAD_FILE:
    ; DCQ     nm_XREAD_FILE, hl_XREAD_FILE
    DQ OFFSET nm_XREAD_FILE, OFFSET hl_XREAD_FILE
    ; DCQ     0
    DQ 0
    ; DCQ     XREAD_FILE, XREAD_FILE_END
    DQ OFFSET XREAD_FILE, OFFSET XREAD_FILE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XREAD_FILE
    DQ OFFSET row_XREAD_FILE
BOOTPTR ENDS
.CODE
XREAD_FILE:
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
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #4
    mov rax, 4
    mov QWORD PTR arm_x0, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; bl      _file_op_call
    lea rax, xret_97
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_97:
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
    ; str     x6, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XREAD_FILE_END:
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
nm_XWRITE_FILE:
    ; DCB "WRITE-FILE", 0
    DB "WRITE-FILE", 0
hl_XWRITE_FILE:
    ; DCB "WRITE-FILE ( c-addr u fileid -- ior ) write to an open file", 0
    DB "WRITE-FILE ( c-addr u fileid -- ior ) write to an open file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XWRITE_FILE:
    ; DCQ     nm_XWRITE_FILE, hl_XWRITE_FILE
    DQ OFFSET nm_XWRITE_FILE, OFFSET hl_XWRITE_FILE
    ; DCQ     0
    DQ 0
    ; DCQ     XWRITE_FILE, XWRITE_FILE_END
    DQ OFFSET XWRITE_FILE, OFFSET XWRITE_FILE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XWRITE_FILE
    DQ OFFSET row_XWRITE_FILE
BOOTPTR ENDS
.CODE
XWRITE_FILE:
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
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #5
    mov rax, 5
    mov QWORD PTR arm_x0, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; bl      _file_op_call
    lea rax, xret_98
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_98:
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
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
XWRITE_FILE_END:
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
nm_XREPOSITION_FILE:
    ; DCB "REPOSITION-FILE", 0
    DB "REPOSITION-FILE", 0
hl_XREPOSITION_FILE:
    ; DCB "REPOSITION-FILE ( ud fileid -- ior ) seek in an open file", 0
    DB "REPOSITION-FILE ( ud fileid -- ior ) seek in an open file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XREPOSITION_FILE:
    ; DCQ     nm_XREPOSITION_FILE, hl_XREPOSITION_FILE
    DQ OFFSET nm_XREPOSITION_FILE, OFFSET hl_XREPOSITION_FILE
    ; DCQ     0
    DQ 0
    ; DCQ     XREPOSITION_FILE, XREPOSITION_FILE_END
    DQ OFFSET XREPOSITION_FILE, OFFSET XREPOSITION_FILE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XREPOSITION_FILE
    DQ OFFSET row_XREPOSITION_FILE
BOOTPTR ENDS
.CODE
XREPOSITION_FILE:
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
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
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
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
    ; bl      _file_op_call
    lea rax, xret_99
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_99:
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
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
XREPOSITION_FILE_END:
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
nm_XFLUSH_FILE:
    ; DCB "FLUSH-FILE", 0
    DB "FLUSH-FILE", 0
hl_XFLUSH_FILE:
    ; DCB "FLUSH-FILE ( fileid -- ior ) flush an open file", 0
    DB "FLUSH-FILE ( fileid -- ior ) flush an open file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFLUSH_FILE:
    ; DCQ     nm_XFLUSH_FILE, hl_XFLUSH_FILE
    DQ OFFSET nm_XFLUSH_FILE, OFFSET hl_XFLUSH_FILE
    ; DCQ     0
    DQ 0
    ; DCQ     XFLUSH_FILE, XFLUSH_FILE_END
    DQ OFFSET XFLUSH_FILE, OFFSET XFLUSH_FILE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFLUSH_FILE
    DQ OFFSET row_XFLUSH_FILE
BOOTPTR ENDS
.CODE
XFLUSH_FILE:
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
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; mov     x0, #15
    mov rax, 0Fh
    mov QWORD PTR arm_x0, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
    ; bl      _file_op_call
    lea rax, xret_100
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_100:
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
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
XFLUSH_FILE_END:
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
nm_XREAD_LINE:
    ; DCB "READ-LINE", 0
    DB "READ-LINE", 0
hl_XREAD_LINE:
    ; DCB "READ-LINE ( c-addr u1 fileid -- u2 flag ior ) read one line. flag is true when a line was read", 0
    DB "READ-LINE ( c-addr u1 fileid -- u2 flag ior ) read one line. flag is true when a line was read", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XREAD_LINE:
    ; DCQ     nm_XREAD_LINE, hl_XREAD_LINE
    DQ OFFSET nm_XREAD_LINE, OFFSET hl_XREAD_LINE
    ; DCQ     0
    DQ 0
    ; DCQ     XREAD_LINE, XREAD_LINE_END
    DQ OFFSET XREAD_LINE, OFFSET XREAD_LINE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XREAD_LINE
    DQ OFFSET row_XREAD_LINE
BOOTPTR ENDS
.CODE
XREAD_LINE:
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
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #6
    mov rax, 6
    mov QWORD PTR arm_x0, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; bl      _file_op_call
    lea rax, xret_101
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_101:
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
    ; str     x6, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; str     x7, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XREAD_LINE_END:
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
nm_XWRITE_LINE:
    ; DCB "WRITE-LINE", 0
    DB "WRITE-LINE", 0
hl_XWRITE_LINE:
    ; DCB "WRITE-LINE ( c-addr u fileid -- ior ) write the bytes and a newline", 0
    DB "WRITE-LINE ( c-addr u fileid -- ior ) write the bytes and a newline", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XWRITE_LINE:
    ; DCQ     nm_XWRITE_LINE, hl_XWRITE_LINE
    DQ OFFSET nm_XWRITE_LINE, OFFSET hl_XWRITE_LINE
    ; DCQ     0
    DQ 0
    ; DCQ     XWRITE_LINE, XWRITE_LINE_END
    DQ OFFSET XWRITE_LINE, OFFSET XWRITE_LINE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XWRITE_LINE
    DQ OFFSET row_XWRITE_LINE
BOOTPTR ENDS
.CODE
XWRITE_LINE:
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
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #7
    mov rax, 7
    mov QWORD PTR arm_x0, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; bl      _file_op_call
    lea rax, xret_102
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_102:
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
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
XWRITE_LINE_END:
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
nm_XFILE_POSITION:
    ; DCB "FILE-POSITION", 0
    DB "FILE-POSITION", 0
hl_XFILE_POSITION:
    ; DCB "FILE-POSITION ( fileid -- ud ior ) byte offset in an open file", 0
    DB "FILE-POSITION ( fileid -- ud ior ) byte offset in an open file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFILE_POSITION:
    ; DCQ     nm_XFILE_POSITION, hl_XFILE_POSITION
    DQ OFFSET nm_XFILE_POSITION, OFFSET hl_XFILE_POSITION
    ; DCQ     0
    DQ 0
    ; DCQ     XFILE_POSITION, XFILE_POSITION_END
    DQ OFFSET XFILE_POSITION, OFFSET XFILE_POSITION_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFILE_POSITION
    DQ OFFSET row_XFILE_POSITION
BOOTPTR ENDS
.CODE
XFILE_POSITION:
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
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; mov     x0, #8
    mov rax, 8
    mov QWORD PTR arm_x0, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
    ; bl      _file_op_call
    lea rax, xret_103
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_103:
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
    ; str     x6, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; str     x7, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XFILE_POSITION_END:
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
nm_XRESIZE_FILE:
    ; DCB "RESIZE-FILE", 0
    DB "RESIZE-FILE", 0
hl_XRESIZE_FILE:
    ; DCB "RESIZE-FILE ( ud fileid -- ior ) set the length of an open file", 0
    DB "RESIZE-FILE ( ud fileid -- ior ) set the length of an open file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRESIZE_FILE:
    ; DCQ     nm_XRESIZE_FILE, hl_XRESIZE_FILE
    DQ OFFSET nm_XRESIZE_FILE, OFFSET hl_XRESIZE_FILE
    ; DCQ     0
    DQ 0
    ; DCQ     XRESIZE_FILE, XRESIZE_FILE_END
    DQ OFFSET XRESIZE_FILE, OFFSET XRESIZE_FILE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRESIZE_FILE
    DQ OFFSET row_XRESIZE_FILE
BOOTPTR ENDS
.CODE
XRESIZE_FILE:
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
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
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
    ; mov     x0, #11
    mov rax, 0Bh
    mov QWORD PTR arm_x0, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
    ; bl      _file_op_call
    lea rax, xret_104
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_104:
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
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
XRESIZE_FILE_END:
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
nm_XDELETE_FILE:
    ; DCB "DELETE-FILE", 0
    DB "DELETE-FILE", 0
hl_XDELETE_FILE:
    ; DCB "DELETE-FILE ( c-addr u -- ior ) delete a named file", 0
    DB "DELETE-FILE ( c-addr u -- ior ) delete a named file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDELETE_FILE:
    ; DCQ     nm_XDELETE_FILE, hl_XDELETE_FILE
    DQ OFFSET nm_XDELETE_FILE, OFFSET hl_XDELETE_FILE
    ; DCQ     0
    DQ 0
    ; DCQ     XDELETE_FILE, XDELETE_FILE_END
    DQ OFFSET XDELETE_FILE, OFFSET XDELETE_FILE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDELETE_FILE
    DQ OFFSET row_XDELETE_FILE
BOOTPTR ENDS
.CODE
XDELETE_FILE:
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
    ; mov     x2, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x2, rax
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #12
    mov rax, 0Ch
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; bl      _file_op_call
    lea rax, xret_105
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_105:
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
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
XDELETE_FILE_END:
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
nm_XRENAME_FILE:
    ; DCB "RENAME-FILE", 0
    DB "RENAME-FILE", 0
hl_XRENAME_FILE:
    ; DCB "RENAME-FILE ( c-addr1 u1 c-addr2 u2 -- ior ) rename a file", 0
    DB "RENAME-FILE ( c-addr1 u1 c-addr2 u2 -- ior ) rename a file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRENAME_FILE:
    ; DCQ     nm_XRENAME_FILE, hl_XRENAME_FILE
    DQ OFFSET nm_XRENAME_FILE, OFFSET hl_XRENAME_FILE
    ; DCQ     0
    DQ 0
    ; DCQ     XRENAME_FILE, XRENAME_FILE_END
    DQ OFFSET XRENAME_FILE, OFFSET XRENAME_FILE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRENAME_FILE
    DQ OFFSET row_XRENAME_FILE
BOOTPTR ENDS
.CODE
XRENAME_FILE:
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
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #13
    mov rax, 0Dh
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; bl      _file_op_call
    lea rax, xret_106
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_106:
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
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
XRENAME_FILE_END:
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
nm_XFILE_STATUS:
    ; DCB "FILE-STATUS", 0
    DB "FILE-STATUS", 0
hl_XFILE_STATUS:
    ; DCB "FILE-STATUS ( c-addr u -- x ior ) attributes of a named file", 0
    DB "FILE-STATUS ( c-addr u -- x ior ) attributes of a named file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFILE_STATUS:
    ; DCQ     nm_XFILE_STATUS, hl_XFILE_STATUS
    DQ OFFSET nm_XFILE_STATUS, OFFSET hl_XFILE_STATUS
    ; DCQ     0
    DQ 0
    ; DCQ     XFILE_STATUS, XFILE_STATUS_END
    DQ OFFSET XFILE_STATUS, OFFSET XFILE_STATUS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFILE_STATUS
    DQ OFFSET row_XFILE_STATUS
BOOTPTR ENDS
.CODE
XFILE_STATUS:
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
    ; mov     x2, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x2, rax
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #14
    mov rax, 0Eh
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; bl      _file_op_call
    lea rax, xret_107
    mov QWORD PTR arm_x30, rax
    jmp _file_op_call
    xret_107:
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
    ; str     x6, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XFILE_STATUS_END:
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
nm_XLINE_SOURCE:
    ; DCB "(LINE-SOURCE)", 0
    DB "(LINE-SOURCE)", 0
hl_XLINE_SOURCE:
    ; DCB "(LINE-SOURCE) ( c-addr u -- ) interpret one line per SOURCE", 0
    DB "(LINE-SOURCE) ( c-addr u -- ) interpret one line per SOURCE", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLINE_SOURCE:
    ; DCQ     nm_XLINE_SOURCE, hl_XLINE_SOURCE
    DQ OFFSET nm_XLINE_SOURCE, OFFSET hl_XLINE_SOURCE
    ; DCQ     0
    DQ 0
    ; DCQ     XLINE_SOURCE, 0
    DQ OFFSET XLINE_SOURCE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLINE_SOURCE
    DQ OFFSET row_XLINE_SOURCE
BOOTPTR ENDS
.CODE
XLINE_SOURCE:
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
    ; stp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; bl      _push_source
    lea rax, xret_108
    mov QWORD PTR arm_x30, rax
    jmp _push_source
    xret_108:
    ; bl      _view_push_src_id
    lea rax, xret_109
    mov QWORD PTR arm_x30, rax
    jmp _view_push_src_id
    xret_109:
    ; bl      _view_set_src_from_pending
    lea rax, xret_110
    mov QWORD PTR arm_x30, rax
    jmp _view_set_src_from_pending
    xret_110:
    ; ldp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; bl      _arm_lines
    lea rax, xret_111
    mov QWORD PTR arm_x30, rax
    jmp _arm_lines
    xret_111:
    ; lea x0, source_id
    lea rax, source_id
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #2
    mov rax, 2
    mov QWORD PTR arm_x1, rax
    ; neg     x1, x1
    mov rax, QWORD PTR arm_x1
    neg rax
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x0, blk_var
    lea rax, blk_var
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; bl      _eval_resume_push
    lea rax, xret_112
    mov QWORD PTR arm_x30, rax
    jmp _eval_resume_push
    xret_112:
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
    ; b       _interpret_empty
    jmp _interpret_empty
BWSTR SEGMENT ALIGN(1) READ
nm_XRESOLVE_KEY:
    ; DCB "RESOLVE-KEY", 0
    DB "RESOLVE-KEY", 0
hl_XRESOLVE_KEY:
    ; DCB "RESOLVE-KEY ( c-addr u -- c-addr u ) absolute path for a load name", 0
    DB "RESOLVE-KEY ( c-addr u -- c-addr u ) absolute path for a load name", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRESOLVE_KEY:
    ; DCQ     nm_XRESOLVE_KEY, hl_XRESOLVE_KEY
    DQ OFFSET nm_XRESOLVE_KEY, OFFSET hl_XRESOLVE_KEY
    ; DCQ     0
    DQ 0
    ; DCQ     XRESOLVE_KEY, 0
    DQ OFFSET XRESOLVE_KEY, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRESOLVE_KEY
    DQ OFFSET row_XRESOLVE_KEY
BOOTPTR ENDS
.CODE
XRESOLVE_KEY:
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
    ; cbz     x1, _resolve_empty
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _resolve_empty
    ; lea x2, resolve_buf
    lea rax, resolve_buf
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #256
    mov rax, 100h
    mov QWORD PTR arm_x3, rax
    ; bl      host_resolve
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
    call host_resolve
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; mov     x1, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, #255
    mov rax, QWORD PTR arm_x1
    cmp rax, 0FFh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _rk_cap
    cmp BYTE PTR arm_c, 0
    je _rk_cap
    cmp BYTE PTR arm_z, 0
    jne _rk_cap
    ; mov     x1, #255
    mov rax, 0FFh
    mov QWORD PTR arm_x1, rax
_rk_cap:
    ; lea x3, include_name_len
    lea rax, include_name_len
    mov QWORD PTR arm_x3, rax
    ; str     x1, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; cbz     x1, _rk_copied
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _rk_copied
    ; lea x2, resolve_buf
    lea rax, resolve_buf
    mov QWORD PTR arm_x2, rax
    ; lea x3, include_name_pending
    lea rax, include_name_pending
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
_rk_cp:
    ; cmp     x4, x1
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _rk_copied
    cmp BYTE PTR arm_c, 0
    jne _rk_copied
    ; ldrb    w5, [x2, x4]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x4
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x5, rax
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
    ; b       _rk_cp
    jmp _rk_cp
_rk_copied:
    ; lea x2, resolve_buf
    lea rax, resolve_buf
    mov QWORD PTR arm_x2, rax
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
_resolve_empty:
    ; lea x1, include_name_len
    lea rax, include_name_len
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR arm_x1
    mov QWORD PTR [r10], 0
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
    ; str     x0, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
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
nm_XBEGIN_LOAD_CWD:
    ; DCB "BEGIN-LOAD-CWD", 0
    DB "BEGIN-LOAD-CWD", 0
hl_XBEGIN_LOAD_CWD:
    ; DCB "BEGIN-LOAD-CWD ( c-addr u -- ) push the directory of this path", 0
    DB "BEGIN-LOAD-CWD ( c-addr u -- ) push the directory of this path", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBEGIN_LOAD_CWD:
    ; DCQ     nm_XBEGIN_LOAD_CWD, hl_XBEGIN_LOAD_CWD
    DQ OFFSET nm_XBEGIN_LOAD_CWD, OFFSET hl_XBEGIN_LOAD_CWD
    ; DCQ     0
    DQ 0
    ; DCQ     XBEGIN_LOAD_CWD, 0
    DQ OFFSET XBEGIN_LOAD_CWD, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBEGIN_LOAD_CWD
    DQ OFFSET row_XBEGIN_LOAD_CWD
BOOTPTR ENDS
.CODE
XBEGIN_LOAD_CWD:
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
    ; bl      host_begin_load
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
    call host_begin_load
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
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
nm_XEND_LOAD_CWD:
    ; DCB "END-LOAD-CWD", 0
    DB "END-LOAD-CWD", 0
hl_XEND_LOAD_CWD:
    ; DCB "END-LOAD-CWD ( -- ) pop the directory pushed for this load", 0
    DB "END-LOAD-CWD ( -- ) pop the directory pushed for this load", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XEND_LOAD_CWD:
    ; DCQ     nm_XEND_LOAD_CWD, hl_XEND_LOAD_CWD
    DQ OFFSET nm_XEND_LOAD_CWD, OFFSET hl_XEND_LOAD_CWD
    ; DCQ     0
    DQ 0
    ; DCQ     XEND_LOAD_CWD, 0
    DQ OFFSET XEND_LOAD_CWD, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XEND_LOAD_CWD
    DQ OFFSET row_XEND_LOAD_CWD
BOOTPTR ENDS
.CODE
XEND_LOAD_CWD:
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
    ; bl      host_end_load
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
    call host_end_load
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
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
nm_XREG_INCLUDED:
    ; DCB "REGISTER-INCLUDED-STR", 0
    DB "REGISTER-INCLUDED-STR", 0
hl_XREG_INCLUDED:
    ; DCB "REGISTER-INCLUDED-STR ( c-addr u -- ) remember a loaded path", 0
    DB "REGISTER-INCLUDED-STR ( c-addr u -- ) remember a loaded path", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XREG_INCLUDED:
    ; DCQ     nm_XREG_INCLUDED, hl_XREG_INCLUDED
    DQ OFFSET nm_XREG_INCLUDED, OFFSET hl_XREG_INCLUDED
    ; DCQ     0
    DQ 0
    ; DCQ     XREG_INCLUDED, 0
    DQ OFFSET XREG_INCLUDED, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XREG_INCLUDED
    DQ OFFSET row_XREG_INCLUDED
BOOTPTR ENDS
.CODE
XREG_INCLUDED:
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
    ; bl      host_register
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
    call host_register
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
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
_parse_filespec:
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
    ; bl      _cursor_load
    lea rax, xret_113
    mov QWORD PTR arm_x30, rax
    jmp _cursor_load
    xret_113:
    ; mov     x2, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x2, rax
    ; lea x9, source_end
    lea rax, source_end
    mov QWORD PTR arm_x9, rax
    ; ldr     x9, [x9]
    mov r10, QWORD PTR arm_x9
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
_pfs_skip:
    ; cmp     x2, x9
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _pfs_empty
    cmp BYTE PTR arm_c, 0
    jne _pfs_empty
    ; ldrb    w4, [x2]
    mov r10, QWORD PTR arm_x2
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cmp     w4, #32
    mov eax, DWORD PTR arm_x4
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pfs_sk
    cmp BYTE PTR arm_z, 0
    jne _pfs_sk
    ; cmp     w4, #9
    mov eax, DWORD PTR arm_x4
    cmp eax, 9
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pfs_sk
    cmp BYTE PTR arm_z, 0
    jne _pfs_sk
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pfs_sk
    cmp BYTE PTR arm_z, 0
    jne _pfs_sk
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _pfs_sk
    cmp BYTE PTR arm_z, 0
    jne _pfs_sk
    ; b       _pfs_body
    jmp _pfs_body
_pfs_sk:
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
    ; b       _pfs_skip
    jmp _pfs_skip
_pfs_body:
    ; cmp     w4, #34
    mov eax, DWORD PTR arm_x4
    cmp eax, 22h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _pfs_word
    cmp BYTE PTR arm_z, 0
    je _pfs_word
    ; add     x3, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x3, rax
_pfs_q:
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
    ; cmp     x2, x9
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x9
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _pfs_qend
    cmp BYTE PTR arm_c, 0
    jne _pfs_qend
    ; ldrb    w4, [x2]
    mov r10, QWORD PTR arm_x2
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cmp     w4, #34
    mov eax, DWORD PTR arm_x4
    cmp eax, 22h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _pfs_q
    cmp BYTE PTR arm_z, 0
    je _pfs_q
    ; sub     x5, x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
    ; add     x2, x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    mov QWORD PTR arm_x2, rax
    ; b       _pfs_out
    jmp _pfs_out
_pfs_qend:
    ; sub     x5, x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    sub rax, rcx
    mov QWORD PTR arm_x5, rax
    ; b       _pfs_out
    jmp _pfs_out
_pfs_word:
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
    ; bl      _cursor_commit
    lea rax, xret_114
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_114:
    ; bl      _parse_name_raw
    lea rax, xret_115
    mov QWORD PTR arm_x30, rax
    jmp _parse_name_raw
    xret_115:
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x1, rax
    ; b       _pfs_ret
    jmp _pfs_ret
_pfs_out:
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
    ; mov     x2, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x2, rax
    ; bl      _cursor_commit
    lea rax, xret_116
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_116:
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x1, rax
    ; b       _pfs_ret
    jmp _pfs_ret
_pfs_empty:
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
    ; bl      _cursor_commit
    lea rax, xret_117
    mov QWORD PTR arm_x30, rax
    jmp _cursor_commit
    xret_117:
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
_pfs_ret:
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
    ; ret
    jmp QWORD PTR arm_x30
BWSTR SEGMENT ALIGN(1) READ
nm_XPARSE_FILESPEC:
    ; DCB "PARSE-FILESPEC", 0
    DB "PARSE-FILESPEC", 0
hl_XPARSE_FILESPEC:
    ; DCB "PARSE-FILESPEC ( -- c-addr u ) next file name or quoted path", 0
    DB "PARSE-FILESPEC ( -- c-addr u ) next file name or quoted path", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPARSE_FILESPEC:
    ; DCQ     nm_XPARSE_FILESPEC, hl_XPARSE_FILESPEC
    DQ OFFSET nm_XPARSE_FILESPEC, OFFSET hl_XPARSE_FILESPEC
    ; DCQ     0
    DQ 0
    ; DCQ     XPARSE_FILESPEC, 0
    DQ OFFSET XPARSE_FILESPEC, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPARSE_FILESPEC
    DQ OFFSET row_XPARSE_FILESPEC
BOOTPTR ENDS
.CODE
XPARSE_FILESPEC:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _parse_filespec
    lea rax, xret_118
    mov QWORD PTR arm_x30, rax
    jmp _parse_filespec
    xret_118:
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
nm_XFROMLIB:
    ; DCB "FROMLIB", 0
    DB "FROMLIB", 0
hl_XFROMLIB:
    ; DCB "FROMLIB ( -- ) arm the next relative load to use Library", 0
    DB "FROMLIB ( -- ) arm the next relative load to use Library", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFROMLIB:
    ; DCQ     nm_XFROMLIB, hl_XFROMLIB
    DQ OFFSET nm_XFROMLIB, OFFSET hl_XFROMLIB
    ; DCQ     0
    DQ 0
    ; DCQ     XFROMLIB, 0
    DQ OFFSET XFROMLIB, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFROMLIB
    DQ OFFSET row_XFROMLIB
BOOTPTR ENDS
.CODE
XFROMLIB:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_fromlib
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
    call host_fromlib
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
nm_XFROM_LIBRARY:
    ; DCB "FROM-LIBRARY", 0
    DB "FROM-LIBRARY", 0
hl_XFROM_LIBRARY:
    ; DCB "FROM-LIBRARY ( -- ) same as FROMLIB", 0
    DB "FROM-LIBRARY ( -- ) same as FROMLIB", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFROM_LIBRARY:
    ; DCQ     nm_XFROM_LIBRARY, hl_XFROM_LIBRARY
    DQ OFFSET nm_XFROM_LIBRARY, OFFSET hl_XFROM_LIBRARY
    ; DCQ     0
    DQ 0
    ; DCQ     XFROM_LIBRARY, 0
    DQ OFFSET XFROM_LIBRARY, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFROM_LIBRARY
    DQ OFFSET row_XFROM_LIBRARY
BOOTPTR ENDS
.CODE
XFROM_LIBRARY:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_fromlib
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
    call host_fromlib
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
nm_XFROMLIB_OFF:
    ; DCB "FROMLIB-OFF", 0
    DB "FROMLIB-OFF", 0
hl_XFROMLIB_OFF:
    ; DCB "FROMLIB-OFF ( -- ) clear an armed FROMLIB", 0
    DB "FROMLIB-OFF ( -- ) clear an armed FROMLIB", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFROMLIB_OFF:
    ; DCQ     nm_XFROMLIB_OFF, hl_XFROMLIB_OFF
    DQ OFFSET nm_XFROMLIB_OFF, OFFSET hl_XFROMLIB_OFF
    ; DCQ     0
    DQ 0
    ; DCQ     XFROMLIB_OFF, 0
    DQ OFFSET XFROMLIB_OFF, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFROMLIB_OFF
    DQ OFFSET row_XFROMLIB_OFF
BOOTPTR ENDS
.CODE
XFROMLIB_OFF:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_fromlib_off
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
    call host_fromlib_off
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
nm_XFROMLIB_Q:
    ; DCB "FROMLIB?", 0
    DB "FROMLIB?", 0
hl_XFROMLIB_Q:
    ; DCB "FROMLIB? ( -- flag ) true when FROMLIB is armed", 0
    DB "FROMLIB? ( -- flag ) true when FROMLIB is armed", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFROMLIB_Q:
    ; DCQ     nm_XFROMLIB_Q, hl_XFROMLIB_Q
    DQ OFFSET nm_XFROMLIB_Q, OFFSET hl_XFROMLIB_Q
    ; DCQ     0
    DQ 0
    ; DCQ     XFROMLIB_Q, XFROMLIB_Q_END
    DQ OFFSET XFROMLIB_Q, OFFSET XFROMLIB_Q_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFROMLIB_Q
    DQ OFFSET row_XFROMLIB_Q
BOOTPTR ENDS
.CODE
XFROMLIB_Q:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_fromlib_query
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
    call host_fromlib_query
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
XFROMLIB_Q_END:
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
nm_XFILE_ECHO:
    ; DCB "FILE-ECHO", 0
    DB "FILE-ECHO", 0
hl_XFILE_ECHO:
    ; DCB "FILE-ECHO ( -- addr ) echo INCLUDE and FLOAD lines with a line number", 0
    DB "FILE-ECHO ( -- addr ) echo INCLUDE and FLOAD lines with a line number", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFILE_ECHO:
    ; DCQ     nm_XFILE_ECHO, hl_XFILE_ECHO
    DQ OFFSET nm_XFILE_ECHO, OFFSET hl_XFILE_ECHO
    ; DCQ     0
    DQ 0
    ; DCQ     XFILE_ECHO, 0
    DQ OFFSET XFILE_ECHO, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFILE_ECHO
    DQ OFFSET row_XFILE_ECHO
BOOTPTR ENDS
.CODE
XFILE_ECHO:
    ; lea x0, file_echo
    lea rax, file_echo
    mov QWORD PTR arm_x0, rax
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
nm_XCLS:
    ; DCB "CLS", 0
    DB "CLS", 0
hl_XCLS:
    ; DCB "CLS ( -- ) clear the host console", 0
    DB "CLS ( -- ) clear the host console", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCLS:
    ; DCQ     nm_XCLS, hl_XCLS
    DQ OFFSET nm_XCLS, OFFSET hl_XCLS
    ; DCQ     0
    DQ 0
    ; DCQ     XCLS, XCLS_END
    DQ OFFSET XCLS, OFFSET XCLS_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCLS
    DQ OFFSET row_XCLS
BOOTPTR ENDS
.CODE
XCLS:
    ; mov     x0, #9
    mov rax, 9
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; b       _facility_op_go
    jmp _facility_op_go
XCLS_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XBIMUL:
    ; DCB "BI-MUL", 0
    DB "BI-MUL", 0
hl_XBIMUL:
    ; DCB "BI-MUL ( a b r -- ) BIG-INTEGER host multiply", 0
    DB "BI-MUL ( a b r -- ) BIG-INTEGER host multiply", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBIMUL:
    ; DCQ     nm_XBIMUL, hl_XBIMUL
    DQ OFFSET nm_XBIMUL, OFFSET hl_XBIMUL
    ; DCQ     0
    DQ 0
    ; DCQ     XBIMUL, XBIMUL_END
    DQ OFFSET XBIMUL, OFFSET XBIMUL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBIMUL
    DQ OFFSET row_XBIMUL
BOOTPTR ENDS
.CODE
XBIMUL:
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
    ; bl      host_bi_mul
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
    call host_bi_mul
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
XBIMUL_END:
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
nm_XBIDIVMOD:
    ; DCB "BI-DIVMOD", 0
    DB "BI-DIVMOD", 0
hl_XBIDIVMOD:
    ; DCB "BI-DIVMOD ( num den quot rem work -- ) BIG-INTEGER host divmod", 0
    DB "BI-DIVMOD ( num den quot rem work -- ) BIG-INTEGER host divmod", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBIDIVMOD:
    ; DCQ     nm_XBIDIVMOD, hl_XBIDIVMOD
    DQ OFFSET nm_XBIDIVMOD, OFFSET hl_XBIDIVMOD
    ; DCQ     0
    DQ 0
    ; DCQ     XBIDIVMOD, XBIDIVMOD_END
    DQ OFFSET XBIDIVMOD, OFFSET XBIDIVMOD_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBIDIVMOD
    DQ OFFSET row_XBIDIVMOD
BOOTPTR ENDS
.CODE
XBIDIVMOD:
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
    ; bl      host_bi_divmod
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
    call host_bi_divmod
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
XBIDIVMOD_END:
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
nm_XBIISQRT:
    ; DCB "BI-ISQRT", 0
    DB "BI-ISQRT", 0
hl_XBIISQRT:
    ; DCB "BI-ISQRT ( a r quot rem work t1 t2 -- ) BIG-INTEGER host isqrt", 0
    DB "BI-ISQRT ( a r quot rem work t1 t2 -- ) BIG-INTEGER host isqrt", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBIISQRT:
    ; DCQ     nm_XBIISQRT, hl_XBIISQRT
    DQ OFFSET nm_XBIISQRT, OFFSET hl_XBIISQRT
    ; DCQ     0
    DQ 0
    ; DCQ     XBIISQRT, XBIISQRT_END
    DQ OFFSET XBIISQRT, OFFSET XBIISQRT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBIISQRT
    DQ OFFSET row_XBIISQRT
BOOTPTR ENDS
.CODE
XBIISQRT:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
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
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
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
    ; bl      host_bi_isqrt
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
    call host_bi_isqrt
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
XBIISQRT_END:
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
nm_XCHDIR:
    ; DCB "CHDIR", 0
    DB "CHDIR", 0
hl_XCHDIR:
    ; DCB "CHDIR ( -- ) change directory. a bare call waits for a dialog", 0
    DB "CHDIR ( -- ) change directory. a bare call waits for a dialog", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCHDIR:
    ; DCQ     nm_XCHDIR, hl_XCHDIR
    DQ OFFSET nm_XCHDIR, OFFSET hl_XCHDIR
    ; DCQ     0
    DQ 0
    ; DCQ     XCHDIR, 0
    DQ OFFSET XCHDIR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCHDIR
    DQ OFFSET row_XCHDIR
BOOTPTR ENDS
.CODE
XCHDIR:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _parse_filespec
    lea rax, xret_119
    mov QWORD PTR arm_x30, rax
    jmp _parse_filespec
    xret_119:
    ; cbz     x1, _chdir_done
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _chdir_done
    ; bl      host_chdir
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
    call host_chdir
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
_chdir_done:
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
nm_XPWD:
    ; DCB "PWD", 0
    DB "PWD", 0
hl_XPWD:
    ; DCB "PWD ( -- ) print the current directory", 0
    DB "PWD ( -- ) print the current directory", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPWD:
    ; DCQ     nm_XPWD, hl_XPWD
    DQ OFFSET nm_XPWD, OFFSET hl_XPWD
    ; DCQ     0
    DQ 0
    ; DCQ     XPWD, 0
    DQ OFFSET XPWD, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPWD
    DQ OFFSET row_XPWD
BOOTPTR ENDS
.CODE
XPWD:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_pwd
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
    call host_pwd
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
nm_XCWD_FETCH:
    ; DCB "CWD@", 0
    DB "CWD@", 0
hl_XCWD_FETCH:
    ; DCB "CWD@ ( c-addr max -- u ) copy the current directory", 0
    DB "CWD@ ( c-addr max -- u ) copy the current directory", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCWD_FETCH:
    ; DCQ     nm_XCWD_FETCH, hl_XCWD_FETCH
    DQ OFFSET nm_XCWD_FETCH, OFFSET hl_XCWD_FETCH
    ; DCQ     0
    DQ 0
    ; DCQ     XCWD_FETCH, 0
    DQ OFFSET XCWD_FETCH, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCWD_FETCH
    DQ OFFSET row_XCWD_FETCH
BOOTPTR ENDS
.CODE
XCWD_FETCH:
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
    ; bl      host_cwd
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
    call host_cwd
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
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
XCWD_FETCH_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XDIR:
    ; DCB "DIR", 0
    DB "DIR", 0
hl_XDIR:
    ; DCB "DIR ( -- ) list files. a bare call lists the current directory", 0
    DB "DIR ( -- ) list files. a bare call lists the current directory", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDIR:
    ; DCQ     nm_XDIR, hl_XDIR
    DQ OFFSET nm_XDIR, OFFSET hl_XDIR
    ; DCQ     0
    DQ 0
    ; DCQ     XDIR, 0
    DQ OFFSET XDIR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDIR
    DQ OFFSET row_XDIR
BOOTPTR ENDS
.CODE
XDIR:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _parse_filespec
    lea rax, xret_120
    mov QWORD PTR arm_x30, rax
    jmp _parse_filespec
    xret_120:
    ; bl      host_dir
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
    call host_dir
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
nm_XLAST_INCLUDED:
    ; DCB "LAST-INCLUDED", 0
    DB "LAST-INCLUDED", 0
hl_XLAST_INCLUDED:
    ; DCB "LAST-INCLUDED ( -- c-addr u ) path of the last included file", 0
    DB "LAST-INCLUDED ( -- c-addr u ) path of the last included file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLAST_INCLUDED:
    ; DCQ     nm_XLAST_INCLUDED, hl_XLAST_INCLUDED
    DQ OFFSET nm_XLAST_INCLUDED, OFFSET hl_XLAST_INCLUDED
    ; DCQ     0
    DQ 0
    ; DCQ     XLAST_INCLUDED, XLAST_INCLUDED_END
    DQ OFFSET XLAST_INCLUDED, OFFSET XLAST_INCLUDED_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLAST_INCLUDED
    DQ OFFSET row_XLAST_INCLUDED
BOOTPTR ENDS
.CODE
XLAST_INCLUDED:
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
    ; add     x0, sp, #48
    mov rax, rsp
    add rax, 30h
    mov QWORD PTR arm_x0, rax
    ; add     x1, sp, #56
    mov rax, rsp
    add rax, 38h
    mov QWORD PTR arm_x1, rax
    ; bl      host_last_included
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
    call host_last_included
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldr     x0, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
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
XLAST_INCLUDED_END:
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
nm_XDOT_INCLUDED:
    ; DCB ".INCLUDED", 0
    DB ".INCLUDED", 0
hl_XDOT_INCLUDED:
    ; DCB ".INCLUDED ( -- ) list files registered by INCLUDE/REQUIRED", 0
    DB ".INCLUDED ( -- ) list files registered by INCLUDE/REQUIRED", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDOT_INCLUDED:
    ; DCQ     nm_XDOT_INCLUDED, hl_XDOT_INCLUDED
    DQ OFFSET nm_XDOT_INCLUDED, OFFSET hl_XDOT_INCLUDED
    ; DCQ     0
    DQ 0
    ; DCQ     XDOT_INCLUDED, 0
    DQ OFFSET XDOT_INCLUDED, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDOT_INCLUDED
    DQ OFFSET row_XDOT_INCLUDED
BOOTPTR ENDS
.CODE
XDOT_INCLUDED:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_dot_included
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
    call host_dot_included
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
nm_XINCLUDE_PAREN:
    ; DCB "(INCLUDE)", 0
    DB "(INCLUDE)", 0
hl_XINCLUDE_PAREN:
    ; DCB "(INCLUDE) ( -- ) bare INCLUDE opens a file dialog", 0
    DB "(INCLUDE) ( -- ) bare INCLUDE opens a file dialog", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XINCLUDE_PAREN:
    ; DCQ     nm_XINCLUDE_PAREN, hl_XINCLUDE_PAREN
    DQ OFFSET nm_XINCLUDE_PAREN, OFFSET hl_XINCLUDE_PAREN
    ; DCQ     0
    DQ 0
    ; DCQ     XINCLUDE_PAREN, 0
    DQ OFFSET XINCLUDE_PAREN, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XINCLUDE_PAREN
    DQ OFFSET row_XINCLUDE_PAREN
BOOTPTR ENDS
.CODE
XINCLUDE_PAREN:
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
    ; add     x0, sp, #48
    mov rax, rsp
    add rax, 30h
    mov QWORD PTR arm_x0, rax
    ; bl      host_include_dialog
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
    call host_include_dialog
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; cbz     x0, _inc_none
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _inc_none
    ; str     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldr     x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; str     x1, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x0, req_included_name
    lea rax, req_included_name
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #8
    mov rax, 8
    mov QWORD PTR arm_x1, rax
    ; bl      _find_word
    lea rax, xret_121
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_121:
    ; cbz     x0, _inc_none
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _inc_none
    ; ldr     x2, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
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
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; str     x2, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; mov     x20, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x20, rax
    ; mov     x21, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x21, rax
    ; ldr     x5, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; br      x5
    mov rax, QWORD PTR arm_x5
    jmp rax
_inc_none:
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
nm_XREQUIRED:
    ; DCB "REQUIRED", 0
    DB "REQUIRED", 0
hl_XREQUIRED:
    ; DCB "REQUIRED ( c-addr u -- ) INCLUDED unless this path was loaded", 0
    DB "REQUIRED ( c-addr u -- ) INCLUDED unless this path was loaded", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XREQUIRED:
    ; DCQ     nm_XREQUIRED, hl_XREQUIRED
    DQ OFFSET nm_XREQUIRED, OFFSET hl_XREQUIRED
    ; DCQ     0
    DQ 0
    ; DCQ     XREQUIRED, 0
    DQ OFFSET XREQUIRED, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XREQUIRED
    DQ OFFSET row_XREQUIRED
BOOTPTR ENDS
.CODE
XREQUIRED:
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
    ; cbz     x1, _req_drop
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _req_drop
    ; lea x2, resolve_buf
    lea rax, resolve_buf
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #256
    mov rax, 100h
    mov QWORD PTR arm_x3, rax
    ; bl      host_resolve
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
    call host_resolve
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; cbz     x0, _req_drop
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _req_drop
    ; str     x0, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x0, resolve_buf
    lea rax, resolve_buf
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; bl      host_was_included
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
    call host_was_included
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; cbnz    x0, _req_drop
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _req_drop
    ; lea x0, req_included_name
    lea rax, req_included_name
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #8
    mov rax, 8
    mov QWORD PTR arm_x1, rax
    ; bl      _find_word
    lea rax, xret_122
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_122:
    ; cbz     x0, _req_drop
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _req_drop
    ; ldr     x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, resolve_buf
    lea rax, resolve_buf
    mov QWORD PTR arm_x2, rax
    ; str     x2, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; mov     x20, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x20, rax
    ; mov     x21, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x21, rax
    ; ldr     x5, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
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
    ; br      x5
    mov rax, QWORD PTR arm_x5
    jmp rax
_req_drop:
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
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
nm_XFORGET:
    ; DCB "FORGET", 0
    DB "FORGET", 0
hl_XFORGET:
    ; DCB "FORGET ( name -- ) remove that word and everything newer", 0
    DB "FORGET ( name -- ) remove that word and everything newer", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFORGET:
    ; DCQ     nm_XFORGET, hl_XFORGET
    DQ OFFSET nm_XFORGET, OFFSET hl_XFORGET
    ; DCQ     0
    DQ 0
    ; DCQ     XFORGET, 0
    DQ OFFSET XFORGET, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFORGET
    DQ OFFSET row_XFORGET
BOOTPTR ENDS
.CODE
XFORGET:
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
    ; bl      _next_word
    lea rax, xret_123
    mov QWORD PTR arm_x30, rax
    jmp _next_word
    xret_123:
    ; cbz     x1, _forget_empty
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _forget_empty
    ; stp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; bl      _find_word
    lea rax, xret_124
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_124:
    ; cbz     x0, _forget_undef
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _forget_undef
    ; lea x1, words_user_base
    lea rax, words_user_base
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, _forget_fence
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne _forget_fence
    ; lea x1, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR arm_x1, rax
_forget_fence:
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _forget_prot
    cmp BYTE PTR arm_c, 0
    je _forget_prot
    ; lea x2, forget_cut
    lea rax, forget_cut
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x1, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x0, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; bl      _prune_wid
    lea rax, xret_125
    mov QWORD PTR arm_x30, rax
    jmp _prune_wid
    xret_125:
    ; lea x3, current_var
    lea rax, current_var
    mov QWORD PTR arm_x3, rax
    ; ldr     x0, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _forget_search
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _forget_search
    ; lea x2, forget_cut
    lea rax, forget_cut
    mov QWORD PTR arm_x2, rax
    ; ldr     x1, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; bl      _prune_wid
    lea rax, xret_126
    mov QWORD PTR arm_x30, rax
    jmp _prune_wid
    xret_126:
_forget_search:
    ; lea x2, search_order_n
    lea rax, search_order_n
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; lea x3, search_order
    lea rax, search_order
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
_forget_sloop:
    ; cmp     x4, x2
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _forget_regs
    cmp BYTE PTR arm_c, 0
    jne _forget_regs
    ; ldr     x0, [x3, x4, lsl #3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _forget_snext
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _forget_snext
    ; stp     x2, x3, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10+8], rax
    ; stp     x4, xzr, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10+0], rax
    mov QWORD PTR [r10+8], 0
    ; lea x1, forget_cut
    lea rax, forget_cut
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; bl      _prune_wid
    lea rax, xret_127
    mov QWORD PTR arm_x30, rax
    jmp _prune_wid
    xret_127:
    ; ldp     x4, xzr, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x4, rax
    add rsp, 10h
    ; ldp     x2, x3, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x2, rax
    mov QWORD PTR arm_x3, rcx
    add rsp, 10h
_forget_snext:
    ; add     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; b       _forget_sloop
    jmp _forget_sloop
_forget_regs:
    ; lea x2, wordlist_reg_n
    lea rax, wordlist_reg_n
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; lea x3, wordlist_reg
    lea rax, wordlist_reg
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
_forget_rloop:
    ; cmp     x4, x2
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _forget_done
    cmp BYTE PTR arm_c, 0
    jne _forget_done
    ; ldr     x0, [x3, x4, lsl #3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _forget_rnext
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _forget_rnext
    ; stp     x2, x3, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10+8], rax
    ; stp     x4, xzr, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10+0], rax
    mov QWORD PTR [r10+8], 0
    ; lea x1, forget_cut
    lea rax, forget_cut
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; bl      _prune_wid
    lea rax, xret_128
    mov QWORD PTR arm_x30, rax
    jmp _prune_wid
    xret_128:
    ; ldp     x4, xzr, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x4, rax
    add rsp, 10h
    ; ldp     x2, x3, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x2, rax
    mov QWORD PTR arm_x3, rcx
    add rsp, 10h
_forget_rnext:
    ; add     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; b       _forget_rloop
    jmp _forget_rloop
_forget_done:
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
_forget_prot:
    ; lea x0, str_protected
    lea rax, str_protected
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_129
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_129:
    ; b       _forget_done
    jmp _forget_done
_forget_empty:
    ; lea x0, msg_huh
    lea rax, msg_huh
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_130
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_130:
    ; b       _forget_done
    jmp _forget_done
_forget_undef:
    ; ldp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; bl      emit_str
    lea rax, xret_131
    mov QWORD PTR arm_x30, rax
    jmp emit_str
    xret_131:
    ; lea x0, msg_huh
    lea rax, msg_huh
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_132
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_132:
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
    ; b       _quit_exit
    jmp _quit_exit
_prune_wid:
    ; cbz     x0, _prune_ret
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _prune_ret
    ; mov     x3, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x4, rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
_prune_thread:
    ; cmp     x5, #16
    mov rax, QWORD PTR arm_x5
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _prune_ret
    cmp BYTE PTR arm_c, 0
    jne _prune_ret
    ; add     x0, x3, x5, lsl #3
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    shl rcx, 3
    add rax, rcx
    mov QWORD PTR arm_x0, rax
_prune_head:
    ; ldr     x2, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, _prune_next
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je _prune_next
    ; cmp     x2, x4
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x4
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _prune_next
    cmp BYTE PTR arm_c, 0
    je _prune_next
    ; ldr     x2, [x2, #-16]
    mov r10, QWORD PTR arm_x2
    add r10, -16
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; str     x2, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; b       _prune_head
    jmp _prune_head
_prune_next:
    ; add     x5, x5, #1
    mov rax, QWORD PTR arm_x5
    add rax, 1
    mov QWORD PTR arm_x5, rax
    ; b       _prune_thread
    jmp _prune_thread
_prune_ret:
    ; ret
    jmp QWORD PTR arm_x30
BWSTR SEGMENT ALIGN(1) READ
nm_XBLOCK_FILE:
    ; DCB "BLOCK-FILE", 0
    DB "BLOCK-FILE", 0
hl_XBLOCK_FILE:
    ; DCB "BLOCK-FILE ( -- addr ) current block fileid", 0
    DB "BLOCK-FILE ( -- addr ) current block fileid", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBLOCK_FILE:
    ; DCQ     nm_XBLOCK_FILE, hl_XBLOCK_FILE
    DQ OFFSET nm_XBLOCK_FILE, OFFSET hl_XBLOCK_FILE
    ; DCQ     0
    DQ 0
    ; DCQ     XBLOCK_FILE, 0
    DQ OFFSET XBLOCK_FILE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBLOCK_FILE
    DQ OFFSET row_XBLOCK_FILE
BOOTPTR ENDS
.CODE
XBLOCK_FILE:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, block_file
    lea rax, block_file
    mov QWORD PTR arm_x0, rax
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
nm_XBLOCK_BUF:
    ; DCB "(BLOCK-BUF)", 0
    DB "(BLOCK-BUF)", 0
hl_XBLOCK_BUF:
    ; DCB "(BLOCK-BUF) ( -- addr ) 1024-byte block buffer", 0
    DB "(BLOCK-BUF) ( -- addr ) 1024-byte block buffer", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBLOCK_BUF:
    ; DCQ     nm_XBLOCK_BUF, hl_XBLOCK_BUF
    DQ OFFSET nm_XBLOCK_BUF, OFFSET hl_XBLOCK_BUF
    ; DCQ     0
    DQ 0
    ; DCQ     XBLOCK_BUF, 0
    DQ OFFSET XBLOCK_BUF, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBLOCK_BUF
    DQ OFFSET row_XBLOCK_BUF
BOOTPTR ENDS
.CODE
XBLOCK_BUF:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, block_buf
    lea rax, block_buf
    mov QWORD PTR arm_x0, rax
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
nm_XBLOCK_UPD:
    ; DCB "(BLOCK-UPD)", 0
    DB "(BLOCK-UPD)", 0
hl_XBLOCK_UPD:
    ; DCB "(BLOCK-UPD) ( -- addr ) block-buffer dirty flag", 0
    DB "(BLOCK-UPD) ( -- addr ) block-buffer dirty flag", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBLOCK_UPD:
    ; DCQ     nm_XBLOCK_UPD, hl_XBLOCK_UPD
    DQ OFFSET nm_XBLOCK_UPD, OFFSET hl_XBLOCK_UPD
    ; DCQ     0
    DQ 0
    ; DCQ     XBLOCK_UPD, 0
    DQ OFFSET XBLOCK_UPD, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBLOCK_UPD
    DQ OFFSET row_XBLOCK_UPD
BOOTPTR ENDS
.CODE
XBLOCK_UPD:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, block_upd
    lea rax, block_upd
    mov QWORD PTR arm_x0, rax
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
nm_XBLOCK_NR:
    ; DCB "(BLOCK-NR)", 0
    DB "(BLOCK-NR)", 0
hl_XBLOCK_NR:
    ; DCB "(BLOCK-NR) ( -- addr ) current block number", 0
    DB "(BLOCK-NR) ( -- addr ) current block number", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBLOCK_NR:
    ; DCQ     nm_XBLOCK_NR, hl_XBLOCK_NR
    DQ OFFSET nm_XBLOCK_NR, OFFSET hl_XBLOCK_NR
    ; DCQ     0
    DQ 0
    ; DCQ     XBLOCK_NR, 0
    DQ OFFSET XBLOCK_NR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBLOCK_NR
    DQ OFFSET row_XBLOCK_NR
BOOTPTR ENDS
.CODE
XBLOCK_NR:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, block_nr
    lea rax, block_nr
    mov QWORD PTR arm_x0, rax
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
nm_XBLK:
    ; DCB "BLK", 0
    DB "BLK", 0
hl_XBLK:
    ; DCB "BLK ( -- addr ) block being loaded or zero", 0
    DB "BLK ( -- addr ) block being loaded or zero", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBLK:
    ; DCQ     nm_XBLK, hl_XBLK
    DQ OFFSET nm_XBLK, OFFSET hl_XBLK
    ; DCQ     0
    DQ 0
    ; DCQ     XBLK, 0
    DQ OFFSET XBLK, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBLK
    DQ OFFSET row_XBLK
BOOTPTR ENDS
.CODE
XBLK:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, blk_var
    lea rax, blk_var
    mov QWORD PTR arm_x0, rax
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
nm_XSCR:
    ; DCB "SCR", 0
    DB "SCR", 0
hl_XSCR:
    ; DCB "SCR ( -- addr ) last listed block number", 0
    DB "SCR ( -- addr ) last listed block number", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSCR:
    ; DCQ     nm_XSCR, hl_XSCR
    DQ OFFSET nm_XSCR, OFFSET hl_XSCR
    ; DCQ     0
    DQ 0
    ; DCQ     XSCR, 0
    DQ OFFSET XSCR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSCR
    DQ OFFSET row_XSCR
BOOTPTR ENDS
.CODE
XSCR:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, scr_var
    lea rax, scr_var
    mov QWORD PTR arm_x0, rax
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
nm_XLOAD_ENTER:
    ; DCB "(LOAD-ENTER)", 0
    DB "(LOAD-ENTER)", 0
hl_XLOAD_ENTER:
    ; DCB "(LOAD-ENTER) ( u -- u ) save SOURCE and set BLK", 0
    DB "(LOAD-ENTER) ( u -- u ) save SOURCE and set BLK", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOAD_ENTER:
    ; DCQ     nm_XLOAD_ENTER, hl_XLOAD_ENTER
    DQ OFFSET nm_XLOAD_ENTER, OFFSET hl_XLOAD_ENTER
    ; DCQ     0
    DQ 0
    ; DCQ     XLOAD_ENTER, 0
    DQ OFFSET XLOAD_ENTER, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOAD_ENTER
    DQ OFFSET row_XLOAD_ENTER
BOOTPTR ENDS
.CODE
XLOAD_ENTER:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _push_source
    lea rax, xret_133
    mov QWORD PTR arm_x30, rax
    jmp _push_source
    xret_133:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; lea x0, blk_var
    lea rax, blk_var
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x20
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
nm_XLOAD_RUN:
    ; DCB "(LOAD-RUN)", 0
    DB "(LOAD-RUN)", 0
hl_XLOAD_RUN:
    ; DCB "(LOAD-RUN) ( c-addr u -- ) interpret a block buffer", 0
    DB "(LOAD-RUN) ( c-addr u -- ) interpret a block buffer", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLOAD_RUN:
    ; DCQ     nm_XLOAD_RUN, hl_XLOAD_RUN
    DQ OFFSET nm_XLOAD_RUN, OFFSET hl_XLOAD_RUN
    ; DCQ     0
    DQ 0
    ; DCQ     XLOAD_RUN, 0
    DQ OFFSET XLOAD_RUN, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLOAD_RUN
    DQ OFFSET row_XLOAD_RUN
BOOTPTR ENDS
.CODE
XLOAD_RUN:
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
    ; stp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; ldp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; lea x2, source_base
    lea rax, source_base
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, source_cur
    lea rax, source_cur
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; add     x0, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; lea x2, source_end
    lea rax, source_end
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, to_in
    lea rax, to_in
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, source_id
    lea rax, source_id
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #-1
    mov rax, -1
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; bl      _eval_resume_push
    lea rax, xret_134
    mov QWORD PTR arm_x30, rax
    jmp _eval_resume_push
    xret_134:
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
    ; b       _interpret_loop
    jmp _interpret_loop
BWSTR SEGMENT ALIGN(1) READ
nm_XRBRA:
    ; DCB "]", 0
    DB "]", 0
hl_XRBRA:
    ; DCB "] ( -- ) enter compile mode", 0
    DB "] ( -- ) enter compile mode", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRBRA:
    ; DCQ     nm_XRBRA, hl_XRBRA
    DQ OFFSET nm_XRBRA, OFFSET hl_XRBRA
    ; DCQ     0
    DQ 0
    ; DCQ     XRBRA, 0
    DQ OFFSET XRBRA, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRBRA
    DQ OFFSET row_XRBRA
BOOTPTR ENDS
.CODE
XRBRA:
    ; lea x0, state_var
    lea rax, state_var
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
nm_XLBRA:
    ; DCB "[", 0
    DB "[", 0
hl_XLBRA:
    ; DCB "[ ( -- ) enter interpret mode", 0
    DB "[ ( -- ) enter interpret mode", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLBRA:
    ; DCQ     nm_XLBRA, hl_XLBRA
    DQ OFFSET nm_XLBRA, OFFSET hl_XLBRA
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XLBRA, 0
    DQ OFFSET XLBRA, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLBRA
    DQ OFFSET row_XLBRA
BOOTPTR ENDS
.CODE
XLBRA:
    ; lea x0, state_var
    lea rax, state_var
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
nm_XEVALUATE:
    ; DCB "EVALUATE", 0
    DB "EVALUATE", 0
hl_XEVALUATE:
    ; DCB "EVALUATE ( i*x c-addr u -- j*x ) interpret the string as Forth source", 0
    DB "EVALUATE ( i*x c-addr u -- j*x ) interpret the string as Forth source", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XEVALUATE:
    ; DCQ     nm_XEVALUATE, hl_XEVALUATE
    DQ OFFSET nm_XEVALUATE, OFFSET hl_XEVALUATE
    ; DCQ     0
    DQ 0
    ; DCQ     XEVALUATE, 0
    DQ OFFSET XEVALUATE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XEVALUATE
    DQ OFFSET row_XEVALUATE
BOOTPTR ENDS
.CODE
XEVALUATE:
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
    ; stp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; bl      _push_source
    lea rax, xret_135
    mov QWORD PTR arm_x30, rax
    jmp _push_source
    xret_135:
    ; cbz     x0, _ev_fail
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _ev_fail
    ; ldp     x0, x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; lea x2, source_base
    lea rax, source_base
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, source_cur
    lea rax, source_cur
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; add     x0, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; lea x2, source_end
    lea rax, source_end
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, to_in
    lea rax, to_in
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, source_id
    lea rax, source_id
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #-1
    mov rax, -1
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; lea x2, blk_var
    lea rax, blk_var
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; bl      _eval_resume_push
    lea rax, xret_136
    mov QWORD PTR arm_x30, rax
    jmp _eval_resume_push
    xret_136:
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
    ; b       _interpret_loop
    jmp _interpret_loop
_ev_fail:
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
nm_XQUIT:
    ; DCB "QUIT", 0
    DB "QUIT", 0
hl_XQUIT:
    ; DCB "QUIT ( -- ) empty the return stack and return to the outer interpreter", 0
    DB "QUIT ( -- ) empty the return stack and return to the outer interpreter", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XQUIT:
    ; DCQ     nm_XQUIT, hl_XQUIT
    DQ OFFSET nm_XQUIT, OFFSET hl_XQUIT
    ; DCQ     0
    DQ 0
    ; DCQ     XQUIT, XQUIT_END
    DQ OFFSET XQUIT, OFFSET XQUIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XQUIT
    DQ OFFSET row_XQUIT
BOOTPTR ENDS
.CODE
XQUIT:
    ; b       _do_quit
    jmp _do_quit
XQUIT_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XBACKSLASH_S:
    ; DCB 0x5C, "S", 0
    DB 5Ch, "S", 0
hl_XBACKSLASH_S:
    ; DCB 0x5C, "S", "stop the rest of this source", 0
    DB 5Ch, "S", "stop the rest of this source", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XBACKSLASH_S:
    ; DCQ     nm_XBACKSLASH_S, hl_XBACKSLASH_S
    DQ OFFSET nm_XBACKSLASH_S, OFFSET hl_XBACKSLASH_S
    ; DCD     0, FLAG_IMM
    DD 0, 80000000h
    ; DCQ     XBACKSLASH_S, 0
    DQ OFFSET XBACKSLASH_S, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XBACKSLASH_S
    DQ OFFSET row_XBACKSLASH_S
BOOTPTR ENDS
.CODE
XBACKSLASH_S:
    ; lea x0, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _bs_pin
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _bs_pin
    ; lea x0, line_limit
    lea rax, line_limit
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x0, line_next
    lea rax, line_next
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
_bs_pin:
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
    ; sub     x2, x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    sub rax, rcx
    mov QWORD PTR arm_x2, rax
    ; lea x0, to_in
    lea rax, to_in
    mov QWORD PTR arm_x0, rax
    ; str     x2, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; lea x0, source_cur
    lea rax, source_cur
    mov QWORD PTR arm_x0, rax
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
nm_XSOURCE_ID:
    ; DCB "SOURCE-ID", 0
    DB "SOURCE-ID", 0
hl_XSOURCE_ID:
    ; DCB "SOURCE-ID ( -- id ) 0 console -1 evaluate -2 file", 0
    DB "SOURCE-ID ( -- id ) 0 console -1 evaluate -2 file", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSOURCE_ID:
    ; DCQ     nm_XSOURCE_ID, hl_XSOURCE_ID
    DQ OFFSET nm_XSOURCE_ID, OFFSET hl_XSOURCE_ID
    ; DCQ     0
    DQ 0
    ; DCQ     XSOURCE_ID, 0
    DQ OFFSET XSOURCE_ID, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSOURCE_ID
    DQ OFFSET row_XSOURCE_ID
BOOTPTR ENDS
.CODE
XSOURCE_ID:
    ; lea x0, source_id
    lea rax, source_id
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
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
nm_XACCEPT:
    ; DCB "ACCEPT", 0
    DB "ACCEPT", 0
hl_XACCEPT:
    ; DCB "ACCEPT ( c-addr +n1 -- +n2 ) read a line into the buffer", 0
    DB "ACCEPT ( c-addr +n1 -- +n2 ) read a line into the buffer", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XACCEPT:
    ; DCQ     nm_XACCEPT, hl_XACCEPT
    DQ OFFSET nm_XACCEPT, OFFSET hl_XACCEPT
    ; DCQ     0
    DQ 0
    ; DCQ     XACCEPT, XACCEPT_END
    DQ OFFSET XACCEPT, OFFSET XACCEPT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XACCEPT
    DQ OFFSET row_XACCEPT
BOOTPTR ENDS
.CODE
XACCEPT:
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
    ; b.gt    _acc_read
    cmp BYTE PTR arm_z, 0
    jne xsk_137
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _acc_read
    xsk_137:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
    ; b       XACCEPT_END
    jmp XACCEPT_END
_acc_read:
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
    ; bl      host_accept
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
    call host_accept
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
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
    ; mov     x20, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x20, rax
XACCEPT_END:
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
nm_XTONUMBER:
    ; DCB ">NUMBER", 0
    DB ">NUMBER", 0
hl_XTONUMBER:
    ; DCB ">NUMBER ( ud1 c-addr1 u1 -- ud2 c-addr2 u2 ) convert digits in the current base", 0
    DB ">NUMBER ( ud1 c-addr1 u1 -- ud2 c-addr2 u2 ) convert digits in the current base", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTONUMBER:
    ; DCQ     nm_XTONUMBER, hl_XTONUMBER
    DQ OFFSET nm_XTONUMBER, OFFSET hl_XTONUMBER
    ; DCQ     0
    DQ 0
    ; DCQ     XTONUMBER, XTONUMBER_END
    DQ OFFSET XTONUMBER, OFFSET XTONUMBER_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTONUMBER
    DQ OFFSET row_XTONUMBER
BOOTPTR ENDS
.CODE
XTONUMBER:
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
    ; lea x5, base_var
    lea rax, base_var
    mov QWORD PTR arm_x5, rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR arm_x5
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; cmp     x5, #2
    mov rax, QWORD PTR arm_x5
    cmp rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _tn_base10
    cmp BYTE PTR arm_c, 0
    je _tn_base10
    ; cmp     x5, #36
    mov rax, QWORD PTR arm_x5
    cmp rax, 24h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _tn_loop
    cmp BYTE PTR arm_c, 0
    je _tn_loop
    cmp BYTE PTR arm_z, 0
    jne _tn_loop
_tn_base10:
    ; mov     x5, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x5, rax
_tn_loop:
    ; cbz     x4, _tn_done
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    je _tn_done
    ; ldrb    w6, [x3]
    mov r10, QWORD PTR arm_x3
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; sub     w7, w6, #48
    mov eax, DWORD PTR arm_x6
    sub eax, 30h
    mov QWORD PTR arm_x7, rax
    ; cmp     w7, #9
    mov eax, DWORD PTR arm_x7
    cmp eax, 9
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _tn_dig
    cmp BYTE PTR arm_c, 0
    je _tn_dig
    cmp BYTE PTR arm_z, 0
    jne _tn_dig
    ; cmp     w6, #'a'
    mov eax, DWORD PTR arm_x6
    cmp eax, 61h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _tn_up
    cmp BYTE PTR arm_c, 0
    je _tn_up
    ; cmp     w6, #'z'
    mov eax, DWORD PTR arm_x6
    cmp eax, 7Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _tn_done
    cmp BYTE PTR arm_c, 0
    je xsk_138
    cmp BYTE PTR arm_z, 0
    je _tn_done
    xsk_138:
    ; sub     w6, w6, #32
    mov eax, DWORD PTR arm_x6
    sub eax, 20h
    mov QWORD PTR arm_x6, rax
_tn_up:
    ; sub     w7, w6, #'A'
    mov eax, DWORD PTR arm_x6
    sub eax, 41h
    mov QWORD PTR arm_x7, rax
    ; cmp     w7, #25
    mov eax, DWORD PTR arm_x7
    cmp eax, 19h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _tn_done
    cmp BYTE PTR arm_c, 0
    je xsk_139
    cmp BYTE PTR arm_z, 0
    je _tn_done
    xsk_139:
    ; add     w7, w7, #10
    mov eax, DWORD PTR arm_x7
    add eax, 0Ah
    mov QWORD PTR arm_x7, rax
_tn_dig:
    ; cmp     x7, x5
    mov rax, QWORD PTR arm_x7
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _tn_done
    cmp BYTE PTR arm_c, 0
    jne _tn_done
    ; mul     x8, x1, x5
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x5
    imul rax, rcx
    mov QWORD PTR arm_x8, rax
    ; umulh   x9, x1, x5
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x5
    mul rcx
    mov rax, rdx
    mov QWORD PTR arm_x9, rax
    ; mul     x10, x2, x5
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x5
    imul rax, rcx
    mov QWORD PTR arm_x10, rax
    ; add     x9, x9, x10
    mov rax, QWORD PTR arm_x9
    mov rcx, QWORD PTR arm_x10
    add rax, rcx
    mov QWORD PTR arm_x9, rax
    ; adds    x1, x8, x7
    mov rax, QWORD PTR arm_x8
    mov rcx, QWORD PTR arm_x7
    add rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    mov QWORD PTR arm_x1, rax
    ; adc     x2, x9, xzr
    mov rax, QWORD PTR arm_x9
    xor ecx, ecx
    mov dl, BYTE PTR arm_c
    add dl, 255
    adc rax, rcx
    mov QWORD PTR arm_x2, rax
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; sub     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    sub rax, 1
    mov QWORD PTR arm_x4, rax
    ; b       _tn_loop
    jmp _tn_loop
_tn_done:
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
    ; str     x3, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; mov     x20, x4
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR arm_x20, rax
XTONUMBER_END:
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
nm_XENVIRONMENT_Q:
    ; DCB "ENVIRONMENT?", 0
    DB "ENVIRONMENT?", 0
hl_XENVIRONMENT_Q:
    ; DCB "ENVIRONMENT? ( c-addr u -- false | i*x true ) query an environment string", 0
    DB "ENVIRONMENT? ( c-addr u -- false | i*x true ) query an environment string", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XENVIRONMENT_Q:
    ; DCQ     nm_XENVIRONMENT_Q, hl_XENVIRONMENT_Q
    DQ OFFSET nm_XENVIRONMENT_Q, OFFSET hl_XENVIRONMENT_Q
    ; DCQ     0
    DQ 0
    ; DCQ     XENVIRONMENT_Q, 0
    DQ OFFSET XENVIRONMENT_Q, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XENVIRONMENT_Q
    DQ OFFSET row_XENVIRONMENT_Q
BOOTPTR ENDS
.CODE
XENVIRONMENT_Q:
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
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
_env_next:
    ; cmp     x4, #ENV_COUNT
    mov rax, QWORD PTR arm_x4
    cmp rax, 1Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _env_no
    cmp BYTE PTR arm_c, 0
    jne _env_no
    ; lea x5, env_name_ptrs
    lea rax, env_name_ptrs
    mov QWORD PTR arm_x5, rax
    ; ldr     x5, [x5, x4, lsl #3]
    mov r10, QWORD PTR arm_x5
    mov rax, QWORD PTR arm_x4
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; mov     x6, #0
    mov rax, 0
    mov QWORD PTR arm_x6, rax
_env_len:
    ; ldrb    w7, [x5, x6]
    mov r10, QWORD PTR arm_x5
    mov rax, QWORD PTR arm_x6
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x7, rax
    ; cbz     w7, _env_len_done
    mov eax, DWORD PTR arm_x7
    cmp rax, 0
    je _env_len_done
    ; add     x6, x6, #1
    mov rax, QWORD PTR arm_x6
    add rax, 1
    mov QWORD PTR arm_x6, rax
    ; b       _env_len
    jmp _env_len
_env_len_done:
    ; cmp     x6, x1
    mov rax, QWORD PTR arm_x6
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _env_cont
    cmp BYTE PTR arm_z, 0
    je _env_cont
    ; mov     x7, #0
    mov rax, 0
    mov QWORD PTR arm_x7, rax
_env_cmp:
    ; cmp     x7, x6
    mov rax, QWORD PTR arm_x7
    mov rcx, QWORD PTR arm_x6
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _env_yes
    cmp BYTE PTR arm_z, 0
    jne _env_yes
    ; ldrb    w8, [x5, x7]
    mov r10, QWORD PTR arm_x5
    mov rax, QWORD PTR arm_x7
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x8, rax
    ; ldrb    w9, [x0, x7]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x7
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
    ; b.ne    _env_cont
    cmp BYTE PTR arm_z, 0
    je _env_cont
    ; add     x7, x7, #1
    mov rax, QWORD PTR arm_x7
    add rax, 1
    mov QWORD PTR arm_x7, rax
    ; b       _env_cmp
    jmp _env_cmp
_env_cont:
    ; add     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; b       _env_next
    jmp _env_next
_env_yes:
    ; lea x5, env_kinds
    lea rax, env_kinds
    mov QWORD PTR arm_x5, rax
    ; ldrb    w5, [x5, x4]
    mov r10, QWORD PTR arm_x5
    mov rax, QWORD PTR arm_x4
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; lea x6, env_values
    lea rax, env_values
    mov QWORD PTR arm_x6, rax
    ; ldr     x6, [x6, x4, lsl #3]
    mov r10, QWORD PTR arm_x6
    mov rax, QWORD PTR arm_x4
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; cbz     w5, _env_flag
    mov eax, DWORD PTR arm_x5
    cmp rax, 0
    je _env_flag
    ; cmp     w5, #2
    mov eax, DWORD PTR arm_x5
    cmp eax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _env_string
    cmp BYTE PTR arm_z, 0
    jne _env_string
    ; str     x6, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; mov     x20, #-1
    mov rax, -1
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
_env_string:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
_env_slen:
    ; ldrb    w1, [x6, x0]
    mov r10, QWORD PTR arm_x6
    mov rax, QWORD PTR arm_x0
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     w1, _env_spush
    mov eax, DWORD PTR arm_x1
    cmp rax, 0
    je _env_spush
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; b       _env_slen
    jmp _env_slen
_env_spush:
    ; str     x6, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; str     x0, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; mov     x20, #-1
    mov rax, -1
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
_env_flag:
    ; mov     x20, x6
    mov rax, QWORD PTR arm_x6
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
_env_no:
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
nm_XSAVE_INPUT:
    ; DCB "SAVE-INPUT", 0
    DB "SAVE-INPUT", 0
hl_XSAVE_INPUT:
    ; DCB "SAVE-INPUT ( -- xn .. x1 n ) save the current input source", 0
    DB "SAVE-INPUT ( -- xn .. x1 n ) save the current input source", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSAVE_INPUT:
    ; DCQ     nm_XSAVE_INPUT, hl_XSAVE_INPUT
    DQ OFFSET nm_XSAVE_INPUT, OFFSET hl_XSAVE_INPUT
    ; DCQ     0
    DQ 0
    ; DCQ     XSAVE_INPUT, 0
    DQ OFFSET XSAVE_INPUT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSAVE_INPUT
    DQ OFFSET row_XSAVE_INPUT
BOOTPTR ENDS
.CODE
XSAVE_INPUT:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, source_base
    lea rax, source_base
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x1, source_end
    lea rax, source_end
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; sub     x20, x1, x20
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x20
    sub rax, rcx
    mov QWORD PTR arm_x20, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, to_in
    lea rax, to_in
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, source_id
    lea rax, source_id
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, blk_var
    lea rax, blk_var
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, #5
    mov rax, 5
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
nm_XRESTORE_INPUT:
    ; DCB "RESTORE-INPUT", 0
    DB "RESTORE-INPUT", 0
hl_XRESTORE_INPUT:
    ; DCB "RESTORE-INPUT ( xn .. x1 n -- flag ) restore input source. 0 means ok", 0
    DB "RESTORE-INPUT ( xn .. x1 n -- flag ) restore input source. 0 means ok", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRESTORE_INPUT:
    ; DCQ     nm_XRESTORE_INPUT, hl_XRESTORE_INPUT
    DQ OFFSET nm_XRESTORE_INPUT, OFFSET hl_XRESTORE_INPUT
    ; DCQ     0
    DQ 0
    ; DCQ     XRESTORE_INPUT, 0
    DQ OFFSET XRESTORE_INPUT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRESTORE_INPUT
    DQ OFFSET row_XRESTORE_INPUT
BOOTPTR ENDS
.CODE
XRESTORE_INPUT:
    ; cmp     x20, #5
    mov rax, QWORD PTR arm_x20
    cmp rax, 5
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _ri_n5
    cmp BYTE PTR arm_z, 0
    jne _ri_n5
    ; cmp     x20, #4
    mov rax, QWORD PTR arm_x20
    cmp rax, 4
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _ri_fail
    cmp BYTE PTR arm_z, 0
    je _ri_fail
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR arm_x5, rax
    ; b       _ri_common
    jmp _ri_common
_ri_n5:
    ; ldr     x5, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
_ri_common:
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
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
    ; ldr     x2, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
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
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; lea x4, blk_var
    lea rax, blk_var
    mov QWORD PTR arm_x4, rax
    ; str     x5, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10], rax
    ; cbz     x5, _ri_apply
    mov rax, QWORD PTR arm_x5
    cmp rax, 0
    je _ri_apply
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x0, x1, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; str     x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x0, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x0, rax
    ; bl      _block_load_nr
    lea rax, xret_140
    mov QWORD PTR arm_x30, rax
    jmp _block_load_nr
    xret_140:
    ; ldp     x0, x1, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; ldr     x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; ldp     x29, x30, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; lea x3, block_buf
    lea rax, block_buf
    mov QWORD PTR arm_x3, rax
    ; mov     x2, #1024
    mov rax, 400h
    mov QWORD PTR arm_x2, rax
_ri_apply:
    ; lea x4, source_base
    lea rax, source_base
    mov QWORD PTR arm_x4, rax
    ; str     x3, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; lea x4, source_cur
    lea rax, source_cur
    mov QWORD PTR arm_x4, rax
    ; add     x6, x3, x1
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x1
    add rax, rcx
    mov QWORD PTR arm_x6, rax
    ; str     x6, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; add     x6, x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x6, rax
    ; lea x4, source_end
    lea rax, source_end
    mov QWORD PTR arm_x4, rax
    ; str     x6, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [r10], rax
    ; lea x4, to_in
    lea rax, to_in
    mov QWORD PTR arm_x4, rax
    ; str     x1, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x4, source_id
    lea rax, source_id
    mov QWORD PTR arm_x4, rax
    ; str     x0, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x4, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x4, rax
    ; ldr     x4, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     x4, _ri_ok
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    je _ri_ok
    ; lea x4, line_limit
    lea rax, line_limit
    mov QWORD PTR arm_x4, rax
    ; ldr     x5, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; add     x3, x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    add rax, rcx
    mov QWORD PTR arm_x3, rax
    ; cmp     x3, x5
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _ri_next
    cmp BYTE PTR arm_c, 0
    jne _ri_next
    ; ldrb    w4, [x3]
    mov r10, QWORD PTR arm_x3
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _ri_nl
    cmp BYTE PTR arm_z, 0
    jne _ri_nl
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _ri_next
    cmp BYTE PTR arm_z, 0
    je _ri_next
    ; add     x4, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x4, rax
    ; cmp     x4, x5
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x5
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _ri_next
    cmp BYTE PTR arm_c, 0
    jne _ri_next
    ; ldrb    w6, [x4]
    mov r10, QWORD PTR arm_x4
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; cmp     w6, #10
    mov eax, DWORD PTR arm_x6
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _ri_next
    cmp BYTE PTR arm_z, 0
    je _ri_next
    ; add     x3, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _ri_next
    jmp _ri_next
_ri_nl:
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
_ri_next:
    ; lea x4, line_next
    lea rax, line_next
    mov QWORD PTR arm_x4, rax
    ; str     x3, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
_ri_ok:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
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
_ri_fail:
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
_ri_drop:
    ; cbz     x1, _ri_bad
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _ri_bad
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _ri_drop
    jmp _ri_drop
_ri_bad:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x20, #-1
    mov rax, -1
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
nm_XNTOR:
    ; DCB "N>R", 0
    DB "N>R", 0
hl_XNTOR:
    ; DCB "N>R ( xn .. x1 n -- ) ( R: -- xn .. x1 n ) move n items and the count to the return stack", 0
    DB "N>R ( xn .. x1 n -- ) ( R: -- xn .. x1 n ) move n items and the count to the return stack", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XNTOR:
    ; DCQ     nm_XNTOR, hl_XNTOR
    DQ OFFSET nm_XNTOR, OFFSET hl_XNTOR
    ; DCQ     0
    DQ 0
    ; DCQ     XNTOR, 0
    DQ OFFSET XNTOR, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XNTOR
    DQ OFFSET row_XNTOR
BOOTPTR ENDS
.CODE
XNTOR:
    ; mov     x5, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x5, rax
    ; mov     x1, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x1, rax
_ntor_loop:
    ; cbz     x1, _ntor_count
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _ntor_count
    ; ldr     x2, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; str     x2, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _ntor_loop
    jmp _ntor_loop
_ntor_count:
    ; str     x5, [x23, #-8]!
    mov rax, QWORD PTR arm_x23
    add rax, -8
    mov QWORD PTR arm_x23, rax
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR arm_x5
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
nm_XNRFROM:
    ; DCB "NR>", 0
    DB "NR>", 0
hl_XNRFROM:
    ; DCB "NR> ( -- xn .. x1 n ) ( R: xn .. x1 n -- ) restore n items and the count", 0
    DB "NR> ( -- xn .. x1 n ) ( R: xn .. x1 n -- ) restore n items and the count", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XNRFROM:
    ; DCQ     nm_XNRFROM, hl_XNRFROM
    DQ OFFSET nm_XNRFROM, OFFSET hl_XNRFROM
    ; DCQ     0
    DQ 0
    ; DCQ     XNRFROM, 0
    DQ OFFSET XNRFROM, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XNRFROM
    DQ OFFSET row_XNRFROM
BOOTPTR ENDS
.CODE
XNRFROM:
    ; ldr     x5, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; mov     x1, x5
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR arm_x1, rax
_nrfrom_loop:
    ; cbz     x1, _nrfrom_count
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _nrfrom_count
    ; ldr     x2, [x23], #8
    mov r10, QWORD PTR arm_x23
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x23
    add rax, 8
    mov QWORD PTR arm_x23, rax
    ; str     x2, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _nrfrom_loop
    jmp _nrfrom_loop
_nrfrom_count:
    ; mov     x20, x5
    mov rax, QWORD PTR arm_x5
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
nm_XCSPICK:
    ; DCB "CS-PICK", 0
    DB "CS-PICK", 0
hl_XCSPICK:
    ; DCB "CS-PICK ( i*x u -- i*x x_u ) copy the uth control-flow item", 0
    DB "CS-PICK ( i*x u -- i*x x_u ) copy the uth control-flow item", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCSPICK:
    ; DCQ     nm_XCSPICK, hl_XCSPICK
    DQ OFFSET nm_XCSPICK, OFFSET hl_XCSPICK
    ; DCQ     0
    DQ 0
    ; DCQ     XCSPICK, 0
    DQ OFFSET XCSPICK, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCSPICK
    DQ OFFSET row_XCSPICK
BOOTPTR ENDS
.CODE
XCSPICK:
    ; b       XPICK
    jmp XPICK
BWSTR SEGMENT ALIGN(1) READ
nm_XCSROLL:
    ; DCB "CS-ROLL", 0
    DB "CS-ROLL", 0
hl_XCSROLL:
    ; DCB "CS-ROLL ( xu .. x0 u -- xu-1 .. x0 xu ) rotate the uth control-flow item to the top", 0
    DB "CS-ROLL ( xu .. x0 u -- xu-1 .. x0 xu ) rotate the uth control-flow item to the top", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCSROLL:
    ; DCQ     nm_XCSROLL, hl_XCSROLL
    DQ OFFSET nm_XCSROLL, OFFSET hl_XCSROLL
    ; DCQ     0
    DQ 0
    ; DCQ     XCSROLL, 0
    DQ OFFSET XCSROLL, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCSROLL
    DQ OFFSET row_XCSROLL
BOOTPTR ENDS
.CODE
XCSROLL:
    ; b       XROLL
    jmp XROLL
BWSTR SEGMENT ALIGN(1) READ
nm_XNAME_INTERPRET:
    ; DCB "NAME>INTERPRET", 0
    DB "NAME>INTERPRET", 0
hl_XNAME_INTERPRET:
    ; DCB "NAME>INTERPRET ( nt -- xt | 0 ) interpretation xt for a name token", 0
    DB "NAME>INTERPRET ( nt -- xt | 0 ) interpretation xt for a name token", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XNAME_INTERPRET:
    ; DCQ     nm_XNAME_INTERPRET, hl_XNAME_INTERPRET
    DQ OFFSET nm_XNAME_INTERPRET, OFFSET hl_XNAME_INTERPRET
    ; DCQ     0
    DQ 0
    ; DCQ     XNAME_INTERPRET, 0
    DQ OFFSET XNAME_INTERPRET, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XNAME_INTERPRET
    DQ OFFSET row_XNAME_INTERPRET
BOOTPTR ENDS
.CODE
XNAME_INTERPRET:
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
nm_XNAME_COMPILE:
    ; DCB "NAME>COMPILE", 0
    DB "NAME>COMPILE", 0
hl_XNAME_COMPILE:
    ; DCB "NAME>COMPILE ( nt -- x xt ) compilation semantics pair for a name token", 0
    DB "NAME>COMPILE ( nt -- x xt ) compilation semantics pair for a name token", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XNAME_COMPILE:
    ; DCQ     nm_XNAME_COMPILE, hl_XNAME_COMPILE
    DQ OFFSET nm_XNAME_COMPILE, OFFSET hl_XNAME_COMPILE
    ; DCQ     0
    DQ 0
    ; DCQ     XNAME_COMPILE, 0
    DQ OFFSET XNAME_COMPILE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XNAME_COMPILE
    DQ OFFSET row_XNAME_COMPILE
BOOTPTR ENDS
.CODE
XNAME_COMPILE:
    ; mov     x5, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x5, rax
    ; ldr     x0, [x5, #-8]
    mov r10, QWORD PTR arm_x5
    add r10, -8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; tbnz    x0, #63, _nc_imm
    mov rax, QWORD PTR arm_x0
    bt rax, 63
    jc _nc_imm
    ; lea x1, cfa_comma
    lea rax, cfa_comma
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; str     x5, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x5
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
_nc_imm:
    ; lea x1, cfa_execute
    lea rax, cfa_execute
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; str     x5, [x22, #-8]!
    mov rax, QWORD PTR arm_x22
    add rax, -8
    mov QWORD PTR arm_x22, rax
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR arm_x5
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
nm_XLIBRARY_PATH:
    ; DCB "LIBRARY-PATH", 0
    DB "LIBRARY-PATH", 0
hl_XLIBRARY_PATH:
    ; DCB "LIBRARY-PATH ( -- c-addr u ) absolute Library directory", 0
    DB "LIBRARY-PATH ( -- c-addr u ) absolute Library directory", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XLIBRARY_PATH:
    ; DCQ     nm_XLIBRARY_PATH, hl_XLIBRARY_PATH
    DQ OFFSET nm_XLIBRARY_PATH, OFFSET hl_XLIBRARY_PATH
    ; DCQ     0
    DQ 0
    ; DCQ     XLIBRARY_PATH, XLIBRARY_PATH_END
    DQ OFFSET XLIBRARY_PATH, OFFSET XLIBRARY_PATH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XLIBRARY_PATH
    DQ OFFSET row_XLIBRARY_PATH
BOOTPTR ENDS
.CODE
XLIBRARY_PATH:
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
    ; lea x0, library_path_buf
    lea rax, library_path_buf
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #1024
    mov rax, 400h
    mov QWORD PTR arm_x1, rax
    ; bl      host_library_path
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
    call host_library_path
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; mov     x1, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x1, rax
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
    ; lea x0, library_path_buf
    lea rax, library_path_buf
    mov QWORD PTR arm_x0, rax
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
XLIBRARY_PATH_END:
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
nm_XPAGE:
    ; DCB "PAGE", 0
    DB "PAGE", 0
hl_XPAGE:
    ; DCB "PAGE ( -- ) clear facility terminal and home cursor", 0
    DB "PAGE ( -- ) clear facility terminal and home cursor", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPAGE:
    ; DCQ     nm_XPAGE, hl_XPAGE
    DQ OFFSET nm_XPAGE, OFFSET hl_XPAGE
    ; DCQ     0
    DQ 0
    ; DCQ     XPAGE, XPAGE_END
    DQ OFFSET XPAGE, OFFSET XPAGE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPAGE
    DQ OFFSET row_XPAGE
BOOTPTR ENDS
.CODE
XPAGE:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; b       _facility_op_go
    jmp _facility_op_go
XPAGE_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XAT_XY:
    ; DCB "AT-XY", 0
    DB "AT-XY", 0
hl_XAT_XY:
    ; DCB "AT-XY ( u1 u2 -- ) facility cursor to column u1 row u2", 0
    DB "AT-XY ( u1 u2 -- ) facility cursor to column u1 row u2", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAT_XY:
    ; DCQ     nm_XAT_XY, hl_XAT_XY
    DQ OFFSET nm_XAT_XY, OFFSET hl_XAT_XY
    ; DCQ     0
    DQ 0
    ; DCQ     XAT_XY, XAT_XY_END
    DQ OFFSET XAT_XY, OFFSET XAT_XY_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAT_XY
    DQ OFFSET row_XAT_XY
BOOTPTR ENDS
.CODE
XAT_XY:
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
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #2
    mov rax, 2
    mov QWORD PTR arm_x0, rax
    ; b       _facility_op_go
    jmp _facility_op_go
XAT_XY_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XAT_XY_Q:
    ; DCB "AT-XY?", 0
    DB "AT-XY?", 0
hl_XAT_XY_Q:
    ; DCB "AT-XY? ( -- col row ) facility cursor position", 0
    DB "AT-XY? ( -- col row ) facility cursor position", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XAT_XY_Q:
    ; DCQ     nm_XAT_XY_Q, hl_XAT_XY_Q
    DQ OFFSET nm_XAT_XY_Q, OFFSET hl_XAT_XY_Q
    ; DCQ     0
    DQ 0
    ; DCQ     XAT_XY_Q, XAT_XY_Q_END
    DQ OFFSET XAT_XY_Q, OFFSET XAT_XY_Q_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XAT_XY_Q
    DQ OFFSET row_XAT_XY_Q
BOOTPTR ENDS
.CODE
XAT_XY_Q:
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
    ; bl      host_facility_xy
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
    call host_facility_xy
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
XAT_XY_Q_END:
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
nm_XCLIP_STORE:
    ; DCB "CLIP!", 0
    DB "CLIP!", 0
hl_XCLIP_STORE:
    ; DCB "CLIP! ( c-addr u -- ) set host clipboard", 0
    DB "CLIP! ( c-addr u -- ) set host clipboard", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCLIP_STORE:
    ; DCQ     nm_XCLIP_STORE, hl_XCLIP_STORE
    DQ OFFSET nm_XCLIP_STORE, OFFSET hl_XCLIP_STORE
    ; DCQ     0
    DQ 0
    ; DCQ     XCLIP_STORE, XCLIP_STORE_END
    DQ OFFSET XCLIP_STORE, OFFSET XCLIP_STORE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCLIP_STORE
    DQ OFFSET row_XCLIP_STORE
BOOTPTR ENDS
.CODE
XCLIP_STORE:
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
    ; bl      host_clip_set
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
    call host_clip_set
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
XCLIP_STORE_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XCLIP_FETCH:
    ; DCB "CLIP@", 0
    DB "CLIP@", 0
hl_XCLIP_FETCH:
    ; DCB "CLIP@ ( c-addr max -- u ) fetch host clipboard", 0
    DB "CLIP@ ( c-addr max -- u ) fetch host clipboard", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCLIP_FETCH:
    ; DCQ     nm_XCLIP_FETCH, hl_XCLIP_FETCH
    DQ OFFSET nm_XCLIP_FETCH, OFFSET hl_XCLIP_FETCH
    ; DCQ     0
    DQ 0
    ; DCQ     XCLIP_FETCH, XCLIP_FETCH_END
    DQ OFFSET XCLIP_FETCH, OFFSET XCLIP_FETCH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCLIP_FETCH
    DQ OFFSET row_XCLIP_FETCH
BOOTPTR ENDS
.CODE
XCLIP_FETCH:
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
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_clip_get
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
    call host_clip_get
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
XCLIP_FETCH_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XTERM_REFRESH:
    ; DCB "TERMINAL-REFRESH", 0
    DB "TERMINAL-REFRESH", 0
hl_XTERM_REFRESH:
    ; DCB "TERMINAL-REFRESH ( -- ) paint facility terminal to host console", 0
    DB "TERMINAL-REFRESH ( -- ) paint facility terminal to host console", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTERM_REFRESH:
    ; DCQ     nm_XTERM_REFRESH, hl_XTERM_REFRESH
    DQ OFFSET nm_XTERM_REFRESH, OFFSET hl_XTERM_REFRESH
    ; DCQ     0
    DQ 0
    ; DCQ     XTERM_REFRESH, 0
    DQ OFFSET XTERM_REFRESH, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTERM_REFRESH
    DQ OFFSET row_XTERM_REFRESH
BOOTPTR ENDS
.CODE
XTERM_REFRESH:
    ; mov     x0, #3
    mov rax, 3
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; b       _facility_op_go
    jmp _facility_op_go
BWSTR SEGMENT ALIGN(1) READ
nm_XFACILITY_OFF:
    ; DCB "FACILITY-OFF", 0
    DB "FACILITY-OFF", 0
hl_XFACILITY_OFF:
    ; DCB "FACILITY-OFF ( -- ) leave facility terminal mode", 0
    DB "FACILITY-OFF ( -- ) leave facility terminal mode", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFACILITY_OFF:
    ; DCQ     nm_XFACILITY_OFF, hl_XFACILITY_OFF
    DQ OFFSET nm_XFACILITY_OFF, OFFSET hl_XFACILITY_OFF
    ; DCQ     0
    DQ 0
    ; DCQ     XFACILITY_OFF, 0
    DQ OFFSET XFACILITY_OFF, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFACILITY_OFF
    DQ OFFSET row_XFACILITY_OFF
BOOTPTR ENDS
.CODE
XFACILITY_OFF:
    ; mov     x0, #4
    mov rax, 4
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; b       _facility_op_go
    jmp _facility_op_go
BWSTR SEGMENT ALIGN(1) READ
nm_XFACILITY_SIZE:
    ; DCB "(FACILITY-SIZE)", 0
    DB "(FACILITY-SIZE)", 0
hl_XFACILITY_SIZE:
    ; DCB "(FACILITY-SIZE) ( cols rows -- ) resize facility terminal grid", 0
    DB "(FACILITY-SIZE) ( cols rows -- ) resize facility terminal grid", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFACILITY_SIZE:
    ; DCQ     nm_XFACILITY_SIZE, hl_XFACILITY_SIZE
    DQ OFFSET nm_XFACILITY_SIZE, OFFSET hl_XFACILITY_SIZE
    ; DCQ     0
    DQ 0
    ; DCQ     XFACILITY_SIZE, XFACILITY_SIZE_END
    DQ OFFSET XFACILITY_SIZE, OFFSET XFACILITY_SIZE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFACILITY_SIZE
    DQ OFFSET row_XFACILITY_SIZE
BOOTPTR ENDS
.CODE
XFACILITY_SIZE:
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
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #5
    mov rax, 5
    mov QWORD PTR arm_x0, rax
    ; b       _facility_op_go
    jmp _facility_op_go
XFACILITY_SIZE_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XFACILITY_REV:
    ; DCB "FACILITY-REV", 0
    DB "FACILITY-REV", 0
hl_XFACILITY_REV:
    ; DCB "FACILITY-REV ( f -- ) reverse-video on or off for facility EMIT", 0
    DB "FACILITY-REV ( f -- ) reverse-video on or off for facility EMIT", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFACILITY_REV:
    ; DCQ     nm_XFACILITY_REV, hl_XFACILITY_REV
    DQ OFFSET nm_XFACILITY_REV, OFFSET hl_XFACILITY_REV
    ; DCQ     0
    DQ 0
    ; DCQ     XFACILITY_REV, XFACILITY_REV_END
    DQ OFFSET XFACILITY_REV, OFFSET XFACILITY_REV_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFACILITY_REV
    DQ OFFSET row_XFACILITY_REV
BOOTPTR ENDS
.CODE
XFACILITY_REV:
    ; mov     x1, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x1, rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR arm_x22
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    mov rax, QWORD PTR arm_x22
    add rax, 8
    mov QWORD PTR arm_x22, rax
    ; mov     x0, #6
    mov rax, 6
    mov QWORD PTR arm_x0, rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR arm_x2, rax
    ; b       _facility_op_go
    jmp _facility_op_go
XFACILITY_REV_END:
BWSTR SEGMENT ALIGN(1) READ
nm_XFACILITY_OP_GO:
    ; DCB "(XFACILITY-OP-GO)", 0
    DB "(XFACILITY-OP-GO)", 0
hl_XFACILITY_OP_GO:
    ; DCB "(XFACILITY-OP-GO) ( -- ) facility host hook x0=op x1 x2=args", 0
    DB "(XFACILITY-OP-GO) ( -- ) facility host hook x0=op x1 x2=args", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFACILITY_OP_GO:
    ; DCQ     nm_XFACILITY_OP_GO, hl_XFACILITY_OP_GO
    DQ OFFSET nm_XFACILITY_OP_GO, OFFSET hl_XFACILITY_OP_GO
    ; DCQ     0
    DQ 0
    ; DCQ     XFACILITY_OP_GO, XFACILITY_OP_GO_END
    DQ OFFSET XFACILITY_OP_GO, OFFSET XFACILITY_OP_GO_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFACILITY_OP_GO
    DQ OFFSET row_XFACILITY_OP_GO
BOOTPTR ENDS
.CODE
XFACILITY_OP_GO:
_facility_op_go:
    ; lea x9, facility_op_hook
    lea rax, facility_op_hook
    mov QWORD PTR arm_x9, rax
    ; ldr     x9, [x9]
    mov r10, QWORD PTR arm_x9
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
    ; cbz     x9, fac_op_done
    mov rax, QWORD PTR arm_x9
    cmp rax, 0
    je fac_op_done
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; blr     x9
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
    mov r11, QWORD PTR arm_x9
    call r11
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
fac_op_done:
XFACILITY_OP_GO_END:
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
_call_native_regs:
    ; stp     x29, x30, [sp, #-128]!
    add rsp, -128
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
    ; stp     x28, x18, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR arm_x28
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x18
    mov QWORD PTR [r10+8], rax
    ; stp     x0, x1, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+8], rax
    ; str     x2, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #64
    mov rax, 40h
    mov QWORD PTR arm_x1, rax
    ; bl      host_icache_inval
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
    call host_icache_inval
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldp     x0, x1, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x0, rax
    mov QWORD PTR arm_x1, rcx
    ; ldr     x2, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; mov     x19, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x19, rax
    ; blr     x2
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
    mov r11, QWORD PTR arm_x2
    call r11
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldp     x28, x18, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x28, rax
    mov QWORD PTR arm_x18, rcx
    ; ldp     x23, x24, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x23, rax
    mov QWORD PTR arm_x24, rcx
    ; ldp     x21, x22, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    ; ldp     x19, x20, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    ; ldp     x29, x30, [sp], #128
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 80h
    ; ret
    jmp QWORD PTR arm_x30
BWSTR SEGMENT ALIGN(1) READ
nm_XMPROTECT:
    ; DCB "MPROTECT", 0
    DB "MPROTECT", 0
hl_XMPROTECT:
    ; DCB "MPROTECT ( addr u prot -- ior ) protect pages prot 1=R 2=W 4=X", 0
    DB "MPROTECT ( addr u prot -- ior ) protect pages prot 1=R 2=W 4=X", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMPROTECT:
    ; DCQ     nm_XMPROTECT, hl_XMPROTECT
    DQ OFFSET nm_XMPROTECT, OFFSET hl_XMPROTECT
    ; DCQ     0
    DQ 0
    ; DCQ     XMPROTECT, 0
    DQ OFFSET XMPROTECT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMPROTECT
    DQ OFFSET row_XMPROTECT
BOOTPTR ENDS
.CODE
XMPROTECT:
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
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_mprotect
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
    call host_mprotect
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
nm_XICACHE_INVAL:
    ; DCB "ICACHE-INVAL", 0
    DB "ICACHE-INVAL", 0
hl_XICACHE_INVAL:
    ; DCB "ICACHE-INVAL ( addr u -- ) flush the instruction cache for a range", 0
    DB "ICACHE-INVAL ( addr u -- ) flush the instruction cache for a range", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XICACHE_INVAL:
    ; DCQ     nm_XICACHE_INVAL, hl_XICACHE_INVAL
    DQ OFFSET nm_XICACHE_INVAL, OFFSET hl_XICACHE_INVAL
    ; DCQ     0
    DQ 0
    ; DCQ     XICACHE_INVAL, 0
    DQ OFFSET XICACHE_INVAL, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XICACHE_INVAL
    DQ OFFSET row_XICACHE_INVAL
BOOTPTR ENDS
.CODE
XICACHE_INVAL:
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
    ; bl      host_icache_inval
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
    call host_icache_inval
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
nm_XCALL_NATIVE:
    ; DCB "CALL-NATIVE", 0
    DB "CALL-NATIVE", 0
hl_XCALL_NATIVE:
    ; DCB "CALL-NATIVE ( x0 dsp code -- x0' ) call native code and save the VM", 0
    DB "CALL-NATIVE ( x0 dsp code -- x0' ) call native code and save the VM", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCALL_NATIVE:
    ; DCQ     nm_XCALL_NATIVE, hl_XCALL_NATIVE
    DQ OFFSET nm_XCALL_NATIVE, OFFSET hl_XCALL_NATIVE
    ; DCQ     0
    DQ 0
    ; DCQ     XCALL_NATIVE, 0
    DQ OFFSET XCALL_NATIVE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCALL_NATIVE
    DQ OFFSET row_XCALL_NATIVE
BOOTPTR ENDS
.CODE
XCALL_NATIVE:
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
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _call_native_regs
    lea rax, xret_141
    mov QWORD PTR arm_x30, rax
    jmp _call_native_regs
    xret_141:
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
BWSTR SEGMENT ALIGN(1) READ
nm_XCALL_NATIVE_LEAF:
    ; DCB "CALL-NATIVE-LEAF", 0
    DB "CALL-NATIVE-LEAF", 0
hl_XCALL_NATIVE_LEAF:
    ; DCB "CALL-NATIVE-LEAF ( code -- x0' ) call code with x0=0 and a BSS DSP", 0
    DB "CALL-NATIVE-LEAF ( code -- x0' ) call code with x0=0 and a BSS DSP", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCALL_NATIVE_LEAF:
    ; DCQ     nm_XCALL_NATIVE_LEAF, hl_XCALL_NATIVE_LEAF
    DQ OFFSET nm_XCALL_NATIVE_LEAF, OFFSET hl_XCALL_NATIVE_LEAF
    ; DCQ     0
    DQ 0
    ; DCQ     XCALL_NATIVE_LEAF, 0
    DQ OFFSET XCALL_NATIVE_LEAF, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCALL_NATIVE_LEAF
    DQ OFFSET row_XCALL_NATIVE_LEAF
BOOTPTR ENDS
.CODE
XCALL_NATIVE_LEAF:
    ; mov     x2, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x2, rax
    ; lea x1, native_dsp_end
    lea rax, native_dsp_end
    mov QWORD PTR arm_x1, rax
    ; sub     x1, x1, #64
    mov rax, QWORD PTR arm_x1
    sub rax, 40h
    mov QWORD PTR arm_x1, rax
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _call_native_regs
    lea rax, xret_142
    mov QWORD PTR arm_x30, rax
    jmp _call_native_regs
    xret_142:
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
BWSTR SEGMENT ALIGN(1) READ
nm_XALLOCATE_EXEC:
    ; DCB "ALLOCATE-EXEC", 0
    DB "ALLOCATE-EXEC", 0
hl_XALLOCATE_EXEC:
    ; DCB "ALLOCATE-EXEC ( u -- a-addr ior ) RW buffer for later R+X", 0
    DB "ALLOCATE-EXEC ( u -- a-addr ior ) RW buffer for later R+X", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XALLOCATE_EXEC:
    ; DCQ     nm_XALLOCATE_EXEC, hl_XALLOCATE_EXEC
    DQ OFFSET nm_XALLOCATE_EXEC, OFFSET hl_XALLOCATE_EXEC
    ; DCQ     0
    DQ 0
    ; DCQ     XALLOCATE_EXEC, 0
    DQ OFFSET XALLOCATE_EXEC, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XALLOCATE_EXEC
    DQ OFFSET row_XALLOCATE_EXEC
BOOTPTR ENDS
.CODE
XALLOCATE_EXEC:
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; cbnz    x0, _ax_size
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _ax_size
    ; mov     x0, #0x1000
    mov rax, 1000h
    mov QWORD PTR arm_x0, rax
_ax_size:
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
    ; add     x1, sp, #48
    mov rax, rsp
    add rax, 30h
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov QWORD PTR [r10], 0
    ; bl      host_alloc_exec
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
    call host_alloc_exec
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldr     x1, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
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
nm_XFREE_EXEC:
    ; DCB "FREE-EXEC", 0
    DB "FREE-EXEC", 0
hl_XFREE_EXEC:
    ; DCB "FREE-EXEC ( a-addr u -- ior ) release an ALLOCATE-EXEC buffer", 0
    DB "FREE-EXEC ( a-addr u -- ior ) release an ALLOCATE-EXEC buffer", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XFREE_EXEC:
    ; DCQ     nm_XFREE_EXEC, hl_XFREE_EXEC
    DQ OFFSET nm_XFREE_EXEC, OFFSET hl_XFREE_EXEC
    ; DCQ     0
    DQ 0
    ; DCQ     XFREE_EXEC, 0
    DQ OFFSET XFREE_EXEC, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XFREE_EXEC
    DQ OFFSET row_XFREE_EXEC
BOOTPTR ENDS
.CODE
XFREE_EXEC:
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
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      host_free_exec
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
    call host_free_exec
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
nm_XJIT_WPROTECT:
    ; DCB "JIT-WPROTECT", 0
    DB "JIT-WPROTECT", 0
hl_XJIT_WPROTECT:
    ; DCB "JIT-WPROTECT ( f -- ) record write or execute mode for this thread", 0
    DB "JIT-WPROTECT ( f -- ) record write or execute mode for this thread", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XJIT_WPROTECT:
    ; DCQ     nm_XJIT_WPROTECT, hl_XJIT_WPROTECT
    DQ OFFSET nm_XJIT_WPROTECT, OFFSET hl_XJIT_WPROTECT
    ; DCQ     0
    DQ 0
    ; DCQ     XJIT_WPROTECT, 0
    DQ OFFSET XJIT_WPROTECT, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XJIT_WPROTECT
    DQ OFFSET row_XJIT_WPROTECT
BOOTPTR ENDS
.CODE
XJIT_WPROTECT:
    ; cmp     x20, #0
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; cset    x1, ne
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    jne xsk_143
    mov eax, 1
    xsk_143:
    mov QWORD PTR arm_x1, rax
    ; lea x0, jit_exec_mode
    lea rax, jit_exec_mode
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
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
nm_XNATIVE_SMOKE:
    ; DCB "NATIVE-SMOKE", 0
    DB "NATIVE-SMOKE", 0
hl_XNATIVE_SMOKE:
    ; DCB "NATIVE-SMOKE ( -- ior ) test RW map then RX call", 0
    DB "NATIVE-SMOKE ( -- ior ) test RW map then RX call", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XNATIVE_SMOKE:
    ; DCQ     nm_XNATIVE_SMOKE, hl_XNATIVE_SMOKE
    DQ OFFSET nm_XNATIVE_SMOKE, OFFSET hl_XNATIVE_SMOKE
    ; DCQ     0
    DQ 0
    ; DCQ     XNATIVE_SMOKE, 0
    DQ OFFSET XNATIVE_SMOKE, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XNATIVE_SMOKE
    DQ OFFSET row_XNATIVE_SMOKE
BOOTPTR ENDS
.CODE
XNATIVE_SMOKE:
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
    ; mov     x0, #0x1000
    mov rax, 1000h
    mov QWORD PTR arm_x0, rax
    ; add     x1, sp, #48
    mov rax, rsp
    add rax, 30h
    mov QWORD PTR arm_x1, rax
    ; str     xzr, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov QWORD PTR [r10], 0
    ; bl      host_alloc_exec
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
    call host_alloc_exec
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; cbnz    x0, _ns_bad
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _ns_bad
    ; ldr     x0, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; bl      host_native_ret7
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
    call host_native_ret7
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldr     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0x1000
    mov rax, 1000h
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #5
    mov rax, 5
    mov QWORD PTR arm_x2, rax
    ; bl      host_mprotect
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
    call host_mprotect
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; cbnz    x0, _ns_free
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _ns_free
    ; ldr     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0x1000
    mov rax, 1000h
    mov QWORD PTR arm_x1, rax
    ; bl      host_icache_inval
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
    call host_icache_inval
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; lea x1, native_dsp_end
    lea rax, native_dsp_end
    mov QWORD PTR arm_x1, rax
    ; sub     x1, x1, #64
    mov rax, QWORD PTR arm_x1
    sub rax, 40h
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; bl      _call_native_regs
    lea rax, xret_144
    mov QWORD PTR arm_x30, rax
    jmp _call_native_regs
    xret_144:
    ; str     x0, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldr     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0x1000
    mov rax, 1000h
    mov QWORD PTR arm_x1, rax
    ; bl      host_free_exec
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
    call host_free_exec
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; cbnz    x0, _ns_bad
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _ns_bad
    ; ldr     x0, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x0, #7
    mov rax, QWORD PTR arm_x0
    cmp rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _ns_bad
    cmp BYTE PTR arm_z, 0
    je _ns_bad
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; b       _ns_out
    jmp _ns_out
_ns_free:
    ; ldr     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0x1000
    mov rax, 1000h
    mov QWORD PTR arm_x1, rax
    ; bl      host_free_exec
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
    call host_free_exec
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
_ns_bad:
    ; mov     x0, #-1
    mov rax, -1
    mov QWORD PTR arm_x0, rax
_ns_out:
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
next_debug_gate:
    ; lea x16, next_debug
    lea rax, next_debug
    mov QWORD PTR arm_x16, rax
    ; br      x16
    mov rax, QWORD PTR arm_x16
    jmp rax
.CONST
req_included_name:
    ; DCB   "INCLUDED"
    DB "INCLUDED"
str_protected:
    ; DCB     "protected (system word)", 10, 0
    DB "protected (system word)", 0Ah, 0
str_gmm_already:
    ; DCB     "? GROWMEMORYMB already used (once per session)", 10, 0
    DB "? GROWMEMORYMB already used (once per session)", 0Ah, 0
str_gmm_small:
    ; DCB     "? GROWMEMORYMB needs at least 1 MB", 10, 0
    DB "? GROWMEMORYMB needs at least 1 MB", 0Ah, 0
str_gmm_big:
    ; DCB     "? GROWMEMORYMB exceeds maximum (256 MB)", 10, 0
    DB "? GROWMEMORYMB exceeds maximum (256 MB)", 0Ah, 0
str_gmm_shrink:
    ; DCB     "? GROWMEMORYMB cannot shrink memory", 10, 0
    DB "? GROWMEMORYMB cannot shrink memory", 0Ah, 0
str_bang:
    ; DCB     "!", 0
    DB "!", 0
str_twostore:
    ; DCB     "2!", 0
    DB "2!", 0
str_twofetch:
    ; DCB     "2@", 0
    DB "2@", 0
str_type:
    ; DCB     "TYPE", 0
    DB "TYPE", 0
    ; ALIGN 8
ALIGN 8
env_name_ptrs:
    ; DCQ     env_n_counted
    DQ OFFSET env_n_counted
    ; DCQ     env_n_aub
    DQ OFFSET env_n_aub
    ; DCQ     env_n_core
    DQ OFFSET env_n_core
    ; DCQ     env_n_core_ext
    DQ OFFSET env_n_core_ext
    ; DCQ     env_n_floored
    DQ OFFSET env_n_floored
    ; DCQ     env_n_maxchar
    DQ OFFSET env_n_maxchar
    ; DCQ     env_n_maxn
    DQ OFFSET env_n_maxn
    ; DCQ     env_n_maxu
    DQ OFFSET env_n_maxu
    ; DCQ     env_n_rstack
    DQ OFFSET env_n_rstack
    ; DCQ     env_n_stack
    DQ OFFSET env_n_stack
    ; DCQ     env_n_floating
    DQ OFFSET env_n_floating
    ; DCQ     env_n_float_ext
    DQ OFFSET env_n_float_ext
    ; DCQ     env_n_floating_stack
    DQ OFFSET env_n_floating_stack
    ; DCQ     env_n_max_float
    DQ OFFSET env_n_max_float
    ; DCQ     env_n_string
    DQ OFFSET env_n_string
    ; DCQ     env_n_facility
    DQ OFFSET env_n_facility
    ; DCQ     env_n_facility_ext
    DQ OFFSET env_n_facility_ext
    ; DCQ     env_n_locals
    DQ OFFSET env_n_locals
    ; DCQ     env_n_nlocals
    DQ OFFSET env_n_nlocals
    ; DCQ     env_n_xchar
    DQ OFFSET env_n_xchar
    ; DCQ     env_n_xchar_enc
    DQ OFFSET env_n_xchar_enc
    ; DCQ     env_n_max_xchar
    DQ OFFSET env_n_max_xchar
    ; DCQ     env_n_xchar_maxmem
    DQ OFFSET env_n_xchar_maxmem
    ; DCQ     env_n_double
    DQ OFFSET env_n_double
    ; DCQ     env_n_exception
    DQ OFFSET env_n_exception
    ; DCQ     env_n_mem
    DQ OFFSET env_n_mem
    ; DCQ     env_n_search
    DQ OFFSET env_n_search
    ; DCQ     env_n_wordlists
    DQ OFFSET env_n_wordlists
    ; DCQ     env_n_block
    DQ OFFSET env_n_block
    ; DCQ     env_n_file
    DQ OFFSET env_n_file
    ; DCQ     env_n_file_ext
    DQ OFFSET env_n_file_ext
env_values:
    ; DCQ     255
    DQ 0FFh
    ; DCQ     8
    DQ 8
    ; DCQ     -1
    DQ -1
    ; DCQ     -1
    DQ -1
    ; DCQ     0
    DQ 0
    ; DCQ     255
    DQ 0FFh
    ; DCQ     0x7FFFFFFFFFFFFFFF
    DQ 7FFFFFFFFFFFFFFFh
    ; DCQ     -1
    DQ -1
    ; DCQ     512
    DQ 200h
    ; DCQ     512
    DQ 200h
    ; DCQ     -1
    DQ -1
    ; DCQ     -1
    DQ -1
    ; DCQ     16
    DQ 10h
    ; DCQ     0x7FEFFFFFFFFFFFFF
    DQ 7FEFFFFFFFFFFFFFh
    ; DCQ     -1
    DQ -1
    ; DCQ     0
    DQ 0
    ; DCQ     0
    DQ 0
    ; DCQ     -1
    DQ -1
    ; DCQ     32
    DQ 20h
    ; DCQ     0
    DQ 0
    ; DCQ     env_s_utf8
    DQ OFFSET env_s_utf8
    ; DCQ     0x10FFFF
    DQ 10FFFFh
    ; DCQ     4
    DQ 4
    ; DCQ     -1
    DQ -1
    ; DCQ     -1
    DQ -1
    ; DCQ     -1
    DQ -1
    ; DCQ     -1
    DQ -1
    ; DCQ     8
    DQ 8
    ; DCQ     -1
    DQ -1
    ; DCQ     -1
    DQ -1
    ; DCQ     -1
    DQ -1
env_kinds:
    ; DCB     1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    DB 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    ; DCB     2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
    DB 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
env_n_counted:
    ; DCB "/COUNTED-STRING", 0
    DB "/COUNTED-STRING", 0
env_n_aub:
    ; DCB "ADDRESS-UNIT-BITS", 0
    DB "ADDRESS-UNIT-BITS", 0
env_n_core:
    ; DCB "CORE", 0
    DB "CORE", 0
env_n_core_ext:
    ; DCB "CORE-EXT", 0
    DB "CORE-EXT", 0
env_n_floored:
    ; DCB "FLOORED", 0
    DB "FLOORED", 0
env_n_maxchar:
    ; DCB "MAX-CHAR", 0
    DB "MAX-CHAR", 0
env_n_maxn:
    ; DCB "MAX-N", 0
    DB "MAX-N", 0
env_n_maxu:
    ; DCB "MAX-U", 0
    DB "MAX-U", 0
env_n_rstack:
    ; DCB "RETURN-STACK-CELLS", 0
    DB "RETURN-STACK-CELLS", 0
env_n_stack:
    ; DCB "STACK-CELLS", 0
    DB "STACK-CELLS", 0
env_n_floating:
    ; DCB "FLOATING", 0
    DB "FLOATING", 0
env_n_float_ext:
    ; DCB "FLOAT-EXT", 0
    DB "FLOAT-EXT", 0
env_n_floating_stack:
    ; DCB "FLOATING-STACK", 0
    DB "FLOATING-STACK", 0
env_n_max_float:
    ; DCB "MAX-FLOAT", 0
    DB "MAX-FLOAT", 0
env_n_string:
    ; DCB "STRING", 0
    DB "STRING", 0
env_n_facility:
    ; DCB "FACILITY", 0
    DB "FACILITY", 0
env_n_facility_ext:
    ; DCB "FACILITY-EXT", 0
    DB "FACILITY-EXT", 0
env_n_locals:
    ; DCB "LOCALS", 0
    DB "LOCALS", 0
env_n_nlocals:
    ; DCB "#LOCALS", 0
    DB "#LOCALS", 0
env_n_xchar:
    ; DCB "EXTENDED-CHARACTER", 0
    DB "EXTENDED-CHARACTER", 0
env_n_xchar_enc:
    ; DCB "XCHAR-ENCODING", 0
    DB "XCHAR-ENCODING", 0
env_n_max_xchar:
    ; DCB "MAX-XCHAR", 0
    DB "MAX-XCHAR", 0
env_n_xchar_maxmem:
    ; DCB "XCHAR-MAXMEM", 0
    DB "XCHAR-MAXMEM", 0
env_n_double:
    ; DCB "DOUBLE", 0
    DB "DOUBLE", 0
env_n_exception:
    ; DCB "EXCEPTION", 0
    DB "EXCEPTION", 0
env_n_mem:
    ; DCB "MEMORY-ALLOCATION", 0
    DB "MEMORY-ALLOCATION", 0
env_n_search:
    ; DCB "SEARCH-ORDER", 0
    DB "SEARCH-ORDER", 0
env_n_wordlists:
    ; DCB "WORDLISTS", 0
    DB "WORDLISTS", 0
env_n_block:
    ; DCB "BLOCK", 0
    DB "BLOCK", 0
env_n_file:
    ; DCB "FILE", 0
    DB "FILE", 0
env_n_file_ext:
    ; DCB "FILE-EXT", 0
    DB "FILE-EXT", 0
env_s_utf8:
    ; DCB "UTF-8", 0
    DB "UTF-8", 0
END
