module Single_Cycle_Top_Tb ();
    
    reg clk=1'b1, rst;
    // Instantiate the Single Cycle RISC-V processor
    // Ensure the module name matches the one in your design
    // If the module name is different, change it accordingly
    // For example, if your module is named "Single_Cycle_RISCV", use

    wire [31:0] PC_out_top, Instruction_out_top;

    RISCV_Single_Cycle Single_Cycle_Top(
                                .clk(clk),
                                .rst_n(rst),
                                .PC_out_top(PC_out_top),
                                .Instruction_out_top(Instruction_out_top)
    );

    initial begin
        $dumpfile("Single_Cycle.vcd");
        $dumpvars(0);
    end

    always 
    begin
        clk = ~ clk;
        #50;  
        
    end
    
    // Monitor Branch_Comp inputs for debugging
    always @(posedge clk) begin
        $display("DEBUG Branch_Comp: time=%0t, a=%h, b=%h, funct3=%b, Jump=%b, BrUn=%b, branch_taken=%b",
                 $time, 
                 Single_Cycle_Top.branch_comp.a, 
                 Single_Cycle_Top.branch_comp.b,
                 Single_Cycle_Top.branch_comp.funct3,
                 Single_Cycle_Top.branch_comp.Jump,
                 Single_Cycle_Top.branch_comp.BrUn,
                 Single_Cycle_Top.branch_comp.branch_taken);
        
        $display("DEBUG Control: PC=%h, inst=%h, Jump=%b, PCSel=%b, pcsel_branch_or_jump=%b",
                 Single_Cycle_Top.pc,
                 Single_Cycle_Top.inst,
                 Single_Cycle_Top.Jump,
                 Single_Cycle_Top.PCSel,
                 Single_Cycle_Top.pcsel_branch);
    end
    
    initial
    begin
        rst <= 1'b0;
        #150;

        rst <= 1'b1;
        #3000;  // Tăng thời gian simulation
        $finish;
    end
endmodule