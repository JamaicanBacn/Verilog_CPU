

#include "VInstructionDecoder.h"
#include "verilated.h"
#include "verilated_fst_c.h"
#include "macros.h"
#include <iostream>
#include <stdint.h>

typedef enum : uint32_t {

    // R-type: rd=x1, rs1=x2, rs2=x3

    ADD  = 0b00000000001100010000000010110011,
    SUB  = 0b01000000001100010000000010110011,
    AND  = 0b00000000001100010111000010110011,
    OR   = 0b00000000001100010110000010110011,
    XOR  = 0b00000000001100010100000010110011,
    SLL  = 0b00000000001100010001000010110011,
    SRL  = 0b00000000001100010101000010110011,
    SRA  = 0b01000000001100010101000010110011,
    SLT  = 0b00000000001100010010000010110011,
    SLTU = 0b00000000001100010011000010110011,

    MUL    = 0b00000010001100010000000010110011,
    MULH   = 0b00000010001100010001000010110011,
    MULHSU = 0b00000010001100010010000010110011,
    MULHU  = 0b00000010001100010011000010110011,

    DIV    = 0b00000010001100010100000010110011,
    DIVU   = 0b00000010001100010101000010110011,
    REM    = 0b00000010001100010110000010110011,
    REMU   = 0b00000010001100010111000010110011,

    // I-type
    // x1 = rd, x2 = rs1, immediate = -1

    ADDI = 0b11111111111100010000000010010011,
    SLLI = 0b00000000000000010001000010010011,
    ANDI = 0b11111111111100010111000010010011,
    SRAI = 0b01000000000000010101000010010011,
    SRLI = 0b00000000000000010101000010010011,
    ORI  = 0b11111111111100010110000010010011,
    XORI = 0b11111111111100010100000010010011,
    SLTI = 0b00000000000000010010000010010011,
    SLTIU= 0b00000000000000010011000010010011,

    // Loads, x1 = rd, x2 = rs1, immediate = -1

    LB  = 0b11111111111100010000000010000011,
    LH  = 0b11111111111100010001000010000011,
    LW  = 0b11111111111100010010000010000011,
    LBU = 0b11111111111100010100000010000011,
    LHU = 0b11111111111100010101000010000011,

    SB = 0b11111110000100010000111110100011,
    SH = 0b11111110000100010001111110100011,
    SW = 0b11111110000100010010111110100011,

    LUI = 0b11111111111111111111000010110111,
    AUIPC = 0b11111111111111111111000010010111

} SampleInstructions;

struct ExpectedOutputs {
    uint8_t rs1;
    uint8_t rs2;
    uint8_t rd;
    uint8_t memread;
    uint8_t memwrite;
    uint8_t regwrite;
    uint8_t branch;
    uint8_t bubble;
    uint8_t alusrc;
    uint8_t aluop;
};

int passed_tests = 0;
int failed_tests = 0;
ExpectedOutputs expected = {0};

void Rtest(VInstructionDecoder* dut, VerilatedFstC* trace, VerilatedContext* context);
void Itest(VInstructionDecoder* dut, VerilatedFstC* trace, VerilatedContext* context);
void LStest( VInstructionDecoder* dut, VerilatedFstC* trace, VerilatedContext* context);
void LUI_AUIPC_test( VInstructionDecoder* dut, VerilatedFstC* trace, VerilatedContext* context);

bool check_outputs(VInstructionDecoder* dut, const ExpectedOutputs& expected);
void run_test(VInstructionDecoder* dut, VerilatedFstC* trace);
void expectedOutputs(uint32_t instr);
void Results();

int main(int argc, char** argv)
{
    VerilatedContext* context = new VerilatedContext;
    context->commandArgs(argc, argv);

    context->traceEverOn(true);

    VInstructionDecoder* dut = new VInstructionDecoder{context};

    VerilatedFstC* trace = new VerilatedFstC;
    dut->trace(trace, 99);
    trace->open("Waveforms/InstructionDecoder.fst");

    Rtest(dut, trace, context);
    Itest(dut, trace, context);
    LStest(dut , trace , context);
    LUI_AUIPC_test(dut, trace, context);

    Results();


    trace->close();

    delete trace;
    delete dut;
    delete context;

    return 0;
}

bool check_outputs(VInstructionDecoder* dut, const ExpectedOutputs& expected)
{
    return dut->rs1 == expected.rs1 && dut->rs2 == expected.rs2 && dut->rd == expected.rd &&
           dut->memread == expected.memread && dut->memwrite == expected.memwrite &&
           dut->regwrite == expected.regwrite && dut->branch == expected.branch &&
           dut->bubble == expected.bubble && dut->alusrc == expected.alusrc &&
           dut->aluop == expected.aluop;
}

void run_test(VInstructionDecoder* dut, VerilatedFstC* trace,
              VerilatedContext* context, uint32_t instruction,
              const char* test_name, const ExpectedOutputs& expected)
{
    dut->instruction_in = instruction;
    dut->eval();
    trace->dump(context->time());

    if (check_outputs(dut, expected)) {
        std::cout << "[PASS] " << test_name << std::endl;
        ++passed_tests;
    } else {
        std::cout << "[FAIL]     " << test_name << " at t=" << context->time()
                  << " (rs1=" << static_cast<int>(dut->rs1)
                  << ", rs2=" << static_cast<int>(dut->rs2)
                  << ", rd=" << static_cast<int>(dut->rd)
                  << ", memread=" << static_cast<int>(dut->memread)
                  << ", memwrite=" << static_cast<int>(dut->memwrite)
                  << ", regwrite=" << static_cast<int>(dut->regwrite)
                  << ", branch=" << static_cast<int>(dut->branch)
                  << ", bubble=" << static_cast<int>(dut->bubble)
                  << ", alusrc=" << static_cast<int>(dut->alusrc)
                  << ", aluop=" << static_cast<int>(dut->aluop) << ")" << std::endl;

        std::cout << "[Expected] " << test_name << " at t=" << context->time()
                  << " (rs1=" << static_cast<int>(expected.rs1)
                  << ", rs2=" << static_cast<int>(expected.rs2)
                  << ", rd=" << static_cast<int>(expected.rd)
                  << ", memread=" << static_cast<int>(expected.memread)
                  << ", memwrite=" << static_cast<int>(expected.memwrite)
                  << ", regwrite=" << static_cast<int>(expected.regwrite)
                  << ", branch=" << static_cast<int>(expected.branch)
                  << ", bubble=" << static_cast<int>(expected.bubble)
                  << ", alusrc=" << static_cast<int>(expected.alusrc)
                  << ", aluop=" << static_cast<int>(expected.aluop) << ")" << std::endl;
        ++failed_tests;
    }

    context->timeInc(1);
}

void expectedOutputs( uint32_t instr)
{
    expected.rs1 = (instr >> 15) & 0x1F;
    expected.rs2 = (instr >> 20) & 0x1F;
    expected.rd  = (instr >> 7) & 0x1F;

    switch( instr & 0x7F ) {

        case R_opcode : 

            expected.memread  = LOW;
            expected.memwrite = LOW;
            expected.regwrite = HIGH;
            expected.branch = LOW;
            expected.bubble = LOW;
            expected.alusrc = 0b00; // for using rs2
            break;
        
        case I_opcode :
            expected.memread = LOW;
            expected.memwrite = LOW;
            expected.regwrite = HIGH;
            expected.branch = LOW;
            expected.bubble = LOW;
            expected.alusrc = 0b01;
            break;
        
        case L_opcode :
            expected.memread = HIGH;
            expected.memwrite = LOW;
            expected.regwrite = HIGH;
            expected.branch = LOW;
            expected.bubble = LOW;
            expected.alusrc = 0b01;
            expected.aluop = ADD_OP;
            break;

        case S_opcode :
            expected.memread = LOW;
            expected.memwrite = HIGH;
            expected.regwrite = LOW;
            expected.branch = LOW;
            expected.bubble = LOW;
            expected.alusrc = 0b01;
            expected.aluop = ADD_OP;
            break;
        
        case B_opcode : 
            expected.memread = LOW;
            expected.memwrite = LOW;
            expected.regwrite = LOW;
            expected.branch = LOW;
            expected.bubble = LOW;
            expected.alusrc = 0b00;
            expected.aluop = NoOP;
            break;
        
        case JAL_opcode : 
            expected.memread = LOW;
            expected.memwrite = LOW;
            expected.regwrite = HIGH;
            expected.branch = HIGH;
            expected.bubble = LOW;
            expected.alusrc = 0b01;
            expected.aluop = NoOP;
            break;
        
        case JALR_opcode : 
            expected.memread = LOW;
            expected.memwrite = HIGH;
            expected.regwrite = LOW;
            expected.branch = HIGH;
            expected.bubble = LOW;
            expected.alusrc = 0b01;
            expected.aluop = NoOP;
            break;
        
        case LUI_opcode :
            expected.memread = LOW;
            expected.memwrite = LOW;
            expected.regwrite = HIGH;
            expected.branch = LOW;
            expected.bubble = LOW;
            expected.alusrc = 0b01;
            expected.aluop = NoOP;
            break;
        
        case AUIPC_opcode :
            expected.memread = LOW;
            expected.memwrite = LOW;
            expected.regwrite = HIGH;
            expected.branch = HIGH;
            expected.bubble = LOW;
            expected.alusrc = 0b01;
            expected.aluop = ADD_OP;
            break;
        
        case ECALL_opcode :
            expected.memread = LOW;
            expected.memwrite = LOW;
            expected.regwrite = LOW;
            expected.branch = LOW;
            expected.bubble = LOW;
            expected.alusrc = 0b01;
            expected.aluop = NoOP;
            break;
        
        default :
            expected.memread = LOW;
            expected.memwrite = LOW;
            expected.regwrite = LOW;
            expected.branch = LOW;
            expected.bubble = LOW;
            expected.alusrc = 0b00;
            expected.aluop = NoOP;
            break;
    }

}

void Rtest( VInstructionDecoder* dut, VerilatedFstC* trace ,
           VerilatedContext* context)
{
    std::cout << "\nR-type Instructions Test\n" << std::endl;

    dut->instruction_in = ADD;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);

    expectedOutputs(dut->instruction_in);
    expected.aluop = ADD_OP;
    run_test(dut, trace, context, ADD, "ADD Instruction Test", expected);
    

    dut->instruction_in = SUB;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = SUB_OP;
    run_test(dut, trace, context, SUB, "SUB Instruction Test", expected);

    dut->instruction_in = MUL;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = MUL_OP;
    run_test(dut, trace, context, MUL, "MUL Instruction Test", expected);

    dut->instruction_in = SLL;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = SLL_OP;
    run_test(dut, trace, context, SLL, "SLL Instruction Test", expected);

    dut->instruction_in = MULH;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = MULH_OP;
    run_test(dut, trace, context, MULH, "MULH Instruction Test", expected);

    dut->instruction_in = SLT;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = SLT_OP;
    run_test(dut, trace, context, SLT, "SLT Instruction Test", expected);

    dut->instruction_in = MULHSU;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = MULHSU_OP;
    run_test(dut, trace, context, MULHSU, "MULHSU Instruction Test", expected);

    dut->instruction_in = SLTU;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = SLTU_OP;
    run_test(dut, trace, context, SLTU, "SLTU Instruction Test", expected);

    dut->instruction_in = MULHU;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = MULHU_OP;
    run_test(dut, trace, context, MULHU, "MULHU Instruction Test", expected);

    dut->instruction_in = XOR;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = XOR_OP;
    run_test(dut, trace, context, XOR, "XOR Instruction Test", expected);

    dut->instruction_in = DIV;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = DIV_OP;
    run_test(dut, trace, context, DIV, "DIV Instruction Test", expected);

    dut->instruction_in = SRL;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = SRL_OP;
    run_test(dut, trace, context, SRL, "SRL Instruction Test", expected);

    dut->instruction_in = SRA;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = SRA_OP;
    run_test(dut, trace, context, SRA, "SRA Instruction Test", expected);

    dut->instruction_in = DIVU;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = DIVU_OP;
    run_test(dut, trace, context, DIVU, "DIVU Instruction Test", expected);

    dut->instruction_in = OR;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = OR_OP;
    run_test(dut, trace, context, OR, "OR Instruction Test", expected);

    dut->instruction_in = REM;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = REM_OP;
    run_test(dut, trace, context, REM, "REM Instruction Test", expected);

    dut->instruction_in = AND;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = AND_OP;
    run_test(dut, trace, context, AND, "AND Instruction Test", expected);

    dut->instruction_in = REMU;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = REMU_OP;
    run_test(dut, trace, context, REMU, "REMU Instruction Test", expected);

}

void Itest( VInstructionDecoder* dut, VerilatedFstC* trace ,
     VerilatedContext* context)
{
    std::cout << "\nI-type Instructions Test\n" << std::endl;

    dut->instruction_in = ADDI;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = ADD_OP;
    run_test(dut, trace, context, ADDI, "ADDI Instruction Test", expected);

    dut->instruction_in = SLLI;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = SLL_OP;
    run_test(dut, trace, context, SLLI, "SLLI Instruction Test", expected);

    dut->instruction_in = SLTI;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = SLT_OP;
    run_test(dut, trace, context, SLTI, "SLTI Instruction Test", expected);

    dut->instruction_in = SLTIU;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = SLTU_OP;
    run_test(dut, trace, context, SLTIU, "SLTIU Instruction Test", expected);

    dut->instruction_in = XORI;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = XOR_OP;
    run_test(dut, trace, context, XORI, "XORI Instruction Test", expected);

    dut->instruction_in = SRLI;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = SRL_OP;
    run_test(dut, trace, context, SRLI, "SRLI Instruction Test", expected);

    dut->instruction_in = SRAI;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = SRA_OP;
    run_test(dut, trace, context, SRAI, "SRAI Instruction Test", expected);

    dut->instruction_in = ORI;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = OR_OP;
    run_test(dut, trace, context, ORI, "ORI Instruction Test", expected);

    dut->instruction_in = ANDI;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = AND_OP;
    run_test(dut, trace, context, ANDI, "ANDI Instruction Test", expected);

}

void LStest( VInstructionDecoder* dut, VerilatedFstC* trace ,
     VerilatedContext* context)
{
    std::cout << "\nLoad/Store Instructions Test\n" << std::endl;

    dut->instruction_in = LB;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = ADD_OP;
    run_test(dut, trace, context, LB, "LB Instruction Test", expected);

    dut->instruction_in = LH;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = ADD_OP;
    run_test(dut, trace, context, LH, "LH Instruction Test", expected);

    dut->instruction_in = LW;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = ADD_OP;
    run_test(dut, trace, context, LW, "LW Instruction Test", expected);

    dut->instruction_in = LBU;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = ADD_OP;
    run_test(dut, trace, context, LBU, "LBU Instruction Test", expected);

    dut->instruction_in = LHU;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = ADD_OP;
    run_test(dut, trace, context, LHU, "LHU Instruction Test", expected);

    dut->instruction_in = SB;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = ADD_OP;
    run_test(dut, trace, context, SB, "SB Instruction Test", expected);

    dut->instruction_in = SH;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = ADD_OP;
    run_test(dut, trace, context, SH, "SH Instruction Test", expected);

    dut->instruction_in = SW;
    dut->eval();
    trace->dump(context->time());
    context->timeInc(CLK_HALF_PERIOD);
    expectedOutputs(dut->instruction_in);
    expected.aluop = ADD_OP;
    run_test(dut, trace, context, SW, "SW Instruction Test", expected);

}


void LUI_AUIPC_test( VInstructionDecoder* dut, VerilatedFstC* trace ,
     VerilatedContext* context)
{
    std::cout << "\nLUI/AUIPC Instructions Test\n" << std::endl;

    dut->instruction_in = LUI;
    dut->eval();
    expectedOutputs(dut->instruction_in);
    expected.aluop = NoOP;
    run_test(dut, trace, context, LUI, "LUI Instruction Test", expected);

    dut->instruction_in = AUIPC;
    dut->eval();
    expectedOutputs(dut->instruction_in);
    expected.aluop = ADD_OP;
    run_test(dut, trace, context, AUIPC, "AUIPC Instruction Test", expected);
}


void Results()
{
    int total_tests = passed_tests + failed_tests;
    std::cout << "Total Passed Tests: " << passed_tests << "/" << total_tests << std::endl;
}