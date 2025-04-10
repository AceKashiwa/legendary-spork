module led_shift_core #(parameter NUM = 4) (
    input clk,
    input rst_n,
    output reg [NUM*8-1:0] led_all  // 总共 NUM 块板的 LED 数据
);

    reg [25:0] cnt;  // 时钟计数器，用于分频
    wire clk_div;

    // 简单时钟分频
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 0;
        else
            cnt <= cnt + 1'b1;
    end

    assign clk_div = cnt[25];  // 每 2^26 个时钟周期产生一个新的时钟

    // 流水灯移位逻辑
    always @(posedge clk_div or negedge rst_n) begin
        if (!rst_n)
            led_all <= {NUM{8'b00000001}};  // 初始化为第一块板第一个 LED 点亮
        else
            led_all <= {led_all[NUM*8-9:0], led_all[NUM*8-1:NUM*8-8]};  // 往右移
    end

endmodule
