#!/bin/sh

# build boot
as -o boot.o boot.s
ld -Ttext 0x7c00 -o boot boot.o
objcopy -O binary boot boot.bin
dd if=boot.bin of=boot.img count=1
chmod -x boot.img
rm -f boot boot.o boot.bin

as -o int.o int.s
ld -Ttext 0x800 -o int -e _int0x80 int.o
objcopy -O binary int int.bin
dd if=int.bin of=boot.img count=1 seek=1
rm -f int.o int int.bin

exit 0

