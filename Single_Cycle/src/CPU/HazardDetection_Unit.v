
`include "./Macros/OpCodes.vh"

module HarzardDetection_Control
(
    input wire[6:0] exmem_opcode,
    input wire[4:0] idex_rd,
    input wire[4:0] ifid_rs1,
    input wire[4:0] ifid_rs2,
    input wire[31:0] JmpDestination,

    input wire MemRead,

    output reg ifid_reset,
    output reg idex_reset,

    output reg PCwrite,
    output reg ifid_write,

    output reg PCSrc1,
    output reg halt
);

wire Load_hzd;
wire Control_hzd;

// Checking for load and Store hazard

assign Load_hzd = (idex_rd == ifid_rs1) || (idex_rd == ifid_rs2) && MemRead;
assign Control_hzd = ( exmem_opcode == `B_opcode ) || ( exmem_opcode == `JAL_opcode) || (exmem_opcode == JALR_opcode);
assign PCSrc1 = JmpDestination;

always begin
    
    // check for control first

    if( Control_hzd ) begin
        ifid_reset <= `HIGH;
        idex_reset <= `HIGH;
        PCwrite <= `HIGH;
    end
    else if( Load_hzd ) begin
        halt <= `HIGH;
        ifid_write <= `HIGH;
    end
    else begin
        ifid_reset <= `LOW;
        idex_reset <= `LOW;
        PCwrite <= `LOW;
        halt <= `LOW;
        ifid_write <= `LOW;
    end

end



endmodule