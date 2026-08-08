`timescale 1ns/1ps
module jk_ff_tb;
    reg clk = 0, rst, j, k;
    wire q;
    integer errors = 0;

    jk_ff dut (.clk(clk), .rst(rst), .j(j), .k(k), .q(q));
    always #5 clk = ~clk;

    task step(input jj, input kk, input exp);
        begin
            j = jj; k = kk; @(posedge clk); #1;
            if (q !== exp) begin
                $display("FAIL: j=%b k=%b -> q=%b expected=%b", jj,kk,q,exp);
                errors = errors + 1;
            end else
                $display("PASS: j=%b k=%b -> q=%b", jj,kk,q);
        end
    endtask

    initial begin
        rst = 1; j=0; k=0; @(posedge clk); #1; rst = 0;
        step(1,0,1); // set
        step(0,0,1); // hold
        step(0,1,0); // clear
        step(1,1,1); // toggle 0->1
        step(1,1,0); // toggle 1->0
        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
