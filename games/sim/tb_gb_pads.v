`timescale 1ns/1ps
// Orphan GB block: real NES pad registers (9 HWPADS, 10 HWPADS2, 11 HWNEVER, 12 CPUSTATE) and that the Game Boy's
// keypad sees browser PADS | real pad 1 | real pad 2.
//   (in games/sim) iverilog -g2012 -o tb_gb_pads.vvp tb_gb_pads.v <every orphan_gb/*.v except top, orphan_leds, orphan_fan,
//   orphan_nespad> <ardzy>/pc_app/fpga/simlib/ardzy_sim.v && vvp -n tb_gb_pads.vvp   (20 checks)
module tb;
  reg clk = 0; always #20 clk = ~clk;
  reg rstn = 1; reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
  wire [31:0] rdata; wire [7:0] level;
  reg  [15:0] hw_pads = 16'd0; reg [1:0] hw_drive = 2'b00;
  wire hw_en; wire [3:0] p1, p2; wire [8:0] never;
  orphan_gb_block #(.SLOT(1)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we),
    .bus_re(re), .bus_rdata(rdata), .level(level), .hw_pads(hw_pads), .hw_drive(hw_drive), .hw_enable(hw_en),
    .hw_port1(p1), .hw_port2(p2), .hw_never(never));
  task wr(input [9:0] i, input [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; wdata <= v; we <= 1; @(posedge clk); we <= 0; end endtask
  task rd(input [9:0] i, output [31:0] v); begin @(posedge clk); addr <= {4'd1, i, 2'b00}; re <= 1; @(posedge clk); re <= 0;
    @(posedge clk); v = rdata; repeat (3) @(posedge clk); end endtask
  integer fails = 0, checks = 0;
  task check(input [255:0] what, input [31:0] got, input [31:0] want); begin
    checks = checks + 1;
    if (got !== want) begin fails = fails + 1; $display("FAIL %0s: got %h want %h", what, got, want); end
    else $display("ok   %0s = %h", what, got);
  end endtask
  task settle; repeat (400) @(posedge clk); endtask              // a few Game Boy clocks for the crossing
  reg [31:0] v;
  initial begin
    repeat (200) @(posedge clk);
    rd(10, v); check("HWPADS2 after load (J1, J2)", v, 32'h21);
    rd(9, v);  check("HWPADS after load (off)", v, 32'h0);
    check("enable out", hw_en, 0);
    wr(9, 32'h871); rd(9, v); check("HWPADS enable", v[24], 1); rd(10, v); check("ports J7, J8", v, 32'h87);
    wr(9, 32'hF01); rd(10, v); check("bad ports fall back to J1, J2", v, 32'h21);
    wr(9, 32'h000); rd(9, v); check("HWPADS disable", v[24], 0);
    wr(11, 32'h020); rd(11, v); check("HWNEVER J6", v, 32'h020); check("never out", never, 9'h020);
    rd(12, v); check("CPUSTATE at 12, top bits 0", v[31:2], 0);
    rd(7, v); check("ID", v, 32'h47423031);

    // keypad: key[7:4] = {Down, Up, Left, Right}, key[3:0] = {Start, Select, B, A}
    hw_pads = 16'h0001; hw_drive = 2'b01; settle; check("pad 1 A -> key A", dut.key, 8'h01);
    rd(9, v); check("HWPADS read buttons + drive", v[17:0], {2'b01, 16'h0001});
    hw_pads = 16'h0800; settle; check("pad 2 Start -> key Start", dut.key, 8'h08);
    hw_pads = 16'h0010; settle; check("pad 1 Up -> key Up", dut.key, 8'h40);
    hw_pads = 16'h8000; settle; check("pad 2 Right -> key Right", dut.key, 8'h10);
    hw_pads = 16'h0020; wr(1, 32'h40); settle; check("pad 1 Down | browser Left", dut.key, 8'hA0);
    hw_pads = 16'h0000; wr(1, 32'h00); settle; check("all released", dut.key, 8'h00);

    rstn = 0; repeat (3) @(posedge clk); rstn = 1; rd(11, v); check("HWNEVER after reset", v, 0); rd(10, v); check("ports after reset", v, 32'h21);
    $display("%0d of %0d checks passed", checks - fails, checks);
    $finish;
  end
endmodule
