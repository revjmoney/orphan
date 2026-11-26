`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR: hr_sha256 known answer, "abc" (FIPS 180-2) shifted in a word a clock. Run it on the RTL and on
// the synthesized netlist (sim/net_sha.sh): on 2026-11-24 the RTL passed while Yosys's SRL16E mapping of the message
// schedule hashed wrong on the board; only the netlist run catches that.
//   iverilog -g2005 -o sim/tb_sha.vvp sim/tb_sha.v hr_sha.v && vvp -n sim/tb_sha.vvp
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
module tb_sha;
    reg clk = 0; always #5 clk = ~clk;
    reg start = 0, win_we = 0; reg [31:0] win = 0;
    wire busy, done; wire [255:0] h_out;
    hr_sha256 u (.clk(clk), .start(start), .h_in(256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19),
                 .win_we(win_we), .win(win), .busy(busy), .done(done), .h_out(h_out));
    reg [511:0] blk = {32'h61626380, 448'd0, 32'h00000018};
    integer i;
    initial begin
        repeat (3) @(negedge clk);
        for (i = 0; i < 16; i = i + 1) begin win_we = 1; win = blk[511 - 32 * i -: 32]; @(negedge clk); end
        win_we = 0; start = 1; @(negedge clk); start = 0;
        wait (done); @(negedge clk);
        $display("%s sha_abc (%h)", h_out == 256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad ?
                 "ok  " : "FAIL", h_out);
        $finish;
    end
endmodule
