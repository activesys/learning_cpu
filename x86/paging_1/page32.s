#
# page32
#

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
pt_base:        .quad    0x00

pde_msg:        .asciz  "PDE:    base=0x"
pte_msg:        .asciz  "PTE:    base=0x"
attr_msg:       .asciz  "Attr: "

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

pde_4m_flags:   .int pat_flags, ignore_flags, ignore_flags, ignore_flags, g_flags, ps_flags
                .int d_flags, a_flags, pcd_flags, pwt_flags, us_flags, rw_flags, p_flags, -1
pde_4k_flags:   .int blank_flags, ignore_flags, ignore_flags, ignore_flags, ignore_flags, ps_flags
                .int ignore_flags, a_flags, pcd_flags, pwt_flags, us_flags, rw_flags, p_flags, -1
pte_4k_flags:   .int blank_flags, ignore_flags, ignore_flags, ignore_flags, g_flags, pat_flags
                .int d_flags, a_flags, pcd_flags, pwt_flags, us_flags, rw_flags, p_flags, -1

