`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Create Date: 2025/06/21 13:18:13
// Module Name: core
//////////////////////////////////////////////////////////////////////////////////

module core(
    // 时钟和复位信号
    input sys_clk_in,
    input sys_rst_n,

    // 蓝牙
    input BT_Uart_rxd,
    output BT_Uart_txd,
    output [4:0] bt_ctrl_o,

    // 按键
    input [4:0] btn_pin,

    // 开关
    input [7:0] sw_pin,
    input [7:0] dip_pin,

    // LED
    output [15:0] led_pin,

    // seg7
    output [7:0] seg_cs_pin,
    output [7:0] seg_data_0_pin,
    output [7:0] seg_data_1_pin,

    // 音频
    output audio_pwm_o,
    output audio_sd_o,

    // pmod
    inout [31:0] exp_io
);

    // ========= 常量定义 =========
    localparam STOP    = 3'b000;
    localparam FORWARD = 3'b001;
    localparam BACK    = 3'b010;
    localparam LEFT    = 3'b011;
    localparam RIGHT   = 3'b100;

    localparam CMD_SET_TIME      = 8'h01;
    localparam CMD_SET_ALARM     = 8'h02;
    localparam CMD_ALARM_OFF     = 8'h0B;
    localparam CMD_ALARM_UNLOCK  = 8'h0C;

    // ========= 超声波相关 =========
    wire [15:0] dis;
    reg  trig_out_en = 1'b1;
    wire trig, echo;

    assign exp_io[0]  = trig_out_en ? trig : 1'bz;
    assign exp_io[1]  = 1'bz;
    assign trig       = exp_io[0];
    assign echo       = exp_io[1];

    HC_SR04 u_HC_SR04(
        .clk   (sys_clk_in),
        .rst_n (sys_rst_n),
        .echo  (echo),
        .trig  (trig),
        .dis   (dis)
    );

    // ========= OLED接口 =========
    wire SCL, SDA, RES, DC;
    reg  scl_out_en = 1'b1, sda_out_en = 1'b1, res_out_en = 1'b1, dc_out_en = 1'b1;
    wire scl_out, sda_out, res_out, dc_out;

    assign exp_io[31] = scl_out_en ? scl_out : 1'bz;
    assign SCL        = exp_io[31];
    assign exp_io[30] = sda_out_en ? sda_out : 1'bz;
    assign SDA        = exp_io[30];
    assign exp_io[29] = res_out_en ? res_out : 1'bz;
    assign RES        = exp_io[29];
    assign exp_io[28] = dc_out_en ? dc_out : 1'bz;
    assign DC         = exp_io[28];

    // ========= 传感器 =========
    wire sensor_back, sensor_front;
    assign exp_io[15] = 1'bz;
    assign sensor_back = exp_io[15];
    assign exp_io[14] = 1'bz;
    assign sensor_front = exp_io[14];

    // ========= 蜂鸣器 =========
    wire buzz_out, buzz_out_en;
    assign exp_io[16] = buzz_out_en ? buzz_out : 1'bz;
    wire buzz = exp_io[16];

    // ========= L298N H桥 =========
    wire IN1, IN2, IN3, IN4;
    wire ENA, ENB;
    reg  in1_out_en = 1'b1, in2_out_en = 1'b1, in3_out_en = 1'b1, in4_out_en = 1'b1;
    reg  ena_out_en = 1'b1, enb_out_en = 1'b1;
    wire in1_out, in2_out, in3_out, in4_out;
    wire ena_out, enb_out;

    assign exp_io[23] = in1_out_en ? in1_out : 1'bz;
    assign IN1 = exp_io[23];
    assign exp_io[24] = in2_out_en ? in2_out : 1'bz;
    assign IN2 = exp_io[24];
    assign exp_io[25] = in3_out_en ? in3_out : 1'bz;
    assign IN3 = exp_io[25];
    assign exp_io[26] = in4_out_en ? in4_out : 1'bz;
    assign IN4 = exp_io[26];
    assign exp_io[7]  = ena_out_en ? ena_out : 1'bz;
    assign ENA = exp_io[7];
    assign exp_io[10] = enb_out_en ? enb_out : 1'bz;
    assign ENB = exp_io[10];

    // ========= 蓝牙控制信号 =========
    assign bt_ctrl_o[0] = sw_pin[4];
    assign bt_ctrl_o[1] = sw_pin[2];
    assign bt_ctrl_o[2] = sw_pin[1];
    assign bt_ctrl_o[3] = sw_pin[0];
    assign bt_ctrl_o[4] = sw_pin[3];

    // ========= alarm模块信号 =========
    wire [23:0] set_time, set_alarm, curr_time;
    wire        set_time_en, set_alarm_en, alarm_off, alarm_unlock, alarm_flag;
    wire [15:0] wake_time;
    wire [111:0] wake_time_hist;
    wire        punish;

    // ========= 蓝牙数据与命令 =========
    wire [31:0] data32;
    wire [7:0]  bt_cmd;
    assign bt_cmd = data32[31:24];

    // ========= 时间/闹钟设置寄存器 =========
    reg [23:0] set_time_reg, set_alarm_reg;
    reg        set_time_en_reg, set_alarm_en_reg;

    assign set_time     = set_time_reg;
    assign set_alarm    = set_alarm_reg;
    assign set_time_en  = set_time_en_reg;
    assign set_alarm_en = set_alarm_en_reg;

    // ========= 运动方向控制 =========
    wire [2:0] dir;
    assign dir = (sensor_front) ? LEFT :
                 (sensor_back)  ? RIGHT :
                 (dis < 20)     ? STOP :
                                  FORWARD;

    // ========= 蓝牙命令处理 =========
    always @(posedge sys_clk_in or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            set_time_reg     <= 24'h000000;
            set_alarm_reg    <= 24'h070000;
            set_time_en_reg  <= 1'b0;
            set_alarm_en_reg <= 1'b0;
        end else begin
            set_time_en_reg  <= 1'b0;
            set_alarm_en_reg <= 1'b0;
            case (bt_cmd)
                CMD_SET_TIME: begin
                    set_time_reg    <= data32[23:0];
                    set_time_en_reg <= 1'b1;
                end
                CMD_SET_ALARM: begin
                    set_alarm_reg    <= data32[23:0];
                    set_alarm_en_reg <= 1'b1;
                end
                default: ;
            endcase
        end
    end

    // ========= alarm模块 =========
    alarm u_alarm(
        .clk           (sys_clk_in),
        .rst_n         (sys_rst_n),
        .set_time      (set_time),
        .set_time_en   (set_time_en),
        .set_alarm     (set_alarm),
        .set_alarm_en  (set_alarm_en),
        .alarm_off     (alarm_off),
        .alarm_unlock  (alarm_unlock),
        .curr_time     (curr_time),
        .alarm_flag    (alarm_flag),
        .wake_time     (wake_time),
        .wake_time_hist(wake_time_hist),
        .punish        (punish)
    );

    // ========= 蓝牙UART模块 =========
    bt_uart u_bt_uart(
        .clk_pin    (sys_clk_in),
        .rst_pin    (~sys_rst_n),
        .rxd_pin    (BT_Uart_rxd),
        .txd_pin    (BT_Uart_txd),
        .lb_sel_pin (sw_pin[7]),
        .bt_data32  (data32)
    );

    // ========= 数码管BCD码反转函数 =========
    function [7:0] reverse4x2;
        input [7:0] in;
        begin
            reverse4x2 = {in[3:0], in[7:4]};
        end
    endfunction

    wire [7:0] hour_rev = reverse4x2(curr_time[23:16]);
    wire [7:0] min_rev  = reverse4x2(curr_time[15:8]);
    wire [7:0] sec_rev  = reverse4x2(curr_time[7:0]);

    // ========= seg7显示 =========
    seg7decimal seg7_0(
        .x      ({hour_rev, 8'b0}),
        .clk    (sys_clk_in),
        .clr    (~sys_rst_n),
        .a_to_g (seg_data_0_pin[6:0]),
        .an     (seg_cs_pin[3:0]),
        .dp     (seg_data_0_pin[7])
    );

    seg7decimal seg7_1(
        .x      ({sec_rev, min_rev}),
        .clk    (sys_clk_in),
        .clr    (~sys_rst_n),
        .a_to_g (seg_data_1_pin[6:0]),
        .an     (seg_cs_pin[7:4]),
        .dp     (seg_data_1_pin[7])
    );

    // ========= 蜂鸣器 =========
    assign buzz_out_en = alarm_flag;
    buzzer u_buzzer(
        .clk   (sys_clk_in),
        .rst_n (sys_rst_n),
        .en    (buzz_out_en),
        .buzz  (buzz_out)
    );

    // ========= 小车运动控制 =========
    run u_run(
        .clk   (sys_clk_in),
        .rst_n (sys_rst_n),
        .dir   (dir),
        .in1   (in1_out),
        .in2   (in2_out),
        .in3   (in3_out),
        .in4   (in4_out),
        .ena   (ena_out),
        .enb   (enb_out)
    );

    // ========= 1MHz 分频时钟 =========
    wire clk_1mhz;
    clk_self #(.DIV(50)) u_clk_1mhz (
        .clk     (sys_clk_in),
        .clk_out (clk_1mhz)
    );

    // ========= 按键消抖 =========
    wire key_value, key_flag;
    key_debounce u_key_debounce(
        .sys_clk    (clk_1mhz),
        .sys_rst_n  (sys_rst_n),
        .key        (btn_pin[1]),
        .key_flag   (key_flag),
        .key_value  (key_value)
    );

    // alarm_off 信号由按钮控制
    assign alarm_off = key_flag;

    // ========= OLED字符显示 =========
    wire [1343:0] str_data;
    oled_time_display u_oled_time_display(
        .clk           (sys_clk_in),
        .rst_n         (sys_rst_n),
        .curr_time     (curr_time),
        .alarm_time    (set_alarm),
        .wake_time     (wake_time),
        .wake_time_hist(wake_time_hist),
        .dis           (dis),
        .dir           (dir),
        .str_data      (str_data)
    );

    oled_display u_oled_display(
        .clk_in    (clk_1mhz),
        .sys_rst_n (sys_rst_n),
        .key       (key_value),
        .key_flag  (key_flag),
        .oled_SCL  (scl_out),
        .oled_SDA  (sda_out),
        .oled_RES  (res_out),
        .oled_DC   (dc_out),
        .str_data  (str_data)
    );

    // ========= 音频接口 =========
    assign audio_pwm_o = buzz_out;
    assign audio_sd_o  = punish;

    // ========= LED输出 =========
    assign led_pin[0]  = (dir == STOP);
    assign led_pin[1]  = (dir == BACK);
    assign led_pin[2]  = (dir == FORWARD);
    assign led_pin[3]  = (dir == LEFT);
    assign led_pin[4]  = (dir == RIGHT);
    assign led_pin[10] = sensor_front;
    assign led_pin[11] = sensor_back;
    assign led_pin[15] = (dis < 20);

    // ========= alarm_unlock DIP开关10次逻辑 =========
    reg [3:0] dip_toggle_cnt = 0;
    reg       dip_last = 0;
    always @(posedge sys_clk_in or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            dip_toggle_cnt <= 0;
            dip_last <= dip_pin[0];
        end else begin
            dip_last <= dip_pin[0];
            if (dip_last != dip_pin[0]) begin
                if (dip_toggle_cnt < 10)
                    dip_toggle_cnt <= dip_toggle_cnt + 1'b1;
            end
        end
    end

    assign alarm_unlock = (dip_toggle_cnt >= 10);

endmodule
