DATA    SEGMENT
    ARR DW -1, 0, 1, 2, 3
        DW 4, 5, 6, 7, -2
    ARR_G DW 10 DUP(?)
DATA    ENDS
STACK   SEGMENT STACK
STACK   ENDS
CODE    SEGMENT
        ASSUME DS: DATA, CS: CODE
START:  MOV AX, DATA ; 放置数据段
        MOV DS, AX

        MOV SI, OFFSET ARR_G ; 初始化
        MOV BX, OFFSET ARR
        MOV CX, 10

        ;JUDGE_1: 
        ;CMP [BX], 0 
        ;JGE JUDGE_2
        ;INC BX
        ;DEC CX 
        ;CMP CX, 0
        ;JNZ JUDGE_1
        ;JMP END_G

        JUDGE_2:
        CMP BYTE PTR [BX], 1
        JGE ENTER
        INC BX
        DEC CX 
        LOOP JUDGE_2
        ;CMP CX, 0
        ;JNZ JUDGE_2
        JMP END_G

        ENTER:
        MOV DX, DS:[BX];
        MOV [SI], DX ;AMS
        INC SI
        INC BX
        DEC CX
        CMP CX, 0
        JNZ JUDGE_2
        JMP END_G

        END_G:
        MOV AH, 4CH
        INT 21H
CODE    ENDS
        END START