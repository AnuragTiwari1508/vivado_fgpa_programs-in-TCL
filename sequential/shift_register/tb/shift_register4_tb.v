`timescale 1ns/1ps
module shift_register4_tb;
    reg clk = 0, rst, en, sin;
    wire [3:0] q;
    integer errors = 0;

    shift_register4 dut (.clk(clk), .rst(rst), .en(en), .serial_in(sin), .q(q));
    always #5 clk = ~clk;

    initial begin
        rst=1; en=0; sin=0; @(posedge clk); #1;
        if (q!==0) begin $display("FAIL reset: q=%b",q); errors=errors+1; end else $display("PASS reset");

        rst=0; en=1;
        sin=1; @(posedge clk); #1; // 0001
        if (q!==4'b0001) begin $display("FAIL shift1: q=%b",q); errors=errors+1; end else $display("PASS shift 0001");
        sin=0; @(posedge clk); #1; // 0010
        if (q!==4'b0010) begin $display("FAIL shift2: q=%b",q); errors=errors+1; end else $display("PASS shift 0010");
        sin=1; @(posedge clk); #1; // 0101
        if (q!==4'b0101) begin $display("FAIL shift3: q=%b",q); errors=errors+1; end else $display("PASS shift 0101");
        sin=1; @(posedge clk); #1; // 1011
        if (q!==4'b1011) begin $display("FAIL shift4: q=%b",q); errors=errors+1; end else $display("PASS shift 1011");

        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
