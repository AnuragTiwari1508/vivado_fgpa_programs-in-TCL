`timescale 1ns/1ps
// 4-bit down counter with sync reset (resets to 15, the top of the count) and enable
module down_counter4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 4'd15;
        else if (en) q <= q - 1'b1;
    end
endmodule
