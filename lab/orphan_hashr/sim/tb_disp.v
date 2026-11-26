`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR: self-checking testbench for the dispatcher (hr_disp + hr_chain, chains 0 and 1) and the work
// builder feeding it (hr_build). Run from lab-work/orphan_hashr:
//   iverilog -g2005 -o sim/tb_disp.vvp sim/tb_disp.v hr_disp.v hr_chain.v hr_crc.v hr_uart.v hr_build.v hr_sha.v
//   vvp -n sim/tb_disp.vvp
// Prints one line per check and "PASS n/n" or "FAIL".
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
module tb_disp;
    reg clk = 0, rstn = 0;
    always #5 clk = ~clk;                                   // 100 MHz
    reg [15:0] addr = 0; reg [31:0] wdata = 0; reg we = 0, re = 0;
    wire [31:0] rdata, rd_disp, rd_build;
    assign rdata = rd_disp | rd_build;
    wire bw_valid, b_take, b_clean; wire [3:0] b_idx; wire [31:0] b_word;
    wire [8:0] tx;
    reg  [8:0] rx = 9'h1FF;
    wire inj_line;
    hr_disp #(.SLOT(2)) dut (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
                             .bus_rdata(rd_disp), .tx_line(tx), .rx_line({rx[8:6], inj_line, rx[4:0]}),
                             .w_valid(bw_valid), .w_idx(b_idx), .w_word(b_word), .w_take(b_take), .clean(b_clean));
    hr_build #(.SLOT(3)) bld (.clk(clk), .rstn(rstn), .bus_addr(addr), .bus_wdata(wdata), .bus_we(we), .bus_re(re),
                              .bus_rdata(rd_build), .w_valid(bw_valid), .w_idx(b_idx), .w_word(b_word),
                              .w_take(b_take), .clean(b_clean));
    localparam B1 = 64 + 32 * 6;                       // chain 6 (J7)
    task wrs(input [3:0] slot, input [9:0] i, input [31:0] v);
        begin @(negedge clk); addr = {slot, i, 2'b00}; wdata = v; we = 1; @(negedge clk); we = 0; end
    endtask
    reg [31:0] bank_g [0:511], bank_b [0:511];
    reg [31:0] expw [0:38];                         // the first 3 genesis works (C++ model), 13 words each
    task load_bank(input big, input b);
        integer j;
        begin for (j = 0; j < 512; j = j + 1) wrs(4'd4, {b, j[8:0]}, big ? bank_b[j] : bank_g[j]); end
    endtask

    // ---- chain 6 (J7) TX capture (bytes only)
    wire cv1, cferr1; wire [7:0] cd1;
    hr_uart_rx cap1 (.clk(clk), .rst(!rstn), .cpb(16'd16), .line(tx[6]), .v(cv1), .d(cd1), .ferr(cferr1));
    reg [7:0] txb1 [0:16383];
    integer   ntx1 = 0;
    always @(posedge clk) if (cv1) begin txb1[ntx1] <= cd1; ntx1 <= ntx1 + 1; end

    localparam B0 = 64 + 32 * 5, CPB = 16;             // chain 5 (J6): the first stock plug
    integer pass = 0, total = 0;
    task check(input ok, input [8*64-1:0] name);
        begin total = total + 1; if (ok) pass = pass + 1; $display("%s %0s", ok ? "ok  " : "FAIL", name); end
    endtask

    task wr(input [9:0] i, input [31:0] v);
        begin @(negedge clk); addr = {4'd2, i, 2'b00}; wdata = v; we = 1; @(negedge clk); we = 0; end
    endtask
    reg [31:0] rv;
    task rd(input [9:0] i);
        begin @(negedge clk); addr = {4'd2, i, 2'b00}; re = 1; @(negedge clk); re = 0; @(negedge clk); rv = rdata; end
    endtask

    // ---- chain 5 (J6) TX capture: every byte with the time its start bit began
    wire cv, cferr; wire [7:0] cd;
    hr_uart_rx cap (.clk(clk), .rst(!rstn), .cpb(cap_cpb), .line(tx[5]), .v(cv), .d(cd), .ferr(cferr));
    reg [15:0] cap_cpb = CPB;
    reg [7:0]  txb [0:16383];
    reg [63:0] txt [0:16383];
    integer    ntx = 0;
    reg        last_line = 1;
    reg [63:0] start_t = 0;
    integer    last_low = 0, low_len = 0;
    reg        in_start = 0;
    always @(posedge clk) begin
        if (last_line && !tx[5]) begin start_t <= $time; in_start <= 1; low_len <= 0; end
        else if (in_start && !tx[5]) low_len <= low_len + 1;
        else if (in_start && tx[5]) begin in_start <= 0; last_low <= low_len + 1; end
        last_line <= tx[5];
        if (cv) begin txb[ntx] <= cd; txt[ntx] <= start_t; ntx <= ntx + 1; end
    end

    // ---- RX injection
    reg inj_start = 0; reg [7:0] inj_d = 0; wire inj_busy;
    hr_uart_tx inj (.clk(clk), .rst(!rstn), .cpb(16'd16), .start(inj_start), .d(inj_d), .line(inj_line), .busy(inj_busy));
    task send_rx(input [7:0] b);
        begin
            @(negedge clk); inj_d = b; inj_start = 1; @(negedge clk); inj_start = 0;
            @(negedge clk); while (inj_busy) @(negedge clk);
        end
    endtask

    task push_work(input [31:0] tag, input [31:0] tag2, input [95:0] tail, input [255:0] mid);
        integer i;
        begin
            wr(B0 + 8, tag); wr(B0 + 9, tag2);
            for (i = 0; i < 3; i = i + 1) wr(B0 + 10 + i, tail[95 - 32 * i -: 32]);
            for (i = 0; i < 8; i = i + 1) wr(B0 + 13 + i, mid[255 - 32 * i -: 32]);
            wr(B0 + 5, 1);
        end
    endtask
    task wait_works_empty;
        begin rd(B0 + 6); while (rv[4:0] != 0 || rv[16]) begin repeat (200) @(negedge clk); rd(B0 + 6); end end
    endtask
    task wait_room;
        begin rd(B0 + 6); while (rv[17]) begin repeat (200) @(negedge clk); rd(B0 + 6); end end
    endtask

    // Skot's job 0x74 (bm1387_scripts): bytes 8..19 tail, 20..51 midstate; its CRC-16 is C6 BB
    localparam [95:0]  SK_TAIL = 96'hf91e0e178020cc6061815505;
    localparam [255:0] SK_MID  = 256'h003606533262a24121a03cb243e3c05349fc207a9d5de084e662147599cb969c;
    reg [8*54-1:0] SK_PKT;
    integer i, k, base, ok, t0, t1, t2, base1, nflip, n;
    // a work word written into the slot chain 5 (J6) is sending right now (a flush must not let new works reuse it)
    integer clobber = 0, wsince = 0, partial = 0;
    integer tx0_low = 0;                            // clocks line 0 (J1) spends low: a masked chain must stay idle
    always @(posedge clk) if (!tx[0]) tx0_low = tx0_low + 1;
    always @(posedge clk) begin                     // every push on chain 5 (J6) must carry 13 words written since
        if (dut.ch[5].on.u.flush[0]) wsince = 0;      // its last push or flush (else it is part stale)
        else if (dut.ch[5].on.u.work_push) begin if (wsince < 13) partial = partial + 1; wsince = 0; end
        else if (dut.ch[5].on.u.work_word_we) wsince = wsince + 1;
    end
    always @(posedge clk) if (dut.ch[5].on.u.in_pkt && dut.ch[5].on.u.work_word_we && dut.ch[5].on.u.wwp == dut.ch[5].on.u.wr_addr[7:4])
        clobber = clobber + 1;
    reg [255:0] mids [0:7];
    reg [351:0] pk [0:7];                           // the 44 work bytes (tail, midstate) of each builder packet
    reg [351:0] ew;
    integer m, found;
    initial begin
        SK_PKT = {64'h2136740100000000, SK_TAIL, SK_MID, 16'hc6bb};
        repeat (20) @(negedge clk); rstn = 1;
        wr(B0 + 1, CPB);

        // 1. skot_packet_bytes: 116 fillers (job ids 0..115), then Skot's work gets job id 0x74
        wr(B0 + 2, 1); wr(B0 + 0, 1);                       // 1 us between jobs, run
        for (i = 0; i < 116; i = i + 1) begin wait_room; push_work(i, 0, 96'd0, 256'd0); end
        wait_room; push_work(32'h74, 0, SK_TAIL, SK_MID);
        wait_works_empty; repeat (CPB * 30) @(negedge clk);
        base = ntx - 54; ok = (ntx == 117 * 54);
        for (i = 0; i < 54; i = i + 1) if (txb[base + i] !== SK_PKT[8*54-1 - 8*i -: 8]) ok = 0;
        check(ok, "skot_packet_bytes (job 0x74, CRC C6 BB)");

        // 2. pacing: 3 works at TIMEOUT 200 us; packet starts 200 us apart (+-2 us)
        wr(B0 + 0, 0); wr(B0 + 2, 200);
        base = ntx;
        for (i = 0; i < 3; i = i + 1) push_work(1000 + i, 0, 96'd0, 256'd0);
        wr(B0 + 0, 1);
        wait_works_empty; repeat (CPB * 30) @(negedge clk);
        t0 = txt[base]; t1 = txt[base + 54]; t2 = txt[base + 108];
        check((t1 - t0 >= 198000) && (t1 - t0 <= 202000) && (t2 - t1 >= 198000) && (t2 - t1 <= 202000),
              "pacing (200 us between packet starts)");

        // 3. cmd_between_packets: a command committed mid-packet goes out after the packet's last byte
        base = ntx;
        push_work(2000, 0, 96'd0, 256'd0);
        while (ntx < base + 10) @(negedge clk);             // the packet is on the wire
        wr(B0 + 3, 8'hAA); wr(B0 + 3, 8'hBB); wr(B0 + 3, 9'h100);
        while (ntx < base + 56) @(negedge clk);
        check(txb[base] == 8'h21 && txb[base + 54] == 8'hAA && txb[base + 55] == 8'hBB, "cmd_between_packets");

        // 4. baud_after_packet: a bit-time change queued mid-packet applies only after it
        wr(B0 + 2, 2000);                                   // next job 2 ms later, out of the way
        base = ntx;
        push_work(3000, 0, 96'd0, 256'd0);
        while (ntx < base + 5) @(negedge clk);
        wr(B0 + 4, 32);
        wr(B0 + 3, 8'h55); wr(B0 + 3, 9'h100);
        cap_cpb = CPB;
        while (ntx < base + 54) @(negedge clk);
        t0 = txt[base + 52]; t1 = txt[base + 53];          // packet bytes still 16 clocks a bit: 10 bits apart
        ok = (t1 - t0 >= 1600) && (t1 - t0 <= 1700);
        cap_cpb = 32;
        while (ntx < base + 55) @(negedge clk);
        check(ok && txb[base + 54] == 8'h55 && last_low == 32, "baud_after_packet (16 -> 32 clocks a bit)");
        wr(B0 + 0, 0); wr(B0 + 1, CPB); cap_cpb = CPB;

        // 5. collector_resync: AA, a register frame, 3 junk bytes, a nonce frame (job 0x45)
        rd(B0 + 25); k = rv;                                // CRC_ERR before
        send_rx(8'hAA);
        for (i = 0; i < 7; i = i + 1) send_rx(56'h13879000000007 >> (8 * (6 - i)));
        send_rx(8'h11); send_rx(8'h22); send_rx(8'h33);
        for (i = 0; i < 7; i = i + 1) send_rx(56'h2f28a626004595 >> (8 * (6 - i)));
        repeat (50) @(negedge clk);
        rd(B0 + 21); ok = rv[31] && rv[15:8] == 8'h00 && rv[7:0] == 8'h00;
        rd(B0 + 22); ok = ok && rv == 32'h13879000;
        rd(B0 + 21); ok = ok && !rv[31];                    // exactly one register record
        rd(2); ok = ok && rv[31] && rv[22:16] == 7'h45 && rv[5:0] == 6'd11;
        rd(3); ok = ok && rv == 32'h2f28a626;
        rd(1); ok = ok && rv == 0;                          // exactly one nonce record
        rd(B0 + 25); ok = ok && (rv - k == 4);
        check(ok, "collector_resync (1 register, 1 nonce, 4 CRC errors)");

        // 5b. nonce_bits65: BM1485 (L3+) nonces may set byte 6 bits 6:5; CRC5 still checked, register replies not
        rd(B0 + 25); k = rv;
        for (i = 0; i < 7; i = i + 1) send_rx(56'h2f28a6260045df >> (8 * (6 - i)));   // nonce, bits 6:5 = 10
        repeat (50) @(negedge clk);
        rd(2); ok = rv[31] && rv[22:16] == 7'h45;
        rd(3); ok = ok && rv == 32'h2f28a626;
        rd(1); ok = ok && rv == 0;
        rd(B0 + 25); ok = ok && rv == k;
        check(ok, "nonce_bits65 (L3+ nonce with byte 6 bits 6:5 set is taken)");

        // 6. jid_reuse_tag: 130 works, tags 0..129; a nonce for job id 1 reports tag 129
        // (the job id counter is at 0x76 after the 118 + 3 + 1 + 1 earlier packets: realign first)
        rd(B0 + 28); k = (rv + 1) % 128;                    // next job id
        wr(B0 + 2, 1); wr(B0 + 0, 1);
        for (i = 0; i < (128 - k) % 128; i = i + 1) begin wait_room; push_work(32'hFFFF0000 + i, 0, 96'd0, 256'd0); end
        for (i = 0; i < 130; i = i + 1) begin wait_room; push_work(i, 32'hBEEF0000 + i, 96'd0, 256'd0); end
        wait_works_empty; repeat (CPB * 30) @(negedge clk);
        for (i = 0; i < 7; i = i + 1) send_rx(56'h2f28a626000199 >> (8 * (6 - i)));
        repeat (50) @(negedge clk);
        rd(2); ok = rv[31] && rv[22:16] == 7'h01;
        rd(4); ok = ok && rv == 129;
        rd(5); ok = ok && rv == 32'hBEEF0000 + 129;
        check(ok, "jid_reuse_tag (job id 1 -> tag 129)");

        // 7. pop_after_take: NONCE_POP read one clock after a nonce enters the empty FIFO returns that nonce
        //    (or nothing, and the nonce on the next pop), never a stale record
        wr(B0 + 0, 0);
        rd(1); while (rv != 0) begin rd(2); rd(1); end
        for (i = 0; i < 6; i = i + 1) send_rx(56'h2f28a626000199 >> (8 * (6 - i)));
        @(negedge clk); inj_d = 8'h99; inj_start = 1; @(negedge clk); inj_start = 0;
        wait (dut.take === 1'b1);
        @(negedge clk); @(negedge clk); addr = {4'd2, 10'd2, 2'b00}; re = 1; @(negedge clk); re = 0; @(negedge clk);
        rv = rdata;
        if (!rv[31]) begin repeat (10) @(negedge clk); rd(2); end
        ok = rv[31] && rv[22:16] == 7'h01;
        rd(3); ok = ok && rv == 32'h2f28a626;
        repeat (10) @(negedge clk);
        rd(1); ok = ok && rv == 0;
        check(ok, "pop_after_take (no stale record)");

        // 8. flush_mid_packet: flushing works while one is on the wire, then 2 new works: 3 packets, FIFO empty
        wr(B0 + 2, 1); wr(B0 + 0, 1);
        base = ntx;
        push_work(4000, 0, 96'd0, 256'd0);
        while (ntx < base + 10) @(negedge clk);
        wr(B0 + 0, 32'h3);                                  // run + flush works
        push_work(4001, 0, 96'd0, 256'd0); push_work(4002, 0, 96'd0, 256'd0);
        wait_works_empty; repeat (CPB * 400) @(negedge clk);
        rd(B0 + 6);
        check(ntx - base == 3 * 54 && rv[4:0] == 0, "flush_mid_packet (3 packets, FIFO empty)");

        // 9. many_commands: 70 one-byte commands committed faster than they go out are all sent
        wr(B0 + 0, 0);
        base = ntx;
        for (i = 0; i < 70; i = i + 1) begin wr(B0 + 3, 8'h5A); wr(B0 + 3, 9'h100); end
        k = 0;
        while (ntx < base + 70 && k < 40000) begin @(negedge clk); k = k + 1; end
        repeat (CPB * 30) @(negedge clk);
        check(ntx - base == 70, "many_commands (70 commits, 70 bytes)");

        // 10. builder_feeds_two_chains: chains 0 and 1 in builder mode, the first 4 packets on each all different
        $readmemh("sim/vec/genesis_bank.hex", bank_g); $readmemh("sim/vec/big_bank.hex", bank_b);
        load_bank(0, 0); wrs(4'd3, 10'd1, 32'hD);           // enable, bank 0, flip, clean
        wr(B1 + 1, CPB); wr(B1 + 2, 1); wr(B0 + 2, 1);
        base = ntx; base1 = ntx1;
        wr(B0 + 0, 32'h11); wr(B1 + 0, 32'h11);             // run, SRC = builder
        k = 0;
        while ((ntx < base + 4 * 54 || ntx1 < base1 + 4 * 54) && k < 200000) begin @(negedge clk); k = k + 1; end
        ok = k < 200000;
        for (n = 0; n < 4; n = n + 1) begin
            if (txb[base + 54 * n] !== 8'h21 || txb1[base1 + 54 * n] !== 8'h21) ok = 0;
            for (i = 0; i < 32; i = i + 1) begin
                mids[n][255 - 8 * i -: 8] = txb[base + 54 * n + 20 + i];
                mids[4 + n][255 - 8 * i -: 8] = txb1[base1 + 54 * n + 20 + i];
            end
        end
        for (n = 0; n < 8; n = n + 1) for (i = n + 1; i < 8; i = i + 1) if (mids[n] === mids[i]) ok = 0;
        // every genesis work the C++ model makes is on the wire byte for byte (tail words 2..4, midstate 5..12)
        $readmemh("sim/vec/genesis_works.hex", expw);
        for (n = 0; n < 4; n = n + 1)
            for (i = 0; i < 44; i = i + 1) begin
                pk[n][351 - 8 * i -: 8] = txb[base + 54 * n + 8 + i];
                pk[4 + n][351 - 8 * i -: 8] = txb1[base1 + 54 * n + 8 + i];
            end
        for (k = 0; k < 3; k = k + 1) begin
            for (m = 0; m < 11; m = m + 1) ew[351 - 32 * m -: 32] = expw[13 * k + 2 + m];
            found = 0;
            for (n = 0; n < 8; n = n + 1) if (pk[n] === ew) found = 1;
            if (!found) begin
                ok = 0;
                $display("     genesis work %0d not on the wire: want %h", k, ew);
                $display("     packet 0 (chain 5) is     %h", pk[0]);
                $display("     packet 0 (chain 6) is     %h", pk[4]);
            end
        end
        check(ok, "builder_feeds_two_chains (8 packets, C++ works byte for byte)");

        // 11. src_ignores_arm: a WORK_PUSH from the ARM on a builder-mode chain adds nothing
        wr(B0 + 0, 32'h10); wr(B0 + 0, 32'h12);             // stop (SRC stays), flush works
        repeat (20) @(negedge clk); rd(B0 + 6); k = rv[4:0];
        push_work(32'h1234, 0, 96'd0, 256'd0);
        repeat (20) @(negedge clk); rd(B0 + 6);
        check(k == 0 && rv[4:0] == 0, "src_ignores_arm (WORK_PUSH adds nothing)");

        // 12. clean_flip_reaches_wire: after a clean flip to a second bank, from the 3rd packet on every packet on
        //     chain 5 carries the new bank's tail (big: nbits 17030ecd; genesis: ffff001d)
        rd(B0 + 6); while (rv[16]) begin repeat (200) @(negedge clk); rd(B0 + 6); end
        repeat (CPB * 30) @(negedge clk);                   // the last byte leaves the UART
        base = ntx;
        wr(B0 + 0, 32'h11);
        while (ntx < base + 2 * 54) @(negedge clk);
        load_bank(1, 1);
        nflip = (ntx - base + 53) / 54;
        wrs(4'd3, 10'd1, 32'hF);                            // enable, bank 1, flip, clean
        k = 0;
        while (ntx < base + 54 * (nflip + 6) && k < 400000) begin @(negedge clk); k = k + 1; end
        ok = k < 400000 && txb[base + 8] == 8'hff && txb[base + 9] == 8'hff && txb[base + 10] == 8'h00
             && txb[base + 11] == 8'h1d;                    // before the flip: genesis
        for (n = nflip + 2; n < nflip + 6; n = n + 1)
            if (txb[base + 54 * n] !== 8'h21 || txb[base + 54 * n + 8] !== 8'h17 || txb[base + 54 * n + 9] !== 8'h03
                || txb[base + 54 * n + 10] !== 8'h0e || txb[base + 54 * n + 11] !== 8'hcd) ok = 0;
        if (!ok) begin
            $display("     waited %0d clocks, flip after packet %0d, %0d bytes", k, nflip, ntx - base);
            for (n = 0; n < nflip + 6; n = n + 1)
                $display("     packet %0d: %h tail0 %h%h%h%h", n, txb[base + 54 * n], txb[base + 54 * n + 8],
                         txb[base + 54 * n + 9], txb[base + 54 * n + 10], txb[base + 54 * n + 11]);
        end
        check(ok, "clean_flip_reaches_wire (new tail within 3 packets)");

        // 13. flush_keeps_packet: 6 clean flips, each landing 20 bytes into a packet on chain 5; the works fed after
        //     each flush never overwrite the slot that packet is still being sent from
        clobber = 0;
        for (n = 0; n < 6; n = n + 1) begin
            k = 0;
            while (!dut.ch[5].on.u.in_pkt && k < 400000) begin @(negedge clk); k = k + 1; end
            repeat (CPB * 10 * 20) @(negedge clk);
            wrs(4'd3, 10'd1, {28'd0, 1'b1, 1'b1, n[0], 1'b1});    // enable, bank n&1, flip, clean
            repeat (CPB * 10 * 60) @(negedge clk);
        end
        base = ntx; k = 0;
        while (ntx < base + 54 && k < 400000) begin @(negedge clk); k = k + 1; end
        if (clobber) $display("     %0d work words written into the slot being sent", clobber);
        check(clobber == 0 && k < 400000, "flush_keeps_packet (no slot reuse mid-packet)");
        wr(B0 + 0, 0); wr(B1 + 0, 0);

        // 14. cmd_flush_mid_command: a 20-byte command flushed 3 bytes in stops there (the byte on the wire
        //     finishes); the counters stay sane, and the next command goes out alone and whole
        rd(B0 + 6); while (rv[16]) begin repeat (200) @(negedge clk); rd(B0 + 6); end
        repeat (CPB * 30) @(negedge clk);
        base = ntx;
        for (i = 0; i < 20; i = i + 1) wr(B0 + 3, 8'h40 + i);
        wr(B0 + 3, 9'h100);
        while (ntx < base + 3) @(negedge clk);
        wr(B0 + 0, 32'h4);                                  // flush commands
        repeat (CPB * 10 * 40) @(negedge clk);
        t0 = ntx - base;
        rd(B0 + 6); ok = rv[12:8] == 5'd0 && !rv[16];
        wr(B0 + 3, 8'hA5); wr(B0 + 3, 9'h100);
        repeat (CPB * 10 * 40) @(negedge clk);
        rd(B0 + 6); ok = ok && rv[12:8] == 5'd0;
        ok = ok && t0 <= 5 && ntx - base == t0 + 1 && txb[ntx - 1] == 8'hA5;
        if (!ok) $display("     %0d bytes before the new command, %0d after, last %h, stat %h", t0, ntx - base - t0,
                          txb[ntx - 1], rv);
        check(ok, "cmd_flush_mid_command (stops, next alone)");

        // 15. arm_flush_mid_copy: the ARM flushes chain 5's works (CCTRL bit 1) while the feeder is copying a work
        //     into it; no work is pushed with words left over from before the flush
        wrs(4'd3, 10'd1, 32'hD);                            // builder on, bank 0, flip, clean
        wr(B0 + 0, 32'h11);                                 // chain 5 running from the builder
        for (n = 0; n < 4; n = n + 1) begin
            k = 0;
            while (!(dut.fst == 3'd1 && dut.fc == 4'd5 && dut.fcnt == 4'd4) && k < 400000) begin
                @(negedge clk); k = k + 1;
            end
            if (n == 0) partial = 0;
            wr(B0 + 0, 32'h13);                             // run, SRC, flush works
            repeat (CPB * 10 * 60) @(negedge clk);
        end
        if (partial) $display("     %0d works pushed part stale", partial);
        check(partial == 0 && k < 400000, "arm_flush_mid_copy (no part-stale work)");
        wr(B0 + 0, 0);

        // 16. masked_chains_silent: with the default CHAIN_MASK (J6, J7, J8) chain 0 (J1) does not exist: a command
        //     and a work pushed to it send nothing on line 0 and its STAT reads 0, while chain 5 (J6) still sends
        tx0_low = 0;
        wr(64 + 1, CPB); wr(64 + 2, 1); wr(64 + 0, 1);
        wr(64 + 3, 8'h5A); wr(64 + 3, 9'h100);
        wr(64 + 8, 32'h1234); for (i = 9; i <= 20; i = i + 1) wr(64 + i, 0); wr(64 + 5, 1);
        wr(B0 + 2, 1); wr(B0 + 0, 1); base = ntx;
        push_work(5000, 0, 96'd0, 256'd0);
        k = 0; while (ntx < base + 54 && k < 400000) begin @(negedge clk); k = k + 1; end
        rd(64 + 6); ok = rv == 0 && tx0_low == 0 && k < 400000;
        if (!ok) $display("     line 0 low for %0d clocks, chain 0 STAT %h, chain 5 sent %0d bytes", tx0_low, rv, ntx - base);
        check(ok, "masked_chains_silent (J1 off, J6 sends)");
        wr(64 + 0, 0); wr(B0 + 0, 0);

        if (pass == total) $display("PASS %0d/%0d", pass, total); else $display("FAIL %0d/%0d", pass, total);
        $finish;
    end
    initial begin #400_000_000; $display("FAIL: timeout"); $finish; end
endmodule
