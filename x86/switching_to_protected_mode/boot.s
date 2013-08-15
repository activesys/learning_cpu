.code16
.section .text

.equ null_selector, 0x00
.equ code_selector, 0x08
.equ vedio_selector, 0x10
.equ stack_selector, 0x18
.equ data_selector, 0x20

.globl _start
_start:
    cli
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss

    # move data to 0x800
    movw $32, %cx
    movw $_protect_msg, %si
    movw $0x800, %di
    rep movsb

    # move protect mode code to 0x2000
    movw $_protect_length, %cx
    movw $_protect, %si
    movw $0x2000, %di
    rep movsb

    lgdt gdt_pointer

    movl %cr0, %eax
    orl $0x01, %eax
    movl %eax, %cr0

    ljmp $code_selector, $0x00

gdt_start:
null_descriptor:
    .quad 0x0000000000000000
code_descriptor:
    .quad 0x00cf9a002000ffff
vedio_descriptor:
    .quad 0x00cf920b8000ffff
stack_descriptor:
    .quad 0x00cf92007000ffff
data_descriptor:
    .quad 0x00cf92000800ffff
gdt_end:

.equ gdt_len, gdt_end - gdt_start

gdt_pointer:
    .short 0xffff
    .int   gdt_start

_protect_msg:
    .ascii "In Protected-Mode."
_protect_msg_end:
    .space 30-(.-_protect_msg), 0x00
    .short _protect_msg_end - _protect_msg

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
    movl $0x7000, %esp

    movl $0x00, %esi
    movl $30, %eax
    movl %ds:(%eax), %ecx
    call _echo

    jmp .

# %edi, %ax, %ecx, %esi
.type _echo, @function
_echo:
    xorl %ebx, %ebx
    movl %ebx, %edi
    movb $0x0c, %ah
start_echo:
    movb %ds:(%esi), %al
    movw %ax, %es:(%edi)

    inc %ebx
    movl %ebx, %edi
    shll %edi
    inc %esi
    loop start_echo 

    ret

_protect_end:
.equ _protect_length, _protect_end - _protect

dummy:
    .space 510-(.-_start), 0

magic_number:
    .byte 0x55, 0xaa

