# memory layout
/*
|                |
+----------------+ 0x0b8000 video buffer (%es)
|                |
|                |
+----------------+ 0x051000 user stack %esp
|                |
+                + 0x050200 user stack
|    user        |
+                + 0x050100 user data
|                |
+----------------+ 0x050000 user code
|                |
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
.equ KERNEL_SEG,    0x8000
.equ USER_SEQ,      0x050000

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
   |    | interrupt LDT  |
   |    +----------------+
   |    | interrupt TSS  |                  +----------------+
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

# interrupt and exception handler
# attr = 0x4098(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1000)
.equ SETUP_BASE,                0x0000
.equ SETUP_LIMIT,               0xffff
.equ SETUP_ATTR,                0x4098
.equ SETUP_SELECTOR,            0x08

# interrupt and exception TSS
# attr = 0x0089(G=0,D/B=0,L=0,AVL=0,P=1,DPL=00,S=0,TYPE=1001)
.equ INT_TSS_BASE,              0x1000
.equ INT_TSS_LIMIT,             0xffff
.equ INT_TSS_ATTR,              0x0089
.equ INT_TSS_SELECTOR,          0x10

# interrupt and exception LDT
# attr = 0x0082(G=0,D/B=0,L=0,AVL=0,P=1,DPL=00,S=0,TYPE=0010)
.equ INT_LDT_BASE,              0x2000
.equ INT_LDT_LIMIT,             0xffff
.equ INT_LDT_ATTR,              0x0082
.equ INT_LDT_SELECTOR,          0x18

# kernel TSS
# attr = 0x0089(G=0,D/B=0,L=0,AVL=0,P=1,DPL=00,S=0,TYPE=1001)
.equ KERNEL_TSS_BASE,           0x1068
.equ KERNEL_TSS_LIMIT,          0xffff
.equ KERNEL_TSS_ATTR,           0x0089
.equ KERNEL_TSS_SELECTOR,       0x20

# kernel LDT
# attr = 0x0082(G=0,D/B=0,L=0,AVL=0,P=1,DPL=00,S=0,TYPE=0010)
.equ KERNEL_LDT_BASE,           0x2020
.equ KERNEL_LDT_LIMIT,          0xffff
.equ KERNEL_LDT_ATTR,           0x0082
.equ KERNEL_LDT_SELECTOR,       0x28

# user TSS
# attr = 0x00e9(G=0,D/B=0,L=0,AVL=0,P=1,DPL=11,S=0,TYPE=1001)
.equ USER_TSS_BASE,             0x10d0
.equ USER_TSS_LIMIT,            0xffff
.equ USER_TSS_ATTR,             0x00e9
.equ USER_TSS_SELECTOR,         0x30

# user LDT
# attr = 0x00e2(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=0,TYPE=0010)
.equ USER_LDT_BASE,             0x2040
.equ USER_LDT_LIMIT,            0xffff
.equ USER_LDT_ATTR,             0x00e2
.equ USER_LDT_SELECTOR,         0x38

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
# interrupt and exception LDT
# interrupt and exception handler
# attr = 0x4098(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1000)
.equ INT_HANDLER_BASE,          0x3000
.equ INT_HANDLER_LIMIT,         0xffff
.equ INT_HANDLER_ATTR,          0x4098
.equ INT_HANDLER_SELECTOR,      0x04

# interrupt and exception data
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ INT_DATA_BASE,             0x3100
.equ INT_DATA_LIMIT,            0xffff
.equ INT_DATA_ATTR,             0x4092
.equ INT_DATA_SELECTOR,         0x0c

# interrupt and exception stack
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ INT_STACK_BASE,            0x3200
.equ INT_STACK_LIMIT,           0xffff
.equ INT_STACK_ATTR,            0x4092
.equ INT_STACK_SELECTOR,        0x14

# video data segment
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ INT_VIDEO_BASE,            0x0b8000
.equ INT_VIDEO_LIMIT,           0xffff
.equ INT_VIDEO_ATTR,            0x4092
.equ INT_VIDEO_SELECTOR,        0x1c

# kernel LDT



################################################################
# for IDT
.equ EXCEPTION_GP_OFFSET,       0x00
.equ INT_0XFF_OFFSET,           0x20

.equ GDT_BASE,                  0x0800
.equ GDT_LIMIT,                 0x50
.equ IDT_BASE,                  0x00
.equ IDT_LIMIT,                 0x07ff

# for access data
.equ GP_MSG_OFFSET,             0x40 
.equ GP_MSG_LEN_OFFSET,         0x80

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

