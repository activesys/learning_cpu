#!/bin/sh

# build granularity_limit_checking
as -o granularity_limit_checking.o granularity_limit_checking.s
ld -Ttext 0x7c00 -o granularity_limit_checking granularity_limit_checking.o
objcopy -O binary granularity_limit_checking granularity_limit_checking.bin
dd if=granularity_limit_checking.bin of=granularity_limit_checking.img count=1
chmod -x granularity_limit_checking.img
rm -f granularity_limit_checking granularity_limit_checking.o granularity_limit_checking.bin

exit 0

