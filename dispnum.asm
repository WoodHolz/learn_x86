IOY0 EQU 00H
MY8255_A EQU IOY0 + 00H
MY8255_MODE EQU IOY0 + 03H
DATA SEGMENT
    ARR DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH, 77H, 7CH, 39H, 5EH, 79H, 71H
DATA ENDS
STACK SEGMENT STACK
    DW 100H DUP(?)
STACK ENDS
CODE SEGMENT
    ASSUME CS: CODE DS: DATA
START:
    MOV AX, DATA
    MOV DS, AX

    ; set the work mode of 8255
    MOV AL, 10000000B ; not confused now, just read the book; set the port of 8255
    MOV DX, MY8255_MODE
    OUT DX,AL

    MOV BX, OFFSET ARR
    MOV CX, 20
    
    LOOP_DIS:
    ;PUSH CX
    CALL DELAY
    RET_DELAY:
    ;POP CX
    MOV AL, [BX]
    MOV DX, MY8255_A
    MOV DX, AL
    INC BX
    DEC CX 
    CMP CX, 0
    JGE LOOP_DIS
    JMP ENDG

    ; confused... how to calculate the time  
    ; when using software timing?
    DELAY:
    PUSH CX
    MOV CX, 0FFFFH 
    DEC CX 
    CMP CX, 0
    JGE DELAY
    POP CX
    JMP RET_DELAY

    ENDG:
    MOV AH, 4CH
    INT 21H
CODE ENDS
    END START
