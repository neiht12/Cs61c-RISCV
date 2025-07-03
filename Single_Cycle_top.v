module RISCV_Single_Cycle (
    input clk,
    input rst_n,
    output [31:0] PC_out_top,
    output [31:0] Instruction_out_top
);
    // PC
    wire [31:0] pc, next_pc, pc_plus4, pc_branch;
    
    // Instruction
    wire [31:0] inst;
    
    // Control signals
    wire BrUn, ASel, BSel, MemRW, RegWEn, PCSel;
    wire [2:0] ImmSel;
    wire [1:0] WBSel;
    wire [3:0] ALUControl;
    
    // Immediate
    wire [31:0] imm_out;
    
    // Register file
    wire [4:0] rs1 = inst[19:15];
    wire [4:0] rs2 = inst[24:20];
    wire [4:0] rd  = inst[11:7];
    wire [31:0] rs1_data, rs2_data, reg_write_data;
    
    // ALU
    wire [31:0] alu_a, alu_b, alu_result;
    wire alu_zero, alu_sign;
    
    // Data memory
    wire [31:0] dmem_read_data;
    
    // Branch comparator
    wire branch_taken;
    
    // PC + 4
    assign pc_plus4 = pc + 32'd4;
    // PC + imm (for branch/jump)
    assign pc_branch = pc + imm_out;
    
    // Next PC selection
    wire pcsel_branch = branch_taken & PCSel;
    
    // PC
    PC pc_inst(
        .clk(clk),
        .rst_n(rst_n),
        .next_pc(next_pc),
        .pc(pc)
    );
    assign PC_out_top = pc;
    assign Instruction_out_top = inst;
    
    // Instruction memory
    I_MEM IMEM_inst(
        .addr(pc),
        .inst(inst)
    );
    
    // Control unit
    Control_Unit_Top control_unit(
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
    
    // Immediate generator
    Imm_Gen imm_gen(
        .instr(inst),
        .ImmSel(ImmSel),
        .imm_out(imm_out)
    );
    
    // Register file
    RegisterFile Reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .RegWEn(RegWEn),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(reg_write_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
    
    // ALU input A mux
    Mux2 mux_a(
        .in0(rs1_data),
        .in1(pc),
        .sel(ASel),
        .out(alu_a)
    );
    // ALU input B mux
    Mux2 mux_b(
        .in0(rs2_data),
        .in1(imm_out),
        .sel(BSel),
        .out(alu_b)
    );
    // ALU
    ALU alu(
        .a(alu_a),
        .b(alu_b),
        .alu_control(ALUControl),
        .result(alu_result),
        .zero(alu_zero),
        .Sign(alu_sign)
    );
    // Data memory
    D_MEM DMEM_inst(
        .clk(clk),
        .MemRW(MemRW),
        .addr(alu_result),
        .write_data(rs2_data),
        .read_data(dmem_read_data)
    );
    // Branch comparator
    Branch_Comp branch_comp(
        .a(rs1_data),
        .b(rs2_data),
        .funct3(inst[14:12]),
        .BrUn(BrUn),
        .branch_taken(branch_taken)
    );
    // Next PC mux (branch/jump)
    Mux2 mux_pc(
        .in0(pc_plus4),
        .in1(pc_branch),
        .sel(pcsel_branch),
        .out(next_pc)
    );
    // Write-back mux
    Mux3 mux_wb(
        .in0(dmem_read_data),
        .in1(alu_result),
        .in2(pc_plus4),
        .sel(WBSel),
        .out(reg_write_data)
    );
    // Xuất tín hiệu debug nếu cần
    // assign alu_result_out = alu_result;
    // assign pc_out = pc;
    // assign inst_out = inst;

    // Debug: In giá trị các tín hiệu khi ghi vào D_MEM
    always @(posedge clk) begin
        if (MemRW) begin
            $display("DEBUG: time=%0t, PC=%h, rs1_data=%h, imm_out=%h, ALU result=%h, addr=%h, write_data=%h, ASel=%b, BSel=%b, ALUControl=%b",
                $time, pc, rs1_data, imm_out, alu_result, alu_result, rs2_data, ASel, BSel, ALUControl);
        end
    end
endmodule
