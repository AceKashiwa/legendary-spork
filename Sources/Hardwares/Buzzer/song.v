`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/23 23:11:21
// Design Name: 
// Module Name: song
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


module song(
    input sys_clk,
    input rst_n,
    output reg speaker,
    output [2:0] cs,    // 数码管
    output buzzer
);
    assign buzzer = speaker;
    wire clk_6mhz;  // 音阶
    clk_self #(8) u1(
        .clk(sys_clk),
        .clk_out(clk_6mhz)
    );

    wire clk_4hz;   // 音长
    clk_self #(12500000) u2(
        .clk(sys_clk),
        .clk_out(clk_4hz)
    );

    wire [3:0] high, med, low;
    wire [2:0] cs_wire;

    // 实例化乐谱模块
    music_score music_score_inst(
        .clk_4hz(clk_4hz),
        .rst_n(rst_n),
        .high(high),
        .med(med),
        .low(low),
        .cs(cs_wire)
    );
    assign cs = cs_wire;

    reg [13:0] divider, origin;
    reg carry;

    always @(posedge clk_6mhz) begin    // 置数改变分频比
        if (divider == 16383)
        begin
            divider <= origin;
            carry <= 1;
        end
        else
        begin
            divider <= divider + 1;
            carry <= 0;
        end
    end

    always @(posedge carry) begin   // 方波信号
        speaker <= ~speaker;
    end

    always @(posedge clk_4hz) begin
        case ({high, med, low})
            'h001:  origin <= 4915; 'h002:  origin <= 6168;
            'h003:  origin <= 7281; 'h004:  origin <= 7792;
            'h005:  origin <= 8730; 'h006:  origin <= 9565;
            'h007:  origin <= 10310;    'h010:  origin <= 10647;
            'h020:  origin <= 11272;    'h030:  origin <= 11831;
            'h040:  origin <= 12094;    'h050:  origin <= 12556; 
            'h060:  origin <= 12947;    'h070:  origin <= 13346;
            'h100:  origin <= 13516;    'h200:  origin <= 13829;
            'h300:  origin <= 14109;    'h400:  origin <= 14235;
            'h500:  origin <= 14470;    'h600:  origin <= 14678;
            'h700:  origin <= 14864;    'h000:  origin <= 16383;
        endcase
    end

    wire [3:0] an;
endmodule