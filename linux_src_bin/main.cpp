#include <iostream>
#include <ctime>
#include <thread>
#include <mutex>
#include <vector>

// Checker function for AVX and SSE
extern "C" bool GetVMXCapability();
extern "C" bool GetAVX512Capability();
extern "C" bool GetAVXCapability();
extern "C" bool GetSSECapability();

// Job functions  (Note: ThreadID is included for future versions)
// Each executes 1024^3 times, 1 gig, or around 1 billion operations.
extern "C" void ADD_REG_1(int threadID);
extern "C" void AND_REG_REG(int threadID);
extern "C" void SHR_REG_CL(int threadID);
extern "C" void SHR_REG_CL_AVX_512(int threadID);
extern "C" void PADDB_MMX(int threadID);
extern "C" void CMOVcc_REG_REG(int threadID);
extern "C" void FLOPS_SSE(int threadID);
extern "C" void FLOPS_AVX(int threadID);
extern "C" void FLOPS_AVX512(int threadID);

// MUL added for Reirei
extern "C" void IMUL_REG_REG(int threadID);

// Lock for the jobs vector
std::mutex workMutex;

// Jobs vector
std::vector< void(*)(int) > work;

void Execute(int threadID)
{
	// The following is not necessary nor cross-platform
	//SetThreadPriority(GetCurrentThread(), 2);
	//SetThreadAffinityMask(GetCurrentThread(), 1 << threadID);

	// Whilte there's jobs to be done
	while (true)
	{
		// Thread's job (if it has one, NULL if it doesn't)
		void (*func)(int);

		// Lock mutex
		workMutex.lock();

		// Assume there's no more work
		func = NULL;

		// If there's more work, grab a job
		if (work.size() != 0)
		{
			func = work.back();
			work.pop_back();
		}
		// Unlock mutex
		workMutex.unlock();

		// If there's a job, execute it
		if (func != NULL)
			func(threadID);
		// Otherwise, return
		else
			return;
	}
}

int main()
{
	double phenom2_performance[] = {
		// Multithreaded
		30.099969,			// Add
		30.564951,			// Bool
		30.106989,			// Shift CL
		82.588283,			// MMX
		30.091751,			// CMOVcc
		41.371507,			// Flops
		41.371507,			// Flops
		1.0,				// IMUL
		// Single threaded
		7.5403567,			// Add
		7.6557838,			// Bool
		7.5400756,			// Shift CL
		20.704509,			// MMX
		7.5366694,			// CMOVcc
		10.36873,			// Flops
		10.36873,			// Flops
		1.0				// IMUL
	};

	// Check for CPU capabilities
	bool VMX_CAPABLE = GetVMXCapability();
	bool AVX512_CAPABLE = GetAVX512Capability();
	bool AVX_CAPABLE = GetAVXCapability();
	bool SSE_CAPABLE = GetSSECapability();

	// Limit output digits to 4
	std::cout.precision(4);

	const int RUNS = 50;			// Repeitions, so we can find a fast time
	const int MAX_THREADS = 64;		// Maximum number of threads
	const int JOB_COUNT = 100;		// Jobs to perform (threads keep checking until all jobs are done)
	int threadCount = std::thread::hardware_concurrency();			// Actual thread count of this CPU
	std::thread* t[MAX_THREADS];	// 16 is the maximum number of threads
	int option = -1;				// Option variable for use input
	double fastest = 0.0;			// Record of the fastest time recorded
	void(*currentFunction)(int);	// Pointer to the currently selected function

	// Output some info
	std::cout<<"* * *  Welcome to A 'Phenom'inal benchmark!  * * *"<< std::endl;
	std::cout<< std::endl;
	std::cout<<"This benchmark will time your CPU performance against an"<< std::endl;
	std::cout<<"AMD Quad Core Phenom II 810 from the year 2009."<< std::endl;
	std::cout<<std::endl;

	if (VMX_CAPABLE)
		std::cout<<"VMX CPU detected!"<< std::endl;
	if (AVX512_CAPABLE)
		std::cout<<"AVX512 CPU detected!  We'll use it for FLOPS and SHR"<< std::endl;
	else
		std::cout<<"No AVX512 support detected!" << std::endl;
	if (AVX_CAPABLE)
		std::cout<<"AVX CPU detected!"<< std::endl;
	else
		std::cout<<"No AVX support detected" << std::endl;
	if (SSE_CAPABLE)
		std::cout<<"SSE CPU detected!" << std::endl;
	else
		std::cout<<"SSE capable CPU is required FLOPS test."<<std::endl;

	std::cout<<"Threads available: "<< threadCount << " vs. 4 for Phenom II" << std::endl;

	while (option != 0)
	{
		// Reset option
		option = -1;

		// Reset fastest:
		fastest = 0.0;

		while (option == -1)
		{
			std::cout<<std::endl;
			std::cout<<"Select a benchmark (or 0 to quit): "<< std::endl;
			std::cout<<"1. ADD REG, 1		(GPR arithmetic)" << std::endl;
			std::cout<<"2. AND REG, REG		(GPR Boolean)" << std::endl;
			std::cout<<"3. SHR REG, CL		(Variable shifts - Phenom's phorte)"<< std::endl; 
			std::cout<<"4. PADDB MMX		(Obsolete instruction set)"<< std::endl;
			std::cout<<"5. CMOVcc REG, REG	(Branchless programming)" << std::endl;
			std::cout<<"6. FLOPS SSE		(Floating point with SSE)" << std::endl;
			std::cout<<"7. FLOPS Best		(Floating point with best set)" << std::endl;
			std::cout<<"8. IMUL REG, REG	(GPR Multiplication)"<< std::endl;
			std::cout<<"9. Toggle Multi vs. Single Threads (Current="<<threadCount<<")"<<std::endl;
			std::cout<<"10. Set thread count to match Phenom (4)" << std::endl;
			std::cout<<"0. Quit" << std::endl;

			std::cin>>option;

			// Reset to -1 if the input is invalid
			option = (option * (option >= 0 && option <= 10))+(-1 * !(option >= 0 && option <= 10));
		}

		switch (option)
		{
		case 0: break;
		case 1: currentFunction = ADD_REG_1; break;
		case 2: currentFunction = AND_REG_REG; break;
		case 3: currentFunction = (AVX512_CAPABLE ? SHR_REG_CL_AVX_512: SHR_REG_CL); break;
		case 4: currentFunction = PADDB_MMX; break;
		case 5: currentFunction = CMOVcc_REG_REG; break;
		case 6: currentFunction = FLOPS_SSE; break;
		case 7: currentFunction =  (AVX512_CAPABLE ? FLOPS_AVX512 : (AVX_CAPABLE ? FLOPS_AVX : FLOPS_SSE)); break;	// Select SSE, AVX or AVX512
		case 8: currentFunction = IMUL_REG_REG; break;
		case 9: threadCount = (1 * (threadCount != 1)) +		// Toggle threaded or single thread
			(std::thread::hardware_concurrency() * (threadCount == 1)); break;
		case 10: threadCount = 4; break; // set Thread count to be the same as the Phenom 820

		}

		if (option == 0)	// Allow quit
			break;
		if (option == 9 || option == 10)	// Continue if the thread count has been changed
			continue;

		// Loop RUNS times through the benchmark
		for (int r = 0; r < RUNS; r++)
		{
			// Add jobs to the Jobs vector
			for (int i = 0; i < JOB_COUNT; i++)
				work.push_back(currentFunction);

			// Start the clock
			long startTime = clock();

			// Start the threads
			for (int i = 0; i < threadCount; i++)
				t[i] = new std::thread(Execute, i);

			// Wait for them to finish
			for (int i = 0; i < threadCount; i++)
				t[i]->join();

			// Stop the clock
			long finishTime = clock();

			// Compute the time taken for this run
			double thisTime = (double)(finishTime - startTime) / CLOCKS_PER_SEC;
			thisTime /= (double)threadCount;	// ctime's clock seems to sum times of each thread

			// Update fastest if this time beat it
			if (thisTime < fastest || fastest == 0.0)
				fastest = thisTime;

			// Output time for this run
			std::cout<<"Run "<< (r+1) << "/" << RUNS <<" Time: "<< thisTime << std::endl;

			// Delete the threads
			for (int i = 0; i < threadCount; i++)
				delete t[i];
		}

		double gops = ((((1024*1024*1024)/1000000000.0)
			/ fastest) * (double)JOB_COUNT);

		double phenom2 = phenom2_performance[(option-1)
		 + (7 * (threadCount == 1))];

		std::cout<<"Executed "<< gops << " billion instructions/second" <<std::endl;
		std::cout<<	"Score: "<< (gops / phenom2) << " Phenom's II's worth's" << std::endl;
	}

	std::cout<<"See ya... "<< std::endl;

	return 0;
}
