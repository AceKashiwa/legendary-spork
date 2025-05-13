`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/23 15:36:21
// Design Name: 
// Module Name: Lock
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


module Lock(
    input clk, reset,
    input b0_in, b1_in,
    output [6:0] a_to_g0,
    output [6:0] a_to_g1,
    output [7:0] an,
    output reg unlock
    );
    // 处理按钮输入
    wire b0, b1;
    Button b_0(.clk(clk), .reset(reset), .button_in(b0_in), .button_out(b0));
    Button b_1(.clk(clk), .reset(reset), .button_in(b1_in), .button_out(b1));
    
    // 状态机
    wire out;
    wire [31:0] hex;
    E_LOCK_FSM lock_fsm(.clk(clk), .reset(reset), .b0(b0), .b1(b1), .out(out), .hex_display(hex));
    
    // 七段数码管
    Hex7seg h(.clk(clk), .reset(reset), .hex(hex), .a_to_g0(a_to_g0), .a_to_g1(a_to_g1), .an(an));
    
    // 解锁
    always @(posedge reset) unlock <= out;
    //reg out_old;
    //always @(posedge clk) begin
    //    if (out == 0 && out_old == 1)
    //        unlock <= ~unlock;
    //    out_old <= out;
    //end
endmodule

module E_LOCK_FSM_(
    input clk, reset,
    input b0, b1,
    output out,
    output [31:0] hex_display
    );
    // 定义状态
    parameter S_RESET = 32'h88888888;
    parameter S_0 = 32'h00000000;
    parameter S_01 = 32'h00000001;
    parameter S_011 = 32'h00000011;
    parameter S_0110 = 32'h00000110;
    parameter S_01101 = 32'h00001101;
    parameter S_011011 = 32'h00011011;
    parameter S_0110110 = 32'h00110110;

    reg [31:0] state, next_state;
    // 次态逻辑
    always @(*) begin
        if (reset)
            next_state = S_RESET;
        else
            case (state)
                S_RESET: next_state = b0 ? S_0 : b1 ? S_RESET : state;
                S_0: next_state = b0 ? S_0 : b1 ? S_01 : state;
                S_01: next_state = b0 ? S_0 : b1 ? S_011 : state;
                S_011: next_state = b0 ? S_0110 : b1 ? S_RESET : state;
                S_0110: next_state = b0 ? S_0 : b1 ? S_01101 : state;
                S_01101: next_state = b0 ? S_0 : b1 ? S_011011 : state;
                S_011011: next_state = b0 ? S_0110110 : b1 ? S_RESET : state;
                S_0110110: next_state = b0 ? S_0 : b1 ? S_01101 : state;
                default: next_state = S_RESET;
            endcase
    end

    // 现态赋值
    always @(posedge clk) state <= next_state;
    
    //输出
    assign out = (state == S_0110110);
    assign hex_display = state;
endmodule

module E_LOCK_FSM(
    input clk, reset,
    input b0, b1,
    output out,
    output [31:0] hex_display
);
    assign C = b0 ? 0 : b1 ? 1 : C;

    // 所有信号变量
    reg net0, net1, net2, net3, net4, net5, net6, net7, net8, net9;
    reg net10, net11, net12, net13, net14, net15, net16, net17, net18, net19;
    reg net20, net21, net22, net23, net24, net25, net26, net27, net28, net29;
    reg net30, net31, net32, net33, net34, net35;

    // 输入连接
    assign net1 = clk;
    assign net5 = C;
    assign {net16, net2, net9, net20, net27, net4, net14, net22} = reset ? 8'b00000000 : 
        {net16, net2, net9, net20, net27, net4, net14, net22};

    // 非门
    not (net24, net13);

    // 与门
    and (net0, net5, net4);
    and (net33, net5, net12);
    and (net18, net5, net28);
    and (net15, net23, net5);
    and (net30, net5, net11);
    and (net7, net5, net22);
    and (net12, net7, net24, net10);
    and (net10, net9, net2, net16);
    and (net25, net27, net20);
    and (net29, net23, net13);
    and (net23, net22, net14);
    and (net28, net14, net4);

    // 或门
    or (net31, net8, net15);
    or (net3, net7, net29);
    or (net26, net29, net18);
    or (net34, net0, net15, net30);
    or (net19, net33, net8, net15);

    // 触发器（按照 D 后数字从小到大排序）
    always @(posedge net1) begin
        net22 <= net5; // D0
    end
    assign net21 = ~net22;

    always @(posedge net1) begin
        net14 <= net3; // D1
    end
    assign net32 = ~net14;

    always @(posedge net1) begin
        net4 <= net26; // D2
    end
    assign net13 = ~net4;

    always @(posedge net1) begin
        net27 <= net34; // D3
    end
    assign net6 = ~net27;

    always @(posedge net1) begin
        net20 <= net19; // D4
    end
    assign net17 = ~net20;

    always @(posedge net1) begin
        net9 <= ~net31; // D5
    end

    always @(posedge net1) begin
        net2 <= ~net15; // D6
    end

    always @(posedge net1) begin
        net16 <= ~net15; // D7
    end

    // 输出
    assign state = {~net16, ~net2, ~net9, net20, net27, net4, net14, net22};
    assign out = (state == 8'b01101100);
    assign hex_display = {3'b000,state[7],3'b000,state[6],3'b000,state[5],3'b000,state[4],3'b000,state[3],3'b000,state[2],3'b000,state[1],3'b000,state[0]};
endmodule