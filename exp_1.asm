_STACK SEGMENT STACK
       DW 100 DUP(?)
_STACK ENDS
_DATA SEGMENT WORD PUBLIC'DATA'
_DATA ENDS
CODE SEGMENT
START PROC NEAR
      ASSUME CS:CODE,DS:_DATA,SS:_STACK
      MOV AX,8000H
      MOV DS,AX
      MOV ES,AX
      NOP
      MOV CX,100H
      MOV SI,3000H
      MOV DI,6000H
      CALL Move
      MOV CX,100H
      MOV SI,3000H
      MOV DI,6000H
      CLD
      REPE CMPSB
      JNE ERROR
TRUE: JMP $
ERROR:JMP $
Move  PROC NEAR
      CLD
      CMP SI,DI
      JZ Return
      JNB Move1
      ADD SI,CX
      DEC SI
      ADD DI,CX
      DEC DI
      STD
Move1:REP MOVSB
Return:RET
Move ENDP
START ENDP
CODE ENDS
END START       
