`timescale 1ns/1ps
module register4_tb;
    reg clk = 0, rst, en;
    reg [3:0] d;
    wire [3:0] q;
    integer errors = 0;

    register4 dut (.clk(clk), .rst(rst), .en(en), .d(d), .q(q));
    always #5 clk = ~clk;

    initial begin
        rst=1; en=0; d=4'hA; @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL reset: q=%h",q); errors=errors+1; end else $display("PASS reset");

        rst=0; en=0; d=4'hF; @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL hold(en=0): q=%h",q); errors=errors+1; end else $display("PASS hold en=0");

        en=1; d=4'h5; @(posedge clk); #1;
        if (q !== 4'h5) begin $display("FAIL load: q=%h",q); errors=errors+1; end else $display("PASS load=5");

        en=0; d=4'hC; @(posedge clk); #1;
        if (q !== 4'h5) begin $display("FAIL hold after load: q=%h",q); errors=errors+1; end else $display("PASS hold retains 5");

        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
