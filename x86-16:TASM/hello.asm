dosseg ;directiva care grupeaza segmentele conform conventiilor microsoft
.model small ;modelul de memorie pt un program, small inseamna 2x segmente a cate 64kb (vezi pdf de pe teams)
.stack 100h ;stack de 256 octeti (bytes in engleza)
.data ;defineste/initializeaza un segment de date
    text db "H", "e", "l", "l", "o", "$" ;secventa de caractere, iar "$" de la final EOL character (cand intalneste caracterul $, printarea se opreste)
    newline db 10, 13, "$" ;spatiu+enter (coduri ASCII) + EOL char
    nbsp db 32, "$" ;spatiu in ASCII + EOL char
    attributes db 0Eh, 0Ch, 0Dh, 0Ah, 0Fh, 0Bh, 08h, 07h, 09h, 0Eh, 0Ch ;coduri hexazecimale pentru culori BIOS, (0x e in fata binar, h la sfarsit e hexa)
.code
    mov ax,@data ;incarcam segmentul de date printr-un registru general (nu poate fi incarcat direct dintr-o constanta, decat printr-un reg. general sau adresa de memorie)
    mov ds,ax ;incarcam segmentul de date in registrul data segment (altfel nu il putem printa mai jos, deoarece 'int ah,02h' printeaza din registrul ds:dx)

    mov si,0 ;setam registrul source index la 0 (ne folosim de ele mai jos), si ajuta la parcurgerea stringului de caractere
    mov di,0 ;setam registrul data index la 0, di ajuta la parcurgerea atributelor de culoare
    mov cx,0 ;setam registrul general cx la 0, ajuta la adaugarea spatiilor inaintea fiecarui caracter

add_nbsp: ;facem o directiva(?) functie(?) numita add_nbsp pentru a adauga spatiu inaintea fiecarui caracter printat (a.i. sa nu repetam codul pt fiecare spatiu necesar, daca avem un cuvant de 30 litere ar trebui sa copiem codul de 30 ori, pt a obtine indentare de la 0 la 29 spatii.)
    cmp cx,di ; facem comparatie intre registrul cx si di 
    je print_loop ; instructiune jump-equal - daca acestea sunt egale, executam print_loop - daca nu, codul din josul acestei linii
    mov dl,nbsp ;incarcam in registrul general de date, lower8bit, datele preluate din @data nbsp
    mov ah,02h ;punem in registrul a high 8bit functia 02h care executa display output (preluat din registrul dl), asta e predefinit de microsoft, 21h se uita in registrul ah mereu si verifica ce avem in el, in cazul de fata avem functia 02h care e 'display output'
    int 21h ;interrupt 21
    inc cx ;incrementam cx, pt a adauga n spatii inaintea fiecarui caracter
    jmp add_nbsp ; sarim inapoi la inceputul directivei? functiei? si o parcurgem din nou (facand toate verificarile de mai sus)

print_loop: 
    mov dl,text[si] ;incarcam in registrul dl caracterul aflat la indexul 'si', iar cu fiecare iteratie peste loop, acesta creste cu o valoare
    mov cx,1 ;printeaza doar un caracter, altfel printeaza toata lungimea stringului (ex: 'H' + 4 spatii goale, pt ca dupa H mai sunt 4 caractere - 'ello')
    cmp dl,'$' ;verificam daca e end of line character
    je done ;daca e end of line, executam done (mai jos) si terminam procesul

    mov ah,09h ; printam string de caractere (preluat din ds:dx, pointer catre un oarecare string cu EOL '$')
    mov bh,0    ; numarul paginii 10 de comenzi (INT 10,0) (0 pt pagina video standard, 1 pt cursor type, 3 pt cursor position etc.) -- merge si fara (e default 0)
    mov bl,[attributes + di] ; incarcam atributul (codul de culoare definit mai sus) + un offset di, incrementat treptat
    int 10h      ; setam video modeul (din bh) si un BIOS interrupt pt printare

    mov ah,02h ;printam pe stdout (display)
    int 21h ;interrupt call 02h de mai sus

    mov dl,newline ;incarcam  din segmentul de date, segmentul newline in registrul dl
    mov ah,02h ;printam stdout
    int 21h ;interrupt call 02h de mai sus

    inc si ;incrementam source indexul, astfel incat urmatoarea instructiune sa printeze urmatorul caracter (definit sus in @data)
    inc di ;incrementam data indexul, astfel incat urmatoarea instructiune sa printeze urmatorul atribut de culoare (definit sus in @data)
    mov cx,0 ;setam cx la 0, astfel incat urmatoarea instructiune incepe de la capat (cx = 0, di != 0 /// daca nu e primul pass-through, astfel stim cate spatii sa adaugam in fata fiecarui caracter) - verificarea asta are loc in add_nbsp
    jmp add_nbsp ;sarim la add_nbsp


done: ;terminam procesul 
    mov ax,4c00h ;terminam procsul cu un return code (stocat in AL pt batch process, AH e 4C)
    int 21h ;terminam programul

end

