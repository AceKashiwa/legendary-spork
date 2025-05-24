vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 "+incdir+../../../../debug_demo.srcs/sources_1/ip/ila_0_3/ila_v6_0_1/hdl/verilog" "+incdir+../../../../debug_demo.srcs/sources_1/ip/ila_0_3/ltlib_v1_0_0/hdl/verilog" "+incdir+../../../../debug_demo.srcs/sources_1/ip/ila_0_3/xsdbm_v1_1_1/hdl/verilog" "+incdir+../../../../debug_demo.srcs/sources_1/ip/ila_0_3/xsdbs_v1_0_2/hdl/verilog" "+incdir+../../../../debug_demo.srcs/sources_1/ip/ila_0_3/ila_v6_0_1/hdl/verilog" "+incdir+../../../../debug_demo.srcs/sources_1/ip/ila_0_3/ltlib_v1_0_0/hdl/verilog" "+incdir+../../../../debug_demo.srcs/sources_1/ip/ila_0_3/xsdbm_v1_1_1/hdl/verilog" "+incdir+../../../../debug_demo.srcs/sources_1/ip/ila_0_3/xsdbs_v1_0_2/hdl/verilog" \
"../../../../debug_demo.srcs/sources_1/ip/ila_0_3/sim/ila_0.v" \


vlog -work xil_defaultlib "glbl.v"

