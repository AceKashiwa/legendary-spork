set_property IOSTANDARD LVCMOS33 [get_ports b0_in]
set_property PACKAGE_PIN R11 [get_ports b0_in]
set_property IOSTANDARD LVCMOS33 [get_ports b1_in]
set_property PACKAGE_PIN R17 [get_ports b1_in]
set_property IOSTANDARD LVCMOS33 [get_ports unlock]
set_property PACKAGE_PIN K2 [get_ports unlock]

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property PACKAGE_PIN P17 [get_ports clk]
set_property PACKAGE_PIN U4 [get_ports reset]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets reset_IBUF]
