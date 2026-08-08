`timescale 1ns/1ps
// 4-bit Johnson (twisted-ring) counter. rst -> 0000. Feedback = inverted MSB into LSB.
// Sequence from 0000: 1000,1100,1110,1111,0111,0011,0001,0000 (8-state cycle)
module johnson_counter4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 4'b0000;
        else if (en) q <= {~q[0], q[3:1]};
    end
endmodule
