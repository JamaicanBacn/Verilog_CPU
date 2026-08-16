`timescale 1ns/1ns

module ProgramCounter_tb;



reg clk;
reg halt;
reg reset;
reg [63:0]Src1;
reg PcWrite;

wire[63:0] PC_output;

integer cases_passed;
integer cases_ran;

integer i=0;
integer caseHalt = 1;
integer caseReset = 1;
integer caseCount = 1;


ProgramCounter PC(.clk(clk) ,
                  .Src1(Src1),
                  .PcWrite(PcWrite),
                  .halt(halt),
                  .reset(reset),
                  .PC_output(PC_output));

initial begin
     clk = 0;
end

always #5 clk = ~clk;


initial begin
    $dumpfile("./TestBenches/ProgramCounter/ProgramCounter.vcd");
    $dumpvars(0 , ProgramCounter_tb );



    // Init

    cases_passed = 0;
    cases_ran = 0;

    Src1 = 0;

    PcWrite = 0;
    reset = 1;
    halt = 0;



    // test 1 program counter iteration
    #1;
    reset = 0;

    $display("Beginning counting case");
    @(posedge clk); #1;
    for( i = 1; i < 10; i = i + 1) begin
    
        if( PC_output != i * 4) begin
        
            caseCount = 0;
        end
        @(posedge clk); #1;
    end

    cases_ran = cases_ran + 1;

    #1

    // Test 2 rest Case
    $display("Beginning reset case");

    reset = 1;

    #1

    if( PC_output != 0 ) begin
    
        caseReset = 0;
    
    end 

    reset = 0;
    cases_ran = cases_ran + 1;

    #1;
    // Test 3 Halt case

    halt = 1;
    i = 0;
    $display("Beginning halt case");
    @(posedge clk); #1;
    for( i = 0; i < 5; i = i + 1) begin
        
        if( PC_output != 0) begin
            caseHalt = 0;
        end
        @(posedge clk); #1;
    end

    cases_ran = cases_ran + 1;
    
    $display("----------RESULTS----------");
    
    if ( caseCount) begin
        $display("Count case passed");
        cases_passed = cases_passed + 1;
    end
    else begin
        $display("Count case failed");
    end

    if ( caseHalt ) begin
        $display("Halt case passed");
        cases_passed = cases_passed + 1;
    end
    else begin
        $display("Halt case failed" , cases_ran);
    end

    if ( caseReset ) begin
        $display("Reset Case passed");
        cases_passed = cases_passed + 1;
    end
    else begin
        $display("Reset Case failed");
    end

    $finish;
end

endmodule