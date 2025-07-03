module RegisterFile (
    input         clk,
    input         rst_n,
    input         RegWEn,        // Register write enable
    input  [4:0]  rs1,           // Source register 1
    input  [4:0]  rs2,           // Source register 2
    input  [4:0]  rd,            // Destination register
    input  [31:0] write_data,    // Data to write to rd
    output [31:0] rs1_data,      // Output of rs1
    output [31:0] rs2_data      // Output of rs2
);

    reg [31:0] registers [0:31];   // 32 registers, each 32-bit
    integer i;
    always @(negedge rst_n) begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 32'h00000000;
    end
    // Asynchronous read

    // Synchronous write
    always @(posedge clk) begin
        if (RegWEn && rd != 0) begin
            registers[rd] <= write_data;
        end
    end
    

    // Optional: debug display
    always @(posedge clk) begin
        if (RegWEn && rd != 0) begin
            $display("RF: time=%0t, x%0d <= 0x%h", $time, rd, write_data);
        end
    end
    assign rs1_data = (rs1 != 0) ? registers[rs1] : 32'b0;
    assign rs2_data = (rs2 != 0) ? registers[rs2] : 32'b0;

    // Export all registers

endmodule
