

module Basic_ALU(

    input wire clk,
    input wire[4:0] OpCode,
    input wire[31:0] data1,
    input wire[31:0] data2, 

    output wire[31:0] ALU_output

);

reg [31:0] tempout;

always @(*) begin

    case( OpCode )

        0  : tempout <= $signed(data1) + $signed(data2);       // ADD
        2  : tempout <= $signed(data1) - $signed(data2);       // SUB
        3  : tempout <= data1 << data2[4:0];                   // SLL
        5  : tempout <= $signed(data1) < $signed(data2);       // SLT
        6  : tempout <= data1 ^ data2;                         // XOR
        8  : tempout <= data1 >> data2[4:0];                   // SRL
        9  : tempout <= $signed(data1) >>> data2[4:0];         // SRA
        10 : tempout <= data1 | data2;                         // OR
        12 : tempout <= data1 & data2;                         // AND
        13 : tempout <= data2 << 12;                           // LUI
        default : tempout <= 0; 
    endcase

end

assign ALU_output = $unsigned(tempout);

endmodule