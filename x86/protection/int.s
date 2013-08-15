.include "common.inc"

.code32
.section .text
.globl _int
_int:

.type _int0x80, @function
_int0x80:

    iret

dummy1:
    .space 0x20-(.-_int), 0x00

.type _int0x90, @function
_int0x90:

    iret

dummy2:
    .space 0x40-(.-_int), 0x00

# %esi, %edi
.type _int0xff, @function
_int0xff:
    # save %esp
    movl %esp, %ebx

    # init int stack environment.
    xorl %eax, %eax
    movw $INT_STACK_SELECTOR, %ax
    movw %ax, %ss
    movl $INT_STACK_INIT_ESP, %esp
    movl %ebx, 8(%esp)

    # get line no from int stack
    movl 4(%esp), %eax

    # calcolate position
    movl $80, %ebx
    mull %ebx
    movl %eax, %ebx
    xorl %eax, %eax

    movb $0x0c, %ah
_start_echo:
    movb %ds:(%esi), %al
    movw %ax, %es:(%edi)

    inc %ebx
    movl %ebx, %edi
    shll %edi
    inc %esi
    loop _start_echo 

    # save new line
    movl 4(%esp), %ebx
    inc %ebx
    movl %ebx, 4(%esp)

    # retrieve stack
    movl 8(%esp), %ebx
    xorl %eax, %eax
    movw $STACK_SELECTOR, %ax
    movw %ax, %ss
    movl %ebx, %esp

    iret

dummy3:
    .space 0x100-(.-_int), 0x00

.type _gp_handler, @function
_gp_handler:

    iret

.globl _int_end
_int_end:

