IOY0           EQU 0200H;此为仿真系统端口地址，实验箱上为0600H
IOY1           EQU 0400H;此为仿真系统端口地址，实验箱上为0640H
MY8255_A       EQU IOYO+00H*2
MY8255_B       EQU IOYO+01H*2
MY8255_C       EQU IOYO+02H*2
MY8255_MODE    EQU IOY0+03H*2
MY8253_A       EQU IOY1+00H*2
MY8253_MODE    EQU IOY1+03H*2

DATA SEGMENT
    NUMDISPLAY DB OFDH,OFEH
    NUMS     DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH
    CLIGHTXR  DB 30H,50H
    CLIGHTYR  DB 84H,88H
DATA ENDS

STACKS SEGMENT
    DW  128 DUP(0)
STACKS ENDS

CLIGHT_DISPLAY MACRO CHOOESLIGHT
    MOV DX,MY8255_B
    MOV AL,CHOOESLIGHT
    OUT DX,AL
ENDM

CODES SEGMENT
    ASSUME   CS:CODES,DS:DATA,SS:STACKS
    START:
    ; Set SEGMENT
        MOV    AX,DATA
        MOV    DS,AX
        MOV    AX,STACKS
        MOV    SS,AX
        MOV    SP,128
    ; Set 8255 Mode
        MOV    DX,MY8255_MODE
        MOV    AL,88H
        OUT    DX,AL
    ; Set 8253 Mode
        MOV    DX,MY8253_MODE
        MOV    AL,30H
        OUT    DX,AL

    CROSSXRED:
    ;CROSSYGREEN:
        MOV    BX,OFFSET CLIGHTXR
        CLIGHT_DISPLAY [BX]

        MOV    CX,11

        CALL   CHANGE
    ;CROSSYYELLOW:
        MOV    BX,OFFSET CLIGHTXR
        CLIGHT_DISPLAY [BX+1]
        MOV    CX,2

        CALL   CHANGE
    ;CROSSYRED
    ;CROSSXGREEN
        MOV     BX,OFFSET CLIGHTYR
        CLIGHT_DISPLAY [BX]
        MOV    CX,11

        CALL   CHANGE
    ;CROSSXYELLOW
        MOV    BX,0FFSET CLIGHTYR
        CLIGHT_DISPLAY [BX+1]
        MOV    CX,2

        CALL   CHANGE

        JMP    CROSSXRED


        CHANGE:
            PUSH    AX
            PUSH    BX
            PUSH    CX
            PUSH    DX
        LOOP1:
            CALL    INIF_8254COUNTER
        L01:
            CALL    COUNT_NUMBER_DISPLAY
            
            MOV    DX,MY8255_C
            IN     AL,DX
            MOV    BX,AX

            AND    AL,20H
            CMP    AL,20H
            JNE    CMPAL1	
            MOV    BX,OFFSET CLIGHTXR
            CLIGHT_DISPLAY [BX]
            PUSH   CX
            MOV    CX,99
        L1:
            CALL    COUNT_NUMBER_DISPLAY
            MOV     DX,MY8255_C
            IN     AL,DX
            AND    AL,20H
            CMP    AL,20H
            JE     L1
            POP    CX
            JMP    CROSSXRED
        
        CMPAL1:
            MOV    AX,BX
            AND    AL ,40H
            CMP    AL,40H
            JNE    CMPAL2
            MOV    BX,OFFSET CLIGHTYR
        CLIGHT_DISPLAY [BX]
            PUSH   CX
            MOV    CX,99
        L2:
            CALL   COUNT_NUMBER_DISPLAY
            MOV    DX,MY8255_C
            IN     AL,DX
            AND    AL,40H
            CMP    AL,40H
            JE     L2
            POP    CX
            JMP    CROSSXRED
        CMPAL2:
            MOV    AX,BX
            AND    AL,80H
            CMP    AL,80H
            JE     L02
            JMP    L01
        L02:
            DEC    CX
            JNS    LOOP1
        
            POP    DX
            POP    CX
            POP    BX
            POP    AX
            RET
        
        COUNT_NUMBER_DISPLAY:
            PUSH   AX
            PUSH   CX
            MOV    AX,CX
            MOV    CL,10
            DIV    CL
            MOV    CH,00H
            MOV    CL,AH
            PUSH   CX
            MOV    CH,00H
            MOV    CL,AL
            PUSH   CX



        COUNT_NUMBER_DISPLAY:
            PUSH   AX
            PUSH   CX
            MOV    AX,CX
            MOV    CL,10
            DIV    CL
            MOV    CH,00H
            MOV    CL,AH
            PUSH   CX
            MOV    CH,OOH
            MOV    CL,AL
            PUSH   CX
            
            MOV    DX,MY8255_C
            MOV    BX,OFFSET NUMDISPLAY 
            MOV    AL,[BX]
            OUT    DX,AL
            MOV    DX,MY8255_A
            
            MOV    BX,OFFSET NUMS
            POP    SI
            MOV    AL,[BX+SI]
            OUT    DX,AL
            
            MOV    AL,OOH
            OUT    DX,AL

            MOV    DX,MY8255_C
            MOV    BX,OFFSET NUMDISPLAY 
            MOV    AL, [BX+1]
            OUT    DX,AL
            
            MOV    DX,MY8255_A
            MOV    BX,OFFSET NUMS
            POP    SI  
            MOV    AL,[BX+SI]
            OUT    DX,AL
            
            MOV    AL,0OH
            OUT    DX,AL
            
            POP    CX
            POP    AX
            RET



CODE ENDS
END START