// LED 0.5Hz 轮流 reset

module stream_e(
    input clk, reset, start,    // 总开始信号
    input last_state, //next_state,
    output reg [7:0] LED,
    output state
    );

    reg [25:0] count;
    reg note, old_note;

    always @(posedge clk) begin
        // 1.复位信号
        if (reset) begin
            LED <= 8'b00000000;
            count <= 0;
        end
        // 2.上下板状态信号，上下板均为熄灭，开始工作
        else if (last_state == 1) begin   // 增加start
            LED <= 8'b00000001;
        end
        // 3.定时移位
        else if (count == 50000000) begin   // 100Mhz, 0.5s
            {LED[0], LED[7:1]} <= {1'b0, LED[6:0]};
            count <= 0;
        end
        else begin
            count <= count + 1; // 计数器
        end
    end

    assign state = (LED == 8'b00000000);    // 输出状态
endmodule

// LED 0.5Hz 轮流 reset

module stream(
    input clk, reset, start,    // 总开始信号
    input last_state, next_state,
    output reg [7:0] LED,
    output state
    );

    reg [25:0] count;
    reg note, old_note;
    reg [10:0] cnt;
    always @(posedge clk) begin
        // 1.复位信号
        if (reset) begin
            cnt=8;
            count <= 0;
        end
        // 2.上下板状态信号，上下板均为熄灭，开始工作
        else if (last_state && next_state && start) begin   // 增加start
            cnt=0;
        end
        // 3.定时移位
        else if (count == 50000000) begin   // 100Mhz, 0.5s
            cnt<=cnt+1;
            count <= 0;
        end
        else begin
            count <= count + 1; // 计数器
        end
        if(cnt==0) LED <=8'b00000001;
        if(cnt==1) LED <=8'b00000010;
        if(cnt==2) LED <=8'b00000100;
        if(cnt==3) LED <=8'b00001000;
        if(cnt==4) LED <=8'b00010000;
        if(cnt==5) LED <=8'b00100000;
        if(cnt==6) LED <=8'b01000000;
        if(cnt==7) LED <=8'b10000000;
        if(cnt==8) LED <=8'b00000000;
    end
    assign state = (LED == 8'b00000000);    // 输出状态
endmodule