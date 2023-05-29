DATA	SEGMENT
        ARR DW -1, 0, 1, 2, 3,
            DW 0, -2, 3, -3, 1
        ARR_P DW 10 DUP(?)
        NUM_P DB 0
        ARR_N DW 10 DUP(?)
        NUM_N DB 0
DATA    ENDS
stack   SEGMENT STACK
stack   ends
CODE    SEGMENT
        ASSUME CS: CODE, DS: DATA
        START:
        MOV AX, DATA
        MOV DS, AX

        MOV CX, 10
        MOV SI, OFFSET ARR
        LEA DI, ARR_P
        MOV BX, offset ARR_N

        LOOP_1:
        CMP BYTE PTR [SI], 0
        JNZ POSITIVE
        MOV DX, SI
        MOV DS:[BX], DX
        INC BX
        INC NUM_N
        INC SI
        DEC CX
        CMP CX, 0
        JNZ LOOP_1
        JMP END_C

        POSITIVE:
        MOV AX, [SI]
        MOV [DI], AX
        INC NUM_P
        INC DI 
        INC SI
        DEC CX
        CMP CX, 0 
        JNZ LOOP_1
        JMP END_C
        

        END_C: 
        ;MOV DL, 'num of positive:$'
        ;MOV AH, 09H
        ;INT 21H
        MOV DL, NUM_P
        ADD DL, 30H
        MOV AH, 02H
        INT 21H

        MOV DL, 0DH
        MOV AH, 02H
        INT 21H
        MOV DL, 0AH
        MOV AH, 02H
        INT 21H
        
        MOV DL, NUM_N
        ADD DL, 30H
        MOV AH, 02H
        INT 21H
        
        MOV AH, 4CH
        INT 21H
CODE    ENDS
        END START