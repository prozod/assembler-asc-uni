.model small 
.stack 100h 
.data 
    text db "         *          ", 10, 13
         db "        /|\         ", 10, 13
         db "       /*|O\        ", 10, 13
         db "      /*/|\*\       ", 10, 13
         db "     /X/O|*\X\      ", 10, 13
         db "    /*/X/|\X\*\     ", 10, 13
         db "   /O/*/X|*\O\X\    ", 10, 13
         db "  /*/O/X/|\X\O\*\   ", 10, 13
         db " /X/O/*/X|O\X\*\O\  ", 10, 13
         db "/O/X/*/O/|\X\*\O\X\ ", 10, 13
         db "        |X|         ", 10, 13
         db "        |X|        $", 10, 13

.code
    mov ax,@data 
    mov ds,ax 
    mov si,0 

print_loop: 
    mov dl,text[si] 
    mov cx,1 
    cmp dl,"$" 
    je done

    mov ah,09h 
    mov bh,0    
    mov bl,0Ah
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

