global PADDB_MMX

section .text

%macro PADD_MACRO 0
	paddb mm1, mm0
	paddb mm2, mm0
	paddb mm3, mm0
	paddb mm4, mm0
%endmacro

PADDB_MMX:
	push rbx
	push rdi
	push rsi
	push rbp
	push r11
	push r8
	push r9
	push r10

	mov rcx, (1024*1024*1024)/(32 * 8)	; 8 for 8 bytes in MMX

.LoopHead:
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO
	PADD_MACRO

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

	emms		; Exit multimedia state, return to x87
	ret
