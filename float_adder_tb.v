// tb_float_add.v - testbench cho float_add
`timescale 1ns/1ps

module tb_float_add;
    reg [31:0] a, b;
    wire [31:0] result;

    // Gắn module
    float_add uut (
        .a(a),
        .b(b),
        .result(result)
    );

    initial begin
        // In kết quả
        $display("Time\t\ta\t\tb\t\tresult");
        $monitor("%0t\t%h\t%h\t%h", $time, a, b, result);

        // Test case 1: 1.0 + 2.0 = 3.0
        a = 32'h3F800000; // 1.0
        b = 32'h40000000; // 2.0
        #10;

        // Test case 2: 1.5 + 1.25 = 2.75
        a = 32'h3FC00000; // 1.5
        b = 32'h3FA00000; // 1.25
        #10;

        // Test case 3: 5.0 + (-2.0) = 3.0
        a = 32'h40A00000; // 5.0
        b = 32'hC0000000; // -2.0
        #10;

        // Test case 4: 0 + 1.0 = 1.0
        a = 32'h00000000;
        b = 32'h3F800000;
        #10;

        $finish;
    end
endmodule
