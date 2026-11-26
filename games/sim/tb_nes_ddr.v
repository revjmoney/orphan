`timescale 1ns/1ps
// Orphan NES block with the cart in the DDR (NES2): the HP2 port answers from a model of the DDR with random
// delays (arready 0..7 clocks, first beat 4..40 clocks, gaps between beats 0..3). The cart's 4 KB pages lie
// scrambled in that memory, so the page table is really used. Checks the probe (8 bytes read back by the FPGA),
// runs the game, prints misses and wait clocks per frame, and dumps a frozen frame like tb_nes.v.
//   +define+FLAGS=<hex mapper flags> +define+FRAMES=<n> +define+IMG="file" (2 MB cart image, 64-bit words hex:
//   PRG at 0, CHR at 0x100000) [+define+PADAT=<frame> press Start there for 4 frames] [+define+FAST: no random]
module tb;
  reg clk = 0; always #5 clk = ~clk;
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire [7:0] level;
  wire hp_clk, hp_arvalid, hp_rready; wire [31:0] hp_araddr; wire [3:0] hp_arlen;
  reg  hp_arready = 0, hp_rvalid = 0, hp_rlast = 0; reg [63:0] hp_rdata = 0; reg [1:0] hp_rresp = 0;
  orphan_nes_block #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we),
    .bus_re(re), .bus_rdata(rdata), .level(level), .hw_pads(16'd0), .hw_drive(2'd0), .hw_enable(), .hw_port1(),
    .hw_port2(), .hw_never(),
    .hp_clk(hp_clk), .hp_araddr(hp_araddr), .hp_arlen(hp_arlen), .hp_arvalid(hp_arvalid), .hp_arready(hp_arready),
    .hp_rdata(hp_rdata), .hp_rvalid(hp_rvalid), .hp_rlast(hp_rlast), .hp_rresp(hp_rresp), .hp_rready(hp_rready));
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  task rd(input [9:0] i, output [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; re <= 1; @(posedge clk); re <= 0;
    @(posedge clk); v = rdata; repeat (3) @(posedge clk); end endtask

  // ---- the DDR: cart page p lies at physical page BASE + perm(p)
  localparam BASE = 20'h1A000;
  function [8:0] perm(input [8:0] p); perm = (p * 9'd167 + 9'd101); endfunction   // 167 odd: a permutation of 0..511
  reg [63:0] cart [0:262143];
  reg [63:0] phys [0:262143];
  integer k, f, n, errs, seed; reg [31:0] v, v2;
  // HP2 slave on hp_clk: one burst at a time
  integer lat, gap, beats; reg [31:0] a;
  reg busy = 0;
  always @(posedge hp_clk) begin
    if (!busy && hp_arvalid && !hp_arready) begin
      `ifdef FAST lat = 0; `else lat = $urandom(seed) % 8; `endif
      repeat (lat) @(posedge hp_clk);
      hp_arready <= 1; a = hp_araddr; beats = hp_arlen + 1; busy = 1;
      @(posedge hp_clk); hp_arready <= 0;
      `ifdef FAST lat = 4; `else lat = 4 + $urandom(seed) % 37; `endif
      repeat (lat) @(posedge hp_clk);
      while (beats > 0) begin
        if (a[31:12] < BASE || a[31:12] >= BASE + 512) begin hp_rresp <= 2'b10; hp_rdata <= 64'hDEAD; end
        else begin hp_rresp <= 2'b00; hp_rdata <= phys[{a[20:12] - BASE[8:0], a[11:3]}]; end
        hp_rvalid <= 1; hp_rlast <= (beats == 1);
        @(posedge hp_clk); hp_rvalid <= 0; hp_rlast <= 0;
        a = a + 8; beats = beats - 1;
        `ifdef FAST gap = 0; `else gap = $urandom(seed) % 4; `endif
        if (beats > 0) repeat (gap) @(posedge hp_clk);
      end
      busy = 0;
    end
  end
  always @(posedge hp_clk) if (hp_rvalid && !hp_rready) begin $display("FAIL: rready low"); $finish; end


  // the console's whole life, hashed: every step's memory address, the bytes it got and the pixel (equal hashes
  // in two runs = the console did exactly the same thing, whatever the cart memory behind it)
  reg [63:0] trace = 64'd0, trace_f = 64'd0; integer xcol = 0, ti; reg [48:0] tv, tz;
  always @(posedge dut.nclk) if (dut.run_nes) begin
    // (unwritten RAM reads X in simulation, 0 on the chip, on both cores alike: X bits count as 0 here)
    tv = {dut.memory_addr, dut.memory_read_cpu, dut.memory_read_ppu, dut.memory_write,
          (dut.memory_read_cpu ? dut.memory_din_cpu : 8'd0), (dut.memory_read_ppu ? dut.memory_din_ppu : 8'd0), dut.color};
    for (ti = 0; ti < 49; ti = ti + 1) tz[ti] = (tv[ti] === 1'b1);
    trace = (trace * 64'd1099511628211) ^ {15'd0, tz};
    if (^dut.color === 1'bx) xcol = xcol + 1;
    if (dut.scanline == 9'd240 && dut.cycle == 9'd0) trace_f <= trace;
  end
  initial begin
    seed = 1;
    $readmemh(`IMG, cart);
    for (k = 0; k < 262144; k = k + 1) phys[{perm(k[17:9]), k[8:0]}] = cart[k];
    wr(0, 0); wr(2, `FLAGS);
    repeat (300) @(posedge clk);                                  // MMCM lock
    wr(13, 0); for (k = 0; k < 512; k = k + 1) wr(14, BASE + perm(k));
    // probe: the FPGA reads 8 bytes itself
    errs = 0;
    for (k = 0; k < 6; k = k + 1) begin
      n = (k * 98765 * 8) % 2097152;
      rd(15, v); v2 = v;
      wr(15, n);
      while (v[0] == v2[0]) rd(15, v);
      rd(16, v); rd(17, v2);
      if ({v2, v} !== cart[n / 8]) begin errs = errs + 1; $display("FAIL probe %06x: %08x%08x want %016x", n, v2, v, cart[n / 8]); end
    end
    $display("probe: %0d of 6 wrong", errs);
    v = 0; while (!v[0]) rd(18, v);                               // tags swept
    $display("caches clean at %0t", $time); $fflush;
    wr(1, 16'h0000); wr(0, 1);                                    // run
    n = 0;
    while (n < `FRAMES) begin
      repeat (20000) @(posedge clk); rd(6, v);
      if (v[15:0] != n) begin
        n = v[15:0]; rd(19, v); rd(20, v2);
        $display("trace at the frame end %016x  x pixels so far %0d", trace_f, xcol); $display("frame %0d  misses %0d (PRG %0d)  waited %0d clocks = %0d.%02d %% of a frame  t=%0t", n, v[15:0], v[31:16],
                 v2, v2 * 100 / 357368, (v2 * 10000 / 357368) % 100, $time); $fflush;
      end
`ifdef PADAT
      if (n == `PADAT) wr(1, 16'h0008);
      if (n == `PADAT + 4) wr(1, 16'h0000);
`endif
    end
    rd(21, v); $display("DDR errors %0d", v); rd(22, v); $display("total misses %0d", v);
    wr(0, 3);                                                     // freeze at the next frame start
    v = 0; while (!v[28]) begin repeat (20000) @(posedge clk); rd(6, v); end
    repeat (400000) @(posedge clk);
    wr(4, 0); f = $fopen("sim/nes_frame.txt", "w");
    for (k = 0; k < 12288; k = k + 1) begin rd(512, v); $fdisplay(f, "%08x", v); end
    $fclose(f);
    $display("frame dumped; probe errors %0d", errs);
    $finish;
  end
endmodule
