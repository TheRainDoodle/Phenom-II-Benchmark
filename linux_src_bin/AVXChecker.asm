global GetAVXCapability

section .text

; Checks CPUID for AVX capability
GetAVXCapability:
	push rbx		; CPUID overwrites RBX
	
	mov eax, 1		; CPUID function
	cpuid			; Call CPUID

	mov eax, ecx		
	shr eax, 27		; Read bit 28
	and eax, 1

	pop rbx			; Restore RBX
	ret

