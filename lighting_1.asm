IOYO EQU 0600H
MY8255_A EQU IOYO + 00H*2
MY8255_B EQU IOYO + 01H*2
MY8255_MODE EQU IOYO + 03H*2

DSEG SEGMENT
    TAL DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH, 77H, 7CH, 39H, 5EH, 79H, 71H
DSEG ENDS

STACK SEGMENT STACK
    DW 128 DUP(0)
STACK ENDS
CODE SEGMENT
    ASSUME CS: CODE, DS: DSEG, SS: STACK
START:
    MOV AX, DSEG
    MOV DS, AX

    MOV AL, 10000000B
    MOV DX, MY8255_MODE
    OUT DX, AL
    mov si, 0
    dis:
    MOV BX, OFFSET TAL
    MOV AL, [BX + si]
    mov DX, MY8255_B
    out DX, AL
    INC si
    call DELAY
    cmp si, 10
    JB dis
    mov si, 0
    jmp dis
    
    DELAY:
    MOV CX, 65535
    
    LOOP_d:
    NOP
    NOP
    NOP
    LOOP LOOP_d
    RET
    
CODE ENDS
    END START