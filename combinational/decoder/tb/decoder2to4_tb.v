`timescale 1ns/1ps
module decoder2to4_tb;
    reg [1:0] in;
    reg en;
    wire [3:0] out;
    integer i, errors = 0;
    reg [3:0] exp;

    decoder2to4 dut (.in(in), .en(en), .out(out));

    initial begin
        en = 0;
        for (i = 0; i < 4; i = i + 1) begin
            in = i[1:0]; #10;
            if (out !== 4'b0000) begin
                $display("FAIL (disabled): in=%0d out=%b expected=0000", i, out);
                errors = errors + 1;
            end else
                $display("PASS (disabled): in=%0d out=%b", i, out);
        end
        en = 1;
        for (i = 0; i < 4; i = i + 1) begin
            in = i[1:0]; #10;
            exp = (4'b0001 << i);
            if (out !== exp) begin
                $display("FAIL: in=%0d out=%b expected=%b", i, out, exp);
                errors = errors + 1;
            end else
                $display("PASS: in=%0d out=%b", i, out);
        end
        if (errors == 0) $display("TESTBENCH RESULT: PASS (all cases)");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
