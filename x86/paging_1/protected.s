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

code_entry:
    movl $msg1, %esi
    call puts
    call get_maxphyadd
    movl %eax, %esi
    call print_int_decimal
    movl $msg2, %esi
    call puts
    call println

    call init_32bit_paging
    movl $PDT32_BASE, %eax
    movl %eax, %cr3

    call pse_enable

    movl %cr0, %eax
    bts $31, %eax
    movl %eax, %cr0

    movl $msg3, %esi
    call puts
    call println

    movl $msg4, %esi
    call puts
    call println
    movl $0x00200000, %esi
    call dump_page

    call println

    movl $msg5, %esi
    call puts
    call println
    movl $0x00400000, %esi
    call dump_page

    jmp .

msg1:   .asciz  "MAXPHYADDR: "
msg2:   .asciz  "-bit"
msg3:   .asciz  "now: enable paging with 32-bit paging."
msg4:   .asciz  "----> dump virtual address 0x200000 <----"
msg5:   .asciz  "----> dump virtual address 0x400000 <----"

###############################################################
# init_32bit_paging
# 0x000000-0x3fffff maped to 0x00 page frame using 4M page
# 0x400000-0x400fff maped to 0x400000 page frame using 4K page
init_32bit_paging:
    pushl %eax
    movl $PDT32_BASE, %eax
    movl $0x00000087, (%eax)    # set PDT[0]
    movl $0x00201001, 4(%eax)   # set PDT[1]
    movl $PTT32_BASE, %eax
    movl $0x00400001, (%eax)
    popl %eax
    ret

pse_enable:
    movl $1, %eax
    cpuid
    bt $3, %edx
    jnc pse_enable_done
    movl %cr4, %eax
    bts $4, %eax
    movl %eax, %cr4
pse_enable_done:
    ret

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
.include "lib32.inc"
.include "handler.s"
.include "page32.s"

###############################################################
dummy:
    .space 0x800-(.-_start), 0x00

