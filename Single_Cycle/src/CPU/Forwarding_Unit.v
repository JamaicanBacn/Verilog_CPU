
`include "./Macros/OpCodes.vh"

module ForwardingControl
(

    input wire[4:0] memwb_rd,
    input wire[4:0] exmem_rd,
    input wire[6:0] opcode,

    input wire exmem_WriteToRegister,
    input wire memwb_WriteToRegister,

    input wire MemRead,

    input wire exmem_bubble,
    input wire memwb_bubble,
    input wire idex_bubble,


    input wire[4:0] idex_rs1,
    input wire[4:0] idex_rs2,

    output wire[1:0] rs1_fwd,
    output wire[1:0] rs2_fwd

);



wire Uses_rs1 = ( opcode !== `JAL_opcode) && ( opcode !== `LUI_opcode ) && ( opcode !== `AUIPC_opcode ) && ( !idex_bubble );
wire Uses_rs2 = ( opcode == `S_opcode || opcode == `R_opcode || opcode == `B_opcode ) && !idex_bubble;


wire rs1_exmem_fwd = Uses_rs1 && exmem_rd == idex_rs1 && idex_rs1 != 0 && exmem_WriteToRegister && !exmem_bubble;
wire rs1_memwb_fwd = Uses_rs1 && memwb_rd == idex_rs1 && idex_rs1 != 0 && memwb_WriteToRegister && !memwb_bubble;

wire rs2_exmem_fwd = Uses_rs2 && exmem_rd == idex_rs2 && idex_rs2 != 0 && exmem_WriteToRegister && !exmem_bubble;
wire rs2_memwb_fwd = Uses_rs2 && memwb_rd == idex_rs2 && idex_rs2 != 0 && memwb_WriteToRegister && !memwb_bubble;

assign rs1_fwd = rs1_exmem_fwd ? 2'b01 :
                 rs1_memwb_fwd ? 
                 MemRead ? 2'b11 : 2'b10 : 0;

assign rs2_fwd = rs2_exmem_fwd ? 2'b01 :
                 rs2_memwb_fwd ? 
                 MemRead ? 2'b11 : 2'b10 : 0;


endmodule

module ForwardingMux
(
    
    input wire[1:0] rs1_fwd,
    input wire[1:0] rs2_fwd,

    input wire[31:0] exmem_alu_out,
    input wire[31:0] memwb_alu_out,
    input wire[31:0] memwb_memory_out,


    output wire[31:0] rs1_fwd_data,
    output wire[31:0] rs2_fwd_data
);

assign rs1_fwd_data = (rs1_fwd == 2'b01) ? exmem_alu_out :
                      (rs1_fwd == 2'b10) ? memwb_alu_out :
                      (rs1_fwd == 2'b11) ? memwb_memory_out : 0;

assign rs2_fwd_data = (rs2_fwd == 2'b01) ? exmem_alu_out :
                      (rs2_fwd == 2'b10) ? memwb_alu_out :
                      (rs2_fwd == 2'b11) ? memwb_memory_out : 0;

endmodule



module ForwardingUnit
(

    input wire[4:0] memwb_rd,
    input wire[4:0] exmem_rd,
    input wire[6:0] opcode,

    input wire exmem_WriteToRegister,
    input wire memwb_WriteToRegister,

    input wire exmem_bubble,
    input wire memwb_bubble,
    input wire idex_bubble,

    input wire MemRead,

    input wire[31:0] exmem_alu_out,
    input wire[31:0] exmem_rs2,
    input wire[31:0] memwb_alu_out,
    input wire[31:0] memwb_memory_out,

    input wire[4:0] idex_rs1,
    input wire[4:0] idex_rs2,


    output wire[1:0] rs1_fwd,
    output wire[1:0] rs2_fwd,
    output wire[31:0] rs1_fwd_data,
    output wire[31:0] rs2_fwd_data

);

ForwardingControl FwdControl(.memwb_rd(memwb_rd),
                             .exmem_rd(exmem_rd),
                             .exmem_WriteToRegister(exmem_WriteToRegister),
                             .memwb_WriteToRegister(memwb_WriteToRegister),
                             .exmem_bubble(exmem_bubble),
                             .opcode(opcode),
                             .MemRead(MemRead),
                             .memwb_bubble(memwb_bubble),
                             .idex_bubble(idex_bubble),
                             .idex_rs1(idex_rs1),
                             .idex_rs2(idex_rs2),
                             .rs1_fwd(rs1_fwd),
                             .rs2_fwd(rs2_fwd)
                             );

ForwardingMux FwdMux( .rs1_fwd(rs1_fwd),
                      .rs2_fwd(rs2_fwd),
                      .exmem_alu_out(exmem_alu_out),
                      .memwb_alu_out(memwb_alu_out),
                      .memwb_memory_out(memwb_memory_out),
                      .rs1_fwd_data(rs1_fwd_data),
                      .rs2_fwd_data(rs2_fwd_data)
                      );





endmodule