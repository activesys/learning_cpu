#!/bin/sh

# build gdt_limit_checking
as -o gdt_limit_checking.o gdt_limit_checking.s
ld -Ttext 0x7c00 -o gdt_limit_checking gdt_limit_checking.o
objcopy -O binary gdt_limit_checking gdt_limit_checking.bin
dd if=gdt_limit_checking.bin of=gdt_limit_checking.img count=1
chmod -x gdt_limit_checking.img
rm -f gdt_limit_checking gdt_limit_checking.o gdt_limit_checking.bin

exit 0

