global GetAVX512Capability
global GetAVXCapability
global GetSSECapability

section .text


; Checks CPUID for AVX capability
GetAVXCapability:
        push rbx
        
        mov eax, 1
        cpuid

        mov eax, ecx
        shr eax, 28             ; Read bit 28
        and eax, 1

        pop rbx
        ret


; Checks CPUID for SSE capability
GetSSECapability:
        push rbx

        mov eax, 1
        cpuid

        mov eax, edx
        shr eax, 25             ; Read bit 25
        and eax, 1

        pop rbx
        ret

; Checks CPUID for AVX512 capability
GetAVX512Capability:
        push rbx

        mov eax, 7
	xor ecx, ecx
        cpuid

        mov eax, ebx
        shr eax, 16             ; Read bit 16
        and eax, 1

        pop rbx
        ret





