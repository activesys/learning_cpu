#
# 8259.s
#

###############################################################
# write EOI
write_master_EOI:
    movb $0b00100000, %al
    out %al, $MASTER_OCW2_PORT
    ret

write_slave_EOI:
    movb $0b00100000, %al
    out %al, $SLAVE_OCW2_PORT
    ret

###############################################################
# read isr
read_master_isr:
    movb $0b00001011, %al
    out %al, $MASTER_OCW3_PORT
    in $MASTER_OCW3_PORT, %al
    ret

read_slave_isr:
    movb $0b00001011, %al
    out %al, $SLAVE_OCW3_PORT
    in $SLAVE_OCW3_PORT, %al
    ret

###############################################################
# read irr
read_master_irr:
    movb $0b00001010, %al
    out %al, $MASTER_OCW3_PORT
    in $MASTER_OCW3_PORT, %al
    ret

read_slave_irr:
    movb $0b00001010, %al
    out %al, $SLAVE_OCW3_PORT
    in $SLAVE_OCW3_PORT, %al
    ret

###############################################################
# read imr
read_master_imr:
    in $MASTER_OCW1_PORT, %al
    ret

read_slave_imr:
    in $SLAVE_OCW1_PORT, %al
    ret

###############################################################
# init 8259a
init_8259a:
    ## master 8259a
    # write ICW1
    movb $0x11, %al
    out %al, $MASTER_ICW1_PORT
    # write ICW2
    movb $0x20, %al
    out %al, $MASTER_ICW2_PORT
    # write ICW3
    movb $0x04, %al
    out %al, $MASTER_ICW3_PORT
    # write ICW4
    movb $0x01, %al
    out %al, $MASTER_ICW4_PORT
    ## slave 8259a
    # write ICW1
    movb $0x11, %al
    out %al, $SLAVE_ICW1_PORT
    # write ICW2
    movb $0x28, %al
    out %al, $SLAVE_ICW2_PORT
    # write ICW3
    movb $0x02, %al
    out %al, $SLAVE_ICW3_PORT
    # write ICW4
    movb $0x01, %al
    out %al, $SLAVE_ICW4_PORT
    ret

###############################################################
# mask timer
disable_timer:
    in $MASTER_MASK_PORT, %al
    orb $0x01, %al
    out %al, $MASTER_MASK_PORT
    ret

enable_timer:
    in $MASTER_MASK_PORT, %al
    andb $0xfe, %al
    out %al, $MASTER_MASK_PORT
    ret

###############################################################
# mask keyboard
disable_keyboard:
    in $MASTER_MASK_PORT, %al
    orb $0x02, %al
    out %al, $MASTER_MASK_PORT
    ret

enable_keyboard:
    in $MASTER_MASK_PORT, %al
    andb $0xfd, %al
    out %al, $MASTER_MASK_PORT
    ret

###############################################################
# dump_8259 isr, irr, imr
dump_8259_isr:
    movl $isr_msg, %esi
    call puts
    call read_master_isr
    movzx %al, %esi
    shll $24, %esi
    call reverse
    movl %eax, %esi
    movl $isr_flags, %edi
    call dump_flags
    call println
    movl $isr_msg1, %esi
    call puts
    call read_slave_isr
    movzx %al, %esi
    shll $24, %esi
    call reverse
    movl %eax, %esi
    movl $isr_flags1, %edi
    call dump_flags
    call println
    ret

dump_8259_irr:
    movl $irr_msg, %esi
    call puts
    call read_master_irr
    movzx %al, %esi
    shll $24, %esi
    call reverse
    movl %eax, %esi
    movl $irr_flags, %edi
    call dump_flags
    call println
    movl $irr_msg1, %esi
    call puts
    call read_slave_irr
    movzx %al, %esi
    shll $24, %esi
    call reverse
    movl %eax, %esi
    movl $irr_flags1, %edi
    call dump_flags
    call println
    ret

dump_8259_imr:
    movl $imr_msg, %esi
    call puts
    call read_master_imr
    movzx %al, %esi
    shll $24, %esi
    call reverse
    movl %eax, %esi
    movl $imr_flags, %edi
    call dump_flags
    call println
    movl $imr_msg1, %esi
    call puts
    call read_slave_imr
    movzx %al, %esi
    shll $24, %esi
    call reverse
    movl %eax, %esi
    movl $imr_flags1, %edi
    call dump_flags
    call println
    ret

isr_msg:    .asciz  "<ISR>: "
irr_msg:    .asciz  "<IRR>: "
imr_msg:    .asciz  "<IMR>: "
isr_msg1:
irr_msg1:
imr_msg1:   .asciz  "       "

irq0:       .asciz  "irq0 "
irq1:       .asciz  "irq1 "
irq3:       .asciz  "irq3 "
irq4:       .asciz  "irq4 "
irq5:       .asciz  "irq5 "
irq6:       .asciz  "irq6 "
irq7:       .asciz  "irq7 "
irq2:       .asciz  "irq2 "
irq8:       .asciz  "irq8 "
irq9:       .asciz  "irq9 "
irq10:      .asciz  "irq10 "
irq11:      .asciz  "irq11 "
irq12:      .asciz  "irq12 "
irq13:      .asciz  "irq13 "
irq14:      .asciz  "irq14 "
irq15:      .asciz  "irq15 "

imr_flags:
irr_flags:
isr_flags:  .int    irq7, irq6, irq5, irq4, irq3, irq2, irq1, irq0, -1

imr_flags1:
irr_flags1:
isr_flags1: .int    irq15, irq14, irq13, irq12, irq11, irq10, irq9, irq8, -1

