// 音符频率ROM模块：存储音符对应的分频置数

module music_freq_ROM #(
    parameter ROM_WIDTH = 16,
    parameter ROM_DEPTH = 32,
    parameter ADDR_WIDTH = 5
)(
    input [11:0] note_code, // {high, med, low} 12位音符编码
    output reg [ROM_WIDTH-1:0] origin
);
    // 频率置数表，顺序与case语句一致
    reg [ROM_WIDTH-1:0] Mem[ROM_DEPTH-1:0];

    // 音符编码与ROM地址映射
    // 例如：'h001 -> 0, 'h002 -> 1, ..., 'h700 -> 20, 'h000 -> 21
    // 可根据实际乐谱调整
    always @(*) begin
        case(note_code)
            12'h001: origin = Mem[0];
            12'h002: origin = Mem[1];
            12'h003: origin = Mem[2];
            12'h004: origin = Mem[3];
            12'h005: origin = Mem[4];
            12'h006: origin = Mem[5];
            12'h007: origin = Mem[6];
            12'h010: origin = Mem[7];
            12'h020: origin = Mem[8];
            12'h030: origin = Mem[9];
            12'h040: origin = Mem[10];
            12'h050: origin = Mem[11];
            12'h060: origin = Mem[12];
            12'h070: origin = Mem[13];
            12'h100: origin = Mem[14];
            12'h200: origin = Mem[15];
            12'h300: origin = Mem[16];
            12'h400: origin = Mem[17];
            12'h500: origin = Mem[18];
            12'h600: origin = Mem[19];
            12'h700: origin = Mem[20];
            12'h000: origin = Mem[21];
            default: origin = Mem[21];
        endcase
    end

    // 初始化频率置数
    initial begin
        Mem[ 0] = 14'd4915;   // 'h001
        Mem[ 1] = 14'd6168;   // 'h002
        Mem[ 2] = 14'd7281;   // 'h003
        Mem[ 3] = 14'd7792;   // 'h004
        Mem[ 4] = 14'd8730;   // 'h005
        Mem[ 5] = 14'd9565;   // 'h006
        Mem[ 6] = 14'd10310;  // 'h007
        Mem[ 7] = 14'd10647;  // 'h010
        Mem[ 8] = 14'd11272;  // 'h020
        Mem[ 9] = 14'd11831;  // 'h030
        Mem[10] = 14'd12094;  // 'h040
        Mem[11] = 14'd12556;  // 'h050
        Mem[12] = 14'd12947;  // 'h060
        Mem[13] = 14'd13346;  // 'h070
        Mem[14] = 14'd13516;  // 'h100
        Mem[15] = 14'd13829;  // 'h200
        Mem[16] = 14'd14109;  // 'h300
        Mem[17] = 14'd14235;  // 'h400
        Mem[18] = 14'd14470;  // 'h500
        Mem[19] = 14'd14678;  // 'h600
        Mem[20] = 14'd14864;  // 'h700
        Mem[21] = 14'd16383;  // 'h000 (静音)
    end

endmodule