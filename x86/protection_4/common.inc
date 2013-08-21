# memory layout
/*
|                |
+----------------+ 0x7c00 boot
|                |
+----------------+ 0x7000 user stack %esp
|                |
+----------------+ 0x6000 user stack
|                |
+----------------+ 0x5100 user data
|                |
+----------------+ 0x5000 user code
|                |
+----------------+ 0x4100 setup
|                |
+----------------+ 0x4000 kernel stack %esp
|                |
+----------------+ 0x3000 kernel stack
|                |
+----------------+ 0x2100 kernel data
|                |
+----------------+ 0x2000 kernel code
|                |
+----------------+ 0x1000 interrupt
|                |
+----------------+ 0x800 GDT
|                |
+----------------+ 0x00 IDT
*/

# content address.
.equ BOOT_SEG,  0x7c00
.equ SETUP_SEG, 0x4100

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

# interrupt and exception handler
# attr = 0x4098(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1000)
.equ INT_HANDLER_BASE,          0x1000
.equ INT_HANDLER_LIMIT,         0xffff
.equ INT_HANDLER_ATTR,          0x4098
.equ INT_HANDLER_SELECTOR,      0x10

# video data segment
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ VIDEO_BASE,                0x0b8000
.equ VIDEO_LIMIT,               0xffff
.equ VIDEO_ATTR,                0x4092
.equ VIDEO_SELECTOR,            0x18

# kernel code segment
# attr = 0x4098(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1000)
.equ KERNEL_CODE_BASE,          0x2000
.equ KERNEL_CODE_LIMIT,         0xffff
.equ KERNEL_CODE_ATTR,          0x4098
.equ KERNEL_CODE_SELECTOR,      0x20

# kernel data segment
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ KERNEL_DATA_BASE,          0x2100
.equ KERNEL_DATA_LIMIT,         0xffff
.equ KERNEL_DATA_ATTR,          0x4092
.equ KERNEL_DATA_SELECTOR,      0x28

# kernel stack segment
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ KERNEL_STACK_BASE,         0x3000
.equ KERNEL_STACK_LIMIT,        0xffff
.equ KERNEL_STACK_ATTR,         0x4092
.equ KERNEL_STACK_SELECTOR,     0x30
.equ KERNEL_STACK_INIT_ESP,     0x4000

# user code segment
# attr = 0x40f8(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=1000)
.equ USER_CODE_BASE,            0x5000
.equ USER_CODE_LIMIT,           0xffff
.equ USER_CODE_ATTR,            0x40f8
.equ USER_CODE_SELECTOR,        0x38

# user data segment
# attr = 0x40f2(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=0010)
.equ USER_DATA_BASE,            0x5100
.equ USER_DATA_LIMIT,           0xffff
.equ USER_DATA_ATTR,            0x40f2
.equ USER_DATA_SELECTOR,        0x40

# user stack segment
# attr = 0x40f2(G=0,D/B=1,L=0,AVL=0,P=1,DPL=11,S=1,TYPE=0010)
.equ USER_STACK_BASE,           0x6000
.equ USER_STACK_LIMIT,          0xffff
.equ USER_STACK_ATTR,           0x40f2
.equ USER_STACK_SELECTOR,       0x48
.equ USER_STACK_INIT_ESP,       0x7000

# invalid selector
.equ INVALID_SELECTOR,          0x100

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

