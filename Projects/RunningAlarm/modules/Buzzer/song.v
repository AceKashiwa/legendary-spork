`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/23 23:11:21
// Design Name: 
// Module Name: song
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//////////////////////////////////////////////////////////////////////////////////

module song(
    input sys_clk,
    input rst_n,
    input [3:0] music_index, // 添加外部曲目选择信号
    output reg speaker = 1'b0, // 初始化为0
    output buzzer
);

    wire clk_6mhz;
    clk_self #(4) u1(
        .clk(sys_clk),
        .clk_out(clk_6mhz)
    );

    wire clk_4hz;
    clk_self #(1000) u2(
        .clk(sys_clk),
        .clk_out(clk_4hz)
    );

    // 为不同曲目定义最大长度
    localparam SONG0_LEN = 135;
    localparam SONG1_LEN = 128;
    
    reg [7:0] counter0 = 0;
    reg [6:0] counter1 = 0; // 假设第二首歌长度不超过128

    reg [3:0] last_music_index;

    // 选择当前使用的计数器
    wire [7:0] counter_sel = (music_index == 4'd0) ? counter0 :
                             (music_index == 4'd1) ? {1'b0, counter1} : 8'd0;

    // ROM输出
    wire [11:0] note_data0, note_data1;
    wire [11:0] note_data;

    music_score_ROM     rom0 (.addr(counter0),      .data(note_data0));
    music_score_ROM_xxx rom1 (.addr(counter1),      .data(note_data1));

    assign note_data = (music_index == 4'd0) ? note_data0 :
                       (music_index == 4'd1) ? note_data1 :
                       12'h000;

    // 节拍计数与音符取出，曲目切换时各自归零
    always @(posedge clk_4hz or negedge rst_n) begin
        if (!rst_n) begin
            counter0 <= 0;
            counter1 <= 0;
            last_music_index <= music_index;
        end else begin
            last_music_index <= music_index;
            if (music_index == 4'd0) begin
                if (counter0 == SONG0_LEN-1)
                    counter0 <= 0;
                else
                    counter0 <= counter0 + 1;
            end else if (music_index == 4'd1) begin
                if (counter1 == SONG1_LEN-1)
                    counter1 <= 0;
                else
                    counter1 <= counter1 + 1;
            end
        end
    end

    // 音符同步
    always @(*) begin
        {high, med, low} = note_data;
    end

    reg [15:0] divider = 16'd0; // 初始化
    reg carry = 1'b0;           // 初始化

    // 分频器
    always @(posedge clk_6mhz) begin
        if (divider == 16383) begin
            divider <= origin_wire;
            carry <= 1'b1;
        end else begin
            divider <= divider + 1;
            carry <= 1'b0;
        end
    end

    always @(posedge carry) begin   // 方波信号
        speaker <= ~speaker;
    end

    assign buzzer = speaker;

endmodule