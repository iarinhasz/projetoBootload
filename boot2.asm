org 0x500        ;endereço de memória em que o programa será carregado
jmp 0x0000:start  ;far jump - seta cs para 0

string1 db 'Loading ...',10,13,0
string2 db 'Loading ...',10,13,0
string5 db 'Loading ...',10,13,0



start:
    xor ax, ax  
    mov ds, ax  
    mov es, ax  
    xor bx, bx
    xor cx, cx
    xor dx, dx

    call screen_clear

    mov si,string1
    call impressao
    mov si,string2
    call impressao
    call delay
    mov si,string5
    call impressao
    call delay

    call screen_clear
    jmp acabou

delay:
	mov cx,10
	mov dx,300
	mov ah, 86h
    	int 15h
    	ret

screen_clear:
    mov ax,12h
    int 10h
    ret


impressao:
    lodsb

    cmp al , 0
    je .exit

        mov ah, 0eh
	    mov bx, 15
        mov bh,0
        int 10h

        xor ax,ax
        call teclado_delay

    jmp impressao

    .exit:
            ;call espacos
            ret
teclado_delay:
    mov cx, 1
    mov dx, 1500
    mov ah, 86h
    int 15h
    ret


acabou:

    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ax, 0x7e0 ;0x7e0<<1 = 0x7e00 (início de kernel.asm)
    mov es, ax
    xor bx, bx    ;posição es<<1+bx

    jmp reset

reset:
    mov ah, 00h ;reseta o controlador de disco
    mov dl, 0   ;floppy disk
    int 13h

    jc reset    ;se o acesso falhar, tenta novamente

    jmp load

load:
    mov ah, 02h ;lê um setor do disco
    mov al, 20  ;quantidade de setores ocupados pelo kernel
    mov ch, 0   ;track 0
    mov cl, 3   ;sector 3
    mov dh, 0   ;head 0
    mov dl, 0   ;drive 0
    int 13h

    jc load     ;se o acesso falhar, tenta novamente

    jmp 0x7e00  ;pula para o setor de endereco 0x7e00 (start do boot2)

