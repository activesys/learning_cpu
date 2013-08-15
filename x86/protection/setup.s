.include "common.inc"

.code16
.section .text
.globl _start
_start:
    cli

    # move protect mode code to 0x7000
    movw $_setup_length, %cx
    movw $_setup, %si
    movw $SETUP_BASE, %di
    rep movsb

    #
    # setup idt
    #
    movl $IDT_BASE, %edi
    movl $13, %eax
    movl $EXCEPTION_GP_OFFSET, %ecx
    call _setup_idt

    movl $0x80, %eax
    movl $INT_0X80_OFFSET, %ecx
    call _setup_idt

    movl $0x90, %eax
    movl $INT_0X90_OFFSET, %ecx
    call _setup_idt

    movl $0xff, %eax
    movl $INT_0XFF_OFFSET, %ecx
    call _setup_idt

    lidt IDT_POINTER

    #
    # setup gdt
    #
    movl $GDT_BASE, %edi
    movl $NULL_DESCRIPTOR_BASE, %eax
    movl $NULL_DESCRIPTOR_LIMIT, %ecx
    movl $NULL_DESCRIPTOR_ATTR, %esi
    call _setup_gdt

    addl $8, %edi
    movl $INT_HANDLER_BASE, %eax
    movl $INT_HANDLER_LIMIT, %ecx
    movl $INT_HANDLER_ATTR, %esi
    call _setup_gdt

    addl $8, %edi
    movl $CODE_MAIN_BASE, %eax
    movl $CODE_MAIN_LIMIT, %ecx
    movl $CODE_MAIN_ATTR, %esi
    call _setup_gdt

    addl $8, %edi
    movl $DATA_BASE, %eax
    movl $DATA_LIMIT, %ecx
    movl $DATA_ATTR, %esi
    call _setup_gdt

    addl $8, %edi
    movl $STACK_BASE, %eax
    movl $STACK_LIMIT, %ecx
    movl $STACK_ATTR, %esi
    call _setup_gdt

    addl $8, %edi
    movl $SETUP_BASE, %eax
    movl $SETUP_LIMIT, %ecx
    movl $SETUP_ATTR, %esi
    call _setup_gdt

    addl $8, %edi
    movl $INT_STACK_BASE, %eax
    movl $INT_STACK_LIMIT, %ecx
    movl $INT_STACK_ATTR, %esi
    call _setup_gdt

    addl $8, %edi
    movl $VIDEO_BASE, %eax
    movl $VIDEO_LIMIT, %ecx
    movl $VIDEO_ATTR, %esi
    call _setup_gdt

    addl $8, %edi
    movl $SUPER_BASE, %eax
    movl $SUPER_LIMIT, %ecx
    movl $SUPER_ATTR, %esi
    call _setup_gdt

    lgdt GDT_POINTER

    # switch to protected-mode
    movl %cr0, %eax
    orl $1, %eax
    movl %eax, %cr0

    # far jmp
    ljmp $SETUP_SELECTOR, $0x00

#
# %edi is address
# %eax is interrupt number
# %ecx is offset
#
.type _setup_idt, @function
_setup_idt:
    pushl %edi
    movl %eax, %ebx
    shll $3, %ebx
    addl %ebx, %edi

    # attr = 0x8e00(P=1,DPL=00,D=1)
    movl $INT_HANDLER_SELECTOR, %edx
    shll $16, %edx
    movl %ecx, %ebx
    andl $0x0000ffff, %ebx
    orl %ebx, %edx
    movl %edx, (%edi)

    movl %ecx, %edx
    andl $0xffff0000, %edx
    orl $0x8e00, %edx
    movl %edx, 4(%edi)

    popl %edi

#
# %edi is descriptor entry address.
# %eax is base
# %ecx is offset
# %esi is attribute
#
.type _setup_gdt, @function
_setup_gdt:
    movl %eax, %ebx
    andl $0x0000ffff, %ebx
    shll $16, %ebx
    movl %ecx, %edx
    andl $0x0000ffff, %edx
    orl %ebx, %edx
    movl %edx, (%edi)

    movl %eax, %ebx
    andl $0x00ff0000, %ebx
    shrl $16, %ebx
    movl %ebx, %edx
    movl %eax, %ebx
    andl $0xff000000, %ebx
    orl %ebx, %edx
    movl %ecx, %ebx
    andl $0x000f0000, %ebx
    orl %ebx, %edx
    movl %esi, %ebx
    andl $0x0000fff0ff, %ebx
    shll $8, %ebx
    orl %ebx, %edx
    movl %edx, 4(%edi)

    ret

GDT_POINTER:
    .short 0x48
    .int   0x0800
IDT_POINTER:
    .short 0x7ff
    .int   0x00

.code32
.type _setup, @function
_setup:
    # copy code and date to appropriate address use super data segment.
    xorl %eax, %eax
    movw $SUPER_SELECTOR, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs

    # copy intrrupt code
    movl $_int, %esi
    movl $INT_HANDLER_BASE, %edi
    movl $_int_end, %ecx
    subl $_int, %ecx
    rep movsb

    # copy main code
    movl $_main, %esi
    movl $CODE_MAIN_BASE, %edi
    movl $_main_end, %ecx
    subl $_main, %ecx
    rep movsb

    # copy data
    movl $_data, %esi
    movl $DATA_BASE, %edi
    movl $_data_end, %ecx
    subl $_data, %ecx
    rep movsb

    # initialize interrupt environment
    xorl %eax, %eax
    movw $INT_STACK_SELECTOR, %ax
    movw %ax, %ss
    movl $INT_STACK_INIT_ESP, %esp
    pushl $0x00

    # initialize protected-mode environment
    xorl %eax, %eax
    movw $DATA_SELECTOR, %ax
    movw %ax, %ds
    movw $VIDEO_SELECTOR, %ax
    movw %ax, %es
    movw $STACK_SELECTOR, %ax
    movw %ax, %ss
    movl $STACK_INIT_ESP, %esp
    movw $NULL_SELECTOR, %ax
    movw %ax, %gs
    movw %ax, %fs

    ljmp $CODE_MAIN_SELECTOR, $0x00

_setup_end:
    .equ _setup_length, _setup_end - _setup

