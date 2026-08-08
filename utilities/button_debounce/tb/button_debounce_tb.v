`timescale 1ns/1ps
module button_debounce_tb;
    reg clk = 0, rst, sample_tick, btn_raw;
    wire btn_clean;
    integer errors = 0;

    button_debounce #(.DEBOUNCE_TICKS(3)) dut (
        .clk(clk), .rst(rst), .sample_tick(sample_tick), .btn_raw(btn_raw), .btn_clean(btn_clean)
    );
    always #5 clk = ~clk;

    // one sampling pulse, one clock wide
    task do_sample;
        begin
            sample_tick = 1; @(posedge clk); #1; sample_tick = 0; @(posedge clk); #1;
        end
    endtask

    // let the input 2-FF synchronizer settle (2 clocks) before we start sampling
    task settle_sync;
        begin
            @(posedge clk); #1; @(posedge clk); #1;
        end
    endtask

    initial begin
        rst = 1; btn_raw = 0; sample_tick = 0; @(posedge clk); #1; rst = 0;
        if (btn_clean !== 0) begin $display("FAIL reset: btn_clean=%b",btn_clean); errors=errors+1; end
        else $display("PASS reset: btn_clean=0");

        // Press the button: raw goes high. Let synchronizer settle, then sample once -
        // should NOT yet propagate (needs DEBOUNCE_TICKS=3 stable samples).
        btn_raw = 1;
        settle_sync();
        do_sample();
        if (btn_clean !== 0) begin
            $display("FAIL: propagated too early after 1 sample: btn_clean=%b",btn_clean);
            errors = errors + 1;
        end else
            $display("PASS: no premature propagation after 1 sample");

        // simulate a bounce: raw drops back low briefly, which resets the debounce counter
        btn_raw = 0;
        settle_sync();
        do_sample();

        // now press again and hold - after DEBOUNCE_TICKS consecutive stable samples,
        // btn_clean should go high
        btn_raw = 1;
        settle_sync();
        do_sample(); do_sample(); do_sample();

        if (btn_clean !== 1) begin
            $display("FAIL: expected debounced HIGH after %0d stable samples, got %b", 3, btn_clean);
            errors = errors + 1;
        end else
            $display("PASS: debounced output went HIGH after stable samples");

        // release the button and confirm it debounces back low
        btn_raw = 0;
        settle_sync();
        do_sample(); do_sample(); do_sample();
        if (btn_clean !== 0) begin
            $display("FAIL: expected debounced LOW after release, got %b", btn_clean);
            errors = errors + 1;
        end else
            $display("PASS: debounced output returned LOW after release");

        if (errors==0) $display("TESTBENCH RESULT: PASS");
        else $display("TESTBENCH RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
