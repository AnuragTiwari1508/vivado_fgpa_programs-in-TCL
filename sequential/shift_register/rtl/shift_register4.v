`timescale 1ns/1ps
// 4-bit SIPO shift register, shifts in serial_in at LSB each clock; sync reset; enable.
module shift_register4 (
    input  wire       clk,
    input  wire       rst,
    input  wire       en,
    input  wire       serial_in,
    output reg  [3:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 4'b0000;
        else if (en) q <= {q[2:0], serial_in};
    end
endmodule
