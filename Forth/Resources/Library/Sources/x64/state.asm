; Generated from Forth/kernel/arm64/state.asm. Do not edit.
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
EXTRN XCATCH_OK:PROC
EXTRN XRESTART:PROC
EXTRN XTW_CONTINUE:PROC
EXTRN host_float_op:PROC
.DATA
PUBLIC latest_var
PUBLIC last_cfa
PUBLIC noname_xt
PUBLIC here_ptr
PUBLIC state_var
PUBLIC bye_flag
PUBLIC inited
PUBLIC emit_fn
PUBLIC file_op_hook
PUBLIC float_op_hook
PUBLIC key_fn
PUBLIC facility_op_hook
PUBLIC vm_tos
PUBLIC vm_dsp
PUBLIC vm_rsp
PUBLIC source_cur
PUBLIC source_end
PUBLIC source_base
PUBLIC to_in
PUBLIC throw_handler
PUBLIC pad_buffer
PUBLIC redef_warn
PUBLIC block_file
PUBLIC block_upd
PUBLIC block_nr
PUBLIC block_buf
PUBLIC scr_var
PUBLIC blk_var
PUBLIC blk_stack
PUBLIC forget_cut
PUBLIC native_dsp_end
PUBLIC jit_exec_mode
PUBLIC cfa_flit
PUBLIC cfa_local_init
PUBLIC cfa_local_at
PUBLIC cfa_local_store
PUBLIC cfa_loop
PUBLIC cfa_plusloop
PUBLIC local_name_count
PUBLIC local_init_count
PUBLIC local_init_reverse
PUBLIC local_declaring
PUBLIC local_brace_phase
PUBLIC local_names
PUBLIC local_frame_depth
PUBLIC local_frames
PUBLIC local_frame_rsp
PUBLIC local_frame_n
PUBLIC slit_esc_buf
PUBLIC slit_esc_buf2
PUBLIC slit_esc_which
PUBLIC line_mode
PUBLIC line_origin
PUBLIC line_limit
PUBLIC line_next
PUBLIC source_id
PUBLIC file_echo
PUBLIC file_echo_pos
PUBLIC file_echo_stack
PUBLIC source_sp
PUBLIC source_stack
PUBLIC eval_resume_sp
PUBLIC eval_resume_stack
PUBLIC resolve_buf
PUBLIC catch_ok_cell
PUBLIC tw_continue_cell
PUBLIC dict_end
PUBLIC base_var
PUBLIC current_var
PUBLIC search_order
PUBLIC search_order_n
PUBLIC pending_help_addr
PUBLIC pending_help_len
PUBLIC word_scratch
PUBLIC wordlist_reg
PUBLIC wordlist_reg_n
PUBLIC words_user_base
PUBLIC words_filter
PUBLIC words_filter_len
PUBLIC words_nk_tmp
PUBLIC words_cfa
PUBLIC cfa_branch
PUBLIC cfa_0branch
PUBLIC cfa_does
PUBLIC cfa_slit
PUBLIC cfa_cstr
PUBLIC cfa_execute
PUBLIC cfa_comma
PUBLIC library_path_buf
PUBLIC exit_cfa
PUBLIC cfa_exit
PUBLIC lit_cfa
PUBLIC cfa_lit
PUBLIC restart_cell
PUBLIC restart_cfa
PUBLIC kernel_inited
PUBLIC emit_hook
PUBLIC key_hook
PUBLIC data_stack
PUBLIC return_stack
PUBLIC user_dict_area
PUBLIC user_dict_size_cell
PUBLIC grow_memory_used
PUBLIC xchar_emit_buf
PUBLIC numbuf
PUBLIC dstack
PUBLIC rstack
PUBLIC dictmem
latest_var:
    ; SPACE   128
    DB 128 DUP(0)
last_cfa:
    ; DCQ     0
    DQ 0
noname_xt:
    ; DCQ     0
    DQ 0
here_ptr:
    ; DCQ     0
    DQ 0
state_var:
    ; DCQ     0
    DQ 0
base_var:
    ; DCQ     10
    DQ 0Ah
current_var:
    ; DCQ     latest_var
    DQ OFFSET latest_var
search_order:
    ; DCQ    latest_var
    DQ OFFSET latest_var
    ; DCQ     0, 0, 0, 0, 0, 0, 0
    DQ 0, 0, 0, 0, 0, 0, 0
search_order_n:
    ; DCQ  1
    DQ 1
pending_help_addr:
    ; DCQ 0
    DQ 0
pending_help_len:
    ; DCQ 0
    DQ 0
wordlist_reg_n:
    ; DCQ  0
    DQ 0
bye_flag:
    ; DCQ     0
    DQ 0
kernel_inited:
inited:
    ; DCQ     0
    DQ 0
emit_hook:
emit_fn:
    ; DCQ     0
    DQ 0
file_op_hook:
    ; DCQ    0
    DQ 0
float_op_hook:
    ; DCQ   host_float_op
    DQ OFFSET host_float_op
key_hook:
key_fn:
    ; DCQ     0
    DQ 0
facility_op_hook:
    ; DCQ 0
    DQ 0
vm_tos:
    ; DCQ     0
    DQ 0
vm_dsp:
    ; DCQ     0
    DQ 0
vm_rsp:
    ; DCQ     0
    DQ 0
source_base:
    ; DCQ     0
    DQ 0
source_cur:
    ; DCQ     0
    DQ 0
source_end:
    ; DCQ     0
    DQ 0
to_in:
    ; DCQ     0
    DQ 0
throw_handler:
    ; DCQ   0
    DQ 0
cfa_flit:
    ; DCQ     0
    DQ 0
cfa_local_init:
    ; DCQ  0
    DQ 0
cfa_local_at:
    ; DCQ    0
    DQ 0
cfa_local_store:
    ; DCQ 0
    DQ 0
cfa_loop:
    ; DCQ     0
    DQ 0
cfa_plusloop:
    ; DCQ    0
    DQ 0
local_name_count:
    ; DCQ 0
    DQ 0
local_init_count:
    ; DCQ 0
    DQ 0
local_init_reverse:
    ; DCQ 0
    DQ 0
local_declaring:
    ; DCQ 0
    DQ 0
local_brace_phase:
    ; DCQ 0
    DQ 0
local_frame_depth:
    ; DCQ 0
    DQ 0
local_names:
    ; SPACE   1024
    DB 1024 DUP(0)
local_frames:
    ; SPACE  4096
    DB 4096 DUP(0)
local_frame_rsp:
    ; SPACE 128
    DB 128 DUP(0)
local_frame_n:
    ; SPACE 128
    DB 128 DUP(0)
slit_esc_buf:
    ; SPACE  256
    DB 256 DUP(0)
slit_esc_buf2:
    ; SPACE 256
    DB 256 DUP(0)
slit_esc_which:
    ; DCQ  0
    DQ 0
line_mode:
    ; DCQ     0
    DQ 0
line_origin:
    ; DCQ     0
    DQ 0
line_limit:
    ; DCQ     0
    DQ 0
line_next:
    ; DCQ     0
    DQ 0
source_id:
    ; DCQ     0
    DQ 0
file_echo:
    ; DCQ     0
    DQ 0
file_echo_pos:
    ; DCQ   0
    DQ 0
file_echo_stack:
    ; SPACE 64
    DB 64 DUP(0)
source_sp:
    ; DCQ     0
    DQ 0
eval_resume_sp:
    ; DCQ  0
    DQ 0
source_stack:
    ; SPACE  512
    DB 512 DUP(0)
eval_resume_stack:
    ; SPACE 64
    DB 64 DUP(0)
resolve_buf:
    ; SPACE   256
    DB 256 DUP(0)
pad_buffer:
    ; SPACE   1024
    DB 1024 DUP(0)
library_path_buf:
    ; SPACE 1024
    DB 1024 DUP(0)
redef_warn:
    ; DCQ     0
    DQ 0
block_file:
    ; DCQ     0
    DQ 0
block_upd:
    ; DCQ     0
    DQ 0
block_nr:
    ; DCQ     -1
    DQ -1
scr_var:
    ; DCQ     0
    DQ 0
blk_var:
    ; DCQ     0
    DQ 0
blk_stack:
    ; SPACE   64
    DB 64 DUP(0)
forget_cut:
    ; DCQ     0
    DQ 0
jit_exec_mode:
    ; DCQ   0
    DQ 0
native_dsp_mem:
    ; SPACE 8192
    DB 8192 DUP(0)
native_dsp_end:
block_buf:
    ; SPACE   1024
    DB 1024 DUP(0)
catch_ok_cell:
    ; DCQ   catch_ok_cfa
    DQ OFFSET catch_ok_cfa
tw_continue_cell:
    ; DCQ tw_continue_cfa
    DQ OFFSET tw_continue_cfa
cfa_exit:
exit_cfa:
    ; DCQ     0
    DQ 0
cfa_lit:
lit_cfa:
    ; DCQ     0
    DQ 0
cfa_branch:
    ; DCQ     0
    DQ 0
cfa_0branch:
    ; DCQ     0
    DQ 0
cfa_does:
    ; DCQ     0
    DQ 0
cfa_slit:
    ; DCQ     0
    DQ 0
cfa_cstr:
    ; DCQ     0
    DQ 0
cfa_execute:
    ; DCQ     0
    DQ 0
cfa_comma:
    ; DCQ     0
    DQ 0
restart_cell:
    ; DCQ    restart_cfa
    DQ OFFSET restart_cfa
numbuf:
    ; SPACE   32
    DB 32 DUP(0)
word_scratch:
    ; SPACE  80
    DB 80 DUP(0)
wordlist_reg:
    ; SPACE  256
    DB 256 DUP(0)
words_user_base:
    ; DCQ 0
    DQ 0
words_filter_len:
    ; DCQ 0
    DQ 0
words_nk_tmp:
    ; DCQ    0
    DQ 0
words_filter:
    ; SPACE  64
    DB 64 DUP(0)
words_cfa:
    ; SPACE   8192
    DB 8192 DUP(0)
data_stack:
dstack:
    ; SPACE   4096
    DB 4096 DUP(0)
return_stack:
rstack:
    ; SPACE   4096
    DB 4096 DUP(0)
user_dict_size_cell:
    ; DCQ 8388608
    DQ 800000h
grow_memory_used:
    ; DCQ 0
    DQ 0
xchar_emit_buf:
    ; SPACE 8
    DB 8 DUP(0)
.DATA?
user_dict_area:
dictmem:
    ; SPACE   268435456
    DB 268435456 DUP(?)
dict_end:
.DATA
restart_cfa:
    ; DCQ     XRESTART
    DQ OFFSET XRESTART
catch_ok_cfa:
    ; DCQ    XCATCH_OK
    DQ OFFSET XCATCH_OK
PUBLIC tw_continue_cfa
tw_continue_cfa:
    ; DCQ XTW_CONTINUE
    DQ OFFSET XTW_CONTINUE
END
