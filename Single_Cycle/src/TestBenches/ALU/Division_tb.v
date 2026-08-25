
`timescale 1ns/1ns



module DIV_tb();


reg clk;
reg start;
reg reset;
reg[31:0] rs1;
reg[31:0] rs2;
reg _signed;
reg Div;

wire[31:0]result;
wire busy;


DivisionUnit DUT(
    .clk(clk),
    .start(start),
    .reset(reset),
    .rs1(rs1),
    .rs2(rs2),
    ._signed(_signed),
    .Div(Div),
    .result(result),
    .busy(busy)
);


initial begin
    clk = 0;
end

always #5 clk = ~clk;

initial begin
     
    $dumpfile("./TestBenches/ALU/DivisionUnit.vcd");
    $dumpvars(0 , DUT );


    reset = 1;
    start = 0;
    rs1 = ;
    rs2 = 0;
    _signed = 0;
    Div = 0;

    @(posedge clk); #1;

    reset = 0;
    start = 1;
    rs1 = 200;
    rs2 = 2;
    _signed = 0;
    Div = 1;

    @( posedge clk); #1;
    start = 0;
    

    @( negedge busy) #1;

    start = 1;
    rs2 = -2;
    _signed = 1;
    
    @(posedge clk); #1;

    start = 0;

    @(negedge busy); #1 ;

    $finish;

end


endmodule