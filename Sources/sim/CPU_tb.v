`timescale 1ns / 1ps

module Dedicate_MicroProcessor_tb;
    reg clk;
    reg rst;
    reg [7:0] N;

    wire led;

    Dedicate_MicroProcessor tb(
        .clk(clk),
        .rst(rst),
        .N(N),
        .led(led)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        N = 8'b00000000;
        rst = 1;
        #50;
        rst = 0;

        // 测试用例 1：加载一个小值到 N
        N = 8'b00000010;
        #20;
        rst = 1;
        #50;
        rst = 0;
        #200;

        // 测试用例 2：加载一个中等值到 N
        N = 8'b01010101;
        #20;
        rst = 1;
        #50;
        rst = 0;
        #200;

        // 测试用例 3：加载一个较大值到 N
        N = 8'b01111111;
        #20;
        rst = 1;
        #50;
        rst = 0;
        #200;

        // 测试用例 4：加载一个值并观察 LED 行为
        N = 8'b00001111;
        #20;
        rst = 1;
        #50;
        rst = 0;
        #200;

        // 测试用例 5：加载一个交替位的值到 N
        N = 8'b10101010;
        #20;
        rst = 1;
        #50;
        rst = 0;
        #200;

        // 测试用例 6：加载全为 0 的值到 N
        N = 8'b00000000;
        #20;
        rst = 1;
        #50;
        rst = 0;
        #200;

        // 测试用例 7：加载全为 1 的值到 N
        N = 8'b11111111;
        #20;
        rst = 1;
        #50;
        rst = 0;
        #200;

        // 测试用例 8：加载一个随机值到 N
        N = 8'b01101001;
        #20;
        rst = 1;
        #50;
        rst = 0;
        #200;

        // 结束仿真
        $stop;
    end
endmodule