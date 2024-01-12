.model small
.stack 100h
.data
    input_msg   DB  'Introdu un numar (max. 2 cifre): $'
    sum_msg     DB  13, 10, 'Suma cifrelor este: $'
    sum         DW  ?

.code
  mov ax, @data
  mov ds, ax
  
  lea dx,input_msg 
  call display_message

  call read_character
  sub al, '0'
  mov bl, al
  call read_character
  sub al, '0'
  mov cl, al
  
  lea dx,sum_msg
  call display_message

  add cl, bl

  cmp cl, 9
  jbe below_10

  call above_10
  call terminate
 
  below_10:
    mov ah, 0
    add cl, '0'
    mov dl, cl
    call display_result
    call terminate

  display_message proc
      mov ah, 09h
      int 21h
      ret
  display_message endp

  display_result proc
      mov ah, 02h
      int 21h
      ret
  display_result endp

  read_character proc
      mov ah, 01h
      int 21h
      ret
  read_character endp

  terminate proc
    mov ah, 4Ch
    int 21h
  terminate endp

  above_10 proc
    mov ch, 0
    mov ax, cx 
    mov dx, 0
    mov bx, 10 
    div bx

    mov bx, dx
    add al, '0'
    mov dl, al 
    call display_result

    add bl, '0'
    mov dl, bl
    call display_result
    ret
  above_10 endp
end
