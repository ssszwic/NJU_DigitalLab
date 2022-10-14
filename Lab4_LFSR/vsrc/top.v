module top(
    input                           sys_clk         ,
    input                           sys_rst_n       ,
    output              [7:0]       seg_0           ,
    output              [7:0]       seg_1           
);

reg             [7:0]       lfsr;

reg             [31:0]      cnt;

always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        cnt <= 32'b0; 
    end
    else if(cnt == 32'd50000000) begin
        cnt <= 32'd0;
    end
    else begin
        cnt <= cnt + 1; 
    end
end

always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        lfsr <= 8'b00000001;
    end
    else if(cnt == 32'd50000000) begin
        lfsr[7]     <=  lfsr[4] ^ lfsr[3] ^ lfsr[2] ^ lfsr[0];
        lfsr[6:0]   <=  lfsr[7:1];
    end
    else begin
        lfsr <= lfsr; 
    end
end


bcd7seg bcd7seg_inst1(
    .bcd                    (lfsr[3:0]              ),  // i 4b
    .seg                    (seg_0                  )   // o 8b
);

bcd7seg bcd7seg_inst2(
    .bcd                    (lfsr[7:4]              ),  // i 4b
    .seg                    (seg_1                  )   // o 8b
);


endmodule

