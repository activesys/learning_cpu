#
# Interrupt and exception handler and data.
#
.include "common.inc"

###############################################################
# Protected-mode code for interrupt handler
.code32
.globl _start
_start:

# Exception #GP handler
.type _gp, @function
_gp:
    movl $INT_GP_MSG_OFFSET, %esi
    movl $INT_GP_MSG_LENGTH, %ecx
    call _int_echo

    jmp .
    iret

.space 0x20-(.-_start), 0x00

# Exception #TS handler
.type _ts, @function
_ts:
    movl $INT_TS_MSG_OFFSET, %esi
    movl $INT_TS_MSG_LENGTH, %ecx
    call _int_echo

    jmp .
    iret

.space 0x40-(.-_start), 0x00

# Exception #SS handler
.type _ss, @function
_ss:
    movl $INT_SS_MSG_OFFSET, %esi
    movl $INT_SS_MSG_LENGTH, %ecx
    call _int_echo

    jmp .
    iret

# %edi, %ax, %ecx, %esi
.type _int_echo, @function
_int_echo:
    xorl %ebx, %ebx
    movl %ebx, %edi
    shll %edi
    movb $0x0c, %ah
_int_start_echo:
    movb %ds:(%esi), %al
    movw %ax, %es:(%edi)

    inc %ebx
    movl %ebx, %edi
    shll %edi
    inc %esi
    loop _int_start_echo 

    ret

.space 0x100-(.-_start), 0x00

###############################################################
# Interrupt and exception data
_int_gp_msg:
    .ascii "In #GP Handler.\n"
_int_ts_msg:
    .ascii "In #TS Handler.\n"
_int_ss_msg:
    .ascii "In #SS Handler.\n"

.space 0x200-(.-_start), 0x00

