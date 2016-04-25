 %define tam_4pxs 16


global ldr_asm

section .data
;!!!!!!!!!!!!!!!!!!!!!!!!!!! VER SI TIENEN QUE SER DD DW O QUE MIERDA
maximo: DD 0.000000205 , 0.000000205 , 0.000000205 , 0.000000205  
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
mov r13,2 ; indice col en 2
mov r14,rdx
mov r15,rcx
sub r14,2;TOPE FILA
sub r15,2;TOPE COL

xor rdx,rdx
xor r9,r9
pxor xmm15,xmm15 ;lo voy a usar para desempaquetar
pxor xmm0,xmm0
pxor xmm1,xmm1
pxor xmm2,xmm2
pxor xmm3,xmm3
pxor xmm4,xmm4
pxor xmm5,xmm5
pxor xmm6,xmm6		
pxor xmm7,xmm7		
pxor xmm8,xmm8		
pxor xmm9,xmm9		
pxor xmm10,xmm10	
pxor xmm11,xmm11	
pxor xmm12,xmm12	
pxor xmm13,xmm13	
pxor xmm14,xmm14	
.ciclo:
	
	cmp r12,r14
	je .fin
	cmp r13,r15
	jge .cambioFila

	; mov r9,r12  ;meto la fila en la que estoy laburando
	; imul r9,rcx ;indiceFila * #columnas
	; shl r9,2 ;fila*cols*4
	; mov rdx, r13
	; shl rdx, 2 ;j*4
	; add r9,rdx ;(fila*cols*4)+(j*4)
	; ;[rsi+r9] 4 pixeles a laburar
	; movdqu xmm0,[rsi+r9]; meto los 4 pxs, quiero laburar con 1 solo

	mov r8,-2
	.cicloVecinosExterior:
		cmp r8,2
		jg .finVecExterior
		mov r11,-2
		.cicloVecinosInterior:
			cmp r11,2
			jg .finVecInterior
			mov r9,r12 ;meto i
			add r9,r8 ; i + iaux =filaNueva
			imul r9,rcx; (filaNueva)*cols
			shl r9,2 ; filaNueva*cols*4
			mov rdx,r13; meto el j
			add rdx,r11;j+jaux =ColNueva
			shl rdx,2 ;ColNueva*4
			add r9,rdx

			;levanto esos 4 del source
			movdqu xmm0,[rdi+r9]
			movdqu xmm1,xmm0 ;[a r g b a r g b a r g b a r g b]
			movdqu xmm2,xmm0
			pslld xmm1,24
			psrld xmm1,24 ;[000b 000b 000b 000b]

			pslld xmm2,8
			psrld xmm2,24 ;[000r000r000r000r]

			pslld xmm0,16
			psrld xmm0,24

			paddw xmm0,xmm1
			paddw xmm0,xmm2


			; punpcklbd xmm0,xmm15 ;[ a1 | r1 | g1 | b1 || a0 | r0 | g0 | b0 ]
			; punpckhbw xmm1,xmm15 ;[ a3 | r3 | g3 | b3 || a2 | r2 | g2 | b2 ]

			; movdqu xmm2,xmm0
			; movdqu xmm3,xmm1

			; psrlq xmm2,16
			; psrlq xmm3,16

			; paddw xmm0,xmm2
			; paddw xmm1,xmm3

			; psrlq xmm2,16
			; psrlq xmm3,16

			; paddw xmm0,xmm2;en cada B tengo la suma
			; paddw xmm1,xmm3;en cada B tengo la suma
			; ;[ a1 | f | f | s || a0 | f | f | s ]
			; ;					 11   10  01  00	
			; pshuflw xmm0,xmm0, 11000000b ;meti la suma
			; pshufhw xmm0,xmm0, 11000000b
			; pshuflw xmm1,xmm1, 11000000b ;meti la suma
			; pshufhw xmm1,xmm1, 11000000b ; [A S S S | A S S S]

			; ; psllq xmm1,16
			; ; psllq xmm1,16
			; ; psllq xmm1,16
			; ; psllq xmm0,16
			; ; psllq xmm0,16
			; ; psllq xmm0,16
			; ; psrlq xmm1,16
			; ; psrlq xmm0,16
			; ; psrlq xmm0,16
			; ; psrlq xmm0,16

			; ; paddd xmm0,xmm1
			; packuswb xmm0,xmm1 ;


			cmp r11,-2
			je .sonDeLasPrimeras4Cols
			jmp .sonDeLasSegundas4Cols

			.sonDeLasPrimeras4Cols:

			;[s3|s2|s1|s0]+
			;[sp3|sp2|sp1|sp0]

			paddd xmm13,xmm0
			add r11,4

			.sonDeLasSegundas4Cols

			paddd xmm14,xmm0
			add r11,4
jmp .cicloVecinosInterior


	.finVecExterior:
		mov r9,r12  ;meto la fila en la que estoy laburando
		imul r9,rcx ;indiceFila * #columnas
		shl r9,2 ;fila*cols*4
		mov rdx, r13
		shl rdx, 2 ;j*4
		add r9,rdx ;(fila*cols*4)+(j*4)
		movdqu xmm0, [rdi+r9] ;con la cuenta saque la posicion de los 4 que voy a modificar
		
		movdqu xmm2,xmm0
		punpcklbw xmm0,xmm15
		punpckhbw xmm2,xmm15
		movdqu xmm3,xmm2
		movdqu xmm1,xmm0

		punpcklwd xmm0,xmm15 ; p0 ---> col0 1 2 3 4
		punpckhwd xmm1,xmm15 ; p1 ---> col1 2 3 4 5
		punpcklwd xmm2,xmm15 ; p2----> col2 3 4 5 6
		punpckhwd xmm3,xmm15 ; p3----> col3 4 5 6 7


		movdqu xmm4,xmm13
		movdqu xmm6,xmm13
		punpcklbw xmm4,xmm15
		punpckhbw xmm6,xmm15

		movdqu xmm5,xmm4
		movdqu xmm7,xmm6

		punpcklwd xmm4,xmm15 ;SUMA COL 0
		punpckhwd xmm5,xmm15 ;SUMA COL 1
		punpcklwd xmm6,xmm15 ;SUMA COL 2
		punpckhwd xmm7,xmm15 ;SUMA COL 3

		movdqu xmm8,xmm14
		movdqu xmm10,xmm14
		punpcklbw xmm8,xmm15
		punpckhbw xmm10,xmm15

		movdqu xmm9,xmm8
		movdqu xmm11,xmm10

		punpcklwd xmm8,xmm15 ;SUMA COL 4
		punpckhwd xmm9,xmm15 ;SUMA COL 5
		punpcklwd xmm10,xmm15 ;SUMA COL 6
		punpckhwd xmm11,xmm15 ;SUMA COL 7


 
		;Pixel 0(col0 a col4)
		pxor xmm13,xmm13
		paddd xmm13,xmm4
		paddd xmm13,xmm5
		paddd xmm13,xmm6
		paddd xmm13,xmm7
		paddd xmm13,xmm8

		movdqu xmm12,xmm0
		pmuldq xmm12,xmm13

		movd xmm13,r10d;meto el alpha
		pmuldq xmm12,xmm13
		cvtdq2ps xmm12,xmm12
		movdqu xmm13,[maximo]
		mulps xmm12,xmm13
		cvtps2dq xmm12,xmm12
		paddq xmm0,xmm12

		;Pixel 1(col1 a col5)
		pxor xmm13,xmm13
		paddd xmm13,xmm5
		paddd xmm13,xmm6
		paddd xmm13,xmm7
		paddd xmm13,xmm8
		paddd xmm13,xmm9

		movdqu xmm12,xmm1
		pmuldq xmm12,xmm13

		movd xmm13,r10d;meto el alpha
		pmuldq xmm12,xmm13
		cvtdq2ps xmm12,xmm12
		movdqu xmm13,[maximo]
		mulps xmm12,xmm13
		cvtps2dq xmm12,xmm12
		paddq xmm1,xmm12

		;Pixel 2
		pxor xmm13,xmm13
		paddd xmm13,xmm6
		paddd xmm13,xmm7
		paddd xmm13,xmm8
		paddd xmm13,xmm9
		paddd xmm13,xmm10

		movdqu xmm12,xmm2
		pmuldq xmm12,xmm13

		movd xmm13,r10d;meto el alpha
		pmuldq xmm12,xmm13
		cvtdq2ps xmm12,xmm12
		movdqu xmm13,[maximo]
		mulps xmm12,xmm13
		cvtps2dq xmm12,xmm12
		paddq xmm2,xmm12

		;Pixel 3
		pxor xmm13,xmm13
		paddd xmm13,xmm7
		paddd xmm13,xmm8
		paddd xmm13,xmm9
		paddd xmm13,xmm10
		paddd xmm13,xmm11

		movdqu xmm12,xmm3
		pmuldq xmm12,xmm13

		movd xmm13,r10d;meto el alpha
		pmuldq xmm12,xmm13
		cvtdq2ps xmm12,xmm12
		movdqu xmm13,[maximo]
		mulps xmm12,xmm13
		cvtps2dq xmm12,xmm12
		paddq xmm3,xmm12



		packusdw xmm0,xmm1
	  	packusdw xmm2,xmm3
	  	packuswb xmm0,xmm2

		movdqu[rsi+r9],xmm0
		jmp .volverACiclo


	.finVecInterior:
	inc r8
	mov r11,-2
	jmp .cicloVecinosExterior



	.volverACiclo:
	;inc r13
	add r13,4
	pxor xmm14,xmm14
	pxor xmm13,xmm13
	jmp .ciclo

	.cambioFila:
	inc r12
	mov r13,2
	jmp .ciclo


.fin:
pop r15
pop r14
pop r13
pop r12
pop rbp
ret
	