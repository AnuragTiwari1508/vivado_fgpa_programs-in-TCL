`timescale 1ns/1ps
module full_adder_tb;
    reg a, b, cin;
    wire sum, cout;
    reg [1:0] exp;
    integer errors = 0;

    full_adder dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            {a,b,cin} = i[2:0];
            #10;
            exp = a + b + cin;
            if ({cout,sum} !== exp) begin
                $display("FAIL: a=%b b=%b cin=%b -> sum=%b cout=%b expected=%b", a,b,cin,sum,cout,exp);
                errors = errors + 1;
            end else
                $display("PASS: a=%b b=%b cin=%b -> sum=%b cout=%b", a,b,cin,sum,cout);
        end
        if (errors == 0) $display("TESTBENCH RESULT: PASS (all 8 cases)");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
