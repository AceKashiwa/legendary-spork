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


module blank(
    // I/O definitions
    );
    // 行为代码
endmodule



module top(
    input clk,
    input reset,
    input S,
    output [1:0] L
    );
    
    wire clk_ms;
    reg [25:0] count;
    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 26'h0000000;
        else
            count <= count + 1;
    end
    assign clk_ms = count[25];  // ~= 0.671ms

    wire clk_3;
    div3 d(.clk(clk_ms), .reset(reset), .clk_3(clk_3));

    assign L = S ? 2'b00 : {clk_3 ,clk_ms};
endmodule

module div2(
    input clk,
    input reset,
    output reg clk_2
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_2 <= 1'b0;
        end else begin
            clk_2 <= clk_2 + 1;
        end
    end
endmodule

module div10(
    input clk,
    input reset,
    output reg clk_10
    );

    reg [2:0] count;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b000;
            clk_10 <= 1'b0;
        end else if (count[2] == 1'b1) begin
            count[2] <= 1'b0;
            clk_10 <= ~clk_10;
        end else begin
            count <= count + 1;
        end
    end
endmodule

module div3(
    input clk,
    input reset,
    output reg clk_3
    );

    reg count_p, count_n;

    always @(posedge clk) begin
        if (reset) begin
            count_p <= 1'b0;
        end else if (count_p == 1'b1) begin
            count_p <= 1'b0;
        end else begin
            count_p <= count_n + 1;
        end
    end

    always @(negedge clk) begin
        if (reset) begin
            count_n <= 1'b0;
        end else if (count_n == 1'b1) begin
            count_n <= 1'b0;
        end else begin
            count_n <= count_p + 1;
        end
    end

    assign up = count_p | count_n;
    always @(posedge up or posedge reset) begin
        if (reset) begin
            clk_3 <= 1'b0;
        end else begin
            clk_3 <= ~clk_3;
        end
    end
endmodule

// testbench for div2, div10, and div3 modules
module tb_divider;
    reg clk;
    reg reset;
    wire clk_2;
    wire clk_10;
    wire clk_3;

    div2 uut_div2 (
        .clk(clk),
        .reset(reset),
        .clk_2(clk_2)
    );

    div10 uut_div10 (
        .clk(clk),
        .reset(reset),
        .clk_10(clk_10)
    );

    div3 uut_div3 (
        .clk(clk),
        .reset(reset),
        .clk_3(clk_3)
    );

    initial begin
        clk = 0;
        reset = 1;
        #20 reset = 0; // Release reset after 5 time units
    end

    always #5 clk = ~clk; // Generate clock signal with a period of 10 time units
endmodule
