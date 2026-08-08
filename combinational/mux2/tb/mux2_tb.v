`timescale 1ns/1ps
module mux2_tb;
    reg a, b, sel;
    wire y;
    integer errors = 0;

    mux2 dut (.a(a), .b(b), .sel(sel), .y(y));

    task check(input exp);
        begin
            if (y !== exp) begin
                $display("FAIL: a=%b b=%b sel=%b -> y=%b expected=%b", a,b,sel,y,exp);
                errors = errors + 1;
            end else begin
                $display("PASS: a=%b b=%b sel=%b -> y=%b", a,b,sel,y);
            end
        end
    endtask

    initial begin
        // exhaustive: all 8 combinations of a,b,sel
        {a,b,sel} = 3'b000; #10; check(a);
        {a,b,sel} = 3'b001; #10; check(b);
        {a,b,sel} = 3'b010; #10; check(a);
        {a,b,sel} = 3'b011; #10; check(b);
        {a,b,sel} = 3'b100; #10; check(a);
        {a,b,sel} = 3'b101; #10; check(b);
        {a,b,sel} = 3'b110; #10; check(a);
        {a,b,sel} = 3'b111; #10; check(b);

        if (errors == 0) $display("TESTBENCH RESULT: PASS (all 8 cases)");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
