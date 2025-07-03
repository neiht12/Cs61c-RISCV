module Control_Unit_Top(
    input  [31:0] instr,
    output        BrUn, ASel, BSel, MemRW,
    output        RegWEn,
    output [2:0]  ImmSel,
    output [1:0]  WBSel,
    output        PCSel,
    output [3:0]  ALUControl
);

    // --- Tách trường từ instruction ---
    wire [6:0] opcode    = instr[6:0];
    wire [2:0] funct3    = instr[14:12];
    wire [6:0] funct7    = instr[31:25];
    wire       funct7b5  = instr[30]; // bit 5 of funct7
    wire       opb5      = instr[5];  // bit 5 of opcode

    wire [1:0] ALUop;

    // --- Main decoder ---
    main_decoder main_dec_inst (
        .opcode(opcode),
        .alu_op(ALUop),
        .BrUn(BrUn),
        .ASel(ASel),
        .BSel(BSel),
        .MemRW(MemRW),
        .RegWEn(RegWEn),
        .ImmSel(ImmSel),
        .WBSel(WBSel),
        .PCSel(PCSel)
    );

    // --- ALU decoder ---
    alu_decoder alu_dec_inst (
        .opb5(opb5),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .alu_op(ALUop),
        .alu_control(ALUControl)
    );

endmodule