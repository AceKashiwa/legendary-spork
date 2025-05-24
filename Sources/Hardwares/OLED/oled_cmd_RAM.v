`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/19 14:44:52
// Design Name: 
// Module Name: oled_cmd_RAM
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


module oled_cmd_RAM #(
    parameter RAM_WIDTH = 8,
    parameter RAM_DEPTH = 32,
    parameter ADDR_WIDTH = 5
)(
    input clk,
    input rst_n,
    input re,
    input [ADDR_WIDTH-1:0] addr,
    output reg [RAM_WIDTH-1:0] data
);
    reg [RAM_WIDTH-1:0] Mem[RAM_DEPTH-1:0];

    always @(posedge rst_n) begin
		Mem[ 0] = 8'hae;	// 关闭屏幕
		Mem[ 1] = 8'h81;
		Mem[ 2] = 8'hff;	// 设置对比度：256级
		Mem[ 3] = 8'ha6;	// 设置显示模式为1亮0灭
		Mem[ 4] = 8'h20;
		Mem[ 5] = 8'h02;	// 设置页寻址模式
		Mem[ 6] = 8'h00; 	// 设置起始列地址低位
		Mem[ 7] = 8'h10;	// 设置起始列地址高位
		Mem[ 8] = 8'h40;	// 设置GDDRAM起始行: (01)xxxxxx -> 40为第0行
		Mem[ 9] = 8'ha1;	// 设置COL0映射到SEG0*
		Mem[10] = 8'hc8;	// 设置COM扫描方向：从COM0至COM[N-1]*
		Mem[11] = 8'ha8;
		Mem[12] = 8'h1F; 	// 设置复用率：即选通的COM行数为1F*
		Mem[13] = 8'hd3;
		Mem[14] = 8'h00;	// 设置垂直显示偏移：00~3F
		Mem[15] = 8'hd5;
		Mem[16] = 8'h80;	// 设置显示时钟分频数和fosc
		Mem[17] = 8'hd9;
		Mem[18] = 8'h1f;	// 设置预充电周期
		Mem[19] = 8'hda;
		Mem[20] = 8'h02;	// 设置COM硬件配置：禁止左右反置、使用序列COM引脚配置*
		Mem[21] = 8'hdb;
		Mem[22] = 8'h40;	// 设置VCOMH输出的高电平 
		Mem[23] = 8'h8d;
		Mem[24] = 8'ha4;	// 设置显示模式为正常模式，此时屏幕输出GDDRAM中的显示数据
		Mem[25] = 8'haf;	// 开启屏幕
    end

    always @(posedge clk) begin
        if(!re)
            data <= Mem[addr]; 
        else
            data <= 8'b0;
    end

endmodule
