
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

Multiplication()
{
    iverilog -o ./TestBenches/ALU/Multiplication_tb.vvp ./CPU/Multiplication_Unit.v ./TestBenches/ALU/Multiplication_tb.v
    vvp ./TestBenches/ALU/Multiplication_tb.vvp
    gtkwave ./TestBenches/ALU/Multiplication_Unit.vcd

}

DivisionUnit()
{
    
    iverilog -o ./TestBenches/ALU/DivisionUnit_tb.vvp ./CPU/Division_Unit.v ./TestBenches/ALU/Division_tb.v
    vvp ./TestBenches/ALU/DivisionUnit_tb.vvp
    gtkwave ./TestBenches/ALU/DivisionUnit.vcd

}

ForwardUnit()
{
    iverilog -o ./TestBenches/FWD/FWD_tb.vvp ./CPU/Forwarding_Unit.v ./TestBenches/FWD/FWD_tb.v
    vvp ./TestBenches/FWD/FWD_tb.vvp
    gtkwave ./TestBenches/FWD/FWD.vcd

}

ImmGen()
{
    iverilog -o ./TestBenches/ImmGen/ImmGen.vvp ./CPU/Decode_stage/ImmGen.v ./TestBenches/ImmGen/ImmGen_tb.v
    vvp ./TestBenches/ImmGen/ImmGen.vvp
    gtkwave ./TestBenches/ImmGen/ImmGen.vcd   
}

case $1 in
    regfile)
        RegFile;;
    programcounter)
        ProgramCounter;;
    basic_alu)
        BasicALU;;
    multiplication)
        Multiplication;;
    forward)
        ForwardUnit;;
    division)
        DivisionUnit;;
    immgen)
        ImmGen;;
    *)
esac