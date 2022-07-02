global SHR_REG_CL
global SHR_REG_CL_AVX_512

section .text

%macro SHR_MACRO 0
	shr rax, cl
	shr rdx, cl
	shr rdi, cl
	shr rsi, cl
	shr r11, cl
	shr r8, cl
	shr r9, cl
	shr r10, cl
%endmacro


%macro SHR_MACRO_AVX_512 0
	vpsrlq zmm1, zmm1,  1	;in SIMD we can do 8*64 bit shifts at a time, so long as all 8 are in a 512 bit register.
%endmacro

SHR_REG_CL:
	push rbx
	push rdi
	push rsi
	push rbp
	push r11
	push r8
	push r9
	push r10

	push r12

	mov r12, (1024*1024*1024)/128

.LoopHead:
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	SHR_MACRO
	
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

;new avx512 section
SHR_REG_CL_AVX_512:
	push rbx
	push rdi
	push rsi
	push rbp
	push r11
	push r8
	push r9
	push r10

	push r12
	mov r12, (1024*1024*1024)/512


											; WARNING the following isn't amazing code
											;but we only have to do it once, and I can't
											;be bothered to pour through the instrinsics
											;manual for a single instruction that saves 3
											;total cycles.  


    vxorps zmm1, zmm1, zmm1					; zero out the AVX 512 registers

	vxorps ymm1, ymm1, ymm1	

	vxorps xmm1, xmm1, xmm1
	vxorps xmm2, xmm2, xmm2
	vxorps xmm3, xmm3, xmm3
	vxorps xmm4, xmm4, xmm4

	vmovq xmm1, rax
	vmovq xmm2, rdx
	vmovq xmm3, rdi
	vmovq xmm4, rsi

	;[RAX] [RDX] [RDI] [RSI]				->[xmm1lower[RAX],xmm1upper[]][xmm2lower[RDX],xmm2upper[]][xmm3lower[RDI],xmm3upper[]][xmm4lower[RSI],xmm4upper[]]

	vpunpcklqdq xmm1, xmm1, xmm2 			; xmm1 now has [rax, rdx] and is therefore full
	;[RAX] [RDX] [RDI] [RSI]				->[xmm1lower[RAX],xmm1upper[RDX]][xmm2lower[RDX],xmm2upper[]][xmm3lower[RDI],xmm3upper[]][xmm4lower[RSI],xmm4upper[]]

	vpunpcklqdq xmm2, xmm3, xmm4 			; xmm2 now has [rdi, rsi] and is therefore full

	;[RAX] [RDX] [RDI] [RSI]				->[xmm1lower[RAX],xmm1upper[RDX]][xmm2lower[RDI],xmm2upper[RSI]][xmm3lower[RDI],xmm3upper[]][xmm4lower[RSI],xmm4upper[]]


	vinserti64x2 zmm1 , zmm1 , xmm1, 0 		; now from xmm1 to zmm1 offset 0.  ZMM 1 is an AVX512 register, in other words it can hold 8 64bit values.
											; For the sake of clarity I'll demark them with zmm[L(ower)1-4 or U(pper)]1-4 to be as simillar to typical intrisic
											; conventions as possible while retaining readability.
											; EX: The second slot of the upper half of zmm1 would be zmm1U2[]

	;[xmm1lower[RAX],xmm1upper[RDX]]			->[zmm1L1[RAX],zmm1L2[RDX],zmm1L3[],zmm1L4[],zmm1U1[],zmm1U2[],zmm1U3[],zmm1U4[]]

	vinserti64x2 zmm1 , zmm1 , xmm2, 127	; now xmm2 to zmm1 offset 127


	;[xmm1lower[RDI],xmm1upper[RSI]]			->[zmm1L1[RAX],zmm1L2[RDX],zmm1L3[RDI],zmm1L4[RSI],zmm1U1[],zmm1U2[],zmm1U3[],zmm1U4[]


	vmovq xmm1, r8
	vmovq xmm2, r9
	vmovq xmm3, r10
	vmovq xmm4, r11

	;[R8] [R9] [R10] [R11]					->[xmm1lower[R8],xmm1upper[]][xmm2lower[R9],xmm2upper[]][xmm3lower[R10],xmm3upper[]][xmm4lower[R11],xmm4upper[]]

	vpunpcklqdq xmm1, xmm1, xmm2 			; xmm1 now has [r8, r9]

	;[R8] [R9] [R10] [R11]					->[xmm1lower[R8],xmm1upper[R9]][xmm2lower[R9],xmm2upper[]][xmm3lower[R10],xmm3upper[]][xmm4lower[R11],xmm4upper[]]

	vpunpcklqdq xmm2, xmm3, xmm4 			; xmm2 now has [r10, r11]

	;[R8] [R9] [R10] [R11]					->[xmm1lower[R8],xmm1upper[R9]][xmm2lower[R10],xmm2upper[R11]][xmm3lower[R10],xmm3upper[]][xmm4lower[R11],xmm4upper[]]

	vinserti64x2 ymm0 , ymm0 , xmm1, 0 		; now from xmm1 to ymm0 offset 0.	YMM 1 is an AVX2 register, in other words it can hold 4 64bit values.
											; For the sake of clarity I'll demark them with ymm[L(ower)1-2 or U(pper)]1-2 to be as simillar to typical intrisic
											; conventions as possible while retaining readability.
											; EX: The second slot of the Lower half of ymm1 would be ymm1L2[]

	;[xmm1lower[R8],xmm1upper[R9]]			->[ymm1L1[R8],ymm1L2[R9],ymm1U1[],ymm1U2[]]

	vinserti64x2 ymm1 , ymm0 , xmm2, 127 	; now from xmm2 to ymm1 offset 127, having copied ymm0 [0-127] at the same time

	;[xmm2lower[R10],xmm2upper[R11]]			->[ymm1L1[R8],ymm1L2[R9],ymm1U1[R10],ymm1U2[R11]]

	vinserti64x4 zmm1 , zmm1 , ymm1, 255 	; now from ymm1 to zmm1 offset 255


	;[ymm1L1[R8],ymm1L2[R9],ymm1U1[R10],ymm1U2[R11]]
											;->[zmm1L1[RAX],zmm1L2[RDX],zmm1L3[RDI],zmm1L4[RSI],zmm1U1[R8],zmm1U2[R9],zmm1U3[R10],zmm1U4[R11]]


											;zmm1 now has all 8 general purpose register
											;values that traditional SHR would have to
											;run once at a time/ 1 per cycle + load
											;code


.LoopHead:
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512
	SHR_MACRO_AVX_512

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
