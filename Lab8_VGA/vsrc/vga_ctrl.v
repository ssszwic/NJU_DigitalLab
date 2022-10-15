module vga_ctrl(
    input                           sys_clk         ,
    input                           sys_rst_n       ,
    // display data
    input               [23:0]      vga_data        ,
    output  reg         [9:0]       h_addr          ,
    output  reg         [9:0]       v_addr          ,
    // vga signal
    output  reg                     hsync           ,
    output  reg                     vsync           ,
    output  reg                     valid           ,
    output  reg         [7:0]       vga_r           ,
    output  reg         [7:0]       vga_g           ,
    output  reg         [7:0]       vga_b           
);

localparam      H_FRONTPORCH    =   96  ,
                H_ACTIVE        =   144 ,
                H_BACKPORCH     =   784 ,
                H_TOTAL         =   800 ;

localparam      V_FRONTPORCH    =   2   ,
                V_ACTIVE        =   35  ,
                V_BACKPORCH     =   515 ,
                V_TOTAL         =   525 ;

reg         [9:0]   h_cnt       ;
reg         [9:0]   v_cnt       ;

always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        h_cnt   <=  10'b0; 
    end
    else if(h_cnt == H_TOTAL - 1) begin
        h_cnt   <=  10'd0;   
    end
    else begin
        h_cnt   <=  h_cnt + 1; 
    end
end

always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        v_cnt   <=  10'b0; 
    end
    else if(h_cnt == H_TOTAL - 1) begin
        if(v_cnt == V_TOTAL - 1) begin
            v_cnt   <=  10'd0;
        end
        else begin
            v_cnt   <=  v_cnt + 1; 
        end
    end
    else begin
        v_cnt   <=  v_cnt; 
    end 
end

// address
always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        h_addr  <=  10'b0;
    end
    else if((h_cnt > H_ACTIVE - 3) && (h_cnt < H_BACKPORCH - 2)) begin
        h_addr  <=  h_cnt - (H_ACTIVE - 2); 
    end
    else begin
        h_addr  <=  10'd0; 
    end
end

always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        v_addr  <=  10'b0;
    end
    else if((v_cnt > V_ACTIVE - 3) && (v_cnt < V_BACKPORCH - 2)) begin
        v_addr  <=  v_cnt - (V_ACTIVE - 2); 
    end
    else begin
        v_addr  <=  10'd0; 
    end
end

// vga signal
always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        hsync   <=  1'b1;
        vsync   <=  1'b1;
    end
    else begin
        if(h_cnt < (H_FRONTPORCH - 1)) begin
            hsync   <=  1'b0; 
        end
        else begin
            hsync   <=  1'b1; 
        end

        if(v_cnt < (V_FRONTPORCH - 1)) begin
            vsync   <=  1'b0; 
        end
        else begin
            vsync   <=  1'b1; 
        end
    end
end

always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        valid   <=  1'b0;
    end
    else if(h_cnt > (H_ACTIVE - 2) && h_cnt < (H_BACKPORCH - 1)
            && v_cnt > (V_ACTIVE - 2) && v_cnt < (V_BACKPORCH - 1)) begin
        valid   <=  1'b1; 
    end
    else begin
        valid   <=  1'b0; 
    end
end

always@(posedge sys_clk or negedge sys_rst_n) begin
    if(~sys_rst_n) begin
        {vga_r, vga_g, vga_b}   <=  24'b0;
    end
    else begin
        {vga_r, vga_g, vga_b}   <=  vga_data;
    end
end

endmodule
