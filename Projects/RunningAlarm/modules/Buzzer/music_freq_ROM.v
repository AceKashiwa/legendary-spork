// 音符频率ROM模块：存储音符对应的分频置数，只读优化版

module music_freq_ROM #(
    parameter ROM_WIDTH = 16,
    parameter ROM_DEPTH = 32,
    parameter ADDR_WIDTH = 5
)(
    input  [11:0] note_code,          // {high, med, low} 12位音符编码
    output [ROM_WIDTH-1:0] origin
);
    reg [ROM_WIDTH-1:0] Mem[0:ROM_DEPTH-1];

    // 初始频率置数
    initial begin
        Mem[ 0] = 16'd4915;   // 'h001
        Mem[ 1] = 16'd6168;   // 'h002
        Mem[ 2] = 16'd7281;   // 'h003
        Mem[ 3] = 16'd7792;   // 'h004
        Mem[ 4] = 16'd8730;   // 'h005
        Mem[ 5] = 16'd9565;   // 'h006
        Mem[ 6] = 16'd10310;  // 'h007
        Mem[ 7] = 16'd10647;  // 'h010
        Mem[ 8] = 16'd11272;  // 'h020
        Mem[ 9] = 16'd11831;  // 'h030
        Mem[10] = 16'd12094;  // 'h040
        Mem[11] = 16'd12556;  // 'h050
        Mem[12] = 16'd12947;  // 'h060
        Mem[13] = 16'd13346;  // 'h070
        Mem[14] = 16'd13516;  // 'h100
        Mem[15] = 16'd13829;  // 'h200
        Mem[16] = 16'd14109;  // 'h300
        Mem[17] = 16'd14235;  // 'h400
        Mem[18] = 16'd14470;  // 'h500
        Mem[19] = 16'd14678;  // 'h600
        Mem[20] = 16'd14864;  // 'h700
        Mem[21] = 16'd16383;  // 'h000 (静音)
        // 其余可根据需要补充
    end

    // 组合逻辑查表输出
    assign origin = 
        (note_code == 12'h001) ? Mem[0]  :
        (note_code == 12'h002) ? Mem[1]  :
        (note_code == 12'h003) ? Mem[2]  :
        (note_code == 12'h004) ? Mem[3]  :
        (note_code == 12'h005) ? Mem[4]  :
        (note_code == 12'h006) ? Mem[5]  :
        (note_code == 12'h007) ? Mem[6]  :
        (note_code == 12'h010) ? Mem[7]  :
        (note_code == 12'h020) ? Mem[8]  :
        (note_code == 12'h030) ? Mem[9]  :
        (note_code == 12'h040) ? Mem[10] :
        (note_code == 12'h050) ? Mem[11] :
        (note_code == 12'h060) ? Mem[12] :
        (note_code == 12'h070) ? Mem[13] :
        (note_code == 12'h100) ? Mem[14] :
        (note_code == 12'h200) ? Mem[15] :
        (note_code == 12'h300) ? Mem[16] :
        (note_code == 12'h400) ? Mem[17] :
        (note_code == 12'h500) ? Mem[18] :
        (note_code == 12'h600) ? Mem[19] :
        (note_code == 12'h700) ? Mem[20] :
        (note_code == 12'h000) ? Mem[21] :
                                 Mem[21] ; // 默认静音
endmodule