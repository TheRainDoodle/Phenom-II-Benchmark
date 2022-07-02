global GetVMXCapability
global GetVTDCapability

section .text

						; Checks CPUID for VMX capability
GetVMXCapability:
	push rbx		; Store the callers RBX register value

	mov eax, 1		; Place a 1 into EAX to load standard set of CPUID data when called
	cpuid			; place CPUID info into EAX EBX ECX and EDX

	mov eax, ecx	; move the ECX registers values into EAX
	shr eax, 5		; Read bit 5 by shifting to the right by 5 bits
	and eax, 1		; and'ing the eax register with 1

	pop rbx			; restore the callers RBX register value
	ret				; Go back to calling routine; Checks CPUID for VMX capability

GetVTDCapability:
	push rbx 		; Store the callers RBX register value

	mov eax, 1		; Place a 1 into EAX to load standard set of CPUID data when called
	cpuid			; place CPUID info into EAX EBX ECX and EDX

	mov eax, ecx		; move the ECX registers values into EAX
	shr eax, 5		; Read bit 5 by shifting to the right by 5 bits
	and eax, 1		; and'ing the eax register with 1

	pop rbx			; restore the callers RBX register value
	ret				; Go back to calling routine




;Checking bit 31 after checking bit 5
;should show us if secondary virtualization
;instructions are available per intel
;manual vol-3c-part3 section 25.1.3
;foot note 3

;Cross checks against section 24.6.2

;N.B. Technically bit 31 can be set to 0
;manually, but at that point, we could try
;and insert a 1 under a special flag?

