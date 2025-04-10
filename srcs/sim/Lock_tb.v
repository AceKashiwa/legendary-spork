`timescale 1ns / 1ps

module Lock_tb;

    // 输入信号
    reg clk;
    reg reset;
    reg b0_in;
    reg b1_in;

    // 输出信号
    wire [6:0] a_to_g0;
    wire [6:0] a_to_g1;
    wire [7:0] an;
    wire unlock;

    // 实例化待测试单元 (UUT)
    Lock uut (
        .clk(clk), 
        .reset(reset), 
        .b0_in(b0_in), 
        .b1_in(b1_in), 
        .a_to_g0(a_to_g0), 
        .a_to_g1(a_to_g1), 
        .an(an), 
        .unlock(unlock)
    );

    initial begin
        // 初始化输入信号
        clk = 0;
        reset = 1;
        b0_in = 0;
        b1_in = 0;

        // 等待 100 ns 以完成全局复位
        #100;
        reset = 0;

        // 测试1：简单的按钮按下和释放
        b0_in = 1; #100; b0_in = 0; #100;
        b1_in = 1; #100; b1_in = 0; #100;
        b0_in = 1; #100; b0_in = 0; #100;
        b1_in = 1; #100; b1_in = 0; #100;
        b0_in = 1; #100; b0_in = 0; #100;
        b1_in = 1; #100; b1_in = 0; #100;

        // 检查解锁信号
        reset = 1; #10; reset = 0;
        if (unlock) begin
            $display("测试通过：锁已解锁");
        end else begin
            $display("测试失败：锁未解锁");
        end

        // 测试2：另一组按钮按下序列
        b0_in = 1; #200; b0_in = 0; #200;
        b1_in = 1; #200; b1_in = 0; #200;
        b0_in = 1; #200; b0_in = 0; #200;
        b1_in = 1; #200; b1_in = 0; #200;
        b0_in = 1; #200; b0_in = 0; #200;
        b1_in = 1; #200; b1_in = 0; #200;

        // 再次检查解锁信号
        reset = 1; #10; reset = 0;
        if (unlock) begin
            $display("测试通过：锁已解锁");
        end else begin
            $display("测试失败：锁未解锁");
        end

        // 测试3：快速连续的按钮按下
        repeat (3) begin
            b0_in = 1; #50; b0_in = 0; #50;
            b1_in = 1; #50; b1_in = 0; #50;
        end

        // 再次检查解锁信号
        reset = 1; #10; reset = 0;
        if (unlock) begin
            $display("测试通过：锁已解锁");
        end else begin
            $display("测试失败：锁未解锁");
        end

        // 测试4：长时间按下按钮
        b0_in = 1; #500; b0_in = 0; #100;
        b1_in = 1; #500; b1_in = 0; #100;

        // 再次检查解锁信号
        reset = 1; #10; reset = 0;
        if (unlock) begin
            $display("测试通过：锁已解锁");
        end else begin
            $display("测试失败：锁未解锁");
        end

        // 测试5：短时间按下按钮
        b0_in = 1; #20; b0_in = 0; #100;
        b1_in = 1; #20; b1_in = 0; #100;

        // 再次检查解锁信号
        reset = 1; #10; reset = 0;
        if (unlock) begin
            $display("测试通过：锁已解锁");
        end else begin
            $display("测试失败：锁未解锁");
        end

        // 测试6：密码序列 0110110
        b0_in = 1; #200; b0_in = 0; #200; // 0
        b1_in = 1; #200; b1_in = 0; #200; // 1
        b1_in = 1; #200; b1_in = 0; #200; // 1
        b0_in = 1; #200; b0_in = 0; #200; // 0
        b1_in = 1; #200; b1_in = 0; #200; // 1
        b1_in = 1; #200; b1_in = 0; #200; // 1
        b0_in = 1; #200; b0_in = 0; #200; // 0

        // 检查解锁信号
        reset = 1; #10; reset = 0;
        if (unlock) begin
            $display("测试通过：锁已解锁");
        end else begin
            $display("测试失败：锁未解锁");
        end

        #1000
        $stop;
    end
    
    always #5 clk = ~clk; // 生成时钟信号

endmodule