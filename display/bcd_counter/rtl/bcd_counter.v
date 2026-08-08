`timescale 1ns/1ps
// BCD (0-9) counter with synchronous reset and enable. Rolls over 9 -> 0.
module bcd_counter (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 4'd0;
        else if (en) begin
            if (q == 4'd9) q <= 4'd0;
            else           q <= q + 1'b1;
        end
    end
endmodule
