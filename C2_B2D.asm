;2021.11
;人工智能与自动化学院微机原理实验
;实验二__四字节十六进制数转十进制数

EXTRN InitKeyDisplay:NEAR, Display8:NEAR, GetKey:NEAR
EXTRN F1:BYTE
_STACK SEGMENT STACK
DW 1000 DUP(?)
_STACK ENDS

_DATA	SEGMENT  WORD  PUBLIC 'DATA'
BUFFER	DB 8 DUP(?)
_DATA	ENDS

CODE	SEGMENT
START	PROC	NEAR
	ASSUME	CS:CODE, DS:_DATA, SS:_STACK
	MOV	AX, _DATA
	MOV	DS,AX
	MOV 	ES,AX
	NOP
	CALL	InitKeyDisplay    ;对键盘、数码管扫描控制器8255初始化
	MOV	F1,0              ;先清除显示，再接收键输入 

START1:	LEA	DI, BUFFER
	MOV	CX, 8              ;按键次数
	CALL	GetKey            ;得到4字节十六进制数
	MOV	F1, 1              ;接收到第一个键，才清除显示
	MOV	SI, WORD PTR BUFFER
	MOV	DI, WORD PTR BUFFER + 2
	CALL	B4toD4            ;转换成十进制数
	LEA	DI, BUFFER         ;存放显示结果
	CALL	B1toB2            ;低位
	MOV	AL, AH
	CALL	B1toB2
	MOV	AL, BL
	CALL	B1toB2
	MOV 	AL, BH
	CALL	B1toB2
	LEA   	SI, BUFFER+7
	MOV   	CX, 7
	CALL  	BlackDisplay      ;将高位0消隐
	LEA    	SI, BUFFER
	CALL   	Display8
	JMP    	START1
;将一个字节压缩BCD码转换成二个字节非压缩BCD码 
	B1toB2	PROC	NEAR
	PUSH   	AX
	AND    	AL,0FH
	STOSB
	POP   	AX
	AND    	AL,0F0H
	ROR   	AL,4
	STOSB
	RET
B1toB2	ENDP
BlackDisplay	 PROC	NEAR
	STD
	MOV	DI,SI
BlackDisplay1:   LODSB                            ;将高位0消隐 
	CMP	AL,0
	JNZ	Exit
	MOV    	AL,10H
	STOSB
	LOOP   	BlackDisplay1
Exit:	CLD
	RET
BlackDisplay	ENDP
;四字节十六进制数转十进制数：DISI为十六进制，BXAX为压缩BCD码 
B4toD4	PROC	NEAR
	XOR    	AX,AX
	XOR    	BX,BX
	MOV   	CX,32
B4toD4_1: 	
	RCL	SI,1
	RCL	DI,1
	ADC	AL,AL
	DAA
	XCHG	AL,AH
	ADC  	AL,AL
	DAA
	XCHG   	AL,BL
	ADC    	AL,AL
	DAA
	XCHG   	AL,BH
	ADC   	AL,AL
	DAA
	XCHG   	AL,BH
	XCHG   	AL,BL
	XCHG  	AL,AH
	LOOP  	B4toD4_1 
	RET
B4toD4	ENDP

START	ENDP
CODE 	ENDS
	END	START


