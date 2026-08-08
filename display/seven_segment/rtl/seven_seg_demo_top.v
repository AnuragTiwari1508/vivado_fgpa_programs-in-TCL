`timescale 1ns/1ps
// Board-demo top for the 7-segment decoder.
// SW[3:0] selects a hex digit (0-F), shown on 7-seg display 0, digit position 0.
// Other 3 digit anodes are driven HIGH (=off, anodes are active-low enable).
module seven_seg_demo_top (
    input  wire [3:0] sw,
    output wire [3:0] D0_AN,
    output wire [7:0] D0_SEG
);
    wire [6:0] seg;
    bin_to_7seg u_dec (.bin(sw), .seg(seg));

    assign D0_AN   = 4'b1110;      // enable only digit 0 (active-low anode)
    assign D0_SEG  = {1'b1, seg};  // seg[7]=dp (off=1), seg[6:0]=g..a active-low
endmodule
