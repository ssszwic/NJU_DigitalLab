module top(
    input               [1:0]       sw              ,
    input                           x0              ,
    input                           x1              ,
    input                           x2              ,
    input                           x3              ,
    output      reg                 f               
);

always@(*) begin
    case(sw)
        2'b00:  f   =   x0;
        2'b01:  f   =   x1;
        2'b10:  f   =   x2;
        2'b11:  f   =   x3;
        default:f   =   1'b0;
    endcase
end

endmodule
