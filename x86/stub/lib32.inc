#
# library 32 function import table
#

.equ LIB32_PUTS,            0
.equ LIB32_PRINT_INT_VALUE, 1
.equ LIB32_PRINTLN,         2

puts:               jmp LIB32_SEG + LIB32_PUTS * 5
print_int_value:    jmp LIB32_SEG + LIB32_PRINT_INT_VALUE * 5
println:            jmp LIB32_SEG + LIB32_PRINTLN * 5

