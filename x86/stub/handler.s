#
# handler
#

###############################################################
# GP_handler():
GP_handler:
    jmp do_GP_handler
gmsg1:  .asciz  '----> Now, enter #GP handler, occur at: 0x'
gmsg2:  .asciz  ', error code = 0x'
gmsg3:  .asciz  '<ID:'
gmsg4:  .asciz  '---------------- register contentx -------------'
do_GP_handler:
    movl $gmsg1, %esi
    call puts
do_GP_handler_done:
    iret

