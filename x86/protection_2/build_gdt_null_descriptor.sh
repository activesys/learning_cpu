#!/bin/sh

# build gdt_null_descriptor
as -o gdt_null_descriptor.o gdt_null_descriptor.s
ld -Ttext 0x7c00 -o gdt_null_descriptor gdt_null_descriptor.o
objcopy -O binary gdt_null_descriptor gdt_null_descriptor.bin
dd if=gdt_null_descriptor.bin of=gdt_null_descriptor.img count=1
chmod -x gdt_null_descriptor.img
rm -f gdt_null_descriptor gdt_null_descriptor.o gdt_null_descriptor.bin

exit 0

