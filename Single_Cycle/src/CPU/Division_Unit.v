



module DivisionUnit
(
    input wire clk,
    input wire start,
    input wire reset,
    input wire[31:0] rs1,
    input wire[31:0] rs2,
    input wire _signed,
    input wire Div,

    output wire[31:0] result,
    output reg busy
);

// restoring division
wire[31:0] abs_rs1 = _signed && rs1[31] ? ~rs1 + 1 :  rs1;
wire[31:0] abs_rs2 = _signed && rs2[31] ? ~rs2 + 1 :  rs2; 

reg signed [63:0] divisor; 
reg signed [63:0] remainder;
reg signed [31:0] quotient;
reg signed [6:0] counter;

assign result = Div ? rs1[31] ^ rs2[31] ? ~quotient + 1 : quotient : remainder;



always @(posedge clk && rs1 != 0 && rs2 != 0) begin

    if (counter > 32) begin
        busy = 0;
        counter = 0;
    end
    else if( busy ) begin
        
        quotient = quotient << 1;

        if( remainder - divisor >= 0) begin
            remainder = remainder - divisor;
            quotient[0] = 1; 
        end
        else begin
            quotient[0] = 0;
        end

        divisor = divisor >> 1;
        counter = counter + 1;
            
    end
    else if (start) begin
        divisor[63:32] = abs_rs2;
        divisor[31:0] = 0;

        remainder[63:32] = 0;
        remainder = abs_rs1;

        quotient = 0;

        counter = 0;
        busy = 1;
    end
end

always @(posedge clk) begin
    if(reset) begin
        counter = 0;
        remainder = 0;
        quotient = 0;
        divisor = 0;
        
    end
end





endmodule;