`timescale 1ns/1ps
// Orphan NES block: load a ROM through the bus, run it, freeze a frame and dump the picture + some sound.
// +define+FLAGS=<hex> +define+PRGW=<words> +define+CHRW=<words> +define+FRAMES=<n>
module tb;
  reg clk = 0; always #20 clk = ~clk;   // 25 MHz bus in the sim (faster); the console clock comes from the MMCM model
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire [7:0] level;
  orphan_gb_block #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we),
    .bus_re(re), .bus_rdata(rdata), .level(level), .hw_pads(16'd0), .hw_drive(2'd0));
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  task rd(input [9:0] i, output [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; re <= 1; @(posedge clk); re <= 0;
    @(posedge clk); v = rdata; repeat (3) @(posedge clk); end endtask
  reg [31:0] prg [0:32767];
  integer k, f, n, sent; reg [31:0] v;
  task up(input [31:0] w); begin
    wr(512, w); sent = sent + 1;
    v = 0; while (v[15:0] != sent[15:0]) rd(3, v);          // wait for the console side to take it
  end endtask
  initial begin
    $readmemh("sim/gb_rom.hex", prg);
    wr(0, 0); wr(2, `FLAGS); sent = 0;
    rd(3, v); sent = v[15:0];
    repeat (200) @(posedge clk);                                  // MMCM lock (1 us in the model)
    wr(3, 32'h00000); for (k = 0; k < `PRGW; k = k + 1) begin up(prg[k]); if (k % 2048 == 0) begin $display("upload %0d at %0t", k, $time); $fflush; end end

    $display("cart loaded: %0d words at %0t", sent, $time); $fflush;
    wr(1, 16'h0000); wr(0, 1);                                    // run
    n = 0;
    while (n < `FRAMES) begin
      repeat (5000) @(posedge clk); rd(6, v);
      if (v[15:0] != n) begin n = v[15:0]; $display("frame %0d  audio words %0d  level %0d  t=%0t", n, v[27:16], level, $time); $fflush; end
      if (n == `FRAMES - 12) wr(1, 16'h0008);                     // press Start for a while
      if (n == `FRAMES - 8) wr(1, 16'h0000);
    end
    wr(0, 3);                                                     // freeze at the next frame start
    v = 0; while (!v[28]) begin repeat (5000) @(posedge clk); rd(6, v); end
    repeat (1000) @(posedge clk);                               // let that frame be written fully... it is frozen
    wr(4, 0); f = $fopen("sim/gb_frame.txt", "w");
    for (k = 0; k < 1440; k = k + 1) begin rd(512, v); $fdisplay(f, "%08x", v); end
    $fclose(f);
    wr(5, 0); f = $fopen("sim/gb_audio.txt", "w");
    for (k = 0; k < 2048; k = k + 1) begin rd(768, v); $fdisplay(f, "%08x", v); end
    $fclose(f);
    $display("frame + audio dumped");
    $finish;
  end
endmodule
