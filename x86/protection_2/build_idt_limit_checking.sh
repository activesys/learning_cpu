#!/bin/sh

# build idt_limit_checking
as -o idt_limit_checking.o idt_limit_checking.s
ld -Ttext 0x7c00 -o idt_limit_checking idt_limit_checking.o
objcopy -O binary idt_limit_checking idt_limit_checking.bin
dd if=idt_limit_checking.bin of=idt_limit_checking.img count=1
chmod -x idt_limit_checking.img
rm -f idt_limit_checking idt_limit_checking.o idt_limit_checking.bin

exit 0

