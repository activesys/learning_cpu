.include "common.inc"

.code32
.section .text
.globl _main
_main:
    sti

    /*
    movl $MAIN_MSG_OFFSET, %esi
    movl $MAIN_MSG_LEN_OFFSET, %eax
    movl %ds:(%eax), %ecx
    int $0xff
    */
    int $0x80

    jmp .

.globl _main_end
_main_end:

