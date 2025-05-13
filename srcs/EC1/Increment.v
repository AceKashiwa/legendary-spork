module Increment #(parameter N = 4) (
    input [N-1:0] IncInput,  // 输入值
    output [N-1:0] IncOutput // 输出值 (加1后的结果)
);
    assign IncOutput = IncInput + 1; // 加1操作
endmodule