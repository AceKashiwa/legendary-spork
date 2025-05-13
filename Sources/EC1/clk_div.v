module clk_div(
    input clk,          // 输入时钟信号
    input reset,        // 复位信号
    output reg clk_2s   // 输出慢时钟信号
);
    reg [31:0] counter;

    parameter DIV_VALUE = 25000000;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_2s <= 0;
        end else begin
            if (counter == DIV_VALUE - 1) begin
                counter <= 0;
                clk_2s <= ~clk_2s; // 翻转慢时钟信号
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule