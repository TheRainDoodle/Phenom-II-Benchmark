global CMOVcc_REG_REG

section .text

%macro CMOV_MACRO 0
	cmove rdx, rax
	cmove rbx, rax
	cmove rsi, rax
	cmove rdi, rax
	cmove r8, rax
	cmove r9, rax
	cmove r10, rax
	cmove r11, rax
%endmacro

CMOVcc_REG_REG:
	push rbx
	push rdi
	push rsi
	push rbp
	push r11
	push r8
	push r9
	push r10

	mov rcx, (1024*1024*1024)/128

.LoopHead:
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	CMOV_MACRO
	
	dec rcx
	jnz .LoopHead

	pop r10
	pop r9
	pop r8
	pop r11
	pop rbp
	pop rsi
	pop rdi
	pop rbx

	ret
