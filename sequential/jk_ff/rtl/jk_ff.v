`timescale 1ns/1ps
// JK flip-flop. Synchronous active-high reset.
// j=0,k=0 hold; j=1,k=0 set; j=0,k=1 clear; j=1,k=1 toggle
module jk_ff (
    input  wire clk,
    input  wire rst,
    input  wire j,
    input  wire k,
    output reg  q
);
    always @(posedge clk) begin
        if (rst) q <= 1'b0;
        else begin
            case ({j,k})
                2'b00: q <= q;
                2'b01: q <= 1'b0;
                2'b10: q <= 1'b1;
                2'b11: q <= ~q;
            endcase
        end
    end
endmodule
