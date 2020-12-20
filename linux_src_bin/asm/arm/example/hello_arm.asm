/*
Output "Hello world!" to standard output.
For Aarch64 (ARM64) architecture with GNU assembler, using Linux libc functions.

Assemble with :
as -o hello.o hello.aarch64.linux.libc.gas.asm &&
gcc -o hello hello.o
*/
.arch armv8-a
//.cpu name cortex-a53
//.cpu name cortex-a76

.global main
.section .text
.balign 4

main:
	stp  x29, x30, [sp, -16]!
	add  x29, sp, 0
	adrp x0, message
	add  x0, x0, :lo12:message
	bl   printf
	mov  w0, 0
	ldp  x29, x30, [sp], 16
	ret

.section .rodata
.balign 4

message:
	.asciz "Hello world!\n\0"
