module pass(
    input clk, reset_local, reset_pass,
    input in,
    output passreset,
    output reg out,
    output reg [7:0] LED
    );

    wire clk_500ms, flip;
    reg [25:0] count;

    always @(posedge clk) begin
        if (reset) begin
            clk_500ms <= 0;
            count <= 0;
        end
        else if (count == 50000000) begin
            clk_500ms <= ~clk_500ms;
            count <= 0;
        end
        else
            count <= count + 1;
    end

    always @(posedge clk) begin
        if (reset_local || reset_pass) begin
            LED <= 8'b00000000;
        end
        else if (flip ^ clk_500ms)
            {LED[0], LED[7:1]} <= {1'b0, LED[6:0]};
        flip <= clk_500ms; // 500ms翻转信号
    end

    assign passreset = reset_local; // 复位信号
endmodule