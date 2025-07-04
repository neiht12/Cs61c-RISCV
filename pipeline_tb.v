module pipeline_tb;

    // Clock and reset signals
    reg clk = 0;
    reg rst_n;

    // Instantiate DUT
    Pipeline_RISCV dut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generator: 100ns cycle
    always #50 clk = ~clk;

    // Main test sequence
    initial begin
        // Apply reset (active-low)
        rst_n = 0;
        #100;
        rst_n = 1;

        // Wait enough cycles for all instructions to propagate through pipeline
        #2000;

        // Display key register values
        $display("=== Simulation Results ===");
        $display("x1  = %0d", dut.Decode.rf.registers[1]);   // 7
        $display("x2  = %0d", dut.Decode.rf.registers[2]);   // 8
        $display("x3  = %0d", dut.Decode.rf.registers[3]);   // 15
        $display("x4  = %0d", dut.Decode.rf.registers[4]);   // 15
        $display("x5  = %0d", dut.Decode.rf.registers[5]);   // 22
        $display("x6  = %0d", dut.Decode.rf.registers[6]);   // 23
        $display("x7  = %0d", dut.Decode.rf.registers[7]);   // 100
        $display("x8  = %0d", dut.Decode.rf.registers[8]);   // 200
        $display("x9  = %0d", dut.Decode.rf.registers[9]);   // unknown (bị flush nếu nhảy)
        $display("x10 = %0d", dut.Decode.rf.registers[10]);  // 77

        $finish;
    end

    // Monitor PC + current instruction
    initial begin
        $monitor("Time = %0t | PC = %h | Instr = %h", 
                 $time, 
                 dut.Fetch.PCD, 
                 dut.Decode.InstrD);
    end

    // Dump VCD waveform
    initial begin
        $dumpfile("pipeline_tb.vcd");
        $dumpvars(0, pipeline_tb);
    end

endmodule