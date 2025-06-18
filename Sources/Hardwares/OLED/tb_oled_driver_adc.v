`timescale 1ns / 1ps

module tb_oled_driver_adc;

    reg sys_clk;
    reg rst_n;
    reg [7:0] oled_display_digital;
    wire oled_csn;
    wire oled_rst;
    wire oled_dcn;
    wire oled_clk;
    wire oled_data;

    // 实例化待测模块
    oled_driver_adc uut (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .oled_display_digital(oled_display_digital),
        .oled_csn(oled_csn),
        .oled_rst(oled_rst),
        .oled_dcn(oled_dcn),
        .oled_clk(oled_clk),
        .oled_data(oled_data)
    );

    // 时钟生成
    initial sys_clk = 0;
    always #5 sys_clk = ~sys_clk; // 100MHz

    initial begin
        // 初始化输入
        rst_n = 0;
        oled_display_digital = 8'h00;

        // 复位
        #20;
        rst_n = 1;

        // 输入不同的ADC显示数据
        #50;
        oled_display_digital = 8'h45; // 4.5

        #100;
        oled_display_digital = 8'h99; // 9.9

        #100;
        oled_display_digital = 8'h12; // 1.2

        #200;
        $stop;
    end

endmodule