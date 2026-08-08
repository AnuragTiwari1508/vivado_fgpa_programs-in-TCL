`timescale 1ns/1ps
module mux4_tb;
    reg [3:0] d;
    reg [1:0] sel;
    wire y;
    integer i, errors = 0;

    mux4 dut (.d(d), .sel(sel), .y(y));

    initial begin
        d = 4'b1010; // d0=0 d1=1 d2=0 d3=1
        for (i = 0; i < 4; i = i + 1) begin
            sel = i[1:0];
            #10;
            if (y !== d[i]) begin
                $display("FAIL: sel=%0d d=%b -> y=%b expected=%b", i, d, y, d[i]);
                errors = errors + 1;
            end else
                $display("PASS: sel=%0d -> y=%b", i, y);
        end
        if (errors == 0) $display("TESTBENCH RESULT: PASS (all 4 selects)");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
