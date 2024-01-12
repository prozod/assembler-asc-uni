.model small
.stack 100h
.data
    msg db 13,10,'Introdu un numar: $'
    result_msg db 13,10,'Suma cifrelor: $'

.code
    mov ax, @data
    mov ds, ax

    lea dx, msg
    call load_and_print 

    call read_and_compare
    je  negative

    sub al, '0'
    jmp  continue

negative:
    mov ah, 01h
    int 21h
    sub al, '0'
    neg al

continue:
    call sum

    lea dx, result_msg
    call load_and_print 

    mov ah, 02h
    mov dl, bl
    add dl, '0'
    int 21h

    call terminate

load_and_print proc text
    mov ah, 09h
    mov dx, [text]
    int 21h
    ret
load_and_print endp

read_and_compare proc
    mov ah, 01h
    int 21h
    cmp al, '-'
    ret
read_and_compare endp

sum proc
    mov bl, al
    int 21h
    sub al, '0'
    add bl, al
    ret
sum endp

terminate proc
    mov ah, 4Ch
    int 21h
terminate endp

end
