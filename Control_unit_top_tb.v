`timescale 1ns / 1ps

module tb_control_unit_and_alu;

    // Inputs
    reg [31:0] instr;
    reg [31:0] a, b;

    // Wires từ control unit
    wire [3:0] ALUControl;
    wire [1:0] WBSel;
    wire [2:0] ImmSel;
    wire BrUn, ASel, BSel, MemRW, RegWEn, PCSel;

    // Outputs từ ALU
    wire [31:0] result;
    wire zero, Sign;

    // Instantiate control unit
    Control_Unit_Top control_unit (
        .instr(instr),
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

    // Instantiate ALU
    ALU alu_inst (
        .a(a),
        .b(b),
        .alu_control(ALUControl),
        .result(result),
        .zero(zero),
        .Sign(Sign)
    );

    // Task to display result
    task print_result(input [31:0] expected);
        begin
            #1;
            $display("Instr = %b", instr);
            $display("a = %0d, b = %0d", a, b);
            $display("ALUControl = %b", ALUControl);
            $display("Result = %0d (Expect %0d), Zero = %b, Sign = %b", result, expected, zero, Sign);
            $display("--------------------------------------------");
        end
    endtask

    initial begin
        $display("=== TEST CONTROL UNIT + ALU ===");

        // ----------- Test ADD ----------
        instr = 32'b0000000_00011_00010_000_00001_0110011; // add x1,x2,x3
        a = 10; b = 20;
        #10; print_result(30);

        // ----------- Test SUB ----------
        instr = 32'b0100000_00010_00011_000_00001_0110011; // sub x1,x3,x2
        a = 20; b = 10;
        #10; print_result(10);

        // ----------- Test AND ----------
        instr = 32'b0000000_11110_11100_111_00001_0110011; // and x1,x28,x30
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F;
        #10; print_result(32'h00000000);

        // ----------- Test OR ----------
        instr = 32'b0000000_00011_00010_110_00001_0110011; // or x1,x2,x3
        a = 32'hF0000000; b = 32'h0F000000;
        #10; print_result(32'hFF000000);

        // ----------- Test SLT ----------
        instr = 32'b0000000_00011_00010_010_00001_0110011; // slt x1,x2,x3
        a = -1; b = 5;
        #10; print_result(1);

        // ----------- Test SLTU ----------
        instr = 32'b0000000_00011_00010_011_00001_0110011; // sltu x1,x2,x3
        a = 32'hFFFFFFFF; b = 1;
        #10; print_result(0);

        // ----------- Test XOR ----------
        instr = 32'b0000000_00011_00010_100_00001_0110011; // xor x1,x2,x3
        a = 32'hAAAAAAAA; b = 32'h55555555;
        #10; print_result(32'hFFFFFFFF);

        // ----------- Test SRL ----------
        instr = 32'b0000000_00010_00011_101_00001_0110011; // srl x1,x3,x2
        a = 32'h80000000; b = 2;
        #10; print_result(32'h20000000);

        // ----------- Test SRA ----------
        instr = 32'b0100000_00010_00011_101_00001_0110011; // sra x1,x3,x2
        a = 32'h80000000; b = 2;
        #10; print_result(32'hE0000000);

        $finish;
    end

endmodule
