#
# code and data for user
#

.include "common.inc"

###############################################################
# code for user
.code32
.globl _start
_start:
    movl $USER_STACK_INIT_ESP, %esp

    movl $USER_MSG_OFFSET, %esi
    movl $USER_MSG_LENGTH, %ecx
    movl $USER_FIRST_VIDEO_OFFSET, %edx
    call _user_echo

    #lcall $NONCONFORMING_CODE_DPL3_SELECTOR, $0x00
    #lcall $NONCONFORMING_CODE_DPL0_SELECTOR, $0x00
    #lcall $CONFORMING_CODE_DPL3_SELECTOR, $0x00
    #lcall $CONFORMING_CODE_DPL0_SELECTOR, $0x00
    #lcall $CONFORMING_CODE_DPL0_CPL3_SELECTOR, $0x00
    lcall $NONCONFORMING_CALL_GATE_SELECTOR, $0x00

    iret

# %edi, %ax, %ecx, %esi
.type _user_echo, @function
_user_echo:
    xorl %ebx, %ebx
    leal (%edx, %ebx), %edi
    shll %edi
    movb $0x0c, %ah
_user_start_echo:
    movb %ds:(%esi), %al
    movw %ax, %es:(%edi)

    inc %ebx
    leal (%edx, %ebx), %edi
    shll %edi
    inc %esi
    loop _user_start_echo 

    ret

dummy:
    .space 0x100-(.-_start), 0x00

###############################################################
# data for user
_user_msg:
    .ascii "In user code, CPL == 3."

dummy1:
    .space 0x200-(.-_start), 0x00

