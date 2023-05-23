DATA	SEGMENT
        ARR DW -1, 0, 1, 2, 3,
            DW 0, -2, 3, -3, 1
        ARR_P DW 10 DUP(?)
        NUM_P DB 0
        ARR_N DW 10 DUP(?)
        NUM_N DB 0
DATA    ENDS
CODE    SEGMENT
        ASSUME CS: CODE, DS: DATA
        START:
        MOV AX, DATA
        MOV DS, AX

        MOV CX, 10
        MOV SI, OFFSET ARR
        LEA DI, ARR_P
        LEA BX, ARR_N

        LOOP:
        CMP [SI], 0
        JNZ POSITIVE
        MOX AX, [SI]
        MOV [BX], AX
        INC BX
        INC NUM_N
        INC SI
        DEC CX
        CMP CX, 0
        JNZ LOOP
        JMP END_C

        POSITIVE:
        MOV AX, [SI]
        MOV [DI], AX
        INC NUM_P
        INC DI 
        INC SI
        DEC CX
        CMP CX, 0 
        JNZ LOOP
        JMP END_C
        

        END_C:
        XOR AX, AX
        MOV DL, NUM_P
        MOV AH, 02H
        INT 21H

        MOV DL, NUM_N
        MOV AH
