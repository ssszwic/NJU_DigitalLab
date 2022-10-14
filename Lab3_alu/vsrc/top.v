module top(
    // data
    input       signed  [3:0]       a               ,
    input       signed  [3:0]       b               ,
    input               [2:0]       opcode          ,
    output  reg         [7:0]       seg_sign        ,
    output  reg         [7:0]       seg_num         
);

localparam      PLUS    =   3'b000,
                SUB     =   3'b001,
                NOT     =   3'b010,
                AND     =   3'b011,
                OR      =   3'b100,
                XOR     =   3'b101,
                COMP    =   3'b110,
                EQUA    =   3'b111;

wire    signed  [4:0]   a_1         ;
wire    signed  [4:0]   b_1         ;

wire    signed  [4:0]   plus_tmp    ;
wire    signed  [4:0]   sub_tmp     ;
wire    signed  [4:0]   tmp         ;


reg     signed  [3:0]   pl_su;
wire            [3:0]   not_comb    ;
wire            [3:0]   and_comb    ;
wire            [3:0]   or_comb     ;
wire            [3:0]   xor_comb    ;
wire                    comp_comb   ;
wire                    equa_comb  ;

reg             [3:0]   data_out    ;

// add 1 bit to avoid overflow or underflow
assign a_1  =   {a[3], a};
assign b_1  =   {b[3], b};

// plus
assign plus_tmp =   a_1 + b_1;
// sub
assign sub_tmp  =   a_1 - b_1;

assign tmp      =   (opcode == PLUS) ? plus_tmp : sub_tmp;

always@(*) begin
    if((~tmp[4]) & tmp[3]) begin
        // OverFlow
        pl_su   =   4'b0111;
    end
    else if(tmp[4] & (~tmp[3])) begin
        // UnderFlow
        pl_su   =   4'b1000; 
    end
    else begin
        pl_su   =   tmp[3:0];
    end
end

// not
assign not_comb =   ~a;

// and
assign and_comb =   a & b;

// or
assign or_comb  =   a | b;

// xor
assign xor_comb =   a ^ b;

// compare
assign comp_comb    =   (sub_tmp[4]) ? 1'b1 : 1'b0;

// equa
assign equa_comb   =   (sub_tmp == 5'd0) ? 1'b1 : 1'b0;

// data_out
always@(*) begin
    case(opcode)
        PLUS    : data_out  = pl_su;
        SUB     : data_out  = pl_su;
        NOT     : data_out  = not_comb;
        AND     : data_out  = and_comb;
        OR      : data_out  = or_comb;
        XOR     : data_out  = xor_comb;
        COMP    : data_out  = {3'b0, comp_comb};
        EQUA    : data_out  = {3'b0, equa_comb};
        default : data_out  = 4'b0;
    endcase 
end

// data_out -> seg

bcd7seg bcd7seg_inst(
    .bcd                    (data_out               ),  // i 4b
    .seg_sign               (seg_sign               ),  // o 8b
    .seg_num                (seg_num                )   // o 8b
);

endmodule
