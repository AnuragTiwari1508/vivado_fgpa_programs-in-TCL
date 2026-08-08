`timescale 1ns/1ps
// Free-running clock-enable ("tick") generator. Produces a single-cycle-wide pulse
// on `tick` once every DIVIDE_COUNT cycles of `clk`. This is the recommended way to
// slow down visible board behaviour instead of gating the FPGA global clock net.
module clock_divider #(
    parameter integer DIVIDE_COUNT = 100_000_000  // e.g. 100_000_000 @ 100MHz = 1Hz tick
) (
    input  wire clk,
    input  wire rst,   // synchronous active-high
    output reg  tick
);
    localparam integer CW = $clog2(DIVIDE_COUNT);
    reg [CW-1:0] cnt;

    always @(posedge clk) begin
        if (rst) begin
            cnt  <= {CW{1'b0}};
            tick <= 1'b0;
        end else if (cnt == DIVIDE_COUNT - 1) begin
            cnt  <= {CW{1'b0}};
            tick <= 1'b1;
        end else begin
            cnt  <= cnt + 1'b1;
            tick <= 1'b0;
        end
    end
endmodule
