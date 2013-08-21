# code and data for user
.include "common.inc"

###############################################################
# code for user
.code32
.globl _start
_start:
    xorl %eax, %eax
    movw $USER_DATA_SELECTOR, %ax
    movw %ax, %ds
    movw $USER_STACK_SELECTOR, %ax
    movw %ax, %ss
    movl $USER_STACK_INIT_ESP, %esp

    /*
    movl $0x00, %esi
    movl $_user_msg_len, %ecx
    int $0xff
    */

    jmp .

dummy:
    .space 0x100-(.-_start), 0x00

###############################################################
# data for user
_user_msg:
    .ascii "In user code, CPL == 3"
_user_msg_end:
    .equ _user_msg_len, _user_msg_end - _user_msg

dummy1:
    .space 0x200-(.-_start), 0x00

