`timescale 1ns / 1ps
// [orphan] ORPHAN LOGIC LAB: SPEKTOR / INJEKTOR 3000 -- INTERSEKTOR, the UART man-in-the-middle bridge.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
//
// Cut a UART link (device A <-> device B) and put the S9 in the middle. Two directions, each with its own receive
// pin, transmit pin and baud rate:  direction 0 = A -> B,  direction 1 = B -> A.  Frames are 8N1.
//   mode 0 OFF    the transmit pin is not driven (high impedance)
//   mode 1 WIRE   bit-level pass-through (about 40 ns of delay, any baud, any frame format); bytes are still logged
//   mode 2 RELAY  every received byte goes through a 256-entry table (pass / swap to another value / drop), then is
//                 sent again; the ARM can inject its own bytes in between. One frame of delay.
//   mode 3 HOLD   received bytes only go to the ARM (the log); it forwards them, edited or not, through INJECT.
//                 If the ARM stops writing the heartbeat (CTRL) for 250 ms, a HOLD direction falls back to RELAY
//                 (FAILSAFE) so the link keeps working.
// A mode change waits until that direction's receiver and transmitter are idle and its relay queue is empty.
// Store and forward needs the bridge to send at least as fast as the sender: while bytes are waiting, the stop bit
// is shortened to 3/4 of a bit, so a sender up to about 2.5 % fast never overruns the queue (a lost byte is logged).
// Framing errors and breaks are logged, not forwarded, in RELAY / HOLD (WIRE passes everything, bit by bit).
//
// Outputs: nothing is driven until GO is set; a direction whose transmit pin equals a receive pin in use, or the
// other direction's transmit pin, is not driven (STATUS conflict bit).
// A second receiver on each transmit pin (read back from the pad) logs what really left the pin (kind 6 OUT).
// TEST: two built-in test transmitters (TESTTX) stand in for devices A and B: each direction then receives from its
// test transmitter instead of its pin (the transmit pins are still driven when GO is set).
//
// Registers (word index, slot SLOT):
//   0 CTRL    [0] GO  [1] TEST   write: [8] clear the log  [9] clear the counters; every write is a heartbeat
//   1 STATUS  [10:0] log entries  [16] log overflowed  [17] pin conflict  [19:18] failsafe d1,d0
//             [21:20] transmitting d1,d0  [23:22] receiving d1,d0  [25:24] driving d1,d0
//   2 TABLE   (write) [7:0] byte  [15:8] new value  [16] swap  [17] drop  [24] direction
//   3 TBLRD   write [8:0] {direction, byte}; read: that entry {drop, swap, value[7:0]}  (all 0 = pass)
//   4 LOG     (read, takes the oldest entry) [31] valid [30:28] kind [27] direction [15:8] byte sent [7:0] byte
//             kinds: 1 passed  2 swapped  3 dropped  4 held (HOLD)  5 framing error / break  6 OUT (left the pin)
//                    7 lost (relay queue full)
//   5 LOGTS   time stamp (microseconds) of the entry LOG just returned
//   6 NOW     the microsecond counter              7 LOST  log entries lost because the log was full
//   16 + 8d   direction d:
//     +0 MODE   [1:0] requested mode; read also [5:4] active mode
//     +1 BAUD   clocks per bit (100 MHz / baud), 16 .. 1048575 (115200 = 868)
//     +2 PINS   [5:0] receive pin  [13:8] transmit pin  (0..35 = J1.5 J1.11 J1.12 J1.15, J2.5 .. J9.15)
//     +3 INJECT write a byte to send; read [9:0] bytes waiting (512 max)
//     +4 COUNT  [15:0] bytes received  [31:16] bytes sent
//     +5 MINP   the shortest pulse seen on the receive pin, in clocks (read); write clears it
//     +6 ERRS   [7:0] framing  [15:8] lost  [23:16] dropped  [31:24] swapped  (saturating)
//     +7 TESTTX write a byte for this direction's test transmitter; read [4:0] bytes waiting
//   127 ID    "IKT1"
module intersektor #(parameter [3:0] SLOT = 4'd2, parameter [17:0] HB_US = 18'd250000) (
    input  wire        clk,                 // 100 MHz
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    input  wire [35:0] pins_in,             // the header pads (what is really on the pins)
    output reg  [35:0] pins_o = 36'd0,
    output reg  [35:0] pins_oe = 36'd0,
    output wire        led_act
);
    reg [15:0] a_r = 16'd0;
    reg [31:0] wd = 32'd0;
    reg        we_r = 1'b0, re_r = 1'b0;
    always @(posedge clk) begin a_r <= bus_addr; wd <= bus_wdata; we_r <= bus_we; re_r <= bus_re; end
    wire sel = (a_r[15:12] == SLOT);
    wire [9:0] idx = a_r[11:2];
    wire wr = we_r && sel;
    wire rd = re_r && sel;

    // ---- global
    reg go = 1'b0, test = 1'b0;
    wire clr_log = wr && idx == 10'd0 && wd[8];
    wire clr_cnt = wr && idx == 10'd0 && wd[9];
    always @(posedge clk) if (!rstn) begin go <= 1'b0; test <= 1'b0; end
        else if (wr && idx == 10'd0) begin go <= wd[0]; test <= wd[1]; end
    // microseconds and the heartbeat
    reg [6:0]  pre = 7'd0;
    reg [31:0] now = 32'd0;
    reg [17:0] hb = 18'd0;                  // microseconds / 1 since the last CTRL write (saturates)
    always @(posedge clk) begin
        pre <= (pre == 7'd99) ? 7'd0 : pre + 1'b1;
        if (pre == 7'd99) now <= now + 1'b1;
        if (wr && idx == 10'd0) hb <= 18'd0;
        else if (pre == 7'd99 && hb != 18'h3FFFF) hb <= hb + 1'b1;
    end
    wire hb_lost = hb >= HB_US;

    // ---- pads in: two flip-flops
    reg [35:0] p1 = 36'hFFFFFFFFF, p2 = 36'hFFFFFFFFF;
    always @(posedge clk) begin p1 <= pins_in; p2 <= p1; end

    // ---- per-direction registers (flattened: direction d in [w*d +: w])
    reg [3:0]  mode_req = 4'd0, mode_act = 4'd0;
    reg [39:0] cpb = {20'd868, 20'd868};
    reg [11:0] rxp = {6'd24, 6'd20};        // d0 A -> B: in on J6.5 (A's TX)    d1 B -> A: in on J7.5 (B's TX)
    reg [11:0] txp = {6'd21, 6'd25};        // d0 out on J7.11 (B's RX)          d1 out on J6.11 (A's RX)
    wire [9:0] didx = idx - 10'd16;
    wire       dsel = idx >= 10'd16 && idx < 10'd32;
    wire       dd = didx[3];
    wire [2:0] dreg = didx[2:0];
    wire [1:0] idle;
    always @(posedge clk) begin
        if (wr && dsel) case (dreg)
            3'd0: if (dd) mode_req[3:2] <= wd[1:0]; else mode_req[1:0] <= wd[1:0];
            3'd1: if (dd) cpb[39:20] <= (wd[19:0] < 20'd16) ? 20'd16 : wd[19:0];
                  else    cpb[19:0]  <= (wd[19:0] < 20'd16) ? 20'd16 : wd[19:0];
            3'd2: if (dd) begin rxp[11:6] <= (wd[5:0] > 6'd35) ? 6'd35 : wd[5:0];
                                txp[11:6] <= (wd[13:8] > 6'd35) ? 6'd35 : wd[13:8]; end
                  else    begin rxp[5:0] <= (wd[5:0] > 6'd35) ? 6'd35 : wd[5:0];
                                txp[5:0] <= (wd[13:8] > 6'd35) ? 6'd35 : wd[13:8]; end
            default: ;
        endcase
        // a mode change waits until the direction is idle
        if (idle[0] || mode_act[1:0] == 2'd0) mode_act[1:0] <= mode_req[1:0];
        if (idle[1] || mode_act[3:2] == 2'd0) mode_act[3:2] <= mode_req[3:2];
    end
    wire [1:0]  ma0 = mode_act[1:0], ma1 = mode_act[3:2];
    wire [5:0]  rx0 = rxp[5:0], rx1 = rxp[11:6], tx0 = txp[5:0], tx1 = txp[11:6];

    // ---- the swap tables (all 0 = pass): {drop, swap, value}
    reg [9:0] tbl0 [0:255], tbl1 [0:255];
    reg [8:0] tbl_ra = 9'd0;
    always @(posedge clk) if (wr && idx == 10'd2) begin
        if (wd[24]) tbl1[wd[7:0]] <= {wd[17], wd[16], wd[15:8]};
        else        tbl0[wd[7:0]] <= {wd[17], wd[16], wd[15:8]};
    end
    always @(posedge clk) if (wr && idx == 10'd3) tbl_ra <= wd[8:0];

    // ---- pin conflicts and drive enables
    wire on0 = ma0 != 2'd0, on1 = ma1 != 2'd0;
    wire cf0 = on0 && (tx0 == rx0 || (on1 && (tx0 == rx1 || tx0 == tx1)));
    wire cf1 = on1 && (tx1 == rx1 || (on0 && (tx1 == rx0 || tx1 == tx0)));
    wire drv0 = go && on0 && !cf0, drv1 = go && on1 && !cf1;
    wire [1:0] fs = {ma1 == 2'd3 && hb_lost, ma0 == 2'd3 && hb_lost};
    wire [3:0] meff = {fs[1] ? 2'd2 : ma1, fs[0] ? 2'd2 : ma0};

    // ---- the two directions
    wire [1:0]  rx_busy, tx_busy, ev_v, tx_line, tl_line;
    wire [37:0] ev_d;                       // per direction {kind[2:0], byte_out[7:0], byte[7:0]}
    wire [19:0] inj_lvl;
    wire [9:0]  tst_lvl;
    wire [63:0] cnt, errs;
    wire [39:0] minp;
    wire [15:0] tbyte;
    reg  [1:0]  rx_line = 2'b11;
    always @(posedge clk) begin
        rx_line[0] <= test ? tl_line[0] : p2[rx0];
        rx_line[1] <= test ? tl_line[1] : p2[rx1];
    end
    wire [19:0] te = {tbl1[tbyte[15:8]], tbl0[tbyte[7:0]]};
    genvar g;
    generate for (g = 0; g < 2; g = g + 1) begin : dir
        ik_dir u (.clk(clk), .rst(!rstn), .clr(clr_cnt), .cpb(cpb[20*g +: 20]), .mode(meff[2*g +: 2]),
            .rx_line(rx_line[g]), .tbl_byte(tbyte[8*g +: 8]), .tbl_e(te[10*g +: 10]),
            .inj_we(wr && dsel && dd == g && dreg == 3'd3), .tst_we(wr && dsel && dd == g && dreg == 3'd7),
            .minp_clr(wr && dsel && dd == g && dreg == 3'd5), .wbyte(wd[7:0]),
            .tx_line(tx_line[g]), .test_line(tl_line[g]), .ev_v(ev_v[g]), .ev_d(ev_d[19*g +: 19]),
            .rx_busy(rx_busy[g]), .tx_busy(tx_busy[g]), .idle(idle[g]),
            .inj_lvl(inj_lvl[10*g +: 10]), .tst_lvl(tst_lvl[5*g +: 5]), .cnt(cnt[32*g +: 32]),
            .errs(errs[32*g +: 32]), .minp(minp[20*g +: 20]));
    end endgenerate

    // the pads: drive, and read back what left each transmit pin
    integer k;
    always @(posedge clk) for (k = 0; k < 36; k = k + 1) begin
        pins_oe[k] <= (drv0 && tx0 == k) || (drv1 && tx1 == k);
        pins_o[k]  <= (drv0 && tx0 == k) ? tx_line[0] : tx_line[1];
    end
    reg [1:0] mon_line = 2'b11;
    always @(posedge clk) begin mon_line[0] <= drv0 ? p2[tx0] : 1'b1; mon_line[1] <= drv1 ? p2[tx1] : 1'b1; end
    wire [1:0]  mv;
    wire [15:0] md;
    ik_uart_rx u_m0 (.clk(clk), .rst(!rstn), .cpb(cpb[19:0]), .line(mon_line[0]), .v(mv[0]), .d(md[7:0]), .ferr(), .busy());
    ik_uart_rx u_m1 (.clk(clk), .rst(!rstn), .cpb(cpb[39:20]), .line(mon_line[1]), .v(mv[1]), .d(md[15:8]), .ferr(), .busy());

    // ---- the log: 1024 x {time stamp[31:0], kind[2:0], dir, byte_out[7:0], byte[7:0]}; four sources, each with
    // a one-deep holding register (a source makes at most one entry per frame)
    reg [3:0]  pv = 4'd0;
    reg [19:0] pd0 = 20'd0, pd1 = 20'd0, pd2 = 20'd0, pd3 = 20'd0;
    reg [31:0] pt0 = 32'd0, pt1 = 32'd0, pt2 = 32'd0, pt3 = 32'd0;
    reg        lwe = 1'b0;
    reg [51:0] lwd = 52'd0;
    reg [9:0]  lwp = 10'd0, lrp = 10'd0;
    reg [10:0] lcnt = 11'd0, lvis = 11'd0;
    reg        lovf = 1'b0;
    reg [31:0] lost = 32'd0;
    wire       pop = rd && idx == 10'd4 && lvis != 11'd0;
    wire [1:0] pick = pv[0] ? 2'd0 : pv[1] ? 2'd1 : pv[2] ? 2'd2 : 2'd3;
    wire       take = pv != 4'd0;
    wire [51:0] pent = pick == 2'd0 ? {pt0, pd0} : pick == 2'd1 ? {pt1, pd1} : pick == 2'd2 ? {pt2, pd2} : {pt3, pd3};
    always @(posedge clk) begin
        lwe <= 1'b0;
        if (take) begin
            if (lcnt + {10'd0, lwe} >= 11'd1023) begin lovf <= 1'b1; lost <= lost + 1'b1; end
            else begin lwe <= 1'b1; lwd <= pent; end
        end
        if (ev_v[0]) begin pd0 <= {ev_d[18:16], 1'b0, ev_d[15:0]}; pt0 <= now; end
        if (ev_v[1]) begin pd1 <= {ev_d[37:35], 1'b1, ev_d[34:19]}; pt1 <= now; end
        if (mv[0]) begin pd2 <= {3'd6, 1'b0, md[7:0], md[7:0]}; pt2 <= now; end
        if (mv[1]) begin pd3 <= {3'd6, 1'b1, md[15:8], md[15:8]}; pt3 <= now; end
        pv <= (pv & ~(take ? (4'd1 << pick) : 4'd0)) | {mv[1], mv[0], ev_v[1], ev_v[0]};
        if (lwe) lwp <= lwp + 1'b1;
        if (pop) lrp <= lrp + 1'b1;
        lcnt <= lcnt + (lwe ? 11'd1 : 11'd0) - (pop ? 11'd1 : 11'd0);
        lvis <= lcnt;
        if (clr_log) begin lwp <= 10'd0; lrp <= 10'd0; lcnt <= 11'd0; lvis <= 11'd0; lovf <= 1'b0; lost <= 32'd0; end
    end
    (* ram_style = "block" *) reg [51:0] lmem [0:1023];
    always @(posedge clk) if (lwe) lmem[lwp] <= lwd;
    reg  [51:0] head = 52'd0;
    wire [9:0]  lrp_n = pop ? lrp + 1'b1 : lrp;
    always @(posedge clk) head <= lmem[lrp_n];
    reg [31:0] last_ts = 32'd0;

    // ---- reads
    reg [9:0] tbl_q = 10'd0;
    always @(posedge clk) tbl_q <= tbl_ra[8] ? tbl1[tbl_ra[7:0]] : tbl0[tbl_ra[7:0]];
    always @(posedge clk) if (re_r) begin
        if (!sel) bus_rdata <= 32'd0;
        else if (dsel) case (dreg)
            3'd0: bus_rdata <= dd ? {26'd0, ma1, 2'd0, mode_req[3:2]} : {26'd0, ma0, 2'd0, mode_req[1:0]};
            3'd1: bus_rdata <= {12'd0, dd ? cpb[39:20] : cpb[19:0]};
            3'd2: bus_rdata <= dd ? {18'd0, tx1, 2'd0, rx1} : {18'd0, tx0, 2'd0, rx0};
            3'd3: bus_rdata <= {22'd0, dd ? inj_lvl[19:10] : inj_lvl[9:0]};
            3'd4: bus_rdata <= dd ? cnt[63:32] : cnt[31:0];
            3'd5: bus_rdata <= {12'd0, dd ? minp[39:20] : minp[19:0]};
            3'd6: bus_rdata <= dd ? errs[63:32] : errs[31:0];
            default: bus_rdata <= {27'd0, dd ? tst_lvl[9:5] : tst_lvl[4:0]};
        endcase else case (idx)
            10'd0: bus_rdata <= {30'd0, test, go};
            10'd1: bus_rdata <= {6'd0, drv1, drv0, rx_busy[1], rx_busy[0], tx_busy[1], tx_busy[0], fs[1], fs[0],
                                 cf0 | cf1, lovf, 5'd0, lvis};
            10'd3: bus_rdata <= {22'd0, tbl_q};
            10'd4: begin
                bus_rdata <= (lvis != 11'd0) ? {1'b1, head[19:17], head[16], 11'd0, head[15:0]} : 32'd0;
                if (lvis != 11'd0) last_ts <= head[51:20];
            end
            10'd5: bus_rdata <= last_ts;
            10'd6: bus_rdata <= now;
            10'd7: bus_rdata <= lost;
            10'd127: bus_rdata <= 32'h494B5431;          // "IKT1"
            default: bus_rdata <= 32'd0;
        endcase
    end
    assign led_act = |rx_busy | |tx_busy;
endmodule

// One direction: receiver, the swap table lookup, the relay and inject queues, the transmitter, the test source.
module ik_dir (
    input  wire        clk,
    input  wire        rst,
    input  wire        clr,
    input  wire [19:0] cpb,
    input  wire [1:0]  mode,                // the active mode (HOLD already turned into RELAY on failsafe)
    input  wire        rx_line,
    output wire [7:0]  tbl_byte,
    input  wire [9:0]  tbl_e,
    input  wire        inj_we,
    input  wire        tst_we,
    input  wire        minp_clr,
    input  wire [7:0]  wbyte,
    output wire        tx_line,
    output wire        test_line,
    output reg         ev_v = 1'b0,
    output reg  [18:0] ev_d = 19'd0,
    output wire        rx_busy,
    output wire        tx_busy,
    output wire        idle,
    output wire [9:0]  inj_lvl,
    output wire [4:0]  tst_lvl,
    output reg  [31:0] cnt = 32'd0,
    output reg  [31:0] errs = 32'd0,
    output reg  [19:0] minp = 20'hFFFFF
);
    // ---- receiver
    wire       rv, rf;
    wire [7:0] rdat;
    ik_uart_rx u_rx (.clk(clk), .rst(rst), .cpb(cpb), .line(rx_line), .v(rv), .d(rdat), .ferr(rf), .busy(rx_busy));
    assign tbl_byte = rdat;
    // shortest pulse on the line (baud finder)
    reg        lp = 1'b1;
    reg [19:0] pc = 20'd0;
    always @(posedge clk) begin
        lp <= rx_line;
        if (lp != rx_line) begin if (pc < minp) minp <= pc; pc <= 20'd0; end
        else if (pc != 20'hFFFFF) pc <= pc + 1'b1;
        if (minp_clr || clr) minp <= 20'hFFFFF;
    end

    // ---- relay queue: 16 bytes
    reg [7:0] rq [0:15];
    reg [3:0] rq_w = 4'd0, rq_r = 4'd0;
    reg [4:0] rq_n = 5'd0;
    // ---- inject queue: 512 bytes (block RAM)
    (* ram_style = "block" *) reg [7:0] iq [0:511];
    reg [8:0]  iq_w = 9'd0, iq_r = 9'd0;
    reg [9:0]  iq_n = 10'd0;
    reg [7:0]  iq_q = 8'd0;
    assign inj_lvl = iq_n;
    always @(posedge clk) if (inj_we && iq_n != 10'd512) iq[iq_w] <= wbyte;
    always @(posedge clk) iq_q <= iq[iq_r];

    // ---- transmitter
    reg        ts = 1'b0;
    reg [7:0]  td = 8'd0;
    wire       tbusy;
    wire       uline;
    ik_uart_tx u_tx (.clk(clk), .rst(rst), .cpb(cpb), .start(ts), .d(td), .short_stop(rq_n > 5'd1), .line(uline),
                     .busy(tbusy));
    assign tx_busy = tbusy || ts;
    assign tx_line = mode == 2'd1 ? rx_line : uline;
    assign idle = !rx_busy && !tx_busy && rq_n == 5'd0;

    // ---- byte handling
    wire       relay = mode == 2'd2;
    wire       hold = mode == 2'd3;
    wire       drop = tbl_e[9], swap = tbl_e[8];
    wire [7:0] outb = swap ? tbl_e[7:0] : rdat;
    wire       push = rv && !rf && relay && !drop && rq_n != 5'd16;
    reg        ipend = 1'b0;                // an inject byte was taken, its data arrives next clock
    always @(posedge clk) begin
        ev_v <= 1'b0; ts <= 1'b0;
        if (rv) begin
            ev_v <= 1'b1;
            if (rf)                       ev_d <= {3'd5, rdat, rdat};
            else if (mode == 2'd1 || mode == 2'd0) ev_d <= {3'd1, rdat, rdat};
            else if (hold)                ev_d <= {3'd4, rdat, rdat};
            else if (drop)                ev_d <= {3'd3, 8'd0, rdat};
            else if (rq_n == 5'd16)       ev_d <= {3'd7, outb, rdat};
            else                          ev_d <= {swap ? 3'd2 : 3'd1, outb, rdat};
        end
        if (push) begin rq[rq_w] <= outb; rq_w <= rq_w + 1'b1; end
        // start the next byte: relay first, then inject
        if (ipend) begin ipend <= 1'b0; ts <= 1'b1; td <= iq_q; end
        else if (!tbusy && !ts && mode >= 2'd2) begin
            if (rq_n != 5'd0) begin ts <= 1'b1; td <= rq[rq_r]; rq_r <= rq_r + 1'b1; end
            else if (iq_n != 10'd0) begin ipend <= 1'b1; iq_r <= iq_r + 1'b1; end
        end
        rq_n <= rq_n + (push ? 5'd1 : 5'd0) - ((!ipend && !tbusy && !ts && mode >= 2'd2 && rq_n != 5'd0) ? 5'd1 : 5'd0);
        if (inj_we && iq_n != 10'd512) iq_w <= iq_w + 1'b1;
        iq_n <= iq_n + ((inj_we && iq_n != 10'd512) ? 10'd1 : 10'd0)
                     - ((!ipend && !tbusy && !ts && mode >= 2'd2 && rq_n == 5'd0 && iq_n != 10'd0) ? 10'd1 : 10'd0);
        // counters
        if (rv && !rf && cnt[15:0] != 16'hFFFF) cnt[15:0] <= cnt[15:0] + 1'b1;
        if (ts && cnt[31:16] != 16'hFFFF) cnt[31:16] <= cnt[31:16] + 1'b1;
        if (rv && rf && errs[7:0] != 8'hFF) errs[7:0] <= errs[7:0] + 1'b1;
        if (rv && !rf && relay && !drop && rq_n == 5'd16 && errs[15:8] != 8'hFF) errs[15:8] <= errs[15:8] + 1'b1;
        if (rv && !rf && relay && drop && errs[23:16] != 8'hFF) errs[23:16] <= errs[23:16] + 1'b1;
        if (rv && !rf && relay && !drop && swap && errs[31:24] != 8'hFF) errs[31:24] <= errs[31:24] + 1'b1;
        if (clr) begin cnt <= 32'd0; errs <= 32'd0; end
        if (rst || (mode < 2'd2 && rq_n != 5'd0)) begin rq_w <= 4'd0; rq_r <= 4'd0; rq_n <= 5'd0; end
    end
    // bytes injected while the direction is OFF or WIRE wait until it is RELAY or HOLD

    // ---- the test source: a 16-byte queue and a transmitter
    reg [7:0] tq [0:15];
    reg [3:0] tq_w = 4'd0, tq_r = 4'd0;
    reg [4:0] tq_n = 5'd0;
    reg       tts = 1'b0;
    reg [7:0] ttd = 8'd0;
    wire      ttb;
    assign tst_lvl = tq_n;
    ik_uart_tx u_tt (.clk(clk), .rst(rst), .cpb(cpb), .start(tts), .d(ttd), .short_stop(1'b0), .line(test_line),
                     .busy(ttb));
    wire tpop = !ttb && !tts && tq_n != 5'd0;
    always @(posedge clk) begin
        tts <= 1'b0;
        if (tst_we && tq_n != 5'd16) begin tq[tq_w] <= wbyte; tq_w <= tq_w + 1'b1; end
        if (tpop) begin tts <= 1'b1; ttd <= tq[tq_r]; tq_r <= tq_r + 1'b1; end
        tq_n <= tq_n + ((tst_we && tq_n != 5'd16) ? 5'd1 : 5'd0) - (tpop ? 5'd1 : 5'd0);
    end
endmodule

// 8N1 receiver: samples each bit in its middle, re-synchronises on every start bit. ferr = the stop bit was low
// (a break or a wrong baud); after one, it waits for the line to go high before looking for the next start bit.
module ik_uart_rx (
    input  wire        clk,
    input  wire        rst,
    input  wire [19:0] cpb,
    input  wire        line,
    output reg         v = 1'b0,
    output reg  [7:0]  d = 8'd0,
    output reg         ferr = 1'b0,
    output wire        busy
);
    localparam IDLE = 3'd0, START = 3'd1, DATA = 3'd2, STOP = 3'd3, WAITH = 3'd4;
    reg [2:0]  st = IDLE;
    reg [19:0] c = 20'd0;
    reg [2:0]  n = 3'd0;
    reg [7:0]  sh = 8'd0;
    assign busy = st != IDLE;
    always @(posedge clk) begin
        v <= 1'b0;
        if (rst) st <= IDLE;
        else case (st)
            IDLE:  if (!line) begin c <= {1'b0, cpb[19:1]} - 1'b1; st <= START; end
            START: if (c != 20'd0) c <= c - 1'b1;
                   else if (line) st <= IDLE;                  // a glitch, not a start bit
                   else begin c <= cpb - 1'b1; n <= 3'd0; st <= DATA; end
            DATA:  if (c != 20'd0) c <= c - 1'b1;
                   else begin sh <= {line, sh[7:1]}; c <= cpb - 1'b1; n <= n + 1'b1; if (n == 3'd7) st <= STOP; end
            STOP:  if (c != 20'd0) c <= c - 1'b1;
                   else begin v <= 1'b1; d <= sh; ferr <= !line; st <= line ? IDLE : WAITH; end
            default: if (line) st <= IDLE;
        endcase
    end
endmodule

// 8N1 transmitter. short_stop: a 3/4-bit stop bit (to catch up with a slightly fast sender).
module ik_uart_tx (
    input  wire        clk,
    input  wire        rst,
    input  wire [19:0] cpb,
    input  wire        start,
    input  wire [7:0]  d,
    input  wire        short_stop,
    output reg         line = 1'b1,
    output wire        busy
);
    reg [9:0]  sh = 10'h3FF;
    reg [3:0]  n = 4'd0;                    // bits left to put on the line
    reg [19:0] c = 20'd0;                   // clocks left of the bit on the line now
    assign busy = n != 4'd0 || c != 20'd0;
    always @(posedge clk) begin
        if (rst) begin n <= 4'd0; c <= 20'd0; line <= 1'b1; end
        else if (c != 20'd0) c <= c - 1'b1;
        else if (n != 4'd0) begin
            line <= sh[0]; sh <= {1'b1, sh[9:1]};
            c <= (n == 4'd1 && short_stop) ? cpb - (cpb >> 2) - 1'b1 : cpb - 1'b1;
            n <= n - 1'b1;
        end else begin
            line <= 1'b1;
            if (start) begin sh <= {1'b1, d, 1'b0}; n <= 4'd10; end
        end
    end
endmodule
