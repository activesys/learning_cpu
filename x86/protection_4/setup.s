.include "common.inc"


###############################################################
# Real-mode code for setup
.code16
.section .text
.globl _start
_start:
    # move interrupt handler to interrupt base
    movw $_interrupt_and_exception_length, %cx
    movw $_interrupt_and_exception, %si
    movw $INT_HANDLER_BASE, %di
    rep movsb

    # setup idt
    movl $IDT_BASE, %edi
    movl $13, %eax
    movl $EXCEPTION_GP_OFFSET, %ecx
    call _setup_idt

    lidt IDT_POINTER

    # setup gdt
    movl $GDT_BASE, %edi
    movl $NULL_DESCRIPTOR_BASE, %eax
    movl $NULL_DESCRIPTOR_LIMIT, %ecx
    movl $NULL_DESCRIPTOR_ATTR, %esi
    call _setup_gdt

    movl $SETUP_BASE, %eax
    movl $SETUP_LIMIT, %ecx
    movl $SETUP_ATTR, %esi
    call _setup_gdt

    movl $INT_HANDLER_BASE, %eax
    movl $INT_HANDLER_LIMIT, %ecx
    movl $INT_HANDLER_ATTR, %esi
    call _setup_gdt

    movl $VIDEO_BASE, %eax
    movl $VIDEO_LIMIT, %ecx
    movl $VIDEO_ATTR, %esi
    call _setup_gdt

    movl $KERNEL_CODE_BASE, %eax
    movl $KERNEL_CODE_LIMIT, %ecx
    movl $KERNEL_CODE_ATTR, %esi
    call _setup_gdt

    movl $KERNEL_DATA_BASE, %eax
    movl $KERNEL_DATA_LIMIT, %ecx
    movl $KERNEL_DATA_ATTR, %esi
    call _setup_gdt

    movl $KERNEL_STACK_BASE, %eax
    movl $KERNEL_STACK_LIMIT, %ecx
    movl $KERNEL_STACK_ATTR, %esi
    call _setup_gdt

    movl $USER_CODE_BASE, %eax
    movl $USER_CODE_LIMIT, %ecx
    movl $USER_CODE_ATTR, %esi
    call _setup_gdt

    movl $USER_DATA_BASE, %eax
    movl $USER_DATA_LIMIT, %ecx
    movl $USER_DATA_ATTR, %esi
    call _setup_gdt

    movl $USER_STACK_BASE, %eax
    movl $USER_STACK_LIMIT, %ecx
    movl $USER_STACK_ATTR, %esi
    call _setup_gdt

    lgdt GDT_POINTER

    # switch to protected-mode
    movl %cr0, %eax
    orl $1, %eax
    movl %eax, %cr0

    # far jmp
    ljmp $SETUP_SELECTOR, _setup

_read_sector_error:
    # show message.
    movw $boot_message, %si
    movw $boot_message_length, %cx
    call _echo

    jmp .

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
    .short GDT_LIMIT
    .int   GDT_BASE
IDT_POINTER:
    .short IDT_LIMIT
    .int   IDT_BASE


###############################################################
# Protected-mode code for interrupt handler
.code 32
_interrupt_and_exception:
.type _gp, @function
_gp:
    movl $_gp_msg, %esi
    movl $_gp_msg_length, %ecx
    call _int_echo

    jmp .
    iret

# %edi, %ax, %ecx, %esi
.type _int_echo, @function
_int_echo:
    xorl %ebx, %ebx
    movl %ebx, %edi
    shll %edi
    movb $0x0c, %ah
_int_start_echo:
    movb %ds:(%esi), %al
    movw %ax, %es:(%edi)

    inc %ebx
    movl %ebx, %edi
    shll %edi
    inc %esi
    loop _int_start_echo 

    ret

_interrupt_and_exception_end:
.equ _interrupt_and_exception_length, _interrupt_and_exception_end - _interrupt_and_exception


###############################################################
# Protected-mode code for setup
.code32
.type _setup, @function
_setup:


dummy:
    .space 1024-(.-_start), 0

