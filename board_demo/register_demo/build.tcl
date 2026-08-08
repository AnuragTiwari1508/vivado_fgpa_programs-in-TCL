# ============================================================
# build.tcl - Independent Vivado build script for board demo: register_demo
# Board: RealDigital Boolean Board (Xilinx/AMD Spartan-7 XC7S50-1CSGA324)
# Auto-generated. Safe to `source build.tcl` standalone from Vivado Tcl console.
# ============================================================

set origin_dir [file dirname [file normalize [info script]]]
set proj_name  "register_demo_proj"
set proj_dir   [file join $origin_dir "vivado_proj"]
set part       "xc7s50csga324-1"
set top        "register_demo_top"

if {[file exists $proj_dir]} {
    file delete -force $proj_dir
}

create_project $proj_name $proj_dir -part $part -force

add_files -norecurse [glob -nocomplain [file join $origin_dir "rtl" "*.v"]]


set xdc_files [glob -nocomplain [file join $origin_dir "constraints" "*.xdc"]]
add_files -fileset constrs_1 -norecurse $xdc_files

set_property top $top [current_fileset]
update_compile_order -fileset sources_1

puts "INFO: running synthesis for register_demo"
reset_run synth_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
    error "ERROR: synthesis failed for register_demo"
}

puts "INFO: running implementation for register_demo"
reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    error "ERROR: implementation/bitstream failed for register_demo"
}

open_run impl_1
set timing_ok [expr {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]] >= 0}]
puts "TIMING (setup, worst path) OK: $timing_ok"

set bit_src [file join $proj_dir "$proj_name.runs" "impl_1" "$top.bit"]
set bit_dst [file join $origin_dir "$top.bit"]
if {[file exists $bit_src]} {
    file copy -force $bit_src $bit_dst
    puts "INFO: bitstream copied to $bit_dst"
} else {
    puts "WARNING: expected bitstream not found at $bit_src"
}
puts "DONE: register_demo synthesis+implementation+bitstream complete."
