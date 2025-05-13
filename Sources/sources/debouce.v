`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Button debounce module
// 
// Dependencies: 
// 
// Revision:
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module debounce(
    input wire reset,       // Reset signal
    input wire clk,         // Clock signal
    input wire button_in,   // Noisy button input
    output reg button_out   // Debounced button output
);

    parameter DEBOUNCE_DELAY = 10; // Number of clock cycles for debounce delay
    parameter COUNTER_BITS = 20;  // Number of bits for the counter

    reg [COUNTER_BITS-1:0] debounce_counter; // Counter for debounce delay
    reg button_state;                        // Current stable button state

    always @ (posedge clk)
    begin
        if (reset)
        begin
            button_state <= button_in;       // Initialize button state
            button_out <= 0;        // Initialize debounced output
            debounce_counter <= 0;          // Reset debounce counter
        end
        else if (button_in != button_state)
        begin
            button_state <= button_in;      // Update button state
            debounce_counter <= 0;          // Reset debounce counter
        end
        else if (debounce_counter == DEBOUNCE_DELAY)
            button_out <= button_state;     // Update debounced output
        else
            debounce_counter <= debounce_counter + 1; // Increment counter
    end
endmodule