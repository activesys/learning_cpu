.code32
.section .text
.globl _int
_int:

.type _int0x80, @function
_int0x80:

    iret

dummy1:
    .space 0x20-(.-_int), 0x00

.type _int0x90, @function
_int0x90:

    iret

dummy2:
    .space 0x40-(.-_int), 0x00

.type _int0xff, @function
_int0xff:

    iret

dummy3:
    .space 0x60-(.-_int), 0x00

.type _gp_handler, @function
_gp_handler:

    iret

.globl _int_end
_int_end:

