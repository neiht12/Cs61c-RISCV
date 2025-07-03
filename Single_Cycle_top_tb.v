// Testbench for SingleCycleTop
`timescale 1ns/1ps

module tb_SingleCycleTop;
    reg clk;
    reg rst_n;

    // Instantiate the CPU
    SingleCycleTop uut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Reset and initial instruction loading
    initial begin
        rst_n = 0;
        #15;
        rst_n = 1;
    end

    // Preload instruction memory and data memory
    initial begin
        // Example instructions: place them in IMEM memory
        // inst[0] = add x1, x2, x3 => 0000000_00011_00010_000_00001_0110011
        uut.imem.memory[0] = 32'b00000000001100010000000010110011;

        // inst[1] = sub x4, x5, x6 => 0100000_00110_00101_000_00100_0110011
        uut.imem.memory[1] = 32'b01000000011000101000000100110011;

        // Add more instructions if needed

        // Preload register values (e.g., x2 = 10, x3 = 20, etc.)
        uut.reg_file.registers[2] = 32'd10; // x2
        uut.reg_file.registers[3] = 32'd20; // x3
        uut.reg_file.registers[5] = 32'd50; // x5
        uut.reg_file.registers[6] = 32'd15; // x6
    end

    // Monitor output
    initial begin
        $display("Time\tPC\t\tInst\t\tALU_Result\tReg x1\tReg x4");
        $monitor("%4dns\t%h\t%h\t%h\t%d\t%d",
            $time,
            uut.pc,
            uut.inst,
            uut.alu_result,
            uut.reg_file.registers[1],
            uut.reg_file.registers[4]
        );

        #100 $finish;
    end
endmodule
