#!/bin/sh

# build instruction_operand
as -o instruction_operand.o instruction_operand.s
ld -Ttext 0x7c00 -o instruction_operand instruction_operand.o
objcopy -O binary instruction_operand instruction_operand.bin
dd if=instruction_operand.bin of=instruction_operand.img count=1
chmod -x instruction_operand.img
rm -f instruction_operand instruction_operand.o instruction_operand.bin

exit 0

