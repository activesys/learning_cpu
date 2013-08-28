#
# Boot and read interrupt, setup, kernel user code and data.
#

.include "common.inc"

.code16
.section .text
.globl _start
_start:
    # read setup
    read_sector $SETUP_SEG, $0x02, $0x03
    jc _read_sector_error

    # read interrupt handler
    read_sector $INT_SEG, $0x05, $0x01
    jc _read_sector_error

    # read kernel code and data.
    read_sector $KERNEL_SEG, $0x06, $0x01
    jc _read_sector_error

    # read user code and data.
    read_sector $USER_SEG, $0x07, $0x01
    jc _read_sector_error

    # read user code and data.
    read_sector $TEST_CODE_SEQ, $0x08, $0x02
    jc _read_sector_error

    ljmp $0x00, $SETUP_SEG

_read_sector_error:
    # show message.
    movw $boot_message, %si
    movw $boot_message_length, %cx
    call _echo

    jmp .

.type _echo, @function
_echo:
    movb $0x0e, %ah
_do_echo:
    lodsb
    int $0x10
    loop _do_echo

    movb $0x0e, %ah
    movb $0x0d, %al
    int $0x10
    movb $0x0a, %al
    int $0x10
    ret

boot_message:
    .ascii "Read sector failure!"
boot_message_end:
    .equ boot_message_length, boot_message_end - boot_message

dummy:
    .space 510-(.-_start), 0

magic_number:
    .byte 0x55, 0xaa

