`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR: self-checking testbench for orphan_larson (the 4 board LEDs as a breathing scanner while
// mining). STEP is 4 clocks here, so one sweep end to end is 3 * 256 * 4 clocks.
//   iverilog -g2005 -o tb_larson.vvp sim/tb_larson.v orphan_larson.v && vvp tb_larson.vvp
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
module tb_larson;
    reg clk = 0, rstn = 0;
    always #5 clk = ~clk;
    reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
    wire [31:0] rdata;
    reg  [3:0] idle_n = 4'b1010;                  // what the LEDs show when the scanner is off (active low)
    wire [3:0] leds_n;
    reg        active = 0;                        // a miner core's own busy signal (KAS / BTC wire it in)
    orphan_larson #(.SLOT(5), .STEP(18'd4), .PWM_BITS(6), .HOLD(28'd2000)) dut (.clk(clk), .rstn(rstn),
        .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re), .bus_rdata(rdata), .active(active),
        .idle_n(idle_n), .leds_n(leds_n));
    integer pass = 0, total = 0;
    reg [31:0] rv;
    task wr(input [9:0] i, input [31:0] v);
        begin @(negedge clk); addr = {4'd5, i, 2'b00}; wdata = v; we = 1; @(negedge clk); we = 0; end
    endtask
    task rd(input [9:0] i);
        begin @(negedge clk); addr = {4'd5, i, 2'b00}; re = 1; @(negedge clk); re = 0; @(negedge clk); rv = rdata; end
    endtask
    task check(input ok, input [8*64-1:0] what);
        begin total = total + 1; if (ok) pass = pass + 1; else $display("FAIL %0s", what); end
    endtask
    // on-time of each LED over one 64-clock PWM window (leds_n low = lit)
    integer on0, on1, on2, on3, k;
    task measure;
        begin
            on0 = 0; on1 = 0; on2 = 0; on3 = 0;
            for (k = 0; k < 64; k = k + 1) begin
                @(negedge clk);
                if (!leds_n[0]) on0 = on0 + 1; if (!leds_n[1]) on1 = on1 + 1;
                if (!leds_n[2]) on2 = on2 + 1; if (!leds_n[3]) on3 = on3 + 1;
            end
        end
    endtask
    integer pos, saw3, back0, mid;
    initial begin
        repeat (4) @(negedge clk); rstn = 1;
        rd(0); check(rv == 32'h4C525331, "ID LRS1");
        rd(1); check(rv == 0, "MODE resets to 0");
        repeat (10) @(negedge clk);
        check(leds_n == idle_n, "scanner off: the LEDs show the design's own status");
        wr(1, 1);
        rd(1); check(rv == 1, "MODE reads back 1");
        // at the start the eye sits on LED 0: LED 0 brightest, LED 3 dark
        measure;
        check(on0 > 40 && on3 == 0, "start: LED 0 lit, LED 3 dark");
        // the eye travels to LED 3, then back to LED 0
        saw3 = 0; back0 = 0; mid = 0;
        for (pos = 0; pos < 3 * 256 * 4 * 2 + 200 && !back0; pos = pos + 64) begin
            measure;
            if (on3 > 40 && on0 == 0) saw3 = 1;
            if (on1 > 5 && on1 < 60) mid = 1;           // a part-lit LED: the fade, not on/off
            if (saw3 && on0 > 40) back0 = 1;
        end
        check(saw3, "the eye reaches LED 3 with LED 0 dark");
        check(mid, "LEDs fade (part brightness) between full and off");
        check(back0, "the eye comes back to LED 0");
        wr(1, 0);
        repeat (4) @(negedge clk);
        check(leds_n == idle_n, "scanner off again: status LEDs back");
        idle_n = 4'b0101; @(negedge clk); @(negedge clk);
        check(leds_n == 4'b0101, "status LEDs follow the design while off");
        // hardware switch: a core's busy signal runs the scanner, and short gaps (between nonce ranges) keep it going
        idle_n = 4'b1111; repeat (4) @(negedge clk);
        check(leds_n == 4'b1111, "core idle: status LEDs");
        active = 1; repeat (4) @(negedge clk);
        measure; check(on0 > 40, "core busy: the scanner runs with MODE 0");
        repeat (300) @(negedge clk);
        active = 0; repeat (500) @(negedge clk);
        active = 1; @(negedge clk); active = 0;
        measure; check(on0 < 40 || on1 > 0, "a short gap does not restart the eye on LED 0");
        repeat (2100) @(negedge clk);
        check(leds_n == 4'b1111, "core idle for HOLD: status LEDs back");
        $display("tb_larson: %0s %0d/%0d", pass == total ? "PASS" : "FAIL", pass, total);
        $finish;
    end
endmodule
