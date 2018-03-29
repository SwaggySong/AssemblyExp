;---------------------------------------------------------
DATA	SEGMENT  USE16
BUF1	DB  0,1,2,3,4,5,6,7,8,9
BUF2 	DB  10  DUP(0)
BUF3	DB  10  DUP(0)
BUF4	DB  10  DUP(0)
STOP_MESSAGE DB 'Press any key to begin!$',0AH,0DH
DATA ENDS 
;----------------------------------------------------------
STACK	SEGMENT STACK
	DB	200 DUP(0)
STACK	ENDS
;-------------------------------------------------------
CODE	SEGMENT  USE16
	ASSUME CS:CODE,DS:DATA,SS:STACK
START: MOV  AX,DATA
MOV  DS, AX
			MOV  SI, OFFSET BUF1
			MOV  DI, OFFSET BUF2
			MOV  BX, OFFSET BUF3
			MOV  BP, OFFSET BUF4
			MOV  CX, 10

			LEA DX,STOP_MESSAGE
			MOV AH,9;DOS9号调用
			INT 21H

			MOV AH,1;DOS1号调用
			INT 21H

 LOOPA: 	MOV  AL, [SI]
			MOV  [DI], AL
			INC   AL
			MOV  [BX], AL
			ADD  AL, 3
			MOV  DS: [BP],AL
			INC   SI
			INC   DI
			INC   BP
			INC 	  BX
			DEC  CX
			JNZ 	  LOOPA

			MOV  AH, 4CH
			INT   21H
CODE	ENDS
		END START
