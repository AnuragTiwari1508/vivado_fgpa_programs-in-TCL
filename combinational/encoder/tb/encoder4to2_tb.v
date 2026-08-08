`timescale 1ns/1ps
module encoder4to2_tb;
    reg [3:0] in;
    wire [1:0] out;
    wire valid;
    integer i, errors = 0;

    encoder4to2 dut (.in(in), .out(out), .valid(valid));

    task check(input [1:0] exp_out, input exp_valid);
        begin
            if (out !== exp_out || valid !== exp_valid) begin
                $display("FAIL: in=%b out=%b valid=%b expected out=%b valid=%b", in,out,valid,exp_out,exp_valid);
                errors = errors + 1;
            end else
                $display("PASS: in=%b out=%b valid=%b", in,out,valid);
        end
    endtask

    initial begin
        in = 4'b0000; #10; check(2'b00, 1'b0);
        in = 4'b0001; #10; check(2'b00, 1'b1);
        in = 4'b0010; #10; check(2'b01, 1'b1);
        in = 4'b0100; #10; check(2'b10, 1'b1);
        in = 4'b1000; #10; check(2'b11, 1'b1);
        in = 4'b1010; #10; check(2'b11, 1'b1); // priority: bit3 wins
        in = 4'b0110; #10; check(2'b10, 1'b1); // priority: bit2 wins over bit1
        in = 4'b1111; #10; check(2'b11, 1'b1);
        if (errors == 0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
