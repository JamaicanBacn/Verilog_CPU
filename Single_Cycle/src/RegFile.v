module CPU(
    output reg[5:0] led,
    input wire clk,
    input wire btn1,
    input wire btn2
);


wire [31:0]data_in;
wire [31:0]data_out;
wire [4:0]write_addr;
wire [4:0]read_addr;

assign _3v3_ = 1;

_RegFile regfile(
    .clk(clk),
    .write_en(btn1),
    .reset(btn2),
    .write_addr(write_addr),
    .read_addr(read_addr),
    .data_in(data_in),
    .data_out(data_out)
);

endmodule



module _RegFile(
    input wire clk,
    input wire write_en,
    input wire reset,

    input wire [4:0] read_addr,
    input wire [4:0] write_addr,

    input wire [31:0] data_in,
    output wire [31:0] data_out
);

reg [31:0] regs[31:0];
integer i = 0;

always @(posedge clk ) begin
    if( reset ) begin

        for (i = 0; i < 32; i = i + 1) regs[i] <= 32'b0;
    end
    else if ( write_en ) begin
    
        regs[write_addr] <= data_in;

    end
end

assign  data_out = regs[read_addr];

endmodule