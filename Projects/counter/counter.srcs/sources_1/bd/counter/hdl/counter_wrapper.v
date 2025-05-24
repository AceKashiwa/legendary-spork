//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Thu Apr 26 14:47:57 2018
//Host        : PC-20170807EJYX running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target counter_wrapper.bd
//Design      : counter_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module counter_wrapper
   (clk,
    rst_n,
    seg7_1_7bit,
    seg7_1_an,
    seg7_1_dp);
  input clk;
  input rst_n;
  output [6:0]seg7_1_7bit;
  output [3:0]seg7_1_an;
  output seg7_1_dp;

  wire clk;
  wire rst_n;
  wire [6:0]seg7_1_7bit;
  wire [3:0]seg7_1_an;
  wire seg7_1_dp;

  counter counter_i
       (.clk(clk),
        .rst_n(rst_n),
        .seg7_1_7bit(seg7_1_7bit),
        .seg7_1_an(seg7_1_an),
        .seg7_1_dp(seg7_1_dp));
endmodule
