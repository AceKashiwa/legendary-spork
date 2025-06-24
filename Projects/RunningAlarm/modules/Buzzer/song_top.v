module song_top(
    input sys_clk,
    input rst,
    input [3:0] music_index, // 曲目选择
    output reg speaker, // 音频输出
    output buzzer
);
    wire clk_6mhz;
    clk_self #(8) u1(
        .clk(sys_clk),
        .clk_out(clk_6mhz)
    );

    wire clk_4hz;
    clk_self #(12500000) u2(
        .clk(sys_clk),
        .clk_out(clk_4hz)
    );
    reg [7:0] counter0 = 0;
    reg [6:0] counter1 = 0;
    reg [3:0] last_music_index = 0;

    // 节拍计数与音符取出
    always @(posedge clk_4hz or negedge rst) begin
        if (!rst_n)
            counter <= 0;
        else if (counter == 127) // 若乐谱长度不同请同步修改
            counter <= 0;
        else
            counter <= counter + 1;

        {high, med, low} <= note_data;
    end

    // 乐谱输出
    wire [11:0] note0, note1, note_sel;
    music_score_ROM rom0(.addr(counter0), .note_code(note0));
    music_score_ROM_xxx rom1(.addr(counter1), .note_code(note1));
    assign note_sel = (music_index == 0) ? note0 :
                      (music_index == 1) ? note1 : 12'h000;

    // 播放器
    player player_inst(
        .clk(sys_clk),
        .rst(rst),
        .note_code(note_sel),
        .speaker(speaker),
        .buzzer(buzzer)
    );
endmodule