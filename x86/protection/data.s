.code32
.section .text
.globl _data
_data:
main_msg:
    .ascii "Now we are in protected-mode, this message come from data segment."
main_msg_end:

dummy1:
    .space 0x80-(.-_data), 0x00

gp_msg:
    .ascii "---->> IN #GP EXCEPTION HANDLER <<----"
gp_msg_end:

dummy2:
    .space 0x100-(.-_data), 0x00

int0x80_msg:
    .ascii "---->> IN INTERRUPT 0x80 HANDLER <<----"
int0x80_msg_end:

dummy3:
    .space 0x180-(.-_data), 0x00

int0x90_msg:
    .ascii "---->> IN INTERRUPT 0x90 HANDLER <<----"
int0x90_msg_end:

dummy4:
    .space 0x200-(.-_data), 0x00

main_msg_length:
    .short main_msg_end - main_msg
gp_msg_length:
    .short gp_msg_end - gp_msg
int0x80_msg_length:
    .short int0x80_msg_end - int0x80_msg
int0x90_msg_length:
    .short int0x90_msg_end - int0x90_msg

.globl _data_end
_data_end:

