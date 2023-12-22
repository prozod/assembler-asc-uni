.model small 
.stack 100h 
   
.code
    mov ax,@data 
    mov ds,ax 

    mov di,5
    mov cx,0 

    mov bx,0
    mov si,1

add_nbsp: 
    cmp cx,di 
    je print_loop 

    mov dl,20h
    mov ah,02h 
    int 21h 
    inc cx 

    cmp si,bx
    je add_newline
    jne add_nbsp

add_newline: 
    add si,2
    mov cx,0
    mov bx,0
    dec di

    mov dl,0Ah
    mov ah,02h 
    int 21h 

    jmp add_nbsp

add_star:
    mov cx,0
    cmp bx,si
    je add_nbsp

    mov dl,2Ah
    mov ah,02h 
    int 21h 

    inc bx
    jmp add_star
  
print_loop:  
    cmp si,9
    jg done
    jle add_star

done: 
    mov ax,4c00h 
    int 21h 

end

