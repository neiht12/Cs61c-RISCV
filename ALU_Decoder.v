module alu_decoder (
    input wire        opb5,       // bit 5 of opcode
    input wire [2:0]  funct3,
    input wire        funct7b5,   // bit 5 of funct7
    input wire [1:0]  alu_op,
    output reg [3:0]  alu_control
);

    wire RtypeSub;
    assign RtypeSub = funct7b5 & opb5; // dùng để phát hiện SUB

    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 4'b0000; // Load/Store: ADD
            2'b01: alu_control = 4'b0001; // Branch: SUB
            default: begin
                case (funct3)
                    3'b000: alu_control = RtypeSub ? 4'b0001 : 4'b0000; // SUB or ADD
                    3'b001: alu_control = 4'b0100; // SLL
                    3'b010: alu_control = 4'b0110; // SLT
                    3'b011: alu_control = 4'b0111; // SLTU
                    3'b100: alu_control = 4'b1000; // XOR
                    3'b101: alu_control = funct7b5 ? 4'b1011 : 4'b1010; // SRA : SRL
                    3'b110: alu_control = 4'b0011; // OR
                    3'b111: alu_control = 4'b0010; // AND
                    default: alu_control = 4'b1111; // invalid
                endcase
            end
        endcase
    end

endmodule
