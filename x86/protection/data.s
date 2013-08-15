.code32
.section .data
.globl main_msg
main_msg:
    .ascii "Now we are in protected-mode, this message come from data segment."
main_msg_end:

dummy1:
    .space 0x80-(.-main_msg), 0

fun_msg:
    .ascii "Now we are in another code segment, but the message also come from same data segment."
fun_msg_end:

dummy2:
    .space 0x100-(.-main_msg), 0

end_msg:
    .ascii "======== THE END ========"
end_msg_end:

dummy3:
    .space 0x180-(.-main_msg), 0

main_msg_length:
    .short main_msg_end - main_msg
fun_msg_length:
    .short fun_msg_end - fun_msg
end_msg_length:
    .short end_msg_end - end_msg

dummy:
    .space 512-(.-main_msg), 0

