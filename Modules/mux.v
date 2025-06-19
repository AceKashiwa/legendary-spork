module mux2to1 #(
    parameter N = 1
)(
    input  wire [N-1:0] in0,
    input  wire [N-1:0] in1,
    input  wire         sel,
    output wire [N-1:0] y
);
    assign y = sel ? in1 : in0;
endmodule

module mux4to1 #(
    parameter N = 1
)(
    input  wire [N-1:0] in0,
    input  wire [N-1:0] in1,
    input  wire [N-1:0] in2,
    input  wire [N-1:0] in3,
    input  wire         sel0,
    input  wire         sel1,
    output wire [N-1:0] y
);
    wire [N-1:0] y0, y1;

    mux2to1 #(.N(N)) u0 (
        .in0(in0),
        .in1(in1),
        .sel(sel0),
        .y(y0)
    );

    mux2to1 #(.N(N)) u1 (
        .in0(in2),
        .in1(in3),
        .sel(sel0),
        .y(y1)
    );

    mux2to1 #(.N(N)) u2 (
        .in0(y0),
        .in1(y1),
        .sel(sel1),
        .y(y)
    );
endmodule

