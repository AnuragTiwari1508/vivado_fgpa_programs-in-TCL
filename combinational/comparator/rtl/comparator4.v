`timescale 1ns/1ps
module comparator4 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire        gt,
    output wire        eq,
    output wire        lt
);
    assign eq = (a == b);
    assign gt = (a > b);
    assign lt = (a < b);
endmodule
