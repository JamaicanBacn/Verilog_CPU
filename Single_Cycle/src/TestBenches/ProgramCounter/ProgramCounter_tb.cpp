#include "VProgramCounter.h"
#include <iostream>
#include "verilated.h"
#include "verilated_fst_c.h"
#include "../../Macros/include_tb.hpp"
#include <stdint.h>


struct expectedOutputs {
    uint32_t pc_in;
    uint32_t pc_out;
};


expectedOutputs expected = {0};

void counter_test( VerilatedContext* context, VProgramCounter* dut,
                    VerilatedFstC* trace);
void halt_test( VerilatedContext* context, VProgramCounter* dut,
                    VerilatedFstC* trace);
void reset_test( VerilatedContext* context, VProgramCounter* dut,
                    VerilatedFstC* trace);
void write_test( VerilatedContext* context, VProgramCounter* dut,
                    VerilatedFstC* trace);

int main( int argc , char** argv )
{
    VerilatedContext* context = new VerilatedContext;
    context->commandArgs(argc , argv);

    context->traceEverOn(true);

    VProgramCounter* dut = new VProgramCounter{context};
    VerilatedFstC* trace = new VerilatedFstC;
    dut->trace(trace , 99);
    trace->open("Waveforms/ProgramCounter.fst");


    counter_test(context, dut, trace);
    halt_test(context, dut, trace);
    write_test(context, dut, trace);


    delete dut;
    delete trace;
    delete context;

    return 1;
}

void checkOutput( VerilatedContext* context, VProgramCounter* dut, expectedOutputs expected)
{
    if( dut->PC_output == expected.pc_out)
    {
        std::cout << "[PASS] Test at t=" << context->time() << std::endl;
    }
    else
    {
        std::cout << "[FAIL] Test at t=" << context->time() << " (pc_out=" << dut->PC_output
                  << ")" << std::endl;

        std::cout << "[Expected] Test at t=" << context->time() << " (pc_out=" << expected.pc_out
                  << ", pc_in=" << expected.pc_in << ")" << std::endl;
    }
}


void counter_test( VerilatedContext* context, VProgramCounter* dut,
                    VerilatedFstC* trace)
{
        // 20 clock ccycles

        dut->clk = LOW;
        dut->eval();
        trace->dump(context->time());
        context->timeInc(CLK_HALF_PERIOD);

        for( int i = 0; i < 20; i++)
        {
            dut->clk = HIGH;
            dut->eval();
            trace->dump(context->time());
            context->timeInc(CLK_HALF_PERIOD);
            expected.pc_out += 4;

            dut->clk = LOW;
            dut->eval();
            trace->dump(context->time());
            context->timeInc(CLK_HALF_PERIOD);
        }

        checkOutput(context, dut, expected);
}

void halt_test( VerilatedContext* context, VProgramCounter* dut,
                    VerilatedFstC* trace)
{
        // 20 clock ccycles

        dut->halt = HIGH;
        for( int i = 0; i < 20; i++)
        {
            dut->clk = HIGH;
            dut->eval();
            trace->dump(context->time());
            context->timeInc(CLK_HALF_PERIOD);
            
            dut->clk = LOW;
            dut->eval();
            trace->dump(context->time());
            context->timeInc(CLK_HALF_PERIOD);
        }

        checkOutput(context, dut, expected);

        dut->reset = HIGH;
        dut->clk = HIGH;
        dut->eval();
        trace->dump(context->time());

        context->timeInc(CLK_HALF_PERIOD);

        dut->reset = LOW;
        dut->clk = LOW;
        dut->eval();
        trace->dump(context->time());

        context->timeInc(CLK_HALF_PERIOD);

}

void write_test( VerilatedContext* context, VProgramCounter* dut,
                    VerilatedFstC* trace)
{
        // 20 clock ccycles

        expected.pc_out = 0x7FFFFFFF;

        dut->halt = LOW;
        dut->PcWrite = HIGH;
        dut->Src1 = 0x7FFFFFFF;
        dut->clk = HIGH;
        dut->eval();
        trace->dump(context->time());
        context->timeInc(CLK_HALF_PERIOD);

        dut->clk = LOW;
        dut->eval();
        trace->dump(context->time());
        context->timeInc(CLK_HALF_PERIOD);


        checkOutput(context, dut, expected);

        context->timeInc(CLK_HALF_PERIOD);

        dut->reset = HIGH;
        dut->clk = HIGH;
        dut->eval();
        trace->dump(context->time());
        
        context->timeInc(CLK_HALF_PERIOD);

}