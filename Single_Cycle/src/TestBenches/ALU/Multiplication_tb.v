`timescale 1ns/1ns




module Multiplication_tb;


reg clk;
reg start;
reg reset;
reg [31:0]Multiplicand;
reg [31:0]Multiplier;
reg Mulh;
reg rs1_signed;
wire [31:0] Product;
wire busy;


MultiplicationUnit MU(  .clk(clk),
                        .Mulh(Mulh),
                        .start(start),
                        .reset(reset),
                        .rs1_signed(rs1_signed),
                        .Multiplicand(Multiplicand),
                        .Multiplier(Multiplier),
                        .Product_out(Product),
                        .busy(busy));

initial begin
    clk = 0;
end

always #5 clk = ~clk;


initial begin

    $dumpfile("./TestBenches/ALU/Multiplication_Unit.vcd");
    $dumpvars(0 , Multiplication_tb );

    reset = 1;
    rs1_signed = 1;
    @(posedge clk); #1;

    $display("Unsigned case");

    Mulh = 0;
    reset = 0;
    start = 1;
    Multiplicand = 10;
    Multiplier = 7;

    @(negedge busy); #1;

    start = 0;
    reset =1;

    #1
    $display("Signed Case");
    start = 1;
    reset = 0;
    Multiplicand = 32'hFFFFFFFF;
    Multiplier = 10;

    @(negedge busy); #1;



    $finish;

end



endmodule