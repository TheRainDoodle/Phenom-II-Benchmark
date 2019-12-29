global AND_REG_REG

section .text

%macro AND_MACRO 0
	and rax, r12
	and rdx, r12
	and rdi, r12
	and rsi, r12
	and r11, r12
	and r8, r12
	and r9, r12
	and r10, r12
%endmacro



AND_REG_REG:
	push rbx
	push rdi
	push rsi
	push rbp
	push r11
	push r8
	push r9
	push r10
	push r12

	mov rcx, (1024*1024*1024)/128

.LoopHead:
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO

	dec rcx
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
