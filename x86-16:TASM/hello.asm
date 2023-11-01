dosseg ;directiva sa grupam segmentele conform conventiilor microsoft
.model small ;modelul de memorie pt un program, 2x segmente a cate 64kb
.stack 100h ;stack de 256bytes
.data ;segment de date
    text db "H", "e", "l", "l", "o", "$" ;secventa de caractere+EOL char
    newline db 10, 13, "$" ;spatiu+enter+EOL char
    nbsp db 32, "$" ;spatiu in ASCII + EOL char
    attributes db 0Eh, 0Ch, 0Dh, 0Ah, 0Fh, 0Bh, 08h, 07h, 09h, 0Eh, 0Ch ;coduri hexa pentru culori BIOS
.code
    mov ax,@data ;incarcam segmentul de date printr-un registru general (nu poate fi incarcat direct dintr-o constanta, decat printr-un reg. general sau adresa de mem.)
    mov ds,ax ;incarcam segmentul de date in registrul data segment

    mov si,0 ;setam registrul source index la 0 (ne folosim de ele mai jos)
    mov di,0 ;setam registrul data index la 0 
    mov cx,0 ;setam registrul general cx la 0 

add_nbsp: ;facem o directiva? functie? pentru a adauga spatiu inaintea fiecarui caracter printat (a.i. sa nu repetam codul pt fiecare spatiu necesar, daca avem un cuvant de 30 litere ar trebui sa copiem codul de 30 ori)
    cmp cx,di ; facem comparatie intre registrul cx si di 
    je print_loop ; jump-equal - daca acestea sunt egale, executam print_loop - daca nu, codul de mai jos
    mov dl,nbsp ;incarcam in registrul general de date, lower8bit, datele preluate din @data nbsp
    mov ah,02h ;punem in registrul high 8bit functia 02h care executa display output (preluat din registrul dl)
    int 21h ;interrupt 21
    inc cx ;incrementam cx
    jmp add_nbsp ; sarim inapoi la inceputul directivei? functiei? si o parcurgem din nou

print_loop: 
    mov dl,text[si] ;incarcam in registrul dl caracterul aflat la indexul 'si', cu fiecare iteratie peste loop, acesta creste cu o valoare
    mov cx,1 ;printeaza doar un caracter (nu stiu exact, fara asta pune o gramada de garbage dupa fiecare caracter)
    cmp dl,'$' ;verificam daca e end of line
    je done ;daca da, executam done si terminam procesul

    mov ah,09h ; printam string de caractere (preluat din ds:dx, pointer catre un oarecare string cu EOL '$')
    mov bh,0    ; numarul paginii 10 de comenzi (INT 10,0) (0 pt pagina video standard, 1 pt cursor type, 3 pt cursor position etc.) -- merge si fara (e default 0)
    mov bl,[attributes + di] ; incarcam atributul (codul de culoare definit mai sus) + un offset di, incrementat treptat
    int 10h      ; setam video modeul si un BIOS interrupt pt printare

    mov ah,02h ;printam pe stdout
    int 21h ;interrupt call 02h de mai sus

    mov dl,newline ;incarcam  @data newline in registrul dl
    mov ah,02h ;printam stdout
    int 21h ;interrupt call 02h de mai sus

    inc si ;incrementam source indexul
    inc di ;incrementam data indexul
    mov cx,0 ;setam cx la 0, astfel incat urmatoarea instructiune incepe de la capat (cx = 0, di != 0 /// daca nu e primul pass-through, astfel stim cate spatii sa adaugam in fata fiecarui caracter)
    jmp add_nbsp ;sarim la add_nbsp


done: ;terminam procesul 
    mov ax,4c00h ;terminam procsul cu un return code (stocat in AL pt batch process, AH e 4C)
    int 21h ;terminam programul

end

