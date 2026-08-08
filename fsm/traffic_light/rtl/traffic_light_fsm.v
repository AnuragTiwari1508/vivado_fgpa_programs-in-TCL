`timescale 1ns/1ps
// Simple 2-road traffic light FSM (Moore machine).
// States cycle: NS_GREEN -> NS_YELLOW -> EW_GREEN -> EW_YELLOW -> (repeat)
// tick is a single-cycle enable pulse (typically from a slow clock-enable divider),
// so the FSM only advances toward the next timed transition once per "tick".
// Each state holds for `HOLD_TICKS` ticks before moving on.
module traffic_light_fsm #(
    parameter HOLD_GREEN  = 4,
    parameter HOLD_YELLOW = 2
) (
    input  wire clk,
    input  wire rst,   // synchronous active-high
    input  wire tick,  // 1-cycle pulse, advances the internal timer
    output reg  [2:0] ns_light, // {R,Y,G}
    output reg  [2:0] ew_light  // {R,Y,G}
);
    localparam S_NS_GREEN  = 2'd0;
    localparam S_NS_YELLOW = 2'd1;
    localparam S_EW_GREEN  = 2'd2;
    localparam S_EW_YELLOW = 2'd3;

    reg [1:0] state;
    reg [3:0] timer;

    wire [3:0] hold_limit = (state == S_NS_YELLOW || state == S_EW_YELLOW) ? HOLD_YELLOW : HOLD_GREEN;

    always @(posedge clk) begin
        if (rst) begin
            state <= S_NS_GREEN;
            timer <= 4'd0;
        end else if (tick) begin
            if (timer >= hold_limit - 1'b1) begin
                timer <= 4'd0;
                case (state)
                    S_NS_GREEN:  state <= S_NS_YELLOW;
                    S_NS_YELLOW: state <= S_EW_GREEN;
                    S_EW_GREEN:  state <= S_EW_YELLOW;
                    S_EW_YELLOW: state <= S_NS_GREEN;
                    default:     state <= S_NS_GREEN;
                endcase
            end else begin
                timer <= timer + 1'b1;
            end
        end
    end

    // Moore outputs: {R,Y,G}, active-high
    always @(*) begin
        case (state)
            S_NS_GREEN:  begin ns_light = 3'b001; ew_light = 3'b100; end
            S_NS_YELLOW: begin ns_light = 3'b010; ew_light = 3'b100; end
            S_EW_GREEN:  begin ns_light = 3'b100; ew_light = 3'b001; end
            S_EW_YELLOW: begin ns_light = 3'b100; ew_light = 3'b010; end
            default:     begin ns_light = 3'b100; ew_light = 3'b100; end
        endcase
    end
endmodule
