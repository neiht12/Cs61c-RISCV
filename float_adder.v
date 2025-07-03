// float_add.v
module float_add (
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] result
);

    function [31:0] add_float;
        input [31:0] a, b;

        reg sign_a, sign_b, sign_res;
        reg [7:0] exp_a, exp_b, exp_res;
        reg [23:0] frac_a, frac_b;
        reg [24:0] aligned_a, aligned_b, sum;
        reg [22:0] frac_res;

        begin
            sign_a = a[31];
            sign_b = b[31];
            exp_a = a[30:23];
            exp_b = b[30:23];
            frac_a = (exp_a == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]}; // xử lý denormals
            frac_b = (exp_b == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            // Align exponent
            if (exp_a > exp_b) begin
                aligned_a = frac_a;
                aligned_b = frac_b >> (exp_a - exp_b);
                exp_res = exp_a;
            end else begin
                aligned_a = frac_a >> (exp_b - exp_a);
                aligned_b = frac_b;
                exp_res = exp_b;
            end

            // Add/sub mantissas
            if (sign_a == sign_b) begin
                sum = aligned_a + aligned_b;
                sign_res = sign_a;
            end else begin
                if (aligned_a >= aligned_b) begin
                    sum = aligned_a - aligned_b;
                    sign_res = sign_a;
                end else begin
                    sum = aligned_b - aligned_a;
                    sign_res = sign_b;
                end
            end

            // Normalize
            if (sum[24]) begin
                sum = sum >> 1;
                exp_res = exp_res + 1;
            end else begin
                while (sum[23] == 0 && exp_res > 0) begin
                    sum = sum << 1;
                    exp_res = exp_res - 1;
                end
            end

            frac_res = sum[22:0];
            add_float = {sign_res, exp_res, frac_res};
        end
    endfunction

    assign result = add_float(a, b);

endmodule
