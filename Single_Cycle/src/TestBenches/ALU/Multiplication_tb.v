`timescale 1ns/1ns




module Multiplication_tb;


reg clk;
reg start;
reg [31:0]Multiplicand;
reg [31:0]Multiplier;
reg _signed;
wire [31:0] Product;
wire busy;

MultiplicationUnit MU( .clk(clk),
                        .start(start),
                        .Multiplicand(Multiplicand),
                        .Multiplier(Multiplier),
                        .Product(Product),
                        ._signed(_signed),
                        .busy(busy));

initial begin
    clk = 0;
end

always #5 clk = ~clk;


initial begin

    $dumpfile("./TestBenches/ALU/Multiplication_Unit.vcd");
    $dumpvars(0 , Multiplication_tb );


    $display("Unsigned case");

    start = 1;
    _signed = 0;
    Multiplicand = 10;
    Multiplier = 7;

    @(negedge busy); #1;

    start = 0;

    #1
    $display("Signed Case");
    start = 0;
    _signed = 1;
    Multiplicand = 1;//32'hFFFFFFFF;
    Multiplier = 1;

    @(negedge busy); #1;



    $finish;

end



endmodule