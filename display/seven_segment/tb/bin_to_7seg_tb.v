`timescale 1ns/1ps
module bin_to_7seg_tb;
    reg [3:0] bin;
    wire [6:0] seg;
    integer i, errors = 0;
    reg [6:0] exp;

    bin_to_7seg dut (.bin(bin), .seg(seg));

    function [6:0] expected(input [3:0] v);
        case (v)
            4'h0: expected = 7'b1000000; 4'h1: expected = 7'b1111001;
            4'h2: expected = 7'b0100100; 4'h3: expected = 7'b0110000;
            4'h4: expected = 7'b0011001; 4'h5: expected = 7'b0010010;
            4'h6: expected = 7'b0000010; 4'h7: expected = 7'b1111000;
            4'h8: expected = 7'b0000000; 4'h9: expected = 7'b0010000;
            4'hA: expected = 7'b0001000; 4'hB: expected = 7'b0000011;
            4'hC: expected = 7'b1000110; 4'hD: expected = 7'b0100001;
            4'hE: expected = 7'b0000110; 4'hF: expected = 7'b0001110;
            default: expected = 7'b1111111;
        endcase
    endfunction

    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            bin = i[3:0]; #10;
            exp = expected(bin);
            if (seg !== exp) begin
                $display("FAIL: bin=%h seg=%b expected=%b", bin, seg, exp);
                errors = errors + 1;
            end else
                $display("PASS: bin=%h seg=%b", bin, seg);
        end
        if (errors == 0) $display("TESTBENCH RESULT: PASS (all 16 digits)");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
