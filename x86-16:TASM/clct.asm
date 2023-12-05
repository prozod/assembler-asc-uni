.model small
.stack 100h
.data
    Message1 DB 'Introdu primul numar: $'
    Message2 DB 13, 10, 'Introdu al 2-lea numar: $'
    Message3 DB 13, 10, 'Introdu tipul de operatie (+, -, *, /): $'
    ResultMsg DB 13, 10, 'Rezultatul este:  $'
    PosSign DB '+', '$'
    NegSign DB '-', '$'
    ZeroMsg DB '0', '$'
    Hold DB 0
.code
start:
    mov ax, @data
    mov ds, ax

    mov dx, offset Message1
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    mov dx, offset Message2
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'
    mov Hold,al
    jmp check_operation


check_operation: 
    mov dx, offset Message3
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h

    cmp al,42
    je mul_op
    cmp al,43
    je add_op
    cmp al,45
    je sub_op

div_op:     
    mov ax,bx
    div Hold
    mov bx,ax
    mov dx, offset ResultMsg
    mov ah, 09h
    int 21h

    cmp bl, 0
    je is_zero
    jns is_positive

mul_op:     
    mov ax,bx
    mul Hold
    mov bx,ax
    mov dx, offset ResultMsg
    mov ah, 09h
    int 21h

    cmp bl, 0
    je is_zero
    jns is_positive

add_op: 
    add bl, Hold
    mov dx, offset ResultMsg
    mov ah, 09h
    int 21h

    cmp bl, 0
    je is_zero
    jns is_positive

sub_op: 
    sub bl, Hold
    mov dx, offset ResultMsg
    mov ah, 09h
    int 21h

    cmp bl, 0
    je is_zero
    jns is_positive

is_negative:
    mov dx, offset NegSign
    mov ah, 09h
    int 21h
    neg bl
    jmp display_result

is_positive:
    mov dx, offset PosSign
    mov ah, 09h
    int 21h

display_result:
    add bl, '0'
    mov dl, bl

    mov ah, 02h
    int 21h

    mov ah, 4ch
    int 21h

is_zero:
    mov dx, offset ZeroMsg
    jmp display_result

end start
