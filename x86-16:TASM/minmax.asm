.model small
.stack 100h
.data
    num1 db ?
    num2 db ?
    max db ?
    min db ?
    msg1 db 10,13,'Introduceti primul numar: $'
    msg2 db 10,13,'Introduceti al doilea numar: $'
    msg_max db 10,13,'Maximul este: $'
    msg_min db 10,13,'Minimul este: $'
    newline db 13, 10, '$'

.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, msg1
    call display_message

    call read_character
    sub al, '0'
    mov num1, al

    lea dx, msg2
    call display_message

    call read_character
    sub al, '0'
    mov num2, al

    mov al, num1
    cmp al, num2
    jae set_max
    mov ah, num2
    mov max, ah
    mov bh, num1
    mov min, bh
    jmp print_result

set_max:
    mov ah, num1
    mov max, ah
    mov bh, num2
    mov min, bh

print_result:
    lea dx, msg_max
    call display_message

    mov dl, max
    call display_number

    lea dx, msg_min
    call display_message

    mov dl, min
    call display_number

    lea dx, newline
    call display_message

    mov ah, 4Ch
    int 21h
main endp

display_message proc
    mov ah, 09h
    int 21h
    ret
display_message endp

read_character proc
    mov ah, 01h
    int 21h
    ret
read_character endp

display_number proc
    add dl, '0'
    mov ah, 02h
    int 21h
    ret
display_number endp

end main
