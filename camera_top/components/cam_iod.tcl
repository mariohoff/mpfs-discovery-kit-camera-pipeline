# Creating SmartDesign "cam_iod"
set sd_name {cam_iod}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {ARST_N} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {HS_IO_CLK_PAUSE} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {HS_SEL} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PLL_LOCK} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESTART_TRNG} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RX_CLK_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RX_CLK_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SKIP_TRNG} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {TRAINING_RESETN} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {CLK_TRAIN_DONE} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CLK_TRAIN_ERROR} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {L0_LP_DATA_N} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {L0_LP_DATA} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {L1_LP_DATA_N} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {L1_LP_DATA} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RX_CLK_G} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {training_done_o} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {RXD_N} -port_direction {IN} -port_range {[1:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {RXD} -port_direction {IN} -port_range {[1:0]} -port_is_pad {1}

sd_create_bus_port -sd_name ${sd_name} -port_name {L0_RXD_DATA} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {L1_RXD_DATA} -port_direction {OUT} -port_range {[7:0]}


# Add AND2_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_0}



# Add AND2_1 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_1}



# Add CORERESET_PF_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERESET_PF_C0} -instance_name {CORERESET_PF_C0_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C0_0:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C0_0:BANK_y_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C0_0:PLL_LOCK} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C0_0:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C0_0:INIT_DONE} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C0_0:FF_US_RESTORE} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_PF_C0_0:FPGA_POR_N} -value {VCC}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERESET_PF_C0_0:PLL_POWERDOWN_B}



# Add CORERXIODBITALIGN_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERXIODBITALIGN_C0} -instance_name {CORERXIODBITALIGN_C0_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C0_0:BIT_ALGN_START}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C0_0:BIT_ALGN_OOR}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C0_0:BIT_ALGN_HOLD} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C0_0:BIT_ALGN_ERR}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C0_0:BIT_ALGN_EYE_IN} -value {011}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C0_0:DEM_BIT_ALGN_TAPDLY}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C0_0:RX_BIT_ALIGN_LEFT_WIN}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C0_0:RX_BIT_ALIGN_RGHT_WIN}



# Add CORERXIODBITALIGN_C1_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERXIODBITALIGN_C1} -instance_name {CORERXIODBITALIGN_C1_0}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C1_0:BIT_ALGN_START}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C1_0:BIT_ALGN_OOR}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C1_0:BIT_ALGN_HOLD} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C1_0:BIT_ALGN_ERR}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C1_0:BIT_ALGN_EYE_IN} -value {011}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C1_0:DEM_BIT_ALGN_TAPDLY}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C1_0:RX_BIT_ALIGN_LEFT_WIN}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERXIODBITALIGN_C1_0:RX_BIT_ALIGN_RGHT_WIN}



# Add PF_IOD_GENERIC_RX_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_IOD_GENERIC_RX_C0} -instance_name {PF_IOD_GENERIC_RX_C0_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_CLEAR_FLAGS} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_CLEAR_FLAGS} -pin_slices {[1:1]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_EARLY} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_EARLY} -pin_slices {[1:1]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_LATE} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_LATE} -pin_slices {[1:1]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_MOVE} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_MOVE} -pin_slices {[1:1]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_DIRECTION} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_DIRECTION} -pin_slices {[1:1]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_LOAD} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_LOAD} -pin_slices {[1:1]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_OUT_OF_RANGE} -pin_slices {[0:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_OUT_OF_RANGE} -pin_slices {[1:1]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_WIDTH} -value {011}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:A" "CORERXIODBITALIGN_C0_0:BIT_ALGN_DONE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:B" "CORERXIODBITALIGN_C1_0:BIT_ALGN_DONE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:Y" "training_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_1:A" "PF_IOD_GENERIC_RX_C0_0:CLK_TRAIN_DONE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_1:B" "CORERESET_PF_C0_0:FABRIC_RESET_N" "CORERXIODBITALIGN_C0_0:RESETN" "CORERXIODBITALIGN_C1_0:RESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_1:Y" "CLK_TRAIN_DONE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ARST_N" "PF_IOD_GENERIC_RX_C0_0:ARST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CLK_TRAIN_ERROR" "PF_IOD_GENERIC_RX_C0_0:CLK_TRAIN_ERROR" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C0_0:CLK" "CORERXIODBITALIGN_C0_0:SCLK" "CORERXIODBITALIGN_C1_0:SCLK" "PF_IOD_GENERIC_RX_C0_0:RX_CLK_G" "RX_CLK_G" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_PF_C0_0:EXT_RST_N" "TRAINING_RESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C0_0:BIT_ALGN_CLR_FLGS" "PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_CLEAR_FLAGS[0:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C0_0:BIT_ALGN_DIR" "PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_DIRECTION[0:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C0_0:BIT_ALGN_LOAD" "PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_LOAD[0:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C0_0:BIT_ALGN_MOVE" "PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_MOVE[0:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C0_0:BIT_ALGN_RSTRT" "CORERXIODBITALIGN_C1_0:BIT_ALGN_RSTRT" "RESTART_TRNG" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C0_0:BIT_ALGN_SKIP" "CORERXIODBITALIGN_C1_0:BIT_ALGN_SKIP" "SKIP_TRNG" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C0_0:IOD_EARLY" "PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_EARLY[0:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C0_0:IOD_LATE" "PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_LATE[0:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C0_0:IOD_OOR" "PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_OUT_OF_RANGE[0:0]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C0_0:LP_IN" "L0_LP_DATA_N" "PF_IOD_GENERIC_RX_C0_0:L0_LP_DATA_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C0_0:PLL_LOCK" "CORERXIODBITALIGN_C1_0:PLL_LOCK" "PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C1_0:BIT_ALGN_CLR_FLGS" "PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_CLEAR_FLAGS[1:1]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C1_0:BIT_ALGN_DIR" "PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_DIRECTION[1:1]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C1_0:BIT_ALGN_LOAD" "PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_LOAD[1:1]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C1_0:BIT_ALGN_MOVE" "PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_MOVE[1:1]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C1_0:IOD_EARLY" "PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_EARLY[1:1]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C1_0:IOD_LATE" "PF_IOD_GENERIC_RX_C0_0:EYE_MONITOR_LATE[1:1]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C1_0:IOD_OOR" "PF_IOD_GENERIC_RX_C0_0:DELAY_LINE_OUT_OF_RANGE[1:1]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERXIODBITALIGN_C1_0:LP_IN" "L1_LP_DATA_N" "PF_IOD_GENERIC_RX_C0_0:L1_LP_DATA_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HS_IO_CLK_PAUSE" "PF_IOD_GENERIC_RX_C0_0:HS_IO_CLK_PAUSE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HS_SEL" "PF_IOD_GENERIC_RX_C0_0:HS_SEL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"L0_LP_DATA" "PF_IOD_GENERIC_RX_C0_0:L0_LP_DATA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"L1_LP_DATA" "PF_IOD_GENERIC_RX_C0_0:L1_LP_DATA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_IOD_GENERIC_RX_C0_0:RX_CLK_N" "RX_CLK_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_IOD_GENERIC_RX_C0_0:RX_CLK_P" "RX_CLK_P" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"L0_RXD_DATA" "PF_IOD_GENERIC_RX_C0_0:L0_RXD_DATA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"L1_RXD_DATA" "PF_IOD_GENERIC_RX_C0_0:L1_RXD_DATA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_IOD_GENERIC_RX_C0_0:RXD" "RXD" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"PF_IOD_GENERIC_RX_C0_0:RXD_N" "RXD_N" }


# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "cam_iod"
generate_component -component_name ${sd_name}
