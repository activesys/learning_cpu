#
# Setup IDT, GDT, LDT, TSS and switch to protected-mode.
#

.include "common.inc"


###############################################################
# Real-mode code for setup
.code16
.section .text
.globl _start
_start:
    cli

    # setup idt
    movl $IDT_BASE, %edi
    call _clear_idt

    movl $8, %eax
    movl $EXCEPTION_DF_OFFSET, %ecx
    call _setup_idt

    movl $10, %eax
    movl $EXCEPTION_TS_OFFSET, %ecx
    call _setup_idt

    movl $11, %eax
    movl $EXCEPTION_NP_OFFSET, %ecx
    call _setup_idt

    movl $12, %eax
    movl $EXCEPTION_SS_OFFSET, %ecx
    call _setup_idt

    movl $13, %eax
    movl $EXCEPTION_GP_OFFSET, %ecx
    call _setup_idt

    movl $14, %eax
    movl $EXCEPTION_PF_OFFSET, %ecx
    call _setup_idt

    lidt IDT_POINTER

    # setup gdt
    movl $GDT_BASE, %edi
    movl $NULL_DESCRIPTOR_BASE, %eax
    movl $NULL_DESCRIPTOR_LIMIT, %ecx
    movl $NULL_DESCRIPTOR_ATTR, %esi
    call _setup_gdt

    addl $0x08, %edi
    movl $SETUP_BASE, %eax
    movl $SETUP_LIMIT, %ecx
    movl $SETUP_ATTR, %esi
    call _setup_gdt

    addl $0x08, %edi
    movl $SETUP_TSS_BASE, %eax
    movl $SETUP_TSS_LIMIT, %ecx
    movl $SETUP_TSS_ATTR, %esi
    call _setup_gdt

    addl $0x08, %edi
    movl $INT_HANDLER_BASE, %eax
    movl $INT_HANDLER_LIMIT, %ecx
    movl $INT_HANDLER_ATTR, %esi
    call _setup_gdt

    addl $0x08, %edi
    movl $INT_DATA_BASE, %eax
    movl $INT_DATA_LIMIT, %ecx
    movl $INT_DATA_ATTR, %esi
    call _setup_gdt

    addl $0x08, %edi
    movl $INT_STACK_BASE, %eax
    movl $INT_STACK_LIMIT, %ecx
    movl $INT_STACK_ATTR, %esi
    call _setup_gdt

    addl $0x08, %edi
    movl $INT_VIDEO_BASE, %eax
    movl $INT_VIDEO_LIMIT, %ecx
    movl $INT_VIDEO_ATTR, %esi
    call _setup_gdt

    addl $0x08, %edi
    movl $KERNEL_TSS_BASE, %eax
    movl $KERNEL_TSS_LIMIT, %ecx
    movl $KERNEL_TSS_ATTR, %esi
    call _setup_gdt

    addl $0x08, %edi
    movl $KERNEL_LDT_BASE, %eax
    movl $KERNEL_LDT_LIMIT, %ecx
    movl $KERNEL_LDT_ATTR, %esi
    call _setup_gdt

    addl $0x08, %edi
    movl $USER_TSS_BASE, %eax
    movl $USER_TSS_LIMIT, %ecx
    movl $USER_TSS_ATTR, %esi
    call _setup_gdt

    addl $0x08, %edi
    movl $USER_LDT_BASE, %eax
    movl $USER_LDT_LIMIT, %ecx
    movl $USER_LDT_ATTR, %esi
    call _setup_gdt

    lgdt GDT_POINTER

    # setup ldt
    # setup ldt for kernel
    movl $KERNEL_LDT_BASE, %edi
    movl $KERNEL_CODE_BASE, %eax
    movl $KERNEL_CODE_LIMIT, %ecx
    movl $KERNEL_CODE_ATTR, %esi
    call _setup_ldt

    addl $0x08, %edi
    movl $KERNEL_DATA_BASE, %eax
    movl $KERNEL_DATA_LIMIT, %ecx
    movl $KERNEL_DATA_ATTR, %esi
    call _setup_ldt

    addl $0x08, %edi
    movl $KERNEL_STACK_BASE, %eax
    movl $KERNEL_STACK_LIMIT, %ecx
    movl $KERNEL_STACK_ATTR, %esi
    call _setup_ldt

    addl $0x08, %edi
    movl $KERNEL_VIDEO_BASE, %eax
    movl $KERNEL_VIDEO_LIMIT, %ecx
    movl $KERNEL_VIDEO_ATTR, %esi
    call _setup_ldt

    # setup ldt for user
    movl $USER_LDT_BASE, %edi
    movl $USER_CODE_BASE, %eax
    movl $USER_CODE_LIMIT, %ecx
    movl $USER_CODE_ATTR, %esi
    call _setup_ldt

    addl $0x08, %edi
    movl $USER_DATA_BASE, %eax
    movl $USER_DATA_LIMIT, %ecx
    movl $USER_DATA_ATTR, %esi
    call _setup_ldt

    addl $0x08, %edi
    movl $USER_STACK_BASE, %eax
    movl $USER_STACK_LIMIT, %ecx
    movl $USER_STACK_ATTR, %esi
    call _setup_ldt

    addl $0x08, %edi
    movl $USER_VIDEO_BASE, %eax
    movl $USER_VIDEO_LIMIT, %ecx
    movl $USER_VIDEO_ATTR, %esi
    call _setup_ldt

    # setup tss
    # setup tss for kernel
    movl $KERNEL_TSS_BASE, %edi
    movl $INT_STACK_INIT_ESP, %eax
    movl $INT_STACK_SELECTOR, %ebx
    movl $KERNEL_LDT_SELECTOR, %edx
    call _setup_tss
    movl $KERNEL_CODE_SELECTOR, %eax
    movl $KERNEL_DATA_SELECTOR, %ebx
    movl $KERNEL_STACK_SELECTOR, %ecx
    movl $KERNEL_VIDEO_SELECTOR, %edx
    call _setup_tss_segment

    # setup tss for user
    movl $USER_TSS_BASE, %edi
    movl $INT_STACK_INIT_ESP, %eax
    movl $INT_STACK_SELECTOR, %ebx
    movl $USER_LDT_SELECTOR, %edx
    call _setup_tss
    movl $USER_CODE_SELECTOR, %eax
    movl $USER_DATA_SELECTOR, %ebx
    movl $USER_STACK_SELECTOR, %ecx
    movl $USER_VIDEO_SELECTOR, %edx
    call _setup_tss_segment

    # switch to protected-mode
    movl %cr0, %eax
    orl $1, %eax
    movl %eax, %cr0

    # far jmp
    ljmp $SETUP_SELECTOR, $_setup

_start_end:


#
# %edi is address
# %eax esp0
# %ebx ss0
# %edx ldt selector
#
.type _setup_tss, @function
_setup_tss:
    movl $0x1a, %ecx
_clear_tss:
    movl $0x00, -4(%edi, %ecx, 4)
    loop _clear_tss

    movl %eax, 4(%edi)
    movw %bx, 8(%edi)
    movw %dx, 96(%edi)

    ret

#
# %edi is address
# %eax cs
# %ebx ds
# %ecx ss
# %edx es
#
.type _setup_tss_segment, @function
_setup_tss_segment:
    movw %ax, 76(%edi)
    movw %bx, 84(%edi)
    movw %cx, 80(%edi)
    movw %dx, 72(%edi)
    ret

#
# %edi is address
#
.type _clear_idt, @function
_clear_idt:
    movl $0x0100, %ecx
_do_clear:
    movl $0x00, -4(%edi, %ecx, 8)
    movl $0x00, -8(%edi, %ecx, 8)
    loop _do_clear

    ret
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

    ret

#
# %edi is descriptor entry address.
# %eax is base
# %ecx is offset
# %esi is attribute
#
.type _setup_gdt, @function
.type _setup_ldt, @function
_setup_gdt:
_setup_ldt:
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
    .short GDT_LIMIT
    .int   GDT_BASE
IDT_POINTER:
    .short IDT_LIMIT
    .int   IDT_BASE

###############################################################
# Protected-mode code for setup
.code32
.type _setup, @function
_setup:
    xorl %eax, %eax
    movw $INT_DATA_SELECTOR, %ax
    movw %ax, %ds
    movw $INT_STACK_SELECTOR, %ax
    movw %ax, %ss
    movl $INT_STACK_INIT_ESP, %esp
    movw $INT_VIDEO_SELECTOR, %ax
    movw %ax, %es
    movw $NULL_SELECTOR, %ax
    movw %ax, %fs
    movw %ax, %gs

    call _clear_screen

    movl $SETUP_TSS_SELECTOR, %eax
    ltr %ax

    ljmp $KERNEL_TSS_SELECTOR, $0x00

# %edi, %ax, %ecx, %esi
.type _clear_screen, @function
_clear_screen:
    xorl %edx, %edx
_start_clear_screen:
    xorl %ebx, %ebx
    leal (%edx, %ebx), %edi
    shll %edi
    movl $80, %ecx
    movb $0x0c, %ah
_do_clear_screen:
    movb $0x20, %al
    movw %ax, %es:(%edi)

    inc %ebx
    leal (%edx, %ebx), %edi
    shll %edi
    loop _do_clear_screen 

    addl $80, %edx
    cmp $1600, %edx
    jnz _start_clear_screen

    ret

###############################################################
dummy:
    .space 0x600-(.-_start), 0x00

