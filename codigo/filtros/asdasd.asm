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
;xor rdx,rdx
xor rax, rax
mov r11, [rbp+16]  ;tam x
mov r12, [rbp+24]  ; tamy
mov r13, [rbp+32]  ; offsetx
mov rax, [rbp+40]  ;offsety
mov r10, rax ; EN R10 TENGO EL INDICE i, arranca en offsety
;mov r11, rdx ; en r11 indice J, arranca en offsetx 


mov r8,r11
shr r8,2 ; tamx/4
mov r9,0 ;mi i
; “puntero al inicio de la matriz” + “cantidad elementos de la fila” * “indice de fila” * “tamaño dato” ++ “indice de columna” * “tamano dato”
.cicloExterior:
	cmp r9,r12 ; i<tamy
	jne .preCicloInterior
	jmp .fin
	.preCicloInterior
	mov r10,0
	.cicloInterior:
		cmp r10,r8 ; j con tamx/4
		jne .seguirInterior
		jmp .finCicloInterior
		.seguirInterior:
		movups xmm0,[rdi] ;meti 4 pixeles

		movups xmm1,[rdi+]

		lea rdi, [rdi + tam_4pxs]; muevo el puntero al siguiente bloque de 4pxs
		inc r10
		jmp .cicloInterior


	.finCicloInterior:
	lea rdi, [rdi + rdx - r11];super salto
	inc r9
	jmp .cicloExterior
