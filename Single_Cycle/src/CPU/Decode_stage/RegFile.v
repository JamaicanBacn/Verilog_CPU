
module RegFile(
    input wire clk,
    input wire enable,
    input wire write_en,
    input wire reset,

    input wire [4:0] rs1_addr,
    input wire [4:0] rs2_addr,
    
    input wire [4:0] write_addr,

    input wire [31:0] data_in,
    output wire [31:0] rs1_out,
    output wire [31:0] rs2_out,
);


reg [31:0] regs[31:0];
integer i;

initial begin
    i = 0;
    regs = 0;
end

always @(posedge clk && enable) begin
    if( reset ) begin
        regs[0] <= 32'b0;
    end
    else if ( write_en ) begin
    
        regs[write_addr] <= data_in;

    end
end


assign  rs1_out = regs[rs1_addr];
assign  rs2_out = regs[rs2_addr];

endmodule
