`timescale 1ns/1ps
// Board demo: 4-bit register. sw[3:0]=data in, btn[1]=load enable (debounced),
// btn[0]=functional reset. led[3:0]=stored value.
module register_demo_top (
    input  wire        clk,
    input  wire [3:0]  btn,
    input  wire [15:0] sw,
    output wire [3:0]  led
);
    wire rst = btn[0];
    wire tick_1khz, en_clean;

    // ~1kHz sampling tick for the debouncer
    clock_divider #(.DIVIDE_COUNT(100_000)) u_div (
        .clk(clk), .rst(rst), .tick(tick_1khz)
    );

    button_debounce #(.DEBOUNCE_TICKS(10)) u_deb (
        .clk(clk), .rst(rst), .sample_tick(tick_1khz), .btn_raw(btn[1]), .btn_clean(en_clean)
    );

    register4 u_reg (
        .clk(clk), .rst(rst), .en(en_clean), .d(sw[3:0]), .q(led)
    );
endmodule
