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

; imul rcx, rdx
; shr rcx, 2  
xor xmm0,xmm0
pxor xmm7, xmm7
xor r13,r13
xor r12,r12 
xor r11, r11
xor r10, r10
xor rdx,rdx
xor rax, rax
mov r11, [rbp+16]  ;tam x
mov r12, [rbp+24]  ; tamy
mov r13, [rbp+32]  ; offsetx
mov rax, [rbp+40]  ;offsety
mov r10, rax ; EN R10 TENGO EL INDICE i, arranca en offsety
mov r11, rdx ; en r11 indice J, arranca en offsetx 
; “puntero al inicio de la matriz” + “cantidad elementos de la fila” * “indice de fila” * “tamaño dato” ++ “indice de columna” * “tamano dato”
.ciclo:

	cmp r10, rcx  ; si el indice de la fila = #filas termine
	jne .seguir

	jmp .fin

	.seguir:
	add rax,2

	movdqu xmm0, [rdi+r8*(r10*TAM_4PXS)+r11*TAM_4PXS]  ; si copie bien, formula sacada de la diapo para moverme en matrices
	


	cmp r11, rdx
	je .cambioFila
	inc r11
	jmp .ciclo
		.cambioFila:
			inc r10
			mov r11, r13
			jmp .ciclo











.fin:
pop r13
pop r12
pop rbp
ret
