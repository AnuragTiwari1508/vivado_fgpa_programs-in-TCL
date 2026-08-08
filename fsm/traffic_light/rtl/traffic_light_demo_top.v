`timescale 1ns/1ps
// Board demo top: traffic_light_fsm driven by the 100MHz board clock through a
// clock divider that produces a slow ~1Hz tick. btn[0] = functional reset (see README
// for why this board has no dedicated reset pin). NS lights on led[2:0]={R,Y,G},
// EW lights on led[5:3]={R,Y,G}.
module traffic_light_demo_top (
    input  wire clk,
    input  wire [3:0] btn,
    output wire [5:0] led
);
    wire rst = btn[0];
    wire tick;

    // Divide 100MHz down to a ~1Hz enable pulse
    clock_divider #(.DIVIDE_COUNT(100_000_000)) u_div (
        .clk(clk), .rst(rst), .tick(tick)
    );

    wire [2:0] ns_light, ew_light;
    traffic_light_fsm #(.HOLD_GREEN(5), .HOLD_YELLOW(2)) u_fsm (
        .clk(clk), .rst(rst), .tick(tick), .ns_light(ns_light), .ew_light(ew_light)
    );

    assign led[2:0] = ns_light;
    assign led[5:3] = ew_light;
endmodule
