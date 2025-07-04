module Decode_Stage(
    clk, rst, Flush,
    InstrD, PCD, PCPlus4D,
    RegWriteW, RDW, ResultW,
    RegWriteE, ALUSrcE, MemWriteE, MemReadE, ResultSrcE,
    BranchE, ALUControlE,
    RD1_E, RD2_E, Imm_Ext_E,
    RD_E, RS1_E, RS2_E,
    PCE, PCPlus4E
);

    // I/O Declaration
    input clk, rst, Flush, RegWriteW;
    input [31:0] InstrD, PCD, PCPlus4D;
    input [4:0] RDW;
    input [31:0] ResultW;

    output RegWriteE, ALUSrcE, MemWriteE, MemReadE, ResultSrcE, BranchE;
    output [3:0] ALUControlE;  // Thay đổi từ [2:0] thành [3:0]
    output [31:0] RD1_E, RD2_E, Imm_Ext_E;
    output [4:0] RD_E, RS1_E, RS2_E;
    output [31:0] PCE, PCPlus4E;

    // Internal Wires
    wire RegWriteD, ALUSrcD, MemWriteD, MemReadD, ResultSrcD, BranchD;
    wire [2:0] ImmSrcD;  // Thay đổi từ [1:0] thành [2:0] để phù hợp với ImmSel
    wire [3:0] ALUControlD;  // Thay đổi từ [2:0] thành [3:0] để phù hợp với ALUControl
    wire [31:0] RD1_D, RD2_D, Imm_Ext_D;

    // Pipeline Registers
    reg RegWriteD_r, ALUSrcD_r, MemWriteD_r, MemReadD_r, ResultSrcD_r, BranchD_r;
    reg [3:0] ALUControlD_r;  // Thay đổi từ [2:0] thành [3:0]
    reg [31:0] RD1_D_r, RD2_D_r, Imm_Ext_D_r;
    reg [4:0] RD_D_r, RS1_D_r, RS2_D_r;
    reg [31:0] PCD_r, PCPlus4D_r;

    // Control Unit
    Control_Unit_Top control (
        .instr(InstrD),
        .BrUn(),  // không sử dụng trong pipeline này
        .ASel(),  // không sử dụng trong pipeline này  
        .BSel(ALUSrcD),
        .MemRW(MemWriteD),
        .RegWEn(RegWriteD),
        .ImmSel(ImmSrcD),
        .WBSel(),  // sẽ map với ResultSrcD
        .PCSel(BranchD),  // map branch signal
        .ALUControl(ALUControlD)
    );
    
    // Logic bổ sung cho các tín hiệu không có trong Control_Unit_Top
    assign MemReadD = ~MemWriteD && (InstrD[6:0] == 7'b0000011);  // Load instructions
    assign ResultSrcD = (InstrD[6:0] == 7'b0000011);  // 1 for load, 0 for others

    // Register File
    RegisterFile rf (
        .clk(clk),
        .rst_n(rst),
        .RegWEn(RegWriteW),
        .rs1(InstrD[19:15]),
        .rs2(InstrD[24:20]),
        .rd(RDW),
        .write_data(ResultW),
        .rs1_data(RD1_D),
        .rs2_data(RD2_D)
    );

    // Immediate Extend
    Imm_Gen extension (
        .instr(InstrD),
        .ImmSel(ImmSrcD),
        .imm_out(Imm_Ext_D)
    );

    // ID/EX Register Logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            RegWriteD_r    <= 1'b0;
            ALUSrcD_r      <= 1'b0;
            MemWriteD_r    <= 1'b0;
            MemReadD_r     <= 1'b0;
            ResultSrcD_r   <= 1'b0;
            BranchD_r      <= 1'b0;
            ALUControlD_r  <= 4'b0000;  // Thay đổi từ 3'b000 thành 4'b0000
            RD1_D_r        <= 32'h00000000;
            RD2_D_r        <= 32'h00000000;
            Imm_Ext_D_r    <= 32'h00000000;
            RD_D_r         <= 5'b00000;
            RS1_D_r        <= 5'b00000;
            RS2_D_r        <= 5'b00000;
            PCD_r          <= 32'h00000000;
            PCPlus4D_r     <= 32'h00000000;
        end else if (Flush) begin
            RegWriteD_r    <= 1'b0;
            ALUSrcD_r      <= 1'b0;
            MemWriteD_r    <= 1'b0;
            MemReadD_r     <= 1'b0;
            ResultSrcD_r   <= 1'b0;
            BranchD_r      <= 1'b0;
            ALUControlD_r  <= 4'b0000;  // Thay đổi từ 3'b000 thành 4'b0000
            // dữ liệu giữ nguyên
        end else begin
            RegWriteD_r    <= RegWriteD;
            ALUSrcD_r      <= ALUSrcD;
            MemWriteD_r    <= MemWriteD;
            MemReadD_r     <= MemReadD;
            ResultSrcD_r   <= ResultSrcD;
            BranchD_r      <= BranchD;
            ALUControlD_r  <= ALUControlD;

            RD1_D_r        <= RD1_D;
            RD2_D_r        <= RD2_D;
            Imm_Ext_D_r    <= Imm_Ext_D;
            RD_D_r         <= InstrD[11:7];
            RS1_D_r        <= InstrD[19:15];
            RS2_D_r        <= InstrD[24:20];
            PCD_r          <= PCD;
            PCPlus4D_r     <= PCPlus4D;
        end
    end

    // Output Assignments
    assign RegWriteE   = RegWriteD_r;
    assign ALUSrcE     = ALUSrcD_r;
    assign MemWriteE   = MemWriteD_r;
    assign MemReadE    = MemReadD_r;
    assign ResultSrcE  = ResultSrcD_r;
    assign BranchE     = BranchD_r;
    assign ALUControlE = ALUControlD_r;

    assign RD1_E       = RD1_D_r;
    assign RD2_E       = RD2_D_r;
    assign Imm_Ext_E   = Imm_Ext_D_r;
    assign RD_E        = RD_D_r;
    assign RS1_E       = RS1_D_r;
    assign RS2_E       = RS2_D_r;
    assign PCE         = PCD_r;
    assign PCPlus4E    = PCPlus4D_r;

endmodule