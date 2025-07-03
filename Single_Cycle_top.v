// Single-Cycle CPU Top-Level Module
module RISCV_Single_Cycle(
    input         clk,
    input         rst_n,
    output [31:0] Instruction_out_top // expose inst to testbench
);

    // Wires
    wire [31:0] pc, next_pc, inst;
    wire [6:0] opcode, funct7;
    wire [2:0] funct3;
    wire [4:0] rs1, rs2, rd;
    wire [31:0] imm;
    wire [31:0] rs1_data, rs2_data;
    wire [31:0] alu_in1, alu_in2, alu_result;
    wire [31:0] mem_data, wb_data;
    wire        PCSel, BrUn, ASel, BSel, MemRW, RegWEn;
    wire [2:0]  ImmSel;
    wire [1:0]  WBSel, ALUop;
    wire [3:0]  ALUControl;
    wire        branch_taken;

    assign Instruction_out_top = inst;

    // === Program Counter ===
    PC pc_reg (
        .clk(clk),
        .rst_n(rst_n),
        .next_pc(next_pc),
        .pc(pc)
    );

    // === Instruction Memory ===
    I_MEM IMEM_inst ( // FIXED
        .addr(pc),
        .inst(inst)
    );

    // === Instruction Fields ===
    assign opcode = inst[6:0];
    assign rd     = inst[11:7];
    assign funct3 = inst[14:12];
    assign rs1    = inst[19:15];
    assign rs2    = inst[24:20];
    assign funct7 = inst[31:25];

    // === Control Unit ===
    Control_Unit_Top control_unit (
        .instr(inst),
        .BrUn(BrUn),
        .ASel(ASel),
        .BSel(BSel),
        .MemRW(MemRW),
        .RegWEn(RegWEn),
        .ImmSel(ImmSel),
        .WBSel(WBSel),
        .PCSel(PCSel),
        .ALUControl(ALUControl)
    );

    // === Immediate Generator ===
    Imm_Gen imm_gen (
        .instr(inst),
        .ImmSel(ImmSel),
        .imm_out(imm)
    );

    // === Register File ===
    RegisterFile reg_file (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(wb_data),
        .RegWEn(RegWEn),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // === MUXes ===
    Mux2 a_mux (
        .in0(rs1_data),
        .in1(pc),
        .sel(ASel),
        .out(alu_in1)
    );

    Mux2 b_mux (
        .in0(rs2_data),
        .in1(imm),
        .sel(BSel),
        .out(alu_in2)
    );

    Mux3 wb_mux (
        .in0(mem_data),
        .in1(alu_result),
        .in2(pc + 4),
        .sel(WBSel),
        .out(wb_data)
    );

    // === ALU ===
    ALU alu (
        .a(alu_in1),
        .b(alu_in2),
        .alu_control(ALUControl),
        .result(alu_result),
        .zero(),
        .Sign()
    );

    // === Data Memory ===
    D_MEM DMEM_inst ( // FIXED
        .clk(clk),
        .MemRW(MemRW),
        .addr(alu_result),
        .write_data(rs2_data),
        .read_data(mem_data)
    );

    // === Branch Comparator ===
    Branch_Comp branch_comp (
        .a(rs1_data),
        .b(rs2_data),
        .funct3(funct3),
        .branch_taken(branch_taken)
    );

    // === Next PC Logic ===
    wire [31:0] pc_plus4 = pc + 4;
    wire [31:0] branch_target = pc + imm;

    Mux2 pc_mux (
        .in0(pc_plus4),
        .in1(branch_target),
        .sel(PCSel & branch_taken),
        .out(next_pc)
    );

endmodule
