#!/bin/sh

# build boot
as -o boot.o boot.s
ld -Ttext 0x7c00 -o boot boot.o
objcopy -O binary boot boot.bin
dd if=boot.bin of=boot.img count=1
chmod -x boot.img
rm -f boot boot.o boot.bin

# build setup
as -o setup.o setup.s
ld -Ttext 0x4100 -o setup setup.o
objcopy -O binary setup setup.bin
dd if=setup.bin of=boot.img count=2 seek=1
rm -f setup setup.o setup.bin

# build kernel
as -o kernel.o kernel.s
ld -Ttext 0x2000 -o kernel kernel.o
objcopy -O binary kernel kernel.bin
dd if=kernel.bin of=boot.img count=1 seek=3
rm -f kernel kernel.o kernel.bin

# build user
as -o user.o user.s
ld -Ttext 0x5000 -o user user.o
objcopy -O binary user user.bin
dd if=user.bin of=boot.img count=1 seek=4
rm -f user user.o user.bin

exit 0

