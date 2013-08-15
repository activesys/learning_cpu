.code16
.section .text
.equ BOOT_SEG, 0x7c00

.equ INT_HANDLER_BASE, 0x800
.equ INT_0X80_HANDLER, 0x800
.equ INT_0X90_HANDLER, 0x820
.equ INT_0XFF_HANDLER, 0x840

.equ IVT_OLD_ADDRESS, 0x00
.equ IVT_NEW_ADDRESS, 0x2000
.equ IVT_ENTRY_COUNT, 256
.equ INT_0X80_OFFSET, 0x2200
.equ INT_0X90_OFFSET, 0x2240
.equ INT_0XFF_OFFSET, 0x23fc

.globl _start
_start:
    cli
    xor %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    sti

    #
    # read interrupt handler to handler base address
    #
    movb $0x02, %ah
    movb $0x01, %al
    movb $0x00, %ch
    movb $0x02, %cl
    movb $0x00, %dh
    movb $0x00, %dl
    movw $INT_HANDLER_BASE, %bx
    int $0x13
    jc no_test

    movw $msg2, %si
    movw $msg2_length, %cx
    call _echo

    sidt old_IVT_pointer

    #
    # move ivt from old ivt address(0x00) to new ivt address (0x2000)
    #
    pushw %es
    pushw %ds
    movw $0x00, %ax
    movw %ax, %ds
    movw %ax, %es
    movw $IVT_ENTRY_COUNT, %cx
    movw $IVT_OLD_ADDRESS, %si
    movw $IVT_NEW_ADDRESS, %di
    rep movsl
    popw %ds
    popw %es

    lidt new_IVT_pointer

    movw $msg1, %si
    movw $msg1_length, %cx
    call _echo

    # setup interrupt vector for 0x80, 0x90, 0xff
    movl $INT_0X80_OFFSET, %edx
    movl $INT_0X80_HANDLER, (%edx)
    movl $INT_0X90_OFFSET, %edx
    movl $INT_0X90_HANDLER, (%edx)
    movl $INT_0XFF_OFFSET, %edx
    movl $INT_0XFF_HANDLER, (%edx)

    # test interrupt 0x80, 0x90, 0xff
    int $0x80
    int $0x90
    int $0xff

    # switch to old ivt address(0x00)
    lidt old_IVT_pointer

    movw $msg2, %si
    movw $msg2_length, %cx
    call _echo

    jmp boot_end

no_test:
    #
    # show message.
    #
    movw $boot_message, %si
    movw $boot_message_length, %cx
    call _echo

boot_end:
    movw $end_msg, %si
    movw $end_msg_length, %cx
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

old_IVT_pointer:
    .short 0x00
    .int 0x00
new_IVT_pointer:
    .short 0x03ff
    .int 0x2000

msg1:
    .ascii "now : IDTR.base = 0x2000"
msg1_end:
    .equ msg1_length, msg1_end - msg1
msg2:
    .ascii "now : IDTR.base = 0x00"
msg2_end:
    .equ msg2_length, msg2_end - msg2
boot_message:
    .ascii "No test to be execute!"
boot_message_end:
    .equ boot_message_length, boot_message_end - boot_message
end_msg:
    .ascii "        THE END"
end_msg_end:
    .equ end_msg_length, end_msg_end - end_msg

dummy:
    .space 510-(.-_start), 0

magic_number:
    .byte 0x55, 0xaa

