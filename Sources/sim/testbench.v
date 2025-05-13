`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/25
// Design Name: 
// Module Name: test_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for onoff module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module test_tb;

    // 输入信号
    reg button;

    // 输出信号
    wire light;

    // 实例化待测模块 (UUT)
    onoff uut (
        .button(button), 
        .light(light)
    );

    initial begin
        // 初始化输入信号
        button = 0;

        // 添加测试激励
        // 测试 1: 简单的按键按下和释放
        #100 button = 1;
        #100 button = 0;

        // 测试 2: 快速连续按键按下和释放
        #100;
        repeat (5) begin
            button = 1; #50;
            button = 0; #50;
        end 

        // 测试 3: 长时间按键按下
        #100;
        button = 1; #500;
        button = 0; #100;

        // 测试 4: 短时间按键按下
        #100;
        button = 1; #20;
        button = 0; #100;

        // 测试 5: 多次快速按键按下和释放
        #100;
        repeat (3) begin
            button = 1; #30;
            button = 0; #30;
        end

        // 测试 6: 按键按下后保持一段时间再释放
        #100;
        button = 1; #100;
        button = 0; #200;

        $stop;
    end

endmodule