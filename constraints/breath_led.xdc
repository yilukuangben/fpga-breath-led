# Xilinx XDC constraints for breath_led
# Replace PACKAGE_PIN values with those for your board.

# Clock
create_clock -name sys_clk -period 20.000 [get_ports clk]

# Reset (active-low)
set_property PACKAGE_PIN P17 [get_ports rstn]
set_property IOSTANDARD LVCMOS33 [get_ports rstn]

# LED PWM output
set_property PACKAGE_PIN P15 [get_ports led_pwm]
set_property IOSTANDARD LVCMOS33 [get_ports led_pwm]