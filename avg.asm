DATA SEGMENT
    ;X   DB  ?
    ;Y   DB  ?
    ;Z   DB  ?
DATA ENDS
STACK SEGMENT STACK
STACK ENDS
CD SEGMENT
    ASSUME CS: CD, DS: DATA
START:

    MOV AX, DATA ; load the segment
    MOV DS, AX

    MOV AH, 01H ; input the first data
    INT 21H
    sub al, 30H
    MOV BL, AL

    MOV DL, 0DH
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH
    MOV AH, 02H
    INT 21H

    MOV AH, 01H ; input the second data
    INT 21H
    sub al, 30h ; 啊啊啊忘了减30h :-( 键盘输入的是ascii码！！！
    ;MOV Y, AL 

    XOR AH, AH ; average
    ADD AL, BL
    ;adc AH, 0
    SHR AX, 1
    MOV BL, AL 

    MOV DL, 0DH
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH
    MOV AH, 02H
    INT 21H

    MOV DL, BL
    ADD DL, 30H
    MOV AH, 02H
    INT 21H

    MOV AH, 4CH
    INT 21H
CD ENDS
    END START