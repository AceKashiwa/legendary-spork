//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
//Date        : Thu Apr 26 14:47:57 2018
//Host        : PC-20170807EJYX running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target counter.bd
//Design      : counter
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "counter,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=counter,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "counter.hwdef" *) 
module counter
   (clk,
    rst_n,
    seg7_1_7bit,
    seg7_1_an,
    seg7_1_dp);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, CLK_DOMAIN counter_clk_0, FREQ_HZ 100000000, PHASE 0.000" *) input clk;
  input rst_n;
  output [6:0]seg7_1_7bit;
  output [3:0]seg7_1_an;
  output seg7_1_dp;

  wire [15:0]c_counter_binary_0_Q;
  wire clk_0_1;
  wire clk_div_10Hz_0_clk_sys;
  wire rst_n_1;
  wire [6:0]seg7_hex_0_a_to_g;
  wire [3:0]seg7_hex_0_an;
  wire seg7_hex_0_dp;

  assign clk_0_1 = clk;
  assign rst_n_1 = rst_n;
  assign seg7_1_7bit[6:0] = seg7_hex_0_a_to_g;
  assign seg7_1_an[3:0] = seg7_hex_0_an;
  assign seg7_1_dp = seg7_hex_0_dp;
  counter_c_counter_binary_0_0 c_counter_binary_0
       (.CLK(clk_div_10Hz_0_clk_sys),
        .Q(c_counter_binary_0_Q));
  counter_clk_div_10Hz_0_0 clk_div_10Hz_0
       (.clk(clk_0_1),
        .clk_sys(clk_div_10Hz_0_clk_sys));
  counter_seg7_hex_0_0 seg7_hex_0
       (.a_to_g(seg7_hex_0_a_to_g),
        .an(seg7_hex_0_an),
        .clk(clk_0_1),
        .clr(rst_n_1),
        .dp(seg7_hex_0_dp),
        .x(c_counter_binary_0_Q));
endmodule
