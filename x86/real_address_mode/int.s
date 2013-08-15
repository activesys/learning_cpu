.code16
.section .text
.globl _int0x80
.type _int0x80, @function
_int0x80:
    movw $int0x80_msg, %si
    movw $int0x80_msg_length, %cx
    call _int_echo

    iret

dummy1:
    .space 0x20-(.-_int0x80), 0x00

.globl _int0x90
.type _int0x90, @function
_int0x90:
    movw $int0x90_msg, %si
    movw $int0x90_msg_length, %cx
    call _int_echo

    iret

dummy2:
    .space 0x40-(.-_int0x80), 0x00

.globl _int0xff
.type _int0xff, @function
_int0xff:
    movw $int0xff_msg, %si
    movw $int0xff_msg_length, %cx
    call _int_echo

    iret

.type _int_echo, @function
_int_echo:
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

int0x80_msg:
    .ascii "--> IN INTERRUPT 0x80 HANDLER. <--"
int0x80_msg_end:
    .equ int0x80_msg_length, int0x80_msg_end - int0x80_msg
int0x90_msg:
    .ascii "--> IN INTERRUPT 0x90 HANDLER. <--"
int0x90_msg_end:
    .equ int0x90_msg_length, int0x90_msg_end - int0x90_msg
int0xff_msg:
    .ascii "--> IN INTERRUPT 0xff HANDLER. <--"
int0xff_msg_end:
    .equ int0xff_msg_length, int0xff_msg_end - int0xff_msg

dummy:
    .space 512-(.-_int0x80), 0x00

