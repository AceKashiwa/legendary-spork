module Register #(parameter N = 8) (
    input clk, load, clear,
    input [N-1:0] loaddata,
    output reg [N-1:0] outdata
);
    always @(posedge clk or posedge clear) begin
        if (clear)
            outdata <= 0;
        else if (load)
            outdata <= loaddata;
    end
endmodule