`timescale 1ns/1ps

module buzzer(
    input        clk,        // 100MHz 时钟
    input        rst_n,      // 低有效复位
    input        en,         // 使能播放
    output reg   buzz        // 蜂鸣器输出
);

    // 小星星简谱（C调）：C C G G A A G | F F E E D D C
    // 音符编码
    localparam NOTE_NUM = 14;
    localparam integer C   = 12'h001;
    localparam integer D   = 12'h002;
    localparam integer E   = 12'h003;
    localparam integer F   = 12'h004;
    localparam integer G   = 12'h005;
    localparam integer A   = 12'h006;
    localparam integer SIL = 12'h000;

    // 小星星音符序列
    reg [11:0] melody [0:NOTE_NUM-1];
    initial begin
        melody[0]  = C;
        melody[1]  = C;
        melody[2]  = G;
        melody[3]  = G;
        melody[4]  = A;
        melody[5]  = A;
        melody[6]  = G;
        melody[7]  = F;
        melody[8]  = F;
        melody[9]  = E;
        melody[10] = E;
        melody[11] = D;
        melody[12] = D;
        melody[13] = C;
    end

    // ====== 节拍分频器 ======
    wire beat_clk;
    clk_self #(.DIV(6_250_000)) u_beat_div( // 假设100MHz时钟，分频到4hz
        .clk(clk),
        .clk_out(beat_clk)
    );

    reg [3:0] note_idx;
    reg [2:0] beat_cnt; // 计数当前小节内的拍数

    always @(posedge beat_clk or negedge rst_n) begin
        if (!rst_n) begin
            note_idx <= 0;
            beat_cnt <= 0;
        end else if (en) begin
            if (beat_cnt == 6) begin // 七拍一顿
                beat_cnt <= 0;
                note_idx <= (note_idx == NOTE_NUM-1) ? 0 : note_idx + 1;
            end else begin
                beat_cnt <= beat_cnt + 1;
            end
        end else begin
            note_idx <= 0;
            beat_cnt <= 0;
        end
    end

    // ====== 频率查找表 ======
    reg [15:0] origin_wire;
    always @(*) begin
        case (melody[note_idx])
            12'h001: origin_wire = 16'd4915;   // C
            12'h002: origin_wire = 16'd6168;   // D
            12'h003: origin_wire = 16'd7281;   // E
            12'h004: origin_wire = 16'd7792;   // F
            12'h005: origin_wire = 16'd8730;   // G
            12'h006: origin_wire = 16'd9565;   // A
            12'h007: origin_wire = 16'd10310;  // B
            12'h000: origin_wire = 16'd16383;  // 静音
            default: origin_wire = 16'd16383;
        endcase
    end

    // ====== 6MHz分频时钟 ======
    wire clk_6mhz;
    clk_self #(.DIV(8)) u_clk6m (
        .clk(clk),
        .clk_out(clk_6mhz)
    );

    // ====== 方波发生器，使用6MHz时钟 ======
    reg [15:0] divider = 0;
    reg        carry = 0;
    reg        speaker = 0;

    always @(posedge clk_6mhz or negedge rst_n) begin
        if (!rst_n) begin
            divider <= 0;
            carry   <= 0;
        end else if (divider == 16'd16383) begin
            divider <= origin_wire;
            carry   <= 1;
        end else begin
            divider <= divider + 1;
            carry   <= 0;
        end
    end

    always @(posedge carry or negedge rst_n) begin
        if (!rst_n)
            speaker <= 0;
        else
            speaker <= ~speaker;
    end

    always @(*) begin
        buzz = (en && melody[note_idx] != SIL) ? speaker : 0;
    end

endmodule