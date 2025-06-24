`timescale 1ns/1ps

module tb_oled_time_display;
    reg         clk;
    reg         rst_n;
    reg [23:0]  curr_time;
    reg [23:0]  alarm_time;
    reg [15:0]  wake_time;
    reg [111:0] wake_time_hist;
    reg [15:0]  dis;           // 新增：测距距离
    reg [2:0]   dir;           // 新增：方向控制
    wire [1343:0] str_data;

    // 实例化待测模块
    oled_time_display dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .curr_time     (curr_time),
        .alarm_time    (alarm_time),     // 之前写错为alarm_time，应该保持一致
        .wake_time     (wake_time),
        .wake_time_hist(wake_time_hist),
        .dis          (dis),             // 新增：测距距离
        .dir          (dir),             // 新增：方向控制
        .str_data     (str_data)
    );

    // 时钟生成
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz

    // 方向状态定义（与被测模块保持一致）
    localparam STOP    = 3'b000;
    localparam FORWARD = 3'b001;
    localparam BACK    = 3'b010;
    localparam LEFT    = 3'b011;
    localparam RIGHT   = 3'b100;

    initial begin
        // 初始化输入
        rst_n = 0;
        curr_time = 24'h235959;      // 23:59:59
        alarm_time = 24'h070000;     // 07:00:00
        wake_time = 16'd120;         // 120秒
        wake_time_hist = {
            16'd100, 16'd110, 16'd120, 16'd130, 16'd140, 16'd150, 16'd160
        };
        dis = 16'd20;               // 20cm
        dir = STOP;                 // 初始停止状态

        #20;
        rst_n = 1;
        
        // 测试不同方向显示
        #20 dir = FORWARD;
        #20 dir = BACK;
        #20 dir = LEFT;
        #20 dir = RIGHT;
        
        // 测试不同距离显示
        #20 dis = 16'd10;
        #20 dis = 16'd50;
        #20 dis = 16'd99;
        
        #100;
        $stop;
    end

    // 添加显示监视
    initial begin
        $monitor("Time=%0t dir=%b dis=%0d", $time, dir, dis);
    end

    // 文件输出部分
    integer f;
    initial begin
        f = $fopen("oled_str_data_bin.txt", "w");
        #80; // 等待数据稳定
        $fdisplay(f, "%b", str_data);
        $fclose(f);
    end

endmodule