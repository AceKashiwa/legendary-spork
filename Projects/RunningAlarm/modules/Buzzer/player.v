module player(
    input        clk,         // 系统时钟
    input        rst,       // 高有效复位
    input [11:0] note_code,   // 当前音符编码
    output reg   speaker,     // PWM输出
    output       buzzer
);

    // 内部频率查找表
    reg [15:0] origin_wire;
    always @(*) begin
        case (note_code)
            12'h001: origin_wire = 16'd4915;   // 'h001
            12'h002: origin_wire = 16'd6168;   // 'h002
            12'h003: origin_wire = 16'd7281;   // 'h003
            12'h004: origin_wire = 16'd7792;   // 'h004
            12'h005: origin_wire = 16'd8730;   // 'h005
            12'h006: origin_wire = 16'd9565;   // 'h006
            12'h007: origin_wire = 16'd10310;  // 'h007
            12'h010: origin_wire = 16'd10647;  // 'h010
            12'h020: origin_wire = 16'd11272;  // 'h020
            12'h030: origin_wire = 16'd11831;  // 'h030
            12'h040: origin_wire = 16'd12094;  // 'h040
            12'h050: origin_wire = 16'd12556;  // 'h050
            12'h060: origin_wire = 16'd12947;  // 'h060
            12'h070: origin_wire = 16'd13346;  // 'h070
            12'h100: origin_wire = 16'd13516;  // 'h100
            12'h200: origin_wire = 16'd13829;  // 'h200
            12'h300: origin_wire = 16'd14109;  // 'h300
            12'h400: origin_wire = 16'd14235;  // 'h400
            12'h500: origin_wire = 16'd14470;  // 'h500
            12'h600: origin_wire = 16'd14678;  // 'h600
            12'h700: origin_wire = 16'd14864;  // 'h700
            12'h000: origin_wire = 16'd16383;  // 'h000 (静音)
        endcase
    end

    reg [15:0] divider = 0;
    reg carry = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            carry <= 0;
            speaker <= 0;
        end
        if (divider == 16383) begin
            divider <= origin_wire;
            carry <= 1;
        end else begin
            divider <= divider + 1;
            carry <= 0;
        end
    end

    always @(posedge carry or posedge rst) begin
        speaker <= ~speaker;
    end

    assign buzzer = speaker; 
endmodule