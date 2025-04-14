`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: LED_Shift
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 流水灯模块，移位完成后灯全灭时输出使能信号
// 
// Dependencies: 
// 
// Revision:
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module LED_Shift(
    input wire clk,          // 时钟信号
    input wire reset,        // 复位信号
    input wire direction,    // 移位方向，1 表示左移，0 表示右移
    output reg [7:0] led,    // 流水灯输出
    output reg done          // 完成信号，当灯全灭时输出高电平
);
    reg enable;              // 内部使能信号

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            led <= 8'b0000_0001; // 初始状态，点亮第一个灯
            done <= 0;           // 完成信号复位
            enable <= 1;         // 使能移位操作
        end else if (enable) begin
            if (direction) begin
                led <= {led[6:0], led[7]}; // 左移
            end else begin
                led <= {led[0], led[7:1]}; // 右移
            end

            // 检查是否所有灯都熄灭
            if (led == 8'b0000_0000) begin
                done <= 1;       // 输出完成信号
                enable <= 0;     // 停止移位操作
            end else begin
                done <= 0;       // 未完成时保持完成信号为低
            end
        end
    end
endmodule
