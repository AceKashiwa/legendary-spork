`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/24
// Design Name: 
// Module Name: onoff_sync_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for onoff_sync module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module onoff_sync_tb;

    // 输入信号
    reg clk;
    reg reset;
    reg button_in;

    // 输出信号
    wire light;

    // 实例化待测模块 (UUT)
    onoff_sync uut (
        .clk(clk), 
        .reset(reset), 
        .button_in(button_in), 
        .light(light)
    );

    initial begin
        // 初始化输入信号
        clk = 0;
        reset = 1;
        button_in = 0;

        // 等待 100 ns 以完成全局复位
        #100;
        reset = 0;

        // 添加测试激励
        // 测试 1: 简单的按键按下和释放
        #100 button_in = 1;
        #200 button_in = 0;

        // 测试 2: 按键按下带消抖
        #200;
        button_in = 1; #10;
        button_in = 0; #10;
        button_in = 1; #10;
        button_in = 0; #10;
        button_in = 1; #200;
        button_in = 0;

        // 测试 3: 快速连续按键按下
        #100;
        repeat (3) begin
            button_in = 1; #50;
            button_in = 0; #50;
        end 

        // 测试 4: 长时间按键按下
        #100;
        button_in = 1; #500;
        button_in = 0; #100;

        // 测试 5: 短时间按键按下
        #100;
        button_in = 1; #20;
        button_in = 0; #100;

        // 测试 6: 多次快速按键按下和释放
        #100;
        repeat (5) begin
            button_in = 1; #30;
            button_in = 0; #30;
        end

        // 测试 7: 按键按下后保持一段时间再释放
        #100;
        button_in = 1; #100;
        button_in = 0; #200;

        $stop;
    end
    
    always #5 clk = ~clk; // 生成时钟信号

endmodule