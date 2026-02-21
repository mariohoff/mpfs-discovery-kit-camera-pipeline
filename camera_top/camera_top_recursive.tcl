#This Tcl file sources other Tcl files to build the design(on which recursive export is run) in a bottom-up fashion

#Sourcing the Tcl file in which all the HDL source files used in the design are imported or linked
source hdl_source.tcl
build_design_hierarchy

#Sourcing the Tcl files in which HDL+ core definitions are created for HDL modules
source components/camera_control.tcl 
build_design_hierarchy

#Sourcing the Tcl files for creating individual components under the top level
source components/COREAXI4INTERCONNECT_C0.tcl 
source components/CORERESET_CSI_DECODE.tcl 
source components/CoreAPB3_C0.tcl 
source components/H264_Encoder_C0.tcl 
source components/PF_CCC_C1.tcl 
source components/VDMA_C0.tcl 
source components/CORERESET_PF_C0.tcl 
source components/CORERXIODBITALIGN_C0.tcl 
source components/CORERXIODBITALIGN_C1.tcl 
source components/PF_IOD_GENERIC_RX_C0.tcl 
source components/cam_iod.tcl 
source components/PFSOC_INIT_MONITOR_C0.tcl 
source components/PF_CCC_GLOBAL.tcl 
source components/PF_CLK_DIV_C0.tcl 
source components/PF_OSC_C0.tcl 
source components/RESET_125MHz_CLOCK.tcl 
source components/RESET_50MHz_CLOCK.tcl 
source components/clocks_and_reset.tcl 
source components/Bayer_Interpolation_C1.tcl 
source components/IMAGE_SCALER_C0.tcl 
source components/RGBtoYCbCr_C0.tcl 
source components/image_pipeline.tcl 
source components/mipicsi2rxdecoderPF_C0.tcl 
source components/camera_top.tcl 
build_design_hierarchy
