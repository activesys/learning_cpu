#
# Common data and struct
#
# sector layout
/*
0        1        5        9         13      
+--------+--------+--------+---------+--------+--------+--------+
| boot   | setup  | lib16  |protected| lib32  |                 |
+--------+--------+--------+---------+--------+--------+--------+
    1         4       4        4        4
*/
.equ BOOT_SECTOR,               0
.equ SETUP_SECTOR,              1
.equ LIB16_SECTOR,              5
.equ PROTECTED_SECTOR,          9
.equ LIB32_SECTOR,              13

.equ BOOT_SECTOR_COUNT,         1
.equ SETUP_SECTOR_COUNT,        4
.equ LIB16_SECTOR_COUNT,        4
.equ PROTECTED_SECTOR_COUNT,    4
.equ LIB32_SECTOR_COUNT,        4

# memory layout
/*
|                |
|                |
+----------------+ 0xa000 lib32
|                |
+----------------+ 0x9000 protected
|                |
+----------------+ 0x8800 lib16
|                |
+----------------+ 0x8000 setup
|                |
+----------------+ 0x7c00 boot
|                |
*/

################################################################
# content address.
.equ BOOT_SEG,      0x7c00
.equ SETUP_SEG,     0x8000
.equ LIB16_SEG,     0x8a00
.equ PROTECTED_SEG, 0x9000
.equ LIB32_SEG,     0xa000

################################################################
# GDT selector
.equ NULL_SELECTOR,                 0x00
.equ CODE16_SELECTOR,               0x08
.equ DATA16_SELECTOR,               0x10
.equ KERNEL_CODE32_SELECTOR,        0x18
.equ KERNEL_DATA32_SELECTOR,        0x20
.equ USER_CODE32_SELECTOR,          0x28
.equ USER_DATA32_SELECTOR,          0x30
.equ TSS32_SELECTOR,                0x38
.equ CALL_GATE_SELECTOR,            0x40
.equ COMFORMING_CODE32_SELECTOR,    0x48
.equ TSS_TEST_SELECTOR,             0x50
.equ TASK_GATE_SELECTOR,            0x58
.equ LDT_SELECTOR,                  0x60

################################################################
# interrupt vector
.equ DE_HANDLER_VECTOR,         0
.equ DB_HANDLER_VECTOR,         1
.equ NMI_HANDLER_VECTOR,        2
.equ BP_HANDLER_VECTOR,         3
.equ OF_HANDLER_VECTOR,         4
.equ BR_HANDLER_VECTOR,         5
.equ UD_HANDLER_VECTOR,         6
.equ NM_HANDLER_VECTOR,         7
.equ DF_HANDLER_VECTOR,         8
.equ TS_HANDLER_VECTOR,         10
.equ NP_HANDLER_VECTOR,         11
.equ SS_HANDLER_VECTOR,         12
.equ GP_HANDLER_VECTOR,         13
.equ PF_HANDLER_VECTOR,         14
.equ MF_HANDLER_VECTOR,         16
.equ AC_HANDLER_VECTOR,         17
.equ MC_HANDLER_VECTOR,         18
.equ XM_HANDLER_VECTOR,         19
.equ SX_HANDLER_VECTOR,         31

################################################################
# paging
.equ PDT32_BASE,                0x100000
.equ PTT32_BASE,                0x201000
.equ PDPT_BASE,                 0x100000

.equ PAE_BIT,                   5

.equ IA32_EFER,                 0xc0000080

