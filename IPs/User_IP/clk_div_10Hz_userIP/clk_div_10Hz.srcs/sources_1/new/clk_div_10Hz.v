`timescale 1ns / 1ps

module clk_div(
    clk,            //100MHz
    clk_sys         //10Hz
    );
  input clk;
  output clk_sys;
    
  reg clk_sys = 0;
  reg [22:0]  div_counter = 0;
    
  always @(posedge clk) begin
    if(div_counter>=5000000) 
        begin     
          clk_sys<=~clk_sys;
          div_counter<=0;
        end 
    else 
        div_counter <= div_counter + 1;
    end

endmodule