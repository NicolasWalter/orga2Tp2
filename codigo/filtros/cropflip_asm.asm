 %define tam_4pxs 16
section .data
 multiplicadores: DB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 
 ; %define TAMX [rbp+16]
; %define TAMY [rbp+24]
; %define OFFSETX [rbp+32]
; %define OFFSETY [rbp+40]
global cropflip_asm

section .text
;void cropflip_asm(unsigned char *src,  unsigned char *dst, int cols, int filas, int src_row_size, int dst_row_size, int tamx, int tamy, int offsetx, int offsety);
; 						RDI,      					RSI,     RDX ,     RCX,        R8,             R9

 cropflip_asm:
push rbp
mov rbp, rsp
push r12
push r13
push r14
push r15

; imul rcx, rdx
; shr rcx, 2  
pxor xmm0, xmm0
pxor xmm7, xmm7
xor rcx, rcx
xor r8, r8
xor r9, r9
xor rax, rax
xor r10, r10 ; indice "i" fuente
xor r11, r11  ; indice "j" fuente
; xor r12,r12 ; indice i destino
; xor r13,r13 ; indice j destino
xor r14, r14
xor r15, r15
mov r9d, [rbp+16]  ;tam x CAPAZ PISO CACA 
mov r14d, [rbp+24]  ; tamy
mov r15d, [rbp+32]  ; offsetx
mov eax, [rbp+40]  ;offsety
mov r8d, r14d ; TIENE TAMY
; “puntero al inicio de la matriz” + “cantidad elementos de la fila” * “indice de fila” * “tamaño dato” ++ “indice de columna” * “tamano dato”
.ciclo:

	cmp r10, r14  ; si el indice de la fila = tamy
	je .fin
	
	cmp r11, r9 ;veo si r11 llego al tope de la fila
	jge .cambioFila

	add r14, rax 	;tamy + off
	sub r14, r10	;tamy + off - i
	dec r14			;tamy + off -i -1
	mov r12, rax
	mov rax, rdx
	imul r14, rdx
	;mul r14			;(tamy + off -i -1)*cols
	;mov r14, rax
	mov rax, r12

	add r15, r11	;ox+j
	add r14, r15;
	movdqu xmm0, [rdi+r14*4]  ; si copie bien, formula sacada de la diapo para moverme en matrices
	
	mov r14, r8
	sub r15, r11

	

	movdqu [rsi], xmm0
	lea rsi, [rsi+tam_4pxs]


	;inc r11
	add r11, 4
	jmp .ciclo

	.cambioFila
	inc r10
	mov r11, 0
	jmp .ciclo

	;tamy + of f sety − i − 1, of f setx + j
	




.fin:
pop r15
pop r14
pop r13
pop r12
pop rbp
ret

	;Prueba para poner todo en blanco
	; pcmpeqw xmm7,xmm7
	; movups [rsi], xmm7
	; lea rsi, [rsi+tam_4pxs]
	;posta