# ============================================================
# master_test.tcl
# Runs ONLY behavioral simulation for every circuit that has a testbench
# (fast: skips synthesis/implementation/bitstream entirely).
#
# Usage (from Vivado Tcl Console):
#   cd FPGA_Boolean_Board
#   source master_test.tcl
# ============================================================

set origin_dir [file dirname [file normalize [info script]]]

set circuits {
    {combinational/mux2          mux2               mux2_tb}
    {combinational/mux4          mux4               mux4_tb}
    {combinational/half_adder    half_adder         half_adder_tb}
    {combinational/full_adder    full_adder         full_adder_tb}
    {combinational/ripple_adder  ripple_adder4      ripple_adder4_tb}
    {combinational/decoder       decoder2to4        decoder2to4_tb}
    {combinational/encoder       encoder4to2        encoder4to2_tb}
    {combinational/comparator    comparator4        comparator4_tb}
    {sequential/d_ff             d_ff               d_ff_tb}
    {sequential/t_ff             t_ff               t_ff_tb}
    {sequential/jk_ff            jk_ff              jk_ff_tb}
    {sequential/register         register4          register4_tb}
    {sequential/up_counter       up_counter4        up_counter4_tb}
    {sequential/down_counter     down_counter4      down_counter4_tb}
    {sequential/up_down_counter  up_down_counter4   up_down_counter4_tb}
    {sequential/shift_register   shift_register4    shift_register4_tb}
    {sequential/ring_counter     ring_counter4      ring_counter4_tb}
    {sequential/johnson_counter  johnson_counter4   johnson_counter4_tb}
    {display/seven_segment       bin_to_7seg        bin_to_7seg_tb}
    {display/bcd_counter         bcd_counter        bcd_counter_tb}
    {fsm/traffic_light           traffic_light_fsm  traffic_light_fsm_tb}
    {utilities/clock_divider     clock_divider      clock_divider_tb}
    {utilities/button_debounce   button_debounce    button_debounce_tb}
}

set n_ok 0
set n_fail 0

foreach entry $circuits {
    set cdir [lindex $entry 0]
    set top  [lindex $entry 1]
    set tbtop [lindex $entry 2]

    puts "\n---- SIMULATING: $cdir ($tbtop) ----"
    set proj_dir [file join $origin_dir $cdir "vivado_proj_sim"]
    if {[file exists $proj_dir]} { file delete -force $proj_dir }

    if {[catch {
        create_project "${top}_simproj" $proj_dir -part xc7s50csga324-1 -force
        add_files -norecurse [glob [file join $origin_dir $cdir "rtl" "*.v"]]
        add_files -fileset sim_1 -norecurse [glob [file join $origin_dir $cdir "tb" "*.v"]]
        set_property top $tbtop [get_filesets sim_1]
        update_compile_order -fileset sources_1
        launch_simulation
        run all
        close_sim
        close_project
    } err]} {
        puts "FAIL: $cdir -> $err"
        incr n_fail
    } else {
        puts "OK: $cdir simulation ran (check transcript above for PASS/FAIL testbench result)"
        incr n_ok
    }
}

puts "\n========================================================"
puts "MASTER TEST SUMMARY: $n_ok ran, $n_fail failed to launch"
puts "NOTE: 'ran' means the simulation executed - always check each"
puts "testbench's own TESTBENCH RESULT: PASS/FAIL line above."
puts "========================================================"
