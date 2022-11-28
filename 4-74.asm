DATAS        SEGMENT 
	;此处输入数据段代码
TABLE       DW G1,G2,G3,G4 
STRING1     DB '1.Change lower to upper.' , 0DH, 0AH, '$'  ; 功能1
STRING2     DB '2.Find the maximum.     ' , 0DH, 0AH, '$'  ; 功能2 
STRING3     DB '3.Sort for datas;       ' , 0DH, 0AH, '$'  ; 功能3
STRING4     DB '4.Exit.                 ' , 0DH, 0AH, '$'  ; 功能4
STRING5     DB 'Input the number you select: $' 
IN_STR      DB 'Input the string:       ' , 0DH, 0AH, '$'    
PRESTR      DB 'Org string : $' 
NEWSTR      DB 'New string : $' 
OUT_STR     DB 'The string is $' 
MAXCHR      DB 'The maximum is $' 
IN_NUM      DB 'Input the numbers: ' , 0DH, 0AH, '$' 
OUT_NUM     DB 'Sorted numbers :   ' , 0DH, 0AH, '$'  
HINTSTR     DB 'Press ESC to the menu or other key to fuction again!  $'
KEYBUF      DB  30  ;键盘缓冲区     
            DB  ?
            DB  30 DUP (?)
NUMBUF      DB  ? 
            DB  30 DUP (?)
DATAS        ENDS     

STACKS   SEGMENT STACK
	;此处输入堆栈段代码
        DB 256 DUP(?)
TOP     LABEL WORD 
STACKS   ENDS
             
CODES   SEGMENT 
       ASSUME CS:CODES, DS:DATAS, SS:STACKS     
START:
            MOV AX, DATAS 
            MOV DS, AX   
            ;此处输入代码段代码
            MOV AX, STACKS 
            MOV SS, AX
            MOV SP, OFFSET TOP
MAIN:      CALL FAR PTR MENU ;设置显示器 
AGAIN:
            MOV AH, 2
            MOV BH, 0 ;页号 
            MOV DL, 41 ;列号 
            MOV DH, 10 ;行号 
            INT 10H ;光标位置设置 
            MOV AH, 1 
            INT 21H 
            CMP AL, '1' 
            JB  AGAIN 
            CMP AL, '5' 
            JA  AGAIN
            SUB AL, '1' ;N-1 
            SHL AL,  1  ;(N-1)*2 
            CBW         ;AL->AX 
            LEA BX, TABLE 
            ADD BX, AX
            JMP WORD PTR[BX]
G1:
            CALL FAR PTR CHGLTR 
            MOV AH, 8 
            INT 21H
            CMP AL, 1BH 
            JZ MAIN 
            JMP G1
G2:
            CALL FAR PTR MAXLTR 
            MOV AH, 8 
            INT 21H
            CMP AL, 1BH 
            JZ MAIN 
            JMP G2
G3:
            CALL FAR PTR SORTNUM 
            MOV AH, 8 
            INT 21H
            CMP AL, 1BH 
            JZ MAIN 
            JMP G3
G4:
            MOV AH, 4CH 
            INT 21H 
            
MENU        PROC FAR ;显示主界面 
            ;设置显示器方式 
            MOV AH, 0 
            MOV AL, 3; 
            MOV BL, 0;
            INT 10H     ;清屏 
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 5    ;行号 
            INT 10H     ;光标位置设置 
            MOV AH, 9
            LEA DX, STRING1 
            INT 21H 
            MOV AH, 2
            MOV DL, 5   ;列号 
            MOV DH, 6   ;行号 
            INT 10H     ;光标位置设置 
            MOV AH, 9
            LEA DX, STRING2 
            INT 21H 
            MOV AH, 2
            MOV DL, 5   ;列号 
            MOV DH, 7    ;行号 
            INT 10H     ;光标位置设置 
            MOV AH, 9
            LEA DX, STRING3 
            INT 21H 
            MOV AH, 2
            MOV DL, 5   ;列号 
            MOV DH, 8   ;行号 
            INT 10H     ;光标位置设置 
            MOV AH, 9
            LEA DX, STRING4 
            INT 21H 
            MOV AH, 2
            MOV DL, 5   ;列号  
            MOV DH, 10  ;行号 
            INT 10H     ;光标位置设置 
            MOV AH, 9
            LEA DX, STRING5 
            INT 21H 
            RET
MENU        ENDP 

CHGLTR      PROC FAR    ;将输入字符串中小写字母便换成大写字母 
RECHG:
            ;设置显示器方式 
            MOV AH, 0 
            MOV AL, 3 
            MOV BL, 0
            INT 10H     ;清屏 
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 5   ;行号 
            INT 10H     ;输入提示光标位置设置 
            MOV AH, 9
            LEA DX, IN_STR
            INT 21H     ;输入字符串提示 
            MOV AH, 2
            MOV DL, 5   ;列号 
            MOV DH, 6   ;行号 
            INT 10H     ;输入字符串光标位置设置 
            MOV AH, 0AH
            LEA DX, KEYBUF
            INT 21H     ;输入字符串 
            CMP KEYBUF +1, 0
            JZ  RECHG   ;判断输入字符串是否为空串 
            LEA BX, KEYBUF+2 
            MOV AL, KEYBUF+1 
            CBW
            MOV CX, AX 
            ADD BX, AX
            MOV BYTE PTR [BX],'$'  ;在输入字符串尾加结束标志$ 
            MOV AH, 2
            MOV BH, 0    ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 7   ;行号 
            INT 10H     ;源字符串提示光标位置设置 
            MOV AH, 9
            LEA DX, PRESTR 
            INT 21H     ;输出源字符串提示 
            MOV AH, 9
            LEA DX, KEYBUF+ 2
            INT 21H     ;输出源字符串 
            LEA BX, KEYBUF+2
LCHG:
            CMP BYTE PTR [BX], 61H 
            JB NOCHG
            AND BYTE PTR [BX], 0DFH
NOCHG:
            INC BX
            LOOP LCHG   ;将字符串中小写字母转换成大写字母 
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 8   ;行号 
            INT 10H     ;新字符串提示光标位置设置 
            MOV AH, 9
            LEA DX, NEWSTR
            INT 21H     ;输出新字符串提示 
            MOV AH, 9
            LEA DX, KEYBUF+2
            INT 21H     ;输出新字符串 
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 9    ;行号 
            INT 10H     ;提示信息光标位置设置 
            MOV AH, 9
            LEA DX, HINTSTR
            INT 21H     ;输出提示信息 
            RET
CHGLTR      ENDP

MAXLTR      PROC FAR     ;在输入字符串中找出最大值 
REMAX:
            ;设置显示器方式 
            MOV AH, 0 
            MOV AL, 3 
            MOV BL, 0
            INT 10H     ;清屏 
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 5   ;行号 
            INT 10H     ;输入提示光标位置设置 
            MOV AH, 9
            LEA DX, IN_STR
            INT 21H     ;输入字符串提示 
            MOV AH, 2
            MOV DL, 5   ;列号 
            MOV DH, 6   ;行号 
            INT 10H     ;输入字符串光标位置设置 
            MOV AH, 0AH 
            LEA DX, KEYBUF
            INT 21H     ;输入字符串 
            CMP KEYBUF+1, 0
            JZ  REMAX   ;判断输入字符串是否为空串 
            LEA BX, KEYBUF+2 
            MOV AL, KEYBUF+1 
            CBW
            MOV CX, AX 
            ADD BX, AX
            MOV BYTE PTR [BX],'$'  ;在输入字符串位加结束标志$ 
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 7   ;行号 
            INT 10H     ;源字符串提示光标位置设置 
            MOV AH, 9
            LEA DX, OUT_STR
            INT 21H     ;输出字符串提示 
            MOV AH, 9
            LEA DX, KEYBUF+2
            INT 21H     ;输出字符串 
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 8   ;行号 
            INT 10H     ;新字符串提示光标位置设置 
            MOV AH, 9
            LEA DX, MAXCHR
            INT 21H     ;输出字符串中最大值提示 
            MOV DL, 0
            LEA BX, KEYBUF+2
LCMP:
            CMP [BX], DL 
            JB NOLCHG 
            MOV DL, [BX]    
NOLCHG:
            INC BX
           LOOP LCMP    ;找出字符串中最大字符，放入 DI 
            MOV AH, 2
            INT 21H     ;输出字符串中最大字符 
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 9    ;行号 
            INT 10H     ;提示信息光标位置设置 
            MOV AH, 9
            LEA DX, HINTSTR
            INT 21H     ;输出提示信息 
            RET
MAXLTR      ENDP    

SORTNUM     PROC FAR    ;对输入数据组排序 
RESORT:
            ;设置显示器方式 
            MOV AH, 0 
            MOV AL, 3 
            MOV BL, 0
            INT 10H     ;清屏 
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 5   ;行号 
            INT 10H     ;输入提示光标位置设置 
            MOV AH, 9
            LEA DX, IN_NUM 
            INT 21H 
            MOV AH, 2
            MOV DL, 5   ;列号 
            MOV DH, 6   ;行号 
            INT 10H     ;输入数据组光标位置设置 
            MOV AH, 0AH 
            LEA DX, KEYBUF
            INT 21H     ;输入数据组字符串 
           CALL CIN_INT ;字符串转换成数据串 
            CMP AL, 0
            JZ RESORT   ;判断数据串是否有错 
            CMP NUMBUF, 0
            JZ RESORT   ;判断数据串是否为空
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 7   ;行号 
            INT 10H     ;输出提示光标位置设置 
            MOV AH, 9
            LEA DX, OUT_NUM
            INT 21H     ;输出数据串提示 
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 8   ;行号 
            INT 10H     ;输出数据组光标位置设置 
           CALL FAR PTR MPSORT  ;数据组排序 
           CALL FAR PTR INT_OUT ;数据组的输出 
            MOV AH, 2
            MOV BH, 0   ;页号 
            MOV DL, 5   ;列号 
            MOV DH, 9   ;行号 
            INT 10H     ;提示信息光标位置设置 
            MOV AH, 9
            LEA DX, HINTSTR
            INT 21H ;输出提示信息 
            RET
SORTNUM     ENDP

CIN_INT     PROC NEAR ;读入整型数 
            ;入口参数:无
            ;出口参数为:AL(有无错误标志，0为有，1为无)
            MOV CL, KEYBUF +1 
            LEA SI, KEYBUF +2
            MOV CH, 0   ;数据组数据个数置0 
            MOV DH, 10
            MOV AL, 0   ;当前数据 x=0 
            MOV DL, 0   ;有无数据标志置 0，即无数据 
FNDNUM:                 
            CMP BYTE PTR [SI],' '
            JZ  ADDNUM  ;判断当前字符是否为空格 
            CMP BYTE PTR [SI],'0' 
            JB  ERRNUM
            CMP BYTE PTR [SI],'9'
            JA  ERRNUM  ;判断当前字符是否在0'-9之间 
            MOV DL, 1   ;有无数据标志置 1，即有数据 
            MUL DH      
            XOR BH, BH 
            MOV BL, [SI]
            ADD AX, BX
            SUB AX,'0'  ;计算出当前数据x 
            CMP AH, 0
            JA  ERRNUM  ;判断x是否越界 
            JMP NEXT
ADDNUM:
            CMP DL, 1
            JNZ NEXT    ;判断是否有数据 
            INC CH      ;数据组数据个数加1 
           CALL ADDNEW 
            MOV DL, 0
            MOV AL, 0   ;清零 
NEXT:
            INC SI 
            DEC CL 
            CMP CL, 0
            JNZ FNDNUM  ;依次检查各字符 
            CMP DL, 1
            JNZ TOTAL   ;判断是否有未加入的数据 
            INC CH
           CALL ADDNEW
TOTAL:
            MOV NUMBUF, CH  ;置数据组数据个数 
            MOV AL, 1       ;输入数据无错误 
            JMP CRTNUM
ERRNUM:
            MOV AL, 0       ;输入数据有错误 
CRTNUM:
            RET
CIN_INT ENDP

ADDNEW     PROC NEAR             ;增加新数 
            ;入口参数:CH(数据组数据个数)、AL(当前数据x);出口参数:无
           PUSH AX
            LEA BX, NUMBUF 
            MOV AL, CH 
            CBW
            ADD BX, AX 
            POP AX
            MOV [BX],AL 
            RET
ADDNEW      ENDP           

MPSORT      PROC FAR        ;数据组排序 
            MOV AL, NUMBUF 
            CMP AL, 1
            JBE NOSORT      ;若只有一个元素，停止排序 
            CBW
            MOV CX, AX
            LEA SI, NUMBUF  ;SI指向数据组首地址 
            ADD SI, CX      ;SI 指向数据组末地址 
            DEC CX          ;外循环次数 
LP1:                        ;外循环开始 
           PUSH CX 
           PUSH SI
            MOV DL, 0       ;交换标志置0 
LP2:                        ;内循环开始 
            MOV AL, [SI] 
            CMP AL, [SI-1] 
            JAE NOXCHG
           XCHG AL, [SI- 1] ;交换操作 
            MOV [SI], AL
            MOV DL, 1       ;交换标志置1 
NOXCHG:
            DEC SI 
           LOOP LP2 
            POP SI 
            POP CX 
            CMP DL, 1
            JNZ NOSORT      ;判断交换标志 
           LOOP LP1
NOSORT:     RET 
MPSORT     ENDP 

INT_OUT     PROC FAR        ;输出数据组 
            MOV AL, NUMBUF 
            CBW
            MOV CX, AX 
            MOV BL, 10H
            LEA SI, NUMBUF+1
PRINT:
            MOV AL, [SI] 
           CALL OUTNUM 
            INC SI
            MOV AH, 2 
            MOV DL, ' ' 
            INT 21H
           LOOP PRINT     
            RET
INT_OUT ENDP  

OUTNUM      PROC NEAR       ;将十进制数以十六进制输出 
            ;入口参数: AL(待转换的数据)，BL(转换进制数 16)
            ;出口参数:无
            MOV AH, 0
            DIV BL 
           PUSH AX 
            CMP AH, 10 
            JB PNUM
            ADD AH,7
PNUM:       ADD AH, 30H 
            MOV DL, AH 
            POP AX 
           PUSH DX 
            CMP AL, 0 
            JZ  OUTN
           CALL OUTNUM
OUTN:
            POP DX 
            MOV AH, 2 
            INT 21H 
            RET
OUTNUM      ENDP    

SHOWNUM     PROC ;把AL 中的数字以十进制输出 
        ;入口参数: AL(待显示的数据)
        ;出口参数:无
            CBW
           PUSH CX 
           PUSH DX 
            MOV CL, 10 
            DIV CL
            ADD AH,'0' 
            MOV BH, AH 
            ADD AL,'0' 
            MOV AH, 2 
            MOV DL, AL 
            INT 21H
            MOV DL, BH 
            INT 21H 
            POP DX 
            POP CX 
            RET
SHOWNUM     ENDP    

CODES        ENDS 
            END START 








