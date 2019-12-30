.code
; Checks CPUID for AVX capability
GetAVXCapability proc
	push rbx
	
	mov eax, 1
	cpuid

	mov eax, ecx
	shr eax, 28		; Read bit 28
	and eax, 1

	pop rbx
	ret
GetAVXCapability endp

; Checks CPUID for SSE capability
GetSSECapability proc
		push rbx
	
	mov eax, 1
	cpuid

	mov eax, edx
	shr eax, 25		; Read bit 25
	and eax, 1

	pop rbx
	ret
GetSSECapability endp
end