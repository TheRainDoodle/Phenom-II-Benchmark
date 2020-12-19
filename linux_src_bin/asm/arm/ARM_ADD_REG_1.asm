.arch armv8-a

.global ARM_ADD_REG_1

.section .text
.balign 4

.macro ADD_MACRO
    add x0, x0, 1	
	add x1, x1, 1
	add x2, x2, 1
	add x3, x3, 1
	add x4, x4, 1
	add x5, x5, 1
	add x6, x6, 1
	add x7, x7, 1
	.endm

ARM_ADD_REG_1:	
.prepADDREG1:
	//First store all value from the registers to the stack...	
	str x0, [sp, #-64]! //push x0 to the stack	
	str x1, [sp, #-64]! //push x1 to the stack	
	str x2, [sp, #-64]! //push x2 to the stack	
	str x3, [sp, #-64]! //...
	str x4, [sp, #-64]!
	str x5, [sp, #-64]!
	str x6, [sp, #-64]!
	str x7, [sp, #-64]!
		
	//Set our iterations
	mov x9, (1024*1024*1024)/128


.LoopADDREG1:
	//Our workloop will run until iterations are decremented to zero
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
	subs x9, x9, 1  // subtract one interation from the register
	cmp  x9, 0  // check if we reached zero
	bne .LoopADDREG1 // go back to the loop if we did not reached zero yet
	
.cleanADDREG1:
	//Restore the registers from the stack
	ldr x7, [sp], #64 // pop from the stack and put into x7
	ldr x6, [sp], #64 // pop from the stack and put into x6
	ldr x5, [sp], #64 // pop from the stack and put into x5
	ldr x4, [sp], #64 // pop from the stack and put into x4
	ldr x3, [sp], #64 // pop from the stack and put into x3
	ldr x2, [sp], #64 // pop from the stack and put into x2	
	ldr x1, [sp], #64 // pop from the stack and put into x1
	ldr x0, [sp], #64 // pop from the stack and put into x0	
	ret
