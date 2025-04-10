`timescale 1ns/1ps

module stream_tb;

    // Inputs
    reg clk;
    reg reset;
    reg start;
    // reg last_state; // Temporarily disabled
    reg next_state;

    // Outputs
    wire [7:0] LED;
    wire state;

    // Instantiate the Unit Under Test (UUT)
    stream uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .last_state(1'b0), // Set last_state to 0 (disabled)
        .next_state(next_state),
        .LED(LED),
        .state(state)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period -> 100 MHz
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        start = 0;
        // last_state = 0; // Temporarily disabled
        next_state = 0;

        // Wait for global reset
        #100;

        // Release reset
        reset = 0;

        // Test case 1: Activate start and next_state
        start = 1;
        next_state = 1;
        #50;

        // Deactivate start
        start = 0;
        #100;

        // Test case 2: Observe LED shifting
        repeat (10) begin
            #100;
        end

        // Apply reset again
        reset = 1;
        #10;
        reset = 0;

        // Wait and finish simulation
        #2000;
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | reset: %b | start: %b | next_state: %b | LED: %b | state: %b", 
                 $time, reset, start, next_state, LED, state);
    end

endmodule