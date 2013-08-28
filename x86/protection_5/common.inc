#
# Common data and struct
#
# memory layout
/*
|                |
+----------------+ 0x0b8000 video buffer (%es)
|                |
+----------------+ 0xd000 test code stack %esp
|                |
+                + 0xc200 test code stack
|                |
+----------------+ 0xc000 test code
|                |
+----------------+ 0xb000 user stack %esp
|                |
+                + 0xa200 user stack
|    user        |
+                + 0xa100 user data
|                |
+----------------+ 0xa000 user code
|                |
+----------------+ 0x9000 kernel stack %esp
|                |
+                + 0x8200 kernel stack
|    kernel      |
+                + 0x8100 kernel data
|                |
+----------------+ 0x8000 kernel code
|                |
+----------------+ 0x7c00 boot
|                |
+----------------+ 0x6000 setup
|                |
+----------------+ 0x4000 interrupt stack %esp
|                |
+                + 0x3200 interrupt stack
| interrupt      |
+                + 0x3100 interrupt data
|                |
+----------------+ 0x3000 interrupt
|                |
+----------------+ 0x2000 LDT
|                |
+----------------+ 0x1000 TSS
|                |
+----------------+ 0x800 GDT
|                |
+----------------+ 0x00 IDT
*/

################################################################
# content address.
.equ BOOT_SEG,      0x7c00
.equ SETUP_SEG,     0x6000
.equ INT_SEG,       0x3000
.equ KERNEL_SEG,    0x8000
.equ USER_SEG,      0xa000
.equ TEST_CODE_SEQ, 0xc000

################################################################
# GDT layout
/*
                                   +---------2-----------+
        |                |         |                     |
        +----------------+         |        +-------+----+---+
        | user LDT       |         |        |       |LDT Sel |
        +----------------+         |        |       +--------+
        | user TSS       |         |        |                |
        +----------------+         |        |  kernel TSS    |
   +----+ kernel LDT     |<--------+        |                |
   |    +----------------+                  |                |     +--------+
   |    | kernel TSS     +-------1--------->+----------------+<----+ TR     |
   |    +----------------+                                         +--------+
   |    | interrupt video|
   |    +----------------+
   |    | interrupt stack|
   |    +----------------+
   |    | interrupt data |
   |    +----------------+
   |    | interrupt code |
   |    +----------------+
   |    | setup TSS      |                  +----------------+
   |    +----------------+                  |                |
   |    |setup descriptor|                  |                |
   |    +----------------+                  |   kernel LDT   |
   |    | null descriptor|                  |                |
   |    +----------------+                  |                |     +--------+
   +-------------------------3------------->+----------------+<----+ LDTR   |
                                                                   +--------+
*/
# invalid selector
.equ INVALID_SELECTOR,          0x100

# for null descriptor
.equ NULL_DESCRIPTOR_BASE,      0x00
.equ NULL_DESCRIPTOR_LIMIT,     0x00
.equ NULL_DESCRIPTOR_ATTR,      0x00
.equ NULL_SELECTOR,             0x00

# setup code
# attr = 0x4098(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1000)
.equ SETUP_BASE,                0x0000
.equ SETUP_LIMIT,               0xffff
.equ SETUP_ATTR,                0x4098
.equ SETUP_SELECTOR,            0x08

# setup TSS
# attr = 0x0089(G=0,D/B=0,L=0,AVL=0,P=1,DPL=00,S=0,TYPE=1001)
.equ SETUP_TSS_BASE,            0x10d0
.equ SETUP_TSS_LIMIT,           0xffff
.equ SETUP_TSS_ATTR,            0x0089
.equ SETUP_TSS_SELECTOR,        0x10

# interrupt and exception handler
# attr = 0x4098(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1000)
.equ INT_HANDLER_BASE,          0x3000
.equ INT_HANDLER_LIMIT,         0xffff
.equ INT_HANDLER_ATTR,          0x4098
.equ INT_HANDLER_SELECTOR,      0x18

# interrupt and exception data
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ INT_DATA_BASE,             0x3100
.equ INT_DATA_LIMIT,            0xffff
.equ INT_DATA_ATTR,             0x4092
.equ INT_DATA_SELECTOR,         0x20

# interrupt and exception stack
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ INT_STACK_BASE,            0x3200
.equ INT_STACK_LIMIT,           0xffff
.equ INT_STACK_ATTR,            0x4092
.equ INT_STACK_SELECTOR,        0x28
.equ INT_STACK_INIT_ESP,        0x4000

# interrupt and exception video
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ INT_VIDEO_BASE,            0x0b8000
.equ INT_VIDEO_LIMIT,           0xffff
.equ INT_VIDEO_ATTR,            0x4092
.equ INT_VIDEO_SELECTOR,        0x30

# kernel TSS
# attr = 0x0089(G=0,D/B=0,L=0,AVL=0,P=1,DPL=00,S=0,TYPE=1001)
.equ KERNEL_TSS_BASE,           0x1000
.equ KERNEL_TSS_LIMIT,          0xffff
.equ KERNEL_TSS_ATTR,           0x0089
.equ KERNEL_TSS_SELECTOR,       0x38

# kernel LDT
# attr = 0x0082(G=0,D/B=0,L=0,AVL=0,P=1,DPL=00,S=0,TYPE=0010)
.equ KERNEL_LDT_BASE,           0x2000
.equ KERNEL_LDT_LIMIT,          0xffff
.equ KERNEL_LDT_ATTR,           0x0082
.equ KERNEL_LDT_SELECTOR,       0x40

# user TSS
# attr = 0x00e9(G=0,D/B=0,L=0,AVL=0,P=1,DPL=11,S=0,TYPE=1001)
.equ USER_TSS_BASE,             0x1068
.equ USER_TSS_LIMIT,            0xffff
.equ USER_TSS_ATTR,             0x00e9
.equ USER_TSS_SELECTOR,         0x4b

# user LDT
# attr = 0x00e2(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=0,TYPE=0010)
.equ USER_LDT_BASE,             0x2020
.equ USER_LDT_LIMIT,            0xffff
.equ USER_LDT_ATTR,             0x00e2
.equ USER_LDT_SELECTOR,         0x53

# test code data
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ TEST_CODE_DPL0_DATA_BASE,       0x0000
.equ TEST_CODE_DPL0_DATA_LIMIT,      0xffff
.equ TEST_CODE_DPL0_DATA_ATTR,       0x4092
.equ TEST_CODE_DPL0_DATA_SELECTOR,   0x58

# test code stack
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ TEST_CODE_DPL0_STACK_BASE,      0xc200
.equ TEST_CODE_DPL0_STACK_LIMIT,     0xffff
.equ TEST_CODE_DPL0_STACK_ATTR,      0x4092
.equ TEST_CODE_DPL0_STACK_SELECTOR,  0x60
.equ TEST_CODE_DPL0_STACK_INIT_ESP,  0xd000

# test code video
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ TEST_CODE_DPL0_VIDEO_BASE,      0x0b8000
.equ TEST_CODE_DPL0_VIDEO_LIMIT,     0xffff
.equ TEST_CODE_DPL0_VIDEO_ATTR,      0x4092
.equ TEST_CODE_DPL0_VIDEO_SELECTOR,  0x68

# test code data
# attr = 0x40f2(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=0010)
.equ TEST_CODE_DPL3_DATA_BASE,       0x0000
.equ TEST_CODE_DPL3_DATA_LIMIT,      0xffff
.equ TEST_CODE_DPL3_DATA_ATTR,       0x40f2
.equ TEST_CODE_DPL3_DATA_SELECTOR,   0x73

# test code stack
# attr = 0x40f2(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=0010)
.equ TEST_CODE_DPL3_STACK_BASE,      0xc200
.equ TEST_CODE_DPL3_STACK_LIMIT,     0xffff
.equ TEST_CODE_DPL3_STACK_ATTR,      0x40f2
.equ TEST_CODE_DPL3_STACK_SELECTOR,  0x7b
.equ TEST_CODE_DPL3_STACK_INIT_ESP,  0xd000

# test code video
# attr = 0x40f2(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=0010)
.equ TEST_CODE_DPL3_VIDEO_BASE,      0x0b8000
.equ TEST_CODE_DPL3_VIDEO_LIMIT,     0xffff
.equ TEST_CODE_DPL3_VIDEO_ATTR,      0x40f2
.equ TEST_CODE_DPL3_VIDEO_SELECTOR,  0x83

# nonconforming code DPL==0
# attr = 0x4098(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1000)
.equ NONCONFORMING_CODE_DPL0_BASE,            0xc000
.equ NONCONFORMING_CODE_DPL0_LIMIT,           0xffff
.equ NONCONFORMING_CODE_DPL0_ATTR,            0x4098
.equ NONCONFORMING_CODE_DPL0_SELECTOR,        0x88

# nonconforming code DPL==3
# attr = 0x40f8(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=1000)
.equ NONCONFORMING_CODE_DPL3_BASE,            0xc040
.equ NONCONFORMING_CODE_DPL3_LIMIT,           0xffff
.equ NONCONFORMING_CODE_DPL3_ATTR,            0x40f8
.equ NONCONFORMING_CODE_DPL3_SELECTOR,        0x93

# conforming code DPL==0
# attr = 0x409c(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1100)
.equ CONFORMING_CODE_DPL0_BASE,            0xc080
.equ CONFORMING_CODE_DPL0_LIMIT,           0xffff
.equ CONFORMING_CODE_DPL0_ATTR,            0x409c
.equ CONFORMING_CODE_DPL0_SELECTOR,        0x98

# conforming code DPL==3
# attr = 0x40fc(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=1100)
.equ CONFORMING_CODE_DPL3_BASE,            0xc0c0
.equ CONFORMING_CODE_DPL3_LIMIT,           0xffff
.equ CONFORMING_CODE_DPL3_ATTR,            0x40fc
.equ CONFORMING_CODE_DPL3_SELECTOR,        0xa3

# conforming code DPL==0, CPL==3
# attr = 0x409c(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1100)
.equ CONFORMING_CODE_DPL0_CPL3_BASE,            0xc100
.equ CONFORMING_CODE_DPL0_CPL3_LIMIT,           0xffff
.equ CONFORMING_CODE_DPL0_CPL3_ATTR,            0x409c
.equ CONFORMING_CODE_DPL0_CPL3_SELECTOR,        0xa8

# nonconforming code call gate
# attr = 0x00ec(G=0,D/B=0,L=0,AVL=0,P=1,DPL=11,S=0,TYPE=1100)
.equ NONCONFORMING_CALL_GATE_BASE,     0x88
.equ NONCONFORMING_CALL_GATE_LIMIT,    0x00
.equ NONCONFORMING_CALL_GATE_ATTR,     0x00ec
.equ NONCONFORMING_CALL_GATE_SELECTOR, 0xb0


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
.equ TEST_CODE_VIDEO_OFFSET,    0x0320

################################################################
# contents for GDT and IDT
.equ GDT_BASE,                  0x0800
.equ GDT_LIMIT,                 0xffff
.equ IDT_BASE,                  0x00
.equ IDT_LIMIT,                 0x07ff

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

