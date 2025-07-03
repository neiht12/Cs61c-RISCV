`timescale 1ns/1ps

module testbench;

    reg [31:0] a, b;
    reg [2:0] funct3;
    reg       funct7b5;
    reg       opb5;
    reg [1:0] alu_op;
    wire [3:0] alu_control;
    wire [31:0] result;
    wire zero, Sign;

    // Instantiate modules
    alu_decode alu_dec_inst (
        .opb5(opb5),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .alu_op(alu_op),
        .alu_control(alu_control)
    );

    ALU alu_inst (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result),
        .zero(zero),
        .Sign(Sign)
    );

    task print_result;
        input [31:0] a_in, b_in;
        input [2:0] funct3_in;
        input funct7b5_in, opb5_in;
        input [1:0] alu_op_in;
        begin
            a = a_in; b = b_in;
            funct3 = funct3_in;
            funct7b5 = funct7b5_in;
            opb5 = opb5_in;
            alu_op = alu_op_in;
            #5;
            $display("a=%0d, b=%0d, funct3=%b, funct7b5=%b, opb5=%b, alu_op=%b => alu_control=%b, result=%0d, zero=%b, Sign=%b",
                     a, b, funct3, funct7b5, opb5, alu_op, alu_control, result, zero, Sign);
        end
    endtask

    initial begin
        $display("----- Testing ALU & alu_decode -----");

        // R-type ADD
        print_result(10, 20, 3'b000, 1'b0, 1'b1, 2'b10); // ADD
        // R-type SUB
        print_result(20, 10, 3'b000, 1'b1, 1'b1, 2'b10); // SUB
        // R-type AND
        print_result(32'hF0F0F0F0, 32'h0F0F0F0F, 3'b111, 1'b0, 1'b1, 2'b10); // AND
        // R-type OR
        print_result(32'hF0F0F0F0, 32'h0F0F0F0F, 3'b110, 1'b0, 1'b1, 2'b10); // OR
        // R-type SLT (signed)
        print_result(-1, 5, 3'b010, 1'b0, 1'b1, 2'b10); // SLT (expect 1)
        // R-type SLTU (unsigned)
        print_result(32'hFFFFFFFF, 32'h00000001, 3'b011, 1'b0, 1'b1, 2'b10); // SLTU (expect 0)
        // R-type XOR
        print_result(32'hAAAA5555, 32'hFFFF0000, 3'b100, 1'b0, 1'b1, 2'b10); // XOR
        // R-type SLL
        print_result(32'h00000001, 2, 3'b001, 1'b0, 1'b1, 2'b10); // SLL
        // R-type SRL
        print_result(32'h80000000, 2, 3'b101, 1'b0, 1'b1, 2'b10); // SRL
        // R-type SRA
        print_result(32'h80000000, 2, 3'b101, 1'b1, 1'b1, 2'b10); // SRA

        $display("----- End of Tests -----");
        $finish;
    end
endmodule
