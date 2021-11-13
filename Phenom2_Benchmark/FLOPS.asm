.code

; 8x phenom II
ADD_SSE macro
	addps xmm1, xmm0
	addps xmm2, xmm0
	addps xmm3, xmm0
	addps xmm4, xmm0
	addps xmm5, xmm0
	addps xmm6, xmm0
	addps xmm7, xmm0
	addps xmm8, xmm0
endm

ADD_AVX macro
	vaddps ymm1, ymm1, ymm0
	vaddps ymm2, ymm2, ymm0
	vaddps ymm3, ymm3, ymm0
	vaddps ymm4, ymm4, ymm0
	vaddps ymm5, ymm5, ymm0
	vaddps ymm6, ymm6, ymm0
	vaddps ymm7, ymm7, ymm0
	vaddps ymm8, ymm8, ymm0
endm

ADD_AVX512 macro
	vaddps zmm1, zmm1, zmm0
	vaddps zmm2, zmm2, zmm0
	vaddps zmm3, zmm3, zmm0
	vaddps zmm4, zmm4, zmm0
	vaddps zmm5, zmm5, zmm0
	vaddps zmm6, zmm6, zmm0
	vaddps zmm7, zmm7, zmm0
	vaddps zmm8, zmm8, zmm0
endm

FLOPS_SSE proc
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

LoopHead:
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
	jnz LoopHead

	pop r12
	pop r10
	pop r9
	pop r8
	pop r11
	pop rbp
	pop rsi
	pop rsi
	pop rbx
	ret
FLOPS_SSE endp

FLOPS_AVX proc
	push rbx
	push rdi
	push rsi
	push rbp
	push r11
	push r8
	push r9
	push r10
	push r12

	mov r12, (1024*1024*1024)/(128 * 8)		; x8 for AVX

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

LoopHead:
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX
	ADD_AVX

	dec r12
	jnz LoopHead

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
FLOPS_AVX endp

FLOPS_AVX512 proc
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

LoopHead:
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512
	ADD_AVX512

	dec r12
	jnz LoopHead

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
FLOPS_AVX512 endp

end