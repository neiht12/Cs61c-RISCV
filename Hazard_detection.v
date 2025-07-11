module Hazard_detection_unit(
    input MemReadE,
    input [4:0] RD_E,
    input [4:0] Rs1_D, Rs2_D,
    output reg PCWrite,
    output reg IF_ID_Write,
    output reg FlushE
);
    always @(*) begin
        // Load-use hazard detection
        if (MemReadE && (RD_E != 5'd0) &&
            ((RD_E == Rs1_D) || (RD_E == Rs2_D))) begin
            PCWrite     = 0;  // dừng PC
            IF_ID_Write = 0;  // dừng IF/ID
            FlushE      = 1;  // chèn NOP vào ID/EX (stall 1 cycle)
        end else begin
            PCWrite     = 1;  // cho phép PC tiếp tục
            IF_ID_Write = 1;  // cho phép IF/ID tiếp tục
            FlushE      = 0;  // không flush
        end
    end
endmodule