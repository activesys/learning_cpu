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

    # load test data DPL == 3
    movl $TEST_DATA_DPL3_SELECTOR_RPL3, %eax
    movw %ax, %ds
    movl $TEST_DATA_CPL3_DPL3_MSG_OFFSET, %esi
    movl $TEST_DATA_CPL3_DPL3_MSG_LENGTH, %ecx
    movl $CPL3_DPL3_VIDEO_OFFSET, %edx
    call _user_echo

    #movl $TEST_DATA_DPL0_SELECTOR_RPL0, %eax
    #movw %ax, %ds

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

