`timescale 1ns/1ps
// 4-bit up/down counter. dir=1 -> count up, dir=0 -> count down. sync reset to 0.
module up_down_counter4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire       dir,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 4'd0;
        else if (en) q <= dir ? (q + 1'b1) : (q - 1'b1);
    end
endmodule
