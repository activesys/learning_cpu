#
# Boot and read interrupt, setup, kernel user code and data.
#

.include "common.inc"

.code16
.section .text
.globl _start
_start:
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw $BOOT_SEG, %sp
    call get_driver_parameter
    call clear_screen

    jmp .

################################
# LBA to CHS
# LBA = C * (header_maximun * sector_maximun) + H * sector_maximun + S - 1
#
.type lba_to_chs, @function
lba_to_chs:
    movzx sector_maximun, %ecx
    movzx header_maximun, %eax
    imul %eax, %ecx
    movl start_sector, %eax
    movl start_sector(,4), %edx
    divl %ecx
    movl %eax, %ebx
    movl %edx, %eax
    xorl %edx, %edx
    movzx sector_maximun, %ecx
    divl %ecx
    incl %edx
    movb %dl, %cl
    movb %bl, %ch
    shrw $0x02, %bx
    andw $0xc0, %bx
    orb %bl, %cl
    movb %al, %dh
    ret

################################
# read sector with extension
#
.type read_sector_with_extension, @function
read_sector_with_extension:
    movw $disk_address_packet, %si
    movb driver_number, %dl
    movb $0x42, %ah
    int $0x13
    movzx %ah, %ax
    ret

################################
# check int0x13 extension
#
.type check_int0x13_extension, @function
check_int0x13_extension:
    pushw %bx
    movw $0x55aa, %bx
    movb driver_number, %dl
    movb $0x41, %ah
    int $0x13
    setnc %al
    jnc _check_int0x13_extension_done
    cmpw $0x55aa, %bx
    setz %al
    jnz _check_int0x13_extension_done
    test $0x01, %cx
    setnz %al
_check_int0x13_extension_done:
    popw %bx
    movzx %al, %ax
    ret

################################
# clear screen
#
.type clear_screen, @function
clear_screen:
    pusha
    movw $0x0600, %ax
    xorw %cx, %cx
    xorb $0x0f, %bh
    movb $24, %dh
    movb $79, %dl
    int $0x10

    movb $0x02, %ah
    movb $0x00, %bh
    xorw %dx, %dx
    int $0x10
    popa
    ret

################################
# get driver parameter
#
.type get_driver_parameter, @function
get_driver_parameter:
    pushw %cx
    pushw %dx
    pushw %bx

    movb $0x08, %ah
    movb driver_number, %dl
    movw parameter_table, %di
    int $0x13
    jc _get_driver_parameter_done

    movb %bl, driver_type
    inc %dh
    movb %dh, header_maximun
    movb %cl, sector_maximun
    andb $0x3f, sector_maximun
    shrb $0x06, %cl
    rolw $0x08, %cx
    andw $0x03ff, %cx
    movw %cx, cylinder_maximun

_get_driver_parameter_done:
    movzx %ah, %ax
    popw %bx
    popw %dx
    popw %cx
    ret

################################
# disk address packet
#
disk_address_packet:
    size:               .int    0x10
    read_sectors:       .int    0
    buffer_offset:      .int    0
    buffer_selector:    .int    0
    start_sector:       .quad   0
################################
# driver parameter table
#
driver_parameters_table:
    driver_type:        .byte   0
    driver_number:      .byte   0
    cylinder_maximun:   .int    0
    header_maximun:     .int    0
    sector_maximun:     .int    0
    parameter_table:    .int    0

dummy:
    .space 510-(.-_start), 0
magic_number:
    .byte 0x55, 0xaa

