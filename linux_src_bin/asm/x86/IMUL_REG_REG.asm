global IMUL_REG_REG

section .text

%macro IMUL_MACRO 0
	imul rax, rbx
	imul rdx, rbx
	imul rdi, rbx
	imul rsi, rbx
	imul r11, rbx
	imul r8, rbx
	imul r9, rbx
	imul r10, rbx
%endmacro

IMUL_REG_REG:
	push rbx
	push rdi
	push rsi
	push rbp
	push r11
	push r8
	push r9
	push r10

	mov rcx, (1024*1024*1024)/128

	; Set all the accumulators to 1
	mov rbx, 1
	mov rax, 1
	mov rdx, 1
	mov rdi, 1
	mov rsi, 1
	mov r11, 1
	mov r8, 1
	mov r9, 1
	mov r10, 1

.LoopHead:
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO
	IMUL_MACRO

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

