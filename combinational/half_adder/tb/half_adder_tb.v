`timescale 1ns/1ps
module half_adder_tb;
    reg a, b;
    wire sum, cout;
    integer errors = 0;
    reg exp_sum, exp_cout;

    half_adder dut (.a(a), .b(b), .sum(sum), .cout(cout));

    integer i;
    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            {a,b} = i[1:0];
            #10;
            exp_sum  = a ^ b;
            exp_cout = a & b;
            if (sum !== exp_sum || cout !== exp_cout) begin
                $display("FAIL: a=%b b=%b -> sum=%b cout=%b expected sum=%b cout=%b", a,b,sum,cout,exp_sum,exp_cout);
                errors = errors + 1;
            end else
                $display("PASS: a=%b b=%b -> sum=%b cout=%b", a,b,sum,cout);
        end
        if (errors == 0) $display("TESTBENCH RESULT: PASS (all 4 cases)");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
