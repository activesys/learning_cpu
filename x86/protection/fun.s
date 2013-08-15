.code32
.section .text

.include "common.inc"

.globl _start
_start:
    movl $FUN_MSG_OFFSET, %eax
    movl $FUN_MSG_LEN_OFFSET, %ebx
    leaw (%eax), %si
    movw (%ebx), %cx
    call _echo

    # test interrupt 0x80, 0x90, 0xff
    int $0x80
    int $0x90
    int $0xff

    movl $END_MSG_OFFSET, %eax
    movl $END_MSG_LEN_OFFSET, %ebx
    leaw (%eax), %si
    movw (%ebx), %cx
    call _echo

    jmp .

.include "echo.inc" 

dummy:
    .space 512-(.-_start), 0
    
