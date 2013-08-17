.type _echo, @function
_echo:
    movb $0x0e, %ah
_do_echo:
    lodsb
    int $0x10
    loop _do_echo

    movb $0x0e, %ah
    movb $0x0d, %al
    int $0x10
    movb $0x0a, %al
    int $0x10
    ret
