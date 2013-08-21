.include "common.inc"

.code16
.section .text
.globl _start
_start:
    # read interrupt handler
    read_sector $SETUP_SEG, $0x02, $0x02
    jc _read_sector_error

    # read kernel code and data.
    read_sector $KERNEL_CODE_BASE, $0x04, $0x01
    jc _read_sector_error

    # read user code and data.
    read_sector $USER_CODE_BASE, $0x05, $0x01
    jc _read_sector_error

    ljmp $SETUP_SEG, $0x00

_read_sector_error:
    # show message.
    movw $boot_message, %si
    movw $boot_message_length, %cx
    call _echo

    jmp .

.include "echo.inc"

boot_message:
    .ascii "Read sector failure!"
boot_message_end:
    .equ boot_message_length, boot_message_end - boot_message

dummy:
    .space 510-(.-_start), 0

magic_number:
    .byte 0x55, 0xaa

