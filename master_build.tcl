# ============================================================
# master_build.tcl
# Builds EVERY circuit in this package by sourcing each circuit's own build.tcl.
# Board: RealDigital Boolean Board - Xilinx/AMD Spartan-7 XC7S50-1CSGA324
#
# Usage (from Vivado Tcl Console):
#   cd FPGA_Boolean_Board
#   source master_build.tcl
#
# For pure logic-building-block circuits (no constraints/*.xdc file present), this
# only creates the project + runs behavioral simulation (there is nothing meaningful
# to place-and-route in isolation - e.g. a bare half_adder with no board pins attached).
# For every circuit that DOES have a constraints/*.xdc (the board_demo/ folder, plus
# display/seven_segment, fsm/traffic_light), this runs the full
#   synthesis -> implementation -> bitstream
# flow and copies the resulting .bit file back into that circuit's folder.
# ============================================================

set origin_dir [file dirname [file normalize [info script]]]
set start_time [clock seconds]

set circuit_dirs {
    combinational/mux2
    combinational/mux4
    combinational/half_adder
    combinational/full_adder
    combinational/ripple_adder
    combinational/decoder
    combinational/encoder
    combinational/comparator
    sequential/d_ff
    sequential/t_ff
    sequential/jk_ff
    sequential/register
    sequential/up_counter
    sequential/down_counter
    sequential/up_down_counter
    sequential/shift_register
    sequential/ring_counter
    sequential/johnson_counter
    display/seven_segment
    display/bcd_counter
    fsm/traffic_light
    utilities/clock_divider
    utilities/button_debounce
    board_demo/mux_demo
    board_demo/full_adder_demo
    board_demo/counter_demo
    board_demo/register_demo
    board_demo/shift_register_demo
}

set results {}
set n_ok 0
set n_fail 0

foreach cdir $circuit_dirs {
    set build_script [file join $origin_dir $cdir "build.tcl"]
    puts "\n========================================================"
    puts "BUILDING: $cdir"
    puts "========================================================"
    if {![file exists $build_script]} {
        puts "WARNING: missing build.tcl for $cdir, skipping"
        lappend results [list $cdir "MISSING_BUILD_TCL"]
        incr n_fail
        continue
    }
    set err_msg ""
    if {[catch {source $build_script} err_msg]} {
        puts "ERROR building $cdir: $err_msg"
        lappend results [list $cdir "FAIL: $err_msg"]
        incr n_fail
    } else {
        lappend results [list $cdir "OK"]
        incr n_ok
    }
    # each build.tcl creates its own project under <circuit>/vivado_proj;
    # close it before moving to the next circuit to keep Vivado's state clean.
    catch {close_project}
}

set elapsed [expr {[clock seconds] - $start_time}]

puts "\n========================================================"
puts "MASTER BUILD SUMMARY"
puts "========================================================"
foreach r $results {
    puts "  [lindex $r 0] : [lindex $r 1]"
}
puts "--------------------------------------------------------"
puts "Total circuits attempted: [llength $circuit_dirs]"
puts "Succeeded: $n_ok"
puts "Failed/Skipped: $n_fail"
puts "Elapsed: ${elapsed}s"
puts "========================================================"
