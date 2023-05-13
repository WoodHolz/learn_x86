DATA    SEGMENT
        INFOR1 DB "please Input the first data(<10):$"
        INFOR2 DB 0AH, 0DH, "input the second data(<10):$"
        INFOR3 DB 0AH, 0DH, "The result is:$"
DATA    ENDS
;stack part?
DATA   SEGMENT STACK
        ;DW ?
DATA   ENDS
CODE    SEGMENT
        ASSUME CS: CODE, DS: DATA
START:  MOV AX, DATA
        MOV DS, AX

        ; show INFOR1
        MOV DX, OFFSET INFOR1
        MOV AH, 09H ; call the 09 func
        INT 21H
        ; END

        ; get the first data
        MOV AH, 01H ; call the 01 func
        INT 21H
        SUB AL, 30H
        ; END

        MOV BL, AL

        ; show INFOR2
        MOV DX, OFFSET INFOR2
        MOV AH, 09H ; call the 09 func
        INT 21H
        ; END

        ; get the second data
        MOV AH, 01H ; call the 01 func
        INT 21H
        SUB AL, 30H
        ; END

        ; sum
        XOR AH, AH ; clear the AH 
        ADD AL, BL ; EMMMMM
        AAA
        ; end

        PUSH AX

        ; 1:show INFOR3
        MOV DX, OFFSET INFOR3
        MOV AH, 09H ; call the 09 func
        INT 21H
        ; end

        ; 2:enter(CRLF) with int21h
        ;MOV DL, 0DH
        ;MOV AH, 02H
        ;INT 21H
        ;MOV DL, 0AH
        ;MOV AH, 02H
        ;INT 21H
        ; end

        ; 3: enter(CRLF) with int10h
        ;MOV AL, 0DH
        ;MOV AH, 0EH
        ;INT 10H
        ;MOV AL, 0AH
        ;MOV AH, 0EH
        ;INT 10H
        ; end

        POP AX
        PUSH AX

        ; show the answer
        ;PUSH AX
        MOV DL, AH
        ADD DL, 30H
        MOV AH, 02H ; call the 02 func
        INT 21H
        POP AX
        MOV DL, AL
        ADD DL, 30H
        MOV AH, 02H ; call the 02 func
        INT 21H
        ; END

        MOV AH, 4CH
        INT 21H
CODE    ENDS
        END START