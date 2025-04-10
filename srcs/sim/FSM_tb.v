`timescale 1ns / 1ps

module FSM_tb;
    reg clk;
    reg reset;
    wire [6:0] a_to_g0;
    wire [6:0] a_to_g1;
    wire [7:0] an;

    // Instantiate the top module
    top uut (
        .s(1'b1), // Assuming 's' is not used in the testbench
        .clk(clk),
        .reset(reset),
        .a_to_g0(a_to_g0),
        .a_to_g1(a_to_g1),
        .an(an)
    );

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Apply reset
        #10 reset = 0;

        // Test case 1: Normal operation
        #1000000; // Wait for some time to observe the behavior

        // Test case 2: Apply reset again
        #10 reset = 1;
        #10 reset = 0;

        // Finish simulation
        #1000000 $finish;
    end

    always #5 clk = ~clk; // Clock generation

    initial begin
        // Monitor signals
        $monitor("Time: %0t | reset: %b | a_to_g0: %b | a_to_g1: %b | an: %b", 
                 $time, reset, a_to_g0, a_to_g1, an);
    end

endmodule