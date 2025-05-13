module master(
    input clk,
    input serial_in,    // 来自从板2的输出
    output reg [7:0] leds,
    output reg serial_out, // 输出到从板1
    output reg shift_clk_en1, // 移位使能信号，连接到所有从板
    output reg shift_clk_en2 // 移位使能信号，连接到所有从板
);

    reg [30:0] counter;
    reg [7:0] shift_reg;

    // 生成1Hz的shift_clk_en信号
    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 50_000_000) begin // 假设时钟为100MHz
            shift_clk_en1 <= 1'b1;
            shift_clk_en2 <= 1'b1;
            counter <= 0;
        end else begin
            shift_clk_en1 <= 1'b0;
            shift_clk_en2 <= 1'b0;
        end
    end

    // 移位逻辑
    always @(posedge clk) begin
        if (shift_clk_en1) begin
            // 移入来自从板2的数据到最低位
            shift_reg <= {shift_reg[6:0], serial_in};
            serial_out <= shift_reg[7]; // 输出最高位到从板1
            leds <= shift_reg; // 更新LED显示
        end
    end

    initial begin
        shift_reg = 8'b00000001; // 初始点亮第一个LED
        leds = 8'b00000000;
    end

endmodule