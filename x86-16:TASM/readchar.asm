.model small
.data
    count_msg db 'Number of characters: $'
    buffer db 100 dup(?) 
    count dw 0

.code
    mov ax, @data
    mov ds, ax

    mov ah, 01h
    lea dx, buffer

read_loop:
    int 21h
    cmp al, 13
    je  end_input
    inc count
    jmp read_loop

end_input: 
    mov ah, 09h
    lea dx, count_msg
    int 21h

    mov ah, 4Ch
    int 21h

end main
