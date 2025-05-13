module mux2to1 #(parameter N = 8) (
    input mux,
    input [N-1:0] Ina, Inb,
    output [N-1:0] out
);
    assign out = mux ? Inb : Ina;
endmodule