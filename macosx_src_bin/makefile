phenom2_benchmark: main.cpp asm.o
	g++ main.cpp asm.o -std=c++11 -lpthread -ffast-math -msse3 -O3 -o phenom2_benchmark

asm.o: asm.asm AND_REG_REG.asm CMOVcc_REG_REG.asm PADDB_MMX.asm ADD_REG_1.asm SHR_REG_CL.asm AVXChecker.asm FLOPS.asm IMUL_REG_REG.asm
	nasm asm.asm -fmacho64 -o asm.o

clean:
	rm phenom2_benchmark asm.o 