global _GetAVXCapability
global _GetSSECapability

section .text

; Checks CPUID for AVX capability
_GetAVXCapability:
	push rbx
	
	mov eax, 1
	cpuid

	mov eax, ecx
	shr eax, 28		; Read bit 28
	and eax, 1

	pop rbx
	ret


; Checks CPUID for SSE capability
_GetSSECapability:
	push rbx
	
	mov eax, 1
	cpuid

	mov eax, edx
	shr eax, 25		; Read bit 25
	and eax, 1

	pop rbx
	ret

