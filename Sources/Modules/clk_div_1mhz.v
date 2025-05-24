// 弃用
module clk_div_1mhz(
    input clk_100m,      // 100MHz 输入时钟
    input rst_n,         // 复位，低有效
    output reg clk_1m    // 1MHz 输出时钟
);

    reg [6:0] cnt;       // 计数器，最大值49

    always @(posedge clk_100m or negedge rst_n) begin
        if(!rst_n) begin
            cnt <= 0;
            clk_1m <= 0;
        end else begin
            if(cnt == 49) begin
                cnt <= 0;
                clk_1m <= ~clk_1m;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end

endmodule