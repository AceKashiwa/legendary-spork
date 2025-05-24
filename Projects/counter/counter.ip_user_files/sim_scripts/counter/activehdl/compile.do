vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xbip_utils_v3_0_8
vlib activehdl/c_reg_fd_v12_0_4
vlib activehdl/xbip_dsp48_wrapper_v3_0_4
vlib activehdl/xbip_pipe_v3_0_4
vlib activehdl/xbip_dsp48_addsub_v3_0_4
vlib activehdl/xbip_addsub_v3_0_4
vlib activehdl/c_addsub_v12_0_11
vlib activehdl/c_gate_bit_v12_0_4
vlib activehdl/xbip_counter_v3_0_4
vlib activehdl/c_counter_binary_v12_0_11

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xbip_utils_v3_0_8 activehdl/xbip_utils_v3_0_8
vmap c_reg_fd_v12_0_4 activehdl/c_reg_fd_v12_0_4
vmap xbip_dsp48_wrapper_v3_0_4 activehdl/xbip_dsp48_wrapper_v3_0_4
vmap xbip_pipe_v3_0_4 activehdl/xbip_pipe_v3_0_4
vmap xbip_dsp48_addsub_v3_0_4 activehdl/xbip_dsp48_addsub_v3_0_4
vmap xbip_addsub_v3_0_4 activehdl/xbip_addsub_v3_0_4
vmap c_addsub_v12_0_11 activehdl/c_addsub_v12_0_11
vmap c_gate_bit_v12_0_4 activehdl/c_gate_bit_v12_0_4
vmap xbip_counter_v3_0_4 activehdl/xbip_counter_v3_0_4
vmap c_counter_binary_v12_0_11 activehdl/c_counter_binary_v12_0_11

vlog -work xil_defaultlib  -v2k5 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/ea72/clk_div_10Hz.srcs/sources_1/new/clk_div_10Hz.v" \
"../../../../counter.srcs/sources_1/bd/counter/ip/counter_clk_div_10Hz_0_0/sim/counter_clk_div_10Hz_0_0.v" \

vcom -work xbip_utils_v3_0_8 -93 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/4173/hdl/xbip_utils_v3_0_vh_rfs.vhd" \

vcom -work c_reg_fd_v12_0_4 -93 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/e6f0/hdl/c_reg_fd_v12_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_wrapper_v3_0_4 -93 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/da55/hdl/xbip_dsp48_wrapper_v3_0_vh_rfs.vhd" \

vcom -work xbip_pipe_v3_0_4 -93 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/ee5e/hdl/xbip_pipe_v3_0_vh_rfs.vhd" \

vcom -work xbip_dsp48_addsub_v3_0_4 -93 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/7b8d/hdl/xbip_dsp48_addsub_v3_0_vh_rfs.vhd" \

vcom -work xbip_addsub_v3_0_4 -93 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/c060/hdl/xbip_addsub_v3_0_vh_rfs.vhd" \

vcom -work c_addsub_v12_0_11 -93 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/1607/hdl/c_addsub_v12_0_vh_rfs.vhd" \

vcom -work c_gate_bit_v12_0_4 -93 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/4b95/hdl/c_gate_bit_v12_0_vh_rfs.vhd" \

vcom -work xbip_counter_v3_0_4 -93 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/df83/hdl/xbip_counter_v3_0_vh_rfs.vhd" \

vcom -work c_counter_binary_v12_0_11 -93 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/ffc8/hdl/c_counter_binary_v12_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../../counter.srcs/sources_1/bd/counter/ip/counter_c_counter_binary_0_0/sim/counter_c_counter_binary_0_0.vhd" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../counter.srcs/sources_1/bd/counter/ipshared/23ab/seg7_EGo.srcs/sources_1/new/seg7_EGo1.v" \
"../../../../counter.srcs/sources_1/bd/counter/ip/counter_seg7_hex_0_0/sim/counter_seg7_hex_0_0.v" \
"../../../../counter.srcs/sources_1/bd/counter/sim/counter.v" \

vlog -work xil_defaultlib \
"glbl.v"

