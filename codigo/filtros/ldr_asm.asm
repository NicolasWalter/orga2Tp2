 %define tam_4pxs 16


global ldr_asm

section .data
;!!!!!!!!!!!!!!!!!!!!!!!!!!! VER SI TIENEN QUE SER DD DW O QUE MIERDA
maximo: DD 0.000000205 , 0.000000205 , 0.000000205 , 0.000000205  
Alpha: DD 255 , 255 , 255 , 255 ;mierda para testear
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

pxor xmm6,xmm6		;Acum Col 0
pxor xmm7,xmm7		;Acul Col 1
pxor xmm8,xmm8		;Acul Col 2
pxor xmm9,xmm9		;Acul Col 3
pxor xmm10,xmm10	;Acul Col 4
pxor xmm11,xmm11	;Acul Col 5
pxor xmm12,xmm12	;Acul Col 6
pxor xmm13,xmm13	;Acul Col 7
pxor xmm14,xmm14	;Acul Col 8
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
			movdqu xmm1,xmm0
			;		XXXXXXXX
			;		XXXXXXXX
			;		XXPPPPXX
			;		XXXXXXXX
			;		XXXXXXXX


			punpcklbw xmm0,xmm15 ;[ a1 | r1 | g1 | b1 || a0 | r0 | g0 | b0 ]
			punpckhbw xmm1,xmm15 ;[ a3 | r3 | g3 | b3 || a2 | r2 | g2 | b2 ]

			movdqu xmm2,xmm0
			movdqu xmm3,xmm1

			psrlq xmm2,16
			psrlq xmm3,16

			paddw xmm0,xmm2
			paddw xmm1,xmm3

			psrlq xmm2,16
			psrlq xmm3,16

			paddw xmm0,xmm2;en cada B tengo la suma
			paddw xmm1,xmm3;en cada B tengo la suma
			;[ a1 | f | f | s || a0 | f | f | s ]
			;					 11   10  01  00	
			pshuflw xmm0,xmm0, 11000000b ;meti la suma
			pshufhw xmm0,xmm0, 11000000b
			pshuflw xmm1,xmm1, 11000000b ;meti la suma
			pshufhw xmm1,xmm1, 11000000b

			packuswb xmm0,xmm1 ;


			; paddw xmm0,xmm1 ;[a1+a3 | r1+r3 ...|| a0+a2 ..| b0+b2]
			; movdqu xmm1,xmm0
			; punpcklwd xmm0,xmm15;[ a0+a2 | r0+r2 | g0+g2 | b0+b2 ]
			; punpckhwd xmm1,xmm15;[ a1+a3 | r1+r3 | g1+g3 | b1+a3 ]
			


			;ESTO ES NUEVO, DESEMPAQUETE ACA TAMBIEN 
			; movdqu xmm2,xmm1
			; movdqu xmm3,xmm2
			; movdqu xmm1,xmm0
			; punpcklwd xmm0,xmm15;p0
			; punpckhwd xmm1,xmm15;p1
			; punpcklwd xmm2,xmm15;p2
			; punpckhwd xmm3,xmm15;p3



			cmp r11,0
			je .sonDeLasPrimeras4Cols
			jmp .sonDeLasSegundas4Cols

			.sonDeLasPrimeras4Cols:

			;[s3|s2|s1|s0]+
			;[sp3|sp2|sp1|sp0]

			paddb xmm13,xmm0
			add r11,4

			.sonDeLasSegundas4Cols

			paddb xmm14,xmm0
			add r11,4


			; paddd xmm0,xmm1
			; paddd xmm0,xmm2 ;		11		10			01		00
			; paddd xmm0,xmm3 ; [ a+a+a+a | r+r+r+r | g+g+g+g | b+b+b+b ]
			


			; movdqu xmm1,xmm0
			; pshufd xmm1,xmm1,11111001b ;[ a+a+a+a | a+a+a+a  | r+r+r+r | g+g+g+g ]
			; paddd xmm0,xmm1
			; pshufd xmm1,xmm1,11111101b;[ a+a+a+a | a+a+a+a  | a+a+a+a  | r+r+r+r]
			; paddd xmm0,xmm1; me queda en B la suma 4b+4g+4r
			; pshufd xmm0,xmm0, 00000000b
			; paddd xmm14,xmm0
			; add r11,4



			;paddd xmm0,xmm1;[a0+a2+a1+a3 |...| b0+b2+b1+b3]
			; movdqu xmm1,xmm0

			; psrld xmm0,16
			; paddd xmm1,xmm0
			; psrld xmm0,16
			; paddd xmm1,xmm0; deberia tener la super suma en B [Fruta | fruta | fruta | b0+...+b3+...+g0+ .. g4]
			; pshufd xmm1,xmm1, 00000000b ;meti la suma en todos lados 
			; paddd xmm14,xmm1 ;acumulo en 14 la super suma ?
			; add r11, 1  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; sumo 1? o sumo mas???????
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
		;psrld xmm14,16

		movdqu xmm7,xmm13;suma primeras 4
		movdqu xmm8,xmm14; suma otras 4  [7 6 5 4]


		;Laburo con el pixel 0
		movdqu xmm9,xmm7;copia de la copia :O
		pshufd xmm9,xmm9,11111001b
		paddd xmm7,xmm9
		pshufd xmm9,xmm9,11111101b
		paddd xmm7,xmm9
		pshufd xmm7,xmm7,00000000b;tengo la suma 4 veces

		pshufd xmm8,xmm8,00000000b

		paddd xmm7,xmm8

		movdqu xmm9,xmm0
		pmuldq xmm9,xmm7

		movdqu xmm8,[Alpha]
		pmuldq xmm9,xmm8
		cvtdq2ps xmm9,xmm9
		movdqu xmm8,[maximo]
		mulps xmm9,xmm8
		cvtps2dq xmm9,xmm9
		paddq xmm0,xmm9

		;Laburo con el pixel 1





		; movdqu xmm10,xmm0
		; movdqu xmm11,xmm1
		; movdqu xmm12,xmm2
		; movdqu xmm13,xmm3

		;  pmuldq xmm0,xmm14 ;es la posta?
		;  pmuldq xmm1,xmm14
		;  pmuldq xmm2,xmm14
		;  pmuldq xmm3,xmm14

		; movdqu xmm8,[Alpha]

		;  pmuldq xmm0,xmm8 ;r*s*ALFA
		;  pmuldq xmm1,xmm8
		;  pmuldq xmm2,xmm8
		;  pmuldq xmm3,xmm8

		; cvtdq2ps xmm0,xmm0
		; cvtdq2ps xmm1,xmm1
		; cvtdq2ps xmm2,xmm2
		; cvtdq2ps xmm3,xmm3

		; movdqu xmm8,[maximo]

		; mulps xmm0,xmm8
		; mulps xmm1,xmm8
		; mulps xmm2,xmm8
		; mulps xmm3,xmm8

		; cvtps2dq xmm0,xmm0
		; cvtps2dq xmm1,xmm1
		; cvtps2dq xmm2,xmm2
	 ; 	cvtps2dq xmm3,xmm3

		; paddd xmm10,xmm0
		; paddd xmm11,xmm1
		; paddd xmm12,xmm2
		; paddd xmm13,xmm3

	


	 ; 	packusdw xmm10,xmm11
	 ; 	packusdw xmm12,xmm13
	 ; 	packuswb xmm10,xmm12
















		; mulpd xmm1,xmm14 ;r*s falta el ALFA 
		; mulpd xmm1,[wacharaka]
		; mulpd xmm1,[multiplicadores] ;divido
		; paddd xmm1,xmm0





		movdqu[rsi+r9],xmm10
		jmp .volverACiclo
	.finVecInterior:
	inc r8
	mov r11,-2
	jmp .cicloVecinosExterior



	.volverACiclo:
	;inc r13
	add r13,4
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
 
	
	