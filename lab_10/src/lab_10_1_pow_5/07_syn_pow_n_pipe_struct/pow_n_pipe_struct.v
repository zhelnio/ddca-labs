module pow_n_pipe_struct
# (
    parameter w        = 8,
              n_stages = 4
)
(
    input                       clk,
    input                       rst_n,
    input                       arg_vld,
    input  [w            - 1:0] n,
    output [    n_stages - 1:0] res_vld,
    output [w * n_stages - 1:0] res
);

    wire [w - 1:0] mul_d     [ 1 : n_stages     ];

    wire           arg_vld_q   [ 0 : n_stages + 1 ];
    wire [w - 1:0] n_q       [ 0 : n_stages + 1 ];
    wire [w - 1:0] mul_q     [ 2 : n_stages + 1 ];

    assign arg_vld_q [0] = arg_vld;
    assign n_q     [0] = n;
    
    assign mul_d   [1] = n_q [1] * n_q [1];

    generate
    
        genvar i;
    
        for (i = 2; i <= n_stages; i = i + 1)
        begin : b_mul
            assign mul_d [i] = mul_q [i] * n_q [i];
        end

        for (i = 1; i <= n_stages; i = i + 1)
        begin : b_mul_reg
            reg_no_rst # (w) i_mul
                (clk, mul_d [i], mul_q [i + 1]);
        end

        for (i = 0; i <= n_stages; i = i + 1)
        begin : b_regs
            reg_rst_n i_arg_vld
                (clk, rst_n, arg_vld_q [i], arg_vld_q [i + 1]);

            reg_no_rst # (w) i_n
                (clk, n_q [i], n_q [i + 1]);
        end
        
        for (i = 2; i <= n_stages + 1; i = i + 1)
        begin : b_res
            assign res_vld [   n_stages + 1 - i            ] = arg_vld_q [i];
            assign res     [ ( n_stages + 1 - i ) * w +: w ] = mul_q   [i];
        end
    
    endgenerate

endmodule
