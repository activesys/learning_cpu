#
# Common data and struct
#
# sector layout
/*
0        1        5        9         13      
+--------+--------+--------+---------+--------+--------+--------+
| boot   | setup  | lib16  |protected| lib32  |                 |
+--------+--------+--------+---------+--------+--------+--------+
    1         4       4        4       32
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
.equ LIB32_SECTOR_COUNT,        32

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
# LDT layout
/*
|                |
+----------------+
|video descriptor|
+----------------+
|stack descriptor|
+----------------+
|data  descriptor|
+----------------+
|code  descriptor|
+----------------+
*/
# kernel LDT
# kernel code
# attr = 0x4098(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1000)
.equ KERNEL_CODE_BASE,          0x8000
.equ KERNEL_CODE_LIMIT,         0xffff
.equ KERNEL_CODE_ATTR,          0x4098
.equ KERNEL_CODE_SELECTOR,      0x04

# kernel data
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ KERNEL_DATA_BASE,          0x8100
.equ KERNEL_DATA_LIMIT,         0xffff
.equ KERNEL_DATA_ATTR,          0x4092
.equ KERNEL_DATA_SELECTOR,      0x0c

# kernel stack
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ KERNEL_STACK_BASE,         0x8200
.equ KERNEL_STACK_LIMIT,        0xffff
.equ KERNEL_STACK_ATTR,         0x4092
.equ KERNEL_STACK_SELECTOR,     0x14
.equ KERNEL_STACK_INIT_ESP,     0x9000

# video data segment
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ KERNEL_VIDEO_BASE,         0x0b8000
.equ KERNEL_VIDEO_LIMIT,        0xffff
.equ KERNEL_VIDEO_ATTR,         0x4092
.equ KERNEL_VIDEO_SELECTOR,     0x1c

# user LDT
# user code
# attr = 0x4098(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=1000)
.equ USER_CODE_BASE,            0xa000
.equ USER_CODE_LIMIT,           0xffff
.equ USER_CODE_ATTR,            0x40f8
.equ USER_CODE_SELECTOR,        0x07

# user data
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=0010)
.equ USER_DATA_BASE,            0xa100
.equ USER_DATA_LIMIT,           0xffff
.equ USER_DATA_ATTR,            0x40f2
.equ USER_DATA_SELECTOR,        0x0f

# user stack
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=0010)
.equ USER_STACK_BASE,           0xa200
.equ USER_STACK_LIMIT,          0xffff
.equ USER_STACK_ATTR,           0x40f2
.equ USER_STACK_SELECTOR,       0x17
.equ USER_STACK_INIT_ESP,       0xb000

# video data segment
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=0010)
.equ USER_VIDEO_BASE,           0x0b8000
.equ USER_VIDEO_LIMIT,          0xffff
.equ USER_VIDEO_ATTR,           0x40f2
.equ USER_VIDEO_SELECTOR,       0x1f


################################################################
# for IDT
.equ EXCEPTION_GP_OFFSET,       0x00
.equ EXCEPTION_TS_OFFSET,       0x20
.equ EXCEPTION_SS_OFFSET,       0x40
.equ EXCEPTION_DF_OFFSET,       0x60
.equ EXCEPTION_NP_OFFSET,       0x80
.equ EXCEPTION_PF_OFFSET,       0xa0

################################################################
# data offset and length
.equ INT_GP_MSG_OFFSET,         0x00 
.equ INT_GP_MSG_LENGTH,         0x10
.equ INT_TS_MSG_OFFSET,         0x10
.equ INT_TS_MSG_LENGTH,         0x10
.equ INT_SS_MSG_OFFSET,         0x20
.equ INT_SS_MSG_LENGTH,         0x10
.equ INT_DF_MSG_OFFSET,         0x30
.equ INT_DF_MSG_LENGTH,         0x10
.equ INT_NP_MSG_OFFSET,         0x40
.equ INT_NP_MSG_LENGTH,         0x10
.equ INT_PF_MSG_OFFSET,         0x50
.equ INT_PF_MSG_LENGTH,         0x10

.equ KERNEL_MSG_OFFSET,         0x00
.equ KERNEL_MSG_LENGTH,         0x19
.equ KERNEL_MSG2_OFFSET,        0x19
.equ KERNEL_MSG2_LENGTH,        0x2a

.equ USER_MSG_OFFSET,           0x00
.equ USER_MSG_LENGTH,           0x17

################################################################
# video offset
.equ KERNEL_FIRST_VIDEO_OFFSET, 0x0190
.equ KERNEL_SECOND_VIDEO_OFFSET,0x0230
.equ USER_FIRST_VIDEO_OFFSET,   0x01e0

################################################################
# contents for GDT and IDT
.equ GDT_BASE,                  0x0800
.equ GDT_LIMIT,                 0xff
.equ IDT_BASE,                  0x00
.equ IDT_LIMIT,                 0x07ff

################################################################
# interrupt vector
.equ DE_HANDLER_VECTOR          0
.equ DB_HANDLER_VECTOR          1
.equ NMI_HANDLER_VECTOR         2
.equ BP_HANDLER_VECTOR          3
.equ OF_HANDLER_VECTOR          4
.equ BR_HANDLER_VECTOR          5
.equ UD_HANDLER_VECTOR          6
.equ NM_HANDLER_VECTOR          7
.equ DF_HANDLER_VECTOR          8
.equ TS_HANDLER_VECTOR          10
.equ NP_HANDLER_VECTOR          11
.equ SS_HANDLER_VECTOR          12
.equ GP_HANDLER_VECTOR          13
.equ PF_HANDLER_VECTOR          14
.equ MF_HANDLER_VECTOR          16
.equ AC_HANDLER_VECTOR          17
.equ MC_HANDLER_VECTOR          18
.equ XM_HANDLER_VECTOR          19
.equ SX_HANDLER_VECTOR          31

################################################################
# read sector macro
.macro read_sector add, sector, count
    movb $0x02, %ah
    movb \count, %al
    movb $0x00, %ch
    movb \sector, %cl
    movb $0x00, %dh
    movb $0x00, %dl
    movw \add, %bx
    int $0x13
.endm

