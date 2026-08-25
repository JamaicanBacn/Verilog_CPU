

#include "VInstruction_decoder.h"
#include "verilated.h"
#include "verilated_fst_c.h"
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
    SLT  = 0b00000000001100010110000010110011,
    SLTU = 0b00000000001100010111000010110011,

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
    ANDI = 0b11111111111100010111000010010011,
    ORI  = 0b11111111111100010110000010010011,
    XORI = 0b11111111111100010100000010010011,
    SLTI = 0b11111111111100010100000010010011,
    SLTIU= 0b11111111111100010110000010010011,

    // Loads, x1 = rd, x2 = rs1, immediate = -1

    LB  = 0b11111111111100010000000010000011,
    LH  = 0b11111111111100010001000010000011,
    LW  = 0b11111111111100010010000010000011,
    LBU = 0b11111111111100010100000010000011,
    LHU = 0b11111111111100010101000010000011,

    // JALR, x1 = rd, x2 = rs1, immediate = -1

    JALR = 0b11111111111100010000000011100111

} Instruction;

int main(int argc, char** argv)
{
    VerilatedContext* context = new VerilatedContext;
    context->commandArgs(argc, argv);

    context->traceEverOn(true);

    VInstruction_decoder* dut = new VInstruction_decoder{context};

    VerilatedFstC* trace = new VerilatedFstC;
    dut->trace(trace, 99);
    trace->open("./Waveforms/InstructionDecoder.fst");

    dut->instruction_in = ADD;
    dut->eval();

    trace->dump(context->time());

    std::cout << (int)dut->rs2 << std::endl;

    trace->close();

    delete trace;
    delete dut;
    delete context;

    return 0;
}