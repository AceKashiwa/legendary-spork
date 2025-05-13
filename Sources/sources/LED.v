// 时钟分频器模块
module clock_divider(
    input wire clk,         // 输入时钟信号
    input wire reset,       // 复位信号
    output reg slow_clk     // 输出分频后的慢时钟信号
);
    parameter DIV_FACTOR = 500000000; // 分频因子，假设输入时钟为 100MHz，目标频率为 2Hz
    reg [25:0] counter;             // 分频计数器（需要 26 位以支持 50,000,000）

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            slow_clk <= 0;
        end else if (counter == DIV_FACTOR - 1) begin
            counter <= 0;
            slow_clk <= ~slow_clk; // 翻转慢时钟信号
        end else begin
            counter <= counter + 1;
        end
    end
endmodule

// 移位方向控制模块
module shift_direction(
    input clk, 
    input enable, 
    input direction, 
    input reset, 
    output reg [7:0] Q
);
    always @(posedge clk or posedge reset) begin
        if (reset) 
            Q <= 8'b0000_0001;  // 复位初始状态
        else if (enable) begin
            if (direction) 
                Q <= {Q[6:0], Q[7]};  // 左移
            else 
                Q <= {Q[0], Q[7:1]};  // 右移
        end
    end
endmodule

// 主模块：流水灯控制
module FWLight (
    input clk, 
    input reset, 
    input direction, 
    input en,
    output [7:0] led
);
    wire clk_2Hz;

    // 实例化时钟分频器
    clock_divider clock_divider1(
        .clk(clk), 
        .reset(reset), 
        .slow_clk(clk_2Hz)
    );

    // 实例化移位模块
    shift_direction shift_direction1(
        .clk(clk_2Hz), 
        .enable(en),
        .direction(direction), 
        .reset(reset), 
        .Q(led)
    );
endmodule