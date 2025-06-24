`timescale 1ns/1ps

module run(
    input        clk,         // 时钟
    input        rst_n,       // 低有效复位
    input  [2:0] dir,         // 运动方向控制：000-停止 001-前进 010-后退 011-左转 100-右转
    output reg   in1,         // L298N IN1
    output reg   in2,         // L298N IN2
    output reg   in3,         // L298N IN3
    output reg   in4,         // L298N IN4
    output reg   ena,         // L298N ENA（左电机使能）
    output reg   enb          // L298N ENB（右电机使能）
);

    // 运动方向编码
    localparam STOP  = 3'b000;
    localparam FORWARD = 3'b001;
    localparam BACK    = 3'b010;
    localparam LEFT    = 3'b011;
    localparam RIGHT   = 3'b100;

    // 低频时钟分频（如1kHz，周期1ms，适合运动节拍）
    reg [16:0] clkdiv = 0;
    reg slow_clk = 0;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clkdiv <= 0;
            slow_clk <= 0;
        end else if (clkdiv == 49_999) begin // 100_000_000/50_000=2_000Hz，slow_clk周期为1ms
            clkdiv <= 0;
            slow_clk <= ~slow_clk;
        end else begin
            clkdiv <= clkdiv + 1;
        end
    end

    // 运动控制逻辑用slow_clk驱动
    always @(posedge slow_clk or negedge rst_n) begin
        if (!rst_n) begin
            in1 <= 0; in2 <= 0; in3 <= 0; in4 <= 0; ena <= 0; enb <= 0;
        end else begin
            case (dir)
                3'b001: begin // 前进
                    in1 <= 1; in2 <= 0; in3 <= 1; in4 <= 0; ena <= 1; enb <= 1;
                end
                3'b010: begin // 后退
                    in1 <= 0; in2 <= 1; in3 <= 0; in4 <= 1; ena <= 1; enb <= 1;
                end
                3'b011: begin // 左转
                    in1 <= 0; in2 <= 1; in3 <= 1; in4 <= 0; ena <= 1; enb <= 1;
                end
                3'b100: begin // 右转
                    in1 <= 1; in2 <= 0; in3 <= 0; in4 <= 1; ena <= 1; enb <= 1;
                end
                default: begin // 停止
                    in1 <= 0; in2 <= 0; in3 <= 0; in4 <= 0; ena <= 0; enb <= 0;
                end
            endcase
        end
    end

endmodule