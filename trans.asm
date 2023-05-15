DATA    SEGMENT
        INF1 DB 'Input a number(0-65535):$'
        IBUF DB 7, 0, 6 DUP(?)
DATA    ENDS
CODE    SEGMENT
        ASSUME CS: CODE, DS: DATA
START:  
        MOV AX, DATA
        MOV DS, AX

        MOV DX, OFFSET INF1
        MOV AH, 09H
        INT 21H
        
        MOV DX, OFFSET IBUF
        MOV AH, 0AH
        INT 21H

        MOV CL, IBUF + 1
        MOV CH, 0
        MOV SI, OFFSET IBUF + 2
        MOV AX, 0
AGAIN:  
        MOV DX, 10
        MUL DX
        AND BYTE PTR [SI], 0FH
        ADD AL, [SI]
        ADC AH, 0
        INC SI
        LOOP AGAIN

        MOV AH, 4CH
        INT 21H
CODE ENDS
    END START