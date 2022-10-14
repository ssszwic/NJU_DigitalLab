module top(
    input                           sys_clk         ,
    input                           sys_rst_n       ,
    // ps/2
    input                           ps2_clk         ,
    input                           ps2_data        ,
    output  reg         [7:0]       data_out        ,
    output  reg                     vld             
);

reg             [2:0]       ps2_clk_reg     ;
wire                        trig            ;

reg             [3:0]       cnt             ;
reg             [10:0]      data_shift      ;

reg                         finish          ;


// beat ps2 clock signal
always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        ps2_clk_reg <=  3'b0; 
    end
    else begin
        ps2_clk_reg <=  {ps2_clk_reg[1:0], ps2_clk};
    end
end

// input data vilid
assign trig = (ps2_clk_reg[2] & (~ps2_clk_reg[1])) ? 1'b1 : 1'b0;

always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        cnt <=  4'b0; 
    end
    else if(trig) begin
        if(cnt == 4'd10) begin
            cnt <=  4'd0;
        end
        else begin
            cnt <=  cnt + 1; 
        end
    end
    else begin
        cnt <=  cnt; 
    end
end

// shift data
always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        data_shift  <=  11'b0;  
    end
    else if(trig) begin
        data_shift  <=  {ps2_data, data_shift[10:1]};
    end
    else begin
        data_shift  <=  data_shift; 
    end
end

// receive data finish
always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        finish  <=  1'b0; 
    end
    else if(trig && cnt == 4'd10) begin
        finish  <=  1'b1;
    end
    else begin
        finish  <=  1'b0; 
    end
end

// examine data
always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        data_out    <=  8'b0;
        vld         <=  1'b0;
    end
    else if(finish) begin
        if((~data_shift[0]) && data_shift[10] && (^data_shift[9:1])) begin
            data_out    <=  data_shift[8:1];
            vld         <=  1'b1;
            // debub
            $display("receive %x", data_shift[8:1]);
        end
        else begin
            data_out    <=  data_out;
            vld         <=  1'b0;
        end 
    end
    else begin
        data_out    <=  data_out;
        vld         <=  1'b0;
    end 
end

endmodule
