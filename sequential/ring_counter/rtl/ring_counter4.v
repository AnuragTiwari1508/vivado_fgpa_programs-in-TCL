`timescale 1ns/1ps
// 4-bit ring counter. rst loads 0001 (one-hot walking bit). Rotates left each enabled clock.
module ring_counter4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 4'b0001;
        else if (en) q <= {q[2:0], q[3]};
    end
endmodule
