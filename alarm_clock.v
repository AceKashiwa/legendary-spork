// alarm_clock.v
// 单一闹钟模块：100MHz 系统时钟，记录并计算最近7次平均起床秒数（不含本次）

module alarm_clock(
    input  wire        clk100,      // 100MHz 系统时钟
    input  wire        rst_n,       // 异步低有效复位
    input  wire [23:0] alarm_set,   // BCD {HH,MM,SS}
    input  wire        key_off,     // 关闭闹钟按键（需外部去抖）
    output reg  [23:0] time_now,    // 实时时间 BCD {HH,MM,SS}
    output reg         alarm_out,   // 闹钟输出，高电平表示响铃中
    output reg  [15:0] used_sec,    // 本次起床用时（秒）
    output reg  [15:0] avg_sec      // 最近7次平均起床秒数（不含本次）
);

    //======================================================================
    // 1Hz 分频器：100MHz -> 1Hz
    //======================================================================
    reg [26:0] cnt100m;
    wire tick1s;
    localparam DIV100M = 100_000_000;
    always @(posedge clk100 or negedge rst_n) begin
        if (!rst_n)
            cnt100m <= 0;
        else if (cnt100m == DIV100M-1)
            cnt100m <= 0;
        else
            cnt100m <= cnt100m + 1;
    end
    assign tick1s = (cnt100m == DIV100M-1);

    //======================================================================
    // 实时时钟计数 & 全日秒数累加
    //======================================================================
    reg [7:0] hr, min_, sec;
    reg [31:0] sec_cnt;
    always @(posedge clk100 or negedge rst_n) begin
        if (!rst_n) begin
            hr <= 0; min_ <= 0; sec <= 0; sec_cnt <= 0;
        end else if (tick1s) begin
            // 更新时分秒
            if (sec == 8'd59) begin
                sec <= 0;
                if (min_ == 8'd59) begin
                    min_ <= 0;
                    if (hr == 8'd23) hr <= 0;
                    else            hr <= hr + 1;
                end else begin
                    min_ <= min_ + 1;
                end
            end else begin
                sec <= sec + 1;
            end
            // 累计全天秒数
            sec_cnt <= hr*3600 + min_*60 + sec + 1;
        end
    end

    // 更新 BCD 时间输出
    always @(posedge clk100 or negedge rst_n) begin
        if (!rst_n)
            time_now <= 24'h000000;
        else if (tick1s)
            time_now <= {hr, min_, sec};
    end

    //======================================================================
    // 闹钟触发及起床计时
    //======================================================================
    reg [31:0] ring_time;
    reg armed;
    always @(posedge clk100 or negedge rst_n) begin
        if (!rst_n) begin
            alarm_out <= 0;
            armed     <= 0;
            used_sec  <= 16'd0;
        end else begin
            // 闹铃响起
            if (!alarm_out && time_now == alarm_set) begin
                alarm_out <= 1;
                armed     <= 1;
                ring_time <= sec_cnt;
            end
            // 按键关闭
            if (armed && key_off) begin
                alarm_out <= 0;
                armed     <= 0;
                // 计算本次用时
                used_sec  <= sec_cnt - ring_time;
            end
        end
    end

    //======================================================================
    // 历史记录与滑动平均（7次，不含本次），初始值均60秒
    //======================================================================
    reg [15:0] hist [0:6];
    integer i;
    reg [31:0] sum;
    always @(posedge clk100 or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 7; i = i + 1)
                hist[i] <= 16'd60;
            avg_sec <= 16'd60;
        end else if (!armed && used_sec > 0) begin
            // 先计算平均（使用旧7条记录）
            sum = 0;
            for (i = 0; i < 7; i = i + 1)
                sum = sum + hist[i];
            avg_sec <= sum / 7;
            // 再更新记录队列，插入本次耗时
            for (i = 6; i > 0; i = i - 1)
                hist[i] <= hist[i-1];
            hist[0] <= used_sec;
        end
    end

endmodule
