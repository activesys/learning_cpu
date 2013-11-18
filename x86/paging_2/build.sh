#!/bin/sh

#
# 0        1        5        9         17      
# +--------+--------+--------+---------+--------+--------+--------+
# | boot   | setup  | lib16  |protected| lib32  |                 |
# +--------+--------+--------+---------+--------+--------+--------+
#     1         4       4        8        4
#

# build boot
as -o boot.o boot.s
ld -Ttext 0x7c00 -o boot boot.o
objcopy -O binary boot boot.bin
dd if=boot.bin of=boot.img count=1
chmod -x boot.img
rm -f boot boot.o boot.bin

# build setup
as -o setup.o setup.s
ld -Ttext 0x8000 -o setup setup.o
objcopy -O binary setup setup.bin
dd if=setup.bin of=boot.img count=4 seek=1
rm -f setup setup.o setup.bin

# build lib16
as -o lib16.o lib16.s
ld -Ttext 0x8800 -o lib16 lib16.o
objcopy -O binary lib16 lib16.bin
dd if=lib16.bin of=boot.img count=4 seek=5
rm -f lib16 lib16.o lib16.bin

# build protected
as -o protected.o protected.s
ld -Ttext 0x9000 -o protected protected.o
objcopy -O binary protected protected.bin
dd if=protected.bin of=boot.img count=8 seek=9
rm -f protected protected.o protected.bin

# build lib32
as -o lib32.o lib32.s
ld -Ttext 0xa000 -o lib32 lib32.o
objcopy -O binary lib32 lib32.bin
dd if=lib32.bin of=boot.img count=4 seek=17
rm -f lib32 lib32.o lib32.bin

exit 0

