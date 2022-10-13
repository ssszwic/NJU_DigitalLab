module bcd7seg(
    input           [3:0]           bcd             ,
    output  reg     [7:0]           seg             
);

always@(*) begin
    case(bcd)
        4'd0:   seg = ~8'b11111101;
        4'd1:   seg = ~8'b01100000;
        4'd2:   seg = ~8'b11011010;
        4'd3:   seg = ~8'b11110010;
        4'd4:   seg = ~8'b01100110;
        4'd5:   seg = ~8'b10110110;
        4'd6:   seg = ~8'b10111110;
        4'd7:   seg = ~8'b11100000;
        default:seg = ~8'b00000000;
    endcase
end

endmodule
