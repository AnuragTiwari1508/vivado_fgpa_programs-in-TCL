`timescale 1ns/1ps
// 4-bit up counter with sync reset and enable, wraps 15->0
module up_counter4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 4'd0;
        else if (en) q <= q + 1'b1;
    end
endmodule
