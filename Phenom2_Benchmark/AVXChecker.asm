.code
; Checks CPUID for AVX capability
GetAVXCapability proc
	push rbx
	
	mov eax, 1
	cpuid

	mov eax, ecx
	shr eax, 27		; Read bit 28
	and eax, 1

	pop rbx
	ret
GetAVXCapability endp
end