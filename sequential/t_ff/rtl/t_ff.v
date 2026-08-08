`timescale 1ns/1ps
// T flip-flop: toggles when t=1, holds when t=0. Synchronous active-high reset.
module t_ff (
    input  wire clk,
    input  wire rst,
    input  wire t,
    output reg  q
);
    always @(posedge clk) begin
        if (rst) q <= 1'b0;
        else if (t) q <= ~q;
    end
endmodule
