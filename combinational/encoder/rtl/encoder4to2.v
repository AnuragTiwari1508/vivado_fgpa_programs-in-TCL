`timescale 1ns/1ps
// 4-to-2 PRIORITY encoder (in[3] has highest priority).
// valid=1 when at least one input is asserted.
module encoder4to2 (
    input  wire [3:0] in,
    output reg  [1:0] out,
    output wire       valid
);
    assign valid = |in;

    always @(*) begin
        casez (in)
            4'b1???: out = 2'b11;
            4'b01??: out = 2'b10;
            4'b001?: out = 2'b01;
            4'b0001: out = 2'b00;
            default: out = 2'b00; // in==0000, valid=0, output don't-care but defined
        endcase
    end
endmodule
