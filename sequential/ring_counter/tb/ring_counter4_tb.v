`timescale 1ns/1ps
module ring_counter4_tb;
    reg clk = 0, rst, en;
    wire [3:0] q;
    integer errors = 0;

    ring_counter4 dut (.clk(clk), .rst(rst), .en(en), .q(q));
    always #5 clk = ~clk;

    initial begin
        rst=1; en=0; @(posedge clk); #1;
        if (q!==4'b0001) begin $display("FAIL reset: q=%b",q); errors=errors+1; end else $display("PASS reset 0001");

        rst=0; en=1;
        @(posedge clk); #1; if (q!==4'b0010) begin $display("FAIL: q=%b",q); errors=errors+1; end else $display("PASS 0010");
        @(posedge clk); #1; if (q!==4'b0100) begin $display("FAIL: q=%b",q); errors=errors+1; end else $display("PASS 0100");
        @(posedge clk); #1; if (q!==4'b1000) begin $display("FAIL: q=%b",q); errors=errors+1; end else $display("PASS 1000");
        @(posedge clk); #1; if (q!==4'b0001) begin $display("FAIL wrap: q=%b",q); errors=errors+1; end else $display("PASS wraps to 0001");

        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
