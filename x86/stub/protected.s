#
# protected code.
#

.include "common.inc"

.code32
.section .text
.globl _start
_start:
    movw $KERNEL_DATA32_SELECTOR, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movl $0x7ff0, %esp

    movw $TSS32_SELECTOR, %ax
    ltr %ax


###############################################################
# set interrupt handler for kernel and user
# %esi : vector, %edi handler
.type __set_interrupt_handler, @function
__set_interrupt_handler:
    sidt __idt_pointer
    movl __idt_base, %eax
    movl %edi, 4(%eax, %esi, 8)
    movw %di, (%eax, %esi, 8)
    movw $KERNEL_CODE32_SELECTOR, 2(%eax, %esi, 8)
    movb $0x8e, 5(%eax, %esi, 8)
    ret

.type __set_user_interrupt_handler, @function
__set_user_interrupt_handler:
    sidt __idt_pointer
    movl __idt_base, %eax
    movl %edi, 4(%eax, %esi, 8)
    movw %di, (%eax, %esi, 8)
    movw $KERNEL_CODE32_SELECTOR, 2(%eax, %esi, 8)
    movb $0xee, 5(%eax, %esi, 8)
    ret

###############################################################
# include exception handler
.include "handler.s"

###############################################################
dummy:
    .space 0x800-(.-_start), 0x00
