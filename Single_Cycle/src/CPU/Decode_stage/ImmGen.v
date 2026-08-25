
`include "./Macros/OpCodes.vh"


module ImmGen(

    input wire[31:0] instr,
    output reg[31:0] imm,
);

wire[6:0] opcode = instr[6:0];

always @(*) begin

    case( opcode )

        `I_opcode,
        `L_opcode,
        `JALR_opcode :  imm <= {{20{instr[31]}},
                              instr[31:20]};
        
        `S_opcode : imm <= { {20{instr[31]}},
                             instr[31:25],
                             instr[11:7] };

        `B_opcode : imm <= { {20{instr[31]}},
                             instr[31],
                             instr[7],
                             instr[31:25],
                             instr[11:8] , 1'b0};

        `LUI_opcode,
        `AUIPC_opcode : imm <= { instr[31:12], 12'b0};

        `JAL_opcode : imm <= { {20{instr[31]}},
                                instr[31],
                                instr[19:12],
                                instr[20],
                                instr[30:21],
                                1'b0
                                };

    endcase

end




endmodule