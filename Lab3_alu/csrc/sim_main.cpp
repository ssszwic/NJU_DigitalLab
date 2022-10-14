#include "verilated_vcd_c.h"
#include <cstdlib>
#include <memory>
#include <verilated.h>
#include "Vtop.h"

#define MAX_SIM_TIME 1000
#define RESET_TIME 10

VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;

static Vtop* top;

void sim_init(){
    contextp = new VerilatedContext;
    tfp = new VerilatedVcdC;
    top = new Vtop;
    contextp->traceEverOn(true);
    top->trace(tfp, 0);
    tfp->open("dump.vcd");
}

void step_and_dump_wave(){
  top->eval();
  contextp->timeInc(1);
  tfp->dump(contextp->time());
}

void sim_exit(){
  step_and_dump_wave();
  tfp->close();
}

int main(int argc, char** argv, char** env) {
    sim_init();

    // initial
    // system signal
    top->sys_rst_n = 0;
    top->sys_clk = 0;
    // input signal
    top->a = 0;
    top->b = 0;
    top->opcode = 0;

    top->eval();
    tfp->dump(contextp->time());
    
    while(contextp->time() < MAX_SIM_TIME) {
        contextp->timeInc(1);
        top->sys_clk = !top->sys_clk;

        // input signal change on negedge clk
        if(!top->sys_clk) {
            // reset
            if(contextp->time() < 10) {
                top->sys_rst_n = !1;
            }
            else {
                top->sys_rst_n = !0;
            }

            // input signal
            top->a = rand() % 16;
            top->b = rand() % 16;
            top->opcode = rand() % 8;
        }
        
        // eval and save wave
        top->eval();
        tfp->dump(contextp->time());
    }

    sim_exit();
    
    return 0;
}
