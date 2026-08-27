
`include "./Macros/OpCodes.vh"


module ImmGen(

    input wire[31:0] instruction_in,
    output reg[31:0] Imm_out
);

wire[6:0] opcode = instruction_in[6:0];

always @(*) begin

    case( opcode )

        `I_opcode,
        `L_opcode,
        `JALR_opcode :  Imm_out = {{20{instruction_in[31]}},
                              instruction_in[31:20]};
        
        `S_opcode : Imm_out = { {20{instruction_in[31]}},
                             instruction_in[31:25],
                             instruction_in[11:7] };

        `B_opcode : Imm_out = { {19{instruction_in[31]}},
                             instruction_in[31],
                             instruction_in[7],
                             instruction_in[30:25],
                             instruction_in[11:8] , 1'b0};

        `LUI_opcode,
        `AUIPC_opcode : Imm_out = { instruction_in[31:12], 12'b0};

        `JAL_opcode : Imm_out = { {11{instruction_in[31]}},
                                instruction_in[31],
                                instruction_in[19:12],
                                instruction_in[20],
                                instruction_in[30:21],
                                1'b0
                                };
        default : Imm_out = 0;

    endcase

end




endmodule