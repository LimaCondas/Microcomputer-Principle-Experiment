Con_8255    EQU     0273H           ;8255控制口
PC_8255     EQU     0272H           ;8255PC口
_STACK      SEGMENT     STACK
    DW      100         DUP(?)
_STACK      ENDS
CODE        SEGMENT
START       PROC        NEAR
ASSUME      CS:CODE,    SS:_STACK
    MOV     DX,     Con_8255
    MOV     AL,     80H
    OUT     DX,     AL              ;8255初始化,PC口作输出用
    MOV     DX,     PC_8255
    MOV     AL,     0
START1:     
    OUT     DX,     AL
    CALL    Delay
    INC     AL
    JMP     START1
Delay       PROC    NEAR            ;延时
Delay1:     
    XOR     CX,     CX
    LOOP    $
RET
Delay       ENDP
START       ENDP
CODE        ENDS
END         START