
RegFile()
{
    iverilog -o ./TestBenches/RegFile/RegFile_tb.vvp ./CPU/RegFile.v ./TestBenches/RegFile/RegFile_tb.v
    vvp ./TestBenches/RegFile/RegFile_tb.vvp
    gtkwave ./TestBenches/RegFile/RegFile.vcd
}

ProgramCounter()
{
    iverilog -o ./TestBenches/ProgramCounter/ProgramCounter_tb.vvp ./CPU/ProgramCounter.v ./TestBenches/ProgramCounter/ProgramCounter_tb.v
    vvp ./TestBenches/ProgramCounter/ProgramCounter_tb.vvp
    gtkwave ./TestBenches/ProgramCounter/ProgramCounter.vcd
}

BasicALU()
{
    iverilog -o ./TestBenches/ALU/Basic_ALU_tb.vvp ./CPU/Basic_ALU.v ./TestBenches/ALU/Basic_ALU_tb.v
    vvp ./TestBenches/ALU/Basic_ALU_tb.vvp
    gtkwave ./TestBenches/ALU/Basic_ALU.vcd
   
}

MultiplicationUnit()
{
    iverilog -o ./TestBenches/ALU/Multiplication_tb.vvp ./CPU/Multiplication_Unit.v ./TestBenches/ALU/Multiplication_tb.v
    vvp ./TestBenches/ALU/Multiplication_tb.vvp
    gtkwave ./TestBenches/ALU/Multiplication_Unit.vcd

}

case $1 in
    regfile)
        RegFile;;
    programcounter)
        ProgramCounter;;
    basic_alu)
        BasicALU;;
    multiply)
        MultiplicationUnit;;
    *)
esac