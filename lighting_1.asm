IOYO EQU 00H
MY8255_A EQU IOYO + 00H
MY8255_MODE EQU IOYO + 03H
CODE SEGMENT
    ASSUME CS: CODE
START:
    MOV AL, 10000000B
    MOV DX, MY8255_MODE
    OUT DX, AL

    MOV AL, 0FFH
    MOV DX, MY8255_A
    OUT DX, AL

    MOV AH, 4CH
    INT 21H
CODE ENDS
    END