# code and data for kernel
.include "common.inc"

###############################################################
# code for kernel
.code32
.globl _start
_start:
    xorl %eax, %eax
    movw $KERNEL_DATA_SELECTOR, %ax
    movw %ax, %ds
    movw $KERNEL_STACK_SELECTOR, %ax
    movw %ax, %ss
    movl $KERNEL_STACK_INIT_ESP, %esp

    #movl $0x00, %esi
    #movl $_kernel_msg_len, %ecx
    #int $0xff

    # jmp to user code.
    ljmp $USER_CODE_SELECTOR, $0x00

dummy:
    .space 0x100-(.-_start), 0x00

###############################################################
# data for kernel
_kernel_msg:
    .ascii "In kernel code, CPL == 0"
_kernel_msg_end:
    .equ _kernel_msg_len, _kernel_msg_end - _kernel_msg

.space 0x40-(.-_kernel_msg), 0x00
_gp_msg:
    .ascii "Entry #GP handler due to Privilege Level Checking."
_gp_msg_end:
.space 0x80-(.-_kernel_msg), 0x00
_gp_msg_len:
    .int _gp_msg_end - _gp_msg - 1

dummy1:
    .space 0x200-(.-_start), 0x00

