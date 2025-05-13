module top(
    input Start, clk,
    input [7:0] LED_IN,
    output [7:0] LED_OUT,
    output [7:0] LED_1, LED_2
    );

    // master m(.Start(Start), .clk(clk), .LED_OUT(LED_OUT), .LED_1(LED_1));
    slave s(.LED_IN(LED_IN), .LED_OUT(LED_OUT));
endmodule

module master(
    input Start, clk,
    output [7:0] LED_OUT,
    output [7:0] LED_1,LED_2
    );

    reg [23:0] LED_SEQ;
    reg [25:0] count;

    always @(posedge clk) begin
        if (~Start) begin   // 静默状态为全零
            count <= 0;
            LED_SEQ <= 24'h00000;
        end
        else if (LED_SEQ == 0)
            LED_SEQ <= 24'h00001;  // 进入初始状态
        else if (count == 50000000) begin
            count <= 0;
            LED_SEQ <= LED_SEQ << 1;    // 移位
        end
        else
            count <= count + 1;     //分频
    end

    assign LED_OUT = LED_SEQ[7:0];  // 主显示
    assign LED_1 = LED_SEQ[15:8];   // 从1
    assign LED_2 = LED_SEQ[23:16];  // 从2
endmodule

module slave(
    input [7:0] LED_IN,
    output [7:0] LED_OUT
    );

    assign LED_OUT = LED_IN;    // 直接显示
endmodule
