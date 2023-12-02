// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2017 by Wilson Snyder.
//======================================================================
#include <string>
#include <iostream>
#include <fstream>

// Include common routines
#include <verilated.h>

#include <sys/stat.h>  // mkdir

// Include model header, generated from Verilating "top.v"
#include "Vaoc_tb.h"

// If "verilator --trace" is used, include the tracing class
#if VM_TRACE
# include <verilated_vcd_c.h>
#endif

// Current simulation time (64-bit unsigned)
vluint64_t main_time = 0;
// Called by $time in Verilog
double sc_time_stamp() {
    return main_time;  // Note does conversion to real, to match SystemC
}

int main(int argc, char** argv, char** env) {
    // This is a more complicated example, please also see the simpler examples/make_hello_c.
    std::string logout = "";
    for (int i = 0; i < argc; i++) {
        if ((std::string(argv[i]) ==  "--logfile") && i+1 < argc)
            logout += std::string(argv[i+1]);
    }

    // Prevent unused variable warnings
    if (0 && argc && argv && env) {}

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs
    Verilated::debug(0);

    // Randomization reset policy
    // May be overridden by commandArgs
    Verilated::randReset(2);

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    Verilated::commandArgs(argc, argv);

    // Construct the Verilated model, from Vaoc_tb.h generated from Verilating "top.v"
    Vaoc_tb* top = new Vaoc_tb;  // Or use a const unique_ptr, or the VL_UNIQUE_PTR wrapper

#if VM_TRACE
    // If verilator was invoked with --trace argument,
    // and if at run time passed the +trace argument, turn on tracing
    VerilatedVcdC* tfp = NULL;
    const char* flag = Verilated::commandArgsPlusMatch("trace");
    if (flag && 0==strcmp(flag, "+trace")) {
        Verilated::traceEverOn(true);  // Verilator must compute traced signals
        VL_PRINTF("Enabling waves into logs/vlt_dump.vcd...\n");
        tfp = new VerilatedVcdC;
        top->trace(tfp, 99);  // Trace 99 levels of hierarchy
        mkdir("logs", 0777);
        tfp->open("logs/vlt_dump.vcd");  // Open the dump file
    }
#endif

    // Set some inputs
    // top->data_in = 0x0f8a;
    top->rst_n = 0;
    top->eval();
    top->clk = 0;
    top->eval();
    top->clk = 1;
    top->eval();
    top->rst_n = 1;
    top->eval();
    
    // Simulate until $finish
    while (!Verilated::gotFinish() && main_time < 100000) {
        main_time++;
        top->clk ^= 1;
        
        top->eval();
#if VM_TRACE        
        tfp->dump(main_time);
#endif
    }

    // Do a couple of clock cycles for easier waveform debugging
    main_time++;
    top->clk ^= 1;
    top->eval();
#if VM_TRACE        
        tfp->dump(main_time);
#endif
    main_time++;
    top->clk ^= 1;
    top->eval();
#if VM_TRACE        
        tfp->dump(main_time);
#endif


    // Final model cleanup
    top->final();

    // Close trace if opened
#if VM_TRACE
    if (tfp) { tfp->close(); }
#endif

    //  Coverage analysis (since test passed)
#if VM_COVERAGE
    mkdir("logs", 0777);
    VerilatedCov::write("logs/coverage.dat");
#endif

    // Destroy model
    delete top; top = NULL;

    // Fin
    exit(0);
}
