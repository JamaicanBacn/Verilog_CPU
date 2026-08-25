`timescale 1ns/1ns


module RegFile_tb;

integer cases_passed;
integer cases_ran;

integer passed = 1;

wire [31:0]data_out;

reg clk;

reg write_en;
reg read_en;
reg reset;
reg [4:0]read_addr;
reg [4:0]write_addr;
reg [31:0]data_in;
reg enable;

wire [31:0] r0, r1, r2, r3, r4, r5, r6, r7;
wire [31:0] r8, r9, r10, r11, r12, r13, r14, r15;
wire [31:0] r16, r17, r18, r19, r20, r21, r22, r23;
wire [31:0] r24, r25, r26, r27, r28, r29, r30, r31;


RegFile regfile(.clk(clk),
             .write_en(write_en),
             .reset(reset),
             .read_addr(read_addr),
             .write_addr(write_addr),
             .data_in(data_in),
             .enable(enable),
             .data_out(data_out));


assign r0  = regfile.regs[0];
assign r1  = regfile.regs[1];
assign r2  = regfile.regs[2];
assign r3  = regfile.regs[3];
assign r4  = regfile.regs[4];
assign r5  = regfile.regs[5];
assign r6  = regfile.regs[6];
assign r7  = regfile.regs[7];
assign r8  = regfile.regs[8];
assign r9  = regfile.regs[9];
assign r10 = regfile.regs[10];
assign r11 = regfile.regs[11];
assign r12 = regfile.regs[12];
assign r13 = regfile.regs[13];
assign r14 = regfile.regs[14];
assign r15 = regfile.regs[15];
assign r16 = regfile.regs[16];
assign r17 = regfile.regs[17];
assign r18 = regfile.regs[18];
assign r19 = regfile.regs[19];
assign r20 = regfile.regs[20];
assign r21 = regfile.regs[21];
assign r22 = regfile.regs[22];
assign r23 = regfile.regs[23];
assign r24 = regfile.regs[24];
assign r25 = regfile.regs[25];
assign r26 = regfile.regs[26];
assign r27 = regfile.regs[27];
assign r28 = regfile.regs[28];
assign r29 = regfile.regs[29];
assign r30 = regfile.regs[30];
assign r31 = regfile.regs[31];

integer i;

initial begin
clk = 0;
end

always #5 clk = ~clk;

initial begin
    $dumpfile("./TestBenches/RegFile/RegFile.vcd");
    $dumpvars(0 , RegFile_tb );
        

    // INIT

    cases_passed = 0;
    cases_ran = 0;

    reset = 1;
    data_in = 0;
    write_addr = 0;
    read_addr = 0;
    write_en = 0;
    read_en = 0;
    enable = 0;


    #1
    reset = 0;
    #1

    enable = 1;

    // CASE 1 Write to register r31
    $display("Case, Write to registers" , cases_ran);
    for(i = 0; i < 32; i = i + 1) begin 
    
        write_en = 1;
        write_addr = i;
        data_in =  32'hFFFFFFFF;

        @(posedge clk); #1;

        write_en = 0;
        write_addr = 0;
        data_in = 0;

        #1;
    
    end

    // Checking case 
    i = 0;
    write_addr = 0;
    write_en = 0;

    for( i = 0; i < 32; i = i + 1) begin
    
        read_addr = i;

        if( data_out != 32'hFFFFFFFF ) begin
            passed = 0;
        end

    end

    if ( passed ) begin
        $display("Case %d: passed" , cases_ran);
        cases_passed = cases_passed + 1;
    end
    else begin
        $display("Case %d: failed" , cases_ran);
    end

    cases_ran = cases_ran + 1;

    $display("----------RESULTS----------");
    $display("Cases Ran:    %d" , cases_ran);
    $display("Cases Passed: %d" , cases_passed);
    $display("Cases Failed: %d" , cases_ran - cases_passed);
    $finish;
end

endmodule
