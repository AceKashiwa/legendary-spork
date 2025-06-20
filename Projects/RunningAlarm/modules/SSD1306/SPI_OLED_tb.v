`timescale 1ns/1ps

module SPI_OLED_tb;

reg clk_in;
reg rst_in;
reg key;
wire oled_SCL;
wire oled_SDA;
wire oled_RES;
wire oled_DC;

// 实例化被测模块
SPI_OLED dut (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .key(key),
    .oled_SCL(oled_SCL),
    .oled_SDA(oled_SDA),
    .oled_RES(oled_RES),
    .oled_DC(oled_DC)
);

reg clk_display;

// 生成主时钟 100MHz
initial begin
    clk_in = 0;
    forever #5 clk_in = ~clk_in;
end

// 生成显示采样时钟，180度相位差
initial begin
    clk_display = 0;
    #2.5;
    forever #5 clk_display = ~clk_display;
end

// 仿真流程
initial begin
    rst_in = 0;
    key = 0;         // 初始为未按下（高电平）
    #100;            // 100ns复位
    rst_in = 1;
    #3500;            // 等待DUT复位完成

    key = 1;
    #500;
    key = 0;

    #5000;

    $stop;
end

integer fp;
initial begin
    fp = $fopen("spi_output.txt", "w");
end

// 采样输出
always @(posedge clk_display) begin
    if ($time >= 600000 && $time <= 640000) begin // $time单位为ns，可根据需要调整
        $fdisplay(fp, "%t ns: SCL=%b SDA=%b RES=%b DC=%b", $time, oled_SCL, oled_SDA, oled_RES, oled_DC);
    end
end

endmodule