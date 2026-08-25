`timescale 1ns/1ns

`include "./Macros/OpCodes.vh"

module ForwardingUnit_tb;


reg[4:0] memwb_rd;
reg[4:0] exmem_rd;
reg[6:0] opcode;

reg exmem_WriteToRegister;
reg memwb_WriteToRegister;

reg exmem_bubble;
reg memwb_bubble;
reg idex_bubble;

reg MemRead;

reg[31:0] exmem_alu_out;
reg[31:0] exmem_rs2;
reg[31:0] memwb_alu_out;
reg[31:0] memwb_memory_out;

reg[4:0] idex_rs1;
reg[4:0] idex_rs2;


wire[1:0] rs1_fwd;
wire[1:0] rs2_fwd;
wire[31:0] rs1_fwd_data;
wire[31:0] rs2_fwd_data;

ForwardingUnit FWD_tb(.memwb_rd(memwb_rd),
                   .exmem_rd(exmem_rd),
                   .exmem_WriteToRegister(exmem_WriteToRegister),
                   .memwb_WriteToRegister(memwb_WriteToRegister),
                   .exmem_bubble(exmem_bubble),
                   .memwb_bubble(memwb_bubble),
                   .idex_bubble(idex_bubble),
                   .opcode(opcode),
                   .MemRead(MemRead),
                   .exmem_alu_out(exmem_alu_out),
                   .exmem_rs2(exmem_rs2),
                   .memwb_alu_out(memwb_alu_out),
                   .memwb_memory_out(memwb_memory_out),
                   .idex_rs1(idex_rs1),
                   .idex_rs2(idex_rs2),
                   .rs1_fwd(rs1_fwd),
                   .rs2_fwd(rs2_fwd),
                   .rs1_fwd_data(rs1_fwd_data),
                   .rs2_fwd_data(rs2_fwd_data)
                   );



initial begin

$dumpfile("./TestBenches/FWD/FWD.vcd");
$dumpvars(0 , FWD_tb );

exmem_alu_out <= 32'hCAFECAFE;
exmem_rs2 <= 32'hDEADBEEF;
memwb_alu_out <= 32'hFFFFFFFF;
memwb_memory_out <= 32'h00B00B00;

idex_bubble <= 0;
exmem_bubble <= 0;
memwb_bubble <= 0;
MemRead <= 0;

exmem_rd <= 0;
memwb_rd <= 0;

idex_rs1 <= 0;
idex_rs2 <= 0;

opcode <= `R_opcode;

exmem_WriteToRegister <= 0;
memwb_WriteToRegister <= 0;

#5;

exmem_WriteToRegister <= 1;
memwb_WriteToRegister <= 1;

exmem_rd <= 12;
memwb_rd <= 12;
idex_rs1 <= 12;

#5;

idex_rs2 <= 10;
memwb_rd <= 10;


#5;

idex_rs2 <= 0;
exmem_rd <= 0;
memwb_rd <= 0;

#5;

exmem_bubble <= 1;
memwb_rd <= 20;
exmem_rd <= 20;
idex_rs1 <= 20;
idex_rs2 <= 20;

#5

MemRead <= 1;

#5

exmem_bubble <= 0;

#5

memwb_bubble <= 1;

#5

MemRead <= 0;



$finish;


end


endmodule
