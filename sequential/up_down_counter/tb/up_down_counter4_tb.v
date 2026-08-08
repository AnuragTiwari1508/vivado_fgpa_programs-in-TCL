`timescale 1ns/1ps
module up_down_counter4_tb;
    reg clk = 0, rst, en, dir;
    wire [3:0] q;
    integer errors = 0;

    up_down_counter4 dut (.clk(clk), .rst(rst), .en(en), .dir(dir), .q(q));
    always #5 clk = ~clk;

    initial begin
        rst=1; en=0; dir=1; @(posedge clk); #1;
        if (q!==0) begin $display("FAIL reset: q=%0d",q); errors=errors+1; end else $display("PASS reset");

        rst=0; en=1; dir=1; @(posedge clk); #1; // 0->1
        if (q!==1) begin $display("FAIL up: q=%0d",q); errors=errors+1; end else $display("PASS up 0->1");
        @(posedge clk); #1; // 1->2
        if (q!==2) begin $display("FAIL up: q=%0d",q); errors=errors+1; end else $display("PASS up 1->2");

        dir=0; @(posedge clk); #1; // 2->1
        if (q!==1) begin $display("FAIL down: q=%0d",q); errors=errors+1; end else $display("PASS down 2->1");
        @(posedge clk); #1; // 1->0
        if (q!==0) begin $display("FAIL down: q=%0d",q); errors=errors+1; end else $display("PASS down 1->0");
        @(posedge clk); #1; // rollover 0->15
        if (q!==15) begin $display("FAIL down-rollover: q=%0d",q); errors=errors+1; end else $display("PASS down rollover 0->15");

        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
