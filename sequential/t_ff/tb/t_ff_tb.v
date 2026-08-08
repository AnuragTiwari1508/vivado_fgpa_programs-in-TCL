`timescale 1ns/1ps
module t_ff_tb;
    reg clk = 0, rst, t;
    wire q;
    integer errors = 0;

    t_ff dut (.clk(clk), .rst(rst), .t(t), .q(q));
    always #5 clk = ~clk;

    initial begin
        rst = 1; t = 0; @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL reset: q=%b",q); errors=errors+1; end else $display("PASS reset");

        rst = 0; t = 0; @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL hold: q=%b",q); errors=errors+1; end else $display("PASS hold (t=0)");

        t = 1; @(posedge clk); #1;
        if (q !== 1) begin $display("FAIL toggle1: q=%b",q); errors=errors+1; end else $display("PASS toggle 0->1");

        @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL toggle2: q=%b",q); errors=errors+1; end else $display("PASS toggle 1->0");

        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
