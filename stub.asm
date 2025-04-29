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
    ; Kernel loading logic

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