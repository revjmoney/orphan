`timescale 1ns/1ps
// Orphan Atari 2600 block: load Orphan's test cart through the bus, run it, freeze a frame and check the picture
// (colour bars that step by one per line), the line count, fire on joystick 1 and the sound.
// cd games && py -3 make_a26_testrom.py && py -3 -c "..." (sim/a26_rom.hex: 1024 words) then:
// iverilog -g2012 -o a26.vvp sim/tb_a26.v orphan_a26/orphan_a26_block.v orphan_a26/A2601top_ghdl.v <ardzy_sim.v>
module tb;
  reg clk = 0; always #20 clk = ~clk;   // 25 MHz bus in the sim (faster); the console clock comes from the MMCM model
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire [7:0] level;
  orphan_a26_block #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we),
    .bus_re(re), .bus_rdata(rdata), .level(level), .hw_pads(16'd0), .hw_drive(2'd0));
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  task rd(input [9:0] i, output [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; re <= 1; @(posedge clk); re <= 0;
    @(posedge clk); v = rdata; repeat (3) @(posedge clk); end endtask
  reg [31:0] rom [0:1023];
  reg [31:0] fbm [0:9599];
  integer k, sent, pass = 0, total = 0, f, r, bad, au_min, au_max, t;
  reg [31:0] v;
  reg [7:0] c, c0, c1;
  task check(input ok, input [8*80-1:0] name); begin total = total + 1; if (ok) pass = pass + 1;
    $display("%s %0s", ok ? "ok  " : "FAIL", name); end endtask
  function [7:0] px(input integer row, input integer x); px = fbm[row * 40 + x / 4] >> (8 * (x % 4)); endfunction
  task frame_wait(input integer n); integer s; begin
    rd(6, v); s = v[15:0]; t = 0;
    while (((v[15:0] - s) & 16'hFFFF) < n && t < 4000000) begin rd(6, v); t = t + 1; end end endtask
  task grab; begin
    frame_wait(1);
    wr(0, 3); v = 0; while (!v[28]) rd(6, v);             // freeze at the next frame end, wait until it is held
    wr(4, 0); for (k = 0; k < 9600; k = k + 1) begin rd(512, v); fbm[k] = v; end
    wr(0, 1); end endtask
  initial begin
    $readmemh("sim/a26_rom.hex", rom);
    wr(0, 0); wr(2, (32'd4096 << 8)); sent = 0;
    rd(3, v); sent = v[15:0];
    repeat (200) @(posedge clk);                          // MMCM lock (1 us in the model)
    wr(3, 0);
    for (k = 0; k < 1024; k = k + 1) begin wr(512, rom[k]); sent = sent + 1; v = 0; while (v[15:0] != sent[15:0]) rd(3, v); end
    $display("uploaded at %0t", $time);
    rd(7, v); check(v == 32'h41323631, "ID reads A261");
    wr(0, 1);
    frame_wait(3);
    rd(15, v); $display("lines per frame %0d", v[8:0]); check(v[8:0] == 262, "262 lines per frame");
    grab;
    f = $fopen("sim/a26_frame.hex", "w"); for (k = 0; k < 9600; k = k + 1) $fwrite(f, "%08x\n", fbm[k]); $fclose(f);
    // rows 0..9 are VSYNC / VBLANK (black), the bars start on row 10 (line 40) and run 192 rows
    bad = 0; for (r = 0; r < 9; r = r + 1) if (px(r, 80) != 0) bad = bad + 1;
    check(bad == 0, "top rows (vertical blank) are black");
    c0 = px(12, 80); bad = 0;
    for (r = 12; r < 200; r = r + 1) begin c = px(r, 80); if (c != ((c0 + r - 12) & 8'h7F)) bad = bad + 1; end
    $display("row 12 colour %0d, rows off %0d", c0, bad);
    check(bad == 0, "bars: colour + 1 per line, rows 12..199");
    bad = 0; for (r = 20; r < 200; r = r + 20) for (k = 8; k < 160; k = k + 13) if (px(r, k) != px(r, 80)) bad = bad + 1;
    check(bad == 0, "a whole line is one colour (x 8..159)");
    bad = 0; for (r = 20; r < 200; r = r + 20) if (px(r, 159) != px(r, 80) || px(r, 156) != px(r, 80)) bad = bad + 1;
    check(bad == 0, "the right edge (x 156..159) is drawn too");
    $write("row 20 x 0..7:"); for (k = 0; k < 8; k = k + 1) $write(" %0d", px(20, k));
    $write("  x 150..159:"); for (k = 150; k < 160; k = k + 1) $write(" %0d", px(20, k)); $display("  (x 80: %0d)", px(20, 80));
    $display("aud0 %b aud1 %b acc %h mix %h", dut.aud0, dut.aud1, dut.acc, dut.mix);
    bad = 0; for (r = 206; r < 240; r = r + 1) if (px(r, 80) != 0) bad = bad + 1;
    check(bad == 0, "rows after the 192 bars (overscan) are black");
    grab; c1 = px(12, 80); check(c1 == c0, "no fire: the bars stand still");
    wr(1, 1);                                             // A = fire on joystick 1
    frame_wait(4);
    grab; c1 = px(12, 80); $display("with fire row 12 colour %0d (was %0d)", c1, c0);
    check(c1 != c0, "fire held: the bars move");
    wr(1, 0);
    // sound: the tone makes the samples swing
    rd(6, v); wr(5, (v[27:16] - 400) & 11'h7FF); au_min = 32767; au_max = -32768;
    for (k = 0; k < 400; k = k + 1) begin rd(768, v); if ($signed(v[15:0]) < au_min) au_min = $signed(v[15:0]);
      if ($signed(v[15:0]) > au_max) au_max = $signed(v[15:0]); end
    $display("audio %0d .. %0d", au_min, au_max);
    check(au_max - au_min > 3000, "tone on channel 0: samples swing");
    $display("%s %0d/%0d", pass == total ? "PASS" : "FAIL", pass, total);
    $finish;
  end
  always @(dut.frames) begin $display("frame %0d at %0t us, lines %0d", dut.frames, $time / 1000000, dut.lines); $fflush; end
  initial begin #2000000000; $display("FAIL timeout"); $finish; end
endmodule
