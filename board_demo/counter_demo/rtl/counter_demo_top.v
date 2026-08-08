`timescale 1ns/1ps
// Board demo: 4-bit up/down counter, auto-advancing on a slow (~2Hz) internal tick
// (NOT on raw pushbutton bounce -- see README / button_debounce notes).
// btn[0] = functional reset (no dedicated board reset pin, see README).
// sw[0]  = direction select (1=up, 0=down). led[3:0] = counter value.
module counter_demo_top (
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

    up_down_counter4 u_cnt (
        .clk(clk), .rst(rst), .en(tick), .dir(sw[0]), .q(led)
    );
endmodule
