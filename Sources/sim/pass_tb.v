`timescale 1ns/1ps

module pass_tb;

    // Inputs
    reg clk;
    reg reset_local;
    reg reset_pass;
    reg in;

    // Outputs
    wire passreset;
    wire out;
    wire [7:0] LED;

    // Instantiate the Unit Under Test (UUT)
    pass uut (
        .clk(clk),
        .reset_local(reset_local),
        .reset_pass(reset_pass),
        .in(in),
        .passreset(passreset),
        .out(out),
        .LED(LED)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period -> 100 MHz
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset_local = 1;
        reset_pass = 0;
        in = 0;

        // Wait for global reset
        #100;

        // Release reset
        reset_local = 0;

        // Test case 1: Shift in a sequence of bits
        in = 1;
        #500_000_000; // Wait for 500ms
        in = 0;
        #500_000_000; // Wait for 500ms
        in = 1;
        #500_000_000; // Wait for 500ms
        in = 1;
        #500_000_000; // Wait for 500ms

        // Test case 2: Apply reset_local
        reset_local = 1;
        #100;
        reset_local = 0;

        // Test case 3: Observe LED shifting
        repeat (10) begin
            #500_000_000; // Wait for 500ms
        end

        // Finish simulation
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | reset_local: %b | reset_pass: %b | in: %b | passreset: %b | out: %b | LED: %b", 
                 $time, reset_local, reset_pass, in, passreset, out, LED);
    end

endmodule