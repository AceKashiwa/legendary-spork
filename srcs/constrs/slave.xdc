# 时钟引脚 (100MHz)
set_property PACKAGE_PIN P17 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

# LED引脚 (与主控板相同)
set_property PACKAGE_PIN F6 [get_ports {leds[0]}]
set_property PACKAGE_PIN G4 [get_ports {leds[1]}]
set_property PACKAGE_PIN G3 [get_ports {leds[2]}]
set_property PACKAGE_PIN J4 [get_ports {leds[3]}]
set_property PACKAGE_PIN H4 [get_ports {leds[4]}]
set_property PACKAGE_PIN J3 [get_ports {leds[5]}]
set_property PACKAGE_PIN J2 [get_ports {leds[6]}]
set_property PACKAGE_PIN K2 [get_ports {leds[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[7]}]

# 输入来自前一级的 serial_in（例如：GPIO0）1
set_property PACKAGE_PIN B16 [get_ports serial_in]
set_property IOSTANDARD LVCMOS33 [get_ports serial_in]

# 输出到下一级的 serial_out（例如：GPIO1）3
set_property PACKAGE_PIN A15 [get_ports serial_out]
set_property IOSTANDARD LVCMOS33 [get_ports serial_out]

# 同步时钟使能信号 shift_clk_en（例如：GPIO2）5
set_property PACKAGE_PIN A13 [get_ports shift_clk_en]
set_property IOSTANDARD LVCMOS33 [get_ports shift_clk_en]
