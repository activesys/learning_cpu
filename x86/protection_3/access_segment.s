.equ null_selector, 0x00
.equ code_selector, 0x08
.equ vedio_selector, 0x10
.equ stack_selector, 0x18
.equ data_selector, 0x20
.equ int_selector, 0x28

.equ invalid_selector, 0x0100

.equ init_esp, 0x6000
.equ int_base, 0x1000

# REAL-ADDRESS-MODE CODE
.code16
.section .text

.globl _start
_start:
    cli
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss

    #move interrupt code to 0x1000
    movw $_interrupt_and_exception_length, %cx
    movw $_interrupt_and_exception, %si
    movw $int_base, %di
    rep movsb

    # setup idt in 0x00
    movl $0x00, %edi
    movl $256, %ecx
_setup_idt:
    movl $0x00, (%edi)
    movl $0x00, 4(%edi)
    addl $8, %edi
    loop _setup_idt
    # setup #GP handler
    movl $13, %edi
    shll $3, %edi
    movl $0x00280000, (%edi)
    movl $0x00008e00, 4(%edi)

    lidt idt_pointer

    lgdt gdt_pointer

    movl %cr0, %eax
    orl $0x01, %eax
    movl %eax, %cr0

    ljmp $code_selector, $_protect

# GDT
gdt_start:
null_descriptor:
    .quad 0x0000000000000000
code_descriptor:
    .quad 0x00cf98000000ffff
vedio_descriptor:
    .quad 0x00cf920b8000ffff
stack_descriptor:
    .quad 0x00cf92007000ffff
data_descriptor:
    .quad 0x00cf90000000ffff
int_descriptor:
    .quad 0x00cf9a001000ffff
gdt_end:
.equ gdt_len, gdt_end - gdt_start

gdt_pointer:
    .short gdt_len
    .int   gdt_start
idt_pointer:
    .short 0x7ff
    .int   0x00

# DATA
_data:
_gp_msg:
    .ascii "Entry exception #GP handler due to Access Segment with Incorrect Type."
_gp_msg_end:
    .equ _gp_msg_length, _gp_msg_end - _gp_msg

# PROTECTED-MODE CODE
.code32
.type _protect, @function
_protect:
    movw $data_selector, %ax
    movw %ax, %ds
    movw $vedio_selector, %ax
    movw %ax, %es
    movw $stack_selector, %ax
    movw %ax, %ss
    movw $null_selector, %ax
    movw %ax, %fs
    movw %ax, %gs
    movl $init_esp, %esp

    # write into executable segment.
    # trigger #GP exception
    #xorl %eax, %eax
    #movl %ebx, %cs:(%eax)

    # write into read-only data segment.
    # trigger #GP exception
    #xorl %eax, %eax
    #movl %ebx, %ds:(%eax)

    # read into executable-only segment.
    # trigger #GP exception
    xorl %eax, %eax
    movl %cs:(%eax), %ebx

    jmp .

# INTERRUPT AND EXCEPTION HANDLER
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

dummy:
    .space 510-(.-_start), 0

magic_number:
    .byte 0x55, 0xaa

