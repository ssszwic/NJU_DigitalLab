#include <nvboard.h>
#include <Vtop.h>

static TOP_NAME dut;

void nvboard_bind_all_pins(Vtop* top);

static void single_cycle() {
  dut.sys_clk = 0; dut.eval();
  dut.sys_clk = 1; dut.eval();
}

static void reset(int n) {
  dut.sys_rst_n = 0;
  while (n -- > 0) single_cycle();
  dut.sys_rst_n = 1;
}

int main() {
  nvboard_bind_all_pins(&dut);
  nvboard_init();

  reset(10);

  while(1) {
    nvboard_update();
    single_cycle();
  }
}
