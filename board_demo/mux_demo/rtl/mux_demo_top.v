`timescale 1ns/1ps
// Board demo: 4:1 MUX. sw[3:2]=select, sw[1:0] unused as data inputs are tied to
// switches sw[7:4] instead so all four data lines + select are independently switchable.
// led[0] = mux output. led[1] = mirrors sw value being routed (visual confirmation aid).
module mux_demo_top (
    input  wire [15:0] sw,
    output wire [1:0]  led
);
    wire [3:0] d = sw[7:4];   // data inputs d0..d3
    wire [1:0] sel = sw[9:8]; // select
    wire y;

    mux4 u_mux (.d(d), .sel(sel), .y(y));

    assign led[0] = y;
    assign led[1] = d[sel]; // sanity mirror, should always equal led[0]
endmodule
