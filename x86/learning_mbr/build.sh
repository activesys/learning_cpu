#!/bin/sh

# build boot
as -o boot.o boot.s
ld -Ttext 0x7c00 -o boot boot.o
objcopy -O binary boot boot.bin
dd if=boot.bin of=boot.img count=1
rm -f boot.o boot.bin boot

exit 0

