`timescale 1ns/1ps
// D flip-flop, synchronous active-high reset
module d_ff (
    input  wire clk,
    input  wire rst,   // synchronous, active-high
    input  wire d,
    output reg  q
);
    always @(posedge clk) begin
        if (rst) q <= 1'b0;
        else     q <= d;
    end
endmodule
