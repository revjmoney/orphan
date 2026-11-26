`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR: self-checking testbench for the work builder (hr_build, slots 3 and 4) against the C++ work
// model's vectors (cpp/test_work vec sim/vec). Run from lab-work/orphan_hashr:
//   iverilog -g2005 -o sim/tb_build.vvp sim/tb_build.v hr_build.v hr_sha.v && vvp -n sim/tb_build.vvp
// Prints one line per check and "PASS n/n" or "FAIL".
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
module tb_build;
    reg clk = 0, rstn = 0;
    always #5 clk = ~clk;                                   // 100 MHz
    reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
    wire [31:0] rdata;
    wire w_valid, clean;
    wire [31:0] w_word;
    reg  [3:0] w_idx = 0;
    reg  w_take = 0;
`ifdef NETLIST                                              // a synthesized netlist has no parameters
`define DUT_PARAMS
`else
`define DUT_PARAMS #(.SLOT(3))
`endif
    hr_build `DUT_PARAMS dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
                              .bus_rdata(rdata), .w_valid(w_valid), .w_idx(w_idx), .w_word(w_word), .w_take(w_take),
                              .clean(clean));

    integer pass = 0, total = 0;
    task check(input ok, input [8*64-1:0] name);
        begin total = total + 1; if (ok) pass = pass + 1; $display("%s %0s", ok ? "ok  " : "FAIL", name); end
    endtask

    task wr(input [3:0] slot, input [9:0] i, input [31:0] v);
        begin @(negedge clk); addr = {slot, i, 2'b00}; wdata = v; we = 1; @(negedge clk); we = 0; end
    endtask
    reg [31:0] rv;
    task rd(input [9:0] i);
        begin @(negedge clk); addr = {4'd3, i, 2'b00}; re = 1; @(negedge clk); re = 0; @(negedge clk); rv = rdata; end
    endtask

    reg [31:0] bank_g [0:511], bank_b [0:511], bank_p [0:511];
    reg [31:0] exp_g [0:38], exp_b [0:38], exp_p [0:25];
    task load(input [8*8-1:0] which, input b);
        integer i;
        begin
            for (i = 0; i < 512; i = i + 1)
                wr(4'd4, {b, i[8:0]}, which == "genesis" ? bank_g[i] : which == "big" ? bank_b[i] : bank_p[i]);
        end
    endtask
    // CTRL: [0] enable [1] bank [2] flip [3] clean
    task flip(input b, input cl);
        begin wr(4'd3, 10'd1, {28'd0, cl, 1'b1, b, 1'b1}); end
    endtask

    // take the ready work (waiting at most `us` microseconds); got[] holds its 13 words
    reg [31:0] got [0:12];
    reg        took;
    task take(input integer us);
        integer i, n;
        begin
            took = 0; n = 0;
            while (!w_valid && n < us * 100) begin @(negedge clk); n = n + 1; end
            if (w_valid) begin
                for (i = 0; i < 13; i = i + 1) begin w_idx = i; #1; got[i] = w_word; end
                @(negedge clk); w_take = 1; @(negedge clk); w_take = 0;
                took = 1;
            end
        end
    endtask
    function same(input integer which, input integer k);   // got[] == work k of exp_g/exp_b/exp_p
        integer i;
        begin
            same = 1;
            for (i = 0; i < 13; i = i + 1)
                if (got[i] !== (which == 0 ? exp_g[13 * k + i] : which == 1 ? exp_b[13 * k + i] : exp_p[13 * k + i]))
                    same = 0;
        end
    endfunction

    integer cleans = 0;
    always @(posedge clk) if (clean) cleans = cleans + 1;

    integer i, ok, c0, n;
    time t0, t1;
    initial begin
        $readmemh("sim/vec/genesis_bank.hex", bank_g); $readmemh("sim/vec/big_bank.hex", bank_b);
        $readmemh("sim/vec/pad_bank.hex", bank_p);
        $readmemh("sim/vec/genesis_works.hex", exp_g); $readmemh("sim/vec/big_works.hex", exp_b);
        $readmemh("sim/vec/pad_works.hex", exp_p);
        repeat (5) @(negedge clk); rstn = 1;

        // 1. genesis, bank 0
        load("genesis", 0); flip(0, 1);
        ok = 1;
        for (i = 0; i < 3; i = i + 1) begin take(200); if (!took || !same(0, i)) ok = 0; end
        rd(0); if (rv != 32'h48534231) ok = 0;
        check(ok, "genesis_works (3 works, words equal)");

        // 2. big, bank 1: 16 branches, en2 straddles bytes 63/64, en2 carries into the TAG
        load("big", 1); flip(1, 1);
        ok = 1;
        for (i = 0; i < 3; i = i + 1) begin take(400); if (!took || !same(1, i)) ok = 0; end
        check(ok, "big_works (16 branches, en2 straddle, carry into TAG)");

        // 3. pad, bank 0: padding needs a third block, EN2_SIZE 1
        load("pad", 0); flip(0, 1);
        ok = 1;
        for (i = 0; i < 2; i = i + 1) begin take(200); if (!took || !same(2, i)) ok = 0; end
        check(ok, "pad_works (extra padding block, EN2_SIZE 1)");

`ifndef NETLIST                                             // the netlist run (sim/net_build.sh) stops after 3
        // 4. pad from 0xFE: 0xFE and 0xFF, then nothing
        take(300);
        rd(2); ok = !took && rv[1] && rv[0];
        rd(4); ok = ok && rv == 1;
        check(ok, "exhaust_size1 (no third work, STATUS[1], STALLS 1)");

        // 5. clean flip with a big work ready and the next one half built: none of them is taken afterwards
        load("big", 0); flip(0, 1);
        n = 0; while (!w_valid && n < 40000) begin @(negedge clk); n = n + 1; end
        repeat (3000) @(negedge clk);                           // the next big work is now half built
        load("genesis", 1);
        c0 = cleans;
        flip(1, 1);
        ok = w_valid == 0;
        for (i = 0; i < 3; i = i + 1) begin take(200); if (!took || !same(0, i)) ok = 0; end
        check(ok && cleans == c0 + 1, "flip_mid_build (one clean pulse, only genesis works after it)");

        // 6. rate: 100 big works with w_take held high
        flip(0, 1);
        t0 = $time; n = 0;
        @(negedge clk); w_take = 1;
        while (n < 100 && $time - t0 < 64'd20_000_000) begin @(posedge clk); if (w_valid) n = n + 1; end
        t1 = $time; @(negedge clk); w_take = 0;
        $display("     100 works in %0d us (%0d us a work)", (t1 - t0) / 1000, (t1 - t0) / 100000);
        check(n == 100 && t1 - t0 < 64'd9_000_000, "rate (100 big works under 9000 us; the need is 131 us a work)");

        // 7. flip_in_sha_start: a clean flip landing in the very clock that starts a compression (S_SHA, core idle)
        //    must not leave that start behind: the next works are genesis works, word for word (bank 1 still holds
        //    genesis from test 5, bank 0 big)
        flip(0, 1);
        n = 0;
        @(negedge clk);
        while (!(dut.st == 4'd4 && !dut.sha_busy && !dut.sha_done) && n < 40000) begin @(negedge clk); n = n + 1; end
        addr = {4'd3, 10'd1, 2'b00}; wdata = {28'd0, 1'b1, 1'b1, 1'b1, 1'b1}; we = 1; @(negedge clk); we = 0;
        ok = n < 40000;
        for (i = 0; i < 3; i = i + 1) begin take(200); if (!took || !same(0, i)) ok = 0; end
        check(ok, "flip_in_sha_start (then genesis works exactly)");

`endif
        $display("%s %0d/%0d", pass == total ? "PASS" : "FAIL", pass, total);
        $finish;
    end
endmodule
