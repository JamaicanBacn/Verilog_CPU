

// For int values
// will not keep remainder




module MultiplicationUnit
(   

    input wire clk,
    input wire start,
    input wire _signed,
    input wire[31:0] Multiplicand,
    input wire[31:0] Multiplier,

    output wire[31:0] Product,
    output wire busy
);

reg [31:0] internal_multiplier;
reg [31:0] internal_product;
reg [31:0] internal_multiplicand;
reg internal_signed;
reg rs1_sign;
reg rs2_sign;

assign busy = internal_multiplier != 0;
assign Product = internal_product;

always @(posedge clk) begin


    if( busy ) begin
        if( internal_multiplier[0] ) begin
        
            internal_product <= internal_product + internal_multiplicand;
        end
        
        internal_multiplicand <= internal_multiplicand << 1;
        internal_multiplier <= internal_multiplier >> 1;
        
    end
    else if( start ) begin
    
        internal_multiplier <= Multiplier;
        internal_multiplicand <= Multiplicand;
        internal_product <= 0;
        internal_signed = _signed;
        rs1_sign = Multiplicand[31];
        rs2_sign = Multiplier[31];

        if( _signed ) begin
            
            if( rs1_sign ) begin
                internal_multiplicand <= ~Multiplicand + 1;
            end

            if(rs2_sign) begin
                internal_multiplier <= ~Multiplier + 1;
            end
        end

    end
end





endmodule;