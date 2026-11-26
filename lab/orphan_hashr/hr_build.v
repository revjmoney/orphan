`timescale 1ns / 1ps
// [orphan] H4SHR-CH3KR work builder (slot 3 registers, slot 4 job memory). From a stratum job in its memory it builds
// every work itself: next extranonce2, coinbase double SHA-256 (with padding done here), merkle fold, header, midstate,
// tail. One SHA-256 core (hr_sha.v, Ardzy's) is time-shared; a work of a 300-byte coinbase with 16 branches is
// 55 compressions, about 81 us (the block goes into the core a word a clock). The C++ work model (cpp/work.cpp) is the known answer (sim/tb_build.v).
//
// Slot 3 registers (word index):
//   0, 127 ID "HSB1"
//   1 CTRL (w) [0] enable  [1] bank to activate  [2] flip (activate that bank, extranonce2 from its EN2_START)
//             [3] clean with the flip (the work being built and the ready work are dropped, `clean` pulses)
//   2 STATUS (r) [0] enabled  [1] exhausted (en2 ran out: no more works until the next flip)  [2] active bank
//                [3] a work is ready
//   3 BUILT (r) works handed out   4 STALLS (r) exhaustions   5 EN2_HI (r) next en2 [47:32]   6 EN2_LO (r) [31:0]
// Slot 4 job memory (write only), bank b at word 512*b + i:
//   0 TAG[15:0]  1 VERSION  2 NTIME  3 NBITS  4..11 PREVHASH (all header bytes, byte 0 in [31:24])
//   12 CB_LEN (bytes, 1..1024)  13 EN2_OFF  14 EN2_SIZE (1..8)  15 NBRANCH (0..16)  16 EN2_START[47:32]
//   17 EN2_START[31:0]  64..191 branches (16 x 8 words)  256..511 coinbase template (byte 0 of a word in [31:24])
// Work port: w_valid, w_word = word w_idx of the ready work (0 TAG = {tag, en2[47:32]}, 1 TAG2 = en2[31:0],
// 2..4 tail = header bytes 72..75, 68..71, 64..67, 5..12 midstate H7..H0); w_take (one clock) hands it over.
// The extranonce2 is written big-endian (low byte last) over EN2_SIZE bytes at EN2_OFF and never repeats within a
// flip: when it no longer fits EN2_SIZE bytes (or 48 bits) the builder stops and counts a stall.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.

module hr_build #(parameter [3:0] SLOT = 4'd3) (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    output reg         w_valid = 1'b0,
    input  wire [3:0]  w_idx,
    output reg  [31:0] w_word,
    input  wire        w_take,
    output reg         clean = 1'b0
);
    localparam [255:0] IV = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;

    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];
    wire wr = bus_we && sel;
    wire rd = bus_re && sel;

    // ------------------------------------------------------------------ job memory: both banks, one BRAM
    reg  [31:0] mem [0:1023];
    reg  [31:0] dout = 32'd0;
    reg  [9:0]  raddr;
    always @(posedge clk) begin
        if (bus_we && bus_addr[15:12] == SLOT + 4'd1) mem[bus_addr[11:2]] <= bus_wdata;
        dout <= mem[raddr];
    end

    // ------------------------------------------------------------------ SHA core
    // The block goes straight into the core's message schedule one word a clock (no block register here), and the
    // chaining value is either IV or the core's own last h_out, which holds still from done to the next start.
    reg          sha_start = 1'b0;
    reg          use_iv = 1'b1;
    reg          win_we;
    reg  [31:0]  win;
    wire         sha_busy, sha_done;
    wire [255:0] h_out;
    hr_sha256 u_sha (.clk(clk), .start(sha_start), .h_in(use_iv ? IV : h_out), .win_we(win_we), .win(win),
                     .busy(sha_busy), .done(sha_done), .h_out(h_out));

    // ------------------------------------------------------------------ state
    localparam S_IDLE = 4'd0, S_PAR = 4'd1, S_CHK = 4'd2, S_CBR = 4'd3, S_SHA = 4'd4, S_SHW = 4'd5, S_BR0 = 4'd6,
               S_BRR = 4'd7, S_HDRR = 4'd8, S_DONE = 4'd9, S_FEED = 4'd10, S_CHK0 = 4'd11;
    localparam PH_CB = 3'd0, PH_CB2 = 3'd1, PH_BA = 3'd2, PH_BB = 3'd3, PH_BC = 3'd4, PH_HDR = 3'd5;
    // S_FEED sources: a digest block (root words, then its padding), the 64-byte message's padding block, the root
    // before a branch (8 words), the root H0..H6 ending the header (8 rotations, the last one not shifted in)
    localparam F_DG = 2'd0, F_PAD = 2'd1, F_RT8 = 2'd2, F_RT7 = 2'd3;
    reg [3:0]  st = S_IDLE;
    reg [2:0]  ph = PH_CB;
    reg [1:0]  fsrc = F_DG;
    reg        enable = 1'b0, abank = 1'b0, en2_load = 1'b0, exhausted = 1'b0;
    reg [48:0] en2 = 49'd0;                        // bit 48: ran past 48 bits
    reg [31:0] built = 32'd0, stalls = 32'd0;

    reg        wbank = 1'b0;
    reg [15:0] wtag = 16'd0;
    reg [31:0] ntime = 32'd0, nbits = 32'd0;
    reg [10:0] cblen = 11'd0, eoff = 11'd0;
    reg [3:0]  esz = 4'd0;
    reg [4:0]  nbr = 5'd0;
    reg [47:0] e2s = 48'd0, wen2 = 48'd0;
    reg [63:0] en2al = 64'd0;                      // the en2 bytes, first one in [63:56]
    reg [4:0]  cbn = 5'd0, nblk = 5'd0, bi = 5'd0;
    reg [255:0] root = 256'd0;                     // rotated a word at a time when fed; 8 rotations restore it
    reg [4:0]  rc = 5'd0, rcq = 5'd0;              // read counter, and the one whose data is in dout
    reg        rvq = 1'b0;                         // dout holds a read issued last clock

    // the next en2 (from the bank's EN2_START after a flip) and whether it fits EN2_SIZE bytes and 48 bits
    wire [48:0] e_next = en2_load ? {1'b0, e2s} : en2;
    wire        e_fits = !e_next[48] && (esz >= 4'd6 || (e_next[47:0] >> {esz, 3'b000}) == 48'd0);
    reg  [48:0] e_nq = 49'd0;                     // e_next and e_fits, registered in S_CHK0
    reg         e_fq = 1'b0;

    // read addresses
    reg [8:0] par_a;
    always @(*) begin
        case (rc[3:0])
            4'd0: par_a = 9'd0;  4'd1: par_a = 9'd2;  4'd2: par_a = 9'd3;  4'd3: par_a = 9'd12; 4'd4: par_a = 9'd13;
            4'd5: par_a = 9'd14; 4'd6: par_a = 9'd15; 4'd7: par_a = 9'd16; default: par_a = 9'd17;
        endcase
        case (st)
            S_PAR:   raddr = {wbank, par_a};
            S_CBR:   raddr = {wbank, 9'd256 + {cbn, 4'd0} + {5'd0, rc[3:0]}};
            S_BRR:   raddr = {wbank, 9'd64 + {1'b0, bi[3:0], 3'd0} + {6'd0, rc[2:0]}};
            S_HDRR:  raddr = {wbank, rc == 5'd0 ? 9'd1 : 9'd3 + {5'd0, rc[3:0]}};
            default: raddr = {wbank, 9'd0};
        endcase
    end

    // One coinbase word at byte position p0 (p0 + j, j = 0..3, for its bytes): template, en2 or padding. The two
    // distances p0 - EN2_OFF and CB_LEN - p0 are worked out once per word; each byte then needs only a 6-bit add.
    // A distance outside -16..15 decides all four bytes the same way, so 5 bits of it are enough.
    wire [10:0] p0 = {cbn, 6'd0} + {4'd0, rcq[3:0], 2'b00};
    wire [11:0] dk = {1'b0, p0} - {1'b0, eoff};                 // p0 - EN2_OFF
    wire [11:0] dq = {1'b0, cblen} - {1'b0, p0};                // CB_LEN - p0
    wire        dk_s = (dk[11:4] == 8'h00) || (dk[11:4] == 8'hff);
    wire        dq_s = (dq[11:4] == 8'h00) || (dq[11:4] == 8'hff);
    wire        dq_big = !dq[11] && !dq_s;                      // CB_LEN - p0 >= 16: all template
    // (the per-word values come in as arguments: a function reading changing module wires would not be
    // re-evaluated in simulation when they change)
    function [7:0] cbyte(input [1:0] j, input [7:0] m, input [4:0] dk5, input [4:0] dq5, input dks, input dqs,
                         input dqb, input [3:0] sz, input [63:0] e2b);
        reg [5:0] k, q;
        begin
            k = {dk5[4], dk5} + {4'd0, j};                      // p - EN2_OFF
            q = {dq5[4], dq5} - {4'd0, j};                      // CB_LEN - p
            if (dqb || (dqs && !q[5] && q != 6'd0))             // p < CB_LEN
                cbyte = (dks && !k[5] && k[4:0] < {1'b0, sz}) ? e2b[63 - 8 * k[2:0] -: 8] : m;
            else if (dqs && q == 6'd0) cbyte = 8'h80;           // p == CB_LEN
            else cbyte = 8'h00;
        end
    endfunction
    wire        last_blk = (cbn == nblk - 5'd1);
    wire [31:0] cb_word = (last_blk && rcq[3:0] == 4'd14) ? 32'd0 :
                          (last_blk && rcq[3:0] == 4'd15) ? {18'd0, cblen, 3'd0} :
                          {cbyte(2'd0, dout[31:24], dk[4:0], dq[4:0], dk_s, dq_s, dq_big, esz, en2al),
                           cbyte(2'd1, dout[23:16], dk[4:0], dq[4:0], dk_s, dq_s, dq_big, esz, en2al),
                           cbyte(2'd2, dout[15:8],  dk[4:0], dq[4:0], dk_s, dq_s, dq_big, esz, en2al),
                           cbyte(2'd3, dout[7:0],   dk[4:0], dq[4:0], dk_s, dq_s, dq_big, esz, en2al)};

    // the word shifted into the core this clock
    wire        rot = (st == S_FEED) && (fsrc != F_PAD) && !(fsrc == F_DG && rc[3]);
    always @(*) begin
        win_we = 1'b0;
        win = dout;
        case (st)
            S_CBR:  begin win_we = rvq; win = cb_word; end
            S_BRR, S_HDRR: win_we = rvq;
            S_FEED: begin
                win_we = !(fsrc == F_RT7 && rc[2:0] == 3'd7);
                if (rot) win = root[255:224];
                else if (fsrc == F_DG) win = (rc[3:0] == 4'd8) ? 32'h80000000 : (rc[3:0] == 4'd15) ? 32'h00000100 : 32'd0;
                else win = (rc[3:0] == 4'd0) ? 32'h80000000 : (rc[3:0] == 4'd15) ? 32'h00000200 : 32'd0;
            end
            default: ;
        endcase
    end

    // ready work
    reg [31:0]  o_tag = 32'd0, o_tag2 = 32'd0, o_t0 = 32'd0, o_t1 = 32'd0, o_t2 = 32'd0;
    reg [255:0] o_mid = 256'd0;
    always @(*) begin
        case (w_idx)
            4'd0: w_word = o_tag;  4'd1: w_word = o_tag2; 4'd2: w_word = o_t0; 4'd3: w_word = o_t1; 4'd4: w_word = o_t2;
            4'd5: w_word = o_mid[31:0];    4'd6: w_word = o_mid[63:32];   4'd7: w_word = o_mid[95:64];
            4'd8: w_word = o_mid[127:96];  4'd9: w_word = o_mid[159:128]; 4'd10: w_word = o_mid[191:160];
            4'd11: w_word = o_mid[223:192]; 4'd12: w_word = o_mid[255:224];
            default: w_word = 32'd0;
        endcase
    end

    always @(posedge clk) begin
        sha_start <= 1'b0;
        clean <= 1'b0;
        rvq <= 1'b0;
        if (w_take && w_valid) w_valid <= 1'b0;
        if (rot) root <= {root[223:0], root[255:224]};
        case (st)
            S_IDLE: if (enable && !exhausted && !sha_busy && !sha_done && !sha_start) begin   // a dropped work's SHA has finished
                wbank <= abank;
                rc <= 5'd0;
                st <= S_PAR;
            end
            S_PAR: begin
                if (rc < 5'd9) begin rc <= rc + 1'b1; rvq <= 1'b1; rcq <= rc; end
                if (rvq) case (rcq[3:0])
                    4'd0: wtag <= dout[15:0];
                    4'd1: ntime <= dout;
                    4'd2: nbits <= dout;
                    4'd3: cblen <= dout[10:0];
                    4'd4: eoff <= dout[10:0];
                    4'd5: esz <= dout[3:0];
                    4'd6: nbr <= dout[4:0];
                    4'd7: e2s[47:32] <= dout[15:0];
                    default: begin e2s[31:0] <= dout; st <= S_CHK0; end
                endcase
            end
            S_CHK0: begin                               // the fit check gets its own clock (timing)
                e_nq <= e_next; e_fq <= e_fits; st <= S_CHK;
            end
            S_CHK: begin
                en2_load <= 1'b0;
                if (e_fq) begin
                    wen2 <= e_nq[47:0];
                    en2 <= e_nq + 49'd1;
                    en2al <= {16'd0, e_nq[47:0]} << {4'd8 - esz, 3'b000};
                    nblk <= ((cblen + 11'd8) >> 6) + 5'd1;
                    cbn <= 5'd0;
                    rc <= 5'd0;
                    use_iv <= 1'b1;
                    st <= S_CBR;
                end else begin
                    en2 <= e_nq;
                    exhausted <= 1'b1;
                    stalls <= stalls + 1'b1;
                    st <= S_IDLE;
                end
            end
            S_CBR: begin                                // 16 template words -> one padded coinbase block
                if (rc < 5'd16) begin rc <= rc + 1'b1; rvq <= 1'b1; rcq <= rc; end
                if (rvq && rcq == 5'd15) begin ph <= PH_CB; st <= S_SHA; end
            end
            S_SHA: if (!sha_busy && !sha_done) begin sha_start <= 1'b1; st <= S_SHW; end
            S_SHW: if (sha_done) begin
                rc <= 5'd0;
                case (ph)
                    PH_CB: if (last_blk) begin          // second SHA over the 32-byte digest
                               root <= h_out; use_iv <= 1'b1; fsrc <= F_DG; ph <= PH_CB2; st <= S_FEED;
                           end else begin
                               use_iv <= 1'b0; cbn <= cbn + 1'b1; st <= S_CBR;
                           end
                    PH_CB2: begin root <= h_out; bi <= 5'd0; st <= S_BR0; end
                    PH_BA: begin                        // root || branch is 64 bytes: the padding block is constant
                               use_iv <= 1'b0; fsrc <= F_PAD; ph <= PH_BB; st <= S_FEED;
                           end
                    PH_BB: begin root <= h_out; use_iv <= 1'b1; fsrc <= F_DG; ph <= PH_BC; st <= S_FEED; end
                    PH_BC: begin root <= h_out; bi <= bi + 1'b1; st <= S_BR0; end
                    default: st <= S_DONE;              // PH_HDR: h_out is the midstate
                endcase
            end
            S_BR0: begin
                rc <= 5'd0;
                if (bi < nbr && bi < 5'd16) begin fsrc <= F_RT8; st <= S_FEED; end
                else st <= S_HDRR;
            end
            S_FEED: begin
                rc <= rc + 1'b1;
                if (fsrc == F_RT8 && rc[2:0] == 3'd7) begin rc <= 5'd0; st <= S_BRR; end
                else if (fsrc == F_RT7 && rc[2:0] == 3'd7) begin use_iv <= 1'b1; ph <= PH_HDR; st <= S_SHA; end
                else if (rc[3:0] == 4'd15) st <= S_SHA;
            end
            S_BRR: begin                                // the branch's 8 words after the root's
                if (rc < 5'd8) begin rc <= rc + 1'b1; rvq <= 1'b1; rcq <= rc; end
                if (rvq && rcq == 5'd7) begin use_iv <= 1'b1; ph <= PH_BA; st <= S_SHA; end
            end
            S_HDRR: begin                               // version, prevhash, then the root's H0..H6 (S_FEED)
                if (rc < 5'd9) begin rc <= rc + 1'b1; rvq <= 1'b1; rcq <= rc; end
                if (rvq && rcq == 5'd8) begin rc <= 5'd0; fsrc <= F_RT7; st <= S_FEED; end
            end
            S_DONE: if (!w_valid || w_take) begin
                o_tag <= {wtag, wen2[47:32]};
                o_tag2 <= wen2[31:0];
                o_t0 <= nbits; o_t1 <= ntime; o_t2 <= root[31:0];
                o_mid <= h_out;
                w_valid <= 1'b1;
                built <= built + 1'b1;
                st <= S_IDLE;
            end
            default: st <= S_IDLE;
        endcase

        if (wr && idx == 10'd1) begin                  // CTRL wins over everything above
            enable <= bus_wdata[0];
            if (bus_wdata[2]) begin
                abank <= bus_wdata[1];
                en2_load <= 1'b1;
                exhausted <= 1'b0;
                st <= S_IDLE;
                sha_start <= 1'b0;                  // a start set this clock would hash a block never fed
                if (bus_wdata[3]) begin w_valid <= 1'b0; clean <= 1'b1; end
            end
        end
        if (!rstn) begin
            st <= S_IDLE; enable <= 1'b0; exhausted <= 1'b0; en2_load <= 1'b0; w_valid <= 1'b0;
            built <= 32'd0; stalls <= 32'd0;
        end
    end

    // ------------------------------------------------------------------ bus reads
    always @(posedge clk) begin
        if (rd) begin
            case (idx)
                10'd0, 10'd127: bus_rdata <= 32'h48534231;
                10'd2: bus_rdata <= {28'd0, w_valid, abank, exhausted, enable};
                10'd3: bus_rdata <= built;
                10'd4: bus_rdata <= stalls;
                10'd5: bus_rdata <= {16'd0, en2[47:32]};
                10'd6: bus_rdata <= en2[31:0];
                default: bus_rdata <= 32'd0;
            endcase
        end else if (!sel) bus_rdata <= 32'd0;
    end
endmodule
