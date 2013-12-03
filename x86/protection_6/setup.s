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

    # fill tss descriptor
    movl $__tss32_descriptor, %esi
    movw $0x68 + __io_bitmap_end - __io_bitmap, (%esi)
    movw $__tss32, 2(%esi)
    movb $0x89, 5(%esi)

    movl $__tss_test_descriptor, %esi
    movw $0x68 + __io_bitmap_end - __io_bitmap, (%esi)
    movw $__tss_test, 2(%esi)
    movb $0x89, 5(%esi)

    # fill ldt descriptor
    movl $__ldt_descriptor, %esi
    movw $-1 + __local_descriptor_table_end - __local_descriptor_table, (%esi)
    movw $__local_descriptor_table, 2(%esi)
    movb $0x82, 5(%esi)

    movl %cr0, %eax
    orl $0x01, %eax
    movl %eax, %cr0

    ljmp $KERNEL_CODE32_SELECTOR, $PROTECTED_SEG

###############################################################
# Task State Segments
__tss32:
    __tss32_previous_task_link:     .short  0x00
    __tss32_reserved0:              .short  0x00
    __tss32_esp0:                   .int    0x00
    __tss32_ss0:                    .short  KERNEL_DATA32_SELECTOR
    __tss32_reserved1:              .short  0x00
    __tss32_esp1:                   .int    0x00
    __tss32_ss1:                    .short  0x00
    __tss32_reserved2:              .short  0x00
    __tss32_esp2:                   .int    0x00
    __tss32_ss2:                    .short  0x00
    __tss32_reserved3:              .short  0x00
    __tss32_cr3:                    .int    0x00
    __tss32_eip:                    .int    0x00
    __tss32_eflags:                 .int    0x00
    __tss32_eax:                    .int    0x00
    __tss32_ecx:                    .int    0x00
    __tss32_edx:                    .int    0x00
    __tss32_ebx:                    .int    0x00
    __tss32_esp:                    .int    0x00
    __tss32_ebp:                    .int    0x00
    __tss32_esi:                    .int    0x00
    __tss32_edi:                    .int    0x00
    __tss32_es:                     .short  0x00
    __tss32_reserved4:              .short  0x00
    __tss32_cs:                     .short  0x00
    __tss32_reserved5:              .short  0x00
    __tss32_ss:                     .short  0x00
    __tss32_reserved6:              .short  0x00
    __tss32_ds:                     .short  0x00
    __tss32_reserved7:              .short  0x00
    __tss32_fs:                     .short  0x00
    __tss32_reserved8:              .short  0x00
    __tss32_gs:                     .short  0x00
    __tss32_reserved9:              .short  0x00
    __tss32_ldt_segment_selector:   .short  0x00
    __tss32_reserved10:             .short  0x00
    __tss32_t:                      .short  0x00
    __tss32_io_map_base_address:    .short  __io_bitmap - __tss32
__tss32_end:

__tss_test:
    __tss_test_previous_task_link:      .short  0x00
    __tss_test_reserved0:               .short  0x00
    __tss_test_esp0:                    .int    0x00
    __tss_test_ss0:                     .short  KERNEL_DATA32_SELECTOR
    __tss_test_reserved1:               .short  0x00
    __tss_test_esp1:                    .int    0x00
    __tss_test_ss1:                     .short  0x00
    __tss_test_reserved2:               .short  0x00
    __tss_test_esp2:                    .int    0x00
    __tss_test_ss2:                     .short  0x00
    __tss_test_reserved3:               .short  0x00
    __tss_test_cr3:                     .int    0x00
    __tss_test_eip:                     .int    0x00
    __tss_test_eflags:                  .int    0x00
    __tss_test_eax:                     .int    0x00
    __tss_test_ecx:                     .int    0x00
    __tss_test_edx:                     .int    0x00
    __tss_test_ebx:                     .int    0x00
    __tss_test_esp:                     .int    0x00
    __tss_test_ebp:                     .int    0x00
    __tss_test_esi:                     .int    0x00
    __tss_test_edi:                     .int    0x00
    __tss_test_es:                      .short  0x00
    __tss_test_reserved4:               .short  0x00
    __tss_test_cs:                      .short  0x00
    __tss_test_reserved5:               .short  0x00
    __tss_test_ss:                      .short  0x00
    __tss_test_reserved6:               .short  0x00
    __tss_test_ds:                      .short  0x00
    __tss_test_reserved7:               .short  0x00
    __tss_test_fs:                      .short  0x00
    __tss_test_reserved8:               .short  0x00
    __tss_test_gs:                      .short  0x00
    __tss_test_reserved9:               .short  0x00
    __tss_test_ldt_segment_selector:    .short  0x00
    __tss_test_reserved10:              .short  0x00
    __tss_test_t:                       .short  0x00
    __tss_test_io_map_base_address:     .short  __io_bitmap - __tss_test
__tss_test_end:

###############################################################
# I/O bitmap
__io_bitmap:
    .fill 0x0a, 1, 0x00
__io_bitmap_end:

###############################################################
# Global descriptor table, Local descriptor table and interrupt descriptor table
__global_descriptor_table:
    __null_descriptor:              .quad   0x00            # NULL descriptor
    __code16_descriptor:            .quad   0x00009a000000ffff  # base=0x00, limit=0xffff, DPL=0
    __data16_descriptor:            .quad   0x000092000000ffff  # base=0x00, limit=0xffff, DPL=0
    __kernel_code32_descriptor:     .quad   0x00cf9a000000ffff  # non-conforming, DPL=0, P=1
    __kernel_data32_descriptor:     .quad   0x00cf92000000ffff  # DPL=0, P=1, writable, expand-up
    __user_code32_descriptor:       .quad   0x00cffa000000ffff  # non-comforming, DPL=3, P=1
    __user_data32_descriptor:       .quad   0x00cff2000000ffff  # DPL=3, P=1, writable, expand-up

    __tss32_descriptor:             .quad   0x00
    __call_gate_descriptor:         .quad   0x00
    __comforming_code32_descriptor: .quad   0x00cf9e000000ffff    # comforing, DPL=0, P=1
    __tss_test_descriptor:          .quad   0x00
    __task_gate_descriptor:         .quad   0x00
    __ldt_descriptor:               .quad   0x00
__global_descriptor_table_end:

__local_descriptor_table:
    .fill 0x0a, 8, 0x00
__local_descriptor_table_end:

__interrupt_descriptor_table:
    .fill 0x80, 8, 0x00
__interrupt_descriptor_table_end:

###############################################################
# GDT, IDT
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

