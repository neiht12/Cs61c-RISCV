module Branch_Comp (
    input  [31:0] a,
    input  [31:0] b,
    input  [2:0]  funct3,
    input         Jump,
    input         BrUn,             // 0 = signed, 1 = unsigned
    output reg    branch_taken
);

    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;

    always @(*) begin
        if (Jump) begin
            branch_taken = 1'b1; // If Jump is asserted, always take the branch
        end else begin
        case (funct3)
            3'b000: branch_taken = (a == b);                        // BEQ
            3'b001: branch_taken = (a != b);                        // BNE
            3'b100: branch_taken = BrUn ? (a < b) : (a_signed < b_signed); // BLT / BLTU
            3'b101: branch_taken = BrUn ? (a >= b) : (a_signed >= b_signed); // BGE / BGEU
            3'b110: branch_taken = (a < b);                         // BLTU (can omit BrUn if separated)
            3'b111: branch_taken = (a >= b);                        // BGEU
            default: branch_taken = 1'b0;
        endcase
    end
    end

endmodule
