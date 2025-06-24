`timescale 1ns/1ps

module alarm_tb;

    reg clk;
    reg rst_n;
    reg [23:0] set_time;
    reg set_time_en;
    reg [23:0] set_alarm;
    reg set_alarm_en;
    reg alarm_off;
    reg alarm_unlock;
    wire [23:0] curr_time;
    wire alarm_flag;
    wire [15:0] wake_time;
    wire [111:0] wake_time_hist;
    wire punish;

    // 实例化被测模块
    alarm uut (
        .clk(clk),
        .rst_n(rst_n),
        .set_time(set_time),
        .set_time_en(set_time_en),
        .set_alarm(set_alarm),
        .set_alarm_en(set_alarm_en),
        .alarm_off(alarm_off),
        .alarm_unlock(alarm_unlock),
        .curr_time(curr_time),
        .alarm_flag(alarm_flag),
        .wake_time(wake_time),
        .wake_time_hist(wake_time_hist),
        .punish(punish)
    );

    // 100MHz 时钟
    initial clk = 0;
    always #5 clk = ~clk;

    // 等待N个1Hz时钟
    task wait_seconds(input integer n);
        integer i;
        reg [23:0] last_time;
        begin
            for (i = 0; i < n; i = i + 1) begin
                last_time = curr_time;
                @(posedge clk);
                while (curr_time == last_time) @(posedge clk);
            end
        end
    endtask

    // 打印历史
    task print_hist;
        begin
            $display("wake_time_hist: %0d %0d %0d %0d %0d %0d %0d",
                wake_time_hist[15:0],
                wake_time_hist[31:16],
                wake_time_hist[47:32],
                wake_time_hist[63:48],
                wake_time_hist[79:64],
                wake_time_hist[95:80],
                wake_time_hist[111:96]
            );
        end
    endtask

    integer i;
    integer lazy_cnt;

    initial begin
        // 初始化
        rst_n = 0;
        set_time = 24'h06_59_00;
        set_time_en = 0;
        set_alarm = 24'h00_00_00;
        set_alarm_en = 0;
        alarm_off = 0;
        alarm_unlock = 0;
        lazy_cnt = 0;

        // 复位
        #100;
        rst_n = 1;
        #20;

        // 设置当前时间为 06:59:00
        set_time = 24'h06_59_00;
        set_time_en = 1;
        #10; set_time_en = 0;

        // 主循环：20次闹钟
        for (i = 0; i < 20; i = i + 1) begin
            // 设置闹钟为当前时间+30秒
            set_alarm = curr_time + 24'h00_00_30;
            set_alarm_en = 1; #10; set_alarm_en = 0;

            wait_seconds(30); // 等待闹钟响起

            $display("==== Alarm #%0d triggered at %h ====", i+1, curr_time);

            // 前8次为懒床（不手动关闭，等超时），其余为正常关闭
            if (i < 8) begin
                // 懒床，等待超时自动关闭
                wait_seconds(uut.alarm_duration + 1);
                lazy_cnt = lazy_cnt + 1;
                $display("[懒床] Alarm auto-cleared after timeout, lazy_cnt=%0d, punish=%b", lazy_cnt, punish);
            end else begin
                // 正常关闭（前8次后alarm_off无效，需alarm_unlock）
                if (uut.lazy_count == 0) begin
                    // 前8次后第一次正常关闭
                    alarm_off = 1; #10; alarm_off = 0; #10;
                    $display("[正常] Alarm cleared by alarm_off, alarm_flag=%b", alarm_flag);
                end else begin
                    // 懒床后只能用alarm_unlock
                    alarm_unlock = 1; #10; alarm_unlock = 0; #10;
                    $display("[正常] Alarm cleared by alarm_unlock, alarm_flag=%b", alarm_flag);
                end
            end

            $display("wake_time (last): %0d", wake_time);
            print_hist();

            // 等待10秒再进入下一轮
            wait_seconds(10);
        end

        $display("==== 长时间仿真结束，懒床次数: %0d ====", lazy_cnt);
        $display("最终 punish = %b", punish);

        $finish;
    end

endmodule