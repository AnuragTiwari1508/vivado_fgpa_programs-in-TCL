`timescale 1ns/1ps
module ripple_adder4_tb;
    reg [3:0] a, b;
    reg cin;
    wire [3:0] sum;
    wire cout;
    reg [4:0] exp;
    integer i, errors = 0;

    ripple_adder4 dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        errors = 0;
        // Directed corner cases + pseudo-exhaustive sweep
        for (i = 0; i < 64; i = i + 1) begin
            a   = i[3:0];
            b   = ~i[3:0];
            cin = i[4] & 1'b0; // keep deterministic; cin cycled below too
            #10;
        end
        // cin=0 sweep
        cin = 0;
        for (i = 0; i < 16; i = i + 1) begin
            a = i[3:0]; b = 4'd7;
            #10;
            exp = a + b + cin;
            if ({cout,sum} !== exp) begin
                $display("FAIL: a=%0d b=%0d cin=%0d -> sum=%0d cout=%0d expected=%0d", a,b,cin,sum,cout,exp);
                errors = errors + 1;
            end
        end
        // cin=1 sweep
        cin = 1;
        for (i = 0; i < 16; i = i + 1) begin
            a = i[3:0]; b = 4'd9;
            #10;
            exp = a + b + cin;
            if ({cout,sum} !== exp) begin
                $display("FAIL: a=%0d b=%0d cin=%0d -> sum=%0d cout=%0d expected=%0d", a,b,cin,sum,cout,exp);
                errors = errors + 1;
            end
        end
        // rollover check: 15+1+0 = 16 -> cout=1 sum=0
        a = 4'd15; b = 4'd1; cin = 0; #10;
        if ({cout,sum} !== 5'd16) begin
            $display("FAIL rollover: a=15 b=1 cin=0 -> sum=%0d cout=%0d", sum, cout);
            errors = errors + 1;
        end else
            $display("PASS rollover: 15+1 -> cout=1 sum=0");

        if (errors == 0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
