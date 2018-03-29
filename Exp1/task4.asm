;--------------------------------------------------
DATA SEGMENT USE16
ORIGIN_BUF DB '4','5','7','7'
XUEHAO DB 4 DUP(0)
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
            MOV SI,OFFSET ORIGIN_BUF
            MOV DI,OFFSET XUEHAO+1

            MOV AL,ORIGIN_BUF
            MOV XUEHAO,AL   ;直接寻址

            INC SI
            MOV AL,[SI]
            MOV [DI],AL     ;间接寻址

            INC SI
            MOV AL,ORIGIN_BUF[SI]
            MOV XUEHAO[SI],AL   ;变址寻址

            INC SI
            LEA BX,ORIGIN_BUF
            LEA BP,XUEHAO
            MOV AL,[BX][SI]
            MOV DS:[BP][SI],AL  ;基址加变址寻址

            MOV AH,4CH
            INT 21H
CODE ENDS
            END START