DATA    SEGMENT
        a DB ?
        ;b DB ?
        INFOR_1 DB "Input the first data:$"
        INFOR_2 DB 0AH, 0DH, "Input the second data:$"
        INFOR_3 DB 0AH, 0DH, "The result is:$"
DATA    ENDS
STACK   SEGMENT STACK
STACK   ENDS
CODE    SEGMENT 
        ASSUME CS: CODE, DS: DATA
START:  
        MOV AX, DATA
        MOV DS, AX 

        MOV DX, OFFSET INFOR_1
        MOV AH, 09H
        INT 21H

        MOV AH, 01H
        INT 21H
        SUB AL, 30H
        MOV a, AL

        MOV DX, OFFSET INFOR_2
        MOV AH, 09H
        INT 21H

        MOV AH, 01H
        INT 21H
        SUB AL, 30H
        ;MOV b, AL

        ;MOV AX, 0 
        MUL a ; a * b   
        ;MOV BX, AX
        PUSH AX

        ; 显示
        MOV DX, OFFSET INFOR_3
        MOV AH, 09H
        INT 21H

        POP AX
        CMP AX, 9 ; 判断      
        JGE NEXT
        ADD AL, 30H 
        MOV DL, AL
        MOV AH, 02H
        INT 21H
        JMP ENDCODE


        NEXT: 
        PUSH AX
        MOV CL, 8
        RCR AX, CL
        AND AX, 0FH
        ADD AL, 30H
        MOV DL, AL
        MOV AH, 02H
        INT 21H
        
        POP AX
        AND AX, 0FH
        ADD AL, 30H
        MOV DL, AL
        MOV AH, 02H
        INT 21H
        
        JMP ENDCODE

        ENDCODE:
        MOV AH, 4CH
        INT 21H
CODE    ENDS
        END START 