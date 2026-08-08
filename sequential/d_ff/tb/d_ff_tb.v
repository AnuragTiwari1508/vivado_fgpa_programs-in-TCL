`timescale 1ns/1ps
module d_ff_tb;
    reg clk = 0, rst, d;
    wire q;
    integer errors = 0;

    d_ff dut (.clk(clk), .rst(rst), .d(d), .q(q));
    always #5 clk = ~clk;

    initial begin
        rst = 1; d = 0; @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL reset: q=%b",q); errors=errors+1; end
        else $display("PASS reset: q=0");

        rst = 0; d = 1; @(posedge clk); #1;
        if (q !== 1) begin $display("FAIL d=1 capture: q=%b",q); errors=errors+1; end
        else $display("PASS d=1 capture: q=1");

        d = 0; @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL d=0 capture: q=%b",q); errors=errors+1; end
        else $display("PASS d=0 capture: q=0");

        d = 1; rst = 1; @(posedge clk); #1; // reset overrides d
        if (q !== 0) begin $display("FAIL reset-override: q=%b",q); errors=errors+1; end
        else $display("PASS reset overrides d: q=0");

        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
