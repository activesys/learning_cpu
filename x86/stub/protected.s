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

    # set interrupt handler
    movl $GP_HANDLER_VECTOR, %esi
    movl $GP_handler, %edi
    call __set_interrupt_handler

    movl $DB_HANDLER_VECTOR, %esi
    movl $DB_handler, %edi
    call __set_interrupt_handler

    movl $AC_HANDLER_VECTOR, %esi
    movl $AC_handler, %edi
    call __set_interrupt_handler

    movl $UD_HANDLER_VECTOR, %esi
    movl $UD_handler, %edi
    call __set_interrupt_handler

    movl $NM_HANDLER_VECTOR, %esi
    movl $NM_handler, %edi
    call __set_interrupt_handler

    movl $TS_HANDLER_VECTOR, %esi
    movl $TS_handler, %edi
    call __set_interrupt_handler

    movl $OF_HANDLER_VECTOR, %esi
    movl $OF_handler, %edi
    call __set_user_interrupt_handler

    movl $BP_HANDLER_VECTOR, %esi
    movl $BP_handler, %edi
    call __set_user_interrupt_handler

    movl $BR_HANDLER_VECTOR, %esi
    movl $BR_handler, %edi
    call __set_user_interrupt_handler

    movw $0x00, %ax
    movw %ax, %ss

    jmp .

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
# GDT, IDT
__gdt_pointer:
    __gdt_limit:    .short  0x00
    __gdt_base:     .int    0x00

__idt_pointer:
    __idt_limit:    .short  0x00
    __idt_base:     .int    0x00

###############################################################
# include exception handler
.include "handler.s"

###############################################################
dummy:
    .space 0x800-(.-_start), 0x00

