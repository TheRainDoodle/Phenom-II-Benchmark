phenom2_benchmark: main.cpp asm.o
	g++ main.cpp asm.o -lpthread -ffast-math -msse3 -O3 -o phenom2_benchmark_x86
	$ chmod u+x ./phenom2_benchmark_x86

asm.o: asm.asm ./asm/x86/AND_REG_REG.asm ./asm/x86/CMOVcc_REG_REG.asm ./asm/x86/PADDB_MMX.asm A./asm/x86/DD_REG_1.asm ./asm/x86/SHR_REG_CL.asm ./asm/x86/AVXChecker.asm ./asm/x86/FLOPS.asm ./asm/x86/IMUL_REG_REG.asm ./asm/x86/ARM_ADD_REG_1.asm
	nasm asm.asm -felf64 -o asm.o

phenom2_benchmark_ARM: main.cpp asm_arm.o
	g++ main.cpp asm_arm.o -lpthread -ffast-math -O3 -o phenom2_benchmark_ARM
	$ chmod u+x ./phenom2_benchmark_ARM

asm_arm.o: asm_arm.asm ./asm/arm/ARM_AND_REG_REG.asm ./asm/arm/ARM_ADD_REG_1.asm 
	as asm_arm.asm -o asm_arm.o
