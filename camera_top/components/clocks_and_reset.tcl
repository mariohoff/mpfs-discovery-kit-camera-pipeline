# Creating SmartDesign "clocks_and_reset"
set sd_name {clocks_and_reset}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {EXT_RST_N} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MSS_PLL_LOCKS} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MSS_TO_FABRIC_RESETN} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_50MHz} -port_direction {IN} -port_is_pad {1}

sd_create_scalar_port -sd_name ${sd_name} -port_name {CLK_125MHz} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CLK_50MHz} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {DEVICE_INIT_DONE} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {FABRIC_POR_N} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {I2C_BCLK} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESETN_125MHz} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESETN_50MHz} -port_direction {OUT}



# Add AND2_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_0}



# Add AND2_1 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_1}



# Add CLKBUF_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {CLKBUF} -instance_name {CLKBUF_0}



# Add PF_CCC_GLOBAL_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_CCC_GLOBAL} -instance_name {PF_CCC_GLOBAL_0}



# Add PF_CLK_DIV_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_CLK_DIV_C0} -instance_name {PF_CLK_DIV_C0_0}



# Add PF_OSC_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_OSC_C0} -instance_name {PF_OSC_C0_0}



# Add PFSOC_INIT_MONITOR_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PFSOC_INIT_MONITOR_C0} -instance_name {PFSOC_INIT_MONITOR_C0_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PFSOC_INIT_MONITOR_C0_0:PCIE_INIT_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PFSOC_INIT_MONITOR_C0_0:USRAM_INIT_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PFSOC_INIT_MONITOR_C0_0:SRAM_INIT_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PFSOC_INIT_MONITOR_C0_0:XCVR_INIT_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PFSOC_INIT_MONITOR_C0_0:USRAM_INIT_FROM_SNVM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PFSOC_INIT_MONITOR_C0_0:USRAM_INIT_FROM_UPROM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PFSOC_INIT_MONITOR_C0_0:USRAM_INIT_FROM_SPI_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PFSOC_INIT_MONITOR_C0_0:SRAM_INIT_FROM_SNVM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PFSOC_INIT_MONITOR_C0_0:SRAM_INIT_FROM_UPROM_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PFSOC_INIT_MONITOR_C0_0:SRAM_INIT_FROM_SPI_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {PFSOC_INIT_MONITOR_C0_0:AUTOCALIB_DONE}



# Add RESET_50MHz_CLOCK_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {RESET_50MHz_CLOCK} -instance_name {RESET_50MHz_CLOCK_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_50MHz_CLOCK_0:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_50MHz_CLOCK_0:BANK_y_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_50MHz_CLOCK_0:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_50MHz_CLOCK_0:FF_US_RESTORE} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {RESET_50MHz_CLOCK_0:PLL_POWERDOWN_B}



# Add RESET_125MHz_CLOCK_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {RESET_125MHz_CLOCK} -instance_name {RESET_125MHz_CLOCK_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_125MHz_CLOCK_0:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_125MHz_CLOCK_0:BANK_y_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_125MHz_CLOCK_0:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {RESET_125MHz_CLOCK_0:FF_US_RESTORE} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {RESET_125MHz_CLOCK_0:PLL_POWERDOWN_B}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:A" "EXT_RST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:B" "MSS_TO_FABRIC_RESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:Y" "RESET_125MHz_CLOCK_0:EXT_RST_N" "RESET_50MHz_CLOCK_0:EXT_RST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_1:A" "MSS_PLL_LOCKS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_1:B" "PF_CCC_GLOBAL_0:PLL_LOCK_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_1:Y" "RESET_125MHz_CLOCK_0:PLL_LOCK" "RESET_50MHz_CLOCK_0:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLKBUF_0:PAD" "REF_CLK_50MHz" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLKBUF_0:Y" "PF_CCC_GLOBAL_0:REF_CLK_0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLK_125MHz" "PF_CCC_GLOBAL_0:OUT1_FABCLK_0" "RESET_125MHz_CLOCK_0:CLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLK_50MHz" "PF_CCC_GLOBAL_0:OUT0_FABCLK_0" "RESET_50MHz_CLOCK_0:CLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DEVICE_INIT_DONE" "PFSOC_INIT_MONITOR_C0_0:DEVICE_INIT_DONE" "RESET_125MHz_CLOCK_0:INIT_DONE" "RESET_50MHz_CLOCK_0:INIT_DONE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"FABRIC_POR_N" "PFSOC_INIT_MONITOR_C0_0:FABRIC_POR_N" "RESET_125MHz_CLOCK_0:FPGA_POR_N" "RESET_50MHz_CLOCK_0:FPGA_POR_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"I2C_BCLK" "PF_CLK_DIV_C0_0:CLK_OUT" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_CLK_DIV_C0_0:CLK_IN" "PF_OSC_C0_0:RCOSC_2MHZ_CLK_DIV" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"RESETN_125MHz" "RESET_125MHz_CLOCK_0:FABRIC_RESET_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"RESETN_50MHz" "RESET_50MHz_CLOCK_0:FABRIC_RESET_N" }



# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "clocks_and_reset"
generate_component -component_name ${sd_name}
