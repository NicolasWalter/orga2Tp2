 %define tam_4pxs 16


global ldr_asm

section .data
multiplicadores: DD 0.000000205 , 0.000000205 , 0.000000205 , 0.000000205
wacharaka: DW 255 , 255 , 255 , 255 ;mierda para testear
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
			movups xmm0,[rdi+r9]
			movups xmm1,xmm0

			punpcklbw xmm0,xmm15 ;[ a1 | r1 | g1 | b1 || a0 | r0 | g0 | b0 ]
			punpckhbw xmm1,xmm15 ;[ a3 | r3 | g3 | b3 || a2 | r2 | g2 | b2 ]
			
			paddw xmm0,xmm1 ;[a1+a3 | r1+r3 ...|| a0+a2 ..| b0+b2]
			movups xmm1,xmm0
			punpcklwd xmm0,xmm15;[ a0+a2 | r0+r2 | g0+g2 | b0+b2 ]
			punpckhwd xmm1,xmm15;[ a1+a3 | r1+r3 | g1+g3 | b1+a3 ]
			paddd xmm0,xmm1;[a0+a2+a1+a3 |...| b0+b2+b1+b3]
			movups xmm1,xmm0
			psrlq xmm0,16
			paddd xmm1,xmm0
			psrlq xmm0,16
			paddd xmm1,xmm0; deberia tener la super suma en B
			pshufd xmm1,xmm1, 00000000b ;meti la suma en todos lados
			paddd xmm14,xmm1 ;acumulo en 14 la super suma ?
			inc r11
			jmp .cicloVecinosInterior


	.finVecExterior:
		mov r9,r12  ;meto la fila en la que estoy laburando
		imul r9,rcx ;indiceFila * #columnas
		shl r9,2 ;fila*cols*4
		mov rdx, r13
		shl rdx, 2 ;j*4
		add r9,rdx ;(fila*cols*4)+(j*4)
		movdqu xmm0, [rdi+r9] ;con la cuenta saque la posicion de los 4 que voy a modificar
		movdqu xmm1,xmm0
		psrlq xmm14,16
		mulpd xmm1,xmm14 ;r*s falta el ALFA 
		mulpd xmm1,[wacharaka]
		mulpd xmm1,[multiplicadores] ;divido
		paddd xmm1,xmm0		 
		movups[rsi+r9],xmm1
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
 
	