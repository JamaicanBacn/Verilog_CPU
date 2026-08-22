`include "./Macros/OpCodes.vh"


module instruction_decoder
(
    input wire[31:0] instruction_in,
    
    output reg memread,
    output reg memwrite,
    output reg regwrite,
    output reg branch,
    output reg bubble,
    output reg alusrc,
    output reg aluop

);


//check each opcode and assing values

wire opcode = instruction_in[6:0];


case( opcode ) begin

    `R_opcode : begin
        memread  <= `LOW;
        memwrite <= `LOW;
        regwrite <= `HIGH;
        branch <= `LOW;
        bubble <= `LOW;
        alusrc <= 2'b0; // for using rs2
    end

    `I_opcode : begin
        
    end

endcase




endmodule