#include <iostream>
#include <fstream>
#include <ctime>
#include <thread>
#include <mutex>
#include <vector>

// Checker function for AVX and SSE
extern "C" bool GetAVXCapability();
extern "C" bool GetSSECapability();

// Job functions  (Note: ThreadID is included for future versions)
// Each executes 1024^3 times, 1 gig, or around 1 billion operations.
extern "C" void ADD_REG_1(int threadID);
extern "C" void AND_REG_REG(int threadID);
extern "C" void SHR_REG_CL(int threadID);
extern "C" void PADDB_MMX(int threadID);
extern "C" void CMOVcc_REG_REG(int threadID);
extern "C" void FLOPS_SSE(int threadID);
extern "C" void FLOPS_AVX(int threadID);

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

void WriteResults(std::string line)
{
    // Output file
    std::ofstream resultsFile;

    // append instead of overwrite
    resultsFile.open("results.txt", std::ios_base::app);

    // write line
    resultsFile << line;

    // close file
    resultsFile.close();
}

int main()
{
    double phenom2_performance[] = {
        // Multithreaded
        30.099969,          // Add
        30.564951,          // Bool
        30.106989,          // Shift CL
        82.588283,          // MMX
        30.091751,          // CMOVcc
        41.371507,          // Flops
        1.0,                // IMUL
        // Single threaded
        7.5403567,          // Add
        7.6557838,          // Bool
        7.5400756,          // Shift CL
        20.704509,          // MMX
        7.5366694,          // CMOVcc
        10.36873,           // Flops
        1.0	                // IMUL
    };

    std::string test_names[] = {
        "ADD REG, 1       (GPR arithmetic)",
        "AND REG, REG     (GPR Boolean)",
        "SHR REG, CL      (Variable shifts - Phenom's phorte)",
        "PADDB MMX        (Obsolete instruction set)",
        "CMOVcc REG, REG  (Branchless programming)",
        "FLOPS            (Floating point with best set)",
        "IMUL REG, REG    (GPR Multiplication)"
    };

    // Check for AVX capability
    bool AVX_CAPABLE = GetAVXCapability();
    bool SSE_CAPABLE = GetSSECapability();

    // Limit output digits to 4
    std::cout.precision(4);

    const int RUNS = 10;            // Repeitions, so we can find a fast time
    const int MAX_THREADS = 64;     // Maximum number of threads
    const int JOB_COUNT = 100;      // Jobs to perform (threads keep checking until all jobs are done)
    int threadCount = std::thread::hardware_concurrency();          // Actual thread count of this CPU
    std::thread* t[MAX_THREADS];    // 16 is the maximum number of threads
    int option = -1;                // Option variable for use input
    double fastest = 0.0;           // Record of the fastest time recorded
    void(*currentFunction)(int);    // Pointer to the currently selected function

    // Output some info
    std::cout<<"* * *  Welcome to How Many Phenom II's is My CPU!  * * *"<< std::endl;
    std::cout<< std::endl;
    std::cout<<"This benchmark will time your CPU performance against an"<< std::endl;
    std::cout<<"AMD Quad Core Phenom II 810 from the year 2009."<< std::endl;
    std::cout<<std::endl;

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

        while (option == -1)
        {
            std::cout<<std::endl;
            std::cout<<"Select a benchmark (or 0 to quit): "<< std::endl;
            std::cout<<"1. " << test_names[0] << std::endl;
            std::cout<<"2. " << test_names[1] << std::endl;
            std::cout<<"3. " << test_names[2] << std::endl;
            std::cout<<"4. " << test_names[3] << std::endl;
            std::cout<<"5. " << test_names[4] << std::endl;
            std::cout<<"6. " << test_names[5] << std::endl;
            std::cout<<"7. " << test_names[6] << std::endl;
            std::cout<<"8. Toggle Multi vs. Single Threads (Current="<<threadCount<<")"<<std::endl;
            std::cout<<"9. All" << std::endl;
            std::cout<<"0. Quit" << std::endl;

            std::cin>>option;
    
            // Reset to -1 if the input is invalid
            option = (option * (option >= 0 && option <= 9))
                + (-1 * !(option >= 0 && option <= 9));
        }

        // Loop through once for everything except option 9
        for (int test = 0; test < (15 * (option == 9) + 1 * (option != 9)); test++)
        {
            // Reset fastest:
            fastest = 0.0;

            // Iterate test if option 9 was chosen
            int testOption = (((test % 8) + 1) * (option == 9)) + 
                (option * (option != 9));

            std::string testHeader = "\nTest=" + std::to_string(testOption) + " Threads=" + 
                std::to_string(threadCount) + "\n" + test_names[testOption-1] + "\n";
            WriteResults(testHeader);

            if (option == 9 && testOption != 8)
                std::cout << testHeader;

            switch (testOption)
            {
            case 0: break;
            case 1: currentFunction = ADD_REG_1; break;
            case 2: currentFunction = AND_REG_REG; break;
            case 3: currentFunction = SHR_REG_CL; break;
            case 4: currentFunction = PADDB_MMX; break;
            case 5: currentFunction = CMOVcc_REG_REG; break;
            case 6: currentFunction = (void (*)(int))               // Select SSE or AVX
                ((unsigned long long)FLOPS_SSE * !AVX_CAPABLE +
                (unsigned long long)FLOPS_AVX * AVX_CAPABLE); break;
            case 7: currentFunction = IMUL_REG_REG; break;
            case 8: threadCount = (1 * (threadCount != 1)) +        // Toggle threaded or single thread
                (std::thread::hardware_concurrency() * (threadCount == 1)); break;
            }

            if (testOption == 0)    // Allow quit
                break;
            if (testOption == 8)    // Continue if the thread count has been changed
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
                thisTime /= (double)threadCount;    // ctime's clock seems to sum times of each thread

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

            double phenom2 = phenom2_performance[(testOption-1)
             + (7 * (threadCount == 1))];

            std::string instructions = "Executed " + std::to_string(gops) + " billion instructions/second\n";
            std::string score = "Score: " + std::to_string(gops / phenom2) + " Phenom's II's worth's\n";

            std::cout << instructions;
            std::cout << score;

            WriteResults(instructions);
            WriteResults(score);
        }
    }

    std::cout<<"See ya... "<< std::endl;

    return 0;
}
