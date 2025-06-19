// 1-bit Full Adder
module full_adder_1bit(
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign {cout, sum} = a + b + cin;
endmodule

// 4-bit Ripple Carry Adder
module adder_4bit(
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [3:0] sum
);
    wire [3:0] carry;
    full_adder_1bit fa0(.a(a[0]), .b(b[0]), .cin(1'b0),     .sum(sum[0]), .cout(carry[0]));
    full_adder_1bit fa1(.a(a[1]), .b(b[1]), .cin(carry[0]), .sum(sum[1]), .cout(carry[1]));
    full_adder_1bit fa2(.a(a[2]), .b(b[2]), .cin(carry[1]), .sum(sum[2]), .cout(carry[2]));
    full_adder_1bit fa3(.a(a[3]), .b(b[3]), .cin(carry[2]), .sum(sum[3]), .cout());
endmodule

// 4-bit Subtractor (using 2's complement)
module subtractor_4bit(
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [3:0] diff
);
    wire [3:0] carry;
    full_adder_1bit fa0(.a(a[0]), .b(~b[0]), .cin(1'b1),     .sum(diff[0]), .cout(carry[0]));
    full_adder_1bit fa1(.a(a[1]), .b(~b[1]), .cin(carry[0]), .sum(diff[1]), .cout(carry[1]));
    full_adder_1bit fa2(.a(a[2]), .b(~b[2]), .cin(carry[1]), .sum(diff[2]), .cout(carry[2]));
    full_adder_1bit fa3(.a(a[3]), .b(~b[3]), .cin(carry[2]), .sum(diff[3]), .cout());
endmodule