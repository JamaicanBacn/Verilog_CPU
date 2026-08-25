`include "./Macros/OpCodes.vh"


function [4:0] decode_rtype;
    input [6:0] funct7;
    input [2:0] funct3;

begin
        case(funct3)
            3'h00 : begin
                case(funct7) 
                //ADD
                    7'h00 : decode_rtype = `ADD_OP;
                //MUL
                    7'h01 :decode_rtype = `MUL_OP;
                //SUB
                    7'h20 : decode_rtype = `SUB_OP;
   
                    default : decode_rtype = `INVALID_OP;

                endcase
            end
            3'h01 : begin
                case( funct7 )
                    //SLL
                    7'h00 : decode_rtype = `SLL_OP; 
                    //MULH
                    7'h01 : decode_rtype = `MULH_OP;

                    default : decode_rtype = `INVALID_OP;

                endcase
            end
            3'h02 : begin
                case( funct7 )
                    //SLT
                    7'h00 :  decode_rtype = `SLT_OP;
                    //MULHSU
                    7'h01 :  decode_rtype = `MULHSU_OP;

                    default : decode_rtype = `INVALID_OP;

                endcase
            end
            3'h03 : begin
                case( funct7 )
                    //SLTU
                    7'h00 :  decode_rtype = `SLTU_OP;
                    //MULHU
                    7'h01:  decode_rtype = `MULHU_OP;

                    default : decode_rtype = `INVALID_OP;
                endcase
            end
            3'h04 : begin
                case( funct7 )
                    // XOR
                    7'h00 : decode_rtype = `XOR_OP;
                    //DIV
                    7'h01 : decode_rtype = `DIV_OP;

                    default : decode_rtype = `INVALID_OP;
                endcase
            end
            3'h05 : begin
                case( funct7 )
                    //SRL
                    7'h00 : decode_rtype = `SRL_OP;
                    //DIVU
                    7'h01 : decode_rtype = `DIVU_OP;
                    //SRA
                    7'h20 : decode_rtype = `SRA_OP;

                    default : decode_rtype = `INVALID_OP;
                endcase
            end
            3'h06 : begin
                case( funct7 )
                    //OR
                    7'h00 : decode_rtype = `OR_OP;
                    //REM
                    7'h01 : decode_rtype = `REM_OP;

                    default : decode_rtype = `INVALID_OP;

                endcase
            end
            3'h07 : begin
                case( funct7 )
                    //AND
                    7'h00 : decode_rtype = `AND_OP;
                    //REMU
                    7'h01 : decode_rtype = `REMU_OP;

                    default : decode_rtype = `INVALID_OP;
                endcase
            end
            default : decode_rtype = `INVALID_OP; 
        endcase
end
endfunction

function [4:0] decode_Itype;
    input [11:5] imm;
    input [2:0 ] funct3;

begin
    case (funct3)
        //ADDI
        3'h00 : decode_Itype = `ADD_OP;

        3'h01: begin
            case( imm[11:5] )
                //SLLI
                7'h00 : decode_Itype = `SLL_OP;

                default : decode_Itype = `INVALID_OP;
            endcase

        end

        //SLTI
        3'h02 : decode_Itype = `SLT_OP;
        //SLTIU
        3'h03 : decode_Itype = `SLTU_OP;
        //XORI
        3'h04: decode_Itype = `XOR_OP;

        3'h05 : begin
            case( imm[11:5] )
                //SRLI
                7'h00: decode_Itype = `SRL_OP;
                //SRAI
                7'h20: decode_Itype = `SRA_OP;

                default : decode_Itype = `INVALID_OP;

            endcase
        end
        // ORI
        3'h06: decode_Itype = `OR_OP;
        // ANDI
        3'h07: decode_Itype = `AND_OP;

        default : decode_Itype = `INVALID_OP;
            
      
    endcase
end
endfunction


module Instruction_decoder
(
    input wire[31:0] instruction_in,

    output wire[4:0] rs1,
    output wire[4:0] rs2,
    output wire[4:0] rd,

    output reg memread,
    output reg memwrite,
    output reg regwrite,
    output reg branch,
    output reg bubble,
    output reg[1:0] alusrc,
    output reg[4:0] aluop

);


//check each opcode and assing values

wire[6:0] opcode = instruction_in[6:0];
wire[6:0] funct7 = instruction_in[31:25];
wire[2:0] funct3 = instruction_in[14:12];

wire[11:5] imm = instruction_in[31:25];

assign rs1 = instruction_in[19:15];
assign rs2 = instruction_in[24:20];
assign rd  = instruction_in[11:7];

always @(*) begin
case( opcode )

        `R_opcode : begin

            memread  = `LOW;
            memwrite = `LOW;
            regwrite = `HIGH;
            branch = `LOW;
            bubble = `LOW;
            alusrc = 2'b00; // for using rs2
            aluop = decode_rtype( funct7 , funct3 );
        end
        `I_opcode : begin
            memread = `LOW;
            memwrite = `LOW;
            regwrite = `HIGH;
            branch = `LOW;
            bubble = `LOW;
            alusrc = 2'b01;
            aluop = decode_Itype( imm , funct3);    
        end
        `L_opcode : begin
            memread = `HIGH;
            memwrite = `LOW;
            regwrite = `HIGH;
            branch = `LOW;
            bubble = `LOW;
            alusrc = 2'b01;
            aluop = `ADD_OP;
        end
        `S_opcode : begin
            memread = `LOW;
            memwrite = `HIGH;
            regwrite = `LOW;
            branch = `LOW;
            bubble = `LOW;
            alusrc = 2'b01;
            aluop = `ADD_OP;
        end
        `B_opcode : begin
            memread = `LOW;
            memwrite = `LOW;
            regwrite = `LOW;
            branch = `LOW;
            bubble = `LOW;
            alusrc = 2'b00;
            aluop = `NoOP;
        end
        `JAL_opcode : begin
            memread = `LOW;
            memwrite = `LOW;
            regwrite = `HIGH;
            branch = `HIGH;
            bubble = `LOW;
            alusrc = 2'b01;
            aluop = `NoOP;
        end
        `JALR_opcode : begin
            memread = `LOW;
            memwrite = `HIGH;
            regwrite = `LOW;
            branch = `HIGH;
            bubble = `LOW;
            alusrc = 2'b01;
            aluop = `NoOP;
        end
        `LUI_opcode : begin
            memread = `LOW;
            memwrite = `LOW;
            regwrite = `HIGH;
            branch = `LOW;
            bubble = `LOW;
            alusrc = 2'b01;
            aluop = `NoOP;
        end
        `AUIPC_opcode : begin
            memread = `LOW;
            memwrite = `LOW;
            regwrite = `HIGH;
            branch = `HIGH;
            bubble = `LOW;
            alusrc = 2'b01;
            aluop = `ADD_OP;
        end
        `ECALL_opcode : begin
            memread = `LOW;
            memwrite = `LOW;
            regwrite = `LOW;
            branch = `LOW;
            bubble = `LOW;
            alusrc = 2'b01;
            aluop = `NoOP;

        end
        default : begin
            memread = `LOW;
            memwrite = `LOW;
            regwrite = `LOW;
            branch = `LOW;
            bubble = `LOW;
            alusrc = 2'b00;
            aluop = `NoOP;
        end
    endcase
end



endmodule
