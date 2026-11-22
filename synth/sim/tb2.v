`timescale 1ns/1ps
module tb;
  reg clk = 0; always #5 clk = ~clk;
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire mclk, bclk, lrclk, dout;
  orphan_synth #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
    .bus_rdata(rdata), .mclk(mclk), .bclk(bclk), .lrclk(lrclk), .dout(dout));
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  integer k; integer mn, mx;
  initial begin
    wr(0, 7); wr(1, 2); wr(2, 3000000); wr(3, 4000); wr(4, 45000); wr(5, 3000); wr(6, 204); wr(7, 3500); wr(8, 46858);
    wr(16, 19327353); wr(17, 0); wr(17, 1);
    mn = 99999; mx = -99999;
    for (k = 0; k < 1500; k = k + 1) begin
      repeat (2048) @(posedge clk);
      if (k > 1000) begin if ($signed(dut.mix_out) < mn) mn = $signed(dut.mix_out); if ($signed(dut.mix_out) > mx) mx = $signed(dut.mix_out); end
      if (k % 300 == 0) $display("frame %0d env=%0d f_in=%0d f_low=%0d f_band=%0d f_high=%0d mix=%0d", k, dut.env[0], $signed(dut.f_in), $signed(dut.f_low), $signed(dut.f_band), $signed(dut.f_high), $signed(dut.mix_out));
    end
    $display("frames 1000-1500: mix min %0d max %0d", mn, mx);
    $finish;
  end
endmodule
