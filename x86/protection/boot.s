.code16
.section .text

.include "common.inc"

.globl _start
_start:
    #
    # read sector.
    #
    read_sector $SETUP_SEG, $0x02, $0x04
    jc _read_sector_error

    ljmp $0x00, $SETUP_SEG

_read_sector_error:
    #
    # show message.
    #
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

