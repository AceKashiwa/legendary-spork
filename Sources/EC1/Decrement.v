module Decrement #(parameter N = 8) (
    input [N-1:0] DecInput,
    output [N-1:0] DecOutput
);
    assign DecOutput = DecInput - 1;
endmodule