IOYO EQU 0600H
MY8255_A EQU IOYO + 00H*2
MY8255_B EQU IOYO + 01H*2
MY8255_MODE EQU IOYO + 03H*2

;DSEG SEGMENT
;    TAL DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH, 77H, 7CH, 39H, 5EH, 79H, 71H
;DSEG ENDS

STACK SEGMENT STACK
    DB 100 DUP(?)
STACK ENDS
CODE SEGMENT
    ASSUME CS: CODE;, DS: DSEG
START:
    ;MOV AX, DSEG
    ;MOV DS, AX



    MOV AL, 10000000B
    MOV DX, MY8255_MODE
    OUT DX, AL

;    MOV BX, OFFSET TAL
;    INC BX
;    MOV AL, [BX]

    ;9
    call DELAY
    ;RET_DELAY:
    mov al, 6fH
    mov dx, MY8255_B
    out dx, al

;8
    call DELAY
    ;RET_DELAY:
    mov al, 7fH
    mov dx, MY8255_B
    out dx, al
;7
    call DELAY
    ;RET_DELAY:
    mov al, 07H
    mov dx, MY8255_B
    out dx, al
;6
    call DELAY
    ;RET_DELAY:
    mov al, 7dH
    mov dx, MY8255_B
    out dx, al
;5
    call DELAY
    ;RET_DELAY:
    mov al, 6dH
    mov dx, MY8255_B
    out dx, al
;4
    call DELAY
    ;RET_DELAY:
    mov al, 66H
    mov dx, MY8255_B
    out dx, al
;3
    call DELAY
    ;RET_DELAY:
    mov al, 4fH
    mov dx, MY8255_B
    out dx, al 
;2
    call DELAY
    ;RET_DELAY:
    mov al, 5BH
    mov dx, MY8255_B
    out dx, al
;1
    call DELAY
    ;RET_DELAY:
    mov al, 06H
    mov dx, MY8255_B
    out dx, al
;0
    call DELAY
    ;RET_DELAY:
    mov al, 3fH
    mov dx, MY8255_B
    out dx,al
    
    jmp ENDG
    
    DELAY:
    ;PUSH CX
    MOV CX,0ffffh
    LOOP_d:
    DEC CX 
    CMP CX, 0
    JGE LOOP_d
    ;POP CX
    RET
    
    ENDG:
    MOV AH, 4CH
    INT 21H
CODE ENDS
    END START