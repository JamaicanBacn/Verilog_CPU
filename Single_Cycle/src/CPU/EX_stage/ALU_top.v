
function [4:0] decode_rtype;
    input [6:0] funct7;
    input [2:0] funct3;


    begin
        case(funct3)
            3'h00 : begin
                case(funct7) 
                //ADD
                    7'h00 : decode_rtype = ADD_OP;
                //MUL
                    7'h01 :decode_rtype = MUL_OP;
                //SUB
                    7'h20 : decode_rtype = SUB_OP;
   
                    default : decode_rtype = invalid;

                endcase
            3'h01 : begin
                case( funct7 ) begin
                    //SLL
                    7'h00 : decode_rtype = SLL_OP; 
                    //MULH
                    7'h01 : decode_rtype = MULH_OP;

                    default : decode_rtype = INVALID_OP;

                endcase
            end
            3'h02 : begin
                case( funct7 ) begin
                    //SLT
                    7'h00 :  decode_rtype = SLT_OP;
                    //MULHSU
                    7'h01 :  decode_rtype = MULHSU_OP;

                    default : decode_rtype = INVALID_OP;

                endcase
            end
            3'h03 : begin
                case( funct7 ) begin
                    //MULHU
                    7'h01:  decode_rtype = MULHU_OP;

                    default : decode_rtype = INVALID_OP;
                endcase
            end
            3'h04 : begin
                case( funct7 ) begin
                    // XOR
                    7'h00 : decode_rtype = XOR_OP;
                    //DIV
                    7'h01 : decode_rtype = DIV_OP;

                    default : decode_rtype = INVALID_OP
                endcase
            end
            3'h05 : begin
                case( funct7 ) begin
                    //SRL
                    7'h00 : decode_rtype = SRL_OP;
                    //DIVU
                    7'h01 : decode_rtype = DIVU_OP;
                    //SRA
                    7'h20 : decode_rtype = SRA_OP;

                    default : decode_rtype = INVALID_OP;
                endcase
            end
            3'h06 : begin
                case( funct7 ) begin
                    //OR
                    7'h00 : decode_rtype = OR_OP;
                    //REM
                    7'h01 : decode_rtype = REM_OP;

                    default : decode_rtype = INVALID_OP;

                endcase
            end
            3'h07 : begin
                case( funct7 ) begin
                    //AND
                    7'h00 : decode_rtype = AND_OP;
                    //REMU
                    7'h01 : decode_rtype = REMU_OP;

                    default : decode_rtype = INVALID_OP;
                endcase
            end
            default : decode_rtype = INVALID_OP; 
            end
        endcase
    
    end
endfunction

function [4:0] decode_Itype
    input [11:0] imm;
    input [2:0 ] funct3;

    wire imm_0_to_4 = imm[4:0];
    wire imm_5_to_11 = imm[11:5];


    case (funct3) begin
        //ADDI
        3'h00 : decode_Itype = ADD_OP;

        3'h01: begin
            case( imm_5_to_11 ) begin
                //SLLI
                7'h00 : decode_Itype = SLL_OP;

                default : decode_Itype = INVALID_OP;
            endcase

        end

        //SLTI
        3'h02 : decode_Itype = SLT_OP;
        //XORI
        3'h04: decode_Itype = XOR_OP;

        3'h05 : begin
            case( imm_5_to_11 ) begin
                //SRLI
                7'h00: decode_Itype = SRL_OP;
                //SRAI
                7'h20: decode_Itype = SRA_OP;

                default : decode_Itype = INVALID_OP;

            endcase
        end
        // ORI
        3'h06: decode_Itype = OR_OP;
        // ANDI
        3'h07: decode_Itype = AND_OP;

        default : decode_Itype = INVALID_OP;
            
      
    endcase
endfunction

function []

// branch doesnt use the alu seperate logic


module ALU_control
(
    input wire[31:0] instruction_in,

    output reg[4:0] ALU_OP
);

wire[6:0] funct7 = instruction_in[6:0];
wire[3:0] funct3 = instruction_in[14:12];
wire[6:0] opcode = instruction_in[6:0];


always(*) begin

    case( opcode ) begin
    
    `R_opcode : ALU_OP =   
    `I_opcode :
    `L_opcode :
    `S_opcode;
    `B_opcode;
    `JAL_opcode;
    `JALR_opcode;
    `LUI_opcode;
    `AUIPC_opcode;

    endcase



end

endmodule

module Imm_gen
(

);

endmodule


module ALU_top
(
    input wire clk,
    input wire[6:0] opcode,

    input wire[31:0] rs1,
    input wire[31:0] rs2,

    input wire[20:0] imm,

    input wire[1:0] fwdMux1
    input wire[1:0] fwdMux2,

    input wire[31:0] rs1_fwd_data,
    input wire[31:0] rs2_fwd_data,

    output wire[31:0] ALU_output,
    output wire zero,

);

wire Multiply;
wire Divide;






endmodule