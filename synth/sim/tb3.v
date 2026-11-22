`timescale 1ns/1ps
// Orphan Synth v2 testbench: pitch, filter stability, mixer + LFO, polyphony, LED block.
module tb;
  reg clk = 0; always #5 clk = ~clk;
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata, rd_led; wire mclk, bclk, lrclk, dout;
  wire [31:0] led_voice; wire [7:0] led_vu, led_lfo; wire [3:0] leds_n;
  orphan_synth #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
    .bus_rdata(rdata), .mclk(mclk), .bclk(bclk), .lrclk(lrclk), .dout(dout),
    .led_voice(led_voice), .led_vu(led_vu), .led_lfo(led_lfo));
  orphan_leds #(.SLOT(14)) leds (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
    .bus_rdata(rd_led), .auto_lvl(led_voice), .vu(led_vu), .lfo(led_lfo), .leds_n(leds_n));
  task wr(input [3:0] s, input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {s, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  integer k, mn, mx, zc, on_cnt; reg signed [15:0] prev;
  task run(input integer frames, input [255:0] label);
    begin
      mn = 99999; mx = -99999; zc = 0; prev = 0;
      for (k = 0; k < frames; k = k + 1) begin
        repeat (2048) @(posedge clk);
        if (k > frames / 4) begin
          if ($signed(dut.mix_out) < mn) mn = $signed(dut.mix_out);
          if ($signed(dut.mix_out) > mx) mx = $signed(dut.mix_out);
          if (prev < 0 && $signed(dut.mix_out) >= 0) zc = zc + 1;
        end
        prev = dut.mix_out;
      end
      $display("%0s: min %0d max %0d, rising zero crossings %0d in %0d frames (%.1f Hz)", label, mn, mx, zc,
               frames - frames / 4 - 1, zc * 48828.125 / (frames - frames / 4 - 1));
    end
  endtask
  initial begin
    // 220 Hz saw, filter bypass
    wr(1, 0, 3); wr(1, 1, 255); wr(1, 30, 3); wr(1, 7, 3000000); wr(1, 9, 50000); wr(1, 18, 200);
    wr(1, 32, 32'd19352245); wr(1, 34, 65535); wr(1, 33, 1);
    run(6000, "saw 220 Hz bypass");
    // low-pass, resonance, filter envelope
    wr(1, 30, 0); wr(1, 15, 25000); wr(1, 16, 20000); wr(1, 17, 20000); wr(1, 11, 200000); wr(1, 12, 3000); wr(1, 13, 10000);
    wr(1, 33, 0); repeat (4096) @(posedge clk); wr(1, 33, 1);
    run(4000, "low-pass + reso + f-env");
    // everything + LFO (vib, trem, pwm, filter) + 3 voices
    wr(1, 2, 150); wr(1, 3, 100); wr(1, 4, 100); wr(1, 5, 150); wr(1, 6, 40);
    wr(1, 19, 32'd500000); wr(1, 20, 30000); wr(1, 21, 20000); wr(1, 22, 40000); wr(1, 23, 20000);
    wr(1, 36, 32'd24382000); wr(1, 38, 50000); wr(1, 37, 1);
    wr(1, 40, 32'd29000000); wr(1, 42, 40000); wr(1, 41, 1);
    run(4000, "full mix + LFO + 3 voices");
    $display("active voices %b, led_voice %h, vu %0d, lfo %0d", dut.active, led_voice, led_vu, led_lfo);
    // high-pass and band-pass with heavy resonance: must not blow up
    wr(1, 30, 2); wr(1, 16, 3000); run(3000, "high-pass reso max");
    wr(1, 30, 1); run(3000, "band-pass reso max");
    // LEDs: LED0 manual 255, LED1 VU bar, LED2 auto, LED3 flash
    wr(14, 1, 16'h1320); wr(14, 2, 255); wr(14, 5, 255);
    on_cnt = 0; for (k = 0; k < 65536; k = k + 1) begin @(posedge clk); if (!leds_n[0]) on_cnt = on_cnt + 1; end
    $display("LED0 manual 255 duty %0d / 65536; eff1 %0d eff2 %0d eff3 %0d", on_cnt, leds.eff[1], leds.eff[2], leds.eff[3]);
    repeat (3000000) @(posedge clk);
    $display("LED3 flash after 30 ms: %0d (decay 4/ms)", leds.eff[3]);
    $finish;
  end
endmodule
