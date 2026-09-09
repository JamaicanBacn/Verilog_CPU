

module Basic_ALU(

    input wire clk,
    input wire[4:0] OpCode,
    input wire[31:0] data1,
    input wire[31:0] data2, 

    output wire[31:0] ALU_output

);

reg [31:0] tempout;

initial begin
    tempout = 0;
end

always @(*) begin

    case( OpCode )

        `ADD_OP     : tempout <= $signed(data1) + $signed(data2);       // ADD
        `SUB_OP     : tempout <= $signed(data1) - $signed(data2);       // SUB
        'SLL_OP     : tempout <= data1 << data2[4:0];                   // SLL
        `SLT_OP     : tempout <= $signed(data1) < $signed(data2);       // SLT
        `XOR_OP     : tempout <= data1 ^ data2;                         // XOR
        `SRL_OP     : tempout <= data1 >> data2[4:0];                   // SRL
        `SRA_OP     : tempout <= $signed(data1) >>> data2[4:0];         // SRA
        `OR_OP      : tempout <= data1 | data2;                         // OR
        `AND_OP     : tempout <= data1 & data2;                         // AND
        `LUI_OP     : tempout <= data2 << 12;

        `DIV_OP     : tempout <= $signed(data1) / $signed(data2);
        `DIVU_OP    : tempout <= data1 / data2;

        `MUL_OP     : tempout <= $signed(data1) * $signed(data2);
        `MULH_OP    : tempout <= data1 / data2;
        `MULHSU_OP  : tempout <= data1 / data2;
        `MULHU_OP   : tempout <= data1 / data2;
        

        /* floating point shit here*/
        
        default : tempout <= 0; 
    endcase

end

assign ALU_output = $unsigned(tempout);

endmodule