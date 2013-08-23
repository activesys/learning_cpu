#
# code and data for user
#

.include "common.inc"

###############################################################
# code for user
.code32
.globl _start
_start:
    movl $USER_MSG_OFFSET, %edi
    movl $USER_MSG_LENGTH, %ecx
    call _user_echo

    jmp .

# %edi, %ax, %ecx, %esi
.type _user_echo, @function
_user_echo:
    movl $800, %edx
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
    .ascii "In user code, CPL == 3\n"

dummy1:
    .space 0x200-(.-_start), 0x00

