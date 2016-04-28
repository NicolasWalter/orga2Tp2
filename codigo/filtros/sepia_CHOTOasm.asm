%define tam_px 4

section .data
 multiplicadores: DD 0.2 , 0.3 , 0.5 , 1.0
 byteshuffle: 	  DB 0x00, 0x04, 0x08, 0x0C,0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF 
 max:			  DD 255, 255, 255, 255

DEFAULT REL

section .text
global sepia_asm
sepia_asm:
;COMPLETAR
;uchar *src,u char *dst, int cols, int filas, int src_row_size, int dst_row_size)
;       RDI,      RSI,     RDX ,     RCX,        R8,             R9

push rbp
mov rbp, rsp
push r12
mov r10, 0
imul rcx, rdx
;shr rcx, 2  ; esta bien pisar esto?
pxor xmm7, xmm7
pxor xmm8, xmm8
pxor xmm9, xmm9
movdqu xmm9, [max]
movups xmm8, [multiplicadores]
	.ciclo:

	pxor xmm0, xmm0
	pxor xmm1, xmm1
	cmp r10, rcx 
	jne .seguir

	jmp .fin

	.seguir:
	
	xor r12, r12

	mov r12d, [rdi] ; donde arranca la matriz, despues incrementamos rdi de a 1 px [ p3 | p2 | p1 | p0 ]

	movd xmm0, r12d ; xmm1 = xmm0= [ 0 | 0 | 0 | p0 ]

	punpcklbw xmm0, xmm7 ; xmm0 = [ 0 | 0 | 0 | 0 || a | r | g | b ]

	movdqu xmm1, xmm0 ; xmm1 = xmm0 = [ 0 | 0 | 0 | 0 || a | r | g | b ]

	psrlq xmm1, 16 ; [ 0 | 0 | 0 | 0 || 0 | a | r | g ]				

	paddw xmm0, xmm1 ; [ 0 | 0 | 0 | 0 || a+0 | r+a | g+r | b+g ]

	psrlq xmm1, 16 ; [ 0 | 0 | 0 | 0 || 0 | 0 | a | r ]

	paddw xmm0, xmm1 ; [ 0 | 0 | 0 | 0 || a+0+0 | r+a+0 | g+r+a | b+g+r ]	
		
	punpcklwd xmm0,xmm7  ; [ a+0+0 | r+a+0 | g+r+a | b+g+r ]

	pshufd xmm0, xmm0, 11000000b

	cvtdq2ps xmm0,xmm0 ; [ a+0+0 | r+a+0 | g+r+a | b+g+r ] en SP
	
	mulps xmm0, xmm8 ; [ a+0+0  * 1.0 | r+a+0 * 0.5 | g+r+a 0.3 | b+g+r 0.2 ] en SP
	
	cvtps2dq xmm0,xmm0 ; [ a+0+0  * 1.0 | r+a+0 * 0.5 | g+r+a 0.3 | b+g+r 0.2 ] en Integer

	pminud xmm0, xmm9

	pshufb xmm0, [byteshuffle] 

	pextrd r12d, xmm0, 0

	mov [rsi], r12d

	lea rsi, [rsi+tam_px]

	lea rdi, [rdi + tam_px] ; muevo el puntero al siguiente pixel
	
	inc r10
	
	jmp .ciclo

	.fin:
	pop r12
	pop rbp
	ret