

`include "./Macros/OpCodes.vh"

module IFID_reg(
    
    input wire[31:0] instruction_in,
    input wire ifid_write,
    input wire reset,
    input wire clk,

    output reg[31:0] instruction_out,
    
    output reg bubble,
    output reg[6:0] opcode
);

reg[31:0] instruction_out;
reg[4:0] rs1;
reg[4:0] rs2;
reg[4:0] rd;

initial begin
    instruction_out <= `I_opcode;
    rs1 <= 0;
    rs2 <= 0;
    rd <= 0;
    op <= 0;
    bubble <= 1;
end
 

always @( posedge clk) begin

    if( reset ) begin 
        instruction_out <= `I_opcode;
        rs1 <= 0;
        rs2 <= 0;
        rd <= 0;
        op <= 0;
        bubble <= 1;
    end
    else if ( ifid_write ) begin
        instruction_out <= instruction_in;
        opcode <= instruction_in[6:0];
        rs1 <= instruction_in[19:15];
        rs2 <= instruction_in[24:20];
        rd  <= instruction_in[11:7];
    end

end

endmodule

module IDEX_reg
(
    input wire clk,
    input wire reset,

    input wire[31:0] rs1_data_in,
    input wire[31:0] rs2_data_in,
    input wire instruction_in,

    output reg[31:0] instruction_out,

    // hazard detection

    input wire RegisterWrite_in,
    input wire MemRead_in,
    input wire MemWrite_in,
    input wire Branch_in,
    input wire bubble_in,

    output reg RegisterWrite_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg Branch_out,
    output reg bubble_out


);

inital begin
    instruction_out <= 0;
    opcode_out <= 7'b0010011;
    rs1_data_out <= 0;
    rs2_data_out <= 0;

    rs1_addr_out <= 0;
    rs2_addr_out <= 0;
    rd_addr_out <= 0;

    RegisterWrite_out <= 0;
    MemRead_out <= 0;
    MemWrite_out <= 0;
    Branch_out <= 0;
    bubble_out <= 1;
end


reg[6:0] opcode_out;
reg[31:0] rs1_data_out;
reg[31:0] rs2-data_out;

reg[4:0] rs1_addr_out;
reg[4:0] rs2_addr_out;
reg[4:0] rd_addr_out;

always @(posedge clk ) begin

    if( reset ) begin
        instruction_out <= 0;
        opcode_out <= 7'b0010011;
        rs1_data_out <= 0;
        rs2_data_out <= 0;

        rs1_addr_out <= 0;
        rs2_addr_out <= 0;
        rd_addr_out <= 0;

        RegisterWrite_out <= 0;
        MemRead_out <= 0;
        MemWrite_out <= 0;
        Branch_out <= 0;
        bubble_out <= 1;
    end
    else begin
        instruction_out <= instruction_in;
        opcode_out <= opcode_in;
        rs1_data_out <= rs1_data_in;
        rs2_data_out <= rs2_data_in;

        rs1_addr_out <= rs1_addr_in;
        rs2_addr_out <= rs2_addr_in;
        rd_addr_out <= rd_addr_in;

        RegisterWrite_out <= RegisterWrite_in;
        MemRead_out <= MemRead_in;
        MemWrite_out <= MemWrite_in;
        Branch_out <= Branch_in;
        bubble_out <= bubble_in;
    end
end

endmodule


module EXMEM_reg(
    
    input wire clk,
    input wire reset,

    input  wire[31:0] instruction_in,
    output wire[31:0] instruction_out,

    input wire MemRead_in,
    input wire MemWrite_in,
    input wire Branch_in,
    input wire RegisterWrite_in,
    input wire bubble_in,

    input wire[4:0] rd_addr_in;

    input wire[31:0] Alu_output_in,
    input wire[31:0] Alu_input2_in,

    output reg[31:0] Alu_output_out,
    output reg[31:0] Alu_input2_out,
    output reg[4:0] rd_addr_out,
    
    output reg RegisterWrite_out,
    output reg bubble_out


);

initial begin
    rd_addr_out <= 0;
    Alu_output_out <= 0;
    Alu_input2_out <= 0;
    RegisterWrite_out <= 0;
    bubble_out <= 1;
end


always @( posedge clk ) begin
    if(reset) begin
        rd_addr_out <= 0;
        Alu_output_out <= 0;
        Alu_input2_out <= 0;
        RegisterWrite_out <= 0;
        bubble_out <= 1;
    end
    else begin 
        rd_addr_out <= rd_addr_in;
        Alu_input2_out <= Alu_input2_in;
        Alu_output_out <= Alu_output_in;
        RegisterWrite_out <= RegisterWrite_in;
        bubble_out <= bubble_in;
    end
end

endmodule

module MEMWB_reg(

    input wire clk,
    input wire reset,
    input wire RegisterWrite_in,
    input wire[4:0] rd_addr_in,
    input wire[31:0] Alu_output_in,
    input wire[31:0] Memory_output_in,

    input wire bubble_in,

    output wire[31:0] Alu_output_out,
    output wire[31:0] Memory_output_out,

    output wire[4:0] rd_addr_out,
    output reg bubble_out,

);

initial begin
    Alu_input2_out <= 0;
    Memory_output_out <= 0;
    rd_addr_out <= 0;
    bubble_out <= 1;
end

always @(posedge clk) begin
    if (reset) begin
        Alu_input2_out <= 0;
        Memory_output_out <= 0;
        rd_addr_out <= 0;
        bubble_out <= 1;
    end
    else begin
        Alu_input2_out <= Alu_input2_in;
        Memory_output_out <= Memory_output_in;
        rd_addr_out <= rd_addr_in;
        bubble_out <= bubble_in;
    end

endmodule