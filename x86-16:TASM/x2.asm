.model small
.stack 100h
.data
    input_msg DB "Enter a number: $"
    output_msg DB 10, 13, "Cube is: $"
    result DW ?

.code
    mov ax, @data
    mov ds, ax

    mov ah, 9
    lea dx, input_msg
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'

    imul al
    mov result, ax

    call print_number
    call terminate

print_number proc
    mov ah, 09h
    lea dx, output_msg
    int 21h

    mov ax, result
    call print_digit
    ret
print_number endp

print_digit proc
    mov cx, 10
    mov bx, 0

    digit_loop:
        xor dx, dx
        div cx 
        add dl, '0'
        push dx
        inc bx
        test ax, ax
        jnz digit_loop

    print_loop:
        pop dx
        mov ah, 02h
        int 21h
        dec bx 
        jnz print_loop

    ret
print_digit endp

terminate proc 
    mov ah, 4Ch
    int 21h
terminate endp

end
