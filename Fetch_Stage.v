module Fetch_Stage(
    input clk, rst_n,              // Đổi rst thành rst_n để phù hợp với PC module
    input PCSrcE,
    input [31:0] PCTargetE,
    input PCWrite,                  // để dừng PC khi có stall
    input IF_ID_Write,             // để dừng ghi IF/ID register khi stall
    output [31:0] InstrD,
    output [31:0] PCD, PCPlus4D
);

    // Interim wires
    wire [31:0] PCF, PC_F, PCPlus4F;
    wire [31:0] InstrF;

    // IF/ID pipeline registers
    reg [31:0] InstrF_reg;
    reg [31:0] PCF_reg, PCPlus4F_reg;

    // Mux chọn PC_F: PC + 4 hay branch target
    Mux2 PC_MUX (
        .in0(PCPlus4F),
        .in1(PCTargetE),
        .sel(PCSrcE),
        .out(PC_F)
    ); // PCTargetE means PC + offset

    // PC Module (sử dụng module PC có sẵn, không có PCWrite control)
    PC Program_Counter (
        .clk(clk),
        .rst_n(rst_n),
        .next_pc(PCWrite ? PC_F : PCF),  // Logic PCWrite được thêm vào
        .pc(PCF)
    );

    // Instruction Memory
    I_MEM IMEM (
        .addr(PCF),
        .inst(InstrF)
    );

    // PC + 4 (thay thế PC_Adder bằng phép cộng đơn giản)
    assign PCPlus4F = PCF + 32'h00000004;

    // IF/ID Pipeline Register logic (ghi khi IF_ID_Write = 1)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            InstrF_reg     <= 32'h00000000;
            PCF_reg        <= 32'h00000000;
            PCPlus4F_reg   <= 32'h00000000;
        end else if (IF_ID_Write) begin
            InstrF_reg     <= InstrF;
            PCF_reg        <= PCF;
            PCPlus4F_reg   <= PCPlus4F;
        end
    end

    // Output assign
    assign InstrD     = InstrF_reg;
    assign PCD        = PCF_reg;
    assign PCPlus4D   = PCPlus4F_reg;

endmodule