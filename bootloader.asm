BITS 16
ORG 0x7C00

; Clear screen
MOV AH, 0x06
MOV AL, 0x00
MOV BH, 0x07
MOV CH, 0x00
MOV CL, 0x00
MOV DH, 24
MOV DL, 79
INT 0x10

; Set cursor to 0,0
MOV AH, 0x02
MOV BH, 0x00
MOV DH, 0x00
MOV DL, 0x00
INT 0x10

; Prints the welcome message
MOV SI, welcome_message
MOV AH, 0x0E

print_welcome_message_loop:
    MOV AL, [SI]
    CMP AL, 0
    JE setup_question_print
    INT 0x10
    INC SI
    JMP print_welcome_message_loop

setup_question_print:
    MOV SI, question_message
    CALL function_double_newline

print_question_message_loop:
    MOV AL, [SI]
    CMP AL, 0
    JE setup_response
    INT 0x10
    INC SI
    JMP print_question_message_loop

setup_response:
    CALL function_double_newline

wait_for_response:
    MOV AH, 0x00
    INT 0x16

    MOV AH, 0x0E
    INT 0x10

    CMP AL, 0x79
    JE setup_y_print
    CMP AL, 0x59
    JE setup_y_print
    CMP AL, 0x6E
    JE setup_n_print
    CMP AL, 0x4E
    JE setup_n_print
    JMP setup_error_print

setup_y_print:
    MOV SI, y_message
    CALL function_double_newline

print_y_message_loop:
    MOV AL, [SI]
    CMP AL, 0
    JE setup_stub_print
    INT 0x10
    INC SI
    JMP print_y_message_loop

setup_n_print:
    MOV SI, n_message
    CALL function_double_newline

print_n_message_loop:
    MOV AL, [SI]
    CMP AL, 0
    JE done
    INT 0x10
    INC SI
    JMP print_n_message_loop

setup_error_print:
    MOV SI, error_message
    CALL function_double_newline

print_error_message_loop:
    MOV AL, [SI]
    CMP AL, 0
    JE setup_response
    INT 0x10
    INC SI
    JMP print_error_message_loop

setup_stub_print:
    MOV SI, stub_message
    CALL function_double_newline

print_sub_message_loop:
    MOV AL, [SI]
    CMP AL, 0
    JE load_stub
    INT 0x10
    INC SI
    JMP print_sub_message_loop

load_stub:
    MOV AX, 0x8000
    MOV ES, AX
    MOV BX, 0x0000

    MOV AH, 0x02
    MOV AL, 0x01
    MOV CH, 0x00
    MOV CL, 0x02
    MOV DH, 0x00
    MOV DL, 0x00    ; Drive, need to change to HDD

    INT 0x13

    JC disk_error

    JMP 0x8000:0x0000

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

welcome_message db 'Welcome to Jeans OS V0.0.1', 0
question_message db 'Boot the system? (Y/N)', 0
y_message db 'Booting...', 0
n_message db 'Boot Cancelled.', 0
error_message db 'Invalid input. Press Y or N.', 0
stub_message db 'Loading Sector 2...', 0

times 510 - ($ - $$) db 0

dw 0xAA55