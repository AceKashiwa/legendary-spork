`timescale 1ns/1ps

module song_tb;

reg sys_clk = 0;
reg rst_n = 0;
reg [3:0] music_index = 0;
wire speaker;
wire buzzer;

// 生成系统时钟（假设50MHz）
always #10 sys_clk = ~sys_clk;

// 实例化待测模块
song uut (
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .music_index(music_index),
    .speaker(speaker),
    .buzzer(buzzer)
);

// 仿真初始化
initial begin
    // 复位
    rst_n = 0;
    #200;
    rst_n = 1;

    // 默认播放第0首歌
    music_index = 0;
    #1000000; // 观察一段时间

    // 切换到第1首歌
    music_index = 1;
    #1000000; // 观察一段时间

    // 切换到静音
    music_index = 2;
    #500000;

    // 再切回第0首歌
    music_index = 0;
    #1000000;

    $stop;
end

// 监控输出
initial begin
    $monitor("%t ns: music_index=%d, speaker=%b, buzzer=%b", $time, music_index, speaker, buzzer);
end

endmodule