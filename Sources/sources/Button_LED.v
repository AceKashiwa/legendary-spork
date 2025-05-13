module top(
    input clk, reset, button_in,
    input [1:0] switch,
    output reg light
    );
    // 实例化 onoff_sync, remove_2ff, remove_debounce, remove_up
    wire light1, light2, light3, light4;
    onoff_sync uut1(.clk(clk), .reset(reset), .button_in(button_in), .light(light1));
    remove_2ff uut2(.clk(clk), .reset(reset), .button_in(button_in), .light(light2));
    remove_debounce uut3(.clk(clk), .reset(reset), .button_in(button_in), .light(light3));
    remove_up uut4(.clk(clk), .reset(reset), .button_in(button_in), .light(light4));

    // 选择待测模块
    always @(switch) begin
        case (switch)
            2'b00: light <= light1;
            2'b01: light <= light2;
            2'b10: light <= light3;
            2'b11: light <= light4;
        endcase
    end
endmodule


module onoff_sync(
    input clk, reset, button_in,
    output reg light
    );

    // 二级触发器
    reg button, btemp;
    always @(posedge clk) begin
        {button, btemp} <= {btemp, button_in};
    end

    // 消抖
    wire bpressed;
    debounce db1(.reset(reset), .clk(clk), .noisy(button), .clean(bpressed));

    // 检测跳变
    reg old_bpressed;
    always @(posedge clk) begin
        if (reset) begin
            light <= 0;
            old_bpressed <= 0;
        end else if (old_bpressed == 0 && bpressed == 1)
            light <= ~light;
        old_bpressed <= bpressed; 
    end
endmodule

module remove_2ff(
    input clk, reset, button_in,
    output reg light
    );

    // 消抖
    wire bpressed;
    debounce db1(.reset(reset), .clk(clk), .noisy(button_in), .clean(bpressed));

    // 检测跳变
    reg old_bpressed;
    always @(posedge clk) begin
        if (reset) begin
            light <= 0;
            old_bpressed <= 0;
        end else if (old_bpressed == 0 && bpressed == 1)
            light <= ~light;
        old_bpressed <= bpressed; 
    end
endmodule

module remove_debounce(
    input clk, reset, button_in,
    output reg light
    );

    // 二级触发器
    reg button, btemp;
    always @(posedge clk) begin
        {button, btemp} <= {btemp, button_in};
    end

    // 检测跳变
    reg old_bpressed;
    always @(posedge clk) begin
        if (reset) begin
            light <= 0;
            old_bpressed <= 0;
        end else if (old_bpressed == 0 && button_in == 1)
            light <= ~light;
        old_bpressed <= button_in; 
    end
endmodule

module remove_up(
    input clk, reset, button_in,
    output reg light = 0
    );

    // 二级触发器
    reg button, btemp;
    always @(posedge clk) begin
        {button, btemp} <= {btemp, button_in};
    end

    // 消抖
    wire bpressed;
    debounce db1(.reset(reset), .clk(clk), .noisy(button), .clean(bpressed));

    // 检测跳变
    always @(posedge bpressed) begin
        light <= ~light;
    end
endmodule

module debounce(reset, clk, noisy, clean);
    input reset, clk, noisy;
    output reg clean;

    parameter NDELAY =10;
    parameter NBITS = 20;

    reg [NBITS-1:0] count;
    reg xnew;

    always @ (posedge clk)
    begin
        if (reset)
        begin
            xnew <= noisy;
            clean <= noisy;
            count <= 0;
        end
        else if (noisy != xnew)
        begin
            xnew <= noisy;
            count <= 0;
        end
        else if (count == NDELAY)
            clean <= xnew;
        else
            count <= count + 1;
    end
endmodule

