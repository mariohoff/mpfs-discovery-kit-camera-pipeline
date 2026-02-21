# Creating SmartDesign "image_pipeline"
set sd_name {image_pipeline}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {DATA_VALID_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {FRAME_START_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {PXL_CLK_I} -port_direction {IN}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESETN_I} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {DATA_VALID_O} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {FRAME_START_O} -port_direction {OUT}


# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {BAYER_FORMAT} -port_direction {IN} -port_range {[1:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {DATA_I} -port_direction {IN} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {HRES_IN_I} -port_direction {IN} -port_range {[12:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {HRES_OUT_I} -port_direction {IN} -port_range {[12:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {HSCALE_FACTOR_I} -port_direction {IN} -port_range {[15:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {VRES_IN_I} -port_direction {IN} -port_range {[12:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {VRES_OUT_I} -port_direction {IN} -port_range {[12:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {VSCALE_FACTOR_I} -port_direction {IN} -port_range {[15:0]}

sd_create_bus_port -sd_name ${sd_name} -port_name {C_OUT} -port_direction {OUT} -port_range {[7:0]}
sd_create_bus_port -sd_name ${sd_name} -port_name {Y_OUT} -port_direction {OUT} -port_range {[7:0]}


# Add Bayer_Interpolation_C1_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {Bayer_Interpolation_C1} -instance_name {Bayer_Interpolation_C1_0}



# Add DFN1C0_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {DFN1C0} -instance_name {DFN1C0_0}



# Add IMAGE_SCALER_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {IMAGE_SCALER_C0} -instance_name {IMAGE_SCALER_C0_0}



# Add RGBtoYCbCr_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {RGBtoYCbCr_C0} -instance_name {RGBtoYCbCr_C0_0}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C1_0:DATA_VALID_I" "DATA_VALID_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C1_0:FRAME_START_I" "DFN1C0_0:D" "FRAME_START_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C1_0:RESETN_I" "DFN1C0_0:CLR" "IMAGE_SCALER_C0_0:RESETN_I" "RESETN_I" "RGBtoYCbCr_C0_0:RESET_N_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C1_0:RGB_VALID_O" "IMAGE_SCALER_C0_0:DATA_VALID_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C1_0:SYS_CLK_I" "DFN1C0_0:CLK" "IMAGE_SCALER_C0_0:IP_CLK_I" "IMAGE_SCALER_C0_0:SYS_CLK_I" "PXL_CLK_I" "RGBtoYCbCr_C0_0:CLOCK_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DATA_VALID_O" "RGBtoYCbCr_C0_0:DATA_VALID_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DFN1C0_0:Q" "FRAME_START_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"IMAGE_SCALER_C0_0:DATA_VALID_O" "RGBtoYCbCr_C0_0:DATA_VALID_I" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"BAYER_FORMAT" "Bayer_Interpolation_C1_0:BAYER_FORMAT_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C1_0:B_O" "IMAGE_SCALER_C0_0:DATA_B_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C1_0:DATA_I" "DATA_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C1_0:G_O" "IMAGE_SCALER_C0_0:DATA_G_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"Bayer_Interpolation_C1_0:R_O" "IMAGE_SCALER_C0_0:DATA_R_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"C_OUT" "RGBtoYCbCr_C0_0:C_OUT" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HRES_IN_I" "IMAGE_SCALER_C0_0:HORZ_RES_IN_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HRES_OUT_I" "IMAGE_SCALER_C0_0:HORZ_RES_OUT_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"HSCALE_FACTOR_I" "IMAGE_SCALER_C0_0:SCALE_FACTOR_HORZ_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"IMAGE_SCALER_C0_0:DATA_B_O" "RGBtoYCbCr_C0_0:GREEN_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"IMAGE_SCALER_C0_0:DATA_G_O" "RGBtoYCbCr_C0_0:BLUE_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"IMAGE_SCALER_C0_0:DATA_R_O" "RGBtoYCbCr_C0_0:RED_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"IMAGE_SCALER_C0_0:SCALE_FACTOR_VERT_I" "VSCALE_FACTOR_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"IMAGE_SCALER_C0_0:VERT_RES_IN_I" "VRES_IN_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"IMAGE_SCALER_C0_0:VERT_RES_OUT_I" "VRES_OUT_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"RGBtoYCbCr_C0_0:Y_OUT" "Y_OUT" }


# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "image_pipeline"
generate_component -component_name ${sd_name}
