.code

ADD_MACRO macro
	add rax, 1
	add rdx, 1
	add rdi, 1
	add rsi, 1
	add r11, 1
	add r8, 1
	add r9, 1
	add r10, 1
endm

ADD_REG_1 proc
	push rbx
	push rdi
	push rsi
	push rbp
	push r11
	push r8
	push r9
	push r10

	mov rcx, (1024*1024*1024)/128

LoopHead:
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO
	ADD_MACRO

	dec rcx
	jnz LoopHead

	pop r10
	pop r9
	pop r8
	pop r11
	pop rbp
	pop rsi
	pop rdi
	pop rbx
	ret
ADD_REG_1 endp
end