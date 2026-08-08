`timescale 1ns/1ps
module clock_divider_tb;
    reg clk = 0, rst;
    wire tick;
    integer errors = 0;
    integer tick_count = 0;
    integer i;

    // small DIVIDE_COUNT for fast simulation
    clock_divider #(.DIVIDE_COUNT(8)) dut (.clk(clk), .rst(rst), .tick(tick));
    always #5 clk = ~clk;

    // sample slightly after the edge so nonblocking updates to `tick` are visible
    always @(posedge clk) begin
        #1;
        if (tick) tick_count = tick_count + 1;
    end

    initial begin
        rst = 1; @(posedge clk); #1; rst = 0;
        // run 24 clocks -> expect 3 ticks (24/8)
        for (i = 0; i < 24; i = i + 1) @(posedge clk);
        #2;
        if (tick_count !== 3) begin
            $display("FAIL: expected 3 ticks in 24 cycles (DIVIDE_COUNT=8), got %0d", tick_count);
            errors = errors + 1;
        end else
            $display("PASS: got 3 ticks in 24 cycles as expected");

        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
