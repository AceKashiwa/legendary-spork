`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/13 23:53:55
// Design Name: 
// Module Name: top
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


module top(
    input sys_clk_in,
    input sys_rst_n,
    output [7:0] seg_cs_pin,
    output [7:0] seg_data_0_pin,
    output [7:0] seg_data_1_pin
);

    wire [31:0] x; // 8位16进制数，00HHMMSS
    wire [7:0] aen; // 使能信号
    wire [7:0] dp_en; // 小数点使能信号
    assign aen = 8'b11111111; // 使能所有数码管
    assign dp_en = 8'b00010100; // 不显示小数点

    timer_hms_top timer_hms_top_inst (
        .clk_100m(sys_clk_in),
        .rst_n(sys_rst_n),
        .hms_hex(x)
    );

    seg7 seg7_inst (
        .x(x),
        .aen(aen),
        .dp_en(dp_en),
        .clk(sys_clk_in),
        .clr(~sys_rst_n), // 低有效复位转为高有效
        .a_to_g0(seg_data_0_pin),
        .a_to_g1(seg_data_1_pin),
        .an(seg_cs_pin)
    );
endmodule
