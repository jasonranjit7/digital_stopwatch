#clk
create_clock -period 20.000 -name clk [get_ports clk]
set_property -dict { PACKAGE_PIN N11    IOSTANDARD LVCMOS33 } [get_ports {clk}];

#i/p
set_property -dict { PACKAGE_PIN L5    IOSTANDARD LVCMOS33 } [get_ports rst];
set_property -dict { PACKAGE_PIN L4    IOSTANDARD LVCMOS33 } [get_ports tick_rst];
set_property -dict { PACKAGE_PIN M4    IOSTANDARD LVCMOS33 } [get_ports start_stop];
set_property -dict { PACKAGE_PIN M2    IOSTANDARD LVCMOS33 } [get_ports lap];
set_property -dict { PACKAGE_PIN M1    IOSTANDARD LVCMOS33 } [get_ports clear];

#o/p
set_property -dict { PACKAGE_PIN J3    IOSTANDARD LVCMOS33 } [get_ports {time_count[0]}];
set_property -dict { PACKAGE_PIN H3    IOSTANDARD LVCMOS33 } [get_ports {time_count[1]}];
set_property -dict { PACKAGE_PIN J1    IOSTANDARD LVCMOS33 } [get_ports {time_count[2]}];
set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports {time_count[3]}];
set_property -dict { PACKAGE_PIN L3    IOSTANDARD LVCMOS33 } [get_ports {time_count[4]}];
set_property -dict { PACKAGE_PIN L2    IOSTANDARD LVCMOS33 } [get_ports {time_count[5]}];
set_property -dict { PACKAGE_PIN K3    IOSTANDARD LVCMOS33 } [get_ports {time_count[6]}];
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports {time_count[7]}];
set_property -dict { PACKAGE_PIN K5    IOSTANDARD LVCMOS33 } [get_ports {time_count[8]}];
set_property -dict { PACKAGE_PIN P6    IOSTANDARD LVCMOS33 } [get_ports {time_count[9]}];
set_property -dict { PACKAGE_PIN R7    IOSTANDARD LVCMOS33 } [get_ports {time_count[10]}];
set_property -dict { PACKAGE_PIN R6    IOSTANDARD LVCMOS33 } [get_ports {time_count[11]}];
set_property -dict { PACKAGE_PIN T5    IOSTANDARD LVCMOS33 } [get_ports {time_count[12]}];
set_property -dict { PACKAGE_PIN R5    IOSTANDARD LVCMOS33 } [get_ports {time_count[13]}];
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports {time_count[14]}];
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports {time_count[15]}];

