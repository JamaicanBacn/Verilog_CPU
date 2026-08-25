



module decoder_top(
    
    input wire clk,
    input wire enable,
    input wire reset,
    input wire write_en,

    input [31:0] instruction_in,

