module timer_hms_top(
    input clk_100m,
    input rst_n,
    output [31:0] hms_hex
);

    wire clk_1hz;

    clk_div #(
        .DIV(100000000)
        .clk_100m(clk_100m),
        .rst_n(rst_n),
        .clk_1hz(clk_1hz)
    );

    timer_hms_core u_hms(
        .clk_1hz(clk_1hz),
        .rst_n(rst_n),
        .hms_hex(hms_hex)
    );

endmodule