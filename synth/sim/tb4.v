`timescale 1ns/1ps
// Orphan Synth v3 testbench: drive shapes, crusher, mod matrix, FX FIFO timing (a fake orphan-fxd).
module tb;
  reg clk = 0; always #5 clk = ~clk;
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire mclk, bclk, lrclk, dout; wire [31:0] lv; wire [7:0] vu, lfo;
  orphan_synth #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
    .bus_rdata(rdata), .mclk(mclk), .bclk(bclk), .lrclk(lrclk), .dout(dout), .led_voice(lv), .led_vu(vu), .led_lfo(lfo));
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  reg [31:0] got;
  task rd(input [9:0] i); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; re <= 1; @(posedge clk); re <= 0; @(posedge clk); @(posedge clk); got = rdata; end endtask
  integer k, mn, mx, n, distinct; reg signed [15:0] prev;
  task run(input integer frames, input [255:0] label);
    begin
      mn = 99999; mx = -99999; distinct = 0; prev = 0;
      for (k = 0; k < frames; k = k + 1) begin
        repeat (2048) @(posedge clk);
        if (k > frames / 3) begin
          if ($signed(dut.mix_out) < mn) mn = $signed(dut.mix_out);
          if ($signed(dut.mix_out) > mx) mx = $signed(dut.mix_out);
          if (dut.mix_out != prev) distinct = distinct + 1;
        end
        prev = dut.mix_out;
      end
      $display("%0s: out %0d..%0d, changed on %0d of %0d samples", label, mn, mx, distinct, frames - frames / 3 - 1);
    end
  endtask
  initial begin
    wr(0, 3); wr(1, 255); wr(30, 3); wr(7, 3000000); wr(9, 60000); wr(18, 256);
    wr(32, 32'd19352245); wr(34, 65535); wr(33, 1);
    run(300, "clean saw");
    wr(64, {14'd0, 2'd2, 16'd2048}); run(200, "hard clip x8");
    wr(64, {14'd0, 2'd1, 16'd1024}); run(200, "soft x4");
    wr(64, {14'd0, 2'd3, 16'd4096}); run(200, "fold x16");
    wr(64, {14'd0, 2'd0, 16'd256});
    wr(65, {18'd0, 6'd1, 3'd0, 5'd3}); run(200, "crush 3 bits");
    wr(65, {18'd0, 6'd8, 3'd0, 5'd16}); run(200, "downsample /8");
    wr(65, {18'd0, 6'd1, 3'd0, 5'd16});
    // mod matrix: LFO1 square 20 Hz -> amp depth full
    wr(19, 32'd1759218); wr(21, 32'd4); wr(22, {16'h7FFF, 1'b0, 3'd4, 2'b00, 2'd1});
    run(400, "LFO1 square -> amp");
    $display("  L1 %0d trem_g %0d", dut.L1, dut.trem_g);
    wr(22, 0);
    // FX streams: returns on, fake daemon pushes a constant 8000 delay return and reads the capture
    wr(66, 0); wr(67, 32768); wr(68, 65535); wr(69, 0);
    wr(0, 7);
    repeat (2048 * 20) @(posedge clk);
    rd(77); $display("underruns before any push: %0d", got);
    rd(72); $display("T %0d", got); rd(75); $display("PLAY_T %0d (should be T or T+1)", got);
    for (n = 0; n < 200; n = n + 1) wr(512, {16'd8000, 16'd0});
    rd(76); $display("PLAY_LEVEL after 200 pushes %0d", got);
    rd(74); $display("CAP2_LEVEL %0d", got[12:0]); rd(73); $display("CAP2_T %0d", got);
    rd(512); $display("popped {dly_in, loop_rec} = %0d, %0d", $signed(got[31:16]), $signed(got[15:0]));
    rd(73); $display("CAP2_T after one pop %0d", got);
    run(100, "returns: delay wet 0.5 x 8000 added");
    rd(77); $display("underruns now %0d (FIFO ran dry after 200)", got);
    $finish;
  end
endmodule
