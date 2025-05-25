module master_fsm (
    input clk,                // 时钟信号
    input reset,              // 复位信号（高电平有效）
    input [1:0] data_in,      // 2-bit 输入信号
    input time_eq_settime,    // 时间等于设定时间标志
    input selfcaught,         // 自捕获标志
    input stop,              // 停止标志
    input caught,             // 捕获标志
    input time_ge_ddl,        // 时间超过截止时间标志
    output reg [2:0] state_out, // 当前状态（调试用）
    output reg [7:0] win_counter,  // 8-bit 胜利计数器（0~255）
    output reg [7:0] lose_counter  // 8-bit 失败计数器（0~255）
);

    // 状态定义
    parameter RESET       = 3'b000; // 复位状态
    parameter TIM         = 3'b001; // 初始状态
    parameter TASK_MASTER = 3'b010; // 任务执行状态
    parameter CAUGHT      = 3'b011; // 被捕获状态
    parameter STOP        = 3'b100; // 任务完成状态
    parameter FAILED      = 3'b101; // 任务失败状态

    reg [2:0] current_state, next_state; // 当前状态和下一状态
    reg win_pulse, lose_pulse;           // 脉冲信号（用于驱动计数器）

    // 状态寄存器更新
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= RESET;
            win_counter <= 8'd0;    // 复位时清零
            lose_counter <= 8'd0;
        end else begin
            current_state <= next_state;
            
            // 胜利计数器（检测 win_pulse 上升沿）
            if (win_pulse) begin
                if (win_counter < 8'd255) // 防止溢出
                    win_counter <= win_counter + 1;
            end
            
            // 失败计数器（检测 lose_pulse 上升沿）
            if (lose_pulse) begin
                if (lose_counter < 8'd255) // 防止溢出
                    lose_counter <= lose_counter + 1;
            end
        end
    end

    // 状态转移逻辑
    always @(*) begin
        next_state = current_state; // 默认保持当前状态
        win_pulse = 0;
        lose_pulse = 0;

        case (current_state)
            RESET:
                if (data_in == 2'b01) next_state = TIM;
            
            TIM:
                if (time_eq_settime) begin
                    next_state = TASK_MASTER;
                end else if (selfcaught == 0 && time_ge_ddl) begin
                    next_state = FAILED;
                    lose_pulse = 1; // 触发失败计数器
                end
            
            TASK_MASTER:
                if (caught) begin
                    next_state = CAUGHT;
                end else if (stop) begin
                    next_state = STOP;
                    win_pulse = 1; // 触发胜利计数器
                end
            
            CAUGHT:
                if (caught == 0) begin
                    if (stop) begin
                        next_state = STOP;
                        win_pulse = 1;
                    end else begin
                        next_state = TASK_MASTER;
                    end
                end
            
            STOP:
                if (data_in == 2'b01) next_state = TIM;
            
            FAILED:
                if (data_in == 2'b01) next_state = TIM;
        endcase
    end

    // 状态输出（调试用）
    always @(*) begin
        state_out = current_state;
    end

endmodule
