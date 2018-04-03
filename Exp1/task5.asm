.386
;--------------------------------------------------
DATA SEGMENT USE16
in_name DB 11
        DB ?
        DB 11 DUP(0)
in_pwd DB 7
      DB ?
      DB 7 DUP(0)
goods_name DB 11
          DB ?
          DB 11 DUP(0)
PR1 DW 0
PR2 DW 0
APR DW 0
AUTH DB 0
COST1 DW 0;成本
PROFIT1 DW 0;利润
COST2 DW 0;成本
PROFIT2 DW 0;利润
BNAME DB 'LONG JQ',3 DUP(0);老板姓名
BPASS DB 'NOPASS';密码
N EQU 30
SHOP1 DB 'SHOP1',0;网店名称，0结束
GA1 DB 'PEN',7 DUP(0)
    DW 35,56,70,25,?
GA2 DB 'BOOK',6 DUP(0)
    DW 12,30,25,5,?
GAN DB N-2 DUP('TEMP-VALUE',15,0,20,0,30,0,2,0,?,?)
SHOP2 DB 'SHOP2',0;网店名称，0结束
GB2 DB 'BOOK',6 DUP(0)
    DW 12,28,20,15,?
GB1 DB 'PEN',7 DUP(0)
    DW 35,50,30,24,?
GBN DB N-2 DUP('TEMP-VALUE',15,0,20,0,30,0,2,0,?,?)
INPUT_NAME_MSG DB 0AH,0DH,'please input name:$'
INPUT_PASS_MSG DB 0AH,0DH,'please input password:$'
LOGIN_FAILED_MSG DB 0AH,0DH,'Login failed! Please input name and pwd again!$'
END_MSG DB 0AH,0DH,'end of program, press any key to continue$'
INPUT_GOODS_NAME_MSG DB 0AH,0DH,'please input the name of the goods:$'
INPUT_GOODS_NAME_AGAIN DB 0AH,0DH,'goods name input error,please input again:$'
GRADE_A_MSG DB 0AH,0DH,'A$'
GRADE_B_MSG DB 0AH,0DH,'B$'
GRADE_C_MSG DB 0AH,0DH,'C$'
GRADE_D_MSG DB 0AH,0DH,'D$'
GRADE_F_MSG DB 0AH,0DH,'F$'
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

            SET_ALL_ZERO:MOV AL,0
            MOV in_name[SI+2],AL
            MOV in_pwd[SI+2],AL
            INC SI
            DEC CX
            CMP SI,6
            JNE SET_ALL_ZERO

            SET_NAME_ALL_ZERO:MOV AL,0
            MOV in_name[SI+2],AL
            INC SI
            DEC CX
            JNZ SET_NAME_ALL_ZERO

            INPUT_NAME:LEA DX,INPUT_NAME_MSG
            MOV AH,9
            INT 21H
            LEA DX,in_name
            MOV AH,10
            INT 21H
            MOV SI, WORD PTR in_name[1]
            AND SI,00FFH
            MOV in_name[SI+2],0

            MOV AL,0
            CMP AL,in_name[3]
            JE AUTH_FAIL

            INPUT_PWD:LEA DX,INPUT_PASS_MSG
            MOV AH,9
            INT 21H
            LEA DX,in_pwd
            MOV AH,10
            INT 21H
            MOV SI, WORD PTR in_pwd[1]
            AND SI,00FFH
            MOV in_pwd[SI+2],0

            MOV SI,0;计数器
            MOV CX,10;计数器

FUNCTION2_PWD:MOV AL,in_name[SI+2]
            CMP AL,BNAME[SI]
            JNE PRINT_LOGIN_FAILED
            MOV AL,in_pwd[SI+2]
            CMP AL,BPASS[SI]
            JNE PRINT_LOGIN_FAILED
            INC SI
            DEC CX
            CMP SI,6
            JNE FUNCTION2_PWD

FUNCTION2_NAME:MOV AL,in_name[SI+2]
            CMP AL,BNAME[SI]
            JNE PRINT_LOGIN_FAILED
            INC SI
            DEC CX
            JNZ FUNCTION2_NAME

AUTH_SUCCESS:MOV BH,1
            MOV BYTE PTR AUTH,BH
            JMP FUNCTION3

AUTH_FAIL:MOV AL,'q'
            CMP AL,in_name[2]
            JE EXIT
            MOV AL,0DH
            CMP AL,in_name[2]
            JNE INPUT_PWD
            MOV BH,0
            MOV BYTE PTR AUTH,BH
            JMP FUNCTION3

PRINT_LOGIN_FAILED:LEA DX,LOGIN_FAILED_MSG
            MOV AH,9
            INT 21H
            JMP FUNCION1

FUNCTION3:MOV SI,0
            MOV CX,10
            SET_GOODSNAME_ALL_ZERO:MOV AL,0
            MOV goods_name[SI+2],AL
            INC SI
            DEC CX
            JNZ SET_GOODSNAME_ALL_ZERO

            LEA DX,INPUT_GOODS_NAME_MSG
            MOV AH,9
            INT 21H
            LEA DX,goods_name
            MOV AH,10
            INT 21H
            MOV SI, WORD PTR goods_name[1]
            AND SI,00FFH
            MOV goods_name[SI+2],0

            MOV BX,0
            MOV AL,0
            CMP AL,goods_name[2];判断是否只输入了回车
            JNE IS_GOODS
            JMP FUNCION1

            IS_PEN:MOV AL,goods_name[SI+2]
            CMP AL,GA1[SI]
            JNE IS_GOODS
            INC SI
            DEC CX
            JNZ IS_PEN
            MOV BYTE PTR goods_name[SI+3],'$'
            MOV AX,WORD PTR GA1[10];进货价
            IMUL GA1[14];AX现为cost1
            MOV COST1,AX
            MOV AX, WORD PTR GA1[12];销售价
            IMUL GA1[16];AX现为profit1+COST1
            SUB AX,COST1;AX现为profit1
            MOV PROFIT1,AX
            MOV AX,WORD PTR GB1[10];进货价
            IMUL GB1[14];AX现为cost2
            MOV COST2,AX
            MOV AX,WORD PTR GB1[12];销售价
            IMUL GB1[16];AX现为profit2+cost2
            SUB AX,COST2
            MOV PROFIT2,AX
            CMP AUTH,0
            JE FUNCTION3_4
            JMP FUNCTION3_3

            IS_BOOK:MOV AL,goods_name[SI+2]
            CMP AL,GA2[SI]
            JNE IS_GOODS
            INC SI
            DEC CX
            JNZ IS_BOOK
            MOV BYTE PTR goods_name[SI+3],'$'
            MOV AX,WORD PTR GA2[10];进货价
            IMUL GA2[14];AX现为cost1
            MOV COST1,AX
            MOV AX,WORD PTR GA2[12];销售价
            IMUL GA2[16]
            SUB AX,COST1;AX现为profit1
            MOV PROFIT1,AX
            MOV AX,WORD PTR GB2[10];进货价
            IMUL GB2[14];AX现为cost2
            MOV COST2,AX
            MOV AX,WORD PTR GB2[12];销售价
            IMUL GB2[16]
            SUB AX,COST2;AX现为profit2
            MOV PROFIT2,AX
            CMP AUTH,0
            JE FUNCTION3_4
            JMP FUNCTION3_3

            IS_N:MOV AL,goods_name[SI+2]
            CMP AL,GAN[SI]
            JNE IS_GOODS
            INC SI
            DEC CX
            JNZ IS_PEN
            MOV BYTE PTR goods_name[SI+3],'$'
            MOV AX,WORD PTR GAN[10];进货价
            IMUL GAN[14];AX现为cost1
            MOV COST1,AX
            MOV AX,WORD PTR GAN[12];销售价
            IMUL GAN[16]
            SUB AX,COST1;AX现为profit1
            MOV PROFIT1,AX
            MOV AX,WORD PTR GB1[10];进货价
            IMUL GB1[14];AX现为cost2
            MOV COST2,AX
            MOV AX,WORD PTR GB1[12];销售价
            IMUL GB1[16]
            SUB AX,COST2;AX现为profit2
            MOV PROFIT2,AX
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

FUNCTION3_3:MOV AX,PROFIT1
            IMUL AX,WORD PTR 100
            MOV DX,0
            IDIV COST1
            MOV AH,0
            MOV PR1,AX
            MOV AX,PROFIT2
            IMUL AX,WORD PTR 100
            MOV DX,0
            IDIV COST2
            MOV AH,0
            MOV PR2,AX
            ADD AX,PR2
            MOV APR,AX

            CMP APR,180
            JNL GRADE_A
            CMP APR,100
            JNL GRADE_B
            CMP APR,40
            JNL GRADE_C
            CMP APR,0
            JNL GRADE_D
            JMP GRADE_F

            GRADE_A:LEA DX,GRADE_A_MSG
            MOV AH,9
            INT 21H
            JMP FUNCION1

            GRADE_B:LEA DX,GRADE_B_MSG
            MOV AH,9
            INT 21H
            JMP FUNCION1

            GRADE_C:LEA DX,GRADE_C_MSG
            MOV AH,9
            INT 21H
            JMP FUNCION1

            GRADE_D:LEA DX,GRADE_D_MSG
            MOV AH,9
            INT 21H
            JMP FUNCION1

            GRADE_F:LEA DX,GRADE_F_MSG
            MOV AH,9
            INT 21H
            JMP FUNCION1

FUNCTION3_4:LEA DX,goods_name
            MOV AH,9
            INT 21H
            JMP FUNCION1

EXIT:LEA DX,END_MSG
            MOV AH,9
            INT 21H
            MOV AH,1
            INT 21H
            MOV AH,4CH
            INT 21H
CODE ENDS
            END START
