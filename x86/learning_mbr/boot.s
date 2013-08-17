.code16
.section .text
#.org 0x7c00
.globl _start
_start:
    movw %cs, %ax
    movw %ax, %ds
    movw %ax, %es

    movw $boot_message, %ax
    movw %ax, %bp
    movw $0x1301, %ax
    movw $16, %cx
    movw $0x0c, %bx
    movw $0x00, %dx

    int $0x10

    jmp .

boot_message:
    .ascii "Hello, OS world!"

dummy:
    .space 510-(.-_start), 0

magic_number:
    .byte 0x55, 0xaa