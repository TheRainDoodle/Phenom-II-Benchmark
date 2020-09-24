.code

SHR_MACRO macro
	shr rax, 1
	shr rdx, 1
	shr rdi, 1
	shr rsi, 1
	shr r11, 1
	shr r8, 1
	shr r9, 1
	shr r10, 1
endm

SHR_REG_CL proc
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

LoopHead:
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
SHR_REG_CL endp
end
