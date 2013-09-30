#
# Setup IDT, GDT, LDT, TSS and switch to protected-mode.
#

.include "common.inc"


###############################################################
# Real-mode code for setup
.code16
.section .text
.globl _start
_start:
    cli

    lgdt __gdt_pointer
    lidt __idt_pointer


###############################################################
# Global descriptor table and interrupt descriptor table
__global_descriptor_table:
    __null_descriptor:		    .quad   0x00		    # NULL descriptor
    __code16_descriptor:	    .quad   0x00009a000000ffff  # base=0x00, limit=0xffff, DPL=0
    __data16_descriptor:	    .quad   0x000092000000ffff  # base=0x00, limit=0xffff, DPL=0
    __kernel_code32_descriptor:	    .quad   0x00cf9a000000ffff  # non-conforming, DPL=0, P=1
    __kernel_data32_descriptor:	    .quad   0x00cf92000000ffff  # DPL=0, P=1, writable, expand-up
    __user_code32_descriptor:	    .quad   0x00cffa000000ffff  # non-comforming, DPL=3, P=1
    __user_data32_descriptor:	    .quad   0x00cff2000000ffff  # DPL=3, P=1, writable, expand-up

    __tss32_descriptor:		    .quad   0x00
    __call_gate_descriptor:	    .quad   0x00
    __comforming_code32_descriptor: .quad   0x00cf9e000000ffff	# comforing, DPL=0, P=1
    __tss_test_descriptor:	    .quad   0x00
    __task_gate_descriptor:	    .quad   0x00
    __ldt_descriptor:		    .quad   0x00
__global_descriptor_table_end:

__interrupt_descriptor_table:
    .fill 0x80, 8, 0x00
__interrupt_descriptor_table_end:

###############################################################
# GDT and IDT
__gdt_pointer:
    __gdt_limit:    .short  __global_descriptor_table_end - __global_descriptor_table - 1 
    __gdt_base:     .int    __global_descriptor_table

__idt_pointer:
    __idt_limit:    .short  __interrupt_descriptor_table_end - __interrupt_descriptor_table - 1
    __idt_base:     .int    __interrupt_descriptor_table

__ivt_pointer:
    __ivt_limit:    .short  0x03ff
    __ivt_base:     .int    0x00

###############################################################
dummy:
    .space 0x800-(.-_start), 0x00

