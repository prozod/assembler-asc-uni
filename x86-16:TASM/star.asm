dosseg 
.model small 
.stack 100h 
.data 
    text    db "  STEA OBRAZNICA ", 10, 13
            db "        .        ", 10, 13
            db "       ,O,       ", 10, 13
            db "      ,OOO,      ", 10, 13
            db "'oooooOOOOOooooo'", 10, 13
            db "  `OOOOOOOOOOO`  ", 10, 13
            db "    `OOOOOOO`    ", 10, 13
            db "    OOOO'OOOO    ", 10, 13
            db "   OOO'   'OOO   ", 10, 13
            db "  O'         'O  $", 10, 13
.code
    mov ax,@data 
    mov ds,ax 
    mov si,0 
    mov di,0

print_loop: 
    mov dl,text[si] 
    mov cx,1 
    cmp dl,"$" 
    je done 

    mov ah,09h 
    mov bh,0    
    mov bl,0Dh
    or bl, 80h
    int 10h  

    mov ah,02h 
    int 21h 

    inc si 
    mov cx,0 

    jmp print_loop 

done: 
    mov ax,4c00h 
    int 21h 

end

