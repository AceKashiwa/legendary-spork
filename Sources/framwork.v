// 闹钟躲避小车代码
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// 底盘运动部分
    // 红外，超声波测距部分

// oled显示部分
// 音乐部分
// 计时器模块

// 其他部分
    // 随机积分题目
    // 蓝牙远程控制
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

module L298N_tb;
    reg clk, reset;
    reg [2:0] state;
    reg [7:0] speed_left, speed_right;
    wire IN1, IN2, IN3, IN4;
    wire ENA, ENB;

    // 实例化L298N模块
    L298N uut (
        .clk(clk),
        .reset(reset),
        .state(state),
        .speed_left(speed_left),
        .speed_right(speed_right),
        .IN1(IN1),
        .IN2(IN2),
        .IN3(IN3),
        .IN4(IN4),
        .ENA(ENA),
        .ENB(ENB)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns周期
    end

    // 测试序列
    initial begin

        // 复位保持更长时间
        reset = 1; state = 0; speed_left = 0; speed_right = 0; #30;
        reset = 0; #20;

        // 前进，低速
        state = 1; speed_left = 10; speed_right = 10; #1000;

        // 前进，中速
        state = 1; speed_left = 50; speed_right = 50; #1000;

        // 前进，高速
        state = 1; speed_left = 90; speed_right = 90; #1000;

        // 前进，左快右慢
        state = 1; speed_left = 80; speed_right = 20; #1000;

        // 前进，左慢右快
        state = 1; speed_left = 20; speed_right = 80; #1000;

        // 后退，低速
        state = 2; speed_left = 10; speed_right = 10; #1000;

        // 后退，左快右慢
        state = 2; speed_left = 90; speed_right = 30; #1000;

        // 原地左转，低速
        state = 3; speed_left = 15; speed_right = 15; #1000;

        // 原地右转，高速
        state = 4; speed_left = 100; speed_right = 100; #1000;

        // 停止
        state = 0; speed_left = 0; speed_right = 0; #50;

        $finish;
    end

    // 监视信号变化
    initial begin
        $monitor("Time: %0t | state: %0d | speed_left: %0d | speed_right: %0d | IN1: %b | IN2: %b | IN3: %b | IN4: %b | ENA: %b | ENB: %b",
                 $time, state, speed_left, speed_right, IN1, IN2, IN3, IN4, ENA, ENB);
    end
endmodule


// ultrasonic.v
module HC_SR04 (
    input clk, reset,
    input start,         // 启动信号
    input echo,          // 超声波回波信号
    output reg trig,     // 超声波触发信号
    output reg [15:0] distance // 测距结果，单位为cm
);
    // 状态定义
    localparam IDLE = 2'd0;
    localparam TRIG = 2'd1;
    localparam LISTEN = 2'd2;
    localparam DONE = 2'd3;

    reg [1:0] current_state, next_state;

    // 10us计数器，用于trig信号
    reg [7:0] trig_cnt;
    reg trig_done;

    // 回波计数器
    reg [15:0] echo_count;

    // 状态机
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:   next_state = start ? TRIG : IDLE;
            TRIG:   next_state = trig_done ? LISTEN : TRIG;
            LISTEN: next_state = (~echo) ? DONE : LISTEN;
            DONE:   next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // trig信号产生：高电平10us
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            trig <= 0;
            trig_cnt <= 0;
            trig_done <= 0;
        end else if (current_state == TRIG) begin
            if (trig_cnt < 10) begin
                trig <= 1;
                trig_cnt <= trig_cnt + 1;
                trig_done <= 0;
            end else begin
                trig <= 0;
                trig_done <= 1;
            end
        end else begin
            trig <= 0;
            trig_cnt <= 0;
            trig_done <= 0;
        end
    end

    // 回波计数
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            echo_count <= 0;
        end else if (current_state == LISTEN) begin
            if (echo)
                echo_count <= echo_count + 1;
        end else if (current_state == DONE) begin
            echo_count <= 0;
        end
    end

    // 距离计算
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            distance <= 0;
        end else if (current_state == DONE) begin
            // 距离 = echo高电平时间 / 58（假设1us时钟，1us=0.017cm，实际可根据clk调整）
            distance <= echo_count / 58;
        end
    end

endmodule