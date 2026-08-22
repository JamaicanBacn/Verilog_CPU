`include "./Macros/OpCodes.vh"


module instruction_decoder
(
    input wire[31:0] instruction_in,
    
    output wire memread,
    output wire memwrite,
    output wire regwrite,
    output wire branch,
    output wire bubble,
    output wire alusrc,
    output wire aluop

);


//check each opcode and assing values

wire opcode = instruction_in[6:0];


case( opcode ) begin

    `R_opcode : begin
    
    end

endcase




endmodule