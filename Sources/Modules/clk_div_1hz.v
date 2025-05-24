// 弃用
module clk_div_1hz(
    input clk_100m,      // 100MHz 输入时钟
    input rst_n,         // 低有效复位
    output reg clk_1hz   // 1Hz 输出时钟
);

    reg [26:0] cnt;

    always @(posedge clk_100m or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_1hz <= 0;
        end else if (cnt == 100_000_000/2 - 1) begin
            cnt <= 0;
            clk_1hz <= ~clk_1hz;
        end else begin
            cnt <= cnt + 1;
        end
    end

endmodule