`include "Fetch_Stage.v"
`include "Decode_Stage.v"
`include "Execcute_Stage.v"
`include "Mem_Stage.v"
`include "WriteBack_Stage.v"    
`include "PC.v"
`include "Mux.v"
`include "I_mem.v"
`include "Control_unit_top.v"
`include "Reg_file.v"
`include "Imm_gen.v"
`include "ALU.v"
`include "D_mem.v"
`include "Fowarding.v"
`include "Hazard_detection.v"

module Pipeline_RISCV(clk, rst_n);

    // Declaration of I/O
    input clk, rst_n;

    // Declaration of Interim Wires
    wire PCSrcE, RegWriteW, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, RegWriteM, MemWriteM, ResultSrcM, ResultSrcW;
    wire [3:0] ALUControlE;  // Thay đổi từ [2:0] thành [3:0]
    wire [4:0] RD_E, RD_M, RDW;
    wire [31:0] PCTargetE, InstrD, PCD, PCPlus4D, ResultW, RD1_E, RD2_E, Imm_Ext_E, PCE, PCPlus4E, PCPlus4M, WriteDataM, ALU_ResultM;
    wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW;
    wire [4:0] RS1_E, RS2_E;
    wire [1:0] ForwardBE, ForwardAE;
    
    // Hazard Detection Unit Wires
    wire MemReadE, IF_ID_Write, PCWrite, FlushE;

    // Module Initiation
    // Fetch Stage
    Fetch_Stage Fetch (
                        .clk(clk), 
                        .rst_n(rst_n), 
                        .PCSrcE(PCSrcE), 
                        .PCTargetE(PCTargetE), 
                        .InstrD(InstrD), 
                        .PCD(PCD), 
                        .PCPlus4D(PCPlus4D),
                        .PCWrite(PCWrite),
                        .IF_ID_Write(IF_ID_Write)
                    );

    // Decode Stage
    Decode_Stage Decode (
                        .clk(clk), 
                        .rst(rst_n), 
                        .InstrD(InstrD), 
                        .PCD(PCD), 
                        .PCPlus4D(PCPlus4D), 
                        .RegWriteW(RegWriteW), 
                        .RDW(RDW), 
                        .ResultW(ResultW), 
                        .RegWriteE(RegWriteE), 
                        .ALUSrcE(ALUSrcE), 
                        .MemWriteE(MemWriteE), 
                        .MemReadE(MemReadE),
                        .ResultSrcE(ResultSrcE),
                        .BranchE(BranchE),  
                        .ALUControlE(ALUControlE), 
                        .RD1_E(RD1_E), 
                        .RD2_E(RD2_E), 
                        .Imm_Ext_E(Imm_Ext_E), 
                        .RD_E(RD_E), 
                        .RS1_E(RS1_E),
                        .RS2_E(RS2_E),
                        .PCE(PCE), 
                        .PCPlus4E(PCPlus4E),
                        .Flush(FlushE)
                    );

    // Execute Stage
    Execute_Stage Execute (
                        .clk(clk), 
                        .rst_n(rst_n), 
                        .RegWriteE(RegWriteE), 
                        .ALUSrcE(ALUSrcE), 
                        .MemWriteE(MemWriteE), 
                        .ResultSrcE(ResultSrcE), 
                        .BranchE(BranchE), 
                        .ALUControlE(ALUControlE), 
                        .RD1_E(RD1_E), 
                        .RD2_E(RD2_E), 
                        .Imm_Ext_E(Imm_Ext_E), 
                        .RD_E(RD_E), 
                        .PCE(PCE), 
                        .PCPlus4E(PCPlus4E), 
                        .PCSrcE(PCSrcE), 
                        .PCTargetE(PCTargetE), 
                        .RegWriteM(RegWriteM), 
                        .MemWriteM(MemWriteM), 
                        .ResultSrcM(ResultSrcM), 
                        .RD_M(RD_M), 
                        .PCPlus4M(PCPlus4M), 
                        .WriteDataM(WriteDataM), 
                        .ALU_ResultM(ALU_ResultM),
                        .ResultW(ResultW),
                        .ForwardA_E(ForwardAE),
                        .ForwardB_E(ForwardBE)
                    );
    
    // Memory Stage
    Mem_Stage Memory (
                        .clk(clk), 
                        .rst_n(rst_n), 
                        .RegWriteM(RegWriteM), 
                        .MemWriteM(MemWriteM), 
                        .ResultSrcM(ResultSrcM), 
                        .RD_M(RD_M), 
                        .PCPlus4M(PCPlus4M), 
                        .WriteDataM(WriteDataM), 
                        .ALU_ResultM(ALU_ResultM), 
                        .RegWriteW(RegWriteW), 
                        .ResultSrcW(ResultSrcW), 
                        .RD_W(RDW), 
                        .PCPlus4W(PCPlus4W), 
                        .ALU_ResultW(ALU_ResultW), 
                        .ReadDataW(ReadDataW)
                    );

    // Write Back Stage
    Writeback_Stage WriteBack (
                        .clk(clk), 
                        .rst_n(rst_n), 
                        .ResultSrcW(ResultSrcW), 
                        .PCPlus4W(PCPlus4W), 
                        .ALU_ResultW(ALU_ResultW), 
                        .ReadDataW(ReadDataW), 
                        .ResultW(ResultW)
                    );

    // Hazard Detection Unit
    Hazard_detection_unit hazard_detection_unit (
        .MemReadE(MemReadE),
        .RD_E(RD_E),
        .Rs1_D(InstrD[19:15]),
        .Rs2_D(InstrD[24:20]),
        .PCWrite(PCWrite),
        .IF_ID_Write(IF_ID_Write),
        .FlushE(FlushE)
    );

    // Forwarding Unit
    forwarding_unit Forwarding_block (
                        .rst_n(rst_n), 
                        .RegWriteM(RegWriteM), 
                        .RegWriteW(RegWriteW), 
                        .RD_M(RD_M), 
                        .RD_W(RDW), 
                        .Rs1_E(RS1_E), 
                        .Rs2_E(RS2_E), 
                        .ForwardAE(ForwardAE), 
                        .ForwardBE(ForwardBE)
                        );
endmodule