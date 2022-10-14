module bcd7seg(
    input           [3:0]           bcd             ,
    output  reg     [7:0]           seg                          
);

// ---7---
// |     |
// 2     6
// |--1--|
// 3     5   ---
// |     |   -0-
// ---4---   ---
always@(*) begin 
    case(bcd)
        4'h0:   seg = ~8'b11111100;
        4'h1:   seg = ~8'b01100000;
        4'h2:   seg = ~8'b11011010;
        4'h3:   seg = ~8'b11110010;
        4'h4:   seg = ~8'b01100110;
        4'h5:   seg = ~8'b10110110;
        4'h6:   seg = ~8'b10111110;
        4'h7:   seg = ~8'b11100000;
        4'h8:   seg = ~8'b11111110;
        4'h9:   seg = ~8'b11110110;
        4'ha:   seg = ~8'b11101110;
        4'hb:   seg = ~8'b00111110;
        4'hc:   seg = ~8'b10011100;
        4'hd:   seg = ~8'b01111010;
        4'he:   seg = ~8'b10011110;
        4'hf:   seg = ~8'b10001110;
        default:seg = ~8'b00000000;
    endcase
end

endmodule
