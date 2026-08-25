`timescale 1ns/1ns


module Basic_ALU_tb;

reg clk;

reg [4:0]OpCode;
reg [31:0]data1;
reg [31:0]data2;


wire [31:0]ALU_output;

Basic_ALU ALU(  .clk(clk),
                .OpCode(OpCode),
                .data1(data1),
                .data2(data2),
                .ALU_output(ALU_output)
                );

initial begin 
    clk = 0;
end;

always #5 clk = ~clk;


initial begin

    $dumpfile("./TestBenches/ALU/Basic_ALU.vcd");
    $dumpvars(0 , Basic_ALU_tb );


    data1 = 0;
    data2 = 0;
    OpCode = 0;

    #1
    //ADD
    data1 = 32'hFFFFFFFF;
    data2 = 1;

    #1;
    //SUB
    OpCode = 2;
    data1 = 32'hFFFF0000;
    data2 = 32'hFFFF0000;

    #1
    //SLL
    OpCode = 3;
    data1 = 1; 
    data2 = 8;

    #1
    //SLT
    OpCode = 5;
    data1 = 32'hFFFFFFFF;
    data2 = 32'h00000000;
    #1
    //XOR
    OpCode = 6;
    data1 = 32'hF0F0F0F0;
    data2 = 32'h0F0F0F0F;

    #1
    //SRL
    OpCode = 8;
    data1 = 32'h80000000;
    data2 = 4;
    #1
    //SRA
    OpCode = 9;
    data1 = 32'h80000000;
    data2 = 4;

    #1
    //OR
    OpCode = 10;
    data1 = 32'hFFFF0000;
    data2 = 32'h0000FFFF;

    #1
    //AND
    OpCode = 12;
    data1 = 32'hFFFFF000;
    data2 = 32'h0000FFFF;

    #1
    //LUI
    OpCode = 13;
    data2 = 32'h0000BEEF;



    $finish;



end






endmodule