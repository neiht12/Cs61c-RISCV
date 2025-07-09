module I_MEM (
    input [31:0] addr,
    output [31:0] inst
);
    reg [31:0] memory [0:511]; // 511 words

    assign inst = memory[addr[31:2]]; // Word-aligned address

    integer i;

    always @(*) begin
        $display("IMEM: Cycle=%0d, addr=%h, inst=%h", $time/10, addr, inst);
    end

        initial begin
        // -------- I-type instructions --------
        // addi x1, x0, 5     => x1 = 5
        memory[0]  = 32'h00500093; // I-type

        // addi x2, x0, 10    => x2 = 10
        memory[1]  = 32'h00a00113; // I-type

        // -------- R-type instructions --------
        // add x3, x1, x2     => x3 = x1 + x2
        memory[2]  = 32'h002081b3; // R-type

        // sub x4, x2, x1     => x4 = x2 - x1
        memory[3]  = 32'h40110233; // R-type

        // and x5, x1, x2     => x5 = x1 & x2
        memory[4]  = 32'h0020f2b3; // R-type

        // or x6, x1, x2      => x6 = x1 | x2
        memory[5]  = 32'h0020e333; // R-type

        // -------- B-type instruction --------
        // beq x1, x2, +8     => nếu x1 == x2 thì nhảy đến PC + 8
        memory[6]  = 32'h00208263; // B-type

        // -------- J-type instruction --------
        // jal x0, -8         => nhảy lùi 8 byte (vòng lặp)
        memory[7]  = 32'hFFFFF06F; // J-type

        // -------- U-type instruction --------
        // lui x7, 0x12345    => x7 = 0x12345000
        memory[8]  = 32'h123457b7; // U-type

        // -------- S-type (store/load) --------
        // sw x1, 0(x2)       => lưu x1 tại địa chỉ x2
        memory[9]  = 32'h00112023; // S-type

        // lw x8, 0(x2)       => load giá trị từ địa chỉ x2 vào x8
        memory[10] = 32'h00012103; // I-type (load)

        // -------- Clear remaining memory --------
        for (i = 11; i < 512; i = i + 1)
            memory[i] = 32'h00000000;
    end

endmodule
