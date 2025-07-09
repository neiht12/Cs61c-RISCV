module ALU (
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_control,
    output reg [31:0] result
);
    wire [31:0] sum;
    assign sum = a + (alu_control[0] ? ~b : b) + alu_control[0];

    always @(*) begin
        case (alu_control)
            4'b0000, 4'b0001: result = sum; // ADD or SUB
            4'b0010: result = a & b;        // AND
            4'b0011: result = a | b;        // OR
            4'b0100: result = a << b[4:0];  // SLL
            4'b0110: result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; // SLT
            4'b0111: result = ($unsigned(a) < $unsigned(b)) ? 32'b1 : 32'b0; // SLTU
            4'b1000: result = a ^ b;        // XOR
            4'b1010: result = a >> b[4:0];  // SRL
            4'b1011: result = $signed(a) >>> b[4:0]; // SRA
            default: result = 32'b0;
        endcase

    end
endmodule
