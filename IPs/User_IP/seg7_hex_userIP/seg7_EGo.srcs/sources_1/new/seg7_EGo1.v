`timescale 1ns / 1ps

module seg7_hex(
    input       [15:0] x,
    input              clk,
    input              clr,
    output reg  [6:0]  a_to_g,
    output reg  [3:0]  an,
    output wire        dp 
   );

  wire [1:0]  s;
  wire [3:0]  aen;
  reg  [3:0]  digit;
  reg  [19:0] clkdiv;

  assign dp  = 1'b0;
  assign aen = 4'b1111; 
  assign s   = clkdiv[19:18];
  
  always @(posedge clk or negedge clr) 
    begin
      if ( clr == 0)
        clkdiv <= 0;
      else
        clkdiv <= clkdiv+1;
    end
  
  always @(posedge clk)
    case(s)
        2'd0:    digit = x[15:12]; 
        2'd1:    digit = x[11:8]; 
        2'd2:    digit = x[7:4];  
        2'd3:    digit = x[3:0]; 
        default: digit = x[3:0];
    endcase
    
  always @(*)
    begin
      an = 4'b0000;
      if(aen[s] == 1)
         an[s]  =  1;
    end

  always @(*)
    case(digit)
        0:       a_to_g = 7'b0111111;
        1:       a_to_g = 7'b0000110;
        2:       a_to_g = 7'b1011011;
        3:       a_to_g = 7'b1001111;
        4:       a_to_g = 7'b1100110;
        5:       a_to_g = 7'b1101101;
        6:       a_to_g = 7'b1111101;
        7:       a_to_g = 7'b0000111;
        8:       a_to_g = 7'b1111111;
        9:       a_to_g = 7'b1101111;
        'hA:     a_to_g = 7'b1110111;
        'hB:     a_to_g = 7'b1111100;
        'hC:     a_to_g = 7'b1100001;
        'hD:     a_to_g = 7'b1011110; 
        'hE:     a_to_g = 7'b1111001; 
        'hF:     a_to_g = 7'b1110001;
        default: a_to_g = 7'b1111111;
    endcase

endmodule