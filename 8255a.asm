CODE SEGMENT
        ASSUME SC:CODE
START: 
        MOV DX,606H
        MOV AL,80H;A口选择00方式，B口0方式
        OUT DX,AL;送控制字
        MOV CL,80H ;赋初值
        MOV BL,1H ;赋初值
        
        AA1:
        MOV DX,600H 
        MOV AL,CL
        OUT DX,AL
        MOV DX,602H
        MOV AL,BL
        OUT DX,AL
        CALL DELAY ;延时作用
        ROL BL,1H  ;循环左移一位
        ROR CL,1H  ;循环右移一位
        JMP AA1
        
        DELAY:
        PUSH CX
        MOV CX,0FFFFH
        
        AA2:
        PUSH AX
        POP AX
        LOOP AA2
        POP CX
        RET
CODE ENDS
	END START
