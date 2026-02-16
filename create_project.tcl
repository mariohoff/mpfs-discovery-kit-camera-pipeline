puts "TCL_BEGIN: [info script]"

set libero_release [split [get_libero_version] .]
set install_loc [defvar_get -name ACTEL_SW_DIR]
set mss_config_loc "$install_loc/bin64/pfsoc_mss"
set local_dir [pwd]
set constraint_path ./constraints

set project_name "disco-kit-video-pipeline"
set project_dir "$local_dir/work"

if { [file exists $project_dir ] } {
    puts stderr "Directory 'work' already exists. Quitting."
    exit 1
} 

new_project \
    -location $project_dir \
    -name $project_name \
    -project_description {} \
    -block_mode 0 \
    -standalone_peripheral_initialization 0 \
    -instantiate_in_smartdesign 1 \
    -ondemand_build_dh 1 \
    -use_relative_path 0 \
    -linked_files_root_dir_env {} \
    -hdl {VHDL} \
    -family {PolarFireSoC} \
    -die {MPFS095T} \
    -package {FCSG325} \
    -speed {-1} \
    -die_voltage {1.0} \
    -part_range {EXT} \
    -adv_options {IO_DEFT_STD:LVCMOS 1.8V} \
    -adv_options {RESTRICTPROBEPINS:1} \
    -adv_options {RESTRICTSPIPINS:0} \
    -adv_options {SYSTEM_CONTROLLER_SUSPEND_MODE:0} \
    -adv_options {TEMPR:EXT} \
    -adv_options {VCCI_1.2_VOLTR:EXT} \
    -adv_options {VCCI_1.5_VOLTR:EXT} \
    -adv_options {VCCI_1.8_VOLTR:EXT} \
    -adv_options {VCCI_2.5_VOLTR:EXT} \
    -adv_options {VCCI_3.3_VOLTR:EXT} \
    -adv_options {VOLTR:EXT}

smartdesign \
    -memory_map_drc_change_error_to_warning 1 \
    -bus_interface_data_width_drc_change_error_to_warning 1 \
    -bus_interface_id_width_drc_change_error_to_warning 1 

try {
    download_core -vlnv {Actel:DirectCore:CoreAPB3:4.2.100} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:COREAXI4DMACONTROLLER:2.2.107} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:COREAXI4INTERCONNECT:2.9.100} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:CoreAXI4SInterconnect:2.0.111} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:COREFIFO:3.1.101} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:CORERESET_PF:2.3.100} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Actel:DirectCore:CORERXIODBITALIGN:2.3.103} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Microsemi:SolutionCore:Gamma_Correction:4.3.0} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Microchip:SolutionCore:H264_Encoder:2.0.0} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Microsemi:SolutionCore:IMAGE_SCALER:4.1.0} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Microsemi:SolutionCore:mipicsi2rxdecoderPF:4.4.0} -location {www.microchip-ip.com/repositories/DirectCore}
    download_core -vlnv {Microsemi:SgCore:PFSOC_INIT_MONITOR:1.0.309} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Actel:SgCore:PF_CCC:2.2.222} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Actel:SgCore:PF_CLK_DIV:1.0.103} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Actel:SystemBuilder:PF_IOD_GENERIC_RX:2.1.116} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Actel:SgCore:PF_OSC:1.0.102} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Actel:SystemBuilder:PF_SRAM_AHBL_AXI:1.2.116} -location {www.microchip-ip.com/repositories/SgCore}
    download_core -vlnv {Microchip:SolutionCore:RGBtoYCbCr:4.6.0} -location {www.microchip-ip.com/repositories/SolutionCore}
    download_core -vlnv {Microchip:SolutionCore:VDMA:1.1.0} -location {www.microchip-ip.com/repositories/SolutionCore}
} on error err {
    puts "Downloading cores failed, the script will continute but will fail if all of the required cores aren't present in the vault."
}

if {[file isdirectory $project_dir/mss_config]} {
    file delete -force $project_dir/mss_config
}
file mkdir $project_dir/mss_config

exec $mss_config_loc -GENERATE -CONFIGURATION_FILE:$local_dir/mss_config/mss_camera.cfg -OUTPUT_DIR:$project_dir/mss_config
import_mss_component -file "$project_dir/mss_config/mss_camera.cxz"


# import_files -library work -hdl_source hdl/camera_control.vhd
# import_files -library work -hdl_source hdl/camera_control_apb.vhd
# import_files -library work -hdl_source hdl/camera_control_monitor.vhd
# import_files -library work -hdl_source hdl/dummy_image_sender.vhd
# import_files -library work -hdl_source hdl/image_data.vhd
# 
import_files -library work -stimulus stimulus/tb_utils.vhd
import_files -library work -stimulus stimulus/camera_control_tb.vhd

import_files -library work -io_pdc constraint/bank_settings.pdc
import_files -library work -io_pdc constraint/board_csi.pdc
import_files -library work -io_pdc constraint/board_misc.pdc
import_files -library work -io_pdc constraint/mss_mac.pdc

cd ./camera_top/
source $local_dir/camera_top/camera_top_recursive.tcl
cd ../

save_project
sd_reset_layout -sd_name {clocks_and_reset}
save_smartdesign -sd_name {clocks_and_reset}
sd_reset_layout -sd_name {cam_iod}
save_smartdesign -sd_name {cam_iod}
sd_reset_layout -sd_name {camera_top}
save_smartdesign -sd_name {camera_top}

set_root -module {camera_top::work} 

build_design_hierarchy
derive_constraints_sdc 

save_project 



puts "TCL_END: [info script]"
