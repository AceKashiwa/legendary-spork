// alarm_clock.v
// 单一闹钟模块：100MHz 输入，按键关闭，6 位 BCD 输入，输出当前时间与闹铃信号

module alarm_clock (
    input  wire        clk100,      // 100MHz 系统时钟
    input  wire        rst_n,       // 异步低有效复位
    input  wire [23:0] alarm_set,   // BCD {HH[7:0], MM[7:0], SS[7:0]}
    input  wire        key_off,     // 关闭闹钟按键（拉高有效，经去抖后）
    output reg  [23:0] time_now,    // 实时时间 BCD {HH, MM, SS}
    output reg         alarm_out    // 闹钟输出，高电平表示响铃中
);

    //==========================================================================
    // 1Hz 分频：100MHz -> 1Hz
    //==========================================================================
    reg [26:0] cnt100m;
    wire       tick1s;
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

    //==========================================================================
    // 实时时钟：HH:MM:SS 计数，BCD 形式
    //==========================================================================
    reg [7:0] sec, min_, hr;
    always @(posedge clk100 or negedge rst_n) begin
        if (!rst_n) begin
            hr   <= 8'd0;
            min_ <= 8'd0;
            sec  <= 8'd0;
        end else if (tick1s) begin
            if (sec == 8'd59) begin
                sec <= 8'd0;
                if (min_ == 8'd59) begin
                    min_ <= 8'd0;
                    if (hr == 8'd23)
                        hr <= 8'd0;
                    else
                        hr <= hr + 1;
                end else begin
                    min_ <= min_ + 1;
                end
            end else begin
                sec <= sec + 1;
            end
        end
    end
    // 更新输出 BCD
    always @(posedge clk100 or negedge rst_n) begin
        if (!rst_n)
            time_now <= 24'h000000;
        else if (tick1s)
            time_now <= {hr, min_, sec};
    end

    //==========================================================================
    // 按键去抖：生成稳定的 key_db
    //==========================================================================
    reg [19:0] db_cnt;
    reg        key_sync0, key_sync1, key_db;
    always @(posedge clk100 or negedge rst_n) begin
        if (!rst_n) begin
            key_sync0 <= 1'b0;
            key_sync1 <= 1'b0;
            key_db    <= 1'b0;
            db_cnt    <= 0;
        end else begin
            key_sync0 <= key_off;
            key_sync1 <= key_sync0;
            if (key_sync1 == key_db)
                db_cnt <= 0;
            else if (db_cnt == 20'd1_000_000) begin
                key_db <= key_sync1;
                db_cnt <= 0;
            end else
                db_cnt <= db_cnt + 1;
        end
    end

    //==========================================================================
    // 闹钟触发与清除逻辑
    //==========================================================================
    always @(posedge clk100 or negedge rst_n) begin
        if (!rst_n)
            alarm_out <= 1'b0;
        else begin
            if (time_now == alarm_set)
                alarm_out <= 1'b1;
            else if (key_db)
                alarm_out <= 1'b0;
        end
    end

endmodule
