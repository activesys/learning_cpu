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
as -o int.o int.s
as -o main.o main.s
as -o data.o data.s
ld -Ttext 0x6000 -o setup setup.o int.o main.o data.o
objcopy -O binary setup setup.bin
dd if=setup.bin of=boot.img count=4 seek=1
rm -f setup.o main.o int.o data.o setup setup.bin

# build interrupt and exception handler
#as -o int.o int.s
#ld -Ttext 0x1000 -o int -e _int0x80 int.o
#objcopy -O binary int int.bin
#dd if=int.bin of=boot.img count=1 seek=5
#rm -f int.o int int.bin

# build main
#as -o main.o main.s
#ld -Ttext 0x2000 -o main main.o
#objcopy -O binary main main.bin
#dd if=main.bin of=boot.img count=1 seek=6
#rm -f main.o main main.bin

# build fun
#as -o fun.o fun.s
#ld -Ttext 0x2600 -o fun fun.o
#objcopy -O binary fun fun.bin
#dd if=fun.bin of=boot.img count=1 seek=7
#rm -f fun.o fun fun.bin

# build data
#as -o data.o data.s
#ld -Ttext 0x3000 -o data -e main_msg data.o
#objcopy -O binary data data.bin
#dd if=data.bin of=boot.img count=1 seek=8
#rm -f data.o data data.bin

exit 0

