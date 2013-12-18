#
# library 32 function import table
#

.equ LIB32_PUTS,                0
.equ LIB32_PRINT_INT_VALUE,     1
.equ LIB32_PRINTLN,             2
.equ LIB32_GET_MAXPHYADD,       3
.equ LIB32_PRINT_INT_DECIMAL,   4
.equ LIB32_PRINT_QWORD_VALUE,   5
.equ LIB32_PRINT_BLANK,         6
.equ LIB32_REVERSE,             7
.equ LIB32_DUMP_FLAGS,          8

puts:               jmp LIB32_SEG + LIB32_PUTS * 5
print_int_value:    jmp LIB32_SEG + LIB32_PRINT_INT_VALUE * 5
println:            jmp LIB32_SEG + LIB32_PRINTLN * 5
get_maxphyadd:      jmp LIB32_SEG + LIB32_GET_MAXPHYADD * 5
print_int_decimal:  jmp LIB32_SEG + LIB32_PRINT_INT_DECIMAL * 5
print_qword_value:  jmp LIB32_SEG + LIB32_PRINT_QWORD_VALUE * 5
printblank:         jmp LIB32_SEG + LIB32_PRINT_BLANK * 5
reverse:            jmp LIB32_SEG + LIB32_REVERSE * 5
dump_flags:         jmp LIB32_SEG + LIB32_DUMP_FLAGS * 5

