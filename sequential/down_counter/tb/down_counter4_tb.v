`timescale 1ns/1ps
module down_counter4_tb;
    reg clk = 0, rst, en;
    wire [3:0] q;
    integer i, errors = 0;

    down_counter4 dut (.clk(clk), .rst(rst), .en(en), .q(q));
    always #5 clk = ~clk;

    initial begin
        rst = 1; en = 0; @(posedge clk); #1;
        if (q !== 15) begin $display("FAIL reset: q=%0d",q); errors=errors+1; end else $display("PASS reset to 15");

        rst = 0; en = 1;
        for (i = 14; i >= 0; i = i - 1) begin
            @(posedge clk); #1;
            if (q !== i[3:0]) begin
                $display("FAIL count: expected=%0d got=%0d", i, q);
                errors = errors + 1;
            end
        end
        $display("PASS counted 14..0");

        @(posedge clk); #1; // rollover 0 -> 15
        if (q !== 15) begin $display("FAIL rollover: q=%0d",q); errors=errors+1; end
        else $display("PASS rollover 0->15");

        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
