 %define tam_4pxs 16


global ldr_asm

section .data

section .text
;void ldr_asm    (
	;unsigned char *src,		RDI
	;unsigned char *dst,		RSI	
	;int filas,					RDX
	;int cols,					RCX
	;int src_row_size,			R8
	;int dst_row_size,			R9
	;int alpha)					--R10

ldr_asm:
push rbp
mov rbp,rsp
push r12
push r13
push r14
push r15

xor r10,r10
mov r10d, [rbp+16] ; alpha
mov r12,2 ;indice fila en 2
mov r13,8 ; indice col en 2
mov r14,rdx
mov r15,rcx
sub r14,2;TOPE FILA
sub r15,8;TOPE COL

xor rdx,rdx
xor r9,r9
pcmpeqw xmm0,xmm0
.ciclo:
	
	cmp r12,10
	je .fin
	cmp r13,10
	jge .cambioFila

	mov r9,r12  ;meto la fila en la que estoy laburando
	imul r9,rcx ;indiceFila * #columnas
	shl r9,2
	mov rdx, r13
	shl rdx, 2
	add r9,rdx


	movdqu [rsi +r9],xmm0
	lea rsi,[rsi+r9]


	;inc r13
	add r13,4
	jmp .ciclo

	.cambioFila:
	inc r12
	mov r13,8
	jmp .ciclo


.fin:
pop r15
pop r14
pop r13
pop r12
pop rbp
ret
 
