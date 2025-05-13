module InstructionROM (
    input [3:0] ina,
    output reg [7:0] out
);
    reg [7:0] rom [15:0];

    initial begin
        // ROM initialization based on the provided instruction encoding
        rom[0] = 8'b01100000;
        rom[1] = 8'b10000000;
        rom[2] = 8'b10100000;
        rom[3] = 8'b11000001;
        rom[4] = 8'b11111111;
        rom[5] = 8'b00000000;
        rom[6] = 8'b00000000;
        rom[7] = 8'b00000000;
        rom[8] = 8'b00000000;
        rom[9] = 8'b00000000;
        rom[10] = 8'b00000000;
        rom[11] = 8'b00000000;
        rom[12] = 8'b00000000;
        rom[13] = 8'b00000000;
        rom[14] = 8'b00000000;
        rom[15] = 8'b00000000;
    end

    always @(*) begin
        out = rom[ina];
    end
endmodule