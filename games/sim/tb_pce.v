`timescale 1ns/1ps
// Orphan PC Engine block: Orphan's own test HuCard (make_pce_testrom.py) in a model of the DDR (its two 4 KB pages
// scrambled, random delays on HP2), the page table, the probe, then run: the picture is VCE colour 0 ($0AB), $1C7
// while button I is held, the PSG plays, and the cache misses come and stop. Then the frame DMA (CTRL[2]): every
// finished picture is written over HP3 into two OCM slots (an AXI write model with random delays), word for word
// the frame buffer, inside the vertical blank.
// cd games && py -3 make_pce_testrom.py, then:
// iverilog -g2005 -o pce.vvp sim/tb_pce.v orphan_pce/orphan_pce_block.v orphan_pce/pce_top_ghdl.v <ardzy_sim.v>
module tb;
  reg clk = 0; always #5 clk = ~clk;
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire [7:0] level;
  wire hp_clk, hp_arvalid, hp_rready; wire [31:0] hp_araddr; wire [3:0] hp_arlen;
  reg  hp_arready = 0, hp_rvalid = 0, hp_rlast = 0; reg [63:0] hp_rdata = 0; reg [1:0] hp_rresp = 0;
  orphan_pce_block #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we),
    .bus_re(re), .bus_rdata(rdata), .level(level), .hw_pads(16'd0), .hw_drive(2'd0), .hw_enable(), .hw_port1(),
    .hw_port2(), .hw_never(),
    .hp_clk(hp_clk), .hp_araddr(hp_araddr), .hp_arlen(hp_arlen), .hp_arvalid(hp_arvalid), .hp_arready(hp_arready),
    .hp_rdata(hp_rdata), .hp_rvalid(hp_rvalid), .hp_rlast(hp_rlast), .hp_rresp(hp_rresp), .hp_rready(hp_rready),
    .hpw_awaddr(w_awaddr), .hpw_awlen(w_awlen), .hpw_awvalid(w_awvalid), .hpw_awready(w_awready), .hpw_wdata(w_wdata),
    .hpw_wlast(w_wlast), .hpw_wvalid(w_wvalid), .hpw_wready(w_wready), .hpw_bresp(w_bresp), .hpw_bvalid(w_bvalid),
    .hpw_bready(w_bready));
  // ---- the OCM behind HP3 (192 KB at FFFC0000), clocked by clk: AW, then 16 W beats, then B, each after random waits
  wire [31:0] w_awaddr; wire [3:0] w_awlen; wire w_awvalid, w_wlast, w_wvalid, w_bready; wire [63:0] w_wdata;
  reg w_awready = 0, w_wready = 0, w_bvalid = 0; reg [1:0] w_bresp = 0;
  reg [63:0] ocm [0:24575];
  integer wl, wbeats, wseed = 11, writes = 0, badlast = 0; reg [31:0] wa;
  always @(posedge clk) begin
    if (w_awvalid && !w_awready) begin
      wl = $urandom(wseed) % 6; repeat (wl) @(posedge clk);
      w_awready <= 1; wa = w_awaddr; wbeats = w_awlen + 1; @(posedge clk); w_awready <= 0;
      while (wbeats > 0) begin
        wl = $urandom(wseed) % 3; repeat (wl) @(posedge clk);
        w_wready <= 1; @(posedge clk);
        while (!w_wvalid) @(posedge clk);
        if (wa[31:18] == 14'h3FFF && wa[17:3] < 24576) ocm[wa[17:3]] = w_wdata; writes = writes + 1;
        if (w_wlast !== (wbeats == 1)) badlast = badlast + 1;
        w_wready <= 0; wa = wa + 8; wbeats = wbeats - 1;
      end
      wl = 2 + $urandom(wseed) % 20; repeat (wl) @(posedge clk);
      w_bresp <= (wa[31:18] == 14'h3FFF) ? 2'b00 : 2'b10; w_bvalid <= 1; @(posedge clk); while (!w_bready) @(posedge clk); w_bvalid <= 0;
    end
  end
  function [31:0] ow(input integer slot, input integer k); reg [63:0] q; begin
    q = ocm[slot * 12288 + k / 2]; ow = k % 2 ? q[63:32] : q[31:0]; end endfunction
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  task rd(input [9:0] i, output [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; re <= 1; @(posedge clk); re <= 0;
    @(posedge clk); v = rdata; repeat (3) @(posedge clk); end endtask

  // ---- the DDR: the card's page 0 at physical page BASE + 5, page 1 at BASE + 2; every other page -> BASE + 7 (zero)
  localparam [19:0] BASE = 20'h1A000;
  reg [63:0] rom [0:1023];
  reg [63:0] phys [0:4095];                               // 8 physical pages x 512 words
  integer k, pass = 0, total = 0, t, bad, au_min, au_max, seed = 7;
  reg [31:0] v, v2;
  integer lat, gap, beats; reg [31:0] a; reg busy = 0;
  always @(posedge hp_clk) begin
    if (!busy && hp_arvalid && !hp_arready) begin
      lat = $urandom(seed) % 8; repeat (lat) @(posedge hp_clk);
      hp_arready <= 1; a = hp_araddr; beats = hp_arlen + 1; busy = 1;
      @(posedge hp_clk); hp_arready <= 0;
      lat = 4 + $urandom(seed) % 37; repeat (lat) @(posedge hp_clk);
      while (beats > 0) begin
        if (a[31:12] < BASE || a[31:12] >= BASE + 8) begin hp_rresp <= 2'b10; hp_rdata <= 64'hDEAD; end
        else begin hp_rresp <= 2'b00; hp_rdata <= phys[{a[14:12] - BASE[2:0], a[11:3]}]; end
        hp_rvalid <= 1; hp_rlast <= (beats == 1);
        @(posedge hp_clk); hp_rvalid <= 0; hp_rlast <= 0;
        a = a + 8; beats = beats - 1;
        gap = $urandom(seed) % 4; if (beats > 0) repeat (gap) @(posedge hp_clk);
      end
      busy = 0;
    end
  end

  task check(input ok, input [8*80-1:0] name); begin total = total + 1; if (ok) pass = pass + 1;
    $display("%s %0s", ok ? "ok  " : "FAIL", name); end endtask
  reg [26:0] fbm [0:20639];
  function [8:0] px(input integer row, input integer x); px = fbm[row * 86 + x / 3] >> (9 * (x % 3)); endfunction
  task frame_wait(input integer n); integer s; begin
    rd(6, v); s = v[15:0]; t = 0;
    while (((v[15:0] - s) & 16'hFFFF) < n && t < 4000000) begin rd(6, v); t = t + 1; end end endtask
  task grab; begin
    frame_wait(1);
    wr(0, 3); v = 0; while (!v[28]) rd(6, v);
    wr(4, 0); for (k = 0; k < 20640; k = k + 1) begin rd(512, v); fbm[k] = v[26:0]; end
    wr(0, 1); end endtask
  integer row, cnt;
  initial begin
    $readmemh("sim/pce_rom.hex", rom);
    for (k = 0; k < 4096; k = k + 1) phys[k] = 64'd0;
    for (k = 0; k < 512; k = k + 1) begin phys[5 * 512 + k] = rom[k]; phys[2 * 512 + k] = rom[512 + k]; end
    wr(0, 0);
    repeat (300) @(posedge clk);
    wr(13, 0); wr(14, BASE + 5); wr(14, BASE + 2); for (k = 2; k < 1024; k = k + 1) wr(14, BASE + 7);
    rd(7, v); check(v == 32'h50434531, "ID reads PCE1");
    rd(15, v2); wr(15, 32'h1FF8); v = v2; t = 0; while (v[0] == v2[0] && t < 1000) begin rd(15, v); t = t + 1; end
    rd(16, v); rd(17, v2);
    $display("probe at $1FF8: %h%h (want %h)", v2, v, rom[1023]);
    check({v2, v} == rom[1023], "probe: the FPGA reads the vectors back from the DDR");
    t = 0; v = 0; while (!v[0] && t < 5000) begin rd(18, v); t = t + 1; end
    check(v[0], "cache tags cleared while held");
    wr(2, 2);                                             // 8 KB card
    wr(0, 1);
    frame_wait(4);
    rd(12, v); $display("shape: %0d dots a line, %0d lines", v[9:0], v[25:16]);
    check(v[9:0] == 270, "270 dots a line (5.37 MHz dots)");
    grab;
    $display("dots (row 100): %h %h %h ... %h", px(100, 0), px(100, 1), px(100, 128), px(100, 255));
    bad = 0; cnt = 0;
    for (row = 20; row < 220; row = row + 10) for (k = 0; k < 256; k = k + 17) begin cnt = cnt + 1; if (px(row, k) !== 9'h0AB) bad = bad + 1; end
    $display("%0d of %0d dots are $0AB", cnt - bad, cnt);
    check(bad == 0, "the picture is VCE colour 0 = $0AB");
    rd(19, v); $display("misses last frame %0d, wait clocks %0d, total misses %0d", v[15:0], 0, 0);
    rd(20, v2); rd(22, v); $display("wait clocks last frame %0d, total misses %0d", v2, v);
    check(v > 0 && v < 400, "the card came in through the cache (a few line misses)");
    rd(21, v); check(v == 0, "no DDR read errors");
    wr(1, 1);                                             // A = button I
    frame_wait(3); grab;
    $display("button I: dot %h", px(100, 128));
    check(px(100, 128) === 9'h1C7, "button I held: colour 0 = $1C7");
    wr(1, 0); frame_wait(3); grab;
    check(px(100, 128) === 9'h0AB, "button I released: back to $0AB");
    rd(6, v); wr(5, (v[27:16] - 400) & 11'h7FF); au_min = 32767; au_max = -32768;
    for (k = 0; k < 400; k = k + 1) begin rd(768, v); if ($signed(v[15:0]) < au_min) au_min = $signed(v[15:0]);
      if ($signed(v[15:0]) > au_max) au_max = $signed(v[15:0]); end
    $display("audio %0d .. %0d", au_min, au_max);
    check(au_max - au_min > 1000, "PSG channel 0 square wave: samples swing");
    // ---- the frame DMA into the OCM
    check(writes == 0, "no OCM writes while the DMA is off");
    for (k = 0; k < 24576; k = k + 1) ocm[k] = 64'hDEADBEEFDEADBEEF;
    grab;                                                 // the frame buffer through the registers
    wr(23, 32'hFFFC0000); wr(24, 32'hFFFD8000);
    rd(23, v); rd(24, v2); check(v == 32'hFFFC0000 && v2 == 32'hFFFD8000, "slot addresses read back");
    rd(25, v2); wr(0, 5); frame_wait(3); rd(25, v);
    $display("dma: %0d copies, last slot %0d, errors %0d, busy %0d", v[15:0] - v2[15:0], v[16], v[31:24], v[17]);
    check(v[15:0] - v2[15:0] >= 2, "a copy every frame");
    check(v[31:24] == 0 && badlast == 0, "no write errors, WLAST on the 16th beat");
    rd(26, v2); $display("dma: %0d clocks for one frame (%0d us)", v2, v2 / 100);
    check(v2 > 0 && v2 < 100000, "a copy takes under 1 ms (the vertical blank is 1.4 ms)");
    // the picture changes a little from frame to frame: one of the two copies is of the frame grabbed just before
    bad = 0; for (k = 0; k < 20640; k = k + 1) if (ow(0, k) !== {5'd0, fbm[k]}) bad = bad + 1;
    cnt = 0; for (k = 0; k < 20640; k = k + 1) if (ow(1, k) !== {5'd0, fbm[k]}) cnt = cnt + 1;
    $display("words that differ from the grabbed frame: slot 0 %0d, slot 1 %0d", bad, cnt);
    check(bad == 0 || cnt == 0, "an OCM slot holds the grabbed frame word for word");
    check(bad < 400 && cnt < 400, "both slots hold whole pictures (copies alternate)");
    wr(1, 1); frame_wait(3); rd(25, v);
    check(((ow(v[16], 100 * 86 + 42) >> 18) & 32'h1FF) == 32'h1C7, "button I shows in the DMA picture (dot 128 of row 100)");
    wr(1, 0); wr(0, 1); frame_wait(1); v2 = writes; frame_wait(2);
    check(writes == v2, "CTRL[2] off: the copies stop");
    $display("%s %0d/%0d", pass == total ? "PASS" : "FAIL", pass, total);
    $finish;
  end
  always @(dut.frames) begin $display("frame %0d at %0t us", dut.frames, $time / 1000); $fflush; end
  initial begin #2000000000; $display("FAIL timeout"); $finish; end
endmodule
