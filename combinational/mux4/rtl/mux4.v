`timescale 1ns/1ps
// 4:1 multiplexer - purely combinational
module mux4 (
    input  wire [3:0] d,     // d[0]..d[3]
    input  wire [1:0] sel,
    output wire        y
);
    assign y = d[sel];
endmodule
