#
# code and data for kernel
#
.include "common.inc"

###############################################################
# code for kernel
.code32
.globl _start
_start:
    movl $KERNEL_MSG_OFFSET, %edi
    movl $KERNEL_MSG_LENGTH, %ecx
    call _kernel_echo

    # jmp to user code.
    lcall $USER_TSS_SELECTOR, $0x00

# %edi, %ax, %ecx, %esi
.type _kernel_echo, @function
_kernel_echo:
    movl $400, %edx
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
    .ascii "In kernel code, CPL == 0\n"

dummy1:
    .space 0x200-(.-_start), 0x00

