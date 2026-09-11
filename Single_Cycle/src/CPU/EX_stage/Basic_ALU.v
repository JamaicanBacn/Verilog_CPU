

module Basic_ALU(

    input wire clk,
    input wire[4:0] OpCode,
    input wire[31:0] data1,
    input wire[31:0] data2, 

    output reg[31:0] ALU_output

);

reg [63:0] tempout;
wire HighBits = ;

initial begin
    tempout = 0;
end

always @(*) begin

    case( OpCode )

        `ADD_OP     : { tempout, HighBits}  <= { $signed(data1) + $signed(data2) , 1'b0 } ;  
        `SUB_OP     : { tempout, HighBits}  <= { $signed(data1) - $signed(data2) , 1'b0 } ;  
        'SLL_OP     : { tempout, HighBits}  <= { data1 << data2[4:0] , 1'b0};               
        `SLT_OP     : { tempout, HighBits}  <= { $signed(data1) < $signed(data2) , 1'b0};   
        `XOR_OP     : { tempout, HighBits}  <= { data1 ^ data2 , 1'b0};                      
        `SRL_OP     : { tempout, HighBits}  <= { data1 >> data2[4:0] , 1'b0};                
        `SRA_OP     : { tempout, HighBits}  <= { $signed(data1) >>> data2[4:0] , 1'b0};      
        `OR_OP      : { tempout, HighBits}  <= { data1 | data2 , 1'b0};                      
        `AND_OP     : { tempout, HighBits}  <= { data1 & data2 , 1'b0};                      
        `LUI_OP     : { tempout, HighBits}  <= { data2 << 12  , 1'b0};

        `DIV_OP     : { tempout, HighBits}  <= { $signed(data1) / $signed(data2) , 1'b0};
        `DIVU_OP    : { tempout, HighBits}  <= { data1 / data2 , 1'b0};

        `MUL_OP     : { tempout, HighBits}  <= { $signed(data1) * $signed(data2) , 1'b0};

        `MULH_OP    : { tempout, HighBits} <=  { $signed(data1) * $signed(data2) 1'b1 };
        `MULHSU_OP  : { tempout, HighBits} <=  { $signed(data1) * data2 1'b1 };
        `MULHU_OP   : { tempout, HighBits} <=  { data1 * data2 , 1'b1 };

        `REM_OP     :
        `REMU_OP    :
        
        
        default : {tempout , HighBits} <= 0; 
    endcase
end



assign ALU_output = HighBits ? tempout[63:32] : tempout[31:0];

endmodule