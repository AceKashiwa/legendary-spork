`timescale 1ns / 1ps

`define STOP 0
`define FORWARD 1
`define BACKWARD 2
`define TURN_LEFT 3
`define TURN_RIGHT 4

module L298N (
    input clk, reset,
    input [2:0] state,           // 状态输入 0-4
    input [7:0] speed_left,      // 左轮速度 0-100
    input [7:0] speed_right,     // 右轮速度 0-100
    output reg IN1, IN2, IN3, IN4,
    output ENA, ENB
);
    // 控制信号输出    
    always @(posedge clk or posedge reset)
    begin
        case (state)
            0: begin IN1 <= 0; IN2 <= 0; IN3 <= 0; IN4 <= 0; end // 停止
            1: begin IN1 <= 1; IN2 <= 0; IN3 <= 1; IN4 <= 0; end // 前进
            2: begin IN1 <= 0; IN2 <= 1; IN3 <= 0; IN4 <= 1; end // 后退
            3: begin IN1 <= 0; IN2 <= 1; IN3 <= 1; IN4 <= 0; end // 原地左转
            4: begin IN1 <= 1; IN2 <= 0; IN3 <= 0; IN4 <= 1; end // 原地右转
            default: begin IN1 <= 0; IN2 <= 0; IN3 <= 0; IN4 <= 0; end // 默认停止
        endcase
    end

    // 速度控制
    reg pwm_left, pwm_right;
    reg [7:0] count_left, count_right;

    always @(posedge clk)
    begin
        // PWM输出
        if (count_left < speed_left)
            pwm_left <= 1;
        else
            pwm_left <= 0;

        // 计数器更新
        if (count_left < 100 - 1)
            count_left <= count_left + 1;
        else
            count_left <= 0; // 重置计数器
    end

    always @(posedge clk)
    begin
        // PWM输出
        if (count_right < speed_right)
            pwm_right <= 1;
        else
            pwm_right <= 0;

        // 计数器更新
        if (count_right < 100 - 1)
            count_right <= count_right + 1;
        else
            count_right <= 0; // 重置计数器
    end

    assign ENA = pwm_left;  // 左轮使能
    assign ENB = pwm_right; // 右轮使能
endmodule