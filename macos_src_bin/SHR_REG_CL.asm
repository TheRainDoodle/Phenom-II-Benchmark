global _SHR_REG_CL

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

_SHR_REG_CL:
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
