#!/bin/sh

# build load_segment_register
as -o load_segment_register.o load_segment_register.s
ld -Ttext 0x7c00 -o load_segment_register load_segment_register.o
objcopy -O binary load_segment_register load_segment_register.bin
dd if=load_segment_register.bin of=load_segment_register.img count=1
chmod -x load_segment_register.img
rm -f load_segment_register load_segment_register.o load_segment_register.bin

exit 0

