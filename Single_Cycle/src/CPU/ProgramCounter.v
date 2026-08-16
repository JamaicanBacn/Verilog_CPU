

module ProgramCounter(

    input wire clk,
    input wire[63:0] Src1,

    input wire PcWrite,
    input wire halt,
    input wire reset,

    output wire[63:0] PC_output

);


wire [63:0]Src0;
reg  [63:0]CurrentProgramCounter;

assign Src0 = CurrentProgramCounter + 4;



// PC needs to be changed
always @(posedge clk or posedge reset) begin
    
    if( reset ) begin
       CurrentProgramCounter <= 0; 
    end
    else if( PcWrite == 1 ) begin

        CurrentProgramCounter <= Src1;
    end
    else if( halt == 1) begin
        CurrentProgramCounter <= CurrentProgramCounter;
    end
    else begin
    
        CurrentProgramCounter <= Src0;

    end

end

assign PC_output = CurrentProgramCounter;

endmodule