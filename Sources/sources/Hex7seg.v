`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/24 00:59:01
// Design Name: 
// Module Name: Hex7seg
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

module Hex7seg(
    input clk,
    input reset,
    input [31:0] hex,
    output [6:0] a_to_g0,
    output [6:0] a_to_g1,
    output [7:0] an
    );

    Hex7segIndex hex7segindex0(
        .hex(hex[15:0]),
        .clk(clk),
        .reset(reset),
        .a_to_g(a_to_g0),
        .an(an[3:0])
    );
    
    Hex7segIndex hex7segindex1(
        .hex(hex[31:16]),
        .clk(clk),
        .reset(reset),
        .a_to_g(a_to_g1),
        .an(an[7:4])
    );
endmodule

module Hex7segIndex(
    input [15:0] hex,
    input clk,
    input reset,
    output reg [6:0] a_to_g,
    output reg [3:0] an
    );

    wire [1:0] s;
    reg [3:0] digit;
    reg [19:0] clkdiv;
    assign s = clkdiv[19:18];

    always @ (*) begin
        case (s)
            2'b00: digit = hex[3:0];
            2'b01: digit = hex[7:4];
            2'b10: digit = hex[11:8];
            2'b11: digit = hex[15:12];
            default: digit = hex[3:0];
        endcase
    end

    always @(*) begin
        case (digit)
            4'b0000: a_to_g = 7'b1111110;
            4'b0001: a_to_g = 7'b0110000;
            4'b0010: a_to_g = 7'b1101101;
            4'b0011: a_to_g = 7'b1111001;
            4'b0100: a_to_g = 7'b0110011;
            4'b0101: a_to_g = 7'b1011011;
            4'b0110: a_to_g = 7'b1011111;
            4'b0111: a_to_g = 7'b1110000;
            4'b1000: a_to_g = 7'b1111111;
            4'b1001: a_to_g = 7'b1111011;
            4'b1010: a_to_g = 7'b1110111;
            4'b1011: a_to_g = 7'b0011111;
            4'b1100: a_to_g = 7'b1001111;
            4'b1101: a_to_g = 7'b0111101;
            4'b1110: a_to_g = 7'b1001111;
            4'b1111: a_to_g = 7'b1000111;
            default: a_to_g = 7'b0000000;
        endcase
    end
    
    always @ (*) begin
        an = 4'b0000;
        an[s] = 1;
    end
        
    always @ (posedge clk or posedge reset) begin
        if (reset)
            clkdiv <= 0;
        else
            clkdiv <= clkdiv + 1;
    end
endmodule