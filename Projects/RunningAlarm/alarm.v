`timescale 1ns/1ps

module alarm(
    input         clk,            // 时钟
    input         rst_n,          // 低有效复位
    input  [23:0] set_time,       // 设置当前时间（BCD: hh_mm_ss）
    input         set_time_en,    // 设置当前时间使能
    input  [23:0] set_alarm,      // 设置闹钟时间（BCD: hh_mm_ss）
    input         set_alarm_en,   // 设置闹钟时间使能
    input         alarm_off,      // 消音信号
    input         alarm_unlock,   // 复杂关闭信号
    output [23:0] curr_time,      // 当前时间（BCD: hh_mm_ss）
    output        alarm_flag,     // 闹钟提醒信号
    output [15:0] wake_time,      // 本次关闭闹钟耗时（秒）
    output [111:0] wake_time_hist,// 7*16=112
    output        punish          // 懒床惩罚信号
);

    // ====== 时间计数与设置 ======
    reg [23:0] time_reg;
    assign curr_time = time_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            time_reg <= 24'h00_00_00;
        else if (set_time_en)
            time_reg <= set_time;
        else if (tick_1s) begin
            // 秒进位
            if (time_reg[7:0] < 8'h59)
                time_reg[7:0] <= (time_reg[7:4] == 4'd5 && time_reg[3:0] == 4'd9) ? 8'h00 : 
                                 (time_reg[3:0] == 4'd9) ? {time_reg[7:4]+1, 4'd0} : time_reg[7:0]+1;
            else begin
                time_reg[7:0] <= 8'h00;
                // 分进位
                if (time_reg[15:8] < 8'h59)
                    time_reg[15:8] <= (time_reg[15:12] == 4'd5 && time_reg[11:8] == 4'd9) ? 8'h00 : 
                                      (time_reg[11:8] == 4'd9) ? {time_reg[15:12]+1, 4'd0} : time_reg[15:8]+1;
                else begin
                    time_reg[15:8] <= 8'h00;
                    // 时进位
                    if (time_reg[23:16] < 8'h23)
                        time_reg[23:16] <= (time_reg[19:16] == 4'd9) ? {time_reg[23:20]+1, 4'd0} : time_reg[23:16]+1;
                    else
                        time_reg[23:16] <= 8'h00;
                end
            end
        end
    end

    // ====== 闹钟时间设置 ======
    reg [23:0] alarm_time;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            alarm_time <= 24'h00_00_00;
        else if (set_alarm_en)
            alarm_time <= set_alarm;
    end

    // ====== 1Hz分频器（假设clk为100MHz）======
    localparam DIV_MAX = 100_000_000 - 1; // 测试用，实际应为100_000_000-1
    reg [26:0] div_cnt;
    wire tick_1s = (div_cnt == DIV_MAX);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            div_cnt <= 0;
        else if (div_cnt == DIV_MAX)
            div_cnt <= 0;
        else
            div_cnt <= div_cnt + 1;
    end

    // ====== 闹钟主逻辑 ======
    reg alarm_on;
    assign alarm_flag = alarm_on;

    reg [15:0] alarm_ring_cnt = 0;  // 闹钟响铃计时
    reg [2:0]  lazy_count = 0;
    reg [15:0] alarm_duration = 600; // 初始10分钟
    reg        punish_reg = 0;
    assign punish = punish_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            alarm_on       <= 1'b0;
            alarm_ring_cnt <= 0;
            lazy_count     <= 0;
            alarm_duration <= 600;
            punish_reg     <= 0;
        end else begin
            // 闹钟触发
            if (time_reg == alarm_time)
                alarm_on <= 1'b1;

            // 闹钟响起时计时
            if (alarm_on && tick_1s)
                alarm_ring_cnt <= alarm_ring_cnt + 1;
            else if (!alarm_on)
                alarm_ring_cnt <= 0;

            // 正常关闭（无懒床）
            if (alarm_on && ((lazy_count == 0 && alarm_off) || (lazy_count > 0 && alarm_unlock))) begin
                alarm_on <= 1'b0;
                alarm_ring_cnt <= 0;
            end

            // 懒床：超时自动关闭
            if (alarm_on && alarm_ring_cnt >= alarm_duration) begin
                alarm_on <= 1'b0;
                alarm_ring_cnt <= 0;
                if (lazy_count < 7)
                    lazy_count <= lazy_count + 1;
                // 每次懒床，闹钟持续时间+5分钟
                alarm_duration <= alarm_duration + 300;
            end

            // 7次懒床惩罚
            if (lazy_count >= 7)
                punish_reg <= 1;
            else
                punish_reg <= 0;
        end
    end

    // ====== 起床耗时统计 ======
    reg [15:0] wake_cnt = 0; // 当前起床耗时（秒）
    reg [15:0] wake_time_reg = 0;
    reg [15:0] wake_time_hist_reg [6:0];
    integer j;
    wire [111:0] wake_time_hist_wire;
    reg [2:0]  hist_idx = 0;
    reg        alarm_on_d = 0;

    assign wake_time = wake_time_reg;

    // 输出历史
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin: hist_out
            assign wake_time_hist_wire[i*16 +: 16] = wake_time_hist_reg[i];
        end
    endgenerate
    assign wake_time_hist = wake_time_hist_wire;

    // 检测闹钟响起沿和关闭沿
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wake_cnt        <= 0;
            wake_time_reg   <= 0;
            hist_idx        <= 0;
            alarm_on_d      <= 0;
            for (j = 0; j < 7; j = j + 1)
                wake_time_hist_reg[j] <= 0;
        end else begin
            alarm_on_d <= alarm_on;
            // 闹钟刚响起，开始计时
            if (~alarm_on_d && alarm_on) begin
                wake_cnt <= 0;
            end
            // 闹钟响着，每秒+1
            else if (alarm_on && tick_1s) begin
                wake_cnt <= wake_cnt + 1;
            end
            // 闹钟刚被关闭，记录耗时
            else if (alarm_on_d && ~alarm_on) begin
                wake_time_reg <= wake_cnt;
                wake_time_hist_reg[hist_idx] <= wake_cnt;
                hist_idx <= (hist_idx == 3'd6) ? 3'd0 : hist_idx + 1;
                wake_cnt <= 0;
            end
        end
    end

endmodule