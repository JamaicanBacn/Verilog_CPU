
#ifndef INCLUDE_TB_HPP
#define INCLUDE_TB_HPP

#define LOW 0
#define HIGH 1

#define CLK_PERIOD 10
#define CLK_HALF_PERIOD (CLK_PERIOD/2)

#define R_opcode     0b0110011
#define I_opcode     0b0010011
#define L_opcode     0b0000011
#define S_opcode     0b0100011
#define B_opcode     0b1100011
#define JAL_opcode   0b1101111
#define JALR_opcode  0b1100111
#define LUI_opcode   0b0110111
#define AUIPC_opcode 0b0010111
#define ECALL_opcode 0b1110011


#define INVALID_OP 0
#define NoOP 0

#define ADD_OP 1
#define SUB_OP 2
#define MUL_OP 3

#define SLL_OP 4
#define MULH_OP 5

#define SLT_OP 6
#define MULHSU_OP 7

#define SLTU_OP 8 
#define MULHU_OP 9 

#define XOR_OP 10 
#define DIV_OP 11

#define SRL_OP 12 
#define SRA_OP 13
#define DIVU_OP 14

#define OR_OP 15
#define REM_OP 16

#define AND_OP 17
#define REMU_OP 18


#endif