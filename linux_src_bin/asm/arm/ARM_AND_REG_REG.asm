.arch armv8-a

.global ARM_AND_REG_REG

.section .text
.balign 4

.macro AND_MACRO
	and x0, x0, x8
	and x1, x1, x8
	and x2, x2, x8
	and x3, x3, x8
	and x4, x4, x8
	and x5, x5, x8
	and x6, x6, x8
	and x7, x7, x8
	.endm

ARM_AND_REG_REG:
.prepANDREGREG:
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

.LoopANDREGREG:
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	AND_MACRO
	subs x9, x9, 1  // subtract one interation from the register
	cmp  x9, 0  // check if we reached zero
	bne .LoopANDREGREG // go back to the loop if we did not reached zero yet

.cleanANDREGREG:
	ldr x8, [sp], #64 // pop from the stack and put into x8
	ldr x7, [sp], #64 // pop from the stack and put into x7
	ldr x6, [sp], #64 // pop from the stack and put into x6
	ldr x5, [sp], #64 // pop from the stack and put into x5
	ldr x4, [sp], #64 // pop from the stack and put into x4
	ldr x3, [sp], #64 // pop from the stack and put into x3
	ldr x2, [sp], #64 // pop from the stack and put into x2	
	ldr x1, [sp], #64 // pop from the stack and put into x1
	ldr x0, [sp], #64 // pop from the stack and put into x0
	ret
