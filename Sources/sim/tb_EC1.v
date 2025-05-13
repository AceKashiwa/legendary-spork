`timescale 1ns / 1ps

module tb_EC1;
    reg [7:0] A;
    reg clk;
    reg Reset;

    wire [7:0] led;
    wire H;

    EC1 uut (
        .A(A),
        .clk(clk),
        .Reset(Reset),
        .led(led),
        .H(H)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        A = 8'b00000000;
        Reset = 1;

        #50 Reset = 0; A = 8'b00000001;
        #500 Reset = 1; #50 Reset = 0; A = 8'b00000010;
        #500 Reset = 1; #50 Reset = 0; A = 8'b00000011;
        #500 Reset = 1; #50 Reset = 0; A = 8'b00000100;
        #500 Reset = 1; #50 Reset = 0; A = 8'b11111111;
        #1000;
        $stop;
    end
endmodule