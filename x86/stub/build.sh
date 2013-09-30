#!/bin/sh

#
# 0        1        5        9         13      
# +--------+--------+--------+---------+--------+--------+--------+
# | boot   | setup  | lib16  |protected| lib32  |                 |
# +--------+--------+--------+---------+--------+--------+--------+
#     1         4       4        4       32
#

# build boot
as -o boot.o boot.s
ld -Ttext 0x7c00 -o boot boot.o
objcopy -O binary boot boot.bin
dd if=boot.bin of=boot.img count=1
chmod -x boot.img
rm -f boot boot.o boot.bin

# build setup
#as -o setup.o setup.s
#ld -Ttext 0x6000 -o setup setup.o
#objcopy -O binary setup setup.bin
#dd if=setup.bin of=boot.img count=3 seek=1
#rm -f setup setup.o setup.bin

# build int
#as -o int.o int.s
#ld -Ttext 0x3000 -o int int.o
#objcopy -O binary int int.bin
#dd if=int.bin of=boot.img count=1 seek=4
#rm -f int int.o int.bin

# build kernel
#as -o kernel.o kernel.s
#ld -Ttext 0x8000 -o kernel kernel.o
#objcopy -O binary kernel kernel.bin
#dd if=kernel.bin of=boot.img count=1 seek=5
#rm -f kernel kernel.o kernel.bin

# build user
#as -o user.o user.s
#ld -Ttext 0xa000 -o user user.o
#objcopy -O binary user user.bin
#dd if=user.bin of=boot.img count=1 seek=6
#rm -f user user.o user.bin

exit 0

