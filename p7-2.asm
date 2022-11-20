; 大小写转换, [bx+idata]同时转换
assume cs:codesg, ds:datasg
datasg segment
    db 'BaSiC'
    db 'MinIx'
datasg ends

codesg segment
start:
    mov ax, datasg
    mov ds, ax

    mov bx, 0
    mov cx, 5
s:  mov al, [bx]
    and al, 11011111b
    mov [bx], al

    mov al, [bx+5]  ; 注意这里的[bx+5]
    or al, 00100000b
    mov [bx+5], al
    inc bx
    loop s

    mov ax, 4c00H
    int 21H

codesg ends
end start
