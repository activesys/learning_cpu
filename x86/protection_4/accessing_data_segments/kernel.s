#
# code and data for kernel
#
.include "common.inc"

###############################################################
# code for kernel
.code32
.globl _start
_start:
    movl $KERNEL_STACK_INIT_ESP, %esp

    movl $KERNEL_MSG_OFFSET, %esi
    movl $KERNEL_MSG_LENGTH, %ecx
    movl $KERNEL_FIRST_VIDEO_OFFSET, %edx
    call _kernel_echo

    pushw %ds

    # load test data DPL == 0
    movl $TEST_DATA_DPL0_SELECTOR_RPL0, %eax
    movw %ax, %ds
    movl $TEST_DATA_CPL0_DPL0_MSG_OFFSET, %esi
    movl $TEST_DATA_CPL0_DPL0_MSG_LENGTH, %ecx
    movl $CPL0_DPL0_VIDEO_OFFSET, %edx
    call _kernel_echo

    # jmp to user code.
    lcall $USER_TSS_SELECTOR, $0x00

    popw %ds

    movl $KERNEL_MSG2_OFFSET, %esi
    movl $KERNEL_MSG2_LENGTH, %ecx
    movl $KERNEL_SECOND_VIDEO_OFFSET, %edx
    call _kernel_echo

    # load test data DPL == 3
    movl $TEST_DATA_DPL3_SELECTOR_RPL3, %eax
    movw %ax, %ds
    movl $TEST_DATA_CPL0_DPL3_MSG_OFFSET, %esi
    movl $TEST_DATA_CPL0_DPL3_MSG_LENGTH, %ecx
    movl $CPL0_DPL3_VIDEO_OFFSET, %edx
    call _kernel_echo

    #movl $TEST_DATA_DPL0_SELECTOR_RPL3, %eax
    #movw %ax, %ds

    #movl $KERNEL_STACK_SELECTOR_RPL3, %eax
    #movw %ax, %ss

    jmp .

# %edi, %ax, %ecx, %esi
.type _kernel_echo, @function
_kernel_echo:
    xorl %ebx, %ebx
    leal (%edx, %ebx), %edi
    shll %edi
    movb $0x0c, %ah
_kernel_start_echo:
    movb %ds:(%esi), %al
    movw %ax, %es:(%edi)

    inc %ebx
    leal (%edx, %ebx), %edi
    shll %edi
    inc %esi
    loop _kernel_start_echo 

    ret

dummy:
    .space 0x100-(.-_start), 0x00

###############################################################
# data for kernel
_kernel_msg:
    .ascii "In kernel code, CPL == 0."
_kernel_msg2:
    .ascii "Welcome back to the kernel code, CPL == 0."

dummy1:
    .space 0x200-(.-_start), 0x00

