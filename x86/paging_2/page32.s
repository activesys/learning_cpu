#
# page32
#

###############################################################
# dump_pae_page
# esi: virtual address(linear address)
dump_pae_page:
    pushl %ecx
    pushl %edx
    pushl %ebx
    movl $PDPT_BASE, pdpt_base
    call get_maxphyaddr_select_mask
    movl %esi, %ecx
    # output PDPTE
    movl $pdpte_msg, %esi
    call puts
    movl %ecx, %eax
    shrl $30, %eax
    andl $0x03, %eax
    movl $PDPT_BASE, %ebx
    movl 4(%ebx, %eax, 8), %edi
    movl (%ebx, %eax, 8), %esi
    movl %esi, %edx
    movl %edi, %ebx
    btl $0, %edx
    jc pdpte_next
    movl $not_available
    call puts
    call println
    jmp dump_pae_page_done
pdpte_next:
    andl maxphyaddr_select_mask, %esi
    andl $0xfffff000, %esi
    andl maxphyaddr_select_mask+4, %edi
    movl %esi, pdt_base
    movl %edi, pdt_base+4
    call print_qword_value
    call printblank
    movl $attr_msg, %esi
    call puts
    movl %edx, %esi
    shll $19, %esi
    call reverse
    movl %eax, %esi
    call $pdpte_pae_flags, %edi
    call dump_flags
    call println
    movl maxphyaddr_select_mask+4, %eax
    notl %eax
    testl %eax, %ebx
    jnz print_reserved_error
    testl $0x1e6, %edx
print_reserved_error:
    movl $0x00, %esi
    movl $reserved_error, %edi
    cmovnz %edi, %esi
    call puts

dump_pae_page_done:
    popl %ebx
    popl %edx
    popl %ecx
    ret

#   MAXPHYADDR = 36 : select mask = 0x0000000fffffffff
#   MAXPHYADDR = 40 : select mask = 0x000000ffffffffff
#   MAXPHYADDR = 52 : select mask = 0x000fffffffffffff
#
get_maxphyaddr_select_mask:
    pushl %ecx
    pushl %edx
    call get_maxphyadd
    leal -64(%eax), %ecx
    negl %ecx
    movl $0x00, %eax
    movl $-1, %edx
    cmpl $32, %ecx
    cmovel %eax, %edx
    shll %cl, %edx
    shrl %cl, %edx
    movl $maxphyaddr_select_mask, %ecx
    movl %eax, (%ecx)
    movl %edx, 4(%ecx)
    movl 
    popl %edx
    popl %ecx
    ret


###############################################################
# dump_page
# esi: virtual address(linear address)
dump_page:
    pushl %ecx
    pushl %edx
    movl %esi, %ecx
    movl $pde_msg, %esi
    call puts
    movl %ecx, %esi
    call __get_32bit_paging_pde_index
    movl PDT32_BASE(, %eax, 4), %eax
    movl %eax, %edx
    btl $7, %eax
    jnc dump_4k_page
dump_4m_page:
    movl %eax, %edi
    movl %eax, %esi
    andl $0xffc00000, %esi
    shrl $13, %edi
    andl $0xff, %edi
    call print_qword_value
    call printblank
    movl $attr_msg, %esi
    call puts
    movl %edx, %esi
    shl $19, %esi
    call reverse
    movl %eax, %esi
    movl $pde_4m_flags, %edi
    call dump_flags
    call println
    jmp do_dump_page_done

dump_4k_page:
# PDE
    movl %edx, %esi
    andl $0xfffff000, %esi
    movl %esi, pt_base
    movl $0x00, %edi
    call print_qword_value
    call printblank
    movl $attr_msg, %esi
    call puts
    movl %edx, %esi
    shll $19, %esi
    call reverse
    movl %eax, %esi
    movl $pde_4k_flags, %edi
    call dump_flags
    call println
# PTE
    movl $pte_msg, %esi
    call puts
    movl %ecx, %esi
    call __get_32bit_paging_pte_index
    leal (, %eax, 4), %eax
    addl pt_base, %eax
    movl (%eax), %ecx
    movl %ecx, %esi
    andl $0xfffff000, %esi
    movl $0x00, %edi
    call print_qword_value
    call printblank
    movl $attr_msg, %esi
    call puts
    movl %ecx, %esi
    shll $19, %esi
    call reverse
    movl %eax, %esi
    movl $pte_4k_flags, %edi
    call dump_flags
    call println
do_dump_page_done:
    popl %edx
    popl %ecx
    ret

###############################################################
# __get_32bit_paging_pte_index
# input: esi: virtual address
# output: eax: pte index
__get_32bit_paging_pte_index:
    movl %esi, %eax
    andl $0x3ff000, %eax
    shrl $12, %eax
    ret

###############################################################
# __get_32bit_paging_pde_index
# input: esi: virtual address
# output: eax: pde index
__get_32bit_paging_pde_index:
    movl %esi, %eax
    andl $0xffc00000, %eax
    shrl $22, %eax
    ret

###############################################################
maxphyaddr_select_mask: .quad   0x00
pt_base:        .quad   0x00
pdpt_base:      .quad   0x00
pdt_base:       .quad   0x00

pde_msg:        .asciz  "PDE:    base=0x"
pte_msg:        .asciz  "PTE:    base=0x"
pdpte_msg:      .asciz  "PDPTE:  base=0x"
attr_msg:       .asciz  "Attr: "

not_available:  .asciz  "***  not available (P=0)"
reserved_error: .asciz  "        <ERROR: reserved bit is not zero!>"

p_flags:        .asciz  "p"
rw_flags:       .asciz  "r/w"
us_flags:       .asciz  "u/s"
pwt_flags:      .asciz  "pwt"
pcd_flags:      .asciz  "pcd"
a_flags:        .asciz  "a"
d_flags:        .asciz  "d"
ps_flags:       .asciz  "ps"
g_flags:        .asciz  "g"
pat_flags:      .asciz  "pat"
ignore_flags:   .asciz  "-"
blank_flags:    .asciz  "   "
reserved_flags: .asciz  "0"
xd_flags:       .asciz  "xd"

pdpte_pae_flags:.int blank_flags, ignore_flags, ignore_flags, ignore_flags, reserved_flags, reserved_flags
                .int reserved_flags, reserved_flags, pcd_flags, pwt_flags, reserved_flags, reserved_flags
                .int p_flags, -1
pde_4m_flags:   .int pat_flags, ignore_flags, ignore_flags, ignore_flags, g_flags, ps_flags
                .int d_flags, a_flags, pcd_flags, pwt_flags, us_flags, rw_flags, p_flags, -1
pde_4k_flags:   .int blank_flags, ignore_flags, ignore_flags, ignore_flags, ignore_flags, ps_flags
                .int ignore_flags, a_flags, pcd_flags, pwt_flags, us_flags, rw_flags, p_flags, -1
pte_4k_flags:   .int blank_flags, ignore_flags, ignore_flags, ignore_flags, g_flags, pat_flags
                .int d_flags, a_flags, pcd_flags, pwt_flags, us_flags, rw_flags, p_flags, -1

