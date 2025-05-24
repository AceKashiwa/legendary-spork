`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/19 15:02:09
// Design Name: 
// Module Name: oled_driver_adc
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


module oled_driver_adc #(
	parameter CMD_WIDTH = 8,   		// LCD命令宽度
    parameter CMD_DEPTH = 5'd25, 	// LCD初始化的命令的数量
    parameter CHAR_WIDTH = 40,		// 一个文字的数据宽度
    parameter CHAR_DEPTH = 7'd123	// 文字库数量
)(
	input sys_clk,
	input rst_n,
	input [7:0] oled_display_digital, 	// 两位ADC数据（一位小数）
	output reg oled_csn,	//OLCD液晶屏使能
	output reg oled_rst,	//OLCD液晶屏复位
	output reg oled_dcn,	//OLCD数据指令控制
	output reg oled_clk,	//OLCD时钟信号
	output reg oled_data	//OLCD数据信号
);
	localparam IDLE = 3'b0, MAIN = 3'b1, INIT = 3'b10;
	localparam SCAN = 3'b11, WRITE = 3'b100, DELAY = 3'b101;
	localparam HIGH	= 1'b1, LOW = 1'b0;
	localparam DATA	= 1'b1, CMD = 1'b0;

    wire [CMD_WIDTH-1:0]  cmd_out;   // cmd_RAM输出的8位命令
    wire [CHAR_WIDTH-1:0] char_out;   // data_RAM输出的40位文字

    reg [7:0] wr_reg;
	reg	[7:0] ypage, xpage_high, xpage_low;   // 位置
	reg	[(8*21-1):0] char;  // 字符串
	reg	[4:0] char_num;   // 文字个数 最多16
    reg [4:0] cmd_addr;
    reg [7:0] char_addr;
	reg	[2:0] cnt_main;
	reg [2:0] cnt_init;
	reg [3:0] cnt_scan;
	reg	[4:0] cnt_write;
	reg	[14:0]num_delay, cnt_delay;
	reg	[2:0] state, state_last;

    oled_cmd_RAM #(
        .RAM_WIDTH(CMD_WIDTH),
        .RAM_DEPTH(CMD_DEPTH),
        .ADDR_WIDTH(5)
    ) CMD_RAM(
        .clk(sys_clk),
        .rst_n(rst_n),
        .re(oled_dcn),
        .addr(cmd_addr),
        .data(cmd_out)
    );

    oled_char_RAM #(
        .RAM_WIDTH(CHAR_WIDTH),
        .RAM_DEPTH(CHAR_DEPTH),
        .ADDR_WIDTH(8)
    ) CHAR_RAM(
        .clk(sys_clk),
        .rst_n(rst_n),
        .re(oled_dcn),
        .addr(char_addr),
        .data(char_out)
    );
 
	always @(posedge sys_clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt_main <= 1'b0; 
            cnt_init <= 1'b0; 
            cnt_scan <= 1'b0; 
            cnt_write <= 1'b0;
			wr_reg <= 1'b0;
			ypage <= 1'b0;
            xpage_high <= 1'b0; 
            xpage_low <= 1'b0;
			char <= 1'b0; 
			char_num <= 1'b0;
            cmd_addr <= 1'b0;
            char_addr <= 1'b0;
			num_delay <= 15'd5; 
            cnt_delay <= 1'b0; 
			oled_csn <= HIGH; 
            oled_rst <= HIGH; 
            oled_dcn <= CMD; 
            oled_clk <= HIGH; 
            oled_data <= LOW;
			state <= IDLE; 
            state_last <= IDLE;
		end 
        else begin
			case(state)
				IDLE: begin
					cnt_main <= 1'b0; 
					cnt_init <= 1'b0; 
					cnt_scan <= 1'b0; 
					cnt_write <= 1'b0;
					wr_reg <= 1'b0;
					ypage <= 1'b0;
					xpage_high <= 1'b0; 
					xpage_low <= 1'b0;
					char <= 1'b0; 
					char_num <= 1'b0; 
					cmd_addr <= 1'b0;
					char_addr <= 1'b0;
					num_delay <= 15'd5; 
					cnt_delay <= 1'b0; 
					oled_csn <= HIGH; 
					oled_rst <= HIGH; 
					oled_dcn <= CMD; 
					oled_clk <= HIGH; 
					oled_data <= LOW;
					state <= MAIN; 
					state_last <= MAIN;
				end

				MAIN: begin
					if(cnt_main >= 3'd6)
						cnt_main <= 3'd5;
					else 
						cnt_main <= cnt_main + 1'b1;
					case(cnt_main)	//MAIN状态
						3'd0: begin state <= INIT; end
						3'd1: begin ypage <= 8'hb0; xpage_high <= 8'h10; xpage_low <= 8'h00; char_num <= 5'd16; char <= "ADC DATA DISPLAY";state <= SCAN; end
						3'd2: begin ypage <= 8'hb1; xpage_high <= 8'h10; xpage_low <= 8'h00; char_num <= 5'd16; char <= "VOLTAGE:   . V  ";state <= SCAN; end
						3'd3: begin ypage <= 8'hb2; xpage_high <= 8'h10; xpage_low <= 8'h00; char_num <= 5'd16; char <= "AUTHOR: ZIRU PAN";state <= SCAN; end
						3'd4: begin ypage <= 8'hb3; xpage_high <= 8'h10; xpage_low <= 8'h00; char_num <= 5'd16; char <= "                ";state <= SCAN; end
						3'd5: begin ypage <= 8'hb1; xpage_high <= 8'h15; xpage_low <= 8'h00; char_num <= 5'd1 ; char <= oled_display_digital[7:4]; state <= SCAN; end
						3'd6: begin ypage <= 8'hb1; xpage_high <= 8'h16; xpage_low <= 8'h00; char_num <= 5'd1 ; char <= oled_display_digital[3:0]; state <= SCAN; end
						default: state <= IDLE;
					endcase
				end

				INIT: begin	//初始化状态
					case(cnt_init)
						5'd0: begin 
								oled_rst <= LOW; 
								cnt_init <= cnt_init + 1'b1; 
							end	//复位有效
						5'd1: begin 
								num_delay <= 15'd25000; 
								state <= DELAY; 
								state_last <= INIT; 
								cnt_init <= cnt_init + 1'b1; 
							end	//延时大于3us
						5'd2: begin 
								oled_rst <= HIGH; 
								cnt_init <= cnt_init + 1'b1; 
							end	//复位恢复
						5'd3: begin 
								num_delay <= 15'd25000; 
								state <= DELAY; 
								state_last <= INIT; 
								cnt_init <= cnt_init + 1'b1; 
							end	//延时大于220us
						5'd4: begin 
								if(cmd_addr >= CMD_DEPTH) begin
									cmd_addr <= 1'b0;
									cnt_init <= cnt_init + 1'b1;
								end 
								else begin	
									cmd_addr <= cmd_addr + 1'b1; 
									num_delay <= 15'd5;
									oled_dcn <= CMD; 
									wr_reg <= cmd_out;
									state <= WRITE; 
									state_last <= INIT;
								end
							end
						5'd5: begin 
							cnt_init <= 1'b0; 
							state <= MAIN; 
						end
						default: state <= IDLE;
					endcase
				end
				
				SCAN: begin
					if(cnt_scan == 4'd12) begin
						if(char_num) 
							cnt_scan <= 4'd3;
						else 
							cnt_scan <= cnt_scan + 1'b1;
					end 
					else if(cnt_scan == 4'd13) 
						cnt_scan <= 4'd0;
					else 
						cnt_scan <= cnt_scan + 1'b1;
					case(cnt_scan)
						4'd0: begin oled_dcn <= CMD; wr_reg <= ypage; state <= WRITE; state_last <= SCAN; end    	//定位列页地址
						4'd1: begin oled_dcn <= CMD; wr_reg <= xpage_low; state <= WRITE; state_last <= SCAN; end	//定位行地址低位
						4'd2: begin oled_dcn <= CMD; wr_reg <= xpage_high; state <= WRITE; state_last <= SCAN; end	//定位行地址高位
						4'd3: begin char_num <= char_num - 1'b1; end
						4'd4: begin char_addr <= char[(char_num*8)+:8]; end
						4'd5: begin oled_dcn <= DATA; wr_reg <= 8'h00; state <= WRITE; state_last <= SCAN; end	//5*8点阵变成8*8
						4'd6: begin oled_dcn <= DATA; wr_reg <= 8'h00; state <= WRITE; state_last <= SCAN; end	//5*8点阵变成8*8
						4'd7: begin oled_dcn <= DATA; wr_reg <= 8'h00; state <= WRITE; state_last <= SCAN; end	//5*8点阵变成8*8
						4'd8: begin oled_dcn <= DATA; wr_reg <= char_out[39:32]; state <= WRITE; state_last <= SCAN; end
						4'd9: begin oled_dcn <= DATA; wr_reg <= char_out[31:24]; state <= WRITE; state_last <= SCAN; end
						4'd10:begin oled_dcn <= DATA; wr_reg <= char_out[23:16]; state <= WRITE; state_last <= SCAN; end
						4'd11:begin oled_dcn <= DATA; wr_reg <= char_out[15:8] ; state <= WRITE; state_last <= SCAN; end
						4'd12:begin oled_dcn <= DATA; wr_reg <= char_out[7:0]  ; state <= WRITE; state_last <= SCAN; end
						4'd13:begin state <= MAIN; end
						default: state <= IDLE;
					endcase
				end

				WRITE: begin	//WRITE状态，将数据按照SPI时序发送给屏幕
					if(cnt_write >= 5'd17) 
						cnt_write <= 5'd0;
					else 
						cnt_write <= cnt_write + 1'b1;
					case(cnt_write)
						5'd0: begin oled_csn <= LOW; end	//9位数据最高位为命令数据控制位
						5'd1: begin oled_clk <= LOW; oled_data <= wr_reg[7]; end	//先发高位数据
						5'd2: begin oled_clk <= HIGH; end
						5'd3: begin oled_clk <= LOW; oled_data <= wr_reg[6]; end
						5'd4: begin oled_clk <= HIGH; end
						5'd5: begin oled_clk <= LOW; oled_data <= wr_reg[5]; end
						5'd6: begin oled_clk <= HIGH; end
						5'd7: begin oled_clk <= LOW; oled_data <= wr_reg[4]; end
						5'd8: begin oled_clk <= HIGH; end
						5'd9: begin oled_clk <= LOW; oled_data <= wr_reg[3]; end
						5'd10:begin oled_clk <= HIGH; end
						5'd11:begin oled_clk <= LOW; oled_data <= wr_reg[2]; end
						5'd12:begin oled_clk <= HIGH; end
						5'd13:begin oled_clk <= LOW; oled_data <= wr_reg[1]; end
						5'd14:begin oled_clk <= HIGH; end
						5'd15:begin oled_clk <= LOW; oled_data <= wr_reg[0]; end	//后发低位数据
						5'd16:begin oled_clk <= HIGH; end
						5'd17:begin oled_csn <= HIGH; state <= DELAY; end
						default: state <= IDLE;
					endcase
				end

				DELAY: begin
					if(cnt_delay >= num_delay) begin
						cnt_delay <= 15'd0; 
						state <= state_last; 
					end 
					else 
						cnt_delay <= cnt_delay + 1'b1;
				end

				default: state <= IDLE;
			endcase
		end
	end
endmodule
