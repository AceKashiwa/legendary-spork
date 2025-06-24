module oled_time_display(
    input        clk,
    input        rst_n,
    input [23:0] curr_time,       // 当前时间 {hour[7:0], min[7:0], sec[7:0]}
    input [23:0] alarm_time,      // 闹钟时间 {hour[7:0], min[7:0], sec[7:0]}
    input [15:0] wake_time,       // 最近一次起床耗时（秒）
    input [111:0] wake_time_hist, // 近7次起床耗时历史（秒），每16位一项
    input [15:0] dis,             // 超声波测距距离（厘米）
    input [2:0]  dir,             // 方向控制信号
    output [1343:0] str_data      // 8行，每行21字符
);

    // ====== 字符常量定义 ======
    localparam [7:0] CHAR_SPACE = 8'h20;  // ' '
    localparam [7:0] CHAR_EQUAL = 8'h3D;  // '='
    localparam [7:0] CHAR_UP    = 8'h5E;  // '^'
    localparam [7:0] CHAR_DOWN  = 8'h76;  // 'v'
    localparam [7:0] CHAR_LEFT  = 8'h3C;  // '<'
    localparam [7:0] CHAR_RIGHT = 8'h3E;  // '>'
    localparam [7:0] CHAR_STOP  = 8'h23;  // '#'
    localparam [7:0] CHAR_COLON = 8'h3A;  // ':'
    localparam [7:0] CHAR_M     = 8'h6D;  // 'm'
    localparam [7:0] CHAR_S     = 8'h73;  // 's'

    // ====== 方向状态定义 ======
    localparam STOP    = 3'b000;
    localparam FORWARD = 3'b001;
    localparam BACK    = 3'b010;
    localparam LEFT    = 3'b011;
    localparam RIGHT   = 3'b100;

    // ====== 方向字符选择 ======
    wire [7:0] dir_char = 
        (dir == STOP)    ? CHAR_STOP  :
        (dir == FORWARD) ? CHAR_UP    :
        (dir == BACK)    ? CHAR_DOWN  :
        (dir == LEFT)    ? CHAR_LEFT  :
        (dir == RIGHT)   ? CHAR_RIGHT :
                           CHAR_SPACE;

    // ====== 括号包裹的方向字符 ======
    wire [23:0] dir_with_brackets = {
        8'h28,    // '('
        dir_char, // 方向字符
        8'h29     // ')'
    };

    // ====== 上边界线，带方向 ======
    wire [167:0] line0 = {
        {8{CHAR_EQUAL}},
        dir_with_brackets,
        {10{CHAR_EQUAL}}
    };

    // ====== 数字转ASCII（0-9） ======
    function [7:0] to_ascii;
        input [3:0] digit;
        begin
            to_ascii = (digit <= 4'd9) ? {4'h3, digit} : 8'h30;
        end
    endfunction

    // ====== 时间分解 ======
    wire [7:0] hour  = curr_time[23:16];
    wire [7:0] min   = curr_time[15:8];
    wire [7:0] sec   = curr_time[7:0];
    wire [7:0] ahour = alarm_time[23:16];
    wire [7:0] amin  = alarm_time[15:8];
    wire [7:0] asec  = alarm_time[7:0];

    // ====== 历史数据分解 ======
    wire [15:0] hist0 = wake_time_hist[15:0];
    wire [15:0] hist1 = wake_time_hist[31:16];
    wire [15:0] hist2 = wake_time_hist[47:32];
    wire [15:0] hist3 = wake_time_hist[63:48];
    wire [15:0] hist4 = wake_time_hist[79:64];
    wire [15:0] hist5 = wake_time_hist[95:80];
    wire [15:0] hist6 = wake_time_hist[111:96];

    // ====== 历史平均值计算 ======
    reg [19:0] sum;
    reg [15:0] avg;
    always @(*) begin
        sum = wake_time + hist0 + hist1 + hist2 + hist3 + hist4 + hist5 + hist6;
        avg = sum >> 3;  // 除以8
    end
    wire is_lazy = (avg > 16'd180);  // 超3分钟为lazy

    // ====== 时间/历史数据转分秒 ======
    wire [7:0] wake_min = wake_time / 16'd60;
    wire [7:0] wake_sec = wake_time % 16'd60;
    wire [7:0] hist0_min = hist0 / 16'd60;
    wire [7:0] hist1_min = hist1 / 16'd60;
    wire [7:0] hist2_min = hist2 / 16'd60;
    wire [7:0] hist3_min = hist3 / 16'd60;
    wire [7:0] hist4_min = hist4 / 16'd60;
    wire [7:0] hist5_min = hist5 / 16'd60;
    wire [7:0] hist6_min = hist6 / 16'd60;

    // ====== 各行内容拼接 ======
    // line1: 当前时间
    wire [167:0] line1 = {
        8'h54, 8'h49, 8'h4D, 8'h45, CHAR_COLON, CHAR_SPACE,  // "TIME: "
        to_ascii(hour[7:4]), to_ascii(hour[3:0]), CHAR_COLON,
        to_ascii(min[7:4]), to_ascii(min[3:0]), CHAR_COLON,
        to_ascii(sec[7:4]), to_ascii(sec[3:0]),
        {7{CHAR_SPACE}}
    };

    // line2: 闹钟时间
    wire [167:0] line2 = {
        8'h41, 8'h4C, 8'h41, 8'h52, 8'h4D, CHAR_COLON,
        to_ascii(ahour[7:4]), to_ascii(ahour[3:0]), CHAR_COLON,
        to_ascii(amin[7:4]), to_ascii(amin[3:0]), CHAR_COLON,
        to_ascii(asec[7:4]), to_ascii(asec[3:0]),
        {7{CHAR_SPACE}}
    };

    // line3: 最近一次起床耗时
    wire [167:0] line3 = {
        8'h4C, 8'h61, 8'h73, 8'h74, CHAR_SPACE,  // "Last "
        8'h57, 8'h61, 8'h6B, 8'h65, CHAR_COLON, CHAR_SPACE,  // "Wake: "
        to_ascii(wake_min[7:4]), to_ascii(wake_min[3:0]), CHAR_M,
        to_ascii(wake_sec[7:4]), to_ascii(wake_sec[3:0]), CHAR_S,
        {4{CHAR_SPACE}}
    };

    // line4: Lazy boy! or Good job!
    wire [167:0] line4 = is_lazy ? {
        8'h4C, 8'h61, 8'h7A, 8'h79, CHAR_SPACE,  // "Lazy "
        8'h62, 8'h6F, 8'h79, 8'h21,              // "boy!"
        {12{CHAR_SPACE}}
    } : {
        8'h47, 8'h6F, 8'h6F, 8'h64, CHAR_SPACE,  // "Good "
        8'h6A, 8'h6F, 8'h62, 8'h21,              // "job!"
        {12{CHAR_SPACE}}
    };

    // line5: 历史数据前3项
    wire [167:0] line5 = {
        8'h48, 8'h69, 8'h73, 8'h74, CHAR_COLON, CHAR_SPACE,  // "Hist: "
        to_ascii(hist0_min[7:4]), to_ascii(hist0_min[3:0]), CHAR_M, CHAR_SPACE,
        to_ascii(hist1_min[7:4]), to_ascii(hist1_min[3:0]), CHAR_M, CHAR_SPACE,
        to_ascii(hist2_min[7:4]), to_ascii(hist2_min[3:0]), CHAR_M,
        CHAR_SPACE
    };

    // line6: 历史数据后4项
    wire [167:0] line6 = {
        {3{CHAR_SPACE}},
        to_ascii(hist3_min[7:4]), to_ascii(hist3_min[3:0]), CHAR_M, CHAR_SPACE,
        to_ascii(hist4_min[7:4]), to_ascii(hist4_min[3:0]), CHAR_M, CHAR_SPACE,
        to_ascii(hist5_min[7:4]), to_ascii(hist5_min[3:0]), CHAR_M, CHAR_SPACE,
        to_ascii(hist6_min[7:4]), to_ascii(hist6_min[3:0]), CHAR_M
    };

    // line7: 下边界+距离
    wire [167:0] line7 = {
        {8{CHAR_EQUAL}},
        8'h44, 8'h49, 8'h53, CHAR_COLON, CHAR_SPACE, // "DIS: "
        to_ascii(dis[11:8]), to_ascii(dis[7:4]), to_ascii(dis[3:0]), // 3位距离
        8'h63, 8'h6D, // "cm"
        {6{CHAR_EQUAL}}
    };

    // ====== 拼接所有行 ======
    assign str_data = {line7, line6, line5, line4, line3, line2, line1, line0};

endmodule