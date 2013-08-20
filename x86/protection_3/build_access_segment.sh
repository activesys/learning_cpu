#!/bin/sh

# build access_segment
as -o access_segment.o access_segment.s
ld -Ttext 0x7c00 -o access_segment access_segment.o
objcopy -O binary access_segment access_segment.bin
dd if=access_segment.bin of=access_segment.img count=1
chmod -x access_segment.img
rm -f access_segment access_segment.o access_segment.bin

exit 0

