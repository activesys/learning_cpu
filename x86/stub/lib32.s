#
# library 32
#
.include "common.inc"

.code32
.section .text
.globl _start
_start:

# jump table
puts:               jmp __puts
print_int_value:    jmp __print_int_value
println:            jmp __println 

# function implements

###############################################################
# __get_current_row()
# result: %eax
__get_current_row:
    pushl %ebx
    movl video_current, %eax
    subl $0x0b8000, %eax
    movb $160, %bl
    divb %bl
    movzx %al, %eax
    popl %ebx
    ret

###############################################################
# __get_current_column()
# result: %eax
__get_current_column:
    pushl %ebx
    movl video_current, %eax
    subl $0x0b8000, %eax
    movb $160, %bl
    divb %bl
    movzx %ah, %eax
    popl %ebx
    ret

###############################################################
# __write_char(char c);
# input: %esi
__write_char:
    pushl %ebx
    movl $video_current, %ebx
    orw $0x0f00, %si
    cmpw $0x0f0a, %si
    jnz do_write_char
    call __get_current_column
    negl %eax
    addl $160, %eax
    addl %eax, (%ebx)
    jmp do_write_char_done

do_write_char:
    movl (%ebx), %eax
    cmpl $0x0b9ff0, %eax
    ja do_write_char_done
    movw %si, (%eax)
    addl $2, %eax
do_write_char_done:
    movl %eax, (%ebx)
    popl %ebx
    ret

###############################################################
# __putc(char c);
# input: %esi
__putc:
    andl $0x00ff, %esi
    call __write_char
    ret

###############################################################
# __println
__println:
    movw $0x0a, %si
    call __putc
    ret

###############################################################
# __printblank
__printblank:
    movw $0x20, %si
    call __putc
    ret

###############################################################
# __puts
# input: %esi: message
__puts:
    pushl %ebx
    movl %esi, %ebx
    testl %ebx, %ebx
    jz do_puts_done
do_puts_loop:
    movb (%ebx), %al
    testb %al, %al
    jz do_puts_done
    movl %eax, %esi
    call __putc
    incl %ebx
    jmp do_puts_loop
do_puts_done:
    popl %ebx
    ret

###############################################################
# __hex_to_char
# input:  esi: hex number
# output: eax: char
__hex_to_char:
    jmp do_hex_to_char
char_str:   .ascii "0123456789ABCDEF"
do_hex_to_char:
    pushl %esi
    andl $0x0f, %esi
    movzx char_str(%esi), %eax
    popl %esi
    ret

###############################################################
# __print_byte_value
# __print_short_value
# __print_int_value
__print_byte_value:
    pushl %ebx
    pushl %esi
    movl %esi, %ebx
    shrl $4, %esi
    call __hex_to_char
    movl %eax, %esi
    call __putc
    movl %ebx, %esi
    call __hex_to_char
    movl %eax, %esi
    call __putc
    popl %esi
    popl %ebx
    ret

__print_short_value:
    pushl %ebx
    pushl %esi
    movl %esi, %ebx
    shrl $8, %esi
    call __print_byte_value
    movl %ebx, %esi
    call __print_byte_value
    popl %esi
    popl %ebx
    ret

__print_int_value:
    pushl %ebx
    pushl %esi
    movl %esi, %ebx
    shrl $16, %esi
    call __print_short_value
    movl %ebx, %esi
    call __print_short_value
    popl %esi
    popl %ebx
    ret


###############################################################
# video_current
video_current:  .int    0x0b8000
    
###############################################################
dummy:
    .space 0x800-(.-_start), 0x00

