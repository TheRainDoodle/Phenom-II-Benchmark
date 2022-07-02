# A-*Phenominal*-benchmark

## TLDR; 

```
git clone 
cd linux_src_bin 
make -B
```
Then run the application 

If testing flops: run option 6 (sse), option 7 (avx) vs option 8 (best ISA available, typically AVX1/2 or AVX512)


## Context
Small set of low level benchmarks for testing hardware speed against a Phenom II 810 Quad Core from 2009.

The benchmarks use all threads and cores of a CPU, and execute a few hundered billion iterations of some specific instruction using heavily unrolled loops for pipelining. The program has the timings from an old Phenom II 810 for each of the benchmarks, and prints out how many Phenom II's your CPU is, i.e. how much faster than a Phenom II the hardware is. A score of 2 Phenom II's means your hardware executed the instructions twice as fast.

The aim of this project is to highlight some of the nuances in the speed of hardware. And show, while hardware is generally improving in speed, there are some things old hardware does as fast or faster. Having forked this repository, I compared the Phenom to my current workstation, an AVX-512 enabled Alder Lake 12th-gen system with 8-cores and 16-threads.

For compute oriented tasks such as FP32, the Phenom is only able to utilize the SSE familly of instruction where as the Alder lake chip has access to AVX and AVX512, in addition to having twice as many cores and 4 times as many threads. 


The Original forked code by Chris Creel did not support AVX512. They've been been added by hand in x86_asm using the AVX512 foundation set of instructions. 

From my testing:


    ```
    Performance metrics on AVX-512 enabled alderlake:
    
    8 P-cores/16threads of AVX-512 :
    
    Run 1/10 Time: 0.08902
    Run 2/10 Time: 0.08652
    Run 3/10 Time: 0.08655
    Run 4/10 Time: 0.0866
    Run 5/10 Time: 0.08652
    Run 6/10 Time: 0.08653
    Run 7/10 Time: 0.08604
    Run 8/10 Time: 0.08657
    Run 9/10 Time: 0.08641
    Run 10/10 Time: 0.08656
    Executed 1248 billion instructions/second
    Score: 30.17 Phenom's II's worth's
    
    Single P-core/Single thread:
    
    Run 1/10 Time: 0.6904
    Run 2/10 Time: 0.6853
    Run 3/10 Time: 0.6853
    Run 4/10 Time: 0.6853
    Run 5/10 Time: 0.6853
    Run 6/10 Time: 0.6853
    Run 7/10 Time: 0.6852
    Run 8/10 Time: 0.6853
    Run 9/10 Time: 0.6853
    Run 10/10 Time: 0.6852
    Executed 156.7 billion instructions/second
    Score: 15.11 Phenom's II's worth's
    ```

When using sse for direct comparison 
    
    
    ```
    8 P-cores/16threads of SSE :

    Run 1/10 Time: 0.3256
    Run 2/10 Time: 0.3224
    Run 3/10 Time: 0.3158
    Run 4/10 Time: 0.3085
    Run 5/10 Time: 0.3224
    Run 6/10 Time: 0.3225
    Run 7/10 Time: 0.3224
    Run 8/10 Time: 0.3224
    Run 9/10 Time: 0.3224
    Run 10/10 Time: 0.3225
    Executed 348 billion instructions/second
    Score: 8.412 Phenom's II's worth's

    Single P-core/Single thread:
    
    Run 1/10 Time: 2.639
    Run 2/10 Time: 2.634
    Run 3/10 Time: 2.633
    Run 4/10 Time: 2.634
    Run 5/10 Time: 2.633
    Run 6/10 Time: 2.636
    Run 7/10 Time: 2.635
    Run 8/10 Time: 2.634
    Run 9/10 Time: 2.633
    Run 10/10 Time: 2.655
    Executed 40.78 billion instructions/second
    Score: 3.933 Phenom's II's worth's

```
    4 cores, no hyper threading, SSE instruction:
	Run 1/10 Time: 0.6646
	Run 2/10 Time: 0.6583
	Run 3/10 Time: 0.66
	Run 4/10 Time: 0.6585
	Run 5/10 Time: 0.6597
	Run 6/10 Time: 0.6586
	Run 7/10 Time: 0.659
	Run 8/10 Time: 0.6591
	Run 9/10 Time: 0.6583
	Run 10/10 Time: 0.6586
	Executed 163.1 billion instructions/second

1 core, no hyper threading, AVX512 instructions: 
	Run 1/10 Time: 0.7091
	Run 2/10 Time: 0.6858
	Run 3/10 Time: 0.6911
	Run 4/10 Time: 0.6855
	Run 5/10 Time: 0.6861
	Run 6/10 Time: 0.6853
	Run 7/10 Time: 0.6893
	Run 8/10 Time: 0.6856
	Run 9/10 Time: 0.686
	Run 10/10 Time: 0.6855
	Executed 156.7 billion instructions/second
    
```
