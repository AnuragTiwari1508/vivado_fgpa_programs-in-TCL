`timescale 1ns/1ps
// Board demo: single-bit full adder. sw[0]=a, sw[1]=b, sw[2]=cin. led[0]=sum, led[1]=cout.
module full_adder_demo_top (
    input  wire [15:0] sw,
    output wire [1:0]  led
);
    full_adder u_fa (.a(sw[0]), .b(sw[1]), .cin(sw[2]), .sum(led[0]), .cout(led[1]));
endmodule
