module slave(
    input clk,
    input shift_clk_en, // 来自主控的同步信号
    input serial_in,    // 来自前一级的输出
    output reg [7:0] leds,
    output reg serial_out // 输出到下一级
);

    reg [7:0] shift_reg;
    reg prev_shift_clk_en;

    // 检测shift_clk_en的上升沿
    always @(posedge clk) begin
        prev_shift_clk_en <= shift_clk_en;
    end

    // 移位逻辑
    always @(posedge clk) begin
        if (shift_clk_en && !prev_shift_clk_en) begin
            // 移入前一级的数据到最低位
            shift_reg <= {shift_reg[6:0], serial_in};
            serial_out <= shift_reg[7]; // 输出最高位到下一级
            leds <= shift_reg; // 更新LED显示
        end
    end

    initial begin
        shift_reg = 8'b00000000; // 初始化为全灭
        leds = 8'b00000000;
        serial_out=0;
    end

endmodule