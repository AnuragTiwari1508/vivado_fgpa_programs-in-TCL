# ============================================================
# build.tcl - Independent Vivado build script for: up_down_counter4
# Category: sequential
# Board: RealDigital Boolean Board (Xilinx/AMD Spartan-7 XC7S50-1CSGA324)
# Auto-generated. Safe to `source build.tcl` standalone from Vivado Tcl console.
# ============================================================

set origin_dir [file dirname [file normalize [info script]]]
set proj_name  "up_down_counter4_proj"
set proj_dir   [file join $origin_dir "vivado_proj"]
set part       "xc7s50csga324-1"
set top        "up_down_counter4"

# ---- clean rebuild ----
if {[file exists $proj_dir]} {
    file delete -force $proj_dir
}

create_project $proj_name $proj_dir -part $part -force

# ---- add RTL sources ----
add_files -norecurse [glob -nocomplain [file join $origin_dir "rtl" "*.v"]]

# ---- add simulation-only testbench sources ----
set tb_files [glob -nocomplain [file join $origin_dir "tb" "*.v"]]
if {[llength $tb_files] > 0} {
    add_files -fileset sim_1 -norecurse $tb_files
}

# ---- add constraints (board-level circuits only) ----
set xdc_files [glob -nocomplain [file join $origin_dir "constraints" "*.xdc"]]
if {[llength $xdc_files] > 0} {
    add_files -fileset constrs_1 -norecurse $xdc_files
}

# ---- set top modules ----
set_property top $top [current_fileset]
set_property top up_down_counter4_tb [get_filesets sim_1]
update_compile_order -fileset sources_1

# ---- run behavioral simulation (if a TB exists) ----
if {[llength $tb_files] > 0} {
    puts "INFO: launching behavioral simulation for up_down_counter4"
    catch {
        launch_simulation
        run all
        close_sim
    } sim_err
    if {$sim_err ne ""} {
        puts "WARNING: simulation step reported: $sim_err"
    }
} else {
    puts "INFO: no testbench found for up_down_counter4, skipping simulation."
}

# ---- synthesis / implementation / bitstream only for board-level (XDC-bearing) circuits ----
if {[llength $xdc_files] > 0} {
    puts "INFO: running synthesis for up_down_counter4"
    reset_run synth_1
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1
    if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
        error "ERROR: synthesis failed for up_down_counter4"
    }

    puts "INFO: running implementation for up_down_counter4"
    reset_run impl_1
    launch_runs impl_1 -to_step write_bitstream -jobs 4
    wait_on_run impl_1
    if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
        error "ERROR: implementation/bitstream failed for up_down_counter4"
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
    puts "DONE: up_down_counter4 synthesis+implementation+bitstream complete."
} else {
    puts "INFO: up_down_counter4 has no XDC (pure logic-building-block circuit) - simulation only, no bitstream targeted."
}
