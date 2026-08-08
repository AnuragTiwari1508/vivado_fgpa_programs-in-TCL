`timescale 1ns/1ps
module traffic_light_fsm_tb;
    reg clk = 0, rst, tick;
    wire [2:0] ns_light, ew_light;
    integer errors = 0;

    traffic_light_fsm #(.HOLD_GREEN(3), .HOLD_YELLOW(2)) dut (
        .clk(clk), .rst(rst), .tick(tick), .ns_light(ns_light), .ew_light(ew_light)
    );
    always #5 clk = ~clk;

    task pulse_tick;
        begin
            tick = 1; @(posedge clk); #1; tick = 0;
        end
    endtask

    initial begin
        rst = 1; tick = 0; @(posedge clk); #1; rst = 0;
        if (ns_light !== 3'b001 || ew_light !== 3'b100) begin
            $display("FAIL initial state: ns=%b ew=%b", ns_light, ew_light); errors=errors+1;
        end else $display("PASS initial state: NS=GREEN EW=RED");

        // hold NS_GREEN for HOLD_GREEN=3 ticks, then expect NS_YELLOW
        pulse_tick(); pulse_tick(); pulse_tick();
        if (ns_light !== 3'b010) begin
            $display("FAIL expected NS_YELLOW: ns=%b", ns_light); errors=errors+1;
        end else $display("PASS transitioned to NS_YELLOW");

        // hold NS_YELLOW for HOLD_YELLOW=2 ticks, then expect EW_GREEN
        pulse_tick(); pulse_tick();
        if (ew_light !== 3'b001 || ns_light !== 3'b100) begin
            $display("FAIL expected EW_GREEN: ns=%b ew=%b", ns_light, ew_light); errors=errors+1;
        end else $display("PASS transitioned to EW_GREEN (NS=RED)");

        // full cycle back to NS_GREEN
        pulse_tick(); pulse_tick(); pulse_tick(); // EW_GREEN -> EW_YELLOW
        pulse_tick(); pulse_tick();               // EW_YELLOW -> NS_GREEN
        if (ns_light !== 3'b001 || ew_light !== 3'b100) begin
            $display("FAIL full cycle back to NS_GREEN: ns=%b ew=%b", ns_light, ew_light); errors=errors+1;
        end else $display("PASS full cycle returned to NS_GREEN");

        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
