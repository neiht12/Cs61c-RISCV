module Imm_Gen (
    input  [31:0] instr,
    input  [2:0]  ImmSel,       
    output reg [31:0] imm_out
);

    wire [6:0] opcode = instr[6:0];
    wire [31:0] immI = {{20{instr[31]}}, instr[31:20]}; // I-type
    wire [31:0] immS = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // S-type
    wire [31:0] immB = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // B-type
    wire [31:0] immU = {instr[31:12], 12'b0}; // U-type
    wire [31:0] immJ = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // J-type

    always @(*) begin
        case (ImmSel)
            3'b000: imm_out = immI; // I-type (e.g., lw, addi)
            3'b001: imm_out = immS; // S-type (e.g., sw)
            3'b010: imm_out = immB; // B-type (e.g., beq, bne)
            3'b011: imm_out = immU; // U-type (e.g., LUI)
            3'b100: imm_out = immJ; // J-type (e.g., JAL)
            default: imm_out = 32'b0;
        endcase
    end

endmodule