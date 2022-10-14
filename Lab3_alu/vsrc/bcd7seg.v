module bcd7seg(
    input           [3:0]           bcd             ,
    output  reg     [7:0]           seg_sign        ,             
    output          [7:0]           seg_num                      
);

wire        [3:0]   num;

assign num = (bcd[3]) ? (~bcd + 1) : bcd;

always@(*) begin
    case(num[3:0])
        4'd0:   seg_num = ~8'b11111100;
        4'd1:   seg_num = ~8'b01100000;
        4'd2:   seg_num = ~8'b11011010;
        4'd3:   seg_num = ~8'b11110010;
        4'd4:   seg_num = ~8'b01100110;
        4'd5:   seg_num = ~8'b10110110;
        4'd6:   seg_num = ~8'b10111110;
        4'd7:   seg_num = ~8'b11100000;
        4'd8:   seg_num = ~8'b11111110;
        default:seg_num = ~8'b00000000;
    endcase
end

assign seg_sign = (bcd[3]) ? ~8'b00000010 : ~8'b00000000;

endmodule
