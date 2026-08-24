`include "./Macros/OpCodes.vh"


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


function [4:0] decode_LUI
endfunction

function [4:0] decode_AUIPC
endfunction

function [4:0] decode_ECALL
endfunction







module instruction_decoder
(
    input wire[31:0] instruction_in,
    
    output reg memread,
    output reg memwrite,
    output reg regwrite,
    output reg branch,
    output reg bubble,
    output reg alusrc,
    output reg aluop

);


//check each opcode and assing values

wire opcode = instruction_in[6:0];


case( opcode ) begin

    `R_opcode : begin
        memread  <= `LOW;
        memwrite <= `LOW;
        regwrite <= `HIGH;
        branch <= `LOW;
        bubble <= `LOW;
        alusrc <= 2'b00; // for using rs2
    end
    `I_opcode : begin
        memread <= `LOW;
        memwrite <= `LOW;
        regwrite <= `HIGH;
        branch <= `LOW;
        bubble <= `LOW;
        alusrc <= 2'b01;    
    end
    `L_opcode : begin
        memread <= `HIGH;
        memwrite <= `LOW;
        regwrite <= `HIGH;
        branch <= `LOW;
        bubble <= `LOW;
        alusrc <= 2'b01;
    end
    `S_opcode : begin
        memread <= `LOW;
        memwrite <= `HIGH;
        regwrite <= `LOW;
        branch <= `LOW;
        bubble <= `LOW;
        alusrc <= 2'b01;
    end
    `B_opcode : begin
        memread <= `LOW;
        memwrite <= `LOW;
        regwrite <= `LOW;
        branch <= `LOW;
        bubble <= `Low;
        alusrc <= 2'b00;
    end
    `JAL_opcode : begin
        memread <= `LOW;
        memwrite <= `LOW;
        regwrite <= `HIGH;
        branch <= `HIGH;
        bubble <= `LOW;
        alusrc <= 2'b01;
    end
    `JALR_opcode : begin
        memread <= `LOW;
        memwrite <= `LOW;
        regwrite <= `HIGH;
        branch <= `HIGH;
        bubble <= `LOW;
        alusrc <= `2'b01;
    end
    `LUI_opcode : begin
        memread <= `LOW;
        memwrite <= `LOW;
        regwrite <= `HIGH;
        branch <= `LOW;
        bubble <= `LOW;
        alusrc <= `2'b01;
    end
    `AUIPC_opcode : begin
        memread <= `LOW;
        memwrite <= `LOW;
        regwrite <= `HIGH;
        branch <= `HIGH;
        bubble <= `LOW;
        alusrc <= `2'b01;
    end
    `ECALL_opcode : begin
        memread <= `LOW;
        memwrite <= `LOW;
        regwrite <= `LOW;
        branch <= `LOW;
        bubble <= `LOW;
        alusrc <= `2'b01;

    end

endcase




endmodule