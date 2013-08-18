#!/bin/sh

# build expand_down_limit_checking
as -o expand_down_limit_checking.o expand_down_limit_checking.s
ld -Ttext 0x7c00 -o expand_down_limit_checking expand_down_limit_checking.o
objcopy -O binary expand_down_limit_checking expand_down_limit_checking.bin
dd if=expand_down_limit_checking.bin of=expand_down_limit_checking.img count=1
chmod -x expand_down_limit_checking.img
rm -f expand_down_limit_checking expand_down_limit_checking.o expand_down_limit_checking.bin

exit 0

