.model small
.stack 100h
.data
    num dw ? 
    result dw ?
    prompt  db "Introdu o cifra: $"
    fact_msg db 13, 10, 'Factorialul este: $'

.code
main proc
    mov ax, @data
    mov ds, ax

    lea dx, prompt
    call print_string

    mov ah, 01h
    int 21h
    sub al, '0'
    cbw 
    mov num, ax
 
    lea dx, fact_msg
    call print_string
 
    mov ax, num
    call calculate_factorial
 
    mov result, ax
    call print_number
 
    mov ah, 4Ch
    int 21h
main endp

calculate_factorial proc
    mov cx, num
    cmp cx, 0
    je set_result_to_1 
    
    mov ax, 1
    jmp factorial_loop  
    
set_result_to_1:
    mov ax, 1
    ret
    
factorial_loop:
    mul cx
    dec cx
    jnz factorial_loop
    ret
calculate_factorial endp

print_string proc
    mov ah, 09h
    int 21h
    ret
print_string endp

print_number proc
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

end main
