push rbp
mov rbp, rsp
mov r10, 0
imul rcx, rdx
shr rcx, 2  ; esta bien pisar esto?
pxor xmm7, xmm7
.ciclo:
movups xmm0, [rdi] ; xmm1 = a3 | a2 | a1 | a0
movups xmm1, xmm0

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


add rdi, 16
loop .ciclo