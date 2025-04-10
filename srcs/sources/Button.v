`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/22 19:59:55
// Design Name: 
// Module Name: Button
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

module Button(
    input clk, reset, button_in,
    output button_out
    );
    
    // 两级触发器，消除亚稳态
    reg button, btemp;
    always @ (posedge clk) begin
        {button, btemp} <= {btemp, button_in};
    end

    wire bpressed;
    // 按键去抖动
    debounce d1(
        .reset(reset),
        .clk(clk),
        .noisy(button),
        .clean(bpressed)
    );

    // 脉宽变换
    reg q;
    assign button_out = bpressed & ~q;
    always @ (posedge clk) begin
        q <= bpressed;
    end
endmodule

module debounce(
    input reset, clk, noisy,
    output reg clean
    );

    parameter NDELAY = 650000;
    parameter NBITS = 20;

    reg [NBITS-1:0] count;
    reg xnew;

    always @ (posedge clk) begin
        if (reset) begin
            xnew <= noisy;
            clean <= noisy;
            count <= 0;
        end else if (noisy != xnew) begin
            xnew <= noisy;
            count <= 0;
        end else if (count == NDELAY) begin
            clean <= xnew;
        end else begin
            count <= count + 1;
        end
    end
endmodule
