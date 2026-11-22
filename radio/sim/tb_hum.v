`timescale 1ns/1ps
// Orphan Radio: hum comb + noise blanker check (internal loopback test tone).
module tb;
  reg clk = 0; always #5 clk = ~clk;
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire pull_low, fb, tx, mclk, bclk, lrclk, dout; wire [7:0] lvl, aud;
  orphan_radio #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
    .bus_rdata(rdata), .rx_in(1'b1), .rx_pull_low(pull_low), .fb_out(fb), .tx_out(tx),
    .mclk(mclk), .bclk(bclk), .lrclk(lrclk), .dout(dout), .led_level(lvl), .led_audio(aud));
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  integer k; real e;
  task run(input integer n, input [255:0] label);
    begin
      e = 0;
      for (k = 0; k < n; k = k + 1) begin @(posedge dut.smp); @(posedge clk); if (k > n / 2) e = e + 1.0 * dut.audio * dut.audio; end
      $display("%0s: audio rms %.0f, blanked %0d", label, $sqrt(e / (n - n / 2 - 1)), dut.nb_count);
    end
  endtask
  initial begin
    wr(5, 32'd25770);                        // 600 Hz tone = 10th harmonic of 60 Hz
    run(1200, "600 Hz tone, hum off");
    wr(15, 32'd31130); wr(17, -32'sd1047); wr(18, 32'd10126); wr(19, 32'd8285); wr(20, -32'sd980); wr(14, {8'd0, 16'd52083, 7'd0, 1'b1});
    run(1200, "600 Hz tone, hum 60 on");
    wr(5, 32'd26844);                        // 625 Hz: between harmonics
    run(1200, "625 Hz tone, hum 60 on");
    wr(14, 0); wr(13, {20'd0, 4'd6, 3'd0, 5'd4});
    run(600, "625 Hz, blanker k=4 on a clean signal");
    $finish;
  end
endmodule
