`timescale 1ns/1ns
`include "RegFile.v"


module basic_tb;

wire [5:0]out;
reg clk;
reg btn1;
reg btn2;


CPU uut(.led(out) ,
        .clk(clk),
        .btn1(btn1),
        .btn2(btn2));

initial begin
    $dumpfile("basic_tb.vcd");
    $dumpvars(0 , basic_tb );

    clk = 1;
    #20;

    btn1 = 1;
    #20;

    $display("Test Complete");

end


endmodule
