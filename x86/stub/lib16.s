#
# library 32
#

.code16
.section .text
.globl _start
_start:
    jmp .

###############################################################
dummy:
    .space 0x800-(.-_start), 0x00

