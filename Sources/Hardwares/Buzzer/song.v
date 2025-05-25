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
    output reg speaker,
    output buzzer
);

    wire clk_6mhz;  // 音阶
    clk_self #(8) u1(
        .clk(sys_clk),
        .clk_out(clk_6mhz)
    );

    wire clk_4hz;   // 音长
    clk_self #(12500000) u2(
        .clk(sys_clk),
        .clk_out(clk_4hz)
    );

    reg [7:0] counter; // 足够覆盖乐谱长度
    wire [11:0] note_data; // {high, med, low}
    music_score_ROM_xxx music_score_ROM_inst (
        .addr(counter),
        .data(note_data)
    );


    reg [3:0] high, med, low;
    wire [15:0] origin_wire;
    music_freq_ROM music_freq_ROM_inst (
        .note_code({high, med, low}),
        .origin(origin_wire)
    );

    // 节拍计数与音符取出
    always @(posedge clk_4hz or negedge rst_n) begin
        if (!rst_n)
            counter <= 0;
        else if (counter == 134) // 若乐谱长度不同请同步修改
            counter <= 0;
        else
            counter <= counter + 1;

        {high, med, low} <= note_data;
    end


    reg [15:0] divider;
    reg carry;

    // 分频器
    always @(posedge clk_6mhz) begin
        if (divider == 16383)
        begin
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