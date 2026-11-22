`timescale 1ns/1ps
module tb;
  reg clk = 0; always #5 clk = ~clk;
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire mclk, bclk, lrclk, dout;
  orphan_synth #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
    .bus_rdata(rdata), .mclk(mclk), .bclk(bclk), .lrclk(lrclk), .dout(dout));
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  integer k;
  initial begin
    wr(0, 7); wr(1, 2); wr(2, 34379); wr(3, 1000); wr(4, 45000); wr(5, 3000); wr(6, 200); wr(7, 20000); wr(8, 40000);
    wr(16, 38654706); wr(17, 0); wr(17, 1);
    for (k = 0; k < 40; k = k + 1) begin
      repeat (2048) @(posedge clk);
      $display("frame %0d st=%0d env=%0d ph=%h osc=%0d prod=%0d acc=%0d f_in=%0d f_low=%0d mix=%0d", k, dut.st[0], dut.env[0], dut.ph, dut.osc, dut.prod, dut.acc, dut.f_in, dut.f_low, dut.mix_out);
    end
    $finish;
  end
endmodule
