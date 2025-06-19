// 例 5.9 最简单的 n 位二进制计数器（带同步清零）
module counter_n #(parameter n = 1) (
    output reg [n-1:0] q,
    output cout,
    input cin,
    input r,
    input clk
);
    assign cout = &q && cin; // 进位输出

    always @(posedge clk) begin
        if (r)
            q <= 0; // 同步清零
        else if (cin)
            q <= q + 1; // 计数
        // else q <= q; // 保持，可省略
    end
endmodule

// 例 5.10 任意进制计数器/分频器
module counter_n_mod #(
    parameter n = 2,              // 计数器的模
    parameter counter_bits = 1    // 计数器的位数
) (
    input clk,
    input r,
    input ci,
    output co,
    output reg [counter_bits:1] q
);
    assign co = (q == (n-1)) && ci; // 组合进位输出

    always @(posedge clk) begin
        if (r)
            q <= 0; // 同步清零
        else if (ci) begin
            if (q == (n-1))
                q <= 0;
            else
                q <= q + 1;
        end
        // else q <= q; // 保持，可省略
    end
endmodule

// 例 5.11 计数器测试代码
`timescale 1ns / 1ps
module counter_n_tb_v;
    // Inputs
    reg clk, r, ci;
    // Outputs
    wire [2:0] q;
    wire co;

    // 5进制计数器实例
    counter_n_mod #(.counter_bits(3), .n(5)) counter_5 (
        .clk(clk),
        .r(r),
        .ci(ci),
        .q(q),
        .co(co)
    );

    initial begin
        clk = 0; r = 1; ci = 0;
        #152 r = 0; ci = 1;
        #1100 r = 1;
        #100 r = 0; ci = 0;
        repeat(6) begin
            #100 ci = 0;
            #200 ci = 1;
        end
        $stop;
    end

    always #50 clk = ~clk;
endmodule

// 例 5-12 2~100进制 8421BCD 计数器
module counter_bcd #(
    parameter MODULUS = 8'h23 // 计数器最大值，计数器的模即 MODULUS+1
) (
    output [7:0] q,
    output co,
    input ci,
    input r,
    input clk
);
    assign co = (q == MODULUS) & ci;

    // 个位
    wire co1;
    counter_n_mod #(.counter_bits(4), .n(10)) counter1 (
        .clk(clk),
        .r(co),
        .ci(ci),
        .q(q[3:0]),
        .co(co1)
    );

    // 十位
    counter_n_mod #(.counter_bits(4), .n(10)) counter2 (
        .clk(clk),
        .r(co),
        .ci(co1),
        .q(q[7:4]),
        .co()
    );
endmodule