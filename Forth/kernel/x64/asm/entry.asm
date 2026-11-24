; Generated from Forth/kernel/arm64/entry.asm. Do not edit.
OPTION CASEMAP:NONE
EXTRN arm_load_base:PROC
EXTRN arm_excl:QWORD
EXTRN arm_excl_addr:QWORD
EXTRN arm_excl_val:QWORD
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
EXTRN _task_cold_init:PROC
EXTRN _view_pop_src_id:PROC
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
EXTRN debug_bp_go:BYTE
EXTRN debug_break_asap:BYTE
EXTRN debug_busy:BYTE
EXTRN debug_floor:BYTE
EXTRN debug_runto_ip:BYTE
EXTRN emit_cstr:PROC
EXTRN emit_hook:BYTE
EXTRN emit_str:PROC
EXTRN eval_frame_sp:BYTE
EXTRN facility_op_hook:BYTE
EXTRN file_echo:BYTE
EXTRN forth_init_end:BYTE
EXTRN forth_init_str:BYTE
EXTRN here_ptr:BYTE
EXTRN host_debug_paint:PROC
EXTRN host_eval_fault_enter:PROC
EXTRN host_eval_fault_leave:PROC
EXTRN host_float_op:PROC
EXTRN kernel_inited:BYTE
EXTRN key_hook:BYTE
EXTRN last_cfa:BYTE
EXTRN latest_var:BYTE
EXTRN local_frame_depth:BYTE
EXTRN next_debug:PROC
EXTRN noname_xt:BYTE
EXTRN pause_hook:BYTE
EXTRN restart_cell:BYTE
EXTRN return_stack:BYTE
EXTRN state_var:BYTE
EXTRN throw_handler:BYTE
EXTRN up_var:BYTE
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
PUBLIC kernel_set_pause
PUBLIC _kernel_set_pause
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
PUBLIC _set_source
PUBLIC _take_line
PUBLIC _push_source
PUBLIC _pop_source
PUBLIC _eval_resume_push
PUBLIC _eval_resume_pop
PUBLIC _throw_unwind_to_sp
PUBLIC _quit_exit
PUBLIC _embed_bye_return
PUBLIC _embed_ret_x0
PUBLIC eval_fault_resume
_kernel_set_emit:
kernel_set_emit:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; lea x1, emit_hook
    lea rax, emit_hook
    mov QWORD PTR [r15+8], rax
    ; str     x0, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
_kernel_set_key:
kernel_set_key:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; lea x1, key_hook
    lea rax, key_hook
    mov QWORD PTR [r15+8], rax
    ; str     x0, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
_kernel_set_pause:
kernel_set_pause:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; lea x1, pause_hook
    lea rax, pause_hook
    mov QWORD PTR [r15+8], rax
    ; str     x0, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
_kernel_set_facility_op:
kernel_set_facility_op:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; lea x1, facility_op_hook
    lea rax, facility_op_hook
    mov QWORD PTR [r15+8], rax
    ; str     x0, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
_kernel_init:
kernel_init:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; sub     sp, sp, #128
    mov rax, rsp
    sub rax, 80h
    mov rsp, rax
    ; lea x16, eval_frame_sp
    lea rax, eval_frame_sp
    mov QWORD PTR [r15+128], rax
    ; mov     x17, sp
    mov rax, rsp
    mov QWORD PTR [r15+136], rax
    ; str     x17, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r15+136]
    mov QWORD PTR [r10], rax
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
    ; stp     x25, x26, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+208]
    mov QWORD PTR [r10+8], rax
    ; stp     x27, x28, [sp, #112]
    lea r10, [rsp]
    add r10, 70h
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+224]
    mov QWORD PTR [r10+8], rax
    ; lea x0, kernel_inited
    lea rax, kernel_inited
    mov QWORD PTR [r15+0], rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, _kinit_already
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne _kinit_already
    ; bl      _kernel_cold_common
    lea rax, xret_1
    mov QWORD PTR [r15+240], rax
    jmp _kernel_cold_common
    xret_1:
    ; bl      _vm_save
    lea rax, xret_2
    mov QWORD PTR [r15+240], rax
    jmp _vm_save
    xret_2:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR [r15+8], rax
    ; lea x0, kernel_inited
    lea rax, kernel_inited
    mov QWORD PTR [r15+0], rax
    ; str     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; lea x0, forth_init_str
    lea rax, forth_init_str
    mov QWORD PTR [r15+0], rax
    ; lea x1, forth_init_end
    lea rax, forth_init_end
    mov QWORD PTR [r15+8], rax
    ; sub     x1, x1, x0
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+0]
    sub rax, rcx
    mov QWORD PTR [r15+8], rax
    ; sub     x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    sub rax, 1
    mov QWORD PTR [r15+8], rax
    ; bl      _set_source
    lea rax, xret_3
    mov QWORD PTR [r15+240], rax
    jmp _set_source
    xret_3:
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
    ; str     xzr, [x16, #TU_SRC_ID]
    mov r10, QWORD PTR [r15+128]
    add r10, 80h
    mov QWORD PTR [r10], 0
    ; lea x2, throw_handler
    lea rax, throw_handler
    mov QWORD PTR [r15+16], rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR [r15+16]
    mov QWORD PTR [r10], 0
    ; lea x2, bye_flag
    lea rax, bye_flag
    mov QWORD PTR [r15+16], rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR [r15+16]
    mov QWORD PTR [r10], 0
    ; bl      host_eval_fault_enter
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR [r15+0]
    mov rdx, QWORD PTR [r15+8]
    mov r8, QWORD PTR [r15+16]
    mov r9, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_eval_fault_enter
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; b       _interpret_loop
    jmp _interpret_loop
_kinit_already:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
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
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x27, #0
    mov rax, 0
    mov QWORD PTR [r15+216], rax
    ; lea x22, data_stack
    lea rax, data_stack
    mov QWORD PTR [r15+176], rax
    ; add     x22, x22, #1, lsl #12
    mov rax, QWORD PTR [r15+176]
    add rax, 1000h
    mov QWORD PTR [r15+176], rax
    ; lea x23, return_stack
    lea rax, return_stack
    mov QWORD PTR [r15+184], rax
    ; add     x23, x23, #1, lsl #12
    mov rax, QWORD PTR [r15+184]
    add rax, 1000h
    mov QWORD PTR [r15+184], rax
    ; lea x24, latest_var
    lea rax, latest_var
    mov QWORD PTR [r15+192], rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR [r15+160], rax
    ; mov     x28, #0
    mov rax, 0
    mov QWORD PTR [r15+224], rax
    ; mov     x0, x24
    mov rax, QWORD PTR [r15+192]
    mov QWORD PTR [r15+0], rax
    ; mov     x1, #16
    mov rax, 10h
    mov QWORD PTR [r15+8], rax
_cold_clear:
    ; str     xzr, [x0], #8
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    mov rax, QWORD PTR [r15+0]
    add rax, 8
    mov QWORD PTR [r15+0], rax
    ; subs    x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    sub rax, 1
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    mov QWORD PTR [r15+8], rax
    ; b.ne    _cold_clear
    cmp BYTE PTR [r15+249], 0
    je _cold_clear
    ; lea x0, last_cfa
    lea rax, last_cfa
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; lea x0, here_ptr
    lea rax, here_ptr
    mov QWORD PTR [r15+0], rax
    ; lea x1, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; lea x0, bye_flag
    lea rax, bye_flag
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; bl      _boot_kernel
    lea rax, xret_4
    mov QWORD PTR [r15+240], rax
    jmp _boot_kernel
    xret_4:
    ; lea x24, latest_var
    lea rax, latest_var
    mov QWORD PTR [r15+192], rax
    ; bl      _task_cold_init
    lea rax, xret_5
    mov QWORD PTR [r15+240], rax
    jmp _task_cold_init
    xret_5:
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
    ; ret
    jmp QWORD PTR [r15+240]
_boot_kernel:
    ; sub     sp, sp, #112
    mov rax, rsp
    sub rax, 70h
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
    ; str     x25, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r10], rax
    ; lea x19, bootptr_start
    lea rax, bootptr_start
    mov QWORD PTR [r15+152], rax
    ; lea x25, bootptr_end
    lea rax, bootptr_end
    mov QWORD PTR [r15+200], rax
_bk_loop:
    ; cmp     x19, x25
    mov rax, QWORD PTR [r15+152]
    mov rcx, QWORD PTR [r15+200]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _bk_done
    cmp BYTE PTR [r15+250], 0
    jne _bk_done
    ; ldr     x7, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+56], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; cbz     x7, _bk_loop
    mov rax, QWORD PTR [r15+56]
    cmp rax, 0
    je _bk_loop
    ; ldr     x20, [x7]
    mov r10, QWORD PTR [r15+56]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    ; cbz     x20, _bk_loop
    mov rax, QWORD PTR [r15+160]
    cmp rax, 0
    je _bk_loop
    ; ldr     x21, [x7, #8]
    mov r10, QWORD PTR [r15+56]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    ; ldr     x22, [x7, #16]
    mov r10, QWORD PTR [r15+56]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+176], rax
    ; ldr     x23, [x7, #24]
    mov r10, QWORD PTR [r15+56]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+184], rax
    ; mov     x0, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+0], rax
    ; bl      _strlen
    lea rax, xret_6
    mov QWORD PTR [r15+240], rax
    jmp _strlen
    xret_6:
    ; str     x0, [sp, #104]
    lea r10, [rsp]
    add r10, 68h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x0, x21
    mov rax, QWORD PTR [r15+168]
    mov QWORD PTR [r15+0], rax
    ; bl      _strlen
    lea rax, xret_7
    mov QWORD PTR [r15+240], rax
    jmp _strlen
    xret_7:
    ; mov     x3, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+24], rax
    ; ldr     x1, [sp, #104]
    lea r10, [rsp]
    add r10, 68h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; mov     x0, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+0], rax
    ; mov     x2, x21
    mov rax, QWORD PTR [r15+168]
    mov QWORD PTR [r15+16], rax
    ; mov     x4, x23
    mov rax, QWORD PTR [r15+184]
    mov QWORD PTR [r15+32], rax
    ; mov     x5, x22
    mov rax, QWORD PTR [r15+176]
    mov QWORD PTR [r15+40], rax
    ; bl      _header_build
    lea rax, xret_8
    mov QWORD PTR [r15+240], rax
    jmp _header_build
    xret_8:
    ; mov     x21, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+168], rax
    ; mov     x0, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+0], rax
    ; bl      _boot_cache_cfa
    lea rax, xret_9
    mov QWORD PTR [r15+240], rax
    jmp _boot_cache_cfa
    xret_9:
    ; b       _bk_loop
    jmp _bk_loop
_bk_done:
    ; ldr     x25, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+200], rax
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
    ; add     sp, sp, #112
    mov rax, rsp
    add rax, 70h
    mov rsp, rax
    ; ret
    jmp QWORD PTR [r15+240]
_boot_cache_cfa:
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
    ; stp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10+8], rax
    ; mov     x19, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+152], rax
    ; mov     x20, x21
    mov rax, QWORD PTR [r15+168]
    mov QWORD PTR [r15+160], rax
    ; lea x1, boot_cmp_lit
    lea rax, boot_cmp_lit
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_10
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_10:
    ; lea x1, boot_cmp_exit
    lea rax, boot_cmp_exit
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_exit
    lea rax, cfa_exit
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_11
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_11:
    ; lea x1, boot_cmp_branch
    lea rax, boot_cmp_branch
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_branch
    lea rax, cfa_branch
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_12
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_12:
    ; lea x1, boot_cmp_0branch
    lea rax, boot_cmp_0branch
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_0branch
    lea rax, cfa_0branch
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_13
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_13:
    ; lea x1, boot_cmp_does
    lea rax, boot_cmp_does
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_does
    lea rax, cfa_does
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_14
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_14:
    ; lea x1, boot_cmp_slit
    lea rax, boot_cmp_slit
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_slit
    lea rax, cfa_slit
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_15
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_15:
    ; lea x1, boot_cmp_cstr
    lea rax, boot_cmp_cstr
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_cstr
    lea rax, cfa_cstr
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_16
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_16:
    ; lea x1, boot_cmp_execute
    lea rax, boot_cmp_execute
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_execute
    lea rax, cfa_execute
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_17
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_17:
    ; lea x1, boot_cmp_comma
    lea rax, boot_cmp_comma
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_comma
    lea rax, cfa_comma
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_18
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_18:
    ; lea x1, boot_cmp_flit
    lea rax, boot_cmp_flit
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_flit
    lea rax, cfa_flit
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_19
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_19:
    ; lea x1, boot_cmp_linit
    lea rax, boot_cmp_linit
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_local_init
    lea rax, cfa_local_init
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_20
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_20:
    ; lea x1, boot_cmp_lat
    lea rax, boot_cmp_lat
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_local_at
    lea rax, cfa_local_at
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_21
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_21:
    ; lea x1, boot_cmp_lstore
    lea rax, boot_cmp_lstore
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_local_store
    lea rax, cfa_local_store
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_22
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_22:
    ; lea x1, boot_cmp_loop
    lea rax, boot_cmp_loop
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_loop
    lea rax, cfa_loop
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_23
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_23:
    ; lea x1, boot_cmp_ploop
    lea rax, boot_cmp_ploop
    mov QWORD PTR [r15+8], rax
    ; lea x2, cfa_plusloop
    lea rax, cfa_plusloop
    mov QWORD PTR [r15+16], rax
    ; bl      _bcc_match
    lea rax, xret_24
    mov QWORD PTR [r15+240], rax
    jmp _bcc_match
    xret_24:
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
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; ret
    jmp QWORD PTR [r15+240]
_bcc_match:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; stp     x2, x19, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10+8], rax
    ; mov     x0, x19
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r15+0], rax
    ; bl      _zcmp
    lea rax, xret_25
    mov QWORD PTR [r15+240], rax
    jmp _zcmp
    xret_25:
    ; ldp     x2, x19, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+16], rax
    mov QWORD PTR [r15+152], rcx
    add rsp, 10h
    ; cbnz    x0, _bcc_match_no
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _bcc_match_no
    ; str     x20, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
_bcc_match_no:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_zcmp:
    ; ldrb    w2, [x0], #1
    mov r10, QWORD PTR [r15+0]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+16], rax
    mov rax, QWORD PTR [r15+0]
    add rax, 1
    mov QWORD PTR [r15+0], rax
    ; ldrb    w3, [x1], #1
    mov r10, QWORD PTR [r15+8]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+24], rax
    mov rax, QWORD PTR [r15+8]
    add rax, 1
    mov QWORD PTR [r15+8], rax
    ; cmp     w2, w3
    mov eax, DWORD PTR [r15+16]
    mov ecx, DWORD PTR [r15+24]
    cmp eax, ecx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _zcmp_ne
    cmp BYTE PTR [r15+249], 0
    je _zcmp_ne
    ; cbnz    w2, _zcmp
    mov eax, DWORD PTR [r15+16]
    cmp rax, 0
    jne _zcmp
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_zcmp_ne:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_kernel_eval:
kernel_eval:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; sub     sp, sp, #128
    mov rax, rsp
    sub rax, 80h
    mov rsp, rax
    ; lea x16, eval_frame_sp
    lea rax, eval_frame_sp
    mov QWORD PTR [r15+128], rax
    ; mov     x17, sp
    mov rax, rsp
    mov QWORD PTR [r15+136], rax
    ; str     x17, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r15+136]
    mov QWORD PTR [r10], rax
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
    ; stp     x25, x26, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+208]
    mov QWORD PTR [r10+8], rax
    ; stp     x27, x28, [sp, #112]
    lea r10, [rsp]
    add r10, 70h
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+224]
    mov QWORD PTR [r10+8], rax
    ; lea x2, kernel_inited
    lea rax, kernel_inited
    mov QWORD PTR [r15+16], rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cbnz    x2, _eval_go
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0
    jne _eval_go
    ; mov     x0, #2
    mov rax, 2
    mov QWORD PTR [r15+0], rax
    ; neg     x0, x0
    mov rax, QWORD PTR [r15+0]
    neg rax
    mov QWORD PTR [r15+0], rax
    ; b       _embed_ret_x0
    jmp _embed_ret_x0
_eval_go:
    ; stp     x0, x1, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10+8], rax
    ; bl      host_eval_fault_enter
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR [r15+0]
    mov rdx, QWORD PTR [r15+8]
    mov r8, QWORD PTR [r15+16]
    mov r9, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_eval_fault_enter
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; ldp     x0, x1, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+0], rax
    mov QWORD PTR [r15+8], rcx
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
    ; ldr     x2, [x16, #TU_INPUT_PTR]
    mov r10, QWORD PTR [r15+128]
    add r10, 0E8h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; mov     x3, #1023
    mov rax, 3FFh
    mov QWORD PTR [r15+24], rax
    ; cmp     x1, x3
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ls    _eval_len_ok
    cmp BYTE PTR [r15+250], 0
    je _eval_len_ok
    cmp BYTE PTR [r15+249], 0
    jne _eval_len_ok
    ; mov     x1, x3
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r15+8], rax
_eval_len_ok:
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR [r15+24], rax
    ; cbz     x0, _eval_nul
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _eval_nul
_eval_copy:
    ; cmp     x3, x1
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _eval_nul
    cmp BYTE PTR [r15+250], 0
    jne _eval_nul
    ; ldrb    w4, [x0, x3]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+24]
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; strb    w4, [x2, x3]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    add r10, rax
    mov eax, DWORD PTR [r15+32]
    mov BYTE PTR [r10], al
    ; add     x3, x3, #1
    mov rax, QWORD PTR [r15+24]
    add rax, 1
    mov QWORD PTR [r15+24], rax
    ; b       _eval_copy
    jmp _eval_copy
_eval_nul:
    ; strb    wzr, [x2, x3]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    add r10, rax
    mov BYTE PTR [r10], 0
    ; mov     x0, x2
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r15+0], rax
    ; mov     x1, x3
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r15+8], rax
    ; bl      _set_source
    lea rax, xret_26
    mov QWORD PTR [r15+240], rax
    jmp _set_source
    xret_26:
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
    ; str     xzr, [x16, #TU_SRC_ID]
    mov r10, QWORD PTR [r15+128]
    add r10, 80h
    mov QWORD PTR [r10], 0
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
    ; str     xzr, [x16, #TU_SRC_SP]
    mov r10, QWORD PTR [r15+128]
    add r10, 0C0h
    mov QWORD PTR [r10], 0
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
    ; str     xzr, [x16, #TU_EVAL_SP]
    mov r10, QWORD PTR [r15+128]
    add r10, 0D0h
    mov QWORD PTR [r10], 0
    ; lea x2, throw_handler
    lea rax, throw_handler
    mov QWORD PTR [r15+16], rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR [r15+16]
    mov QWORD PTR [r10], 0
    ; lea x2, bye_flag
    lea rax, bye_flag
    mov QWORD PTR [r15+16], rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR [r15+16]
    mov QWORD PTR [r10], 0
    ; lea x2, view_src_id
    lea rax, view_src_id
    mov QWORD PTR [r15+16], rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR [r15+16]
    mov QWORD PTR [r10], 0
    ; lea x2, view_id_sp
    lea rax, view_id_sp
    mov QWORD PTR [r15+16], rax
    ; str     xzr, [x2]
    mov r10, QWORD PTR [r15+16]
    mov QWORD PTR [r10], 0
    ; bl      _vm_load
    lea rax, xret_27
    mov QWORD PTR [r15+240], rax
    jmp _vm_load
    xret_27:
    ; b       _interpret_loop
    jmp _interpret_loop
_interpret_loop:
    ; lea x24, latest_var
    lea rax, latest_var
    mov QWORD PTR [r15+192], rax
    ; bl      _check_stack
    lea rax, xret_28
    mov QWORD PTR [r15+240], rax
    jmp _check_stack
    xret_28:
    ; bl      _file_echo_upto_cursor
    lea rax, xret_29
    mov QWORD PTR [r15+240], rax
    jmp _file_echo_upto_cursor
    xret_29:
    ; bl      _next_word
    lea rax, xret_30
    mov QWORD PTR [r15+240], rax
    jmp _next_word
    xret_30:
    ; cbz     x1, _interpret_empty
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _interpret_empty
    ; mov     x25, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+200], rax
    ; mov     x26, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+208], rax
    ; b       _try_find
    jmp _try_find
_try_find:
    ; lea x2, state_var
    lea rax, state_var
    mov QWORD PTR [r15+16], rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cbz     x2, _try_find_dict
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0
    je _try_find_dict
    ; mov     x0, x25
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r15+0], rax
    ; mov     x1, x26
    mov rax, QWORD PTR [r15+208]
    mov QWORD PTR [r15+8], rax
    ; bl      _local_lookup
    lea rax, xret_31
    mov QWORD PTR [r15+240], rax
    jmp _local_lookup
    xret_31:
    ; cmp     x0, #-1
    mov rax, QWORD PTR [r15+0]
    cmp rax, -1
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _try_find_dict
    cmp BYTE PTR [r15+249], 0
    jne _try_find_dict
    ; mov     x25, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+200], rax
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_32
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_32:
    ; mov     x0, x25
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_33
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_33:
    ; lea x0, cfa_local_at
    lea rax, cfa_local_at
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_34
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_34:
    ; b       _interpret_loop
    jmp _interpret_loop
_try_find_dict:
    ; mov     x0, x25
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r15+0], rax
    ; mov     x1, x26
    mov rax, QWORD PTR [r15+208]
    mov QWORD PTR [r15+8], rax
    ; bl      _find_word
    lea rax, xret_35
    mov QWORD PTR [r15+240], rax
    jmp _find_word
    xret_35:
    ; cbz     x0, _try_number_after_find
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _try_number_after_find
    ; mov     x2, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+16], rax
    ; mov     x3, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+24], rax
    ; tbnz    x3, #63, _exec_found
    mov rax, QWORD PTR [r15+24]
    bt rax, 63
    jc _exec_found
    ; lea x6, state_var
    lea rax, state_var
    mov QWORD PTR [r15+48], rax
    ; ldr     x6, [x6]
    mov r10, QWORD PTR [r15+48]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+48], rax
    ; cbnz    x6, _compile_entry
    mov rax, QWORD PTR [r15+48]
    cmp rax, 0
    jne _compile_entry
_exec_found:
    ; lea x19, restart_cell
    lea rax, restart_cell
    mov QWORD PTR [r15+152], rax
    ; mov     x21, x2
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r15+168], rax
    ; ldr     x5, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; br      x5
    mov rax, QWORD PTR [r15+40]
    jmp rax
_compile_entry:
    ; mov     x0, x2
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_36
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_36:
    ; b       _interpret_loop
    jmp _interpret_loop
_try_number_after_find:
    ; mov     x0, x25
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r15+0], rax
    ; mov     x1, x26
    mov rax, QWORD PTR [r15+208]
    mov QWORD PTR [r15+8], rax
    ; bl      _parse_number
    lea rax, xret_37
    mov QWORD PTR [r15+240], rax
    jmp _parse_number
    xret_37:
    ; cbz     x0, _try_charlit
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _try_charlit
    ; cmp     x0, #2
    mov rax, QWORD PTR [r15+0]
    cmp rax, 2
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _number_double
    cmp BYTE PTR [r15+249], 0
    jne _number_double
    ; lea x2, state_var
    lea rax, state_var
    mov QWORD PTR [r15+16], rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cbnz    x2, _compile_lit
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0
    jne _compile_lit
    ; mov     x0, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+0], rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+160], rax
    ; b       _interpret_loop
    jmp _interpret_loop
_compile_lit:
    ; mov     x25, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+200], rax
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_38
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_38:
    ; mov     x0, x25
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_39
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_39:
    ; b       _interpret_loop
    jmp _interpret_loop
_number_double:
    ; lea x3, state_var
    lea rax, state_var
    mov QWORD PTR [r15+24], rax
    ; ldr     x3, [x3]
    mov r10, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; cbnz    x3, _compile_dlit
    mov rax, QWORD PTR [r15+24]
    cmp rax, 0
    jne _compile_dlit
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; str     x1, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x20, x2
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r15+160], rax
    ; b       _interpret_loop
    jmp _interpret_loop
_compile_dlit:
    ; stp     x1, x2, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r10+8], rax
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_40
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_40:
    ; ldr     x0, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_41
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_41:
    ; lea x0, cfa_lit
    lea rax, cfa_lit
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_42
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_42:
    ; ldr     x0, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_43
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_43:
    ; add     sp, sp, #16
    mov rax, rsp
    add rax, 10h
    mov rsp, rax
    ; b       _interpret_loop
    jmp _interpret_loop
_try_charlit:
    ; cmp     x26, #3
    mov rax, QWORD PTR [r15+208]
    cmp rax, 3
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _try_float
    cmp BYTE PTR [r15+249], 0
    je _try_float
    ; ldrb    w2, [x25]
    mov r10, QWORD PTR [r15+200]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cmp     w2, #39
    mov eax, DWORD PTR [r15+16]
    cmp eax, 27h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _try_float
    cmp BYTE PTR [r15+249], 0
    je _try_float
    ; ldrb    w2, [x25, #2]
    mov r10, QWORD PTR [r15+200]
    add r10, 2
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cmp     w2, #39
    mov eax, DWORD PTR [r15+16]
    cmp eax, 27h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _try_float
    cmp BYTE PTR [r15+249], 0
    je _try_float
    ; ldrb    w1, [x25, #1]
    mov r10, QWORD PTR [r15+200]
    add r10, 1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; lea x2, state_var
    lea rax, state_var
    mov QWORD PTR [r15+16], rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cbnz    x2, _compile_lit
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0
    jne _compile_lit
    ; mov     x0, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+0], rax
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+160], rax
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
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x0, #100
    mov rax, 64h
    mov QWORD PTR [r15+0], rax
    ; mov     x1, #0
    mov rax, 0
    mov QWORD PTR [r15+8], rax
    ; mov     x2, x26
    mov rax, QWORD PTR [r15+208]
    mov QWORD PTR [r15+16], rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR [r15+24], rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR [r15+32], rax
    ; mov     x5, x25
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r15+40], rax
    ; add     x6, sp, #48
    mov rax, rsp
    add rax, 30h
    mov QWORD PTR [r15+48], rax
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
    mov rcx, QWORD PTR [r15+0]
    mov rdx, QWORD PTR [r15+8]
    mov r8, QWORD PTR [r15+16]
    mov r9, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_float_op
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; ldr     x6, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+48], rax
    ; ldr     x7, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+56], rax
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    ; add     sp, sp, #80
    mov rax, rsp
    add rax, 50h
    mov rsp, rax
    ; cbz     x6, _interpret_undef
    mov rax, QWORD PTR [r15+48]
    cmp rax, 0
    je _interpret_undef
    ; mov     x26, x7
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [r15+208], rax
    ; lea x2, state_var
    lea rax, state_var
    mov QWORD PTR [r15+16], rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cbnz    x2, _compile_flit
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0
    jne _compile_flit
    ; mov     x1, x26
    mov rax, QWORD PTR [r15+208]
    mov QWORD PTR [r15+8], rax
    ; mov     x0, #101
    mov rax, 65h
    mov QWORD PTR [r15+0], rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR [r15+16], rax
    ; mov     x3, #0
    mov rax, 0
    mov QWORD PTR [r15+24], rax
    ; mov     x4, #0
    mov rax, 0
    mov QWORD PTR [r15+32], rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR [r15+40], rax
    ; sub     sp, sp, #80
    mov rax, rsp
    sub rax, 50h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; add     x6, sp, #48
    mov rax, rsp
    add rax, 30h
    mov QWORD PTR [r15+48], rax
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
    mov rcx, QWORD PTR [r15+0]
    mov rdx, QWORD PTR [r15+8]
    mov r8, QWORD PTR [r15+16]
    mov r9, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_float_op
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    ; add     sp, sp, #80
    mov rax, rsp
    add rax, 50h
    mov rsp, rax
    ; b       _interpret_loop
    jmp _interpret_loop
_compile_flit:
    ; mov     x25, x26
    mov rax, QWORD PTR [r15+208]
    mov QWORD PTR [r15+200], rax
    ; lea x0, cfa_flit
    lea rax, cfa_flit
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_44
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_44:
    ; mov     x0, x25
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r15+0], rax
    ; bl      _compile_cell
    lea rax, xret_45
    mov QWORD PTR [r15+240], rax
    jmp _compile_cell
    xret_45:
    ; b       _interpret_loop
    jmp _interpret_loop
_interpret_undef:
    ; mov     x0, x25
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r15+0], rax
    ; mov     x1, x26
    mov rax, QWORD PTR [r15+208]
    mov QWORD PTR [r15+8], rax
    ; bl      emit_str
    lea rax, xret_46
    mov QWORD PTR [r15+240], rax
    jmp emit_str
    xret_46:
    ; lea x0, msg_huh
    lea rax, msg_huh
    mov QWORD PTR [r15+0], rax
    ; bl      emit_cstr
    lea rax, xret_47
    mov QWORD PTR [r15+240], rax
    jmp emit_cstr
    xret_47:
    ; lea x7, throw_handler
    lea rax, throw_handler
    mov QWORD PTR [r15+56], rax
    ; ldr     x1, [x7]
    mov r10, QWORD PTR [r15+56]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, _undef_abandon
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _undef_abandon
    ; mov     x20, #-13
    mov rax, -13
    mov QWORD PTR [r15+160], rax
    ; b       XTHROW
    jmp XTHROW
_undef_abandon:
    ; lea x22, data_stack
    lea rax, data_stack
    mov QWORD PTR [r15+176], rax
    ; add     x22, x22, #1, lsl #12
    mov rax, QWORD PTR [r15+176]
    add rax, 1000h
    mov QWORD PTR [r15+176], rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR [r15+160], rax
    ; bl      _local_compile_reset
    lea rax, xret_48
    mov QWORD PTR [r15+240], rax
    jmp _local_compile_reset
    xret_48:
    ; lea x0, noname_xt
    lea rax, noname_xt
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; b       _do_quit
    jmp _do_quit
_interpret_empty:
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
    ; ldr     x0, [x16, #TU_LINE_MODE]
    mov r10, QWORD PTR [r15+128]
    add r10, 90h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbz     x0, _ie_whole
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _ie_whole
    ; bl      _take_line
    lea rax, xret_49
    mov QWORD PTR [r15+240], rax
    jmp _take_line
    xret_49:
    ; cbnz    x0, _interpret_loop
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _interpret_loop
    ; b       _ie_pop
    jmp _ie_pop
_ie_whole:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_15
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_15
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_15:
    ; ldr     x0, [x16, #TU_SRC_SP]
    mov r10, QWORD PTR [r15+128]
    add r10, 0C0h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbz     x0, _embed_finish
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _embed_finish
_ie_pop:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_17
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_17
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_17:
    ; ldr     x25, [x16, #TU_SRC_ID]
    mov r10, QWORD PTR [r15+128]
    add r10, 80h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+200], rax
    ; bl      _pop_source
    lea rax, xret_50
    mov QWORD PTR [r15+240], rax
    jmp _pop_source
    xret_50:
    ; cbz     x0, _embed_finish
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _embed_finish
    ; cmp     x25, #0
    mov rax, QWORD PTR [r15+200]
    cmp rax, 0
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.gt    _ie_view_pop
    cmp BYTE PTR [r15+249], 0
    jne xsk_51
    mov r11b, BYTE PTR [r15+248]
    cmp r11b, BYTE PTR [r15+251]
    je _ie_view_pop
    xsk_51:
    ; cmn     x25, #2
    mov rax, QWORD PTR [r15+200]
    add rax, 2
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setc BYTE PTR [r15+250]
    ; b.ne    _ie_after_view
    cmp BYTE PTR [r15+249], 0
    je _ie_after_view
_ie_view_pop:
    ; bl      _view_pop_src_id
    lea rax, xret_52
    mov QWORD PTR [r15+240], rax
    jmp _view_pop_src_id
    xret_52:
_ie_after_view:
    ; cmn     x25, #1
    mov rax, QWORD PTR [r15+200]
    add rax, 1
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setc BYTE PTR [r15+250]
    ; b.eq    _ie_resume
    cmp BYTE PTR [r15+249], 0
    jne _ie_resume
    ; cmn     x25, #2
    mov rax, QWORD PTR [r15+200]
    add rax, 2
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setc BYTE PTR [r15+250]
    ; b.ne    _interpret_loop
    cmp BYTE PTR [r15+249], 0
    je _interpret_loop
_ie_resume:
    ; bl      _eval_resume_pop
    lea rax, xret_53
    mov QWORD PTR [r15+240], rax
    jmp _eval_resume_pop
    xret_53:
    ; cbz     x0, _interpret_loop
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _interpret_loop
    ; mov     x19, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+152], rax
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
_do_quit:
    ; lea x23, return_stack
    lea rax, return_stack
    mov QWORD PTR [r15+184], rax
    ; add     x23, x23, #1, lsl #12
    mov rax, QWORD PTR [r15+184]
    add rax, 1000h
    mov QWORD PTR [r15+184], rax
    ; lea x0, throw_handler
    lea rax, throw_handler
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_20
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_20
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_20:
    ; str     xzr, [x16, #TU_SRC_SP]
    mov r10, QWORD PTR [r15+128]
    add r10, 0C0h
    mov QWORD PTR [r10], 0
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_22
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_22
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_22:
    ; str     xzr, [x16, #TU_EVAL_SP]
    mov r10, QWORD PTR [r15+128]
    add r10, 0D0h
    mov QWORD PTR [r10], 0
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_24
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_24
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_24:
    ; str     xzr, [x16, #TU_SRC_ID]
    mov r10, QWORD PTR [r15+128]
    add r10, 80h
    mov QWORD PTR [r10], 0
    ; lea x0, view_src_id
    lea rax, view_src_id
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; lea x0, view_id_sp
    lea rax, view_id_sp
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_26
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_26
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_26:
    ; str     xzr, [x16, #TU_LINE_MODE]
    mov r10, QWORD PTR [r15+128]
    add r10, 90h
    mov QWORD PTR [r10], 0
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_28
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_28
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_28:
    ; str     xzr, [x16, #TU_BLK]
    mov r10, QWORD PTR [r15+128]
    add r10, 88h
    mov QWORD PTR [r10], 0
    ; lea x0, local_frame_depth
    lea rax, local_frame_depth
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; bl      _vm_save
    lea rax, xret_54
    mov QWORD PTR [r15+240], rax
    jmp _vm_save
    xret_54:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; b       _embed_ret_x0
    jmp _embed_ret_x0
_embed_finish:
    ; bl      _record_words_user_base_once
    lea rax, xret_55
    mov QWORD PTR [r15+240], rax
    jmp _record_words_user_base_once
    xret_55:
    ; bl      _vm_save
    lea rax, xret_56
    mov QWORD PTR [r15+240], rax
    jmp _vm_save
    xret_56:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; b       _embed_ret_x0
    jmp _embed_ret_x0
_quit_exit:
    ; b       _embed_bye_return
    jmp _embed_bye_return
_embed_bye_return:
    ; bl      _vm_save
    lea rax, xret_57
    mov QWORD PTR [r15+240], rax
    jmp _vm_save
    xret_57:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR [r15+0], rax
    ; b       _embed_ret_x0
    jmp _embed_ret_x0
eval_fault_resume:
    ; lea x16, eval_frame_sp
    lea rax, eval_frame_sp
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
    ; mov     sp, x16
    mov rax, QWORD PTR [r15+128]
    mov rsp, rax
    ; bl      host_eval_fault_leave
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR [r15+0]
    mov rdx, QWORD PTR [r15+8]
    mov r8, QWORD PTR [r15+16]
    mov r9, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_eval_fault_leave
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; bl      _vm_reset_stacks
    lea rax, xret_58
    mov QWORD PTR [r15+240], rax
    jmp _vm_reset_stacks
    xret_58:
    ; mov     x28, #0
    mov rax, 0
    mov QWORD PTR [r15+224], rax
    ; lea x1, debug_armed
    lea rax, debug_armed
    mov QWORD PTR [r15+8], rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; lea x1, debug_busy
    lea rax, debug_busy
    mov QWORD PTR [r15+8], rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; lea x1, debug_bp_go
    lea rax, debug_bp_go
    mov QWORD PTR [r15+8], rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; lea x1, debug_runto_ip
    lea rax, debug_runto_ip
    mov QWORD PTR [r15+8], rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; lea x1, debug_floor
    lea rax, debug_floor
    mov QWORD PTR [r15+8], rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; lea x1, throw_handler
    lea rax, throw_handler
    mov QWORD PTR [r15+8], rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; lea x0, msg_memfault
    lea rax, msg_memfault
    mov QWORD PTR [r15+0], rax
    ; bl      emit_cstr
    lea rax, xret_59
    mov QWORD PTR [r15+240], rax
    jmp emit_cstr
    xret_59:
    ; bl      host_debug_paint
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR [r15+0]
    mov rdx, QWORD PTR [r15+8]
    mov r8, QWORD PTR [r15+16]
    mov r9, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_debug_paint
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; bl      _vm_save
    lea rax, xret_60
    mov QWORD PTR [r15+240], rax
    jmp _vm_save
    xret_60:
    ; mov     x0, #-1
    mov rax, -1
    mov QWORD PTR [r15+0], rax
    ; b       _embed_ret_x0
    jmp _embed_ret_x0
_embed_ret_x0:
    ; str     x0, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; bl      host_eval_fault_leave
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR [r15+0]
    mov rdx, QWORD PTR [r15+8]
    mov r8, QWORD PTR [r15+16]
    mov r9, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    call host_eval_fault_leave
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; ldr     x0, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; ldp     x27, x28, [sp, #112]
    lea r10, [rsp]
    add r10, 70h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+216], rax
    mov QWORD PTR [r15+224], rcx
    ; ldp     x25, x26, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+200], rax
    mov QWORD PTR [r15+208], rcx
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
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
_check_stack:
    ; mov     x0, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+0], rax
    ; cbnz    x0, _cs_have
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _cs_have
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
_cs_have:
    ; cbz     x0, _cs_bss
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _cs_bss
    ; ldr     x1, [x0, #48]
    mov r10, QWORD PTR [r15+0]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; sub     x0, x1, #1, lsl #12
    mov rax, QWORD PTR [r15+8]
    sub rax, 1000h
    mov QWORD PTR [r15+0], rax
    ; cmp     x22, x1
    mov rax, QWORD PTR [r15+176]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _stack_underflow
    cmp BYTE PTR [r15+250], 0
    je xsk_61
    cmp BYTE PTR [r15+249], 0
    je _stack_underflow
    xsk_61:
    ; cmp     x22, x0
    mov rax, QWORD PTR [r15+176]
    mov rcx, QWORD PTR [r15+0]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _stack_overflow
    cmp BYTE PTR [r15+250], 0
    je _stack_overflow
    ; ret
    jmp QWORD PTR [r15+240]
_cs_bss:
    ; lea x0, data_stack
    lea rax, data_stack
    mov QWORD PTR [r15+0], rax
    ; add     x1, x0, #1, lsl #12
    mov rax, QWORD PTR [r15+0]
    add rax, 1000h
    mov QWORD PTR [r15+8], rax
    ; cmp     x22, x1
    mov rax, QWORD PTR [r15+176]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _stack_underflow
    cmp BYTE PTR [r15+250], 0
    je xsk_62
    cmp BYTE PTR [r15+249], 0
    je _stack_underflow
    xsk_62:
    ; cmp     x22, x0
    mov rax, QWORD PTR [r15+176]
    mov rcx, QWORD PTR [r15+0]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _stack_overflow
    cmp BYTE PTR [r15+250], 0
    je _stack_overflow
    ; ret
    jmp QWORD PTR [r15+240]
_stack_underflow:
    ; lea x0, msg_underflow
    lea rax, msg_underflow
    mov QWORD PTR [r15+0], rax
    ; bl      emit_cstr
    lea rax, xret_63
    mov QWORD PTR [r15+240], rax
    jmp emit_cstr
    xret_63:
    ; b       _stack_reset_abandon
    jmp _stack_reset_abandon
_stack_overflow:
    ; lea x0, msg_overflow
    lea rax, msg_overflow
    mov QWORD PTR [r15+0], rax
    ; bl      emit_cstr
    lea rax, xret_64
    mov QWORD PTR [r15+240], rax
    jmp emit_cstr
    xret_64:
_stack_reset_abandon:
    ; b       _undef_abandon
    jmp _undef_abandon
_file_echo_upto_cursor:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; lea x0, file_echo
    lea rax, file_echo
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbz     x0, _fe_done
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _fe_done
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_30
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_30
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_30:
    ; ldr     x0, [x16, #TU_SRC_ID]
    mov r10, QWORD PTR [r15+128]
    add r10, 80h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     x0, #0
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.gt    _fe_on
    cmp BYTE PTR [r15+249], 0
    jne xsk_65
    mov r11b, BYTE PTR [r15+248]
    cmp r11b, BYTE PTR [r15+251]
    je _fe_on
    xsk_65:
    ; cmn     x0, #2
    mov rax, QWORD PTR [r15+0]
    add rax, 2
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setc BYTE PTR [r15+250]
    ; b.ne    _fe_done
    cmp BYTE PTR [r15+249], 0
    je _fe_done
_fe_on:
    ; sub     sp, sp, #48
    mov rax, rsp
    sub rax, 30h
    mov rsp, rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_32
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_32
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_32:
    ; ldr     x0, [x16, #TU_LINE_MODE]
    mov r10, QWORD PTR [r15+128]
    add r10, 90h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbz     x0, _fe_plain
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _fe_plain
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_34
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_34
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_34:
    ; ldr     x1, [x16, #TU_LINE_ORIGIN]
    mov r10, QWORD PTR [r15+128]
    add r10, 98h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_36
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_36
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_36:
    ; ldr     x2, [x16, #TU_LINE_LIMIT]
    mov r10, QWORD PTR [r15+128]
    add r10, 0A0h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; b       _fe_bounds
    jmp _fe_bounds
_fe_plain:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_38
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_38
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_38:
    ; ldr     x1, [x16, #TU_SRC_ADDR]
    mov r10, QWORD PTR [r15+128]
    add r10, 68h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_40
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_40
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_40:
    ; ldr     x2, [x16, #TU_SRC_ADDR]
    mov r10, QWORD PTR [r15+128]
    add r10, 68h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; ldr     x17, [x16, #TU_SRC_LEN]
    mov r10, QWORD PTR [r15+128]
    add r10, 70h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+136], rax
    ; add     x2, x2, x17
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+136]
    add rax, rcx
    mov QWORD PTR [r15+16], rax
_fe_bounds:
    ; stp     x1, x2, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r10+8], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_42
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_42
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_42:
    ; ldr     x0, [x16, #TU_WORD_CURSOR]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B8h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _fe_clamp_hi
    cmp BYTE PTR [r15+250], 0
    jne _fe_clamp_hi
    ; mov     x0, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+0], rax
_fe_clamp_hi:
    ; cmp     x0, x2
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ls    _fe_skip
    cmp BYTE PTR [r15+250], 0
    je _fe_skip
    cmp BYTE PTR [r15+249], 0
    jne _fe_skip
    ; mov     x0, x2
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r15+0], rax
_fe_skip:
    ; cmp     x0, x2
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _fe_eol
    cmp BYTE PTR [r15+250], 0
    jne _fe_eol
    ; ldrb    w3, [x0]
    mov r10, QWORD PTR [r15+0]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; cbz     w3, _fe_eol
    mov eax, DWORD PTR [r15+24]
    cmp rax, 0
    je _fe_eol
    ; cmp     w3, #32
    mov eax, DWORD PTR [r15+24]
    cmp eax, 20h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_skip1
    cmp BYTE PTR [r15+249], 0
    jne _fe_skip1
    ; cmp     w3, #9
    mov eax, DWORD PTR [r15+24]
    cmp eax, 9
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_skip1
    cmp BYTE PTR [r15+249], 0
    jne _fe_skip1
    ; cmp     w3, #10
    mov eax, DWORD PTR [r15+24]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_skip1
    cmp BYTE PTR [r15+249], 0
    jne _fe_skip1
    ; cmp     w3, #13
    mov eax, DWORD PTR [r15+24]
    cmp eax, 0Dh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_skip1
    cmp BYTE PTR [r15+249], 0
    jne _fe_skip1
    ; b       _fe_eol
    jmp _fe_eol
_fe_skip1:
    ; add     x0, x0, #1
    mov rax, QWORD PTR [r15+0]
    add rax, 1
    mov QWORD PTR [r15+0], rax
    ; b       _fe_skip
    jmp _fe_skip
_fe_eol:
    ; mov     x3, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+24], rax
_fe_eol_scan:
    ; cmp     x3, x2
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _fe_eol_ok
    cmp BYTE PTR [r15+250], 0
    jne _fe_eol_ok
    ; ldrb    w4, [x3]
    mov r10, QWORD PTR [r15+24]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; cbz     w4, _fe_eol_ok
    mov eax, DWORD PTR [r15+32]
    cmp rax, 0
    je _fe_eol_ok
    ; cmp     w4, #10
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_eol_ok
    cmp BYTE PTR [r15+249], 0
    jne _fe_eol_ok
    ; cmp     w4, #13
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Dh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_eol_ok
    cmp BYTE PTR [r15+249], 0
    jne _fe_eol_ok
    ; add     x3, x3, #1
    mov rax, QWORD PTR [r15+24]
    add rax, 1
    mov QWORD PTR [r15+24], rax
    ; b       _fe_eol_scan
    jmp _fe_eol_scan
_fe_eol_ok:
    ; str     x3, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_44
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_44
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_44:
    ; ldr     x0, [x16, #TU_ECHO_POS]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B0h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; ldr     x1, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cmp     x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _fe_pos_hi
    cmp BYTE PTR [r15+250], 0
    jne _fe_pos_hi
    ; mov     x0, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+0], rax
_fe_pos_hi:
    ; ldr     x2, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cmp     x0, x2
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ls    _fe_pos_ok
    cmp BYTE PTR [r15+250], 0
    je _fe_pos_ok
    cmp BYTE PTR [r15+249], 0
    jne _fe_pos_ok
    ; mov     x0, x2
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r15+0], rax
_fe_pos_ok:
    ; str     x0, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ldr     x3, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; cmp     x0, x3
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _fe_drop
    cmp BYTE PTR [r15+250], 0
    jne _fe_drop
_fe_line:
    ; ldr     x0, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; ldr     x3, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; cmp     x0, x3
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _fe_drop
    cmp BYTE PTR [r15+250], 0
    jne _fe_drop
    ; ldr     x1, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cmp     x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_num
    cmp BYTE PTR [r15+249], 0
    jne _fe_num
    ; ldrb    w4, [x0, #-1]
    mov r10, QWORD PTR [r15+0]
    add r10, -1
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; cmp     w4, #10
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_num
    cmp BYTE PTR [r15+249], 0
    jne _fe_num
    ; cmp     w4, #13
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Dh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_num
    cmp BYTE PTR [r15+249], 0
    jne _fe_num
    ; b       _fe_text
    jmp _fe_text
_fe_num:
    ; mov     x4, #1
    mov rax, 1
    mov QWORD PTR [r15+32], rax
    ; mov     x3, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+24], rax
_fe_count:
    ; cmp     x3, x0
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+0]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _fe_count_done
    cmp BYTE PTR [r15+250], 0
    jne _fe_count_done
    ; ldrb    w5, [x3]
    mov r10, QWORD PTR [r15+24]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; cmp     w5, #10
    mov eax, DWORD PTR [r15+40]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _fe_count_next
    cmp BYTE PTR [r15+249], 0
    je _fe_count_next
    ; add     x4, x4, #1
    mov rax, QWORD PTR [r15+32]
    add rax, 1
    mov QWORD PTR [r15+32], rax
_fe_count_next:
    ; add     x3, x3, #1
    mov rax, QWORD PTR [r15+24]
    add rax, 1
    mov QWORD PTR [r15+24], rax
    ; b       _fe_count
    jmp _fe_count
_fe_count_done:
    ; mov     x0, x4
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [r15+0], rax
    ; bl      _fe_emit_lineno
    lea rax, xret_66
    mov QWORD PTR [r15+240], rax
    jmp _fe_emit_lineno
    xret_66:
_fe_text:
    ; ldr     x0, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; ldr     x2, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; mov     x3, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+24], rax
_fe_text_scan:
    ; cmp     x3, x2
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _fe_text_write
    cmp BYTE PTR [r15+250], 0
    jne _fe_text_write
    ; ldrb    w4, [x3]
    mov r10, QWORD PTR [r15+24]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; cbz     w4, _fe_text_write
    mov eax, DWORD PTR [r15+32]
    cmp rax, 0
    je _fe_text_write
    ; cmp     w4, #10
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_text_write
    cmp BYTE PTR [r15+249], 0
    jne _fe_text_write
    ; cmp     w4, #13
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Dh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_text_write
    cmp BYTE PTR [r15+249], 0
    jne _fe_text_write
    ; add     x3, x3, #1
    mov rax, QWORD PTR [r15+24]
    add rax, 1
    mov QWORD PTR [r15+24], rax
    ; b       _fe_text_scan
    jmp _fe_text_scan
_fe_text_write:
    ; mov     x1, x3
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r15+8], rax
    ; ldr     x0, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; subs    x1, x1, x0
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+0]
    sub rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    mov QWORD PTR [r15+8], rax
    ; b.eq    _fe_advance
    cmp BYTE PTR [r15+249], 0
    jne _fe_advance
    ; str     x3, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; bl      emit_str
    lea rax, xret_67
    mov QWORD PTR [r15+240], rax
    jmp emit_str
    xret_67:
    ; ldr     x3, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
_fe_advance:
    ; ldr     x2, [sp, #8]
    lea r10, [rsp]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; mov     x1, x3
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r15+8], rax
    ; cmp     x3, x2
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _fe_store
    cmp BYTE PTR [r15+250], 0
    jne _fe_store
    ; ldrb    w0, [x3]
    mov r10, QWORD PTR [r15+24]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     w0, #10
    mov eax, DWORD PTR [r15+0]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _fe_one
    cmp BYTE PTR [r15+249], 0
    jne _fe_one
    ; cmp     w0, #13
    mov eax, DWORD PTR [r15+0]
    cmp eax, 0Dh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _fe_store
    cmp BYTE PTR [r15+249], 0
    je _fe_store
    ; add     x1, x3, #1
    mov rax, QWORD PTR [r15+24]
    add rax, 1
    mov QWORD PTR [r15+8], rax
    ; cmp     x1, x2
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _fe_store
    cmp BYTE PTR [r15+250], 0
    jne _fe_store
    ; ldrb    w0, [x1]
    mov r10, QWORD PTR [r15+8]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     w0, #10
    mov eax, DWORD PTR [r15+0]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _fe_store
    cmp BYTE PTR [r15+249], 0
    je _fe_store
    ; add     x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    add rax, 1
    mov QWORD PTR [r15+8], rax
    ; b       _fe_store
    jmp _fe_store
_fe_one:
    ; add     x1, x3, #1
    mov rax, QWORD PTR [r15+24]
    add rax, 1
    mov QWORD PTR [r15+8], rax
_fe_store:
    ; str     x1, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_46
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_46
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_46:
    ; str     x1, [x16, #TU_ECHO_POS]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B0h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x0, #10
    mov rax, 0Ah
    mov QWORD PTR [r15+0], rax
    ; bl      _putchar
    lea rax, xret_68
    mov QWORD PTR [r15+240], rax
    jmp _putchar
    xret_68:
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
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_fe_emit_lineno:
    ; stp     x29, x30, [sp, #-32]!
    add rsp, -32
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; str     x0, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR [r15+8], rax
    ; mov     x2, #10
    mov rax, 0Ah
    mov QWORD PTR [r15+16], rax
_fe_digits:
    ; cmp     x0, x2
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _fe_pad
    cmp BYTE PTR [r15+250], 0
    je _fe_pad
    ; add     x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    add rax, 1
    mov QWORD PTR [r15+8], rax
    ; mov     x3, #10
    mov rax, 0Ah
    mov QWORD PTR [r15+24], rax
    ; mul     x2, x2, x3
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+24]
    imul rax, rcx
    mov QWORD PTR [r15+16], rax
    ; cmp     x1, #5
    mov rax, QWORD PTR [r15+8]
    cmp rax, 5
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _fe_digits
    cmp BYTE PTR [r15+250], 0
    je _fe_digits
_fe_pad:
    ; mov     x2, #5
    mov rax, 5
    mov QWORD PTR [r15+16], rax
    ; subs    x2, x2, x1
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+8]
    sub rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    mov QWORD PTR [r15+16], rax
    ; b.ls    _fe_print
    cmp BYTE PTR [r15+250], 0
    je _fe_print
    cmp BYTE PTR [r15+249], 0
    jne _fe_print
_fe_spaces:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR [r15+0], rax
    ; str     x2, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r10], rax
    ; bl      _putchar
    lea rax, xret_69
    mov QWORD PTR [r15+240], rax
    jmp _putchar
    xret_69:
    ; ldr     x2, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; subs    x2, x2, #1
    mov rax, QWORD PTR [r15+16]
    sub rax, 1
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    mov QWORD PTR [r15+16], rax
    ; b.ne    _fe_spaces
    cmp BYTE PTR [r15+249], 0
    je _fe_spaces
_fe_print:
    ; ldr     x0, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; bl      _print_unsigned
    lea rax, xret_70
    mov QWORD PTR [r15+240], rax
    jmp _print_unsigned
    xret_70:
    ; mov     x0, #124
    mov rax, 7Ch
    mov QWORD PTR [r15+0], rax
    ; bl      _putchar
    lea rax, xret_71
    mov QWORD PTR [r15+240], rax
    jmp _putchar
    xret_71:
    ; mov     x0, #32
    mov rax, 20h
    mov QWORD PTR [r15+0], rax
    ; bl      _putchar
    lea rax, xret_72
    mov QWORD PTR [r15+240], rax
    jmp _putchar
    xret_72:
    ; ldp     x29, x30, [sp], #32
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 20h
    ; ret
    jmp QWORD PTR [r15+240]
_set_source:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_48
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_48
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_48:
    ; str     x0, [x16, #TU_SRC_ADDR]
    mov r10, QWORD PTR [r15+128]
    add r10, 68h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_50
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_50
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_50:
    ; str     x1, [x16, #TU_SRC_LEN]
    mov r10, QWORD PTR [r15+128]
    add r10, 70h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_52
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_52
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_52:
    ; str     xzr, [x16, #TU_TO_IN]
    mov r10, QWORD PTR [r15+128]
    add r10, 78h
    mov QWORD PTR [r10], 0
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_54
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_54
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_54:
    ; str     x0, [x16, #TU_WORD_CURSOR]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B8h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_56
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_56
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_56:
    ; str     x0, [x16, #TU_ECHO_POS]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B0h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_58
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_58
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_58:
    ; str     xzr, [x16, #TU_LINE_MODE]
    mov r10, QWORD PTR [r15+128]
    add r10, 90h
    mov QWORD PTR [r10], 0
    ; ret
    jmp QWORD PTR [r15+240]
_arm_lines:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_60
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_60
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_60:
    ; str     x0, [x16, #TU_ECHO_POS]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B0h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_62
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_62
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_62:
    ; str     x0, [x16, #TU_LINE_ORIGIN]
    mov r10, QWORD PTR [r15+128]
    add r10, 98h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; add     x3, x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    add rax, rcx
    mov QWORD PTR [r15+24], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_64
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_64
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_64:
    ; str     x3, [x16, #TU_LINE_LIMIT]
    mov r10, QWORD PTR [r15+128]
    add r10, 0A0h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_66
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_66
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_66:
    ; str     x0, [x16, #TU_LINE_NEXT]
    mov r10, QWORD PTR [r15+128]
    add r10, 0A8h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x3, #1
    mov rax, 1
    mov QWORD PTR [r15+24], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_68
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_68
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_68:
    ; str     x3, [x16, #TU_LINE_MODE]
    mov r10, QWORD PTR [r15+128]
    add r10, 90h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; ret
    jmp QWORD PTR [r15+240]
_take_line:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_70
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_70
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_70:
    ; ldr     x0, [x16, #TU_LINE_NEXT]
    mov r10, QWORD PTR [r15+128]
    add r10, 0A8h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_72
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_72
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_72:
    ; ldr     x3, [x16, #TU_LINE_LIMIT]
    mov r10, QWORD PTR [r15+128]
    add r10, 0A0h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; cmp     x0, x3
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _tl_eof
    cmp BYTE PTR [r15+250], 0
    jne _tl_eof
    ; mov     x1, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+8], rax
_tl_scan:
    ; cmp     x1, x3
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _tl_eos
    cmp BYTE PTR [r15+250], 0
    jne _tl_eos
    ; ldrb    w4, [x1]
    mov r10, QWORD PTR [r15+8]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; cmp     w4, #10
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _tl_lf
    cmp BYTE PTR [r15+249], 0
    jne _tl_lf
    ; cmp     w4, #13
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Dh
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _tl_cr
    cmp BYTE PTR [r15+249], 0
    jne _tl_cr
    ; add     x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    add rax, 1
    mov QWORD PTR [r15+8], rax
    ; b       _tl_scan
    jmp _tl_scan
_tl_lf:
    ; mov     x5, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+40], rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    add rax, 1
    mov QWORD PTR [r15+8], rax
    ; b       _tl_set
    jmp _tl_set
_tl_cr:
    ; mov     x5, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+40], rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    add rax, 1
    mov QWORD PTR [r15+8], rax
    ; cmp     x1, x3
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _tl_set
    cmp BYTE PTR [r15+250], 0
    jne _tl_set
    ; ldrb    w4, [x1]
    mov r10, QWORD PTR [r15+8]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; cmp     w4, #10
    mov eax, DWORD PTR [r15+32]
    cmp eax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _tl_set
    cmp BYTE PTR [r15+249], 0
    je _tl_set
    ; add     x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    add rax, 1
    mov QWORD PTR [r15+8], rax
    ; b       _tl_set
    jmp _tl_set
_tl_eos:
    ; mov     x5, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+40], rax
_tl_set:
    ; sub     x6, x5, x0
    mov rax, QWORD PTR [r15+40]
    mov rcx, QWORD PTR [r15+0]
    sub rax, rcx
    mov QWORD PTR [r15+48], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_74
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_74
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_74:
    ; str     x1, [x16, #TU_LINE_NEXT]
    mov r10, QWORD PTR [r15+128]
    add r10, 0A8h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_76
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_76
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_76:
    ; str     x0, [x16, #TU_SRC_ADDR]
    mov r10, QWORD PTR [r15+128]
    add r10, 68h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_78
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_78
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_78:
    ; str     x6, [x16, #TU_SRC_LEN]
    mov r10, QWORD PTR [r15+128]
    add r10, 70h
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_80
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_80
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_80:
    ; str     xzr, [x16, #TU_TO_IN]
    mov r10, QWORD PTR [r15+128]
    add r10, 78h
    mov QWORD PTR [r10], 0
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_82
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_82
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_82:
    ; str     x0, [x16, #TU_WORD_CURSOR]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B8h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_tl_eof:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_push_source:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_84
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_84
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_84:
    ; add     x0, x16, #TU_SRC_SP
    mov rax, QWORD PTR [r15+128]
    add rax, 0C0h
    mov QWORD PTR [r15+0], rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cmp     x1, #8
    mov rax, QWORD PTR [r15+8]
    cmp rax, 8
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _ps_full
    cmp BYTE PTR [r15+250], 0
    jne _ps_full
    ; mov     x2, #80
    mov rax, 50h
    mov QWORD PTR [r15+16], rax
    ; mul     x3, x1, x2
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+16]
    imul rax, rcx
    mov QWORD PTR [r15+24], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_86
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_86
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_86:
    ; ldr     x2, [x16, #TU_SSTK_PTR]
    mov r10, QWORD PTR [r15+128]
    add r10, 0F0h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; add     x2, x2, x3
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+24]
    add rax, rcx
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_88
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_88
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_88:
    ; ldr     x3, [x16, #TU_SRC_ADDR]
    mov r10, QWORD PTR [r15+128]
    add r10, 68h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_90
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_90
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_90:
    ; ldr     x3, [x16, #TU_SRC_LEN]
    mov r10, QWORD PTR [r15+128]
    add r10, 70h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_92
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_92
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_92:
    ; ldr     x3, [x16, #TU_TO_IN]
    mov r10, QWORD PTR [r15+128]
    add r10, 78h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_94
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_94
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_94:
    ; ldr     x3, [x16, #TU_SRC_ID]
    mov r10, QWORD PTR [r15+128]
    add r10, 80h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_96
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_96
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_96:
    ; ldr     x3, [x16, #TU_ECHO_POS]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B0h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_98
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_98
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_98:
    ; ldr     x3, [x16, #TU_BLK]
    mov r10, QWORD PTR [r15+128]
    add r10, 88h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_100
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_100
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_100:
    ; ldr     x3, [x16, #TU_LINE_MODE]
    mov r10, QWORD PTR [r15+128]
    add r10, 90h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_102
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_102
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_102:
    ; ldr     x3, [x16, #TU_LINE_ORIGIN]
    mov r10, QWORD PTR [r15+128]
    add r10, 98h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_104
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_104
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_104:
    ; ldr     x3, [x16, #TU_LINE_LIMIT]
    mov r10, QWORD PTR [r15+128]
    add r10, 0A0h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_106
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_106
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_106:
    ; ldr     x3, [x16, #TU_LINE_NEXT]
    mov r10, QWORD PTR [r15+128]
    add r10, 0A8h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    add rax, 1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_ps_full:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_pop_source:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_108
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_108
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_108:
    ; add     x0, x16, #TU_SRC_SP
    mov rax, QWORD PTR [r15+128]
    add rax, 0C0h
    mov QWORD PTR [r15+0], rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, _pop_empty
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _pop_empty
    ; sub     x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    sub rax, 1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x2, #80
    mov rax, 50h
    mov QWORD PTR [r15+16], rax
    ; mul     x3, x1, x2
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+16]
    imul rax, rcx
    mov QWORD PTR [r15+24], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_110
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_110
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_110:
    ; ldr     x2, [x16, #TU_SSTK_PTR]
    mov r10, QWORD PTR [r15+128]
    add r10, 0F0h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; add     x2, x2, x3
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+24]
    add rax, rcx
    mov QWORD PTR [r15+16], rax
    ; ldr     x4, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+32], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_112
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_112
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_112:
    ; str     x4, [x16, #TU_SRC_ADDR]
    mov r10, QWORD PTR [r15+128]
    add r10, 68h
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_114
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_114
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_114:
    ; str     x3, [x16, #TU_SRC_LEN]
    mov r10, QWORD PTR [r15+128]
    add r10, 70h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_116
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_116
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_116:
    ; str     x3, [x16, #TU_TO_IN]
    mov r10, QWORD PTR [r15+128]
    add r10, 78h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; add     x4, x4, x3
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+24]
    add rax, rcx
    mov QWORD PTR [r15+32], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_118
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_118
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_118:
    ; str     x4, [x16, #TU_WORD_CURSOR]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B8h
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_120
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_120
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_120:
    ; str     x3, [x16, #TU_SRC_ID]
    mov r10, QWORD PTR [r15+128]
    add r10, 80h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_122
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_122
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_122:
    ; str     x3, [x16, #TU_ECHO_POS]
    mov r10, QWORD PTR [r15+128]
    add r10, 0B0h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_124
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_124
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_124:
    ; str     x3, [x16, #TU_BLK]
    mov r10, QWORD PTR [r15+128]
    add r10, 88h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_126
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_126
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_126:
    ; str     x3, [x16, #TU_LINE_MODE]
    mov r10, QWORD PTR [r15+128]
    add r10, 90h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_128
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_128
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_128:
    ; str     x3, [x16, #TU_LINE_ORIGIN]
    mov r10, QWORD PTR [r15+128]
    add r10, 98h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2], #8
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    mov rax, QWORD PTR [r15+16]
    add rax, 8
    mov QWORD PTR [r15+16], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_130
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_130
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_130:
    ; str     x3, [x16, #TU_LINE_LIMIT]
    mov r10, QWORD PTR [r15+128]
    add r10, 0A0h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_132
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_132
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_132:
    ; str     x3, [x16, #TU_LINE_NEXT]
    mov r10, QWORD PTR [r15+128]
    add r10, 0A8h
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_pop_empty:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_eval_resume_push:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_134
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_134
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_134:
    ; add     x0, x16, #TU_EVAL_SP
    mov rax, QWORD PTR [r15+128]
    add rax, 0D0h
    mov QWORD PTR [r15+0], rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cmp     x1, #8
    mov rax, QWORD PTR [r15+8]
    cmp rax, 8
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _erp_full
    cmp BYTE PTR [r15+250], 0
    jne _erp_full
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_136
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_136
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_136:
    ; ldr     x2, [x16, #TU_EVALSTK_PTR]
    mov r10, QWORD PTR [r15+128]
    add r10, 0F8h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; lsl     x3, x1, #3
    mov rax, QWORD PTR [r15+8]
    shl rax, 3
    mov QWORD PTR [r15+24], rax
    ; str     x19, [x2, x3]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    add r10, rax
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10], rax
    ; add     x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    add rax, 1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
_erp_full:
    ; ret
    jmp QWORD PTR [r15+240]
_eval_resume_pop:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_138
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_138
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_138:
    ; add     x0, x16, #TU_EVAL_SP
    mov rax, QWORD PTR [r15+128]
    add rax, 0D0h
    mov QWORD PTR [r15+0], rax
    ; ldr     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, _erpop_empty
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _erpop_empty
    ; sub     x1, x1, #1
    mov rax, QWORD PTR [r15+8]
    sub rax, 1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_140
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_140
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_140:
    ; ldr     x2, [x16, #TU_EVALSTK_PTR]
    mov r10, QWORD PTR [r15+128]
    add r10, 0F8h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; lsl     x3, x1, #3
    mov rax, QWORD PTR [r15+8]
    shl rax, 3
    mov QWORD PTR [r15+24], rax
    ; ldr     x0, [x2, x3]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_erpop_empty:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_throw_unwind_to_sp:
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
    ; str     x0, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
_tu_loop:
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_142
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_142
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_142:
    ; ldr     x1, [x16, #TU_SRC_SP]
    mov r10, QWORD PTR [r15+128]
    add r10, 0C0h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; ldr     x2, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cmp     x1, x2
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ls    _tu_done
    cmp BYTE PTR [r15+250], 0
    je _tu_done
    cmp BYTE PTR [r15+249], 0
    jne _tu_done
    ; mov     x16, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+128], rax
    ; cbnz    x16, L91_144
    mov rax, QWORD PTR [r15+128]
    cmp rax, 0
    jne L91_144
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
L91_144:
    ; ldr     x0, [x16, #TU_SRC_ID]
    mov r10, QWORD PTR [r15+128]
    add r10, 80h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; str     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; bl      _pop_source
    lea rax, xret_73
    mov QWORD PTR [r15+240], rax
    jmp _pop_source
    xret_73:
    ; cbz     x0, _tu_done
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _tu_done
    ; ldr     x0, [sp, #56]
    lea r10, [rsp]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     x0, #0
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.gt    _tu_view
    cmp BYTE PTR [r15+249], 0
    jne xsk_74
    mov r11b, BYTE PTR [r15+248]
    cmp r11b, BYTE PTR [r15+251]
    je _tu_view
    xsk_74:
    ; cmn     x0, #2
    mov rax, QWORD PTR [r15+0]
    add rax, 2
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setc BYTE PTR [r15+250]
    ; b.ne    _tu_loop
    cmp BYTE PTR [r15+249], 0
    je _tu_loop
_tu_view:
    ; bl      _view_pop_src_id
    lea rax, xret_75
    mov QWORD PTR [r15+240], rax
    jmp _view_pop_src_id
    xret_75:
    ; b       _tu_loop
    jmp _tu_loop
_tu_done:
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
    ; ret
    jmp QWORD PTR [r15+240]
_vm_save:
    ; lea x0, vm_tos
    lea rax, vm_tos
    mov QWORD PTR [r15+0], rax
    ; str     x20, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; lea x0, vm_dsp
    lea rax, vm_dsp
    mov QWORD PTR [r15+0], rax
    ; str     x22, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+176]
    mov QWORD PTR [r10], rax
    ; lea x0, vm_rsp
    lea rax, vm_rsp
    mov QWORD PTR [r15+0], rax
    ; str     x23, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+184]
    mov QWORD PTR [r10], rax
    ; ret
    jmp QWORD PTR [r15+240]
_vm_load:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x27, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+216], rax
    ; lea x24, latest_var
    lea rax, latest_var
    mov QWORD PTR [r15+192], rax
    ; lea x0, vm_tos
    lea rax, vm_tos
    mov QWORD PTR [r15+0], rax
    ; ldr     x20, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    ; lea x0, vm_dsp
    lea rax, vm_dsp
    mov QWORD PTR [r15+0], rax
    ; ldr     x22, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+176], rax
    ; lea x0, vm_rsp
    lea rax, vm_rsp
    mov QWORD PTR [r15+0], rax
    ; ldr     x23, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+184], rax
    ; lea x0, debug_armed
    lea rax, debug_armed
    mov QWORD PTR [r15+0], rax
    ; ldr     x28, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+224], rax
    ; cbnz    x22, _vm_load_ok
    mov rax, QWORD PTR [r15+176]
    cmp rax, 0
    jne _vm_load_ok
    ; b       _vm_reset_stacks
    jmp _vm_reset_stacks
_vm_load_ok:
    ; ret
    jmp QWORD PTR [r15+240]
_vm_reset_stacks:
    ; lea x22, data_stack
    lea rax, data_stack
    mov QWORD PTR [r15+176], rax
    ; add     x22, x22, #1, lsl #12
    mov rax, QWORD PTR [r15+176]
    add rax, 1000h
    mov QWORD PTR [r15+176], rax
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR [r15+160], rax
    ; lea x23, return_stack
    lea rax, return_stack
    mov QWORD PTR [r15+184], rax
    ; add     x23, x23, #1, lsl #12
    mov rax, QWORD PTR [r15+184]
    add rax, 1000h
    mov QWORD PTR [r15+184], rax
    ; lea x24, latest_var
    lea rax, latest_var
    mov QWORD PTR [r15+192], rax
    ; lea x0, state_var
    lea rax, state_var
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbz     x0, _vm_reset_done
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _vm_reset_done
    ; str     xzr, [x0, #TU_SRC_SP]
    mov r10, QWORD PTR [r15+0]
    add r10, 0C0h
    mov QWORD PTR [r10], 0
_vm_reset_done:
    ; ret
    jmp QWORD PTR [r15+240]
next_debug_gate:
    ; lea x16, next_debug
    lea rax, next_debug
    mov QWORD PTR [r15+128], rax
    ; br      x16
    mov rax, QWORD PTR [r15+128]
    jmp rax
.CONST
msg_huh:
    ; DCB     " ?", 10, 0
    DB " ?", 0Ah, 0
msg_memfault:
    ; DCB     "memory access error", 10, 0
    DB "memory access error", 0Ah, 0
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
