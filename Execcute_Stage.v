module Execute_Stage(clk, rst_n, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, ALUControlE, 
    RD1_E, RD2_E, Imm_Ext_E, RD_E, PCE, PCPlus4E, PCSrcE, PCTargetE, RegWriteM, MemWriteM, ResultSrcM, RD_M, PCPlus4M, WriteDataM, ALU_ResultM, ResultW, ForwardA_E, ForwardB_E);

    // Declaration I/Os
    input clk, rst_n, RegWriteE,ALUSrcE,MemWriteE,ResultSrcE,BranchE;
    input [3:0] ALUControlE;  // Thay đổi từ [2:0] thành [3:0] để phù hợp với ALU
    input [31:0] RD1_E, RD2_E, Imm_Ext_E;
    input [4:0] RD_E;
    input [31:0] PCE, PCPlus4E;
    input [31:0] ResultW;
    input [1:0] ForwardA_E, ForwardB_E;

    output PCSrcE, RegWriteM, MemWriteM, ResultSrcM;
    output [4:0] RD_M; 
    output [31:0] PCPlus4M, WriteDataM, ALU_ResultM;
    output [31:0] PCTargetE;

    // Declaration of Interim Wires
    wire [31:0] Src_A, Src_B_interim, Src_B;
    wire [31:0] ResultE;
    wire ZeroE;

    // Declaration of Register
    reg RegWriteE_r, MemWriteE_r, ResultSrcE_r;
    reg [4:0] RD_E_r;
    reg [31:0] PCPlus4E_r, RD2_E_r, ResultE_r;

    // Declaration of Modules
    // 3 by 1 Mux for Source A (sử dụng Mux3 có sẵn)
    Mux3 srca_mux (
                        .in0(RD1_E),
                        .in1(ResultW),
                        .in2(ALU_ResultM),
                        .sel(ForwardA_E),
                        .out(Src_A)
                        );

    // 3 by 1 Mux for Source B (sử dụng Mux3 có sẵn)
    Mux3 srcb_mux (
                        .in0(RD2_E),
                        .in1(ResultW),
                        .in2(ALU_ResultM),
                        .sel(ForwardB_E),
                        .out(Src_B_interim)
                        );
    // ALU Src Mux (sử dụng Mux2 có sẵn)
    Mux2 alu_src_mux (
            .in0(Src_B_interim),
            .in1(Imm_Ext_E),
            .sel(ALUSrcE),
            .out(Src_B)
            );

    // ALU Unit (sử dụng ALU có sẵn với port names đúng)
    ALU alu (
            .a(Src_A),
            .b(Src_B),
            .result(ResultE),
            .alu_control(ALUControlE),
            .zero(ZeroE),
            .Sign()  // Không sử dụng Sign output
            );

    // Branch Target Calculation (thay thế PC_Adder bằng phép cộng đơn giản)
    assign PCTargetE = PCE + Imm_Ext_E;

    // Register Logic
    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            RegWriteE_r <= 1'b0; 
            MemWriteE_r <= 1'b0; 
            ResultSrcE_r <= 1'b0;
            RD_E_r <= 5'h00;
            PCPlus4E_r <= 32'h00000000; 
            RD2_E_r <= 32'h00000000; 
            ResultE_r <= 32'h00000000;
        end
        else begin
            RegWriteE_r <= RegWriteE; 
            MemWriteE_r <= MemWriteE; 
            ResultSrcE_r <= ResultSrcE;
            RD_E_r <= RD_E;
            PCPlus4E_r <= PCPlus4E; 
            RD2_E_r <= Src_B_interim; 
            ResultE_r <= ResultE;
        end
    end

    // Output Assignments
    assign PCSrcE = ZeroE &  BranchE; // support beq only
    assign RegWriteM = RegWriteE_r;
    assign MemWriteM = MemWriteE_r;
    assign ResultSrcM = ResultSrcE_r;
    assign RD_M = RD_E_r;
    assign PCPlus4M = PCPlus4E_r;
    assign WriteDataM = RD2_E_r;
    assign ALU_ResultM = ResultE_r;

endmodule