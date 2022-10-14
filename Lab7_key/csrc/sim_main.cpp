#include "verilated_vcd_c.h"
#include <cstdlib>
#include <memory>
#include <verilated.h>
#include "Vtop.h"

#define MAX_SIM_TIME 100000000
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
    top->ps2_clk = 0;
    top->ps2_data = 0;

    top->eval();
    tfp->dump(contextp->time());

    int send_data[11] = {0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1};
    int i = 0;
    int ps2_period = 100;
    int ps2_cnt = 0;
    
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
            // ps2_clk change every 200
            if (ps2_cnt == ps2_period) {
                
                top->ps2_clk = !top->ps2_clk;

                ps2_cnt = 0;
                // ps2_data change on posedge ps2_clk
                if(top->ps2_clk == 1) {
                    if(i > 10)
                        break;
                    top->ps2_data = send_data[i];
                    i++;
                }
            }
            ps2_cnt++;

        }
        
        // eval and save wave
        top->eval();
        tfp->dump(contextp->time());
    }

    sim_exit();
    
    return 0;
}
