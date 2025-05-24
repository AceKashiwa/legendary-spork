`timescale 1ns/1ps

module song(
    input sys_clk,
    output reg speaker,
    output reg [2:0] cs,    // 数码管
    output [6:0] seg_7s,
    output buzzer
);
    assign buzzer = speaker;
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

    reg [13:0] divider, origin;
    reg carry;
    reg [7:0] counter;
    reg [3:0] high, med, low, num;

    music_score_RAM music_score_RAM_inst (
        .clk(clk_4hz),
        .rst_n(1'b1),      // 若有复位信号请替换
        .re(1'b1),
        .addr(counter),
        .data(music_data)
    );    

    // 调用buzzer频率ROM模块
    music_freq_ROM buzzer_rom_inst (
        .note_code({high, med, low}),
        .origin(origin)
    );

    always @(posedge clk_6mhz) begin    // 置数改变分频比
        if (divider == 16383)
        begin
            divider <= origin;
            carry <= 1;
        end
        else
        begin
            divider <= divider + 1;
            carry <= 0;
        end
    end

    always @(posedge carry) begin   // 方波信号
        speaker <= ~speaker;
    end


    always @(posedge clk_4hz) begin
        if (counter == 134)
            counter <= 0;
        else
            counter <= counter + 1;
        case(counter)
            0:begin {high, med, low} <= 'h003;  cs <= 3'b001; end
            1:begin {high, med, low} <= 'h003;  cs <= 3'b001; end
            2:begin {high, med, low} <= 'h003;  cs <= 3'b001; end
            3:begin {high, med, low} <= 'h003;  cs <= 3'b001; end
            4:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            5:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            6:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            7:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            8:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            9:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            10:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            11:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            12:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            13:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            14:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            15:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            16:begin {high, med, low} <= 'h050;  cs <= 3'b010; end
            17:begin {high, med, low} <= 'h050;  cs <= 3'b010; end
            18:begin {high, med, low} <= 'h050;  cs <= 3'b010; end
            19:begin {high, med, low} <= 'h100;  cs <= 3'b100; end
            20:begin {high, med, low} <= 'h060;  cs <= 3'b010; end
            21:begin {high, med, low} <= 'h050;  cs <= 3'b010; end
            22:begin {high, med, low} <= 'h030;  cs <= 3'b010; end
            23:begin {high, med, low} <= 'h050;  cs <= 3'b010; end
            24:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            25:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            26:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            27:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            28:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            29:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            30:begin {high, med, low} <= 'h000;  cs <= 3'b010; end
            31:begin {high, med, low} <= 'h000;  cs <= 3'b010; end
            32:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            33:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            34:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            35:begin {high, med, low} <= 'h030;  cs <= 3'b010; end
            36:begin {high, med, low} <= 'h007;  cs <= 3'b001; end
            37:begin {high, med, low} <= 'h007;  cs <= 3'b001; end
            38:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            39:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            40:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            41:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            42:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            43:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            44:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            45:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            46:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            47:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            48:begin {high, med, low} <= 'h003;  cs <= 3'b010; end
            49:begin {high, med, low} <= 'h003;  cs <= 3'b010; end
            50:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            51:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            52:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            53:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            54:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            55:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            56:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            57:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            58:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            59:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            60:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            61:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            62:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            63:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            64:begin {high, med, low} <= 'h030;  cs <= 3'b010; end
            65:begin {high, med, low} <= 'h030;  cs <= 3'b010; end
            66:begin {high, med, low} <= 'h030;  cs <= 3'b010; end
            67:begin {high, med, low} <= 'h050;  cs <= 3'b010; end
            68:begin {high, med, low} <= 'h007;  cs <= 3'b001; end
            69:begin {high, med, low} <= 'h007;  cs <= 3'b001; end
            70:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            71:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            72:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            73:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            74:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            75:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            76:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            77:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            78:begin {high, med, low} <= 'h000;  cs <= 3'b001; end
            79:begin {high, med, low} <= 'h000;  cs <= 3'b001; end
            80:begin {high, med, low} <= 'h003;  cs <= 3'b001; end
            81:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            82:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            83:begin {high, med, low} <= 'h003;  cs <= 3'b001; end
            84:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            85:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            86:begin {high, med, low} <= 'h007;  cs <= 3'b001; end
            87:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            88:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            89:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            90:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            91:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            92:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            93:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            94:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            95:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            96:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            97:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            98:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            99:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            100:begin {high, med, low} <= 'h050;  cs <= 3'b010; end
            101:begin {high, med, low} <= 'h050;  cs <= 3'b010; end
            102:begin {high, med, low} <= 'h030;  cs <= 3'b010; end
            103:begin {high, med, low} <= 'h030;  cs <= 3'b010; end
            104:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            105:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            106:begin {high, med, low} <= 'h030;  cs <= 3'b010; end
            107:begin {high, med, low} <= 'h020;  cs <= 3'b010; end
            108:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            109:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            110:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            111:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            112:begin {high, med, low} <= 'h003;  cs <= 3'b001; end
            113:begin {high, med, low} <= 'h003;  cs <= 3'b001; end
            114:begin {high, med, low} <= 'h003;  cs <= 3'b001; end
            115:begin {high, med, low} <= 'h003;  cs <= 3'b001; end
            116:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            117:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            118:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            119:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            120:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            121:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            122:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            123:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            124:begin {high, med, low} <= 'h003;  cs <= 3'b001; end
            125:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            126:begin {high, med, low} <= 'h006;  cs <= 3'b001; end
            127:begin {high, med, low} <= 'h010;  cs <= 3'b010; end
            128:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            129:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            130:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            131:begin {high, med, low} <= 'h005;  cs <= 3'b001; end
            132:begin {high, med, low} <= 'h005;  cs <= 3'h001; end
            133:begin {high, med, low} <= 'h000;  cs <= 3'b010; end
            134:begin {high, med, low} <= 'h000;  cs <= 3'b010; end
            default:begin {high, med, low} <= 'h000;  cs <= 3'b010; end
        endcase
    end
    
    assign an = {cs[2], cs[1], cs[0], 1'b1};
    seg7decimal u3(
        .x({high, med, low}),
        .clk(clk_4hz),
        .clr(1'b0),
        .a_to_g(seg_7s),
        .an(an),
        .dp()
    );
endmodule
