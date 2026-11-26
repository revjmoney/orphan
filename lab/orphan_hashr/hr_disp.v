`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR dispatcher (slot 2): up to 9 hashboard chains driven the way Bitmain's FPGA does it.
// Each chain (hr_chain.v) owns its UART, sends a job every TIMEOUT microseconds and collects replies; nonces from all
// chains meet in one 256-entry FIFO.
//
// Registers (word index):
//   0 ID "HSD1"        1 NONCE_COUNT (r)
//   2 NONCE_POP (r, pops) [31] valid, [27:24] chain, [22:16] job id, [5:0] chip; latches words 3..5
//   3 NONCE_VALUE (r) the 4 nonce bytes as received, byte 0 in [31:24]   4 NONCE_TAG (r)   5 NONCE_TAG2 (r)
//   chain c (0..8) at B = 64 + 32*c:
//     B+0 CCTRL [0] RUN, [1] flush works, [2] flush commands, [3] flush register replies (1..3 self-clearing),
//               [4] SRC: 0 the ARM stages works (pattern mode), 1 the work builder (hr_build) feeds this chain and
//               the ARM's staging and WORK_PUSH are ignored
// Builder feed: when hr_build has a work ready, the next chain (round-robin) with SRC = 1, RUN = 1 and fewer than 2
// queued works gets it (13 words, one a clock, then pushed). A clean flip of the builder flushes the queued works of
// every SRC = 1 chain at once (a packet already on the wire finishes).
//     B+1 BAUD clocks per bit now in force (a write applies at once: only while idle)
//     B+2 TIMEOUT [16:0] microseconds between jobs
//     B+3 CMD (w) [7:0] byte appended to the open command, [8] commit (the bytes so far become one command)
//     B+4 CMD_BAUD (w) [15:0] bit-time change queued behind everything before it (commit open commands first)
//     B+5 WORK_PUSH (w) the staged work (B+8..B+20) joins the work FIFO (16 deep)
//     B+6 STAT (r) [4:0] works queued, [12:8] commands queued, [16] sending, [17] work FIFO full
//     B+8 TAG  B+9 TAG2  B+10..B+12 tail (byte 0 in [31:24] of B+10)  B+13..B+20 midstate
//     B+21 REG_POP (r, pops) [31] valid, [15:8] chip address, [7:0] register; latches B+22 REG_VALUE
//     B+23 SENT  B+24 NONCES  B+25 CRC_ERR  B+26 FRAMES  B+27 RX_OVF  B+28 LAST_JID
//   127 ID "HSD1"
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.

module hr_disp #(parameter [3:0] SLOT = 4'd2,
                 parameter [8:0] CHAIN_MASK = 9'b011100000) (   // chains that exist: J6, J7, J8 (the stock plugs)
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    output wire [8:0]  tx_line,
    input  wire [8:0]  rx_line,
    input  wire        w_valid,                    // hr_build work port
    output wire [3:0]  w_idx,
    input  wire [31:0] w_word,
    output wire        w_take,
    input  wire        clean
);
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];
    wire wr = bus_we && sel;
    wire rd = bus_re && sel;

    // 1 MHz tick
    reg [6:0] usdiv = 7'd0;
    reg       us_tick = 1'b0;
    always @(posedge clk) begin
        us_tick <= (usdiv == 7'd99);
        usdiv <= (usdiv == 7'd99) ? 7'd0 : usdiv + 1'b1;
    end

    // chain decode. Writes are registered once before they fan out to the 9 chains (timing: the chains sit far
    // apart on the chip); reads decode directly.
    wire        in_chain = (idx >= 10'd64) && (idx < 10'd352);
    wire [9:0]  coff = idx - 10'd64;
    wire [3:0]  cn = coff[8:5];
    wire [4:0]  cr = coff[4:0];
    reg         wq = 1'b0;
    reg [3:0]   wcn = 4'd0;
    reg [4:0]   wcr = 5'd0;
    reg [31:0]  wd = 32'd0;
    always @(posedge clk) begin
        wq <= wr && in_chain;
        wcn <= cn; wcr <= cr; wd <= bus_wdata;
    end

    wire [8:0]  nv, n_ack, rv_, r_ack;
    wire [6:0]  njid [0:8];
    wire [5:0]  nchip [0:8];
    wire [31:0] nnonce [0:8], ntag [0:8], ntag2 [0:8];
    wire [7:0]  rchip [0:8], rreg [0:8];
    wire [31:0] rval [0:8], cstat [0:8], csent [0:8], cnon [0:8], ccrc [0:8], cfr [0:8], covf [0:8];
    wire [15:0] ccpb [0:8];
    wire [6:0]  clj [0:8];
    reg  [8:0]  r_ack_q = 9'd0;
    reg  [31:0] reg_latch [0:8];
    wire [8:0]  run_w, src_w, wfl_w;            // wfl_w: the chain's works are being flushed this clock

    // builder feeder (below) drives these
    localparam F_IDLE = 3'd0, F_COPY = 3'd1, F_PUSH = 3'd2, F_COOL = 3'd3, F_COOL2 = 3'd4;
    reg  [2:0]  fst = F_IDLE;
    reg  [3:0]  fc = 4'd0, fptr = 4'd0, fcnt = 4'd0;
    wire        feed_we = (fst == F_COPY) && !clean;
    wire        feed_push = (fst == F_PUSH) && !clean && !wfl_w[fc];   // a push in a flush clock would carry
                                                                     // only the words written after it
    assign w_idx = fcnt;
    assign w_take = feed_push;
    // the copy is registered once before it fans out to the 9 chains (timing), like the ARM writes above; write
    // and push are both one clock late, so their order is kept, and a push landing with a clean flush is dropped
    // by the chain exactly as an earlier push would have been flushed
    reg         fq_we = 1'b0, fq_push = 1'b0;
    reg  [3:0]  fq_c = 4'd0, fq_idx = 4'd0;
    reg  [31:0] fq_word = 32'd0;
    always @(posedge clk) begin
        fq_we <= feed_we; fq_push <= feed_push; fq_c <= fc; fq_idx <= fcnt; fq_word <= w_word;
    end

    genvar c;
    generate for (c = 0; c < 9; c = c + 1) begin : ch
      if (CHAIN_MASK[c]) begin : on
        wire mine = wq && (wcn == c);
        reg        run = 1'b0;
        reg        src = 1'b0;
        reg [16:0] tmo = 17'd2359;
        reg [2:0]  fl = 3'd0;
        always @(posedge clk) begin
            fl <= 3'd0;
            if (!rstn) begin run <= 1'b0; src <= 1'b0; tmo <= 17'd2359; end
            else if (mine && wcr == 5'd0) begin run <= wd[0]; fl <= wd[3:1]; src <= wd[4]; end
            else if (mine && wcr == 5'd2) tmo <= wd[16:0];
        end
        assign run_w[c] = run;
        assign src_w[c] = src;
        assign wfl_w[c] = fl[0];
        wire fed = (fq_c == c);
        hr_chain u (
            .clk(clk), .rstn(rstn), .us_tick(us_tick), .tx_line(tx_line[c]), .rx_line(rx_line[c]),
            .run(run), .timeout(tmo),
            .cpb_we(mine && wcr == 5'd1), .cpb_wdata(wd[15:0]), .cpb(ccpb[c]),
            .cmd_byte_we(mine && wcr == 5'd3 && !wd[8]), .cmd_byte(wd[7:0]),
            .cmd_commit(mine && wcr == 5'd3 && wd[8]),
            .cmd_baud_we(mine && wcr == 5'd4), .cmd_baud(wd[15:0]),
            .work_word_we(src ? (fq_we && fed) : (mine && wcr >= 5'd8 && wcr <= 5'd20)),
            .work_word_idx(src ? fq_idx : wcr[3:0] - 4'd8), .work_word(src ? fq_word : wd),
            .work_push(src ? (fq_push && fed) : (mine && wcr == 5'd5)), .flush(fl | {2'b00, clean && src}),
            .nonce_valid(nv[c]), .n_jid(njid[c]), .n_chip(nchip[c]), .n_nonce(nnonce[c]), .n_tag(ntag[c]),
            .n_tag2(ntag2[c]), .nonce_ack(n_ack[c]),
            .reg_valid(rv_[c]), .r_chip(rchip[c]), .r_reg(rreg[c]), .r_value(rval[c]), .reg_ack(r_ack_q[c]),
            .stat(cstat[c]), .c_sent(csent[c]), .c_nonces(cnon[c]), .c_crcerr(ccrc[c]), .c_frames(cfr[c]),
            .c_rxovf(covf[c]), .last_jid(clj[c]));
      end else begin : off                     // no chain on this header: every output idle, writes ignored
        assign tx_line[c] = 1'b1;
        assign run_w[c] = 1'b0; assign src_w[c] = 1'b0; assign wfl_w[c] = 1'b0;
        assign nv[c] = 1'b0; assign njid[c] = 7'd0; assign nchip[c] = 6'd0; assign nnonce[c] = 32'd0;
        assign ntag[c] = 32'd0; assign ntag2[c] = 32'd0;
        assign rv_[c] = 1'b0; assign rchip[c] = 8'd0; assign rreg[c] = 8'd0; assign rval[c] = 32'd0;
        assign cstat[c] = 32'd0; assign csent[c] = 32'd0; assign cnon[c] = 32'd0; assign ccrc[c] = 32'd0;
        assign cfr[c] = 32'd0; assign covf[c] = 32'd0; assign ccpb[c] = 16'd0; assign clj[c] = 7'd0;
      end
    end endgenerate

    // ------------------------------------------------------------------ builder feeder
    // fptr walks the chains one a clock (round-robin); a chain in builder mode, running, with fewer than 2 queued
    // works gets the ready work. A clean pulse drops a copy in progress (the builder has dropped the work too).
    wire [8:0] elig;
    generate for (c = 0; c < 9; c = c + 1) begin : el
        assign elig[c] = src_w[c] && run_w[c] && (cstat[c][4:0] < 5'd2);
    end endgenerate
    always @(posedge clk) begin
        fptr <= (fptr == 4'd8) ? 4'd0 : fptr + 1'b1;
        case (fst)
            F_IDLE: if (w_valid && !clean && elig[fptr]) begin fc <= fptr; fcnt <= 4'd0; fst <= F_COPY; end
            F_COPY: if (clean || !w_valid || wfl_w[fc]) fst <= F_IDLE;   // an ARM works flush drops the copy
                    else if (fcnt == 4'd12) fst <= F_PUSH;
                    else fcnt <= fcnt + 1'b1;
            F_PUSH: begin fcnt <= 4'd0; fst <= F_COOL; end     // the registered push lands in F_COOL and the
            F_COOL: fst <= F_COOL2;                             // chain's queued count shows it a clock later
            default: fst <= F_IDLE;
        endcase
        if (!rstn) fst <= F_IDLE;
    end

    // ------------------------------------------------------------------ shared nonce FIFO (256 x 113)
    reg [112:0] nmem [0:255];
    reg [7:0]   nwp = 8'd0, nrp = 8'd0;
    reg [8:0]   ncnt = 9'd0;
    reg [112:0] nq = 113'd0;
    reg [3:0]   rr = 4'd0;                 // round-robin chain
    wire        take = nv[rr] && ncnt != 9'd256;
    reg  [8:0]  n_ack_q = 9'd0;             // the ack is registered (timing: it fans out to 9 chains); rr revisits
    assign n_ack = n_ack_q;                  // a chain only every 9 clocks, so the record is never taken twice
    always @(posedge clk) n_ack_q <= take ? (9'd1 << rr) : 9'd0;
    reg         npop = 1'b0;
    reg         take_q = 1'b0;
    wire        nready = (ncnt != 9'd0) && !(take_q && ncnt == 9'd1);   // nq lags a write by one clock
    always @(posedge clk) begin
        if (take) nmem[nwp] <= {rr, njid[rr], nchip[rr], nnonce[rr], ntag[rr], ntag2[rr]};
        nq <= nmem[nrp];
    end
    always @(posedge clk) begin
        rr <= (rr == 4'd8) ? 4'd0 : rr + 1'b1;
        take_q <= take;
        if (!rstn) begin nwp <= 8'd0; nrp <= 8'd0; ncnt <= 9'd0; end
        else begin
            if (take) nwp <= nwp + 1'b1;
            if (npop) nrp <= nrp + 1'b1;
            ncnt <= ncnt + (take ? 9'd1 : 9'd0) - (npop ? 9'd1 : 9'd0);
        end
    end

    // ------------------------------------------------------------------ bus reads
    reg [31:0] lat_val = 32'd0, lat_tag = 32'd0, lat_tag2 = 32'd0;
    integer k;
    always @(posedge clk) begin
        npop <= 1'b0;
        r_ack_q <= 9'd0;
        if (rd) begin
            bus_rdata <= 32'd0;
            if (idx == 10'd0 || idx == 10'd127) bus_rdata <= 32'h48534431;
            else if (idx == 10'd1) bus_rdata <= {23'd0, ncnt};
            else if (idx == 10'd2) begin
                if (nready) begin
                    bus_rdata <= {1'b1, 3'd0, nq[112:109], 1'b0, nq[108:102], 10'd0, nq[101:96]};
                    lat_val <= nq[95:64]; lat_tag <= nq[63:32]; lat_tag2 <= nq[31:0];
                    npop <= 1'b1;
                end
            end
            else if (idx == 10'd3) bus_rdata <= lat_val;
            else if (idx == 10'd4) bus_rdata <= lat_tag;
            else if (idx == 10'd5) bus_rdata <= lat_tag2;
            else if (in_chain) begin
                for (k = 0; k < 9; k = k + 1) if (cn == k) case (cr)
                    5'd1:  bus_rdata <= {16'd0, ccpb[k]};
                    5'd6:  bus_rdata <= cstat[k];
                    5'd21: if (rv_[k]) begin
                               bus_rdata <= {1'b1, 15'd0, rchip[k], rreg[k]};
                               reg_latch[k] <= rval[k];
                               r_ack_q[k] <= 1'b1;
                           end
                    5'd22: bus_rdata <= reg_latch[k];
                    5'd23: bus_rdata <= csent[k];
                    5'd24: bus_rdata <= cnon[k];
                    5'd25: bus_rdata <= ccrc[k];
                    5'd26: bus_rdata <= cfr[k];
                    5'd27: bus_rdata <= covf[k];
                    5'd28: bus_rdata <= {25'd0, clj[k]};
                    default: ;
                endcase
            end
        end else if (!sel) bus_rdata <= 32'd0;
    end
endmodule
