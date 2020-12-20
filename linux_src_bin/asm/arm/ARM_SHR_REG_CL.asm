.arch armv8-a

.global ARM_SHR_REG_CL

.section .text
.balign 4

.macro SHR_MACRO
	//in x86: shr dest, src => Logical shift dest to the right by src bits.
	//in x86: CL is the lower (4-Bit) half of CX which is the lower half of ECX which is the lower half of RCX
	//in AARCH64:  lsr x0, x1, 0 =>  x0 = x1 >> 0
	//in AARCH64: We've no CL instead we're using x9's bits
	//TO consider: ... do we just want a few bytes? then we have to load it elsewhere before
	//ldr x10, [x9, #4] //Load 4 Bytes from x9 to x10
	lsr x0, x0, x9
	lsr x1, x1, x9
	lsr x2, x2, x9
	lsr x3, x3, x9
	lsr x4, x4, x9
	lsr x5, x5, x9
	lsr x6, x6, x9
	lsr x7, x7, x9
	lsr x8, x8, x9
	.endm

ARM_SHR_REG_CL:
.prepSHRREGCL:
	//First store all value from the registers to the stack...	
	str x0, [sp, #-64]! //push x0 to the stack	
	str x1, [sp, #-64]! //push x1 to the stack	
	str x2, [sp, #-64]! //push x2 to the stack	
	str x3, [sp, #-64]! //...
	str x4, [sp, #-64]!
	str x5, [sp, #-64]!
	str x6, [sp, #-64]!
	str x7, [sp, #-64]!
	str x8, [sp, #-64]!
		
	//Set our iterations
	mov x9, (1024*1024*1024)/128

.LoopSHRREGCL:
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
	
	subs x9, x9, 1  // subtract one interation from the register
	cmp  x9, 0  // check if we reached zero
	bne .LoopSHRREGCL// go back to the loop if we did not reached zero yet

.cleanSHRREGCL:
//Restore the registers from the stack
	ldr x8, [sp], #64 // pop from the stack and put into x7
	ldr x7, [sp], #64 // pop from the stack and put into x7
	ldr x6, [sp], #64 // pop from the stack and put into x6
	ldr x5, [sp], #64 // pop from the stack and put into x5
	ldr x4, [sp], #64 // pop from the stack and put into x4
	ldr x3, [sp], #64 // pop from the stack and put into x3
	ldr x2, [sp], #64 // pop from the stack and put into x2	
	ldr x1, [sp], #64 // pop from the stack and put into x1
	ldr x0, [sp], #64 // pop from the stack and put into x0	
	ret
