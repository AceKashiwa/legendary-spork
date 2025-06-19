// n 位无符号数比较器
module compare_n #(
    parameter n = 1 // n 为比较器的位数
) (
    output great,
    output equal,
    output little,
    input  [n-1:0] ina,
    input  [n-1:0] inb
);
    assign great = (ina > inb);
    assign equal = (ina == inb);
    assign little = (ina < inb);
endmodule

// n 位有符号数比较器（用加法器实现，补码形式）
module signed_compare_n #(
    parameter n = 4 // n 为比较器的位数
) (
    output great,
    output equal,
    output little,
    input  [n-1:0] ina,
    input  [n-1:0] inb
);
    // 计算 ina - inb，符号扩展防止溢出
    wire [n:0] result;
    full_adder #(.N(n+1)) a1 (
        .a({ina[n-1], ina}),         // 符号扩展
        .b({~inb[n-1], ~inb}),      // b 的反码
        .ci(1'b1),
        .s(result),
        .co()
    );

    // 差为正、零、负分别表示大于、等于、小于
    assign great = (~result[n]) && (|result); // 差为正
    assign equal = ~|result;                  // 差为 0
    assign little = result[n];                // 差为负
endmodule