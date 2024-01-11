.model small
.stack 100h
.data
    msg db 13,10,'Enter a number: $'
    result_msg db 13,10,'Sum of digits: $'

.code
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    lea dx, msg
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al
 
    int 21h
    sub al, '0'
 
    add bl, al
 
    mov ah, 09h
    lea dx, result_msg
    int 21h
 
    mov ah, 02h
    mov dl, bl 
    add dl, '0'
    int 21h

    mov ah, 4Ch
    int 21h
end 
