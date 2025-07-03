module main_decoder(
    input [6:0] opcode,
    output reg [1:0] alu_op,
    output reg BrUn, ASel,BSel,MemRW,
    output reg RegWEn,
    output reg[2:0] ImmSel,
    output reg [1:0] WBSel,
    output reg PCSel
);
    always @(*) begin
        case(opcode)
            7'b0110011: begin // R-type
                alu_op = 2'b10; // ALU operation
                BrUn = 0; ASel = 0; BSel = 0; MemRW = 0;
                RegWEn = 1; ImmSel = 3'b000; WBSel = 2'b01 ; PCSel = 0;
            end
            7'b0000011: begin // Load
                alu_op = 2'b00; // ALU operation for load
                BrUn = 0; ASel = 0; BSel = 1; MemRW = 0;
                RegWEn = 1; ImmSel = 3'b000; WBSel = 2'b00; PCSel = 0;
            end
            7'b0100011: begin // Store
                alu_op = 2'b00; // ALU operation for store
                BrUn = 0; ASel = 0; BSel = 1; MemRW = 1;
                RegWEn = 0; ImmSel = 3'b001; WBSel = 2'b01; PCSel = 0;
            end
            7'b1100011: begin // Branch
                alu_op = 2'b01; // ALU operation for branch
                BrUn = 1; ASel = 0; BSel = 1; MemRW = 0;
                RegWEn = 0; ImmSel = 3'b010; WBSel = 2'b01; PCSel = 1;
            end
            7'b1101111: begin // Jal
                alu_op = 2'b00; // ALU operation for jump and link
                BrUn = 0; ASel = 1; BSel = 0; MemRW = 0;
                RegWEn = 1; ImmSel = 3'b011; WBSel = 2'b10; PCSel = 1;
            end
            7'b0010011: begin // I-type ALU
                alu_op = 2'b10; // ALU operation for I-type
                BrUn = 0; ASel = 0; BSel = 1; MemRW = 0;
                RegWEn = 1; ImmSel = 3'b000; WBSel = 2'b01; PCSel = 0;
            end
            7'b0110111: begin // LUI
                alu_op = 2'b00; // ALU operation for LUI
                BrUn = 0; ASel = 0; BSel = 1; MemRW = 0;
                RegWEn = 1; ImmSel = 3'b011; WBSel = 2'b01; PCSel = 0;
            end
            7'b0010111: begin // AUIPC
                alu_op = 2'b00; // ALU operation for AUIPC
                BrUn = 0; ASel = 1; BSel = 1; MemRW = 0;
                RegWEn = 1; ImmSel = 3'b100; WBSel = 2'b01; PCSel = 0;
            end
            default: begin // Default case
                alu_op = 2'b00;
                BrUn = 0; ASel = 0; BSel = 0; MemRW = 0;
                RegWEn = 0; ImmSel = 3'b000; WBSel = 2'b00; PCSel = 0;
            end
        endcase
    end

endmodule
