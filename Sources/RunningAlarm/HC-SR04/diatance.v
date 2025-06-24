`timescale 1ns / 1ps
module HC_SR04(
    input        clk,      // 100MHz系统时钟
    input        rst_n,    // 系统复位  低电平有效
    input        echo,     // 超声波接收端口  
    output       trig,     // 超声波控制端口  
    output [15:0] dis      // 超声波测量的距离（厘米）
);

    // 状态编码 独热码
    parameter idle = 3'b001,
              s0   = 3'b010,
              s1   = 3'b100;

    // 100ms周期参数，15us脉冲，100MHz下
    parameter ms_100ms = 1500 + (100_000 * 100); // 15us + 100ms

    reg [23:0] trig_cnt;
    reg [2:0]  cur_state;
    reg [2:0]  next_state;
    reg [24:0] echo_cnt;
    reg [24:0] echo_cnt_reg;

    // 触发信号分频计数
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            trig_cnt <= 0;
        else if (trig_cnt == ms_100ms - 1)
            trig_cnt <= 0;
        else
            trig_cnt <= trig_cnt + 1;
    end

    // 15us脉冲，100MHz下
    assign trig = (trig_cnt > 0 && trig_cnt < 1500) ? 1'b1 : 1'b0;

    // 状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cur_state <= idle;
        else
            cur_state <= next_state;
    end

    always @(*) begin
        case (cur_state)
            idle:  next_state = (echo == 1'b1) ? s0 : idle;
            s0:    next_state = (echo == 1'b0) ? s1 : s0;
            s1:    next_state = idle;
            default: next_state = idle;
        endcase
    end

    // 回波计数
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            echo_cnt     <= 0;
            echo_cnt_reg <= 0;
        end else begin
            case (cur_state)
                idle: begin
                    echo_cnt     <= 0;
                    echo_cnt_reg <= echo_cnt_reg;
                end
                s0: begin
                    echo_cnt     <= echo_cnt + 1;
                    echo_cnt_reg <= echo_cnt_reg;
                end
                s1: begin
                    echo_cnt     <= 0;
                    echo_cnt_reg <= echo_cnt;
                end
                default: begin
                    echo_cnt     <= 0;
                    echo_cnt_reg <= 0;
                end
            endcase
        end
    end

    // 距离计算，100MHz下，距离（cm）= echo_cnt_reg / 5882
    assign dis = echo_cnt_reg / 5882;

endmodule