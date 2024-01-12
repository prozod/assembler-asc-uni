.model small
.stack 100h
.data
    input_msg   DB  'Introdu un numar (max. 2 cifre): $'
    sum_msg     DB  13, 10, 'Suma cifrelor este: $'
    sum         DW  ?

.code
  mov ax, @data
  mov ds, ax
  
  lea dx,input_msg ;aici incarcam mesajul din segmentul de date si pe urma apelam procedura display_message
  call display_message

  call read_character
  sub al, '0' ;chestia asta e putin sketchy, adica functioneaza strict pt. ce vrem noi... deoarece in ASCII, cifrele sunt secventiale (0-9) = (48-57)
              ;iar atunci cand facem scaderea respectiva, se face conversia din cifra ASCII introdusa de noi, in cifra numerica
              ;logica e ca, daca noi introducem cifra 8 (56 in ASCII) de la tastatura, se produce operatia: 56 - 48 = 8
  mov bl, al ;mutam cifra inrodusa in bl pentru a putea citi urmatoarea cifra
  call read_character
  sub al, '0'
  mov cl, al
  
  lea dx,sum_msg
  call display_message

  add cl, bl

  cmp cl, 9 ;comparam suma adunata mai sus, trebuie sa verificam cand e >=9
  jbe below_10 ;jump below or equal

  mov ch, 0 ;aici setez ch la 0 pt a putea muta cx in ax (16bit), deoarece suma noastra e in cl (8bit) 
            ;(honestly, e mai mult un safety measure, sa fiu sigur ca nu avem garbage la adresa respectiva)
  mov ax, cx 
  mov dx, 0 ;setam dx la 0 pt ca restul impartirii noastre o sa fie aici si vrem sa fim siguri ca nu "il punem" peste ceva existent (cred ca se produce overflow sau eroare daca e cazul, deci better to be safe than sorry)
  mov bx, 10 ;punem divizorul 10 in bx
  div bx ;impartirea se executa asa: (AX:DX)/BX, impartim ce avem in AX la BX (de asta am mutat cx in ax mai sus)
          ;iar coeficientul impartirii va fi pus automat AX si restul in DX (se rescrie AX dupa impartire, AX nu va mai contine numarul nostru)

  mov bx, dx ;mutam restul din dx in bx (pt ca 02h are nevoie registrul dl sa printeze)
  add al, '0' ;facem conversia coeficientului impartirii inapoi in ASCII, sa-l putem afisa corect
  mov dl, al 
  call display_result

  add bl, '0' ;conversia restului inapoi in ASCII
  mov dl, bl
  call display_result

  call terminate
 
  below_10:
    mov ah, 0
    add cl, '0' ;daca rezultatul e sub <=9, el va fi tot in cl (pt ca nu se executa mov ax, cx de mai sus), iar aici il convertim inapoi in ASCII
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
end
