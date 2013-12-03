#
# handler
#

###############################################################
# GP_handler():
GP_handler:
    jmp do_GP_handler
gp_msg1:  .asciz  "----> Now, enter #GP handler, occur at: 0x"
do_GP_handler:
    movl $gp_msg1, %esi
    call puts
    movl 4(%esp), %esi
    call print_int_value
    call println

    jmp .
do_GP_handler_done:
    iret

###############################################################
# PF_handler():
PF_handler:
    jmp do_PF_handler
pf_msg1:  .asciz  "----> Now, enter #PF handler, occur at: 0x"
pf_msg2:  .asciz  "----> fixup <----"
do_PF_handler:
    addl $0x04, %esp
    pushl %ecx
    pushl %edx
    pushl %ebx
    movl $pf_msg1, %esi
    call puts

    movl %cr2, %ecx
    movl %ecx, %esi
    call print_int_value
    call println

# fix error
    movl %ecx, %eax
    shrl $30, %eax
    andl $0x03, %eax
    movl $PDPT_BASE, %ebx
    # PDPTE
    movl (%ebx, %eax, 8), %edx
    btsl $0, %edx
    jnc do_PF_handler_done

    #PDE
    movl %edx, %ebx
    andl $0xfffff000, %ebx
    movl %ecx, %eax
    shrl $21, %eax
    andl $0x01ff, %eax
    movl (%ebx, %eax, 8), %edx
    btsl $0, %edx
    jnc do_PF_handler_done
    bt $7, %edx
    jc do_PF_handler_done

    #PTE
    movl %edx, %ebx
    andl $0xfffff000, %ebx
    movl %ecx, %eax
    shrl $12, %eax
    andl $0x01ff, %eax
    movl (%ebx, %eax, 8), %edx
    btsl $0, %edx

do_PF_handler_done:
    movl %edx, (%ebx, %eax, 8)

    movl $pf_msg2, %esi
    call puts
    call println
    call println

    popl %ebx
    popl %edx
    popl %ecx
    iret

###############################################################
# DB_handler():
DB_handler:
    jmp do_DB_handler
db_msg1:  .asciz  "----> Now, enter #DB handler, occur at: 0x"
do_DB_handler:
    movl $db_msg1, %esi
    call puts
    movl 4(%esp), %esi
    call print_int_value
    call println

    jmp .
do_DB_handler_done:
    iret

###############################################################
# AC_handler():
AC_handler:
    jmp do_AC_handler
ac_msg1:  .asciz  "----> Now, enter #AC handler, occur at: 0x"
do_AC_handler:
    movl $ac_msg1, %esi
    call puts
    movl 4(%esp), %esi
    call print_int_value
    call println

    jmp .
do_AC_handler_done:
    iret

###############################################################
# UD_handler():
UD_handler:
    jmp do_UD_handler
ud_msg1:  .asciz  "----> Now, enter #UD handler, occur at: 0x"
do_UD_handler:
    movl $ud_msg1, %esi
    call puts
    movl 4(%esp), %esi
    call print_int_value
    call println

    jmp .
do_UD_handler_done:
    iret

###############################################################
# NM_handler():
NM_handler:
    jmp do_NM_handler
nm_msg1:  .asciz  "----> Now, enter #NM handler, occur at: 0x"
do_NM_handler:
    movl $nm_msg1, %esi
    call puts
    movl 4(%esp), %esi
    call print_int_value
    call println

    jmp .
do_NM_handler_done:
    iret

###############################################################
# TS_handler():
TS_handler:
    jmp do_TS_handler
ts_msg1:  .asciz  "----> Now, enter #TS handler, occur at: 0x"
do_TS_handler:
    movl $ts_msg1, %esi
    call puts
    movl 4(%esp), %esi
    call print_int_value
    call println

    jmp .
do_TS_handler_done:
    iret

###############################################################
# OF_handler():
OF_handler:
    jmp do_OF_handler
of_msg1:  .asciz  "----> Now, enter #OF handler, occur at: 0x"
do_OF_handler:
    movl $of_msg1, %esi
    call puts
    movl 4(%esp), %esi
    call print_int_value
    call println

    jmp .
do_OF_handler_done:
    iret

###############################################################
# BP_handler():
BP_handler:
    jmp do_BP_handler
bp_msg1:  .asciz  "----> Now, enter #BP handler, occur at: 0x"
do_BP_handler:
    movl $bp_msg1, %esi
    call puts
    movl 4(%esp), %esi
    call print_int_value
    call println

    jmp .
do_BP_handler_done:
    iret

###############################################################
# BR_handler():
BR_handler:
    jmp do_BR_handler
br_msg1:  .asciz  "----> Now, enter #BR handler, occur at: 0x"
do_BR_handler:
    movl $br_msg1, %esi
    call puts
    movl 4(%esp), %esi
    call print_int_value
    call println

    jmp .
do_BR_handler_done:
    iret

