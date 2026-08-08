`timescale 1ns/1ps
// Simple counter-based debouncer + 2-FF synchronizer for a mechanical pushbutton.
// btn_raw must be stable for DEBOUNCE_TICKS consecutive `sample_tick` pulses (drive
// sample_tick from clock_divider, e.g. ~1kHz) before btn_clean changes.
// ASSUMPTION (flagged in README): button is active-HIGH (pressed = 1). If physical
// testing shows the board's buttons are active-low, invert btn_raw at the input port.
module button_debounce #(
    parameter integer DEBOUNCE_TICKS = 4
) (
    input  wire clk,
    input  wire rst,
    input  wire sample_tick,   // slow sampling enable, NOT the raw system clock
    input  wire btn_raw,
    output reg  btn_clean
);
    reg btn_sync0, btn_sync1;
    reg [$clog2(DEBOUNCE_TICKS+1)-1:0] cnt;

    // 2-FF synchronizer (btn_raw may be asynchronous to clk)
    always @(posedge clk) begin
        btn_sync0 <= btn_raw;
        btn_sync1 <= btn_sync0;
    end

    always @(posedge clk) begin
        if (rst) begin
            cnt <= 0;
            btn_clean <= 1'b0;
        end else if (sample_tick) begin
            if (btn_sync1 == btn_clean) begin
                cnt <= 0; // stable at current output, nothing to do
            end else begin
                cnt <= cnt + 1'b1;
                if (cnt >= DEBOUNCE_TICKS - 1) begin
                    btn_clean <= btn_sync1;
                    cnt <= 0;
                end
            end
        end
    end
endmodule
