




module Branch_decision_Unit(

    input wire[31:0] instruction_in,
    input wire[31:0] instruction_addr,
    input wire[31:0] input1,
    input wire[31:0] input2,
    input reg branch_in, // if the instructoin is a branch instruciton

    output reg branch_out, // if the branch condition is true
    output wire[31:0] branch_destination
);

wire[2:0] funct3 = instruction_in[14:12];

wire imm12 = instruction_in[31];
wire imm11 = instruction_in[7];
wire imm_10_to_5 = instruction_in[30:25];
wire imm_4_to_1 = instruction_in[11:7];

wire[11:0] imm_value = { imm12 , imm11 , imm_10_to_5 , imm_4_to_1};
wire[31:0] imm_extended = $signed(imm_extended) << 1;

reg condition;

assign branch_destination = imm_extended + instruction_addr;
branch_out = condition & branch_in;


always(*) begin
    case(funct3) begin
        1'h0 : condition = input1 == input2;
        1'h1 : condition = input1 != input2;
        1'h2 : condition = input1 <  input2;
        1'h3 : condition = input1 <= input2;
        1'h4 : condition = $unsigned(input1) < unsigned(input2)
        1'h5 : condition = $unsigned(input1) >= unsigned(input2);
    endcase
end


endmodule