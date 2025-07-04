module Writeback_Stage(clk, rst_n, ResultSrcW, PCPlus4W, ALU_ResultW, ReadDataW, ResultW);

// Declaration of IOs
input clk, rst_n, ResultSrcW;
input [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

output [31:0] ResultW;

// Declaration of Module (sử dụng Mux2 có sẵn)
Mux2 result_mux (    
                .in0(ALU_ResultW),
                .in1(ReadDataW),
                .sel(ResultSrcW),
                .out(ResultW)
                );
endmodule