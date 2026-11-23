`timescale 1ns / 1ps
// [orphan] ORPHAN LOGIC LAB: SPEKTOR / INJEKTOR 3000 -- the SPEKTOR capture core (16-channel logic analyzer).
// by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later.
//
// 16 channels sampled at 100 MHz / (DIV + 1). Samples go into a ring of 16384 x 32-bit block RAM words:
//   RAW mode  two samples per word ({newer, older}): 32768 samples
//   RLE mode  one word per run: {run length - 1 (16 bits), value (16 bits)}: long captures of slow buses
// A 4-stage trigger sequencer: stage s matches when (in & MASK_s) == (VALUE_s & MASK_s) and every channel in RISE_s
// just went 0 -> 1 and every channel in FALL_s just went 1 -> 0 (a channel in both = any edge). A stage must match
// COUNT_s + 1 times (counting matching samples), then the next
// stage is armed; after the last used stage (STAGES) the capture triggers. PRE words are kept before the trigger,
// then POST words are written after it.
//
// Registers (word index, slot SLOT):
//   0 CTRL    write: [0] arm  [1] stop  [2] force trigger           1 STATUS [0] armed [1] triggered [2] done [3] rle
//   2 DIV     sample divider (0 = 100 MHz)                        3 MODE   [0] rle  [1] test source  [3:2] stages-1
//   4 POST    words to write after the trigger (1 .. 16384)      5 TRIG_AT  the trigger: RAW {word, half}, RLE {word}
//   6 WPTR    ring index of the next word (read)                  7 FILLED  words written since arm (saturating)
//   8 LIVE    the 16 channels now (read)                          9 SAMPLES samples taken since arm (read)
//   10 + 4s   stage s: MASK [15:0] | VALUE [31:16]    11 + 4s: RISE [15:0] | FALL [31:16]    12 + 4s: COUNT
//   127 ID "SPK1"
//   768..1023 read: the next ring word, starting at RDPTR (word 30 write); the read pointer counts up and wraps
//   30 RDPTR (write)
//   40 + c    MAP: channel c samples header pin SEL (0..35 = J1.5 J1.11 J1.12 J1.15 J2.5 .. J9.15), read/write
// Channel map: all 36 hashboard header pins come in; each channel picks any of them (a crossbar), so any J1..J9
// header can be a probe port. Default: CH0..15 = J6, J7, J8, J9 (the S9's stock headers first).
module spektor #(parameter [3:0] SLOT = 4'd1) (
    input  wire        clk,                 // 100 MHz
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    input  wire [35:0] pins,                // all 36 header pins: J1.5 J1.11 J1.12 J1.15, J2.5 .. J9.15
    output wire        led_armed,
    output wire        led_trig
);
    reg [15:0] a_r = 16'd0;
    reg [31:0] wd = 32'd0;
    reg        we_r = 1'b0, re_r = 1'b0;
    always @(posedge clk) begin a_r <= bus_addr; wd <= bus_wdata; we_r <= bus_we; re_r <= bus_re; end
    wire sel = (a_r[15:12] == SLOT);
    wire [9:0] idx = a_r[11:2];
    wire wr = we_r && sel;

    // ---- registers
    reg [23:0] div = 24'd0;
    reg        rle = 1'b0, tsrc = 1'b0;
    reg [1:0]  nstg = 2'd0;
    reg [14:0] post = 15'd8192;
    reg [15:0] smask [0:3], sval [0:3], sedge [0:3], srise [0:3];
    reg [15:0] scnt [0:3];
    reg [5:0]  cmap [0:15];                  // the channel map
    integer k;
    initial for (k = 0; k < 4; k = k + 1) begin smask[k] = 0; sval[k] = 0; sedge[k] = 0; srise[k] = 0; scnt[k] = 0; end
    initial for (k = 0; k < 16; k = k + 1) cmap[k] = 6'd20 + k;
    wire cmd_arm = wr && idx == 10'd0 && wd[0];
    wire cmd_stop = wr && idx == 10'd0 && wd[1];
    wire cmd_force = wr && idx == 10'd0 && wd[2];
    always @(posedge clk) if (wr) begin
        if (idx == 10'd2) div <= wd[23:0];
        if (idx == 10'd3) begin rle <= wd[0]; tsrc <= wd[1]; nstg <= wd[3:2]; end
        if (idx >= 10'd40 && idx < 10'd56) cmap[idx[3:0] - 4'd8] <= (wd[5:0] > 6'd35) ? 6'd35 : wd[5:0];
        if (idx == 10'd4) post <= wd[15] ? 15'd16384 : (wd[14:0] == 15'd0) ? 15'd1 : wd[14:0];
        if (idx >= 10'd10 && idx < 10'd26) case (idx[1:0] - 2'd2)
            2'd0: begin smask[(idx - 10'd10) >> 2] <= wd[15:0]; sval[(idx - 10'd10) >> 2] <= wd[31:16]; end
            2'd1: begin srise[(idx - 10'd10) >> 2] <= wd[15:0]; sedge[(idx - 10'd10) >> 2] <= wd[31:16]; end   // rise, fall
            2'd2: scnt[(idx - 10'd10) >> 2] <= wd[15:0];
            default: ;
        endcase
    end

    // ---- inputs: two flip-flops (asynchronous pins), or the built-in test pattern
    reg [35:0] p1 = 36'd0, p2 = 36'd0;
    reg [15:0] p3 = 16'd0;
    reg [31:0] tcount = 32'd0;
    integer c;
    always @(posedge clk) begin p1 <= pins; p2 <= p1; tcount <= tcount + 1'b1;
        for (c = 0; c < 16; c = c + 1) p3[c] <= p2[cmap[c]];                 // the crossbar (same delay for all)
    end
    // test source: ch0 = 50 MHz/2^k style counter bits, plus a slow "UART-ish" walking pattern on ch8..15
    wire [15:0] tpat = {tcount[27:20], tcount[11:4]};
    wire [15:0] live = tsrc ? tpat : p3;

    // ---- sample strobe
    reg [23:0] dc = 24'd0;
    reg        st = 1'b0;
    always @(posedge clk) begin
        st <= 1'b0;
        if (dc == 24'd0) begin dc <= div; st <= 1'b1; end else dc <= dc - 1'b1;
    end

    // ---- state
    localparam S_IDLE = 2'd0, S_PRE = 2'd1, S_POST = 2'd2, S_DONE = 2'd3;
    reg [1:0]  state = S_IDLE;
    reg [13:0] wp = 14'd0;                  // next ring word
    reg [14:0] filled = 15'd0;
    reg [14:0] left = 15'd0;                // words still to write after the trigger
    reg [14:0] trig_at = 15'd0;          // RAW: {word, half} = the exact sample; RLE: the run's word
    reg [31:0] samples = 32'd0;
    reg        triggered = 1'b0;
    reg [1:0]  stg = 2'd0;
    reg [15:0] smatch = 16'd0;
    reg [15:0] prev = 16'd0;
    reg        half = 1'b0;                 // RAW: a word holds 2 samples
    reg [15:0] held = 16'd0;                // RAW: the older sample of the pair / RLE: the run's value
    reg [15:0] run = 16'd0;                 // RLE: run length - 1
    reg        have = 1'b0;                 // RLE: a run is open
    reg        mwe = 1'b0;
    reg [31:0] mwd = 32'd0;
    reg [13:0] mwa = 14'd0;

    // trigger: the current stage against this sample (srise = channels that must rise, sedge = must fall)
    wire [15:0] chg = live ^ prev;
    wire [15:0] rm = srise[stg], fm = sedge[stg];
    wire [15:0] eok = ~(rm | fm) | (chg & ((rm & live) | (fm & ~live)));
    wire pat_ok = ((live & smask[stg]) == (sval[stg] & smask[stg]));
    wire stage_hit = pat_ok && (&eok);
    // the write pointer as of this clock (a write issued last clock bumps wp this clock)
    wire [13:0] wpn = mwe ? wp + 1'b1 : wp;
    // the trigger fires on this sample: it then starts a fresh RLE run, so its position is exact
    wire fire = state == S_PRE && (cmd_force || (stage_hit && smatch == scnt[stg] && stg == nstg));
    wire [14:0] here = rle ? {1'b0, wpn + {13'd0, have}} : {wpn, half};   // where this sample is stored

    always @(posedge clk) begin
        mwe <= 1'b0;
        if (!rstn || cmd_stop) begin state <= S_IDLE; triggered <= 1'b0; end
        else if (cmd_arm) begin
            state <= S_PRE; triggered <= 1'b0; wp <= 14'd0; filled <= 15'd0; samples <= 32'd0;
            stg <= 2'd0; smatch <= 16'd0; half <= 1'b0; have <= 1'b0; run <= 16'd0; prev <= live;
        end else if (st && (state == S_PRE || state == S_POST)) begin
            samples <= samples + 1'b1;
            prev <= live;
            // ---- store
            if (!rle) begin
                if (!half) begin held <= live; half <= 1'b1; end
                else begin mwe <= 1'b1; mwd <= {live, held}; mwa <= wpn; half <= 1'b0; end
            end else begin
                if (!have) begin held <= live; run <= 16'd0; have <= 1'b1; end
                else if (live == held && run != 16'hFFFF && !fire) run <= run + 1'b1;
                else begin mwe <= 1'b1; mwd <= {run, held}; mwa <= wpn; held <= live; run <= 16'd0; end
            end
            // ---- trigger sequencer (in PRE)
            if (state == S_PRE && (cmd_force || stage_hit)) begin
                if (!cmd_force && smatch != scnt[stg]) smatch <= smatch + 1'b1;
                else if (!cmd_force && stg != nstg) begin stg <= stg + 1'b1; smatch <= 16'd0; end
                else begin state <= S_POST; triggered <= 1'b1; trig_at <= here; left <= post; end
            end else if (state == S_PRE) smatch <= 16'd0;
        end else if (cmd_force && state == S_PRE) begin
            state <= S_POST; triggered <= 1'b1; trig_at <= rle ? {1'b0, wpn} : {wpn, half}; left <= post;
        end
        if (mwe) begin
            wp <= wp + 1'b1;
            if (filled != 15'h7FFF) filled <= filled + 1'b1;
            if (state == S_POST) begin
                if (left <= 15'd1) state <= S_DONE;
                left <= left - 1'b1;
            end
        end
    end

    // ---- the ring
    (* ram_style = "block" *) reg [31:0] ring [0:16383];
    always @(posedge clk) if (mwe) ring[mwa] <= mwd;
    // reads: pops, the next word fetched on the same clock (back-to-back reads stay in order)
    reg [13:0] rp = 14'd0;
    reg [31:0] rq = 32'd0;
    wire pop = re_r && sel && idx[9:8] == 2'b11;
    wire [13:0] rp_n = (wr && idx == 10'd30) ? wd[13:0] : pop ? rp + 1'b1 : rp;
    always @(posedge clk) begin rp <= rp_n; rq <= ring[rp_n]; end

    always @(posedge clk) if (re_r) begin
        if (!sel) bus_rdata <= 32'd0;
        else if (idx[9:8] == 2'b11) bus_rdata <= rq;
        else case (idx)
            10'd1: bus_rdata <= {28'd0, rle, state == S_DONE, triggered, state == S_PRE || state == S_POST};
            10'd2: bus_rdata <= {8'd0, div};
            10'd3: bus_rdata <= {28'd0, nstg, tsrc, rle};
            10'd4: bus_rdata <= {17'd0, post};
            10'd5: bus_rdata <= {17'd0, trig_at};
            10'd6: bus_rdata <= {18'd0, wp};
            10'd7: bus_rdata <= {17'd0, filled};
            10'd8: bus_rdata <= {16'd0, live};
            10'd9: bus_rdata <= samples;
            10'd127: bus_rdata <= 32'h53504B31;          // "SPK1"
            10'd56: bus_rdata <= {28'd0, p2[35:32]};     // raw header pins (J9) for the pin finder
            10'd57: bus_rdata <= p2[31:0];               // raw header pins J1..J8
            default: bus_rdata <= (idx >= 10'd40 && idx < 10'd56) ? {26'd0, cmap[idx[3:0] - 4'd8]} : 32'd0;
        endcase
    end
    assign led_armed = state == S_PRE;
    assign led_trig = triggered;
endmodule
