phenom2_benchmark: main.cpp asm.o
	g++ main.cpp asm.o -lpthread -ffast-math -msse3 -O3 -o phenom2_benchmark

asm.o: asm.asm AND_REG_REG.asm CMOVcc_REG_REG.asm PADDB_MMX.asm ADD_REG_1.asm SHR_REG_CL.asm AVXChecker.asm FLOPS.asm
	nasm asm.asm -felf64 -o asm.o
