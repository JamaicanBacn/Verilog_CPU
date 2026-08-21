

module ProgramCounter(

    input wire clk,
    input wire[31:0] Src1,

    input wire PcWrite,
    input wire halt,
    input wire reset,

    output reg[31:0] PC_output

);


wire [31:0]Src0;

// PC needs to be changed
always @(posedge clk or posedge reset) begin
    
    if( reset ) begin
       PC_output <= 0; 
    end
    else if( PcWrite == 1 ) begin

        PC_output <= Src1;
    end
    else if( halt == 0) begin
        PC_output <= Src0;
    end
    
end

assign Src0 = PC_output + 4;

endmodule