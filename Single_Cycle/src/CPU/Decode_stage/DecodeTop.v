
module DecodeTop(
    
    input wire clk,
    input wire reset,
    input wire write_en,

    input wire[4:0] writeAddr,
    input [31:0] instruction_in,
    input reg [31:0] writeData,

    output reg memread_out,
    output reg memwrite_out,
    output reg regwrite_out,
    output reg bubble_out,
    output reg branch_out,

    output reg [31:0] instruction_out,
    output reg [4:0] rs1_addr_out,
    output reg [4:0] rs2_addr_out,
    output reg [4:0] rd_addr_out,

    output reg [4:0] aluop,
    output reg [1:0] alusrc,

    output reg [31:0] Imm_out,
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out
);

assign instruction_out = instruction_in; 

InstructionDecoder InstructionDecoder_inst(
    .instruction_in(instruction_in),

    .rs1(rs1_addr_out),
    .rs2(rs2_addr_out),
    .rd(rd_addr_out),

    .memread(memread_out),
    .memwrite(memwrite_out),
    .regwrite(regwrite_out),
    .branch(branch_out),
    .bubble(bubble_out),
    .alusrc(alusrc),
    .aluop(aluop)
);

ImmGen ImmGen_inst(
    .instruction_in(instruction_in),
    .Imm_out(Imm_out)
);

RegFile   RegFile_inst(
    .clk(clk),
    .write_en(write_en),
    .reset(reset),

    .rs1_addr(rs1_addr_out),
    .rs2_addr(rs2_addr_out),

    .write_addr(writeAddr),

    .data_in(writeData),
    .rs1_out(rs1_data_out),
    .rs2_out(rs2_data_out)
);


endmodule


