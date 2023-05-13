DATA SEGMENT
    X   DB  ?
    ;Y   DB  ?
    Z   DB  ?
DATA ENDS
CD SEGMENT
    ASSUME CS: CD, DS: DATA
START:

    MOV AX, DATA ; load the segment
    MOV DS, AX

    MOV AH, 01H ; input the first data
    INT 21H
    MOV X, AL

    MOV DL, 0DH
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH
    MOV AH, 02H
    INT 21H

    MOV AH, 01H ; input the second data
    INT 21H
    ;MOV Y, AL 

    XOR AH, AH ; average
    ADD AL, X
    SHR AX, 1
    MOV Z, AL 

    MOV DL, 0DH
    MOV AH, 02H
    INT 21H
    MOV DL, 0AH
    MOV AH, 02H
    INT 21H

    MOV DL, Z
    ADD DL, 30H
    MOV AH, 02H
    INT 21H

    MOV AH, 4CH
    INT 21H
CD ENDS
    END START