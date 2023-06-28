IOYO EQU 0600H
MY_8255_A EQU IOYO+00h*2
MY_8255_B EQU IOYO+01h*2
MY_8255_C EQU IOYO+02h*2
MY_8255_MODE EQU IOYO+03h*2

DSEG    SEGMENT 'DATA'
    TAL DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH,77H,7CH,39H,5EH,79H,71H
DSEG    ENDS
CSEG    SEGMENT
assume  cs:CSEG
START:
        MOV     AX,DSEG
        MOV     DS,AX
        MOV AL,10010000B
        MOV DX,MY_8255_MODE
        OUT DX,AL
        
again:  mov dx,MY_8255_A
        in al,dx
        mov dx,MY_8255_B
        out dx,al
        and al,0fh
        mov bx,offset tal
        xlat
        mov dx,MY_8255_C
        out dx,al
        jmp again
   
END     START