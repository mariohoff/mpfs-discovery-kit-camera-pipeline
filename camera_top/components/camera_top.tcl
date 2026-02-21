# Creating SmartDesign "camera_top"
set sd_name {camera_top}
create_smartdesign -sd_name ${sd_name}

# Disable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 0

# Create top level Scalar Ports
sd_create_scalar_port -sd_name ${sd_name} -port_name {GPIO_MIPI_RX_CKN} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {GPIO_MIPI_RX_CKP} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MMUART_4_RXD} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REFCLK_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REFCLK} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {REF_CLK_50MHz} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_RX0_N} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_RX0_P} -port_direction {IN} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SWITCH2} -port_direction {IN}

sd_create_scalar_port -sd_name ${sd_name} -port_name {ACT_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {BG0} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_EN} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_GPIO} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAS_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CK0_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CK0} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CKE0} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CS0_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {GPIO_1_9_OUT} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED1} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED2} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED3} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED4} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED5} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED6} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {LED7} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MAC_0_MDC} -port_direction {OUT}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MMUART_4_TXD} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {ODT0} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RAS_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {RESET_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_TX0_N} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {SGMII_TX0_P} -port_direction {OUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {WE_N} -port_direction {OUT} -port_is_pad {1}

sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_SCL} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {CAM1_SDA} -port_direction {INOUT} -port_is_pad {1}
sd_create_scalar_port -sd_name ${sd_name} -port_name {MDIO_PAD} -port_direction {INOUT} -port_is_pad {1}

# Create top level Bus Ports
sd_create_bus_port -sd_name ${sd_name} -port_name {GPIO_MIPI_RX_N} -port_direction {IN} -port_range {[1:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {GPIO_MIPI_RX_P} -port_direction {IN} -port_range {[1:0]} -port_is_pad {1}

sd_create_bus_port -sd_name ${sd_name} -port_name {A} -port_direction {OUT} -port_range {[13:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {BA} -port_direction {OUT} -port_range {[1:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {DM} -port_direction {OUT} -port_range {[1:0]} -port_is_pad {1}

sd_create_bus_port -sd_name ${sd_name} -port_name {DQS_N} -port_direction {INOUT} -port_range {[1:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {DQS} -port_direction {INOUT} -port_range {[1:0]} -port_is_pad {1}
sd_create_bus_port -sd_name ${sd_name} -port_name {DQ} -port_direction {INOUT} -port_range {[15:0]} -port_is_pad {1}

sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {LED4} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {LED5} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {LED6} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {LED7} -value {GND}
# Add AND2_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_0}



# Add AND2_1 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {AND2} -instance_name {AND2_1}



# Add BIBUF_0 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {BIBUF_0}



# Add BIBUF_1 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {BIBUF_1}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BIBUF_1:D} -value {GND}



# Add BIBUF_2 instance
sd_instantiate_macro -sd_name ${sd_name} -macro_name {BIBUF} -instance_name {BIBUF_2}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {BIBUF_2:D} -value {GND}



# Add cam_iod_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {cam_iod} -instance_name {cam_iod_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {cam_iod_0:HS_IO_CLK_PAUSE} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {cam_iod_0:HS_SEL} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {cam_iod_0:RESTART_TRNG} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {cam_iod_0:SKIP_TRNG} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {cam_iod_0:CLK_TRAIN_DONE}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {cam_iod_0:CLK_TRAIN_ERROR}



# Add camera_control_0 instance
sd_instantiate_hdl_core -sd_name ${sd_name} -hdl_core_name {camera_control} -instance_name {camera_control_0}



# Add clocks_and_reset_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {clocks_and_reset} -instance_name {clocks_and_reset_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {clocks_and_reset_0:MSS_PLL_LOCKS} -value {VCC}



# Add CoreAPB3_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CoreAPB3_C0} -instance_name {CoreAPB3_C0_0}



# Add COREAXI4INTERCONNECT_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {COREAXI4INTERCONNECT_C0} -instance_name {COREAXI4INTERCONNECT_C0_0}



# Add CORERESET_CSI_DECODE_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {CORERESET_CSI_DECODE} -instance_name {CORERESET_CSI_DECODE_0}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_CSI_DECODE_0:BANK_x_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_CSI_DECODE_0:BANK_y_VDDI_STATUS} -value {VCC}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_CSI_DECODE_0:SS_BUSY} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_CSI_DECODE_0:FF_US_RESTORE} -value {GND}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {CORERESET_CSI_DECODE_0:FPGA_POR_N} -value {VCC}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {CORERESET_CSI_DECODE_0:PLL_POWERDOWN_B}



# Add H264_Encoder_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {H264_Encoder_C0} -instance_name {H264_Encoder_C0_0}



# Add image_pipeline_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {image_pipeline} -instance_name {image_pipeline_0}



# Add mipicsi2rxdecoderPF_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {mipicsi2rxdecoderPF_C0} -instance_name {mipicsi2rxdecoderPF_C0_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {mipicsi2rxdecoderPF_C0_0:data_out_o} -pin_slices {[1:0]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mipicsi2rxdecoderPF_C0_0:data_out_o[1:0]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {mipicsi2rxdecoderPF_C0_0:data_out_o} -pin_slices {[9:2]}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mipicsi2rxdecoderPF_C0_0:frame_valid_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mipicsi2rxdecoderPF_C0_0:line_end_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mipicsi2rxdecoderPF_C0_0:data_type_o}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mipicsi2rxdecoderPF_C0_0:word_count_o}



# Add mss_camera_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {mss_camera} -instance_name {mss_camera_0}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {mss_camera_0:MSS_INT_F2M} -pin_slices {[3:0]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {mss_camera_0:MSS_INT_F2M[3:0]} -value {GND}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {mss_camera_0:MSS_INT_F2M} -pin_slices {[4:4]}
sd_create_pin_slices -sd_name ${sd_name} -pin_name {mss_camera_0:MSS_INT_F2M} -pin_slices {[63:5]}
sd_connect_pins_to_constant -sd_name ${sd_name} -pin_names {mss_camera_0:MSS_INT_F2M[63:5]} -value {GND}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:FIC_0_DLL_LOCK_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:FIC_3_DLL_LOCK_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:PLL_CPU_LOCK_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:PLL_DDR_LOCK_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:PLL_SGMII_LOCK_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MAC_0_TSU_SOF_TX_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MAC_0_TSU_SYNC_FRAME_TX_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MAC_0_TSU_DELAY_REQ_TX_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MAC_0_TSU_PDELAY_REQ_TX_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MAC_0_TSU_PDELAY_RESP_TX_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MAC_0_TSU_SOF_RX_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MAC_0_TSU_SYNC_FRAME_RX_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MAC_0_TSU_DELAY_REQ_RX_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MAC_0_TSU_PDELAY_REQ_RX_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MAC_0_TSU_PDELAY_RESP_RX_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:FIC_3_APB_M_PSTRB}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MSS_INT_M2F}
sd_mark_pins_unused -sd_name ${sd_name} -pin_names {mss_camera_0:MAC_0_TSU_TIMER_CNT_M2F}



# Add PF_CCC_PIXEL_CLK_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {PF_CCC_C1} -instance_name {PF_CCC_PIXEL_CLK_0}



# Add VDMA_C0_0 instance
sd_instantiate_component -sd_name ${sd_name} -component_name {VDMA_C0} -instance_name {VDMA_C0_0}



# Add scalar net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"ACT_N" "mss_camera_0:ACT_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:A" "camera_control_0:DMA_RESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:B" "cam_iod_0:training_done_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_0:Y" "CORERESET_CSI_DECODE_0:EXT_RST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_1:A" "CORERESET_CSI_DECODE_0:PLL_LOCK" "PF_CCC_PIXEL_CLK_0:PLL_LOCK_0" "cam_iod_0:PLL_LOCK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_1:B" "camera_control_0:IOD_RESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"AND2_1:Y" "cam_iod_0:TRAINING_RESETN" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BG0" "mss_camera_0:BG0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_0:D" "mss_camera_0:MAC_0_MDO_M2F" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_0:E" "mss_camera_0:MAC_0_MDO_OE_M2F" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_0:PAD" "MDIO_PAD" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_0:Y" "mss_camera_0:MAC_0_MDI_F2M" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_1:E" "mss_camera_0:I2C_0_SCL_OE_M2F" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_1:PAD" "CAM1_SCL" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_1:Y" "mss_camera_0:I2C_0_SCL_F2M" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_2:E" "mss_camera_0:I2C_0_SDA_OE_M2F" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_2:PAD" "CAM1_SDA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BIBUF_2:Y" "mss_camera_0:I2C_0_SDA_F2M" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_EN" "LED1" "camera_control_0:CAM_ENABLE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAM1_GPIO" "LED2" "camera_control_0:CAM_GPIO" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CAS_N" "mss_camera_0:CAS_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CK0" "mss_camera_0:CK0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CK0_N" "mss_camera_0:CK0_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CKE0" "mss_camera_0:CKE0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREAXI4INTERCONNECT_C0_0:ACLK" "H264_Encoder_C0_0:ACLK_I" "VDMA_C0_0:ACLK_I" "VDMA_C0_0:DDR_CLK_I" "camera_control_0:ACLK" "clocks_and_reset_0:CLK_125MHz" "mss_camera_0:FIC_0_ACLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREAXI4INTERCONNECT_C0_0:ARESETN" "H264_Encoder_C0_0:ARESETN_I" "VDMA_C0_0:ARESETN_I" "VDMA_C0_0:DDR_CLK_RSTN_I" "camera_control_0:ARESETN" "clocks_and_reset_0:RESETN_125MHz" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_CSI_DECODE_0:CLK" "PF_CCC_PIXEL_CLK_0:REF_CLK_0" "cam_iod_0:RX_CLK_G" "mipicsi2rxdecoderPF_C0_0:CAM_CLOCK_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_CSI_DECODE_0:FABRIC_RESET_N" "H264_Encoder_C0_0:RESET_N" "VDMA_C0_0:VIDEO_CLK_RSTN_I" "camera_control_0:PARALLEL_RESETN" "image_pipeline_0:RESETN_I" "mipicsi2rxdecoderPF_C0_0:RESET_n_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CORERESET_CSI_DECODE_0:INIT_DONE" "VDMA_C0_0:DDR_CTRL_READY_I" "cam_iod_0:ARST_N" "clocks_and_reset_0:DEVICE_INIT_DONE" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CS0_N" "mss_camera_0:CS0_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"GPIO_1_9_OUT" "mss_camera_0:GPIO_1_9_OUT" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"GPIO_MIPI_RX_CKN" "cam_iod_0:RX_CLK_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"GPIO_MIPI_RX_CKP" "cam_iod_0:RX_CLK_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"H264_Encoder_C0_0:DATA0_VALID_O" "VDMA_C0_0:DATA_VALID_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"H264_Encoder_C0_0:DATA_VALID_I" "image_pipeline_0:DATA_VALID_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"H264_Encoder_C0_0:FRAME_START_I" "image_pipeline_0:FRAME_START_O" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"H264_Encoder_C0_0:FRAME_START_O" "VDMA_C0_0:FRAME_START_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"H264_Encoder_C0_0:PIX_CLK_I" "PF_CCC_PIXEL_CLK_0:OUT0_FABCLK_0" "VDMA_C0_0:VIDEO_CLK_I" "camera_control_0:PARALLEL_CLK" "image_pipeline_0:PXL_CLK_I" "mipicsi2rxdecoderPF_C0_0:PARALLEL_CLOCK_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"LED3" "camera_control_0:CSI_LINE_VALID" "image_pipeline_0:DATA_VALID_I" "mipicsi2rxdecoderPF_C0_0:line_valid_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MAC_0_MDC" "mss_camera_0:MAC_0_MDC_M2F" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MMUART_4_RXD" "mss_camera_0:MMUART_4_RXD" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"MMUART_4_TXD" "mss_camera_0:MMUART_4_TXD" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"ODT0" "mss_camera_0:ODT0" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"RAS_N" "mss_camera_0:RAS_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"REFCLK" "mss_camera_0:REFCLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"REFCLK_N" "mss_camera_0:REFCLK_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"REF_CLK_50MHz" "clocks_and_reset_0:REF_CLK_50MHz" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"RESET_N" "mss_camera_0:RESET_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_RX0_N" "mss_camera_0:SGMII_RX0_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_RX0_P" "mss_camera_0:SGMII_RX0_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_TX0_N" "mss_camera_0:SGMII_TX0_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SGMII_TX0_P" "mss_camera_0:SGMII_TX0_P" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"SWITCH2" "clocks_and_reset_0:EXT_RST_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"VDMA_C0_0:INT_DMA_O" "camera_control_0:VDMA_INT" "mss_camera_0:MSS_INT_F2M[4:4]" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"WE_N" "mss_camera_0:WE_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"cam_iod_0:L0_LP_DATA" "mipicsi2rxdecoderPF_C0_0:L0_LP_DATA_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"cam_iod_0:L0_LP_DATA_N" "mipicsi2rxdecoderPF_C0_0:L0_LP_DATA_N_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"cam_iod_0:L1_LP_DATA" "mipicsi2rxdecoderPF_C0_0:L1_LP_DATA_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"cam_iod_0:L1_LP_DATA_N" "mipicsi2rxdecoderPF_C0_0:L1_LP_DATA_N_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:CSI_ECC_ERROR" "mipicsi2rxdecoderPF_C0_0:ecc_error_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:CSI_FRAME_END" "mipicsi2rxdecoderPF_C0_0:frame_end_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:CSI_FRAME_START" "image_pipeline_0:FRAME_START_I" "mipicsi2rxdecoderPF_C0_0:frame_start_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:CSI_LINE_START" "mipicsi2rxdecoderPF_C0_0:line_start_o" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:PCLK" "clocks_and_reset_0:CLK_50MHz" "mss_camera_0:FIC_3_PCLK" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:PRESETN" "clocks_and_reset_0:RESETN_50MHz" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"clocks_and_reset_0:FABRIC_POR_N" "mss_camera_0:MSS_RESET_N_F2M" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"clocks_and_reset_0:I2C_BCLK" "mss_camera_0:I2C_0_BCLK_F2M" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"clocks_and_reset_0:MSS_TO_FABRIC_RESETN" "mss_camera_0:MSS_RESET_N_M2F" }

# Add bus net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"A" "mss_camera_0:A" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"BA" "mss_camera_0:BA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DM" "mss_camera_0:DM" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQ" "mss_camera_0:DQ" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQS" "mss_camera_0:DQS" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"DQS_N" "mss_camera_0:DQS_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"GPIO_MIPI_RX_N" "cam_iod_0:RXD_N" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"GPIO_MIPI_RX_P" "cam_iod_0:RXD" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"H264_Encoder_C0_0:DATA0_O" "VDMA_C0_0:DATA_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"H264_Encoder_C0_0:DATA_C_I" "image_pipeline_0:C_OUT" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"H264_Encoder_C0_0:DATA_Y_I" "image_pipeline_0:Y_OUT" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"cam_iod_0:L0_RXD_DATA" "mipicsi2rxdecoderPF_C0_0:L0_HS_DATA_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"cam_iod_0:L1_RXD_DATA" "mipicsi2rxdecoderPF_C0_0:L1_HS_DATA_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:BAYER_FORMAT" "image_pipeline_0:BAYER_FORMAT" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:HRES_IN_O" "image_pipeline_0:HRES_IN_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:HRES_OUT_O" "image_pipeline_0:HRES_OUT_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:SCALER_H_FACTOR_O" "image_pipeline_0:HSCALE_FACTOR_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:SCALER_V_FACTOR_O" "image_pipeline_0:VSCALE_FACTOR_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:VRES_IN_O" "image_pipeline_0:VRES_IN_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"camera_control_0:VRES_OUT_O" "image_pipeline_0:VRES_OUT_I" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"image_pipeline_0:DATA_I" "mipicsi2rxdecoderPF_C0_0:data_out_o[9:2]" }

# Add bus interface net connections
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREAXI4INTERCONNECT_C0_0:AXI4mmaster0" "mss_camera_0:FIC_0_AXI4_INITIATOR" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREAXI4INTERCONNECT_C0_0:AXI4mslave0" "H264_Encoder_C0_0:AXI4L_H264" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"COREAXI4INTERCONNECT_C0_0:AXI4mslave1" "VDMA_C0_0:AXI4L_VDMA" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreAPB3_C0_0:APB3mmaster" "mss_camera_0:FIC_3_APB_INITIATOR" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"CoreAPB3_C0_0:APBmslave0" "camera_control_0:APB_slave" }
sd_connect_pins -sd_name ${sd_name} -pin_names {"VDMA_C0_0:mAXI4_SLAVE" "mss_camera_0:FIC_0_AXI4_TARGET" }

# Re-enable auto promotion of pins of type 'pad'
auto_promote_pad_pins -promote_all 1
# Save the SmartDesign 
save_smartdesign -sd_name ${sd_name}
# Generate SmartDesign "camera_top"
generate_component -component_name ${sd_name}
