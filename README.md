# Phenom-II-Benchmark

The Phenom II Benchmark is a small set of low level benchmarks for testing hardware speed against a Phenom II 810 Quad Core from 2009. I hope to add more tests as time goes on, depending on whether the topic is found to be interesting for people (specifically single threaded performance, and L1 cache tests).

The benchmarks use all threads and cores of a CPU, and execute 100 billion iterations of some specific instruction using heavily unrolled loops for pipelining. The program has the timings which my old Phenom II 810 scores for each of the benchmarks, and prints out how many Phenom II's your CPU is, i.e. how much faster than a Phenom II the hardware is. A score of 2 Phenom II's means your hardware executed the instructions twice as fast.

The aim of this project is to highlight some of the nuances in the speed of hardware. And show, while hardware is generally improving in speed, there are some things old hardware does as fast or faster. I happen to own two Phenom II 810 CPU's from a long time ago, and I decided it would be fun to race them against my laptop, which has an i7 8750H; a mobile CPU, fer sure, but a decent peice of hardware nonetheless.

I was surprised and fascinated by the results. There are many things the old Phenom does much faster than my modern CPU, although they are generally single threaded, and these tests do not currently appear in the benchmark. Modern CPU's have larger SIMD registers and more cores, but are otherwise not much faster.

There are other things the Phenom II does very well, and I'd love to explore further if there is interest in improving this tool.

Anywho, have a good one all, DL and run the app yourself, find today: How Many Phenom II's is my CPU! :)
