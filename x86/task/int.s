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

.space 0x60-(.-_start), 0x00

# Exception #DF handler
.type _df, @function
_df:
    movl $INT_DF_MSG_OFFSET, %esi
    movl $INT_DF_MSG_LENGTH, %ecx
    call _int_echo

    jmp .
    iret

.space 0x80-(.-_start), 0x00

# Exception #NP handler
.type _np, @function
_np:
    movl $INT_NP_MSG_OFFSET, %esi
    movl $INT_NP_MSG_LENGTH, %ecx
    call _int_echo

    jmp .
    iret

.space 0xa0-(.-_start), 0x00

# Exception #PF handler
.type _pf, @function
_pf:
    movl $INT_PF_MSG_OFFSET, %esi
    movl $INT_PF_MSG_LENGTH, %ecx
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
    .ascii "In #GP Handler. "
_int_ts_msg:
    .ascii "In #TS Handler. "
_int_ss_msg:
    .ascii "In #SS Handler. "
_int_df_msg:
    .ascii "In #DF Handler. "
_int_np_msg:
    .ascii "In #NP Handler. "
_int_pf_msg:
    .ascii "In #PF Handler. "

.space 0x200-(.-_start), 0x00

