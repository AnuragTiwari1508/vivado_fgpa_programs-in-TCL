`timescale 1ns/1ps
// 4-bit register with synchronous active-high reset and enable
module register4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire [3:0] d,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 4'b0000;
        else if (en) q <= d;
    end
endmodule
