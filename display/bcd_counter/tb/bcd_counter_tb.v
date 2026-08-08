`timescale 1ns/1ps
module bcd_counter_tb;
    reg clk = 0, rst, en;
    wire [3:0] q;
    integer i, errors = 0;

    bcd_counter dut (.clk(clk), .rst(rst), .en(en), .q(q));
    always #5 clk = ~clk;

    initial begin
        rst=1; en=0; @(posedge clk); #1;
        if (q!==0) begin $display("FAIL reset: q=%0d",q); errors=errors+1; end else $display("PASS reset");

        rst=0; en=1;
        for (i=1;i<=9;i=i+1) begin
            @(posedge clk); #1;
            if (q!==i[3:0]) begin $display("FAIL count: exp=%0d got=%0d", i, q); errors=errors+1; end
        end
        $display("PASS counted 1..9");
        @(posedge clk); #1; // rollover 9->0
        if (q!==0) begin $display("FAIL rollover: q=%0d",q); errors=errors+1; end else $display("PASS rollover 9->0");

        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
