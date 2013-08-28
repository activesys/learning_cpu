#
# test code segments
#

.include "common.inc"

.code32
.globl _start
_start:

###############################################################
# nonconforming code DPL == 0
_nonconforming_code_dpl0:
    xorl %eax, %eax
    movl $TEST_CODE_DPL0_DATA_SELECTOR, %eax
    movw %ax, %ds
    movl $TEST_CODE_DPL0_STACK_SELECTOR, %eax
    movw %ax, %ss
    movl $TEST_CODE_DPL0_STACK_INIT_ESP, %esp
    movl $TEST_CODE_DPL0_VIDEO_SELECTOR, %eax
    movw %ax, %es
    movl $NULL_SELECTOR, %eax
    movw %ax, %fs
    movw %ax, %gs

    movl $_nonconforming_code_dpl0_msg, %esi
    movl $_nonconforming_code_dpl0_msg_len, %ecx
    movl $TEST_CODE_VIDEO_OFFSET, %edx
    call _code_echo

    jmp .

.space 0x40-(.-_start), 0x00

###############################################################
# nonconforming code DPL == 3
_nonconforming_code_dpl3:
    xorl %eax, %eax
    movl $TEST_CODE_DPL3_DATA_SELECTOR, %eax
    movw %ax, %ds
    movl $TEST_CODE_DPL3_STACK_SELECTOR, %eax
    movw %ax, %ss
    movl $TEST_CODE_DPL3_STACK_INIT_ESP, %esp
    movl $TEST_CODE_DPL3_VIDEO_SELECTOR, %eax
    movw %ax, %es
    movl $NULL_SELECTOR, %eax
    movw %ax, %fs
    movw %ax, %gs

    movl $_nonconforming_code_dpl3_msg, %esi
    movl $_nonconforming_code_dpl3_msg_len, %ecx
    movl $TEST_CODE_VIDEO_OFFSET, %edx
    call _code_echo

    jmp .

.space 0x80-(.-_start), 0x00

###############################################################
# conforming code DPL == 0
_conforming_code_dpl0:
    xorl %eax, %eax
    movl $TEST_CODE_DPL0_DATA_SELECTOR, %eax
    movw %ax, %ds
    movl $TEST_CODE_DPL0_STACK_SELECTOR, %eax
    movw %ax, %ss
    movl $TEST_CODE_DPL0_STACK_INIT_ESP, %esp
    movl $TEST_CODE_DPL0_VIDEO_SELECTOR, %eax
    movw %ax, %es
    movl $NULL_SELECTOR, %eax
    movw %ax, %fs
    movw %ax, %gs

    movl $_conforming_code_dpl0_msg, %esi
    movl $_conforming_code_dpl0_msg_len, %ecx
    movl $TEST_CODE_VIDEO_OFFSET, %edx
    call _code_echo

    jmp .

.space 0xc0-(.-_start), 0x00

###############################################################
# conforming code DPL == 3
_conforming_code_dpl3:
    xorl %eax, %eax
    movl $TEST_CODE_DPL3_DATA_SELECTOR, %eax
    movw %ax, %ds
    movl $TEST_CODE_DPL3_STACK_SELECTOR, %eax
    movw %ax, %ss
    movl $TEST_CODE_DPL3_STACK_INIT_ESP, %esp
    movl $TEST_CODE_DPL3_VIDEO_SELECTOR, %eax
    movw %ax, %es
    movl $NULL_SELECTOR, %eax
    movw %ax, %fs
    movw %ax, %gs

    movl $_conforming_code_dpl3_msg, %esi
    movl $_conforming_code_dpl3_msg_len, %ecx
    movl $TEST_CODE_VIDEO_OFFSET, %edx
    call _code_echo

    jmp .

.space 0x0100-(.-_start), 0x00

###############################################################
# conforming code DPL == 0, CPL == 3
_conforming_code_dpl0_cpl3:
    xorl %eax, %eax
    movl $TEST_CODE_DPL3_DATA_SELECTOR, %eax
    movw %ax, %ds
    movl $TEST_CODE_DPL3_STACK_SELECTOR, %eax
    movw %ax, %ss
    movl $TEST_CODE_DPL3_STACK_INIT_ESP, %esp
    movl $TEST_CODE_DPL3_VIDEO_SELECTOR, %eax
    movw %ax, %es
    movl $NULL_SELECTOR, %eax
    movw %ax, %fs
    movw %ax, %gs

    movl $_conforming_code_dpl0_cpl3_msg, %esi
    movl $_conforming_code_dpl0_cpl3_msg_len, %ecx
    movl $TEST_CODE_VIDEO_OFFSET, %edx
    call _code_echo

    jmp .

###############################################################
# code echo function
# %edi, %ax, %ecx, %esi
.type _code_echo, @function
_code_echo:
    xorl %ebx, %ebx
    leal (%edx, %ebx), %edi
    shll %edi
    movb $0x0c, %ah
_code_start_echo:
    movb %ds:(%esi), %al
    movw %ax, %es:(%edi)

    inc %ebx
    leal (%edx, %ebx), %edi
    shll %edi
    inc %esi
    loop _code_start_echo 

    ret


###############################################################
# message data
_nonconforming_code_dpl0_msg:
    .ascii "In nonconforming code segment, DPL == 0."
_nonconforming_code_dpl0_msg_end:
    .equ _nonconforming_code_dpl0_msg_len, _nonconforming_code_dpl0_msg_end - _nonconforming_code_dpl0_msg
_nonconforming_code_dpl3_msg:
    .ascii "In nonconforming code segment, DPL == 3."
_nonconforming_code_dpl3_msg_end:
    .equ _nonconforming_code_dpl3_msg_len, _nonconforming_code_dpl3_msg_end - _nonconforming_code_dpl3_msg
_conforming_code_dpl0_msg:
    .ascii "In conforming code segment, DPL == 0."
_conforming_code_dpl0_msg_end:
    .equ _conforming_code_dpl0_msg_len, _conforming_code_dpl0_msg_end - _conforming_code_dpl0_msg
_conforming_code_dpl3_msg:
    .ascii "In conforming code segment, DPL == 3."
_conforming_code_dpl3_msg_end:
    .equ _conforming_code_dpl3_msg_len, _conforming_code_dpl3_msg_end - _conforming_code_dpl3_msg
_conforming_code_dpl0_cpl3_msg:
    .ascii "In conforming code segment, DPL == 0, CPL==3."
_conforming_code_dpl0_cpl3_msg_end:
    .equ _conforming_code_dpl0_cpl3_msg_len, _conforming_code_dpl0_cpl3_msg_end - _conforming_code_dpl0_cpl3_msg


dummy1:
    .space 0x400-(.-_start), 0x00

