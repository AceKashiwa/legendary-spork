`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/17 22:55:05
// Design Name: 
// Module Name: timer_hms
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


module timer_hms(
    input clk,           // 100MHz clock
    input rst_n,         // 低有效复位
    output reg [31:0] hms_hex // 8位16进制数，00HHMMSS
);

    reg [26:0] cnt_1s;      // 计数1秒，100_000_000-1
    reg [7:0] sec;
    reg [7:0] min;
    reg [7:0] hour;

    // 1秒计数器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_1s <= 0;
        else if (cnt_1s == 100_000_000 - 1)
            cnt_1s <= 0;
        else
            cnt_1s <= cnt_1s + 1;
    end

    // 时分秒计数
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sec  <= 0;
            min  <= 0;
            hour <= 0;
        end else if (cnt_1s == 100_000_000 - 1) begin
            if (sec == 59) begin
                sec <= 0;
                if (min == 59) begin
                    min <= 0;
                    if (hour == 23)
                        hour <= 0;
                    else
                        hour <= hour + 1;
                end else
                    min <= min + 1;
            end else
                sec <= sec + 1;
        end
    end

    function [7:0] to_bcd(input [7:0] bin);
        to_bcd = { (bin / 10), (bin % 10) };
    endfunction

    // 输出格式：00HHMMSS（每字节为BCD）
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            hms_hex <= 32'h00000000;
        else
            hms_hex <= {8'h00, to_bcd(hour), to_bcd(min), to_bcd(sec)};
    end

endmodule
