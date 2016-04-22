%define TAM_4PXS 4
%define TAMX [rbp+16]
%define TAMY [rbp+24]
%define OFFSETX [rbp+32]
%define OFFSETY [rbp+40]
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
xor xmm0,xmm0
pxor xmm7, xmm7
xor rcx, rcx
xor r8, r8
xor r9, r9
xor rax, rax
xor r10, r10 ; indice "i" fuente
xor r11, r11  ; indice "j" fuente
xor r12,r12 ; indice i destino
xor r13,r13 ; indice j destino
xor r14, r14
xor r15, r15
mov r9, [rbp+16]  ;tam x CAPAZ PISO CACA 
mov r14, [rbp+24]  ; tamy
mov r15, [rbp+32]  ; offsetx
mov rax, [rbp+40]  ;offsety
mov r8, r14 ; TIENE TAMY
; “puntero al inicio de la matriz” + “cantidad elementos de la fila” * “indice de fila” * “tamaño dato” ++ “indice de columna” * “tamano dato”
.ciclo:

	cmp r10, r8  ; si el indice de la fila != tamy
	jne .seguir

	jmp .fin

	.seguir:
	add r14,rax
	sub r14,r10
	dec r14
	imul r14, rdx
	movdqu xmm0, [rdi+r14+(r15+r11)]  ; si copie bien, formula sacada de la diapo para moverme en matrices
	mov r14, r8
	;tamy + of f sety − i − 1, of f setx + j
	


	cmp r11, rdx
	je .cambioFila
	inc r11
	jmp .ciclo
		.cambioFila:
			inc r10
			mov r11, r13
			jmp .ciclo











; .fin:
; pop r15
; pop r14
; pop r13
; pop r12
; pop rbp
 ret