DATA SEGMENT
        BUF1 DB 0A8H, 9FH, 0B4H, 25H # 注意16位数首位是字母必须开头加‘0’
        BUF2 DB 78H, 0FFH, 0D3H, 5CH
        BUF3 DB 4 DUP(?)
DATA ENDS
CODE SEGMENT
ASSUME CS: CODE, DS: DATA
START:  MOV AX, DATA
        MOV AX, DATA
        MOV DS, AX
        LEA SI, BUF1
        LEA DI, BUF2
        MOV BX, OFFSET BUF3
        MOV CX, 4
        CLC             ;CF=0, STC CF=1
NEXT:   MOV AL, [SI]
        MOV DL, [DI]
        ADD AL, DL
        MOV [BX], AL
        INC SI
        INC DI
        INC BX
        DEC CX
        JNC NEXT        ;ZF=0

        MOV AH, 4CH
        INT 21H
CODE ENDS
END START
