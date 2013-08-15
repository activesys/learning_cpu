# memory layout
/*
|                |
+----------------+ 0x8000000 (128M) code
|                |
+----------------+ 0x7f00000 data
|                |
|                |
+----------------+ 0x100f000 %esp
|                |
+----------------+ 0x1000000 stack
|                |
+----------------+ 0x7c00 boot
|                |
+----------------+ 0x7000 protected-mode setup
|                |
+----------------+ 0x6000 setup
|                |
+----------------+ 0x5000 int %esp
|                |
+----------------+ 0x4000 int stack
|                |
+----------------+ 0x1000 interrupt
|                |
+----------------+ 0x800 GDT
|                |
+----------------+ 0x00 IDT
*/

# content address.
.equ BOOT_SEG,  0x7c00
.equ SETUP_SEG, 0x6000

# for null descriptor
.equ NULL_DESCRIPTOR_BASE,  0x00
.equ NULL_DESCRIPTOR_LIMIT, 0x00
.equ NULL_DESCRIPTOR_ATTR,  0x00
.equ NULL_SELECTOR,         0x00

# interrupt and exception handler
# attr = 0x409a(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1010)
.equ INT_HANDLER_BASE,     0x1000
.equ INT_HANDLER_LIMIT,    0xffff
.equ INT_HANDLER_ATTR,     0x409a
.equ INT_HANDLER_SELECTOR, 0x08

# main code segment
# attr = 0x409a(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1010)
.equ CODE_MAIN_BASE,       0x08000000
.equ CODE_MAIN_LIMIT,      0xffff
.equ CODE_MAIN_ATTR,       0x409a
.equ CODE_MAIN_SELECTOR,   0x10

# data segment
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ DATA_BASE,            0x07f00000
.equ DATA_LIMIT,           0xffff
.equ DATA_ATTR,            0x4092
.equ DATA_SELECTOR,        0x18

# stack segment
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ STACK_BASE,           0x01000000
.equ STACK_LIMIT,          0xffff
.equ STACK_ATTR,           0x4092
.equ STACK_SELECTOR,       0x20
.equ STACK_INIT_ESP,       0x0100f000

# setup segment
# attr = 0x409a(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=1010)
.equ SETUP_BASE,           0x7000
.equ SETUP_LIMIT,          0xffff
.equ SETUP_ATTR,           0x409a
.equ SETUP_SELECTOR,       0x28

# interrupt stack segment
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ INT_STACK_BASE,       0x4000
.equ INT_STACK_LIMIT,      0xffff
.equ INT_STACK_ATTR,       0x4092
.equ INT_STACK_SELECTOR,   0x30
.equ INT_STACK_INIT_ESP,   0x5000

# video data segment
# attr = 0x4092(G=0,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ VIDEO_BASE,            0x0b8000
.equ VIDEO_LIMIT,           0xffff
.equ VIDEO_ATTR,            0x4092
.equ VIDEO_SELECTOR,        0x38

# super data segment
# attr = 0xc092(G=1,D/B=1,L=0,AVL=0,P=1,DPL=00,S=1,TYPE=0010)
.equ SUPER_BASE,            0x00
.equ SUPER_LIMIT,           0xfffff
.equ SUPER_ATTR,            0xc092
.equ SUPER_SELECTOR,        0x40

# invalid selector
.equ INVALID_SELECTOR,     0x100

# for IDT
.equ INT_0X80_OFFSET,      0x00
.equ INT_0X90_OFFSET,      0x20
.equ INT_0XFF_OFFSET,      0x40
.equ EXCEPTION_GP_OFFSET,  0x60

.equ GDT_BASE,             0x0800
.equ IDT_BASE,             0x00

# for access data
.equ MAIN_MES_OFFSET,      0x00
.equ FUN_MSG_OFFSET,       0x80 
.equ END_MSG_OFFSET,       0x100
.equ MAIN_MSG_LEN_OFFSET,  0x180
.equ FUN_MSG_LEN_OFFSET,   0x182
.equ END_MSG_LEN_OFFSET,   0x184

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

