// 通用 D 触发器（可配置位宽）
module dff #(
    parameter WIDTH = 1
)(
    input  wire              clk,
    input  wire [WIDTH-1:0]  d,
    output reg  [WIDTH-1:0]  q
);
    always @ (posedge clk)
        q <= d;
endmodule

// 带同步清零的 D 触发器
module dffr #(
    parameter WIDTH = 1
)(
    input  wire              clk,
    input  wire              r,   // 同步清零信号，高有效
    input  wire [WIDTH-1:0]  d,
    output reg  [WIDTH-1:0]  q
);
    always @ (posedge clk)
        if (r)
            q <= {WIDTH{1'b0}};
        else
            q <= d;
endmodule

// 带同步清零和使能的 D 触发器
module dffre #(
    parameter WIDTH = 1
)(
    input  wire              clk,
    input  wire              r,   // 同步清零信号，高有效
    input  wire              en,  // 使能信号，高有效
    input  wire [WIDTH-1:0]  d,
    output reg  [WIDTH-1:0]  q
);
    always @ (posedge clk)
        if (r)
            q <= {WIDTH{1'b0}};
        else if (en)
            q <= d;
        // else q <= q; // 可省略，保持原值
endmodule