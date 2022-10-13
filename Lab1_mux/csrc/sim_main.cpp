#include "verilated_vcd_c.h"
#include <cstdlib>
#include <memory>
#include <verilated.h>
#include "Vtop.h"


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

    int i = 0;

    while(i < 100) {
        top->sw = rand()%4; 
        top->x0 = rand()%2; top->x1 = rand()%2; top->x2 = rand()%2; top->x3 = rand()%2;
        step_and_dump_wave();
        i++;
    }

    sim_exit();
}
