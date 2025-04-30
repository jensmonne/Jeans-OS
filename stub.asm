BITS 16
ORG 0x0000

MOV AX, CS
MOV DS, AX

MOV SI, start_message
MOV AH, 0x0E
CALL function_double_newline

print_start_message:
    MOV AL, [SI]
    CMP AL, 0
    JE load_kernel
    INT 0x10
    INC SI
    JMP print_start_message

load_kernel:
    MOV AH, 0x02
    MOV AL, 0x01
    MOV CH, 0x00
    MOV CL, 0x02
    MOV DH, 0x00
    MOV DL, 0x00
    MOV ES, AX
    MOV BX, 0x1000
    INT 0x13
    JC disk_error
    JMP 0x1000:0x0000

disk_error:
    JMP $

done:
    JMP $

function_double_newline:
    MOV AL, 0x0D
    INT 0x10
    MOV AL, 0x0A
    INT 0x10
    MOV AL, 0x0D
    INT 0x10
    MOV AL, 0x0A
    INT 0x10
    RET

start_message db 'Loading Kernel...', 0

times 510 - ($ - $$) db 0

dw 0xAA55