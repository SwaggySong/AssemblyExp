;--------------------------------------------------
DATA SEGMENT USE16
INPUT_NAME_MSG DB 0AH,0DH,'please input name:$'
INPUT_PASS_MSG DB 0AH,0DH,'please input password:$'
LOGIN_FAILED_MSG DB 0AH,0DH,'Login failed! Please input name and pwd again!$'
END_MSG DB 0AH,0DH,'end of program, press any key to continue$'
INPUT_GOODS_NAME_MSG DB 0AH,0DH,'please input the name of the goods:$'
INPUT_GOODS_NAME_AGAIN DB 0AH,0DH,'goods name input error,please input again:$'
in_name DB 10 DUP(0)
in_pwd DB 6 DUP(0)
goods_name DB 10 DUP(0)
PR1 DB 0
PR2 DB 0
APR DB 0
AUTH DB 0
COST1 DB 0;成本
PROFIT1 DB 0;利润
COST2 DB 0;成本
PROFIT2 DB ;利润
BNAME DB 'LONG JQ',3 DUP(0);老板姓名
BPASS DB 'NOPASS';密码
N EQU 30
SHOP1 DB 'SHOP1',0;网店名称，0结束
GA1 DB 'PEN',7 DUP(0)
    DW 35,56,70,25,?
GA2 DB 'BOOK',6 DUP(0)
    DW 12,30,25,5,?
GAN DB N-2 DUP('TEMP-VALUE',15,0,20,0,30,0,2,0,?,?)
SHOP2 DB 'SHOP1',0;网店名称，0结束
GB2 DB 'BOOK',6 DUP(0)
    DW 12,28,20,15,?
GB1 DB 'PEN',7 DUP(0)
    DW 35,50,30,24,?
GBN DB N-2 DUP('TEMP-VALUE',15,0,20,0,30,0,2,0,?,?)
DATA ENDS
;---------------------------------------------------
STACK SEGMENT STACK
        DB 200 DUP(0)
STACK ENDS
;---------------------------------------------------
CODE SEGMENT USE16
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:MOV AX,DATA
            MOV DS,AX

FUNCION1:MOV SI,0;计数器
            MOV CX,10;计数器
            LEA DX,INPUT_NAME_MSG
            MOV AH,9
            INT 21H
            LEA DX,in_name
            MOV AH,10
            INT 21H

            LEA DX,INPUT_PASS_MSG
            MOV AH,9
            INT 21H
            LEA DX,in_pwd
            MOV AH,10
            INT 21H

            CMP 0,in_name[SI+1]
            JE AUTH_FAIL

FUNCTION2:CMP in_name[SI],BNAME[SI]
            JNE PRINT_LOGIN_FAILED
            CMP in_pwd[SI],BPASS[SI]
            JNE PRINT_LOGIN_FAILED
            INC SI
            DEC CX
            JNZ FUNCTION2

AUTH_SUCCESS:MOV BH,1
            MOV BYTE PTR AUTH,BH
            JMP FUNCTION3

AUTH_FAIL:CMP 71H,in_name
            JE EXIT
            MOV BH,0
            MOV BYTE PTR AUTH,BH
            JMP FUNCTION3

PRINT_LOGIN_FAILED:LEA DX,LOGIN_FAILED_MSG
            MOV AH,9
            INT 21H
            JMP FUNCION1

FUNCTION3:LEA DX,INPUT_GOODS_NAME_MSG
            MOV AH,9
            INT 21H
            LEA DX,goods_name
            MOV AH,10
            INT 21H

            CMP 0DH,goods_name
            JE FUNCION1
            MOV BX,0
            JMP IS_GOODS

            IS_PEN:CMP goods_name[SI],GA1[SI]
            JNE IS_GOODS
            INC SI
            DEC CX
            JNZ IS_PEN
            MOV BYTE PTR goods_name[SI+1],'$'
            MOV AL,GA1[10];进货价
            IMUL GA1[14];AX现为cost1
            MOV COST1,AX
            MOV AL,GA1[12];销售价
            IMUL GA1[16];AX现为profit1
            MOV PROFIT1,AX
            MOV AL,GB1[10];进货价
            IMUL GB1[14];AX现为cost2
            MOV COST2,AX
            MOV AL,GB1[12];销售价
            IMUL GB1[16];AX现为profit2
            MOV PROFIT2,AX
            CMP AUTH,0
            JE FUNCTION3_4
            JMP FUNCTION3_3

            IS_BOOK:CMP goods_name[SI],GA2[SI]
            JNE IS_GOODS
            INC SI
            DEC CX
            JNZ IS_BOOK
            MOV BYTE PTR goods_name[SI+1],'$'
            MOV AL,GA2[10];进货价
            IMUL GA2[14];AX现为cost1
            MOV COST1,AX
            MOV AL,GA2[12];销售价
            IMUL GA2[16];AX现为profit1
            MOV PROFIT1,AX
            MOV AL,GB2[10];进货价
            IMUL GB2[14];AX现为cost2
            MOV COST2,AX
            MOV AL,GB2[12];销售价
            IMUL GB2[16];AX现为profit2
            CMP AUTH,0
            JE FUNCTION3_4
            JMP FUNCTION3_3

            IS_N:CMP goods_name[SI],GAN[SI]
            JNE IS_GOODS
            INC SI
            DEC CX
            JNZ IS_PEN
            MOV BYTE PTR goods_name[SI+1],'$'
            MOV AL,GAN[10];进货价
            IMUL GAN[14];AX现为cost1
            MOV COST1,AX
            MOV AL,GAN[12];销售价
            IMUL GAN[16];AX现为profit1
            MOV PROFIT1,AX
            MOV AL,GB1[10];进货价
            IMUL GB1[14];AX现为cost2
            MOV COST2,AX
            MOV AL,GB1[12];销售价
            IMUL GB1[16];AX现为profit2
            CMP AUTH,0
            JE FUNCTION3_4
            JMP FUNCTION3_3

            IS_GOODS:MOV SI,0;计数器
            MOV CX,10;计数器
            INC BX
            CMP BX,1
            JE IS_PEN
            CMP BX,2
            JE IS_BOOK
            CMP BX,3
            JE IS_N
            CMP BX,4
            JE FUNCTION3_1

FUNCTION3_1:LEA DX,INPUT_GOODS_NAME_AGAIN
            MOV AH,9
            INT 21H
            JMP FUNCTION3

FUNCTION3_3:;等级A
            ;JE GRADE_A
            ;B
            ;JE GRADE_B
            ;C
            ;JE GRADE_C
            ;D
            ;JE GRADE_D
            ;F
            ;JE GRADE_F
            
            GRADE_A:MOV DL,41H
            MOV AH,2
            INT 21H
            JMP FUNCION1

            GRADE_B:MOV DL,42H
            MOV AH,2
            INT 21H
            JMP FUNCION1

            GRADE_C:MOV DL,43H
            MOV AH,2
            INT 21H
            JMP FUNCION1

            GRADE_D:MOV DL,44H
            MOV AH,2
            INT 21H
            JMP FUNCION1

            GRADE_F:MOV DL,46H
            MOV AH,2
            INT 21H
            JMP FUNCION1

FUNCTION3_4:
            LEA DX,goods_name
            MOV AH,9
            INT 21H
            JMP FUNCION1

EXIT:
            LEA DX,END_MSG
            MOV AH,10
            INT 21H
            MOV AH,1
            INT 21H
            MOV AH,4CH
            INT 21H
CODE ENDS
            END START