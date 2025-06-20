module clk_self #(
    parameter DIV = 1
)(
    input clk,
    output reg clk_out
);
    reg [31:0] count = 0;
    initial clk_out = 0; // 初始化输出为0

    always @(posedge clk) begin
        if (count == DIV - 1)
        begin
            count <= 0;
            clk_out <= ~clk_out;
        end
        else
            count <= count + 1;
    end
endmodule