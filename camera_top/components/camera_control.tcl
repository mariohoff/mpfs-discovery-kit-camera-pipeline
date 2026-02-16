# Exporting core camera_control to TCL
# Exporting Create HDL core command for module camera_control
create_hdl_core -file {hdl/camera_control.vhd} -module {camera_control} -library {work} -package {}
# Exporting BIF information of  HDL core command for module camera_control
hdl_core_add_bif -hdl_core_name {camera_control} -bif_definition {APB:AMBA:AMBA2:slave} -bif_name {APB_slave} -signal_map {\
"PADDR:PADDR" \
"PENABLE:PENABLE" \
"PWRITE:PWRITE" \
"PRDATA:PRDATA" \
"PWDATA:PWDATA" \
"PREADY:PREADY" \
"PSLVERR:PSLVERR" \
"PSELx:PSEL" }
