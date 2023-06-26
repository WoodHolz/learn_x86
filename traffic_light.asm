IOY0           EQU 0600H       ; 8255地址，实验箱上为0600H，仿真系统上为0200H
IOY1           EQU 0640H       ; 8255地址，实验箱上为0640H，仿真系统上为0400H
MY8255_A       EQU IOY0+00H*2  ; 8255A口地址
MY8255_B       EQU IOY0+01H*2  ; 8255B口地址
MY8255_C       EQU IOY0+02H*2  ; 8255C口地址
MY8255_MODE    EQU IOY0+03H*2  ; 8255模式设置端口地址
MY8253_A       EQU IOY1+00H*2  ; 8253A口地址
MY8253_MODE    EQU IOY1+03H*2  ; 8253模式设置端口地址

DATA SEGMENT
    NUMDISPLAY DB 0FDH,0FEH    ; 用于控制数显管显示数字的两个字节
    NUMS       DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH ; 显示数字 0 到 9 的数码管值
    CLIGHTXR   DB 30H,50H      ; 水平交通灯的红灯和黄灯的控制值
    CLIGHTYR   DB 84H,88H      ; 垂直交通灯的红灯和黄灯的控制值
DATA ENDS

STACKS SEGMENT
    DW 128 DUP(0)
STACKS ENDS

; 宏，用于在交通灯上显示所选的灯光颜色。接受表示颜色的参数（CHOOESLIGHT）并将其输出到相应的 I/O 端口
CLIGHT_DISPLAY MACRO CHOOESLIGHT
    MOV DX,MY8255_B
    MOV AL,CHOOESLIGHT
    OUT DX,AL
ENDM

CODES SEGMENT
    ASSUME      CS:CODES,DS:DATA,SS:STACKS    ;指定程序中的代码段、数据段和堆栈段
    START:               
    ; 设置数据段（DS）和堆栈段（SS）寄存器
    MOV    AX,DATA         ; 将DATA的值移动到AX寄存器
    MOV    DS,AX           ; 将AX的值移动到DS寄存器
    MOV    AX,STACKS       ; 将STACKS的值移动到AX寄存器
    MOV    SS,AX           ; 将AX的值移动到SS寄存器
    MOV    SP,128          ; 将值128移动到SP寄存器（设置堆栈指针）

    ; 设置8255模式
    MOV    DX,MY8255_MODE  ; 将MY8255_MODE的地址移动到DX寄存器
    MOV    AL,88H          ; 将值88H移动到AL寄存器
    OUT    DX,AL           ; 将AL寄存器中的值输出到DX指定的端口

    ; 设置8253模式
    MOV    DX,MY8253_MODE  ; 将MY8253_MODE的地址移动到DX寄存器
    MOV    AL,30H          ; 将值30H移动到AL寄存器
    OUT    DX,AL           ; 将AL寄存器中的值输出到DX指定的端口

    CROSSXRED:                  ; 主循环       
    ; 水平红灯亮，竖直绿灯亮：
    MOV    BX,OFFSET CLIGHTXR   ; 将CLIGHTXR的偏移地址移动到BX寄存器
    CLIGHT_DISPLAY [BX]         ; 显示BX指向的CLIGHTXR内存位置的信号灯状态，即水平红灯，竖直绿灯
    MOV    CX,11                ; 将值11移动到CX寄存器，作为倒计时开始
    CALL   CHANGE               ; 调用CHANGE子程序进行倒计时

    ; 水平红灯亮，竖直黄灯亮：
    MOV    BX,OFFSET CLIGHTXR   ; 将CLIGHTXR的偏移地址移动到BX寄存器
    CLIGHT_DISPLAY [BX+1]       ; 显示BX+1指向的CLIGHTXR内存位置的信号灯状态，即水平红灯，竖直黄灯
    MOV    CX,2                 ; 将值2移动到CX寄存器，作为倒计时开始
    CALL   CHANGE               ; 调用CHANGE程序进行倒计时

    ; 水平绿灯亮，竖直红灯亮：
    MOV    BX,OFFSET CLIGHTYR   ; 将CLIGHTYR的偏移地址移动到BX寄存器
    CLIGHT_DISPLAY [BX]         ; 显示BX指向的CLIGHTYR内存位置的信号灯状态，即水平绿灯，竖直红灯
    MOV    CX,11                ; 将值11移动到CX寄存器
    CALL   CHANGE               ; 调用CHANGE子程序进行倒计时

    ; 水平黄灯亮，竖直红灯亮：
    MOV    BX,OFFSET CLIGHTYR   ; 将CLIGHTYR的偏移地址移动到BX寄存器
    CLIGHT_DISPLAY [BX+1]       ; 显示BX+1指向的CLIGHTYR内存位置的信号灯状态，即水平黄灯，竖直绿灯
    MOV    CX,2                 ; 将值2移动到CX寄存器
    CALL   CHANGE               ; 调用CHANGE子程序进行倒计时

    JMP    CROSSXRED            ; 无条件跳转到CROSSXRED标签，即代码的开头重新执行

    CHANGE:              
        PUSH    AX              ; 将AX寄存器的值压入栈
        PUSH    BX              ; 将BX寄存器的值压入栈
        PUSH    CX              ; 将CX寄存器的值压入栈
        PUSH    DX              ; 将DX寄存器的值压入栈
        
    LOOP1:               
        CALL    INIF_8254COUNTER      ; 调用INIF_8254COUNTER子程序，初始化计数器8254

    ; 计数延时的起始点  
    L01:         
        CALL    COUNT_NUMBER_DISPLAY  ; 调用COUNT_NUMBER_DISPLAY子程序，显示计数器的值
        MOV     DX,MY8255_C           ; 将MY8255_C的值存入DX寄存器
        IN      AL,DX                 ; 从端口DX读取数据到AL寄存器
        MOV     BX,AX                 ; 将AX寄存器的值存入BX寄存器
        AND     AL,20H                ; 将AL寄存器与20H进行按位与操作
        CMP     AL,20H                ; 比较AL寄存器的值与20H，如果输入端口的状态中的第 5 位是 1，表示水平交通灯需要改变
        JNE     CMPAL1                ; 如果不相等，跳转到CMPAL1标签
        MOV     BX,OFFSET CLIGHTXR    ; 将CLIGHTXR的地址存入BX寄存器
        CLIGHT_DISPLAY [BX]           ; 调用CLIGHT_DISPLAY函数，显示CLIGHTXR的值
        PUSH    CX                    ; 将CX寄存器的值压入栈
        MOV     CX,99                 ; 将CX寄存器设置为99

    ; 如果水平交通灯需要改变，则进入的分支，通过循环计数延时来等待一段时间，并且重新检测输入端口的状态，以确定是否需要继续改变交通灯
    L1:                    
        CALL    COUNT_NUMBER_DISPLAY  ; 调用COUNT_NUMBER_DISPLAY子程序，显示计数器的值
        MOV     DX,MY8255_C           ; 将MY8255_C的值存入DX寄存器
        IN      AL,DX                 ; 从端口DX读取数据到AL寄存器
        AND     AL,20H                ; 将AL寄存器与20H进行按位与操作
        CMP     AL,20H                ; 比较AL寄存器的值与20H
        JE      L1                    ; 如果相等，跳转到L1标签
        POP     CX                    ; 弹出栈顶的值到CX寄存器
        JMP     CROSSXRED             ; 无条件跳转到CROSSXRED标签
    ; 如果水平交通灯不需要改变，则进入的分支，在这里将会跳转回CROSSXRED，进入交通灯变化的循环
    CMPAL1:              
        MOV     AX,BX                 ; 将BX寄存器的值存入AX寄存器
        AND     AL ,40H               ; 将AL寄存器与40H进行按位与操作
        CMP     AL,40H                ; 比较AL寄存器的值与40H
        JNE     CMPAL2                ; 如果不相等，跳转到CMPAL2标签
        MOV     BX,OFFSET CLIGHTYR    ; 将CLIGHTYR的地址存入BX寄存器
        CLIGHT_DISPLAY [BX]           ; 调用CLIGHT_DISPLAY函数，显示CLIGHTYR的值
        PUSH     CX                   ; 将CX寄存器的值压入栈
        MOV      CX,99                ; 将CX寄存器设置为99

    ; 如果垂直交通灯需要改变，则进入的分支，通过循环计数延时来等待一段时间，并且重新检测输入端口的状态，以确定是否需要继续改变交通灯      
    L2:      
        CALL     COUNT_NUMBER_DISPLAY  ; 调用COUNT_NUMBER_DISPLAY子程序，显示计数器的值
        MOV      DX,MY8255_C           ; 将MY8255_C的值存入DX寄存器
        IN       AL,DX                 ; 从端口DX读取数据到AL寄存器
        AND      AL,40H                ; 将AL寄存器与40H进行按位与操作
        CMP      AL,40H                ; 比较AL寄存器的值与40H
        JE       L2                    ; 如果相等，跳转到L2标签
        POP      CX                    ; 弹出栈顶的值到CX寄存器
        JMP      CROSSXRED             ; 无条件跳转到CROSSXRED标签

    ; 如果垂直交通灯不需要改变，则进入的分支，在这里将会跳转回L01，继续循环计数延时和交通灯的变化过程
    CMPAL2:             
        MOV      AX,BX                 ; 将BX寄存器的值存入AX寄存器
        AND      AL,80H                ; 将AL寄存器与80H进行按位与操作
        CMP      AL,80H                ; 比较AL寄存器的值与80H
        JE       L02                   ; 如果相等，跳转到L02标签
        JMP      L01                   ; 无条件跳转到L01标签

    ; 垂直交通灯变化结束后的分支，通过减少计数器的值来控制循环的次数，并在计数器减为负数（大于等于 0）后跳转回CROSSXRED，即重新开始水平和垂直交通灯的变化过程   
    L02:       
        DEC      CX                    ; 将CX寄存器的值减1
        JNS      LOOP1                 ; 如果结果为非负数，跳转到LOOP1标签
        POP      DX                    ; 弹出栈顶的值到DX寄存器
        POP      CX                    ; 弹出栈顶的值到CX寄存器
        POP      BX                    ; 弹出栈顶的值到BX寄存器
        POP      AX                    ; 弹出栈顶的值到AX寄存器
        RET                            ; 返回

    ; 初始化计数器
    INIF_8254COUNTER:    
        PUSH     DX                    ; 将DX寄存器的值压入栈
        PUSH     AX                    ; 将AX寄存器的值压入栈
        MOV      DX,MY8253_A           ; 将MY8253_A的值存入DX寄存器
        MOV      AL,00H                ; 将AL寄存器设置为00H
        OUT      DX,AL                 ; 输出AL寄存器的值到端口DX
        MOV      AL,48H                ; 将AL寄存器设置为48H
        OUT      DX,AL                 ; 输出AL寄存器的值到端口DX
        POP      AX                    ; 弹出栈顶的值到AX寄存器
        POP      DX                    ; 弹出栈顶的值到DX寄存器
        RET                            ; 
        
    ; 根据传入的数字来显示在数码管上
    COUNT_NUMBER_DISPLAY:  
        PUSH     AX                    ; 将AX寄存器的值压入栈
        PUSH     CX                    ; 将CX寄存器的值压入栈
        MOV      AX,CX                 ; 将CX寄存器的值存入AX寄存器
        MOV      CL,10                 ; 将CL寄存器设置为10
        DIV      CL                    ; 将AX寄存器的值除以CL寄存器的值，商存入AL寄存器，余数存入AH寄存器
        MOV      CH,00H                ; 将CH寄存器的值设置为00H
        MOV      CL,AH                 ; 将AH寄存器的值存入CL寄存器
        PUSH     CX                    ; 将CX寄存器的值压入栈
        MOV      CH,00H                ; 将CH寄存器的值设置为00H
        MOV      CL,AL                 ; 将AL寄存器的值存入CL寄存器
        PUSH     CX                    ; 将CX寄存器的值压入栈
        MOV      DX,MY8255_C           ; 将MY8255_C的值存入DX寄存器
        MOV      BX,OFFSET NUMDISPLAY  ; 将NUMDISPLAY的地址存入BX寄存器
        MOV      AL,[BX]               ; 将BX寄存器指向的地址的值存入AL寄存器
        OUT      DX,AL                 ; 输出AL寄存器的值到端口DX
        MOV      DX,MY8255_A           ; 将MY8255_A的值存入DX寄存器
        MOV      BX,OFFSET NUMS        ; 将NUMS的地址存入BX寄存器
        POP      SI                    ; 弹出栈顶的值到SI寄存器
        MOV      AL,[BX+SI]            ; 将BX寄存器指向的地址加上SI寄存器的值的偏移量，对应的值存入AL寄存器
        OUT      DX,AL                 ; 输出AL寄存器的值到端口DX
        MOV      AL,00H                ; 将AL寄存器设置为00H
        OUT      DX,AL                 ; 输出AL寄存器的值到端口DX
        MOV      DX,MY8255_C           ; 将MY8255_C的值存入DX寄存器
        MOV      BX,OFFSET NUMDISPLAY  ; 将NUMDISPLAY的地址存入BX寄存器
        MOV      AL, [BX+1]            ; 将BX寄存器指向的地址加1的值存入AL寄存器
        OUT      DX,AL                 ; 输出AL寄存器的值到端口DX
        MOV      DX,MY8255_A           ; 将MY8255_A的值存入DX寄存器
        MOV      BX,OFFSET NUMS        ; 将NUMS的地址存入BX寄存器
        POP      SI                    ; 弹出栈顶的值到SI寄存器
        MOV      AL,[BX+SI]            ; 将BX寄存器指向的地址加上SI寄存器的值的偏移量，对应的值存入AL寄存器
        OUT      DX,AL                 ; 输出AL寄存器的值到端口DX
        MOV      AL,00H                ; 将AL寄存器设置为00H
        OUT      DX,AL                 ; 输出AL寄存器的值到端口DX
        POP      CX                    ; 弹出栈顶的值到CX寄存器
        POP      AX                    ; 弹出栈顶的值到AX寄存器
        RET                            ; 返回

        MOV      AH,4CH                ; 将程序的返回值设置为0
        INT      21H                   ; 然后通过软中断21H（interrupt 21H）来终止程序的执行
CODES ENDS
END START