; VM memory. Stacks grow down from the high end. TOS starts at 0.

        AREA |.data|, DATA, READWRITE, ALIGN=8

        EXPORT latest_var
        EXPORT last_cfa
        EXPORT noname_xt
        EXPORT here_ptr
        EXPORT state_var
        EXPORT bye_flag
        EXPORT inited
        EXPORT emit_fn
        EXPORT file_op_hook
        EXPORT float_op_hook
        EXTERN host_float_op
        EXPORT key_fn
        EXPORT facility_op_hook
        EXPORT vm_tos
        EXPORT vm_dsp
        EXPORT vm_rsp
        EXPORT source_cur
        EXPORT source_end
        EXPORT source_base
        EXPORT to_in
        EXPORT throw_handler
        EXPORT pad_buffer
        EXPORT redef_warn
        EXPORT block_file
        EXPORT block_upd
        EXPORT block_nr
        EXPORT block_buf
        EXPORT scr_var
        EXPORT blk_var
        EXPORT blk_stack
        EXPORT forget_cut
        EXPORT native_dsp_end
        EXPORT jit_exec_mode
        EXPORT cfa_flit
        EXPORT cfa_local_init
        EXPORT cfa_local_at
        EXPORT cfa_local_store
        EXPORT cfa_loop
        EXPORT cfa_plusloop
        EXPORT local_name_count
        EXPORT local_init_count
        EXPORT local_init_reverse
        EXPORT local_declaring
        EXPORT local_brace_phase
        EXPORT local_names
        EXPORT local_frame_depth
        EXPORT local_frames
        EXPORT local_frame_rsp
        EXPORT local_frame_n
        EXPORT slit_esc_buf
        EXPORT slit_esc_buf2
        EXPORT slit_esc_which
        EXPORT line_mode
        EXPORT line_origin
        EXPORT line_limit
        EXPORT line_next
        EXPORT source_id
        EXPORT file_echo
        EXPORT file_echo_pos
        EXPORT file_echo_stack
        EXPORT source_sp
        EXPORT source_stack
        EXPORT eval_resume_sp
        EXPORT eval_resume_stack
        EXPORT resolve_buf
        EXPORT catch_ok_cell
        EXPORT tw_continue_cell
        EXPORT dict_end
        EXPORT base_var
        EXPORT current_var
        EXPORT search_order
        EXPORT search_order_n
        EXPORT pending_help_addr
        EXPORT pending_help_len
        EXPORT word_scratch
        EXPORT wordlist_reg
        EXPORT wordlist_reg_n
        EXPORT words_user_base
        EXPORT words_filter
        EXPORT words_filter_len
        EXPORT words_nk_tmp
        EXPORT words_cfa
        EXPORT cfa_branch
        EXPORT cfa_0branch
        EXPORT cfa_does
        EXPORT cfa_slit
        EXPORT cfa_cstr
        EXPORT cfa_execute
        EXPORT cfa_comma
        EXPORT library_path_buf
        EXPORT exit_cfa
        EXPORT cfa_exit
        EXPORT lit_cfa
        EXPORT cfa_lit
        EXPORT restart_cell
        EXPORT restart_cfa
        EXPORT kernel_inited
        EXPORT emit_hook
        EXPORT key_hook
        EXPORT data_stack
        EXPORT return_stack
        EXPORT user_dict_area
        EXPORT user_dict_size_cell
        EXPORT grow_memory_used
        EXPORT xchar_emit_buf
        EXPORT numbuf
        EXPORT dstack
        EXPORT rstack
        EXPORT dictmem

latest_var  SPACE   128
last_cfa    DCQ     0
noname_xt   DCQ     0
here_ptr    DCQ     0
state_var   DCQ     0
base_var    DCQ     10
current_var DCQ     latest_var
search_order DCQ    latest_var
            DCQ     0, 0, 0, 0, 0, 0, 0
search_order_n DCQ  1
pending_help_addr DCQ 0
pending_help_len DCQ 0
wordlist_reg_n DCQ  0
bye_flag    DCQ     0
kernel_inited
inited      DCQ     0
emit_hook
emit_fn     DCQ     0
file_op_hook DCQ    0
float_op_hook DCQ   host_float_op
key_hook
key_fn      DCQ     0
facility_op_hook DCQ 0
vm_tos      DCQ     0
vm_dsp      DCQ     0
vm_rsp      DCQ     0
source_base DCQ     0
source_cur  DCQ     0
source_end  DCQ     0
to_in       DCQ     0
throw_handler DCQ   0
cfa_flit    DCQ     0
cfa_local_init DCQ  0
cfa_local_at DCQ    0
cfa_local_store DCQ 0
cfa_loop    DCQ     0
cfa_plusloop DCQ    0
local_name_count DCQ 0
local_init_count DCQ 0
local_init_reverse DCQ 0
local_declaring DCQ 0
local_brace_phase DCQ 0
local_frame_depth DCQ 0
local_names SPACE   1024
local_frames SPACE  4096
local_frame_rsp SPACE 128
local_frame_n SPACE 128
slit_esc_buf SPACE  256
slit_esc_buf2 SPACE 256
slit_esc_which DCQ  0
line_mode   DCQ     0
line_origin DCQ     0
line_limit  DCQ     0
line_next   DCQ     0
source_id   DCQ     0
file_echo   DCQ     0
file_echo_pos DCQ   0
file_echo_stack SPACE 64
source_sp   DCQ     0
eval_resume_sp DCQ  0
source_stack SPACE  512
eval_resume_stack SPACE 64
resolve_buf SPACE   256
pad_buffer  SPACE   1024
library_path_buf SPACE 1024
redef_warn  DCQ     0
block_file  DCQ     0
block_upd   DCQ     0
block_nr    DCQ     -1
scr_var     DCQ     0
blk_var     DCQ     0
blk_stack   SPACE   64
forget_cut  DCQ     0
jit_exec_mode DCQ   0
native_dsp_mem SPACE 8192
native_dsp_end
block_buf   SPACE   1024
catch_ok_cell DCQ   catch_ok_cfa
tw_continue_cell DCQ tw_continue_cfa
cfa_exit
exit_cfa    DCQ     0
cfa_lit
lit_cfa     DCQ     0
cfa_branch  DCQ     0
cfa_0branch DCQ     0
cfa_does    DCQ     0
cfa_slit    DCQ     0
cfa_cstr    DCQ     0
cfa_execute DCQ     0
cfa_comma   DCQ     0
restart_cell DCQ    restart_cfa
numbuf      SPACE   32
word_scratch SPACE  80
wordlist_reg SPACE  256
words_user_base DCQ 0
words_filter_len DCQ 0
words_nk_tmp DCQ    0
words_filter SPACE  64
words_cfa   SPACE   8192
data_stack
dstack      SPACE   4096
return_stack
rstack      SPACE   4096
; Logical size starts at 8 MiB. GROWMEMORYMB raises it once, up to 256 MiB.
; The reserve is uninitialized so the image stays small. The base does not move.
user_dict_size_cell DCQ 8388608
grow_memory_used DCQ 0
xchar_emit_buf SPACE 8

        AREA |.bss|, DATA, NOINIT, READWRITE, ALIGN=3
user_dict_area
dictmem     SPACE   268435456
dict_end

        AREA |.data|, DATA, READWRITE, ALIGN=8
restart_cfa DCQ     XRESTART
catch_ok_cfa DCQ    XCATCH_OK
        EXPORT tw_continue_cfa
tw_continue_cfa DCQ XTW_CONTINUE

        EXTERN XRESTART
        EXTERN XCATCH_OK
        EXTERN XTW_CONTINUE

        END
