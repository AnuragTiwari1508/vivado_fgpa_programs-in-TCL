`timescale 1ns/1ps
// Board demo: 4-bit SIPO shift register. sw[0]=serial data in, auto-shifts on a
// slow ~2Hz internal tick (so bits visibly walk across the LEDs). btn[0]=reset.
module shift_register_demo_top (
    input  wire        clk,
    input  wire [3:0]  btn,
    input  wire [15:0] sw,
    output wire [3:0]  led
);
    wire rst = btn[0];
    wire tick;

    clock_divider #(.DIVIDE_COUNT(50_000_000)) u_div ( // ~2Hz
        .clk(clk), .rst(rst), .tick(tick)
    );

    shift_register4 u_shr (
        .clk(clk), .rst(rst), .en(tick), .serial_in(sw[0]), .q(led)
    );
endmodule
