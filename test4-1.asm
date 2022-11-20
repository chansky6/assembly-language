; 实验4(1)(2)
assume cs:code
code segment

    mov ax, 200H
    mov ds, ax

    mov bx, 0
    
    mov cx, 64

s:  mov [bx], bx
    inc bx
    loop s

    mov ax, 4c00H
    int 21H

code ends

end