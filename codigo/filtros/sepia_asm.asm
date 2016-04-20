%define tam_4pxs 16

section .data
 multiplicadores: DD 0.2 , 0.3 , 0.5 , 1.0

DEFAULT REL

section .text
global sepia_asm
sepia_asm:
;COMPLETAR
;uchar *src,u char *dst, int cols, int filas, int src_row_size, int dst_row_size)
;       RDI,      RSI,     RDX ,     RCX,        R8,             R9
push rbp
mov rbp, rsp
mov r10, 0
imul rcx, rdx
shr rcx, 2  ; esta bien pisar esto?
pxor xmm7, xmm7
pxor xmm8, xmm8
movups xmm8, [multiplicadores]
	.ciclo:

	cmp r10, rcx 
	jne .seguir

	jmp .fin

	.seguir:
	movups xmm0, [rdi] ; donde arranca la matriz, despues incrementamos rdi de a 4 pxs [ p3 | p2 | p1 | p0 ]

	movups xmm1, xmm0 ; xmm1=xmm0=[ p3 | p2 | p1 | p0 ]

	punpcklbw xmm0, xmm7 ; xmm0 = [ 0 a1 | 0  r1 | 0 g1 | 0  b1 | 0  a0 | 0  r0 | 0  g0 | 0  b0 ]

	punpckhbw xmm1, xmm7  ;probar si funca o hay que usar wd [ 0 a3 | 0  r3 | 0 g3 | 0  b3 | 0  a2 | 0  r2 | 0  g2 | 0  b2 ]

	movups xmm2, xmm0 ; xmm2 = xmm0 = [ 0 a1 | 0  r1 | 0 g1 | 0  b1 | 0  a0 | 0  r0 | 0  g0 | 0  b0 ]

	movups xmm3, xmm1 ; xmm3 = xmm1 = [ 0 a3 | 0  r3 | 0 g3 | 0  b3 | 0  a2 | 0  r2 | 0  g2 | 0  b2 ]

	psrlq xmm2, 2 ; [ 0 0 | 0 a1 | 0 r1 | 0 g1 ||| 0  0 | 0  a0 | 0  r0 | 0  g0 ]				

	psrlq xmm3, 2	; [ 0 0 | 0 a3 | 0 r3 | 0 g3 ||| 0  0 | 0  a2 | 0  r2 | 0  g2 ]		

	paddw xmm0, xmm2 ; acumulo b + g

	paddw xmm1, xmm3 ; acumulo b + g

	psrlq xmm2, 2	; [ 0 0 | 0 0 | 0 a1 | 0 r1 ||| 0  0 | 0  0 | 0  a0 | 0  r0 ]						

	psrlq xmm3, 2	; [ 0  0 | 0 0 | 0 a3 | 0 r3 ||| 0 0 | 0 0 | 0 a2 | 0 r2 ]					

	paddw xmm0, xmm2 ; acumulo (b+g) + r EN B 
	paddw xmm1, xmm3 ; acumulo (b+g) + r EN B
	
	movups xmm2, xmm1 ;CHEQUEAAR
	movups xmm3, xmm1; CHEQUEAAR


; EN XMMI TENGO PIXEL I (i !=7)
	punpcklwd xmm2,xmm7 
	punpckhwd xmm3, xmm7
	movups xmm1, xmm0 
	punpcklwd xmm0, xmm7
	punpckhwd xmm1, xmm7

	;METO SUMA EN TODOS LADOS EXCEPTO EN LAS A
	pshufd xmm0, xmm0, 11000000b
	pshufd xmm1, xmm1, 11000000b
	pshufd xmm2, xmm2, 11000000b
	pshufd xmm3, xmm3, 11000000b

	; PASO TODOS A FLOAT
	cvtdq2ps xmm0,xmm0 
	cvtdq2ps xmm1,xmm1 
	cvtdq2ps xmm2,xmm2 
	cvtdq2ps xmm3,xmm3 

	mulps xmm0, xmm8
	mulps xmm1,xmm8 
	mulps xmm2,xmm8
	mulps xmm3,xmm8

	; convierto a enteros de nuevo 
	cvtps2dq xmm0,xmm0 
	cvtps2dq xmm1,xmm1 
	cvtps2dq xmm2,xmm2 
	cvtps2dq xmm3,xmm3 

	packusdw xmm1, xmm0
	packusdw xmm3, xmm2 
	packuswb xmm3,xmm1

	movups [rsi], xmm3

	lea rsi, [rsi+tam_4pxs]

	lea rdi, [rdi + tam_4pxs] ; muevo el puntero al siguiente bloque de 4 pxs
	inc r10
	jmp .ciclo




	.fin:
	pop rbp
	ret


	