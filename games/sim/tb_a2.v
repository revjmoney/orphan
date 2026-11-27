`timescale 1ns/1ps
// Orphan Apple IIe block: upload Orphan's own test ROM + video ROM (make_a2_testrom.py) and a track of $E7 nibbles,
// run, freeze a frame and check the hi-res picture (dots at the left edge, the right edge and the middle), the
// line count, the two nibbles read from the Disk II, a key press, button 0 and the speaker.
// cd games && py -3 make_a2_testrom.py, then:
// iverilog -g2005 -o a2.vvp sim/tb_a2.v orphan_a2/orphan_a2_block.v orphan_a2/a2core_ghdl.v <ardzy_sim.v>
module tb;
  reg clk = 0; always #20 clk = ~clk;   // 25 MHz bus in the sim (faster); the console clock comes from the MMCM model
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire [7:0] level;
  orphan_a2_block #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we),
    .bus_re(re), .bus_rdata(rdata), .level(level), .hw_pads(16'd0), .hw_drive(2'd0));
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  task rd(input [9:0] i, output [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; re <= 1; @(posedge clk); re <= 0;
    @(posedge clk); v = rdata; repeat (3) @(posedge clk); end endtask
  reg [31:0] rom [0:4095];
  reg [31:0] vrom [0:2047];
  reg [31:0] fbm [0:3455];
  integer k, pass = 0, total = 0, f, r, bad, au_min, au_max, t, first;
  reg [31:0] v;
  task check(input ok, input [8*80-1:0] name); begin total = total + 1; if (ok) pass = pass + 1;
    $display("%s %0s", ok ? "ok  " : "FAIL", name); end endtask
  function dot(input integer row, input integer x); dot = fbm[row * 18 + x / 32] >> (x % 32); endfunction
  // the 14 dots of hi-res byte `col` (7 dots doubled, from dot 14 x col + sh)
  function [13:0] dcell(input integer row, input integer col, input integer sh); integer i; begin
    for (i = 0; i < 14; i = i + 1) dcell[i] = dot(row, col * 14 + i + sh); end endfunction
  function [13:0] want(input [7:0] bv); integer i; begin
    for (i = 0; i < 14; i = i + 1) want[i] = bv[i / 2]; end endfunction
  task frame_wait(input integer n); integer s; begin
    rd(6, v); s = v[15:0]; t = 0;
    while (((v[15:0] - s) & 16'hFFFF) < n && t < 4000000) begin rd(6, v); t = t + 1; end end endtask
  task grab; begin
    frame_wait(1);
    wr(0, 3); v = 0; while (!v[28]) rd(6, v);
    wr(4, 0); for (k = 0; k < 3456; k = k + 1) begin rd(512, v); fbm[k] = v; end
    wr(0, 1); end endtask
  initial begin
    $readmemh("sim/a2_rom.hex", rom);
    $readmemh("sim/a2_vrom.hex", vrom);
    wr(0, 0);
    repeat (200) @(posedge clk);                          // MMCM lock (1 us in the model)
    wr(3, 32'h20000); for (k = 0; k < 4096; k = k + 1) wr(512, rom[k]);
    wr(3, 32'h24000); for (k = 0; k < 2048; k = k + 1) wr(512, vrom[k]);
    wr(3, 32'h28000); for (k = 0; k < 1664; k = k + 1) wr(512, 32'hE7E7E7E7);
    rd(3, v); check(v == 32'h28000 + 4 * 1664, "upload address moved by 4 per word");
    rd(7, v); check(v == 32'h41324531, "ID reads A2E1");
    wr(12, 1 | (17 << 8));                                // a disk in drive 1, track 17 loaded (the head starts there)
    wr(0, 1);
    frame_wait(3);
    rd(15, v); $display("lines per frame %0d", v[8:0]); check(v[8:0] == 262, "262 lines per frame");
    frame_wait(3);                                        // the ROM fills hi-res memory (~2 frames)
    grab;
    f = $fopen("sim/a2_frame.hex", "w"); for (k = 0; k < 3456; k = k + 1) $fwrite(f, "%08x\n", fbm[k]); $fclose(f);
    first = -1; for (k = 559; k >= 0; k = k - 1) if (dot(40, k)) first = k;
    $display("row 40: first lit dot %0d", first);
    $write("row 40 dots 0..31: "); for (k = 0; k < 32; k = k + 1) $write("%0d", dot(40, k)); $display("");
    $write("row 40 dots 528..559: "); for (k = 528; k < 560; k = k + 1) $write("%0d", dot(40, k)); $display("");
    bad = 0; for (r = 0; r < 192; r = r + 7) if (dcell(r, 0, 0) != want(8'h01)) bad = bad + 1;
    check(bad == 0, "byte 0 = $01: dots 0-1 lit, every line");
    bad = 0; for (r = 0; r < 192; r = r + 7) if (dcell(r, 39, 0) != want(8'h40)) bad = bad + 1;
    check(bad == 0, "byte 39 = $40: dots 558-559 lit (the right edge)");
    bad = 0; for (r = 3; r < 192; r = r + 7) if (dcell(r, 20, 0) != want(8'h55)) bad = bad + 1;
    check(bad == 0, "byte 20 = $55: four dots");
    bad = 0; for (r = 1; r < 192; r = r + 5) for (k = 1; k < 39; k = k + 1) if (k != 20 && !(r == 2 && (k == 5 || k == 6)) && dcell(r, k, 0) != 0) bad = bad + 1;
    check(bad == 0, "the other bytes are dark");
    check(fbm[17] >> 31, "hi-res lines are colour lines");
    $display("disk nibbles at line 2: %b %b", dcell(2, 5, 0), dcell(2, 6, 0));
    check(dcell(2, 5, 0) == want(8'h67) && dcell(2, 6, 0) == want(8'h67), "two $E7 nibbles read from the Disk II track");
    rd(12, v); $display("disk register %h", v); check(v[8] && v[5:0] == 17, "drive 1 motor on, head on track 17");
    wr(2, (1 << 9) | (1 << 8) | 8'h41);                   // press 'A'
    wr(1, 1);                                             // button 0 (A)
    frame_wait(3); wr(2, (1 << 9) | 8'h41);           // key up (the toggle stays)
    grab;
    $display("line 0 byte 10: %b  byte 12: %b", dcell(0, 10, 0), dcell(0, 12, 0));
    check(dcell(0, 10, 0) == want(8'h41), "the key ('A' = $C1) landed at line 0 byte 10");
    check(dcell(0, 12, 0) == want(8'h7F), "button 0 held: line 0 byte 12 = $7F");
    rd(2, v); check(v[7] == 0, "the program cleared the keyboard strobe");
    wr(1, 0); frame_wait(3); grab;
    check(dcell(0, 12, 0) == 0, "button 0 released: byte 12 dark again");
    rd(6, v); wr(5, (v[27:16] - 400) & 11'h7FF); au_min = 32767; au_max = -32768;
    for (k = 0; k < 400; k = k + 1) begin rd(768, v); if ($signed(v[15:0]) < au_min) au_min = $signed(v[15:0]);
      if ($signed(v[15:0]) > au_max) au_max = $signed(v[15:0]); end
    $display("audio %0d .. %0d", au_min, au_max);
    check(au_max - au_min > 10000, "speaker clicks: samples swing");
    $display("%s %0d/%0d", pass == total ? "PASS" : "FAIL", pass, total);
    $finish;
  end
  always @(dut.frames) begin $display("frame %0d at %0t us, lines %0d", dut.frames, $time / 1000, dut.lines); $fflush; end
  initial begin #2000000000; $display("FAIL timeout"); $finish; end
endmodule
