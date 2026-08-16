


module ForwardingUnit
(
    input wire[4:0] memwb_rd,
    input wire[4:0] exmem_rd,

    input wire[4:0] idex_rs1,
    input wire[4:0] idex_rs2

    output wire exmem_fwd,
    output wire memwb_fwd,

    output wire[31:0] exmem_fwd_data,
    output wire[31:0 ]

);