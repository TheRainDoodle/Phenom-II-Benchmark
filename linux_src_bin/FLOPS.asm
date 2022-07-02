global FLOPS_SSE
global FLOPS_AVX
global FLOPS_AVX512

section .text

; 8x phenom II
%macro ADD_SSE 0
	addps xmm1, xmm0
	addps xmm2, xmm0
	addps xmm3, xmm0
	addps xmm4, xmm0
	addps xmm5, xmm0
	addps xmm6, xmm0
	addps xmm7, xmm0
	addps xmm8, xmm0
%endmacro

; For AVX capable CPU's
%macro ADD_AVX 0
	vaddps ymm1, ymm1, ymm0
	vaddps ymm2, ymm2, ymm0
	vaddps ymm3, ymm3, ymm0
	vaddps ymm4, ymm4, ymm0
	vaddps ymm5, ymm5, ymm0
	vaddps ymm6, ymm6, ymm0
	vaddps ymm7, ymm7, ymm0
	vaddps ymm8, ymm8, ymm0
	vaddps ymm9, ymm9, ymm0
	vaddps ymm10, ymm10, ymm0
	vaddps ymm11, ymm11, ymm0
	vaddps ymm12, ymm12, ymm0
	vaddps ymm13, ymm13, ymm0
	vaddps ymm14, ymm14, ymm0
	vaddps ymm15, ymm15, ymm0


		
%endmacro;


; For AVX512 capable CPU's
%macro ADD_AVX512 0
	vaddps zmm1, zmm1, zmm0
	vaddps zmm2, zmm2, zmm0
	vaddps zmm3, zmm3, zmm0
	vaddps zmm4, zmm4, zmm0
	vaddps zmm5, zmm5, zmm0
	vaddps zmm6, zmm6, zmm0
	vaddps zmm7, zmm7, zmm0
	vaddps zmm8, zmm8, zmm0
	vaddps zmm9, zmm9, zmm0
	vaddps zmm10, zmm10, zmm0
	vaddps zmm11, zmm11, zmm0
	vaddps zmm12, zmm12, zmm0
	vaddps zmm13, zmm13, zmm0
	vaddps zmm14, zmm14, zmm0
	vaddps zmm15, zmm15, zmm0
	vaddps zmm16, zmm16, zmm0
	vaddps zmm17, zmm17, zmm0
	vaddps zmm18, zmm18, zmm0
	vaddps zmm19, zmm19, zmm0
	vaddps zmm20, zmm20, zmm0
	vaddps zmm21, zmm21, zmm0
	vaddps zmm22, zmm22, zmm0
	vaddps zmm23, zmm23, zmm0
	vaddps zmm24, zmm24, zmm0
	vaddps zmm25, zmm25, zmm0
	vaddps zmm26, zmm26, zmm0
	vaddps zmm27, zmm27, zmm0
	vaddps zmm28, zmm28, zmm0
	vaddps zmm29, zmm29, zmm0
	vaddps zmm30, zmm30, zmm0
	vaddps zmm31, zmm31, zmm0

%endmacro

FLOPS_SSE:
	push rbx
	push rdi
	push rsi
	push rbp
	push r11
	push r8
	push r9
	push r10

	push r12

	mov r12, (1024*1024*1024)/(128 * 4)	; x4 for SSE

.LoopHead:
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE
	ADD_SSE

	dec r12
	jnz .LoopHead

	pop r12
	pop r10
	pop r9
	pop r8
	pop r11
	pop rbp
	pop rsi
	pop rdi
	pop rbx
	ret

FLOPS_AVX:
	push rbx
	push rdi
	push rsi
	push rbp
	push r11
	push r8
	push r9
	push r10
	push r12

	mov r12, (1024*1024*1024)/(128 * 8)		; x8 for AVX2

	; Set all the AVX regs to 0.0
	vxorps ymm0, ymm0, ymm0
	vxorps ymm1, ymm1, ymm1
	vxorps ymm2, ymm2, ymm2
	vxorps ymm3, ymm3, ymm3
	vxorps ymm4, ymm4, ymm4
	vxorps ymm5, ymm5, ymm5
	vxorps ymm6, ymm6, ymm6
	vxorps ymm7, ymm7, ymm7
	vxorps ymm8, ymm8, ymm8
	vxorps ymm9, ymm9, ymm9
	vxorps ymm10, ymm10, ymm10
	vxorps ymm11, ymm11, ymm11
	vxorps ymm12, ymm12, ymm12
	vxorps ymm13, ymm13, ymm13
	vxorps ymm14, ymm14, ymm14
	vxorps ymm15, ymm15, ymm15


.LoopHead:
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX

	dec r12
	jnz .LoopHead

	pop r12
	pop r10
	pop r9
	pop r8
	pop r11
	pop rbp
	pop rsi
	pop rdi
	pop rbx
	ret



FLOPS_AVX512:
	push rbx
	push rdi
	push rsi
	push rbp
	push r11
	push r8
	push r9
	push r10
	push r12

	mov r12, (1024*1024*1024)/(128 * 16)		; x16 for AVX512

	; Set all the AVX512 regs to 0.0
	vxorps zmm0, zmm0, zmm0
	vxorps zmm1, zmm1, zmm1
	vxorps zmm2, zmm2, zmm2
	vxorps zmm3, zmm3, zmm3
	vxorps zmm4, zmm4, zmm4
	vxorps zmm5, zmm5, zmm5
	vxorps zmm6, zmm6, zmm6
	vxorps zmm7, zmm7, zmm7
	vxorps zmm8, zmm8, zmm8
	vxorps zmm9, zmm9, zmm9
	vxorps zmm10, zmm10, zmm10
	vxorps zmm11, zmm11, zmm11
	vxorps zmm12, zmm12, zmm12
	vxorps zmm13, zmm13, zmm13
	vxorps zmm14, zmm14, zmm14
	vxorps zmm15, zmm15, zmm15
	vxorps zmm16, zmm16, zmm16
	vxorps zmm17, zmm17, zmm17
	vxorps zmm18, zmm18, zmm18
	vxorps zmm19, zmm19, zmm19
	vxorps zmm20, zmm20, zmm20
	vxorps zmm21, zmm21, zmm21
	vxorps zmm22, zmm22, zmm22
	vxorps zmm23, zmm23, zmm23
	vxorps zmm24, zmm24, zmm24
	vxorps zmm25, zmm25, zmm25
	vxorps zmm26, zmm26, zmm26
	vxorps zmm27, zmm27, zmm27
	vxorps zmm28, zmm28, zmm28
	vxorps zmm29, zmm29, zmm29
	vxorps zmm30, zmm30, zmm30
	vxorps zmm31, zmm31, zmm31


.LoopHead:
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512

	dec r12
	jnz .LoopHead

	pop r12
	pop r10
	pop r9
	pop r8
	pop r11
	pop rbp
	pop rsi
	pop rdi
	pop rbx
	ret

