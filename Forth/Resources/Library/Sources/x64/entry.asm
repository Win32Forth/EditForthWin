; Generated from Forth/kernel/arm64/entry.asm. Do not edit.
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
EXTRN XTHROW:PROC
EXTRN _compile_cell:PROC
EXTRN _find_word:PROC
EXTRN _header_build:PROC
EXTRN _local_compile_reset:PROC
EXTRN _local_lookup:PROC
EXTRN _next_word:PROC
EXTRN _parse_number:PROC
EXTRN _print_unsigned:PROC
EXTRN _putchar:PROC
EXTRN _record_words_user_base_once:PROC
EXTRN _strlen:PROC
EXTRN _view_pop_src_id:PROC
EXTRN blk_stack:BYTE
EXTRN blk_var:BYTE
EXTRN bootptr_end:BYTE
EXTRN bootptr_start:BYTE
EXTRN bye_flag:BYTE
EXTRN cfa_0branch:BYTE
EXTRN cfa_branch:BYTE
EXTRN cfa_comma:BYTE
EXTRN cfa_cstr:BYTE
EXTRN cfa_does:BYTE
EXTRN cfa_execute:BYTE
EXTRN cfa_exit:BYTE
EXTRN cfa_flit:BYTE
EXTRN cfa_lit:BYTE
EXTRN cfa_local_at:BYTE
EXTRN cfa_local_init:BYTE
EXTRN cfa_local_store:BYTE
EXTRN cfa_loop:BYTE
EXTRN cfa_plusloop:BYTE
EXTRN cfa_slit:BYTE
EXTRN data_stack:BYTE
EXTRN debug_armed:BYTE
EXTRN debug_break_asap:BYTE
EXTRN emit_cstr:PROC
EXTRN emit_hook:BYTE
EXTRN emit_str:PROC
EXTRN eval_resume_sp:BYTE
EXTRN eval_resume_stack:BYTE
EXTRN facility_op_hook:BYTE
EXTRN file_echo:BYTE
EXTRN file_echo_pos:BYTE
EXTRN file_echo_stack:BYTE
EXTRN forth_init_end:BYTE
EXTRN forth_init_str:BYTE
EXTRN here_ptr:BYTE
EXTRN host_float_op:PROC
EXTRN kernel_inited:BYTE
EXTRN key_hook:BYTE
EXTRN last_cfa:BYTE
EXTRN latest_var:BYTE
EXTRN line_limit:BYTE
EXTRN line_mode:BYTE
EXTRN line_next:BYTE
EXTRN line_origin:BYTE
EXTRN local_frame_depth:BYTE
EXTRN next_debug:PROC
EXTRN noname_xt:BYTE
EXTRN restart_cell:BYTE
EXTRN return_stack:BYTE
EXTRN source_base:BYTE
EXTRN source_cur:BYTE
EXTRN source_end:BYTE
EXTRN source_id:BYTE
EXTRN source_sp:BYTE
EXTRN source_stack:BYTE
EXTRN state_var:BYTE
EXTRN throw_handler:BYTE
EXTRN to_in:BYTE
EXTRN user_dict_area:BYTE
EXTRN view_id_sp:BYTE
EXTRN view_src_id:BYTE
EXTRN vm_dsp:BYTE
EXTRN vm_rsp:BYTE
EXTRN vm_tos:BYTE
.CODE
PUBLIC kernel_init
PUBLIC _kernel_init
PUBLIC kernel_eval
PUBLIC _kernel_eval
PUBLIC kernel_set_emit
PUBLIC _kernel_set_emit
PUBLIC kernel_set_key
PUBLIC _kernel_set_key
PUBLIC kernel_set_facility_op
PUBLIC _kernel_set_facility_op
PUBLIC _kernel_cold_common
PUBLIC _boot_kernel
PUBLIC _boot_cache_cfa
PUBLIC _zcmp
PUBLIC _vm_save
PUBLIC _vm_load
PUBLIC _vm_reset_stacks
PUBLIC _interpret_loop
PUBLIC _try_find
PUBLIC _exec_found
PUBLIC _compile_entry
PUBLIC _compile_lit
PUBLIC _try_number_after_find
PUBLIC _interpret_empty
PUBLIC _embed_finish
PUBLIC _do_quit
PUBLIC _arm_lines
PUBLIC _take_line
PUBLIC _push_source
PUBLIC _pop_source
PUBLIC _eval_resume_push
PUBLIC _eval_resume_pop
PUBLIC _throw_unwind_to_sp
PUBLIC _quit_exit
PUBLIC _embed_bye_return
PUBLIC _embed_ret_x0
_kernel_set_emit:
kernel_set_emit:
    mov QWORD PTR arm_x0, rcx
    mov QWORD PTR arm_x1, rdx
    mov QWORD PTR arm_x2, r8
    mov QWORD PTR arm_x3, r9
    ; lea x1, emit_hook
    lea rax, emit_hook
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR arm_x0
    ret
_kernel_set_key:
kernel_set_key:
    mov QWORD PTR arm_x0, rcx
    mov QWORD PTR arm_x1, rdx
    mov QWORD PTR arm_x2, r8
    mov QWORD PTR arm_x3, r9
    ; lea x1, key_hook
    lea rax, key_hook
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR arm_x0
    ret
_kernel_set_facility_op:
kernel_set_facility_op:
    mov QWORD PTR arm_x0, rcx
    mov QWORD PTR arm_x1, rdx
    mov QWORD PTR arm_x2, r8
    mov QWORD PTR arm_x3, r9
    ; lea x1, facility_op_hook
    lea rax, facility_op_hook
    mov QWORD PTR arm_x1, rax
    ; str     x0, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR arm_x0
    ret
_kernel_init:
kernel_init:
    mov QWORD PTR arm_x0, rcx
    mov QWORD PTR arm_x1, rdx
    mov QWORD PTR arm_x2, r8
    mov QWORD PTR arm_x3, r9
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
    ; stp     x27, x28, [sp, #112]
    lea r10, [rsp]
    add r10, 70h
    mov rax, QWORD PTR arm_x27
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x28
    mov QWORD PTR [r10+8], rax
    ; lea x0, kernel_inited
    lea rax, kernel_inited
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, _kinit_already
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne _kinit_already
    ; bl      _kernel_cold_common
    lea rax, xret_1
    mov QWORD PTR arm_x30, rax
    jmp _kernel_cold_common
    xret_1:
    ; bl      _vm_save
    lea rax, xret_2
    mov QWORD PTR arm_x30, rax
    jmp _vm_save
    xret_2:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x0, kernel_inited
    lea rax, kernel_inited
    mov QWORD PTR arm_x0, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x0, forth_init_str
    lea rax, forth_init_str
    mov QWORD PTR arm_x0, rax
    ; lea x1, forth_init_end
    lea rax, forth_init_end
    mov QWORD PTR arm_x1, rax
    ; sub     x1, x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    sub rax, rcx
    mov QWORD PTR arm_x1, rax
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; lea x2, source_base
    lea rax, source_base
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
    ; lea x2, source_cur
    lea rax, source_cur
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, source_end
    lea rax, source_end
    mov QWORD PTR arm_x2, rax
    ; add     x0, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, throw_handler
    lea rax, throw_handler
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, bye_flag
    lea rax, bye_flag
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; b       _interpret_loop
    jmp _interpret_loop
_kinit_already:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; b       _embed_ret_x0
    jmp _embed_ret_x0
_kernel_cold_common:
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
    ; lea x22, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x22, rax
    ; add     x22, x22, #1, lsl #12
    mov rax, QWORD PTR arm_x22
    add rax, 1000h
    mov QWORD PTR arm_x22, rax
    ; lea x23, return_stack
    lea rax, return_stack
    mov QWORD PTR arm_x23, rax
    ; add     x23, x23, #1, lsl #12
    mov rax, QWORD PTR arm_x23
    add rax, 1000h
    mov QWORD PTR arm_x23, rax
    ; lea x24, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x24, rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
    ; mov     x28, #0
    mov rax, 0
    mov QWORD PTR arm_x28, rax
    ; mov     x0, x24
    mov rax, QWORD PTR arm_x24
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #16
    mov rax, 10h
    mov QWORD PTR arm_x1, rax
_cold_clear:
    ; str     xzr, [x0], #8
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    mov rax, QWORD PTR arm_x0
    add rax, 8
    mov QWORD PTR arm_x0, rax
    ; subs    x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x1, rax
    ; b.ne    _cold_clear
    cmp BYTE PTR arm_z, 0
    je _cold_clear
    ; lea x0, last_cfa
    lea rax, last_cfa
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, here_ptr
    lea rax, here_ptr
    mov QWORD PTR arm_x0, rax
    ; lea x1, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, bye_flag
    lea rax, bye_flag
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; bl      _boot_kernel
    lea rax, xret_3
    mov QWORD PTR arm_x30, rax
    jmp _boot_kernel
    xret_3:
    ; lea x24, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x24, rax
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
_boot_kernel:
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
    ; str     x25, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR [r10], rax
    ; lea x19, bootptr_start
    lea rax, bootptr_start
    mov QWORD PTR arm_x19, rax
    ; lea x25, bootptr_end
    lea rax, bootptr_end
    mov QWORD PTR arm_x25, rax
_bk_loop:
    ; cmp     x19, x25
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x25
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _bk_done
    cmp BYTE PTR arm_c, 0
    jne _bk_done
    ; ldr     x7, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x7, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; cbz     x7, _bk_loop
    mov rax, QWORD PTR arm_x7
    cmp rax, 0
    je _bk_loop
    ; ldr     x20, [x7]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; cbz     x20, _bk_loop
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    je _bk_loop
    ; ldr     x21, [x7, #8]
    mov r10, QWORD PTR arm_x7
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    ; ldr     x22, [x7, #16]
    mov r10, QWORD PTR arm_x7
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x22, rax
    ; ldr     x23, [x7, #24]
    mov r10, QWORD PTR arm_x7
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x23, rax
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      _strlen
    lea rax, xret_4
    mov QWORD PTR arm_x30, rax
    jmp _strlen
    xret_4:
    ; str     x0, [sp, #104]
    lea r10, [rsp]
    add r10, 68h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; mov     x0, x21
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR arm_x0, rax
    ; bl      _strlen
    lea rax, xret_5
    mov QWORD PTR arm_x30, rax
    jmp _strlen
    xret_5:
    ; mov     x3, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x3, rax
    ; ldr     x1, [sp, #104]
    lea r10, [rsp]
    add r10, 68h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; mov     x2, x21
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR arm_x2, rax
    ; mov     x4, x23
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR arm_x4, rax
    ; mov     x5, x22
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR arm_x5, rax
    ; bl      _header_build
    lea rax, xret_6
    mov QWORD PTR arm_x30, rax
    jmp _header_build
    xret_6:
    ; mov     x21, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x21, rax
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      _boot_cache_cfa
    lea rax, xret_7
    mov QWORD PTR arm_x30, rax
    jmp _boot_cache_cfa
    xret_7:
    ; b       _bk_loop
    jmp _bk_loop
_bk_done:
    ; ldr     x25, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x25, rax
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
    ; ret
    jmp QWORD PTR arm_x30
_boot_cache_cfa:
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
    ; stp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
    ; mov     x20, x21
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR arm_x20, rax
    ; lea x1, boot_cmp_lit
    lea rax, boot_cmp_lit
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_8
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_8:
    ; lea x1, boot_cmp_exit
    lea rax, boot_cmp_exit
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_exit
    lea rax, cfa_exit
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_9
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_9:
    ; lea x1, boot_cmp_branch
    lea rax, boot_cmp_branch
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_branch
    lea rax, cfa_branch
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_10
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_10:
    ; lea x1, boot_cmp_0branch
    lea rax, boot_cmp_0branch
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_0branch
    lea rax, cfa_0branch
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_11
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_11:
    ; lea x1, boot_cmp_does
    lea rax, boot_cmp_does
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_does
    lea rax, cfa_does
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_12
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_12:
    ; lea x1, boot_cmp_slit
    lea rax, boot_cmp_slit
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_slit
    lea rax, cfa_slit
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_13
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_13:
    ; lea x1, boot_cmp_cstr
    lea rax, boot_cmp_cstr
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_cstr
    lea rax, cfa_cstr
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_14
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_14:
    ; lea x1, boot_cmp_execute
    lea rax, boot_cmp_execute
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_execute
    lea rax, cfa_execute
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_15
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_15:
    ; lea x1, boot_cmp_comma
    lea rax, boot_cmp_comma
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_comma
    lea rax, cfa_comma
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_16
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_16:
    ; lea x1, boot_cmp_flit
    lea rax, boot_cmp_flit
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_flit
    lea rax, cfa_flit
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_17
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_17:
    ; lea x1, boot_cmp_linit
    lea rax, boot_cmp_linit
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_local_init
    lea rax, cfa_local_init
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_18
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_18:
    ; lea x1, boot_cmp_lat
    lea rax, boot_cmp_lat
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_local_at
    lea rax, cfa_local_at
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_19
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_19:
    ; lea x1, boot_cmp_lstore
    lea rax, boot_cmp_lstore
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_local_store
    lea rax, cfa_local_store
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_20
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_20:
    ; lea x1, boot_cmp_loop
    lea rax, boot_cmp_loop
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_loop
    lea rax, cfa_loop
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_21
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_21:
    ; lea x1, boot_cmp_ploop
    lea rax, boot_cmp_ploop
    mov QWORD PTR arm_x1, rax
    ; lea x2, cfa_plusloop
    lea rax, cfa_plusloop
    mov QWORD PTR arm_x2, rax
    ; bl      _bcc_match
    lea rax, xret_22
    mov QWORD PTR arm_x30, rax
    jmp _bcc_match
    xret_22:
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
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; ret
    jmp QWORD PTR arm_x30
_bcc_match:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x2, x19, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+8], rax
    ; mov     x0, x19
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR arm_x0, rax
    ; bl      _zcmp
    lea rax, xret_23
    mov QWORD PTR arm_x30, rax
    jmp _zcmp
    xret_23:
    ; ldp     x2, x19, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x2, rax
    mov QWORD PTR arm_x19, rcx
    add rsp, 10h
    ; cbnz    x0, _bcc_match_no
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _bcc_match_no
    ; str     x20, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
_bcc_match_no:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_zcmp:
    ; ldrb    w2, [x0], #1
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; ldrb    w3, [x1], #1
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; cmp     w2, w3
    mov eax, DWORD PTR arm_x2
    mov ecx, DWORD PTR arm_x3
    cmp eax, ecx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _zcmp_ne
    cmp BYTE PTR arm_z, 0
    je _zcmp_ne
    ; cbnz    w2, _zcmp
    mov eax, DWORD PTR arm_x2
    cmp rax, 0
    jne _zcmp
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_zcmp_ne:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_kernel_eval:
kernel_eval:
    mov QWORD PTR arm_x0, rcx
    mov QWORD PTR arm_x1, rdx
    mov QWORD PTR arm_x2, r8
    mov QWORD PTR arm_x3, r9
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
    ; stp     x27, x28, [sp, #112]
    lea r10, [rsp]
    add r10, 70h
    mov rax, QWORD PTR arm_x27
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x28
    mov QWORD PTR [r10+8], rax
    ; lea x2, kernel_inited
    lea rax, kernel_inited
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbnz    x2, _eval_go
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    jne _eval_go
    ; mov     x0, #2
    mov rax, 2
    mov QWORD PTR arm_x0, rax
    ; neg     x0, x0
    mov rax, QWORD PTR arm_x0
    neg rax
    mov QWORD PTR arm_x0, rax
    ; b       _embed_ret_x0
    jmp _embed_ret_x0
_eval_go:
    ; lea x2, source_base
    lea rax, source_base
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
    ; lea x2, source_cur
    lea rax, source_cur
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, source_end
    lea rax, source_end
    mov QWORD PTR arm_x2, rax
    ; add     x0, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    add rax, rcx
    mov QWORD PTR arm_x0, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, throw_handler
    lea rax, throw_handler
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, bye_flag
    lea rax, bye_flag
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
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, source_sp
    lea rax, source_sp
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, view_src_id
    lea rax, view_src_id
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, view_id_sp
    lea rax, view_id_sp
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, eval_resume_sp
    lea rax, eval_resume_sp
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; bl      _vm_load
    lea rax, xret_24
    mov QWORD PTR arm_x30, rax
    jmp _vm_load
    xret_24:
    ; b       _interpret_loop
    jmp _interpret_loop
_interpret_loop:
    ; lea x24, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x24, rax
    ; bl      _check_stack
    lea rax, xret_25
    mov QWORD PTR arm_x30, rax
    jmp _check_stack
    xret_25:
    ; bl      _file_echo_upto_cursor
    lea rax, xret_26
    mov QWORD PTR arm_x30, rax
    jmp _file_echo_upto_cursor
    xret_26:
    ; bl      _next_word
    lea rax, xret_27
    mov QWORD PTR arm_x30, rax
    jmp _next_word
    xret_27:
    ; cbz     x1, _interpret_empty
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _interpret_empty
    ; mov     x25, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x25, rax
    ; mov     x26, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x26, rax
    ; b       _try_find
    jmp _try_find
_try_find:
    ; lea x2, state_var
    lea rax, state_var
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbz     x2, _try_find_dict
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    je _try_find_dict
    ; mov     x0, x25
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x26
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR arm_x1, rax
    ; bl      _local_lookup
    lea rax, xret_28
    mov QWORD PTR arm_x30, rax
    jmp _local_lookup
    xret_28:
    ; cmp     x0, #-1
    mov rax, QWORD PTR arm_x0
    cmp rax, -1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _try_find_dict
    cmp BYTE PTR arm_z, 0
    jne _try_find_dict
    ; mov     x25, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x25, rax
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_29
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_29:
    ; mov     x0, x25
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_30
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_30:
    ; lea x0, cfa_local_at
    lea rax, cfa_local_at
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_31
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_31:
    ; b       _interpret_loop
    jmp _interpret_loop
_try_find_dict:
    ; mov     x0, x25
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x26
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR arm_x1, rax
    ; bl      _find_word
    lea rax, xret_32
    mov QWORD PTR arm_x30, rax
    jmp _find_word
    xret_32:
    ; cbz     x0, _try_number_after_find
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _try_number_after_find
    ; mov     x2, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x2, rax
    ; mov     x3, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x3, rax
    ; tbnz    x3, #63, _exec_found
    mov rax, QWORD PTR arm_x3
    bt rax, 63
    jc _exec_found
    ; lea x6, state_var
    lea rax, state_var
    mov QWORD PTR arm_x6, rax
    ; ldr     x6, [x6]
    mov r10, QWORD PTR arm_x6
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; cbnz    x6, _compile_entry
    mov rax, QWORD PTR arm_x6
    cmp rax, 0
    jne _compile_entry
_exec_found:
    ; lea x19, restart_cell
    lea rax, restart_cell
    mov QWORD PTR arm_x19, rax
    ; mov     x21, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x21, rax
    ; ldr     x5, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; br      x5
    mov rax, QWORD PTR arm_x5
    jmp rax
_compile_entry:
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_33
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_33:
    ; b       _interpret_loop
    jmp _interpret_loop
_try_number_after_find:
    ; mov     x0, x25
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x26
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR arm_x1, rax
    ; bl      _parse_number
    lea rax, xret_34
    mov QWORD PTR arm_x30, rax
    jmp _parse_number
    xret_34:
    ; cbz     x0, _try_charlit
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _try_charlit
    ; cmp     x0, #2
    mov rax, QWORD PTR arm_x0
    cmp rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _number_double
    cmp BYTE PTR arm_z, 0
    jne _number_double
    ; lea x2, state_var
    lea rax, state_var
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbnz    x2, _compile_lit
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    jne _compile_lit
    ; mov     x0, x1
    mov rax, QWORD PTR arm_x1
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
    ; b       _interpret_loop
    jmp _interpret_loop
_compile_lit:
    ; mov     x25, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x25, rax
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_35
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_35:
    ; mov     x0, x25
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_36
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_36:
    ; b       _interpret_loop
    jmp _interpret_loop
_number_double:
    ; lea x3, state_var
    lea rax, state_var
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbnz    x3, _compile_dlit
    mov rax, QWORD PTR arm_x3
    cmp rax, 0
    jne _compile_dlit
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
    ; b       _interpret_loop
    jmp _interpret_loop
_compile_dlit:
    ; stp     x1, x2, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10+8], rax
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_37
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_37:
    ; ldr     x0, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_38
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_38:
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_39
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_39:
    ; ldr     x0, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_40
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_40:
    ; add     sp, sp, #16
    mov rax, rsp
    add rax, 10h
    mov rsp, rax
    ; b       _interpret_loop
    jmp _interpret_loop
_try_charlit:
    ; cmp     x26, #3
    mov rax, QWORD PTR arm_x26
    cmp rax, 3
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _try_float
    cmp BYTE PTR arm_z, 0
    je _try_float
    ; ldrb    w2, [x25]
    mov r10, QWORD PTR arm_x25
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cmp     w2, #39
    mov eax, DWORD PTR arm_x2
    cmp eax, 27h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _try_float
    cmp BYTE PTR arm_z, 0
    je _try_float
    ; ldrb    w2, [x25, #2]
    mov r10, QWORD PTR arm_x25
    add r10, 2
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cmp     w2, #39
    mov eax, DWORD PTR arm_x2
    cmp eax, 27h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _try_float
    cmp BYTE PTR arm_z, 0
    je _try_float
    ; ldrb    w1, [x25, #1]
    mov r10, QWORD PTR arm_x25
    add r10, 1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, state_var
    lea rax, state_var
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbnz    x2, _compile_lit
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    jne _compile_lit
    ; mov     x0, x1
    mov rax, QWORD PTR arm_x1
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
    ; b       _interpret_loop
    jmp _interpret_loop
_try_float:
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
    ; mov     x0, #100
    mov rax, 64h
    mov QWORD PTR arm_x0, rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR arm_x1, rax
    ; mov     x2, x26
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR arm_x2, rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR arm_x3, rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR arm_x4, rax
    ; mov     x5, x25
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR arm_x5, rax
    ; add     x6, sp, #48
    mov rax, rsp
    add rax, 30h
    mov QWORD PTR arm_x6, rax
    ; str     xzr, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov QWORD PTR [r10], 0
    ; str     xzr, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov QWORD PTR [r10], 0
    ; str     xzr, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov QWORD PTR [r10], 0
    ; bl      host_float_op
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
    call host_float_op
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldr     x6, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; ldr     x7, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x7, rax
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
    ; cbz     x6, _interpret_undef
    mov rax, QWORD PTR arm_x6
    cmp rax, 0
    je _interpret_undef
    ; mov     x26, x7
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR arm_x26, rax
    ; lea x2, state_var
    lea rax, state_var
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cbnz    x2, _compile_flit
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    jne _compile_flit
    ; mov     x1, x26
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR arm_x1, rax
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
    ; add     x6, sp, #48
    mov rax, rsp
    add rax, 30h
    mov QWORD PTR arm_x6, rax
    ; str     xzr, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov QWORD PTR [r10], 0
    ; str     xzr, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov QWORD PTR [r10], 0
    ; str     xzr, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov QWORD PTR [r10], 0
    ; bl      host_float_op
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
    call host_float_op
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
    ; add     sp, sp, #80
    mov rax, rsp
    add rax, 50h
    mov rsp, rax
    ; b       _interpret_loop
    jmp _interpret_loop
_compile_flit:
    ; mov     x25, x26
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR arm_x25, rax
    ; lea x0, cfa_flit
    lea rax, cfa_flit
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_41
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_41:
    ; mov     x0, x25
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR arm_x0, rax
    ; bl      _compile_cell
    lea rax, xret_42
    mov QWORD PTR arm_x30, rax
    jmp _compile_cell
    xret_42:
    ; b       _interpret_loop
    jmp _interpret_loop
_interpret_undef:
    ; mov     x0, x25
    mov rax, QWORD PTR arm_x25
    mov QWORD PTR arm_x0, rax
    ; mov     x1, x26
    mov rax, QWORD PTR arm_x26
    mov QWORD PTR arm_x1, rax
    ; bl      emit_str
    lea rax, xret_43
    mov QWORD PTR arm_x30, rax
    jmp emit_str
    xret_43:
    ; lea x0, msg_huh
    lea rax, msg_huh
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_44
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_44:
    ; lea x7, throw_handler
    lea rax, throw_handler
    mov QWORD PTR arm_x7, rax
    ; ldr     x1, [x7]
    mov r10, QWORD PTR arm_x7
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _undef_abandon
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _undef_abandon
    ; mov     x20, #-13
    mov rax, -13
    mov QWORD PTR arm_x20, rax
    ; b       XTHROW
    jmp XTHROW
_undef_abandon:
    ; lea x22, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x22, rax
    ; add     x22, x22, #1, lsl #12
    mov rax, QWORD PTR arm_x22
    add rax, 1000h
    mov QWORD PTR arm_x22, rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
    ; bl      _local_compile_reset
    lea rax, xret_45
    mov QWORD PTR arm_x30, rax
    jmp _local_compile_reset
    xret_45:
    ; lea x0, noname_xt
    lea rax, noname_xt
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; b       _do_quit
    jmp _do_quit
_interpret_empty:
    ; lea x0, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _ie_whole
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _ie_whole
    ; bl      _take_line
    lea rax, xret_46
    mov QWORD PTR arm_x30, rax
    jmp _take_line
    xret_46:
    ; cbnz    x0, _interpret_loop
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    jne _interpret_loop
    ; b       _ie_pop
    jmp _ie_pop
_ie_whole:
    ; lea x0, source_sp
    lea rax, source_sp
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _embed_finish
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _embed_finish
_ie_pop:
    ; lea x0, source_id
    lea rax, source_id
    mov QWORD PTR arm_x0, rax
    ; ldr     x25, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x25, rax
    ; bl      _pop_source
    lea rax, xret_47
    mov QWORD PTR arm_x30, rax
    jmp _pop_source
    xret_47:
    ; cbz     x0, _embed_finish
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _embed_finish
    ; cmp     x25, #0
    mov rax, QWORD PTR arm_x25
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.gt    _ie_view_pop
    cmp BYTE PTR arm_z, 0
    jne xsk_48
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _ie_view_pop
    xsk_48:
    ; cmn     x25, #2
    mov rax, QWORD PTR arm_x25
    add rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    _ie_after_view
    cmp BYTE PTR arm_z, 0
    je _ie_after_view
_ie_view_pop:
    ; bl      _view_pop_src_id
    lea rax, xret_49
    mov QWORD PTR arm_x30, rax
    jmp _view_pop_src_id
    xret_49:
_ie_after_view:
    ; cmn     x25, #1
    mov rax, QWORD PTR arm_x25
    add rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.eq    _ie_resume
    cmp BYTE PTR arm_z, 0
    jne _ie_resume
    ; cmn     x25, #2
    mov rax, QWORD PTR arm_x25
    add rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    _interpret_loop
    cmp BYTE PTR arm_z, 0
    je _interpret_loop
_ie_resume:
    ; bl      _eval_resume_pop
    lea rax, xret_50
    mov QWORD PTR arm_x30, rax
    jmp _eval_resume_pop
    xret_50:
    ; cbz     x0, _interpret_loop
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _interpret_loop
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR arm_x28
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR arm_x19
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x21, rax
    mov rax, QWORD PTR arm_x19
    add rax, 8
    mov QWORD PTR arm_x19, rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR arm_x21
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; br      x1
    mov rax, QWORD PTR arm_x1
    jmp rax
_do_quit:
    ; lea x23, return_stack
    lea rax, return_stack
    mov QWORD PTR arm_x23, rax
    ; add     x23, x23, #1, lsl #12
    mov rax, QWORD PTR arm_x23
    add rax, 1000h
    mov QWORD PTR arm_x23, rax
    ; lea x0, throw_handler
    lea rax, throw_handler
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, source_sp
    lea rax, source_sp
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, eval_resume_sp
    lea rax, eval_resume_sp
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, source_id
    lea rax, source_id
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, view_src_id
    lea rax, view_src_id
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, view_id_sp
    lea rax, view_id_sp
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, blk_var
    lea rax, blk_var
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; lea x0, local_frame_depth
    lea rax, local_frame_depth
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
    ; bl      _vm_save
    lea rax, xret_51
    mov QWORD PTR arm_x30, rax
    jmp _vm_save
    xret_51:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; b       _embed_ret_x0
    jmp _embed_ret_x0
_embed_finish:
    ; bl      _record_words_user_base_once
    lea rax, xret_52
    mov QWORD PTR arm_x30, rax
    jmp _record_words_user_base_once
    xret_52:
    ; bl      _vm_save
    lea rax, xret_53
    mov QWORD PTR arm_x30, rax
    jmp _vm_save
    xret_53:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; b       _embed_ret_x0
    jmp _embed_ret_x0
_quit_exit:
    ; b       _embed_bye_return
    jmp _embed_bye_return
_embed_bye_return:
    ; bl      _vm_save
    lea rax, xret_54
    mov QWORD PTR arm_x30, rax
    jmp _vm_save
    xret_54:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; b       _embed_ret_x0
    jmp _embed_ret_x0
_embed_ret_x0:
    ; ldp     x27, x28, [sp, #112]
    lea r10, [rsp]
    add r10, 70h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x27, rax
    mov QWORD PTR arm_x28, rcx
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
    ; add     sp, sp, #128
    mov rax, rsp
    add rax, 80h
    mov rsp, rax
    ; ret
    mov rax, QWORD PTR arm_x0
    ret
_check_stack:
    ; lea x0, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x0, rax
    ; add     x1, x0, #1, lsl #12
    mov rax, QWORD PTR arm_x0
    add rax, 1000h
    mov QWORD PTR arm_x1, rax
    ; cmp     x22, x1
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hi    _stack_underflow
    cmp BYTE PTR arm_c, 0
    je xsk_55
    cmp BYTE PTR arm_z, 0
    je _stack_underflow
    xsk_55:
    ; cmp     x22, x0
    mov rax, QWORD PTR arm_x22
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _stack_overflow
    cmp BYTE PTR arm_c, 0
    je _stack_overflow
    ; ret
    jmp QWORD PTR arm_x30
_stack_underflow:
    ; lea x0, msg_underflow
    lea rax, msg_underflow
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_56
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_56:
    ; b       _stack_reset_abandon
    jmp _stack_reset_abandon
_stack_overflow:
    ; lea x0, msg_overflow
    lea rax, msg_overflow
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_57
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_57:
_stack_reset_abandon:
    ; b       _undef_abandon
    jmp _undef_abandon
_file_echo_upto_cursor:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; lea x0, file_echo
    lea rax, file_echo
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cbz     x0, _fe_done
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _fe_done
    ; lea x0, source_id
    lea rax, source_id
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x0, #0
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.gt    _fe_on
    cmp BYTE PTR arm_z, 0
    jne xsk_58
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _fe_on
    xsk_58:
    ; cmn     x0, #2
    mov rax, QWORD PTR arm_x0
    add rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    _fe_done
    cmp BYTE PTR arm_z, 0
    je _fe_done
_fe_on:
    ; sub     sp, sp, #48
    mov rax, rsp
    sub rax, 30h
    mov rsp, rax
    ; lea x4, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x4, rax
    ; ldr     x4, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     x4, _fe_src
    mov rax, QWORD PTR arm_x4
    cmp rax, 0
    je _fe_src
    ; lea x1, line_origin
    lea rax, line_origin
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, line_limit
    lea rax, line_limit
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; b       _fe_bounds
    jmp _fe_bounds
_fe_src:
    ; lea x1, source_base
    lea rax, source_base
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; lea x2, source_end
    lea rax, source_end
    mov QWORD PTR arm_x2, rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
_fe_bounds:
    ; str     x1, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; str     x2, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; lea x0, source_cur
    lea rax, source_cur
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _fe_clamp_hi
    cmp BYTE PTR arm_c, 0
    jne _fe_clamp_hi
    ; mov     x0, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x0, rax
_fe_clamp_hi:
    ; cmp     x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _fe_skip
    cmp BYTE PTR arm_c, 0
    je _fe_skip
    cmp BYTE PTR arm_z, 0
    jne _fe_skip
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
_fe_skip:
    ; cmp     x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _fe_eol
    cmp BYTE PTR arm_c, 0
    jne _fe_eol
    ; ldrb    w3, [x0]
    mov r10, QWORD PTR arm_x0
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; cbz     w3, _fe_eol
    mov eax, DWORD PTR arm_x3
    cmp rax, 0
    je _fe_eol
    ; cmp     w3, #32
    mov eax, DWORD PTR arm_x3
    cmp eax, 20h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fe_skip1
    cmp BYTE PTR arm_z, 0
    jne _fe_skip1
    ; cmp     w3, #9
    mov eax, DWORD PTR arm_x3
    cmp eax, 9
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fe_skip1
    cmp BYTE PTR arm_z, 0
    jne _fe_skip1
    ; cmp     w3, #10
    mov eax, DWORD PTR arm_x3
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fe_skip1
    cmp BYTE PTR arm_z, 0
    jne _fe_skip1
    ; cmp     w3, #13
    mov eax, DWORD PTR arm_x3
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fe_skip1
    cmp BYTE PTR arm_z, 0
    jne _fe_skip1
    ; b       _fe_eol
    jmp _fe_eol
_fe_skip1:
    ; add     x0, x0, #1
    mov rax, QWORD PTR arm_x0
    add rax, 1
    mov QWORD PTR arm_x0, rax
    ; b       _fe_skip
    jmp _fe_skip
_fe_eol:
    ; mov     x3, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x3, rax
_fe_eol_scan:
    ; cmp     x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _fe_eol_ok
    cmp BYTE PTR arm_c, 0
    jne _fe_eol_ok
    ; ldrb    w4, [x3]
    mov r10, QWORD PTR arm_x3
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _fe_eol_ok
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _fe_eol_ok
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fe_eol_ok
    cmp BYTE PTR arm_z, 0
    jne _fe_eol_ok
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fe_eol_ok
    cmp BYTE PTR arm_z, 0
    jne _fe_eol_ok
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _fe_eol_scan
    jmp _fe_eol_scan
_fe_eol_ok:
    ; str     x3, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; lea x4, file_echo_pos
    lea rax, file_echo_pos
    mov QWORD PTR arm_x4, rax
    ; ldr     x0, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [sp]
    lea r10, [rsp]
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
    ; b.hs    _fe_pos_hi
    cmp BYTE PTR arm_c, 0
    jne _fe_pos_hi
    ; mov     x0, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x0, rax
_fe_pos_hi:
    ; ldr     x2, [sp, #8]
    lea r10, [rsp]
    add r10, 8
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
    ; b.ls    _fe_pos_ok
    cmp BYTE PTR arm_c, 0
    je _fe_pos_ok
    cmp BYTE PTR arm_z, 0
    jne _fe_pos_ok
    ; mov     x0, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x0, rax
_fe_pos_ok:
    ; str     x0, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; ldr     x3, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
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
    ; b.hs    _fe_drop
    cmp BYTE PTR arm_c, 0
    jne _fe_drop
_fe_line:
    ; ldr     x0, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; ldr     x3, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
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
    ; b.hs    _fe_drop
    cmp BYTE PTR arm_c, 0
    jne _fe_drop
    ; ldr     x1, [sp]
    lea r10, [rsp]
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
    ; b.eq    _fe_num
    cmp BYTE PTR arm_z, 0
    jne _fe_num
    ; ldrb    w4, [x0, #-1]
    mov r10, QWORD PTR arm_x0
    add r10, -1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fe_num
    cmp BYTE PTR arm_z, 0
    jne _fe_num
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fe_num
    cmp BYTE PTR arm_z, 0
    jne _fe_num
    ; b       _fe_text
    jmp _fe_text
_fe_num:
    ; mov     x4, #1
    mov rax, 1
    mov QWORD PTR arm_x4, rax
    ; mov     x3, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x3, rax
_fe_count:
    ; cmp     x3, x0
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _fe_count_done
    cmp BYTE PTR arm_c, 0
    jne _fe_count_done
    ; ldrb    w5, [x3]
    mov r10, QWORD PTR arm_x3
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x5, rax
    ; cmp     w5, #10
    mov eax, DWORD PTR arm_x5
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _fe_count_next
    cmp BYTE PTR arm_z, 0
    je _fe_count_next
    ; add     x4, x4, #1
    mov rax, QWORD PTR arm_x4
    add rax, 1
    mov QWORD PTR arm_x4, rax
_fe_count_next:
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _fe_count
    jmp _fe_count
_fe_count_done:
    ; mov     x0, x4
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR arm_x0, rax
    ; bl      _fe_emit_lineno
    lea rax, xret_59
    mov QWORD PTR arm_x30, rax
    jmp _fe_emit_lineno
    xret_59:
_fe_text:
    ; ldr     x0, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; ldr     x2, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; mov     x3, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x3, rax
_fe_text_scan:
    ; cmp     x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _fe_text_write
    cmp BYTE PTR arm_c, 0
    jne _fe_text_write
    ; ldrb    w4, [x3]
    mov r10, QWORD PTR arm_x3
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cbz     w4, _fe_text_write
    mov eax, DWORD PTR arm_x4
    cmp rax, 0
    je _fe_text_write
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fe_text_write
    cmp BYTE PTR arm_z, 0
    jne _fe_text_write
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fe_text_write
    cmp BYTE PTR arm_z, 0
    jne _fe_text_write
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; b       _fe_text_scan
    jmp _fe_text_scan
_fe_text_write:
    ; mov     x1, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x1, rax
    ; ldr     x0, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; subs    x1, x1, x0
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x0
    sub rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x1, rax
    ; b.eq    _fe_advance
    cmp BYTE PTR arm_z, 0
    jne _fe_advance
    ; str     x3, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; bl      emit_str
    lea rax, xret_60
    mov QWORD PTR arm_x30, rax
    jmp emit_str
    xret_60:
    ; ldr     x3, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
_fe_advance:
    ; ldr     x2, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; mov     x1, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x1, rax
    ; cmp     x3, x2
    mov rax, QWORD PTR arm_x3
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _fe_store
    cmp BYTE PTR arm_c, 0
    jne _fe_store
    ; ldrb    w0, [x3]
    mov r10, QWORD PTR arm_x3
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     w0, #10
    mov eax, DWORD PTR arm_x0
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _fe_one
    cmp BYTE PTR arm_z, 0
    jne _fe_one
    ; cmp     w0, #13
    mov eax, DWORD PTR arm_x0
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _fe_store
    cmp BYTE PTR arm_z, 0
    je _fe_store
    ; add     x1, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, x2
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _fe_store
    cmp BYTE PTR arm_c, 0
    jne _fe_store
    ; ldrb    w0, [x1]
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     w0, #10
    mov eax, DWORD PTR arm_x0
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _fe_store
    cmp BYTE PTR arm_z, 0
    je _fe_store
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _fe_store
    jmp _fe_store
_fe_one:
    ; add     x1, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x1, rax
_fe_store:
    ; str     x1, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x4, file_echo_pos
    lea rax, file_echo_pos
    mov QWORD PTR arm_x4, rax
    ; str     x1, [x4]
    mov r10, QWORD PTR arm_x4
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_61
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_61:
    ; b       _fe_line
    jmp _fe_line
_fe_drop:
    ; add     sp, sp, #48
    mov rax, rsp
    add rax, 30h
    mov rsp, rax
_fe_done:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_fe_emit_lineno:
    ; stp     x29, x30, [sp, #-32]!
    add rsp, -32
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; str     x0, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR arm_x1, rax
    ; mov     x2, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x2, rax
_fe_digits:
    ; cmp     x0, x2
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _fe_pad
    cmp BYTE PTR arm_c, 0
    je _fe_pad
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; mov     x3, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x3, rax
    ; mul     x2, x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    imul rax, rcx
    mov QWORD PTR arm_x2, rax
    ; cmp     x1, #5
    mov rax, QWORD PTR arm_x1
    cmp rax, 5
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.lo    _fe_digits
    cmp BYTE PTR arm_c, 0
    je _fe_digits
_fe_pad:
    ; mov     x2, #5
    mov rax, 5
    mov QWORD PTR arm_x2, rax
    ; subs    x2, x2, x1
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x1
    sub rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x2, rax
    ; b.ls    _fe_print
    cmp BYTE PTR arm_c, 0
    je _fe_print
    cmp BYTE PTR arm_z, 0
    jne _fe_print
_fe_spaces:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; str     x2, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR [r10], rax
    ; bl      _putchar
    lea rax, xret_62
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_62:
    ; ldr     x2, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; subs    x2, x2, #1
    mov rax, QWORD PTR arm_x2
    sub rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    mov QWORD PTR arm_x2, rax
    ; b.ne    _fe_spaces
    cmp BYTE PTR arm_z, 0
    je _fe_spaces
_fe_print:
    ; ldr     x0, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _print_unsigned
    lea rax, xret_63
    mov QWORD PTR arm_x30, rax
    jmp _print_unsigned
    xret_63:
    ; mov     x0, #124
    mov rax, 7Ch
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_64
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_64:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR arm_x0, rax
    ; bl      _putchar
    lea rax, xret_65
    mov QWORD PTR arm_x30, rax
    jmp _putchar
    xret_65:
    ; ldp     x29, x30, [sp], #32
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 20h
    ; ret
    jmp QWORD PTR arm_x30
_arm_lines:
    ; lea x2, file_echo_pos
    lea rax, file_echo_pos
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, line_origin
    lea rax, line_origin
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; add     x3, x0, x1
    mov rax, QWORD PTR arm_x0
    mov rcx, QWORD PTR arm_x1
    add rax, rcx
    mov QWORD PTR arm_x3, rax
    ; lea x2, line_limit
    lea rax, line_limit
    mov QWORD PTR arm_x2, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; lea x2, line_next
    lea rax, line_next
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; mov     x3, #1
    mov rax, 1
    mov QWORD PTR arm_x3, rax
    ; lea x2, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x2, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; ret
    jmp QWORD PTR arm_x30
_take_line:
    ; lea x2, line_next
    lea rax, line_next
    mov QWORD PTR arm_x2, rax
    ; ldr     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; lea x3, line_limit
    lea rax, line_limit
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
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
    ; b.hs    _tl_eof
    cmp BYTE PTR arm_c, 0
    jne _tl_eof
    ; mov     x1, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x1, rax
_tl_scan:
    ; cmp     x1, x3
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _tl_eos
    cmp BYTE PTR arm_c, 0
    jne _tl_eos
    ; ldrb    w4, [x1]
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _tl_lf
    cmp BYTE PTR arm_z, 0
    jne _tl_lf
    ; cmp     w4, #13
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _tl_cr
    cmp BYTE PTR arm_z, 0
    jne _tl_cr
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _tl_scan
    jmp _tl_scan
_tl_lf:
    ; mov     x5, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x5, rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _tl_set
    jmp _tl_set
_tl_cr:
    ; mov     x5, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x5, rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, x3
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x3
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _tl_set
    cmp BYTE PTR arm_c, 0
    jne _tl_set
    ; ldrb    w4, [x1]
    mov r10, QWORD PTR arm_x1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x4, rax
    ; cmp     w4, #10
    mov eax, DWORD PTR arm_x4
    cmp eax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    _tl_set
    cmp BYTE PTR arm_z, 0
    je _tl_set
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; b       _tl_set
    jmp _tl_set
_tl_eos:
    ; mov     x5, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x5, rax
_tl_set:
    ; lea x2, line_next
    lea rax, line_next
    mov QWORD PTR arm_x2, rax
    ; str     x1, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x2, source_base
    lea rax, source_base
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x2, source_end
    lea rax, source_end
    mov QWORD PTR arm_x2, rax
    ; str     x5, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [r10], rax
    ; lea x2, to_in
    lea rax, to_in
    mov QWORD PTR arm_x2, rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR arm_x2
    mov QWORD PTR [r10], 0
    ; lea x2, source_cur
    lea rax, source_cur
    mov QWORD PTR arm_x2, rax
    ; str     x0, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_tl_eof:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_push_source:
    ; lea x0, source_sp
    lea rax, source_sp
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, #8
    mov rax, QWORD PTR arm_x1
    cmp rax, 8
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _ps_full
    cmp BYTE PTR arm_c, 0
    jne _ps_full
    ; lsl     x3, x1, #6
    mov rax, QWORD PTR arm_x1
    shl rax, 6
    mov QWORD PTR arm_x3, rax
    ; lea x2, source_stack
    lea rax, source_stack
    mov QWORD PTR arm_x2, rax
    ; add     x2, x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    add rax, rcx
    mov QWORD PTR arm_x2, rax
    ; lea x3, source_base
    lea rax, source_base
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x3, source_end
    lea rax, source_end
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x3, to_in
    lea rax, to_in
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x3, source_id
    lea rax, source_id
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x3, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x3, line_origin
    lea rax, line_origin
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x3, line_limit
    lea rax, line_limit
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x3, line_next
    lea rax, line_next
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; lea x3, file_echo_pos
    lea rax, file_echo_pos
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; lea x2, file_echo_stack
    lea rax, file_echo_stack
    mov QWORD PTR arm_x2, rax
    ; str     x3, [x2, x1, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; lea x3, blk_var
    lea rax, blk_var
    mov QWORD PTR arm_x3, rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR arm_x3
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; lea x2, blk_stack
    lea rax, blk_stack
    mov QWORD PTR arm_x2, rax
    ; str     x3, [x2, x1, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    add r10, rax
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
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_ps_full:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_pop_source:
    ; lea x0, source_sp
    lea rax, source_sp
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _pop_empty
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _pop_empty
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lsl     x3, x1, #6
    mov rax, QWORD PTR arm_x1
    shl rax, 6
    mov QWORD PTR arm_x3, rax
    ; lea x2, source_stack
    lea rax, source_stack
    mov QWORD PTR arm_x2, rax
    ; add     x2, x2, x3
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x3
    add rax, rcx
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x0, source_base
    lea rax, source_base
    mov QWORD PTR arm_x0, rax
    ; str     x3, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; mov     x4, x3
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR arm_x4, rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x0, source_end
    lea rax, source_end
    mov QWORD PTR arm_x0, rax
    ; str     x3, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x0, to_in
    lea rax, to_in
    mov QWORD PTR arm_x0, rax
    ; str     x3, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; add     x4, x4, x3
    mov rax, QWORD PTR arm_x4
    mov rcx, QWORD PTR arm_x3
    add rax, rcx
    mov QWORD PTR arm_x4, rax
    ; lea x0, source_cur
    lea rax, source_cur
    mov QWORD PTR arm_x0, rax
    ; str     x4, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x0, source_id
    lea rax, source_id
    mov QWORD PTR arm_x0, rax
    ; str     x3, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x0, line_mode
    lea rax, line_mode
    mov QWORD PTR arm_x0, rax
    ; str     x3, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x0, line_origin
    lea rax, line_origin
    mov QWORD PTR arm_x0, rax
    ; str     x3, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    mov rax, QWORD PTR arm_x2
    add rax, 8
    mov QWORD PTR arm_x2, rax
    ; lea x0, line_limit
    lea rax, line_limit
    mov QWORD PTR arm_x0, rax
    ; str     x3, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; lea x0, line_next
    lea rax, line_next
    mov QWORD PTR arm_x0, rax
    ; str     x3, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; lea x2, file_echo_stack
    lea rax, file_echo_stack
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2, x1, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; lea x0, file_echo_pos
    lea rax, file_echo_pos
    mov QWORD PTR arm_x0, rax
    ; str     x3, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; lea x2, blk_stack
    lea rax, blk_stack
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2, x1, lsl #3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; lea x0, blk_var
    lea rax, blk_var
    mov QWORD PTR arm_x0, rax
    ; str     x3, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_pop_empty:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_eval_resume_push:
    ; lea x0, eval_resume_sp
    lea rax, eval_resume_sp
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cmp     x1, #8
    mov rax, QWORD PTR arm_x1
    cmp rax, 8
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _erp_full
    cmp BYTE PTR arm_c, 0
    jne _erp_full
    ; lea x2, eval_resume_stack
    lea rax, eval_resume_stack
    mov QWORD PTR arm_x2, rax
    ; lsl     x3, x1, #3
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    mov QWORD PTR arm_x3, rax
    ; str     x19, [x2, x3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    add r10, rax
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10], rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    add rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
_erp_full:
    ; ret
    jmp QWORD PTR arm_x30
_eval_resume_pop:
    ; lea x0, eval_resume_sp
    lea rax, eval_resume_sp
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, _erpop_empty
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _erpop_empty
    ; sub     x1, x1, #1
    mov rax, QWORD PTR arm_x1
    sub rax, 1
    mov QWORD PTR arm_x1, rax
    ; str     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; lea x2, eval_resume_stack
    lea rax, eval_resume_stack
    mov QWORD PTR arm_x2, rax
    ; lsl     x3, x1, #3
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    mov QWORD PTR arm_x3, rax
    ; ldr     x0, [x2, x3]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_erpop_empty:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; ret
    jmp QWORD PTR arm_x30
_throw_unwind_to_sp:
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
    ; str     x0, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
_tu_loop:
    ; lea x0, source_sp
    lea rax, source_sp
    mov QWORD PTR arm_x0, rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; ldr     x2, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x2, rax
    ; cmp     x1, x2
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x2
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ls    _tu_done
    cmp BYTE PTR arm_c, 0
    je _tu_done
    cmp BYTE PTR arm_z, 0
    jne _tu_done
    ; lea x0, source_id
    lea rax, source_id
    mov QWORD PTR arm_x0, rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; str     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; bl      _pop_source
    lea rax, xret_66
    mov QWORD PTR arm_x30, rax
    jmp _pop_source
    xret_66:
    ; cbz     x0, _tu_done
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    je _tu_done
    ; ldr     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; cmp     x0, #0
    mov rax, QWORD PTR arm_x0
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.gt    _tu_view
    cmp BYTE PTR arm_z, 0
    jne xsk_67
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    je _tu_view
    xsk_67:
    ; cmn     x0, #2
    mov rax, QWORD PTR arm_x0
    add rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.ne    _tu_loop
    cmp BYTE PTR arm_z, 0
    je _tu_loop
_tu_view:
    ; bl      _view_pop_src_id
    lea rax, xret_68
    mov QWORD PTR arm_x30, rax
    jmp _view_pop_src_id
    xret_68:
    ; b       _tu_loop
    jmp _tu_loop
_tu_done:
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
_vm_save:
    ; lea x0, vm_tos
    lea rax, vm_tos
    mov QWORD PTR arm_x0, rax
    ; str     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10], rax
    ; lea x0, vm_dsp
    lea rax, vm_dsp
    mov QWORD PTR arm_x0, rax
    ; str     x22, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10], rax
    ; lea x0, vm_rsp
    lea rax, vm_rsp
    mov QWORD PTR arm_x0, rax
    ; str     x23, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR arm_x23
    mov QWORD PTR [r10], rax
    ; ret
    jmp QWORD PTR arm_x30
_vm_load:
    ; lea x24, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x24, rax
    ; lea x0, vm_tos
    lea rax, vm_tos
    mov QWORD PTR arm_x0, rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x20, rax
    ; lea x0, vm_dsp
    lea rax, vm_dsp
    mov QWORD PTR arm_x0, rax
    ; ldr     x22, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x22, rax
    ; lea x0, vm_rsp
    lea rax, vm_rsp
    mov QWORD PTR arm_x0, rax
    ; ldr     x23, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x23, rax
    ; lea x0, debug_armed
    lea rax, debug_armed
    mov QWORD PTR arm_x0, rax
    ; ldr     x28, [x0]
    mov r10, QWORD PTR arm_x0
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x28, rax
    ; cbnz    x22, _vm_load_ok
    mov rax, QWORD PTR arm_x22
    cmp rax, 0
    jne _vm_load_ok
    ; b       _vm_reset_stacks
    jmp _vm_reset_stacks
_vm_load_ok:
    ; ret
    jmp QWORD PTR arm_x30
_vm_reset_stacks:
    ; lea x22, data_stack
    lea rax, data_stack
    mov QWORD PTR arm_x22, rax
    ; add     x22, x22, #1, lsl #12
    mov rax, QWORD PTR arm_x22
    add rax, 1000h
    mov QWORD PTR arm_x22, rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR arm_x20, rax
    ; lea x23, return_stack
    lea rax, return_stack
    mov QWORD PTR arm_x23, rax
    ; add     x23, x23, #1, lsl #12
    mov rax, QWORD PTR arm_x23
    add rax, 1000h
    mov QWORD PTR arm_x23, rax
    ; lea x24, latest_var
    lea rax, latest_var
    mov QWORD PTR arm_x24, rax
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR arm_x0, rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR arm_x0
    mov QWORD PTR [r10], 0
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
msg_huh:
    ; DCB     " ?", 10, 0
    DB " ?", 0Ah, 0
msg_underflow:
    ; DCB     "stack underflow", 10, 0
    DB "stack underflow", 0Ah, 0
msg_overflow:
    ; DCB     "stack overflow", 10, 0
    DB "stack overflow", 0Ah, 0
    ; ALIGN   8
ALIGN 8
boot_cmp_lit:
    ; DCB     "LIT", 0
    DB "LIT", 0
boot_cmp_exit:
    ; DCB     "EXIT", 0
    DB "EXIT", 0
boot_cmp_branch:
    ; DCB     "BRANCH", 0
    DB "BRANCH", 0
boot_cmp_0branch:
    ; DCB    "0BRANCH", 0
    DB "0BRANCH", 0
boot_cmp_does:
    ; DCB     "(DOES>)", 0
    DB "(DOES>)", 0
boot_cmp_slit:
    ; DCB     "(S", 0x22, ")", 0
    DB "(S", 22h, ")", 0
boot_cmp_cstr:
    ; DCB     "(C", 0x22, ")", 0
    DB "(C", 22h, ")", 0
boot_cmp_execute:
    ; DCB    "EXECUTE", 0
    DB "EXECUTE", 0
boot_cmp_comma:
    ; DCB     0x2C, 0
    DB 2Ch, 0
boot_cmp_flit:
    ; DCB     "FLIT", 0
    DB "FLIT", 0
boot_cmp_linit:
    ; DCB     "LOCAL-INIT", 0
    DB "LOCAL-INIT", 0
boot_cmp_lat:
    ; DCB     "(LOCAL@)", 0
    DB "(LOCAL@)", 0
boot_cmp_lstore:
    ; DCB     "(LOCAL!)", 0
    DB "(LOCAL!)", 0
boot_cmp_loop:
    ; DCB     "(LOOP)", 0
    DB "(LOOP)", 0
boot_cmp_ploop:
    ; DCB     "(+LOOP)", 0
    DB "(+LOOP)", 0
END
