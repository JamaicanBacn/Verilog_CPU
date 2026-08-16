
module RegFile(
    input wire clk,
    input wire enable,
    input wire write_en,
    input wire reset,

    input wire [4:0] read_addr,
    input wire [4:0] write_addr,

    input wire [31:0] data_in,
    output wire [31:0] data_out
);


reg [31:0] regs[31:0];
integer i = 0;

always @(posedge clk && enable or posedge reset) begin
    if( reset ) begin
        for( i = 0; i < 32 ; i++) begin
            regs[i] <= 0;
        end
    end
    else if ( write_en ) begin
    
        regs[write_addr] <= data_in;

    end
end


assign  data_out = regs[read_addr];



endmodule
