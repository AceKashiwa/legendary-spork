`timescale 1ns / 1ps

module Button_tb;
    reg clk;
    reg reset;
    reg button_in;
    wire button_out;

    Button uut (
        .clk(clk),
        .reset(reset),
        .button_in(button_in),
        .button_out(button_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        button_in = 0;
        #50 reset = 0;
        
        // 测试1：简单的按钮按下和释放
        press_button(100, 200);
        
        // 测试2：带有去抖动的按钮按下
        debounce_test();
        
        // 测试3：快速连续的按钮按下
        fast_press(3, 50);
        
        // 测试4：长时间按下按钮
        press_button(500, 100);

        // 测试5：短时间按下按钮
        press_button(20, 100);

        $stop;
    end

    // 按钮按下任务
    task press_button(input integer press_duration, input integer release_duration);
        begin
            button_in = 1; #press_duration;
            button_in = 0; #release_duration;
        end
    endtask

    // 去抖动测试任务
    task debounce_test();
        begin
            #200;
            button_in = 1; #10;
            button_in = 0; #10;
            button_in = 1; #10;
            button_in = 0; #10;
            button_in = 1; #200;
            button_in = 0;
        end
    endtask

    // 快速连续按下任务
    task fast_press(input integer repeat_count, input integer duration);
        begin
            #200;
            repeat (repeat_count) begin
                button_in = 1; #duration;
                button_in = 0; #duration;
            end
        end
    endtask
endmodule

`timescale 1ns / 1ps

module E_LOCK_FSM_tb;

    // 输入信号
    reg clk;
    reg reset;
    reg b0;
    reg b1;

    // 输出信号
    wire out;
    wire [31:0] hex_display;

    // 实例化待测试单元 (UUT)
    E_LOCK_FSM uut (
        .clk(clk),
        .reset(reset),
        .b0(b0),
        .b1(b1),
        .out(out),
        .hex_display(hex_display)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 时钟周期为10ns
    end

    initial begin
        // 初始化输入信号
        reset = 1;
        b0 = 0;
        b1 = 0;

        // 等待 100 ns 以完成全局复位
        #95;
        reset = 0;

        // 测试1：输入密码序列 0110110
        b0 = 1; #4; b0 = 0; #6; // 0
        b1 = 1; #4; b1 = 0; #6; // 1
        b1 = 1; #4; b1 = 0; #6; // 1
        b0 = 1; #4; b0 = 0; #6; // 0
        b1 = 1; #4; b1 = 0; #6; // 1
        b1 = 1; #4; b1 = 0; #6; // 1
        b0 = 1; #4; b0 = 0; #6; // 0

        // 检查解锁信号
        if (out) begin
            $display("测试通过：密码序列 0110110 解锁成功");
        end else begin
            $display("测试失败：密码序列 0110110 解锁失败");
        end

        // 测试2：错误的密码序列
        b0 = 1; #4; b0 = 0; #6; // 0
        b1 = 1; #4; b1 = 0; #6; // 1
        b0 = 1; #4; b0 = 0; #6; // 0
        b1 = 1; #4; b1 = 0; #6; // 1
        b1 = 1; #4; b1 = 0; #6; // 1
        b0 = 1; #4; b0 = 0; #6; // 0

        // 检查解锁信号
        if (out) begin
            $display("测试失败：错误的密码序列解锁成功");
        end else begin
            $display("测试通过：错误的密码序列未解锁");
        end

        $stop;
    end

endmodule