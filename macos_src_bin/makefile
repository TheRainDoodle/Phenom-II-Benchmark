phenom2_benchmark: main.cpp asm.o
	g++ -std=c++11 main.cpp asm.o -lpthread -ffast-math -msse3 -O3 -o phenom2_benchmark

asm.o: asm.asm AND_REG_REG.asm CMOVcc_REG_REG.asm PADDB_MMX.asm ADD_REG_1.asm SHR_REG_CL.asm AVXChecker.asm FLOPS.asm IMUL_REG_REG.asm
	nasm asm.asm -fmacho64 -o asm.o
