CXX = g++
CXXFLAGS = -Wall -Wextra
OFLAGS = -march=native -mtune=native -Ofast -ffast-math
LDFLAGS = -lpthread

BIN = phenom2_benchmark

.PHONY: clean

$(BIN): main.cpp asm.o
	$(CXX) $(CXXFLAGS) $(OFLAGS) $^ -o $@ $(LDFLAGS)

asm.o: asm.asm AND_REG_REG.asm CMOVcc_REG_REG.asm PADDB_MMX.asm ADD_REG_1.asm SHR_REG_CL.asm AVXChecker.asm FLOPS.asm IMUL_REG_REG.asm
	nasm asm.asm -felf64 -o asm.o

clean:
	@rm -rf *.o $(BIN)
