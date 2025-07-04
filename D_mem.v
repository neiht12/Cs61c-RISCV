module D_MEM (
    input         clk,
    input         MemRW,         // 1: write, 0: read
    input  [31:0] addr,          // byte address
    input  [31:0] write_data,    // data to write
    output [31:0] read_data      // data read from memory
);

    reg [31:0] memory [0:511];   

    // Read (asynchronous)
    assign read_data = memory[addr[31:2]]; // Word-aligned: ignore bits [1:0]

    // Write (synchronous)
    always @(posedge clk) begin
        if (MemRW) begin
            memory[addr[31:2]] <= write_data;
            $display("D_MEM: time=%0t, addr=%h, write_data=%h", $time, addr, write_data);
        end
    end

endmodule
