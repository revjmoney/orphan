`timescale 1ns/1ps
// Orphan Radio: tuners B..D (shared second CIC, FIFO 2) and the wide panadapter block capture.
// Internal loopback: 1000 kHz carrier with a 625 Hz AM tone.
module tb;
  reg clk = 0; always #5 clk = ~clk;
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire pull_low, fb, tx, mclk, bclk, lrclk, dout; wire [7:0] lvl, aud;
  orphan_radio #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
    .bus_rdata(rdata), .rx_in(1'b1), .rx_pull_low(pull_low), .fb_out(fb), .tx_out(tx),
    .mclk(mclk), .bclk(bclk), .lrclk(lrclk), .dout(dout), .led_level(lvl), .led_audio(aud));
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  task rd(input [9:0] i, output [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; re <= 1; @(posedge clk); re <= 0;
    @(posedge clk); v = rdata; repeat (3) @(posedge clk); end endtask
  integer k, f, n2; reg [31:0] v; real ea, eb, ec, ed, dab;
  initial begin
    wr(21, 32'd42949673);        // B 1000 kHz (same as A)
    wr(22, 32'd43164421);        // C 1005 kHz
    wr(23, 32'd45097156);        // D 1050 kHz
    wr(24, 32'd38654706);        // pan centre 900 kHz
    wr(25, 32'h0000_0085);       // rlog 5 (3.125 MHz), gain 8
    // tuners: compare A and B sample by sample, energies of C and D
    ea = 0; eb = 0; ec = 0; ed = 0; dab = 0;
    for (k = 0; k < 40; k = k + 1) begin
      @(posedge dut.smp); repeat (60) @(posedge clk);
      if (k > 12) begin
        ea = ea + 1.0 * dut.ri * dut.ri + 1.0 * dut.rq * dut.rq;
        eb = eb + 1.0 * $signed(dut.rs[0]) * $signed(dut.rs[0]) + 1.0 * $signed(dut.rs[1]) * $signed(dut.rs[1]);
        ec = ec + 1.0 * $signed(dut.rs[2]) * $signed(dut.rs[2]) + 1.0 * $signed(dut.rs[3]) * $signed(dut.rs[3]);
        ed = ed + 1.0 * $signed(dut.rs[4]) * $signed(dut.rs[4]) + 1.0 * $signed(dut.rs[5]) * $signed(dut.rs[5]);
        dab = dab + (1.0 * dut.ri - $signed(dut.rs[0])) * (1.0 * dut.ri - $signed(dut.rs[0]));
      end
      if (k == 20) $display("sample: A I %0d Q %0d   B I %0d Q %0d   C I %0d Q %0d   D I %0d Q %0d", dut.ri, dut.rq,
        $signed(dut.rs[0]), $signed(dut.rs[1]), $signed(dut.rs[2]), $signed(dut.rs[3]), $signed(dut.rs[4]), $signed(dut.rs[5]));
    end
    $display("rms A %.0f  B %.0f  C %.0f  D %.0f   rms(A_I - B_I) %.0f", $sqrt(ea / 27), $sqrt(eb / 27), $sqrt(ec / 27), $sqrt(ed / 27), $sqrt(dab / 27));
    rd(26, v); $display("FIFO 2 words waiting: %0d (3 per sample)", v);
    rd(27, v); $display("features: %h", v);
    // panadapter: capture 4096 samples, read them out
    wr(25, 32'h0000_0185);
    k = 0; v = 0;
    while (!v[31]) begin repeat (2000) @(posedge clk); rd(25, v); end
    f = $fopen("sim/pan_snap.txt", "w");
    for (k = 0; k < 4096; k = k + 1) begin rd(130, v); $fdisplay(f, "%0d %0d", $signed(v[31:16]), $signed(v[15:0])); end
    $fclose(f);
    $display("pan block captured and read: 4096 samples");
    $finish;
  end
endmodule
