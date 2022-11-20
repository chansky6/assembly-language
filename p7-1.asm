assume cs:codesg, ds:datasg
datasg segment
    db 'BaSiC'
    db 'iNfOrMaTion'
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
    inc bx
    loop s

    mov bx, 5
    mov cx, 11
s0: mov al, [bx]
    or al, 00100000b
    mov [bx], al
    inc bx
    loop s0

    mov ax, 4c00H
    int 21H

codesg ends
end start
