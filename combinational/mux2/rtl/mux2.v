`timescale 1ns/1ps
// 2:1 multiplexer - purely combinational, no latches
module mux2 (
    input  wire a,
    input  wire b,
    input  wire sel,   // 0 -> a, 1 -> b
    output wire y
);
    assign y = sel ? b : a;
endmodule
