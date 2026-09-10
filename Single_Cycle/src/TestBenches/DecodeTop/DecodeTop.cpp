#include "VDecodeTop.h"
#include "verilated.h"
#include "verilated_fst_c.h"
#include "include_top.h"
#include <iostream>
#include <stdint.h>

struct ExpectedOutputs {
    uint8_t rs1_addr_out;
    uint8_t rs2_addr_out;
    uint8_t rd_addr_out;
    uint8_t memread_out;
    uint8_t memwrite_out;
    uint8_t regwrite_out;
    uint8_t branch_out;
    uint8_t bubble_out;
    uint8_t alusrc;
    uint8_t aluop;

    uint32_t rs1_data_out;
    uint32_t rs2_data_out;
    uint32_t Imm_out;
};

int passed_tests = 0;
int failed_tests = 0;

uint32_t Regfile[32] = {0};
ExpectedOutputs expected = {0};



bool check_outputs(VDecodeTop* dut, const ExpectedOutputs& expected);
void RegfileTest( VDecodeTop* dut, VerilatedFstC* trace, VerilatedContext* context);

void run_test(VDecodeTop* dut, VerilatedFstC* trace,
              VerilatedContext* context,
              uint32_t instruction,
              const char* test_name,
              const ExpectedOutputs& expected);
              
void expectedOutputs(uint32_t instr);
void Results();

int main(int argc, char** argv)
{
    VerilatedContext* context = new VerilatedContext;
    context->commandArgs(argc, argv);

    context->traceEverOn(true);

    VDecodeTop* dut = new VDecodeTop{context};

    VerilatedFstC* trace = new VerilatedFstC;
    dut->trace(trace, 99);
    trace->open("Waveforms/DecoderTop.fst");

    RegfileTest( dut , trace , context);




    trace->close();

    delete trace;
    delete dut;
    delete context;

    return 0;
}

bool check_outputs(VDecodeTop* dut, const ExpectedOutputs& expected)
{
    return dut->rs1_addr_out == expected.rs1_addr_out &&
           dut->rs2_addr_out == expected.rs2_addr_out &&
           dut->rd_addr_out == expected.rd_addr_out &&
           dut->memread_out == expected.memread_out &&
           dut->memwrite_out == expected.memwrite_out &&
           dut->regwrite_out == expected.regwrite_out &&
           dut->branch_out == expected.branch_out &&
           dut->bubble_out == expected.bubble_out &&
           dut->alusrc == expected.alusrc &&
           dut->aluop == expected.aluop &&
           dut->rs1_data_out == expected.rs1_data_out &&
           dut->rs2_data_out == expected.rs2_data_out &&
           dut->Imm_out == expected.Imm_out;
}

void run_test(VDecodeTop* dut, VerilatedFstC* trace,
              VerilatedContext* context, uint32_t instruction,
              const char* test_name)
{
    if (check_outputs(dut, expected)) {
        std::cout << "[PASS] " << test_name << std::endl;
        ++passed_tests;
    } else {
        std::cout << "[FAIL]     " << test_name << " at t=" << context->time()
                  << " (rs1=" << static_cast<int>(dut->rs1_addr_out)
                  << ", rs2=" << static_cast<int>(dut->rs2_addr_out)
                  << ", rd=" << static_cast<int>(dut->rd_addr_out)
                  << ", memread=" << static_cast<int>(dut->memread_out)
                  << ", memwrite=" << static_cast<int>(dut->memwrite_out)
                  << ", regwrite=" << static_cast<int>(dut->regwrite_out)
                  << ", branch=" << static_cast<int>(dut->branch_out)
                  << ", bubble=" << static_cast<int>(dut->bubble_out)
                  << ", alusrc=" << static_cast<int>(dut->alusrc)
                  << ", aluop=" << static_cast<int>(dut->aluop)
                  << ", rs1_data" << static_cast<int>(dut->rs1_data_out)
                  << ", rs2_data" << static_cast<int>(dut->rs2_data_out)
                  << ", Imm" << ")" << static_cast<int>(dut->Imm_out) << std::endl;

        std::cout << "[Expected] " << test_name << " at t=" << context->time()
                  << " (rs1=" << static_cast<int>(expected.rs1_addr_out)
                  << ", rs2=" << static_cast<int>(expected.rs2_addr_out)
                  << ", rd=" << static_cast<int>(expected.rd_addr_out)
                  << ", memread=" << static_cast<int>(expected.memread_out)
                  << ", memwrite=" << static_cast<int>(expected.memwrite_out)
                  << ", regwrite=" << static_cast<int>(expected.regwrite_out)
                  << ", branch=" << static_cast<int>(expected.branch_out)
                  << ", bubble=" << static_cast<int>(expected.bubble_out)
                  << ", alusrc=" << static_cast<int>(expected.alusrc)
                  << ", aluop=" << static_cast<int>(expected.aluop)  
                  << ", rs1_data" << static_cast<int>(expected.rs1_data_out)
                  << ", rs2_data" << static_cast<int>(expected.rs2_data_out)
                  << ", Imm" << ")" << static_cast<int>(expected.Imm_out) << std::endl;
        ++failed_tests;
    }

    context->timeInc(1);
}

void runRegfile(VDecodeTop* dut, VerilatedFstC* trace,
              VerilatedContext* context, uint32_t instruction,
              const char* test_name)
{
   

}


void expectedOutputs( uint32_t instr)
{
    expected.rs1_addr_out = (instr >> 15) & 0x1F;
    expected.rs2_addr_out = (instr >> 20) & 0x1F;
    expected.rd_addr_out  = (instr >> 7) & 0x1F;

    expected.rs1_data_out = Regfile[expected.rs1_addr_out];
    expected.rs2_data_out = Regfile[expected.rs2_addr_out];

    Instruction instruction = parse_instruction(instr);
    
    uint32_t I_imm = sign_extend_number( (instr >> 20) , 12 );
    uint32_t B_imm = get_branch_offset( instruction );
    uint32_t J_imm = get_jump_offset( instruction );
    uint32_t SL_imm = get_store_offset( instruction );
    uint32_t LUI_imm = sign_extend_number( (instr >> 10) , 20);

    switch( instruction.rtype.opcode ) {

        case R_opcode : 

            expected.memread_out  = LOW;
            expected.memwrite_out = LOW;
            expected.regwrite_out = HIGH;
            expected.branch_out = LOW;
            expected.bubble_out = LOW;
            expected.alusrc = 0b00; // for using rs2
            expected.Imm_out = 0; 
            break;
        
        case I_opcode :
            expected.memread_out = LOW;
            expected.memwrite_out = LOW;
            expected.regwrite_out = HIGH;
            expected.branch_out = LOW;
            expected.bubble_out = LOW;
            expected.alusrc = 0b01;
            expected.Imm_out = I_imm;
            break;
        
        case L_opcode :
            expected.memread_out = HIGH;
            expected.memwrite_out = LOW;
            expected.regwrite_out = HIGH;
            expected.branch_out = LOW;
            expected.bubble_out = LOW;
            expected.alusrc = 0b01;
            expected.aluop = ADD_OP;
            expected.Imm_out = SL_imm;
            break;

        case S_opcode :
            expected.memread_out = LOW;
            expected.memwrite_out = HIGH;
            expected.regwrite_out = LOW;
            expected.branch_out = LOW;
            expected.bubble_out = LOW;
            expected.alusrc = 0b01;
            expected.aluop = ADD_OP;
            expected.Imm_out = SL_imm;
            break;
        
        case B_opcode : 
            expected.memread_out = LOW;
            expected.memwrite_out = LOW;
            expected.regwrite_out = LOW;
            expected.branch_out = LOW;
            expected.bubble_out = LOW;
            expected.alusrc = 0b00;
            expected.aluop = NoOP;
            expected.Imm_out = B_imm;
            break;
        
        case JAL_opcode : 
            expected.memread_out = LOW;
            expected.memwrite_out = LOW;
            expected.regwrite_out = HIGH;
            expected.branch_out = HIGH;
            expected.bubble_out = LOW;
            expected.alusrc = 0b01;
            expected.aluop = NoOP;
            expected.Imm_out = J_imm;
            break;
        
        case JALR_opcode : 
            expected.memread_out = LOW;
            expected.memwrite_out = HIGH;
            expected.regwrite_out = LOW;
            expected.branch_out = HIGH;
            expected.bubble_out = LOW;
            expected.alusrc = 0b01;
            expected.aluop = NoOP;
            expected.Imm_out = I_imm;
            break;
        
        case LUI_opcode :
            expected.memread_out = LOW;
            expected.memwrite_out = LOW;
            expected.regwrite_out = HIGH;
            expected.branch_out = LOW;
            expected.bubble_out = LOW;
            expected.alusrc = 0b01;
            expected.aluop = NoOP;
            expected.Imm_out = LUI_imm; 
            break;
        
        case AUIPC_opcode :
            expected.memread_out = LOW;
            expected.memwrite_out = LOW;
            expected.regwrite_out = HIGH;
            expected.branch_out = HIGH;
            expected.bubble_out = LOW;
            expected.alusrc = 0b01;
            expected.aluop = ADD_OP;
            expected.Imm_out = LUI_imm;
            break;
        
        case ECALL_opcode :
            expected.memread_out = LOW;
            expected.memwrite_out = LOW;
            expected.regwrite_out = LOW;
            expected.branch_out = LOW;
            expected.bubble_out = LOW;
            expected.alusrc = 0b01;
            expected.aluop = NoOP;
            break;
        
        default :
            expected.memread_out = LOW;
            expected.memwrite_out = LOW;
            expected.regwrite_out = LOW;
            expected.branch_out = LOW;
            expected.bubble_out = LOW;
            expected.alusrc = 0b00;
            expected.aluop = NoOP;
            break;
    }

}

void RegfileTest( VDecodeTop* dut, VerilatedFstC* trace, VerilatedContext* context)
{
    std::cout << "\nRegFile Write Test\n" << std::endl;
    
    dut->clk = LOW;
    dut->write_en = HIGH;

    bool passed = true;

    for( int i = 1; i < 32 ; i++)
    {

        dut->writeData = i;
        dut->writeAddr = i;
        dut->eval();
        trace->dump(context->time());
        context->timeInc(CLK_HALF_PERIOD);

        dut->clk = HIGH;
        dut->eval();
        trace->dump(context->time());
        context->timeInc(CLK_HALF_PERIOD);

        Regfile[i] = i;

        dut->clk = LOW;
        dut->eval();
    }
    
    dut->write_en = LOW;

    for( int i = 1; i < 32 ; i++ )
    {
        dut->instruction_in = i << 15;
        dut->eval();
        trace->dump(context->time());
        context->timeInc(NS);

        std::cout << i << std::endl;

        if( Regfile[i] != dut->rs1_data_out)
        {
            passed = false;
        }


    }


    if( passed ) std::cout << "[PASS] " << "Regfile Test" << std::endl ;
    else {  std::cout << "[FAILED] " << "Regfile Test" << std::endl;
}
 


}
