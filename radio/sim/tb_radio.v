`timescale 1ns/1ps
// Orphan Radio testbench: internal loopback, 1000 kHz carrier with a 625 Hz AM tone.
module tb;
  reg clk = 0; always #5 clk = ~clk;
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire pull_low, fb, tx, mclk, bclk, lrclk, dout; wire [7:0] lvl, aud;
  orphan_radio #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
    .bus_rdata(rdata), .rx_in(1'b1), .rx_pull_low(pull_low), .fb_out(fb), .tx_out(tx),
    .mclk(mclk), .bclk(bclk), .lrclk(lrclk), .dout(dout), .led_level(lvl), .led_audio(aud));
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  integer k, zc, mn, mx; reg signed [15:0] prev;
  task run(input integer n, input [255:0] label);
    begin
      zc = 0; mn = 99999; mx = -99999; prev = 0;
      for (k = 0; k < n; k = k + 1) begin
        @(posedge dut.smp); @(posedge clk);
        if (k > n / 3) begin
          if (dut.audio < mn) mn = dut.audio; if (dut.audio > mx) mx = dut.audio;
          if (prev < 0 && dut.audio >= 0) zc = zc + 1;
        end
        prev = dut.audio;
      end
      $display("%0s: carrier %0d, I %0d Q %0d, audio %0d..%0d, tone %.0f Hz, density %0d", label, dut.carrier,
               dut.ri, dut.rq, mn, mx, zc * 12207.03 / (n - n / 3 - 1), dut.density);
    end
  endtask
  initial begin
    run(300, "tuned 1000 kHz");
    wr(1, 32'd43164421);          // 1005 kHz: 5 kHz off, tone should still come through (as a 5 kHz het + tone)
    run(300, "tuned 1005 kHz");
    wr(1, 32'd45097156);          // 1050 kHz: off channel
    run(300, "tuned 1050 kHz");
    wr(1, 32'd42949673);
    wr(6, 0);                     // no modulation: carrier only, audio ~0
    run(300, "1000 kHz, depth 0");
    $finish;
  end
endmodule
