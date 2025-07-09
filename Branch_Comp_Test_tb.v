module Branch_Comp_Test_Tb ();
    
    reg [31:0] a, b;
    reg [2:0] funct3;
    reg Jump, BrUn;
    wire branch_taken;
    
    // Instantiate Branch_Comp
    Branch_Comp dut (
        .a(a),
        .b(b),
        .funct3(funct3),
        .Jump(Jump),
        .BrUn(BrUn),
        .branch_taken(branch_taken)
    );
    
    initial begin
        $dumpfile("Branch_Comp_Test.vcd");
        $dumpvars(0);
        
        // Test Jump = 1 (should always be taken)
        $display("Testing Jump functionality...");
        a = 32'h10; b = 32'h20; funct3 = 3'b000; Jump = 1; BrUn = 0;
        #10;
        $display("Jump=1: a=%h, b=%h, funct3=%b, Jump=%b, BrUn=%b -> branch_taken=%b (Expected: 1)", 
                 a, b, funct3, Jump, BrUn, branch_taken);
        
        // Test BEQ (equal)
        $display("Testing BEQ (equal)...");
        a = 32'h10; b = 32'h10; funct3 = 3'b000; Jump = 0; BrUn = 0;
        #10;
        $display("BEQ Equal: a=%h, b=%h, funct3=%b, Jump=%b, BrUn=%b -> branch_taken=%b (Expected: 1)", 
                 a, b, funct3, Jump, BrUn, branch_taken);
        
        // Test BEQ (not equal)
        $display("Testing BEQ (not equal)...");
        a = 32'h10; b = 32'h20; funct3 = 3'b000; Jump = 0; BrUn = 0;
        #10;
        $display("BEQ Not Equal: a=%h, b=%h, funct3=%b, Jump=%b, BrUn=%b -> branch_taken=%b (Expected: 0)", 
                 a, b, funct3, Jump, BrUn, branch_taken);
        
        // Test BNE (not equal)
        $display("Testing BNE (not equal)...");
        a = 32'h10; b = 32'h20; funct3 = 3'b001; Jump = 0; BrUn = 0;
        #10;
        $display("BNE Not Equal: a=%h, b=%h, funct3=%b, Jump=%b, BrUn=%b -> branch_taken=%b (Expected: 1)", 
                 a, b, funct3, Jump, BrUn, branch_taken);
        
        // Test BLT signed
        $display("Testing BLT signed...");
        a = 32'hFFFFFFFF; b = 32'h1; funct3 = 3'b100; Jump = 0; BrUn = 0;
        #10;
        $display("BLT Signed: a=%h, b=%h, funct3=%b, Jump=%b, BrUn=%b -> branch_taken=%b (Expected: 1)", 
                 a, b, funct3, Jump, BrUn, branch_taken);
        
        // Test BLTU unsigned
        $display("Testing BLTU unsigned...");
        a = 32'hFFFFFFFF; b = 32'h1; funct3 = 3'b100; Jump = 0; BrUn = 1;
        #10;
        $display("BLTU Unsigned: a=%h, b=%h, funct3=%b, Jump=%b, BrUn=%b -> branch_taken=%b (Expected: 0)", 
                 a, b, funct3, Jump, BrUn, branch_taken);
        
        $display("Branch_Comp test completed.");
        $finish;
    end
    
endmodule
