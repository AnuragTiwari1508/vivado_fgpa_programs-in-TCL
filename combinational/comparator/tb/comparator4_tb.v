`timescale 1ns/1ps
module comparator4_tb;
    reg [3:0] a, b;
    wire gt, eq, lt;
    integer i, j, errors = 0;

    comparator4 dut (.a(a), .b(b), .gt(gt), .eq(eq), .lt(lt));

    initial begin
        // exhaustive over a representative sweep (all 16 vs 3 reference points, plus a full 16x16 sweep)
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i[3:0]; b = j[3:0];
                #4;
                if (gt !== (a>b) || eq !== (a==b) || lt !== (a<b)) begin
                    $display("FAIL: a=%0d b=%0d gt=%b eq=%b lt=%b", a,b,gt,eq,lt);
                    errors = errors + 1;
                end
            end
        end
        if (errors == 0) $display("TESTBENCH RESULT: PASS (full 16x16 exhaustive sweep)");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
