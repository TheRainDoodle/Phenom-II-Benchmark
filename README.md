# Phenom-II-Benchmark

## Why it exist
### Curiosity is a BIG thing
The Phenom II Benchmark is a small set of low level benchmarks for testing hardware speed against a Phenom II 810 Quad Core from 2009. I hope to add more tests as time goes on, depending on whether the topic is found to be interesting for people (specifically single threaded performance, and L1 cache tests).
[Official video](https://youtu.be/Rp6_bfZ4nuE)
### How it works
The benchmarks use all threads and cores of a CPU, and execute 100 billion iterations of some specific instruction using heavily unrolled loops for pipelining. The program has the timings which my old Phenom II 810 scores for each of the benchmarks, and prints out how many Phenom II's your CPU is, i.e. how much faster than a Phenom II the hardware is. A score of 2 Phenom II's means your hardware executed the instructions twice as fast.
### Aim
The aim of this project is to highlight some of the nuances in the speed of hardware. And show, while hardware is generally improving in speed, there are some things old hardware does as fast or faster. I happen to own two Phenom II 810 CPU's from a long time ago, and I decided it would be fun to race them against my laptop, which has an i7 8750H; a mobile CPU, fer sure, but a decent peice of hardware nonetheless.
- I was surprised and fascinated by the results. There are many things the old Phenom does much faster than my modern CPU, although they are generally single threaded, and these tests do not currently appear in the benchmark. Modern CPU's have larger SIMD registers and more cores, but are otherwise not much faster.
- There are other things the Phenom II does very well, and I'd love to explore further if there is interest in improving this tool.

`Anywho, have a good one all, DL and run the app yourself, find today: How Many Phenom II's is my CPU! :)`

## BIG data
### Lets compare
One of our participants write simple logging feature to our program to export to CSV, and from today we starting collecting data this is all data we will able to analyze of general performance off all processors tested by this program.

Run program, lt will create `Output.csv ` run tests separate to Multi treads and Single tread and write it to `Output Multytread.ods` and `Output Singletread.ods` what locate in project root folder.

`.ods` is Open Document Format (odt, odp, ods) you can open it with Online Viewer/Converter, free https://libreoffice.org/ or http://www.openoffice.org/

`4 October(Hacktoberfest) 2020, Readme ver 0.0.2`
