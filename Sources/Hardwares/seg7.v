`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/13 21:49:22
// Design Name: 
// Module Name: seg7
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 7-segment display driver for 8 digits (common cathode)
// 
// Dependencies: seg7decimal module
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module seg7(
    input [31:0] x,
    input [7:0] aen,
    input [7:0] dp_en,
    input clk,
    input clr,
    output reg [7:0] a_to_g_0,
    output reg [7:0] a_to_g_1,
    output reg [7:0] an
);

    // Instance of seg7decimal for the first digit
    seg7decimal seg0 (
        .x(x[15:0]),          // 16-bit input for the first digit
        .aen(aen[3:0]),       // Enable signals for digits
        .dp_en(dp_en[3:0]),   // Decimal point enable signals
        .clk(clk),            // Clock signal
        .clr(clr),            // Clear signal
        .a_to_g(a_to_g_0[6:0]), // 7-segment display segments for the first digit
        .an(an[3:0]),           // Enable signal for the first digit
        .dp(a_to_g_0[7])      // Decimal point (always off)
    );

    // Instance of seg7decimal for the second digit
    seg7decimal seg1 (
        .x(x[31:16]),         // 16-bit input for the second digit
        .aen(aen[7:4]),       // Enable signals for digits
        .dp_en(dp_en[7:4]),   // Decimal point enable signals
        .clk(clk),            // Clock signal
        .clr(clr),            // Clear signal
        .a_to_g(a_to_g_1[6:0]), // 7-segment display segments for the second digit
        .an(an[7:4]),           // Enable signal for the second digit
        .dp(a_to_g_1[7])      // Decimal point (always off)
    );

endmodule


module seg7decimal(
    input [15:0] x,          // 16-bit input to display
    input [3:0] aen,        // Enable signals for digits
    input [3:0] dp_en,       // Decimal point enable signals
    input clk,               // Clock signal
    input clr,               // Clear signal
    output reg [6:0] a_to_g, // 7-segment display segments
    output reg [3:0] an,     // 4-digit enable signals
    output wire dp           // Decimal point (always off)
);

    wire [1:0] s;            // Select signal for digit multiplexing
    reg [3:0] digit;         // Current digit to display
    reg [19:0] clkdiv;       // Clock divider for multiplexing

    assign s = clkdiv[19:18];// Use the two MSBs of clkdiv for digit selection
    assign dp = dp_en[s]; // Assign decimal point enable signal based on selected digit

    // Select the current digit based on the clock divider
    always @(*) begin
        case (s)
            2'b00: digit = x[15:12]; // Select the most significant digit
            2'b01: digit = x[11:8];  // Select the second digit
            2'b10: digit = x[7:4];   // Select the third digit
            2'b11: digit = x[3:0];   // Select the least significant digit
            default: digit = 4'b0000;
        endcase
    end

    //decoder or truth-table for 7a_to_g display values
    always @(*) begin
        //////////<---MSB-LSB<---
        //////////////gfedcba////////////////////////////////////////////  
        //            ___
        //           | a |
        //          f|   |b
        //           |___|
        //           | g |
        //          e|   |c
        //           |___| 
        //             d
        //////////////////////////////////////////////
        case (digit)
             4'b0000: a_to_g = 7'b1111110; // 0
             4'b0001: a_to_g = 7'b0110000; // 1
             4'b0010: a_to_g = 7'b1101101; // 2
             4'b0011: a_to_g = 7'b1111001; // 3
             4'b0100: a_to_g = 7'b0110011; // 4
             4'b0101: a_to_g = 7'b1011011; // 5
             4'b0110: a_to_g = 7'b1011111; // 6
             4'b0111: a_to_g = 7'b1110000; // 7
             4'b1000: a_to_g = 7'b1111111; // 8
             4'b1001: a_to_g = 7'b1111011; // 9
             4'b1010: a_to_g = 7'b1110111; // A
             4'b1011: a_to_g = 7'b0011111; // B
             4'b1100: a_to_g = 7'b1001111; // C
             4'b1101: a_to_g = 7'b0111101; // D
             4'b1110: a_to_g = 7'b1001111; // E
             4'b1111: a_to_g = 7'b1000111; // F
             default: a_to_g = 7'b0000000; // Blank
        endcase
    end

    // Clock divider for digit multiplexing
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            clkdiv <= 0;     // Reset clock divider
        end else begin
            clkdiv <= clkdiv + 1; // Increment clock divider
        end
    end

    // Enable signals for 4 digits (common cathode)
    always @(*) begin
        an=4'b0000;
        an[s] = aen[s];
    end

endmodule
