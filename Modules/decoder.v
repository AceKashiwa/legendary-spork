// 3线-8线译码器（输出低电平有效）
module decoder_38 (
    output reg [7:0] out,
    input      [2:0] in
);
    always @(*) begin
        case (in)
            3'd0: out = 8'b1111_1110;
            3'd1: out = 8'b1111_1101;
            3'd2: out = 8'b1111_1011;
            3'd3: out = 8'b1111_0111;
            3'd4: out = 8'b1110_1111;
            3'd5: out = 8'b1101_1111;
            3'd6: out = 8'b1011_1111;
            3'd7: out = 8'b0111_1111;
            default: out = 8'b1111_1111;
        endcase
    end
endmodule

// BCD码-七段共阴数码管译码器
module decode4_7 (
    output reg a, b, c, d, e, f, g,
    input  [3:0] din
);
    always @(*) begin
        case (din)
            4'd0: {a,b,c,d,e,f,g} = 7'b1111110;
            4'd1: {a,b,c,d,e,f,g} = 7'b0110000;
            4'd2: {a,b,c,d,e,f,g} = 7'b1101101;
            4'd3: {a,b,c,d,e,f,g} = 7'b1111001;
            4'd4: {a,b,c,d,e,f,g} = 7'b0110011;
            4'd5: {a,b,c,d,e,f,g} = 7'b1011011;
            4'd6: {a,b,c,d,e,f,g} = 7'b1011111;
            4'd7: {a,b,c,d,e,f,g} = 7'b1110000;
            4'd8: {a,b,c,d,e,f,g} = 7'b1111111;
            4'd9: {a,b,c,d,e,f,g} = 7'b1111011;
            default: {a,b,c,d,e,f,g} = 7'bx;
        endcase
    end
endmodule