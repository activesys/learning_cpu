#
# test data
#

.code32
.globl _start
_start:
###############################################################
# CPL0 message
_test_data_cpl0_msg:
    .ascii "TEST DATA MESSAGE, CPL == 0, DPL == 0."
    .ascii "TEST DATA MESSAGE, CPL == 3, DPL == 0."

dummy1:
    .space 0x100-(.-_start), 0x00

###############################################################
# CPL3 message
_test_data_cpl3_msg:
    .ascii "TEST DATA MESSAGE, CPL == 3, DPL == 3."
    .ascii "TEST DATA MESSAGE, CPL == 0, DPL == 3."

dummy2:
    .space 0x200-(.-_start), 0x00

