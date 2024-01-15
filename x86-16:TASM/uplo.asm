.model small
.stack 100h
.data 
  input_msg   DB "Introdu o litera mica: $";
  output_msg  DB 10, 13, "Conversia rezultata: $"
  error_msg   DB 10, 13, "Incearca din nou! S-a produs o eroare. $"

;propunere conversie lowercase-uppercase
.code
  mov ax, @data
  mov ds, ax

  lea dx,input_msg
  call display_msg

  call read_char 
  mov bl, al

  cmp al, 'a'
  jl display_error
  cmp al, 'z'
  jg display_error

  lea dx,output_msg
  call display_msg
  call display_upper

  call terminate

display_error:
  lea dx,error_msg
  call display_msg
  call terminate
 
display_upper proc
  sub al, 32
  mov dl, al
  call display_char
  ret
display_upper endp

read_char proc
  mov ah,01h
  int 21h
  ret
read_char endp

display_msg proc
  mov ah,09h
  int 21h
  ret
display_msg endp

display_char proc
  mov ah,02h
  int 21h
  ret
display_char endp

terminate proc
  mov ah, 4Ch
  int 21h
terminate endp
  
end
