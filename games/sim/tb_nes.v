`timescale 1ns/1ps
// Orphan NES block: load a ROM through the bus, run it, freeze a frame and dump the picture + some sound.
// +define+FLAGS=<hex> +define+PRGW=<words> +define+CHRW=<words> +define+FRAMES=<n>
module tb;
  reg clk = 0; always #5 clk = ~clk;
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire [7:0] level;
  orphan_nes_block #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we),
    .bus_re(re), .bus_rdata(rdata), .level(level), .hw_pads(16'd0), .hw_drive(2'd0), .hw_enable(), .hw_port1(), .hw_port2(), .hw_never());
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  task rd(input [9:0] i, output [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; re <= 1; @(posedge clk); re <= 0;
    @(posedge clk); v = rdata; repeat (3) @(posedge clk); end endtask
  reg [31:0] prg [0:16383]; reg [31:0] chr [0:8191];
  integer k, f, n, sent; reg [31:0] v;
  task up(input [31:0] w); begin
    wr(512, w); sent = sent + 1;
    v = 0; while (v[15:0] != sent[15:0]) rd(3, v);          // wait for the console side to take it
  end endtask

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
    $readmemh("sim/rom_prg.hex", prg); $readmemh("sim/rom_chr.hex", chr);
    wr(0, 0); wr(2, `FLAGS); sent = 0;
    rd(3, v); sent = v[15:0];
    repeat (200) @(posedge clk);                                  // MMCM lock (1 us in the model)
    wr(3, 32'h00000); for (k = 0; k < `PRGW; k = k + 1) begin up(prg[k]); if (k % 2048 == 0) begin $display("upload %0d at %0t", k, $time); $fflush; end end
    if (`CHRW > 0) begin wr(3, 32'h10000); for (k = 0; k < `CHRW; k = k + 1) up(chr[k]); end
    $display("cart loaded: %0d words at %0t", sent, $time); $fflush;
    wr(1, 16'h0000); wr(0, 1);                                    // run
    n = 0;
    while (n < `FRAMES) begin
      repeat (20000) @(posedge clk); rd(6, v);
      if (v[15:0] != n) begin n = v[15:0]; $display("trace at the frame end %016x  x pixels so far %0d", trace_f, xcol); $display("frame %0d  audio words %0d  level %0d  t=%0t", n, v[27:16], level, $time); $fflush; end
      if (n == `FRAMES - 12) wr(1, 16'h0008);                     // press Start for a while
      if (n == `FRAMES - 8) wr(1, 16'h0000);
    end
    wr(0, 3);                                                     // freeze at the next frame start
    v = 0; while (!v[28]) begin repeat (20000) @(posedge clk); rd(6, v); end
    repeat (400000) @(posedge clk);                               // let that frame be written fully... it is frozen
    wr(4, 0); f = $fopen("sim/nes_frame.txt", "w");
    for (k = 0; k < 12288; k = k + 1) begin rd(512, v); $fdisplay(f, "%08x", v); end
    $fclose(f);
    wr(5, 0); f = $fopen("sim/nes_audio.txt", "w");
    for (k = 0; k < 2048; k = k + 1) begin rd(768, v); $fdisplay(f, "%08x", v); end
    $fclose(f);
    $display("frame + audio dumped");
    $finish;
  end
endmodule
