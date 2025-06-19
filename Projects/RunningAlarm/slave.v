`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/19 14:25:52
// Design Name: 
// Module Name: slave
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module slave_fsm (
    input clk,          // 时钟信号
    input reset,        // 异步复位信号（高电平有效）
    input alarm_recv,   // 报警接收信号（触发状态转换）
    input caught,       // 捕获信号（来自主板）
    output reg [1:0] state_out // 当前状态输出
);

    parameter RESET      = 2'b00;  // 复位状态
    parameter FAST_SLAVE = 2'b01;  // 快速响应状态
    parameter STOP       = 2'b10;  // 停止状态

    reg [1:0] current_state, next_state;

    // 状态寄存器更新（时序逻辑）
    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= RESET;  // 异步复位
        else 
            current_state <= next_state;  // 状态转移
    end

    // 状态转换逻辑（组合逻辑）
    always @(*) begin
        // 默认保持当前状态
        next_state = current_state;  
        
        case (current_state)
            RESET:
                // 收到报警信号时进入快速响应状态
                if (alarm_recv) 
                    next_state = FAST_SLAVE;
            
            FAST_SLAVE:
                // 报警消失或收到捕获信号时进入停止状态
                if (!alarm_recv || caught) 
                    next_state = STOP;
            
            STOP: 
                // 停止状态保持，需要复位才能退出
                next_state = STOP;
                
            default:
                next_state = RESET;  // 异常情况回到复位状态
        endcase
    end

    // 状态输出（组合逻辑）
    always @(*) begin
        state_out = current_state;
    end

endmodule
