module top(
    input                           sys_clk         ,
    input                           sys_rst_n       ,
    // vga
    output                          hsync           ,
    output                          vsync           ,
    output                          blank_n         ,
    output              [7:0]       vga_r           ,
    output              [7:0]       vga_g           ,
    output              [7:0]       vga_b           
);

wire                [9:0]   h_addr      ;
wire                [9:0]   v_addr      ;
wire                [23:0]  vga_data    ;


vga_ctrl vga_ctrl_inst(
    .sys_clk                (sys_clk                ),  // i 1b
    .sys_rst_n              (sys_rst_n              ),  // i 1b
    // display data
    .vga_data               (vga_data               ),  // i 24b
    .h_addr                 (h_addr                 ),  // o 10b
    .v_addr                 (v_addr                 ),  // o 10b
    // vga signal
    .hsync                  (hsync                  ),  // o 1b
    .vsync                  (vsync                  ),  // o 1b
    .valid                  (blank_n                ),  // o 1b
    .vga_r                  (vga_r                  ),  // o 8b
    .vga_g                  (vga_g                  ),  // o 8b
    .vga_b                  (vga_b                  )   // o 8b
);


vmem vmem_inst(
    .h_addr                 (h_addr                 ),  // i 10b
    .v_addr                 (v_addr                 ),  // i 10b
    .data_out               (vga_data               )   // o 24b
);

endmodule
