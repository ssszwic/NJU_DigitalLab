module top(
    input                           sys_clk         ,
    input                           sys_rst_n       ,
    input               [7:0]       sw              ,
    input                           en              ,
    output      reg     [7:0]       seg             ,
    output      reg                 led             
);

reg         [7:0]       seg_comb    ;
reg                     led_comb    ;

reg         [3:0]       bcd         ;

always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        seg <=  8'hff;
        led <=  1'b0;
    end
    else begin
        seg <=  (en) ? seg_comb : 8'hff;
        led <=  (en) ? led_comb : 1'b0;
    end
end

// priority encoder
always@(*) begin
    if(sw[7]) begin
        bcd         =   4'd7;
        led_comb    =   1'b1;
    end
    else if(sw[6]) begin
        bcd         =   4'd6;
        led_comb    =   1'b1;
    end
    else if(sw[5]) begin
        bcd         =   4'd5;
        led_comb    =   1'b1;
    end
    else if(sw[4]) begin
        bcd         =   4'd4;
        led_comb    =   1'b1;
    end
    else if(sw[3]) begin
        bcd         =   4'd3;
        led_comb    =   1'b1;
    end
    else if(sw[2]) begin
        bcd         =   4'd2;
        led_comb    =   1'b1;
    end
    else if(sw[1]) begin
        bcd         =   4'd1;
        led_comb    =   1'b1;
    end
    else if(sw[0]) begin
        bcd         =   4'd0;
        led_comb    =   1'b1;
    end
    else begin
        bcd         =   4'd0;
        led_comb    =   1'b0;
    end
end

// bcd2seg
bcd7seg bcd7seg_inst(
    .bcd                    (bcd                    ),  // i 4b
    .seg                    (seg_comb               )   // o 8b
);




endmodule
