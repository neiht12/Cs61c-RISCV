module PC (
    input         clk,        // Clock
    input         rst_n,      // Active-low reset
    input  [31:0] next_pc,    // Next PC value
    output reg [31:0] pc      // Current PC
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc <= 32'h00000000;  // Reset to 0
        else
            pc <= next_pc;       // Update PC every clock
    end

endmodule
