`timescale 1ns/1ns



module ImmGen_tb();



reg[31:0] instruction;
wire[31:0] imm;


ImmGen DUT(
    .instr(instruction),
    .imm(imm)
);



initial begin
$dumpfile("./TestBenches/ImmGen/ImmGen.vcd");
$dumpvars(0 , DUT );


// ADDI x0 x0 -1
instruction = 32'b11111111111100000000000000010011;
#5
// ADDI x0 x0 2047
instruction = 32'b01111111111100000000000000010011;
#5

// LUI x1 128
instruction = 32'b00000000000010000000000010110111;
#5
// LUI x1 4294963200
instruction = 32'b11111111111111111111000010110111;
#5
// AUIPC x2 -1
instruction = 32'b11111111111111111111000100010111;
#5

// SB x1 -1(x2)
instruction = 32'b11111110000100010000111110100011;
#5
// SH x1 -1(x2)
instruction = 32'b11111110000100010001111110100011;
#5
// SW x1 -1(x2)
instruction = 32'b11111110000100010010111110100011;
#5

// LB x1 -1(x2)
instruction = 32'b11111111111100010000000010000011;
#5
// LH x1 -1(x2)
instruction = 32'b11111111111100010001000010000011;
#5
// LW x1 -1(x2)
instruction = 32'b11111111111100010010000010000011;
#5

// BEQ x1 x2 -1
instruction = 32'b11111110001000001000111111100011;
#5

// JAL x1 -1
instruction = 32'b11111111111111111111000011101111;
#5
// JALR x1 -1
instruction = 32'b11111111111100000000000011100111;
#5


$finish;
end

endmodule