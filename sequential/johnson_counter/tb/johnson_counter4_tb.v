`timescale 1ns/1ps
module johnson_counter4_tb;
    reg clk = 0, rst, en;
    wire [3:0] q;
    integer errors = 0;
    reg [3:0] seq [0:7];
    integer i;

    johnson_counter4 dut (.clk(clk), .rst(rst), .en(en), .q(q));
    always #5 clk = ~clk;

    initial begin
        seq[0]=4'b0000; seq[1]=4'b1000; seq[2]=4'b1100; seq[3]=4'b1110;
        seq[4]=4'b1111; seq[5]=4'b0111; seq[6]=4'b0011; seq[7]=4'b0001;

        rst=1; en=0; @(posedge clk); #1;
        if (q!==seq[0]) begin $display("FAIL reset: q=%b",q); errors=errors+1; end else $display("PASS reset 0000");

        rst=0; en=1;
        for (i = 1; i <= 8; i = i + 1) begin
            @(posedge clk); #1;
            if (q !== seq[i % 8]) begin
                $display("FAIL step %0d: q=%b expected=%b", i, q, seq[i%8]);
                errors = errors + 1;
            end else
                $display("PASS step %0d: q=%b", i, q);
        end
        if (errors==0) $display("TESTBENCH RESULT: PASS (full 8-state cycle)");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
