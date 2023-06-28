IOYO EQU 0600H
MY8255_A EQU IOYO+00h*2
MY8255_B EQU IOYO+01h*2
MY8255_C EQU IOYO+02h*2
MY8255_MODE EQU IOYO+03h*2

DATA SEGMENT
    TAL DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH, 77H, 7CH, 39H, 5EH, 79H, 71H
DATA ENDS

STACK SEGMENT STACK
    DB 128 DUP(0)
STACK ENDS
CODE SEGMENT
    ASSUME CS: CODE, DS: DATA, SS: STACK
START:
    MOV AX, DATA
    MOV DS, AX

    MOV AL, 10000000B
    MOV DX, MY8255_MODE
    OUT DX,AL 

    MOV BX, OFFSET TAL
    MOV AL, [BX]

;10
    show_10:
    mov AL, 00000010b
    mov DX, MY8255_C
    out DX, AL 
    mov AL, [BX + 1]
    mov DX, MY8255_B
    out DX,AL 
    
    ;mov AL, 00h
    ;mov DX, MY8255_B
    ;out DX,AL 
    mov AL, 00000001b
    mov DX, MY8255_C
    out DX, AL 
    mov AL, [BX]
    mov DX, MY8255_B
    out DX,AL 
    mov AL, 00h
    mov DX, MY8255_B
    out DX,AL 
    jmp show_10

    DELAY:
    MOV CX,26 
    LOOP_d:
    NOP
    LOOP LOOP_d
    RET
    
CODE ENDS
    END START