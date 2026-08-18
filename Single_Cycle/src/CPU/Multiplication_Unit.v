

// For int values
// will not keep remainder

module MulSignHandler(

    input wire[31:0] rs1,
    input wire rs1_signed,

    output wire[32:0] signed_rs1
);

assign signed_rs1 = rs1_signed ? { rs1[31] , rs1} : { 1'b0 , rs1};


endmodule


module MultiplicationUnit
(   

    input wire clk,
    input wire start,
    input wire Mulh,
    input wire reset,

    input wire rs1_signed,

    input wire[31:0] Multiplicand,
    input wire[31:0] Multiplier,

    output wire[31:0] Product_out,
    output reg busy
);

reg signed [65:0] Product;
reg[5:0]  counter;
wire[1:0] BoothValue = Product[1:0];
wire signed[32:0] extended_rs1;

MulSignHandler MSH( .rs1(Multiplicand),
                    .rs1_signed(rs1_signed),
                    .signed_rs1(extended_rs1)
                    );

always @(posedge clk ) begin

    if( reset ) begin
        counter <= 0;
        Product <= 0;
        busy <= 0;
    end
    else if ( counter == 32 ) begin
        counter <= 0;
        busy <= 0;
    end
    else if( busy ) begin
        
        if( BoothValue == 2'b10) begin
            //subtract
            Product[65:33] = Product[65:33] - extended_rs1;
        end
        else if( BoothValue == 2'b01 ) begin
            Product[65:33] = Product[65:33] + extended_rs1;
        end

        if( signed_rs1 ) begin
            Product = Product >>> 1;
        end
        else begin
            counter <= counter + 1;
        end

    end
    else if(start) begin
            Product[65:33] <= 0;
            Product[32:1] <= Multiplier;
            Product[0] <= 0;
            counter <= 0;
            busy <= 1;
        end


end


// for MULH 
assign Product_out = Mulh  ? Product[64:33] : Product[32:1]; 




endmodule