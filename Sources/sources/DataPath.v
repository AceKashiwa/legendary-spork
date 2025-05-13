module DataPath(
    input [7:0] N,
    input clk, rst,
    input NMUX, CountMUX, NLoad, CountLoad, OutputMUX, OE,
    output N_equal_0, N0_equal_0, Count_equal_4,
    output out
    );

    reg [7:0] Q;
    reg [3:0] count;

    wire [7:0] D1 = NMUX ? N : Q >> 1;
    wire [3:0] D2 = CountMUX ? 0 : count + 1;

    always @(posedge clk or posedge rst) begin
        if (rst) Q <= 0;
        else if (NLoad) Q <= D1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) count <= 0;
        else if (CountLoad) count <= D2;
    end

    assign N_equal_0 = (Q == 0);
    assign N0_equal_0 = (Q[0] == 0);
    assign Count_equal_4 = (count == 4);

    assign out = OE ? OutputMUX ? 1 : 0 : 0;
endmodule