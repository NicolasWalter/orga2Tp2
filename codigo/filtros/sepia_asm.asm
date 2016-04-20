%define tam_4pxs 16

section .data
DEFAULT REL

section .text
global sepia_asm
sepia_asm:
;COMPLETAR
;uchar *src,u char *dst, int cols, int filas, int src_row_size, int dst_row_size)
;       RDI,      RSI,     RDX ,     RCX,        R8,             R9
push rbp
mov rbp, rsp
; extender para la suma
mov r10,0 ; iterador
imul rdx, rcx ; PISO RDX SIN SABER SI LO NECESITO
shr rdx, 2 ; columnas * filas /4, para iterar 
	.ciclo:
	cmp r10, rdx
	je .fin
	pxor xmm7, xmm7 ; xmm7 = 0 | 0 | . . . | 0
	movups xmm0, [rdi] ; donde arranca la matriz, despues incrementamos rdi de a 4 pxs

	movups xmm1, xmm0 ; ESTO MUEVE BIEN??

	punpcklbw xmm0, xmm7 ; xmm1 = 0 | a7 | . . . | 0 | a0

	punpckhbw xmm1, xmm7  ;probar si funca o hay que usar wd

	movups xmm2, xmm0

	movups xmm3, xmm1

	shr xmm2, 2				

	shr xmm3, 2				

	paddw xmm0, xmm2		;acumulo b + g

	paddw xmm1, xmm3		;acumulo b + g

	shr xmm2, 2				

	shr xmm3, 2				

	paddw xmm0, xmm2		;acumulo (b+g) + r EN B

	paddw xmm1, xmm3		;acumulo (b+g) + r EN B

	0a0s0s0s|0a0s0s0s (buscar shuffle que mueva words)
	pasar a float cvt
	cambiar shifts por packed
	multiplicar cada color por el inmediato correspondiente
	ver que nada se pase de 255
	meter el resul de la multi en el pixel
	agarrar nuevos pixels.
	instrucciones float addps y  mulps, para multiplicar y sumar xmms, puede servirm ucho

	; ;punpcklbw xmm2, xmm7 ; xmm2 = 0 | a15 | . . . | 0 | a8
	
	; movdqu xmm2, xmm1 ; xmm2 = xmm1 = a15 | a14 | . . . | a1 | a0
	; punpcklbw xmm1, xmm7 ;000(A0)000(r0)000(g0)000(b0)
	; punpckhbw xmm2, xmm7;000(a1)000(r1)000(g1)000(b1)




	inc r10
	lea rdi, [rdi + tam_4pxs] ; muevo el puntero al siguiente bloque de 4 pxs
.fin:
pop rbp
ret


