`timescale 1ns / 1ps
// Orphan Radio: a small AM receiver in the FPGA (JMSCNC, Rev. J. Money 2026, GPL-3 + attribution).
//
//   1-bit input sampled at 100 MHz  ->  x tunable NCO (I and Q, no multiplier: the input is +-1)
//   ->  CIC 4th order /64 (1.5625 MHz)  ->  CIC 4th order /128 (12.207 kHz complex baseband, +-6 kHz)
//   ->  AM detector |I,Q| (alpha-max-beta-min)  ->  DC block  ->  audio gain  ->  capture FIFO + I2S.
//
// Input modes (CTRL[2:1]):
//   0  plain pin: J8 pin 12 read as a 1-bit signal (loopback wire from the test transmitter)
//   1  internal loopback: the test transmitter's bit, no wire
//   2  zero-parts antenna: J8 pin 12 is its own 1-bit sigma-delta ADC. Whenever it reads high the FPGA pulls
//      it low for SD_PULSE clocks, so the node hovers at the input threshold (the FPGA's weak pull-up + pin
//      capacitance); RF on a wire antenna on the pin changes how often that happens.
//   3  RC sigma-delta: J8 pin 15 drives the inverted input bit back through R to the input node (R + C parts).
// Test transmitter: J8 pin 5, a square-wave carrier whose duty cycle carries an AM tone. Keep it on short wires.
//
// Registers (word index):
//   0 CTRL       [0] capture on  [2:1] input mode  [3] test transmitter drives J8 pin 5  [4] I2S on  [5] dither
//   1 RX_FREQ    receive NCO step (f = step * 100 MHz / 2^32)
//   2 IQ_SHIFT   extra baseband gain 0..15 (x 2^n)
//   3 AF_GAIN    audio gain, audio = (|IQ| - average) * gain / 1024
//   4 TX_FREQ    test transmitter carrier step     5 TX_TONE  tone step (per 100 MHz clock)
//   6 TX_DEPTH   modulation depth 0..255           7 SD_PULSE zero-parts mode pull-low length, clocks 1..15
//   8 CARRIER    read: average |IQ| (signal strength)
//   9 CAP_LEVEL  read: words waiting (2 per sample: {I,Q} then {audio, carrier})
//  10 ID         "RAD1"
//  11 DENSITY    read: ones in the input over the last 8192 clocks (bias check: ~4096 = centered)
//  512..1023     read: oldest capture word, removes it (any address in the window, so a block read works)
module orphan_radio #(parameter [3:0] SLOT = 4'd1) (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    input  wire        rx_in,          // J8 pin 12 (from the IOBUF)
    output wire        rx_pull_low,    // J8 pin 12: 1 = drive low (zero-parts mode)
    output reg         fb_out = 1'b0,  // J8 pin 15
    output reg         tx_out = 1'b0,  // J8 pin 5
    output wire        mclk,
    output wire        bclk,
    output reg         lrclk = 1'b0,
    output reg         dout = 1'b0,
    output wire [7:0]  led_level,      // signal strength for the LEDs
    output wire [7:0]  led_audio
);
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    reg [5:0]  ctrl = 6'b100011;          // capture on, internal loopback
    reg [31:0] rx_freq = 32'd42949673;    // 1000 kHz
    reg [3:0]  iq_shift = 4'd0;
    reg [15:0] af_gain = 16'd2048;
    reg [31:0] tx_freq = 32'd42949673;    // 1000 kHz
    reg [31:0] tx_tone = 32'd26844;       // 625 Hz
    reg [7:0]  tx_depth = 8'd200;
    reg [3:0]  sd_pulse = 4'd1;
    reg [1:0]  force_t = 2'd0;            // debug: 0 normal, 1 always input (released), 2 always drive low
    reg [4:0]  nb_k = 5'd0;               // noise blanker threshold (x average), 0 = off
    reg [3:0]  nb_len = 4'd6;             // blank length, samples at 1.5625 MHz (+2 before the spike)
    reg        hum_on = 1'b0;
    reg [15:0] hum_d = 16'd52083;         // hum comb delay, samples in 8.8 fixed point (fs / 60 Hz = 203.45)
    reg [15:0] hum_r = 16'd31130;         // hum comb pole radius, Q15 (0.95): closer to 1 = narrower notches
    reg signed [15:0] hc0 = 16'sd0, hc1 = 16'sd16384, hc2 = 16'sd0, hc3 = 16'sd0;   // cubic weights, Q14
    reg [31:0] freq_b = 32'd42949673, freq_c = 32'd42949673, freq_d = 32'd42949673;   // tuners B..D
    reg [31:0] pan_freq = 32'd42949673;   // wide panadapter centre
    reg [3:0]  pan_rlog = 4'd6;           // panadapter decimation 2^4 .. 2^8 (6.25 MHz .. 390 kHz wide)
    reg [3:0]  pan_gain = 4'd8;           // panadapter extra gain x 2^n
    wire [1:0] mode = ctrl[2:1];

    // ---------------------------------------------------------------- test transmitter
    reg [31:0] tx_ph = 32'd0, tone_ph = 32'd0;
    wire signed [15:0] tone;
    ardzy_sine_rom u_tone (.clk(clk), .a(tone_ph[31:22]), .q(tone));
    reg signed [24:0] tone_m = 25'sd0;
    reg [7:0]  duty = 8'd64;
    wire signed [9:0] tone_s = tone_m[24:15];                 // tone x depth: -256..255
    reg  [7:0]  a8 = 8'd128;                                  // envelope 0..255 (128 = no modulation)
    reg  [15:0] a_scaled = 16'd0;
    reg  tx_bit = 1'b0;
    always @(posedge clk) begin
        tx_ph <= tx_ph + tx_freq;
        tone_ph <= tone_ph + tx_tone;
        tone_m <= tone * $signed({1'b0, tx_depth});
        a8 <= tone_s[8:1] + 8'd128;
        a_scaled <= a8 * 8'd115;
        // duty 5 % .. 50 %: the carrier's fundamental grows with the duty, so the duty carries the AM
        duty <= 8'd12 + a_scaled[15:8];
        tx_bit <= (tx_ph[31:24] < duty);
        tx_out <= ctrl[3] & tx_bit;
    end

    // ---------------------------------------------------------------- input
    reg s1 = 1'b0, s2 = 1'b0;
    reg [4:0] pull_cnt = 5'd0;
    // 32-bit LFSR (x^32 + x^22 + x^2 + x + 1, repeats every 43 s): random extra pull length breaks up the loop's
    // idle tones. (A 16-bit one repeats every 65535 clocks and itself paints a 1.526 kHz comb on the spectrum.)
    reg [31:0] dith = 32'hACE1_2468;
    always @(posedge clk) begin
        s1 <= rx_in;
        s2 <= s1;
        dith <= {dith[30:0], dith[31] ^ dith[21] ^ dith[1] ^ dith[0]};
        if (mode == 2'd2) begin
            if (pull_cnt != 5'd0) pull_cnt <= pull_cnt - 1'b1;
            else if (s1) pull_cnt <= {1'b0, sd_pulse} + (ctrl[5] ? {3'd0, dith[1:0]} : 5'd0);
        end else pull_cnt <= 5'd0;
        fb_out <= (mode == 2'd3) ? ~s1 : 1'b0;
    end
    assign rx_pull_low = (force_t == 2'd1) ? 1'b0 : (force_t == 2'd2) ? 1'b1 : (pull_cnt != 5'd0);
    wire bit_in = (mode == 2'd1) ? tx_bit : s2;

    // input density (bias check)
    reg [12:0] dens_cnt = 13'd0;
    reg [13:0] dens_ones = 14'd0, density = 14'd0;
    always @(posedge clk) begin
        dens_cnt <= dens_cnt + 1'b1;
        if (dens_cnt == 13'd0) begin density <= dens_ones; dens_ones <= {13'd0, bit_in}; end
        else if (bit_in) dens_ones <= dens_ones + 1'b1;
    end

    // ---------------------------------------------------------------- NCO + mixer (input is +-1: no multiplier)
    reg [31:0] lo_ph = 32'd0;
    always @(posedge clk) lo_ph <= lo_ph + rx_freq;
    wire signed [15:0] lo_cos, lo_sin;
    ardzy_sine_rom u_cos (.clk(clk), .a(lo_ph[31:22] + 10'd256), .q(lo_cos));
    ardzy_sine_rom u_sin (.clk(clk), .a(lo_ph[31:22]), .q(lo_sin));
    reg signed [15:0] mi = 16'sd0, mq = 16'sd0;
    reg bit_d = 1'b0;
    always @(posedge clk) begin
        bit_d <= bit_in;
        mi <= bit_d ? lo_cos : -lo_cos;
        mq <= bit_d ? -lo_sin : lo_sin;
    end

    // ---------------------------------------------------------------- decimation 100 MHz -> 12.207 kHz
    wire        v1i, v1q, v2i, v2q;
    wire signed [39:0] c1i, c1q;
    wire signed [51:0] c2i, c2q;
    orphan_cic4 #(.IW(16), .RLOG(6)) u_c1i (.clk(clk), .in_v(1'b1), .in(mi), .out_v(v1i), .out(c1i));
    orphan_cic4 #(.IW(16), .RLOG(6)) u_c1q (.clk(clk), .in_v(1'b1), .in(mq), .out_v(v1q), .out(c1q));
    // tuners B, C, D: their own NCO + first CIC (these run every clock); they keep step with tuner A's first
    // CIC (same counters from power-up), so they share A's noise blanker decisions and one second-stage engine
    wire vb, vc, vd;
    wire signed [23:0] nbi, nbq, nci, ncq, ndi, ndq;
    orphan_fe u_fe_b (.clk(clk), .bit_in(bit_in), .freq(freq_b), .v1(vb), .oi(nbi), .oq(nbq));
    orphan_fe u_fe_c (.clk(clk), .bit_in(bit_in), .freq(freq_c), .v1(vc), .oi(nci), .oq(ncq));
    orphan_fe u_fe_d (.clk(clk), .bit_in(bit_in), .freq(freq_d), .v1(vd), .oi(ndi), .oq(ndq));
    // ---------------------------------------------------------------- noise blanker (1.5625 MHz I/Q)
    // Impulses (power-line arcs, switching spikes, lightning) are much bigger than the running average of |IQ|:
    // when one is, the stage zeroes NB_LEN samples (plus the 2 before it, from a 2-sample delay line) so the
    // narrow filter after it never rings on the spike. The average is not updated with the spikes themselves.
    wire signed [23:0] n1i = c1i[39:16], n1q = c1q[39:16];
    // |I|, |Q| registered first, then max + 3/8 min the clock after (two short steps instead of one long one)
    reg  [23:0] ai1 = 24'd0, aq1 = 24'd0;
    reg         v1d = 1'b0;
    wire [23:0] mx1 = (ai1 > aq1) ? ai1 : aq1;
    wire [23:0] mn1 = (ai1 > aq1) ? aq1 : ai1;
    reg  [24:0] mag1 = 25'd0;
    reg  signed [23:0] ci = 24'sd0, cq = 24'sd0, d1i = 24'sd0, d1q = 24'sd0, d2i = 24'sd0, d2q = 24'sd0;
    reg  signed [23:0] oi = 24'sd0, oq = 24'sd0;
    reg  [31:0] avg_nb = 32'h0001_0000;       // average |IQ|, 8 fractional bits
    reg  [28:0] nb_thr = 29'h1FFF_FFFF;
    reg  [4:0]  blank_cnt = 5'd0;
    reg  [31:0] nb_count = 32'd0;
    reg         s1v = 1'b0, s2v = 1'b0, s3v = 1'b0, nb_v = 1'b0;
    reg         hit = 1'b0;
    reg  [24:0] magc = 25'd0;
    reg  signed [33:0] enb = 34'sd0;
    // the average always moves, but with each sample clipped to the threshold: spikes cannot pump it up, and a
    // too-low average (power-up, after a fade) grows back by up to k x per time constant instead of locking out.
    // Pipelined over 3 clocks (samples come every 64): compare, then subtract, then add.
    wire signed [33:0] e_nb = $signed({1'b0, magc, 8'd0}) - $signed({2'b00, avg_nb});
    // tuners B..D ride the same 2-sample delay line and blanking (an impulse is wideband: it hits every tuner)
    reg  [143:0] xb = 144'd0, xb1 = 144'd0, xb2 = 144'd0, xbo = 144'd0;
    always @(posedge clk) begin
        if (v1i) xb <= {ndq, ndi, ncq, nci, nbq, nbi};
        if (s2v) begin
            xb1 <= xb; xb2 <= xb1;
            xbo <= (hit || blank_cnt != 5'd0) ? 144'd0 : xb2;
        end
    end
    always @(posedge clk) begin
        nb_thr <= avg_nb[31:8] * nb_k;
        v1d <= v1i; s1v <= v1d; s2v <= s1v; s3v <= s2v;
        nb_v <= 1'b0;
        if (v1i) begin ai1 <= n1i[23] ? -n1i : n1i; aq1 <= n1q[23] ? -n1q : n1q; ci <= n1i; cq <= n1q; end
        if (v1d) mag1 <= {1'b0, mx1} + (mn1 >> 2) + (mn1 >> 3);
        if (s1v) begin
            hit <= (nb_k != 5'd0) && ({4'd0, mag1} > nb_thr);
            magc <= ((nb_k != 5'd0) && ({4'd0, mag1} > nb_thr)) ? nb_thr[24:0] : mag1;
        end
        if (s3v) avg_nb <= avg_nb + enb[33:10];                 // ~0.65 ms average
        if (s2v) begin
            enb <= e_nb;
            d1i <= ci; d1q <= cq; d2i <= d1i; d2q <= d1q;
            if (hit) begin
                blank_cnt <= {1'b0, nb_len} + 5'd2;
                nb_count <= nb_count + 1'b1;
                oi <= 24'sd0; oq <= 24'sd0;
            end else begin
                if (blank_cnt != 5'd0) begin blank_cnt <= blank_cnt - 1'b1; oi <= 24'sd0; oq <= 24'sd0; nb_count <= nb_count + 1'b1; end
                else begin oi <= d2i; oq <= d2q; end
            end
            nb_v <= 1'b1;
        end
    end
    orphan_cic4 #(.IW(24), .RLOG(7)) u_c2i (.clk(clk), .in_v(nb_v), .in(oi), .out_v(v2i), .out(c2i));
    orphan_cic4 #(.IW(24), .RLOG(7)) u_c2q (.clk(clk), .in_v(nb_v), .in(oq), .out_v(v2q), .out(c2q));
    // one time-shared second CIC for the six channels of tuners B..D (each gets 8 of the 64 clocks)
    wire         x6_v;
    wire [311:0] x6_out;
    orphan_cic4x6 u_c2x (.clk(clk), .in_v(nb_v), .in(xbo), .out_v(x6_v), .out(x6_out));

    // ---------------------------------------------------------------- scaling + AM detector
    // One step per clock: the baseband only changes every 8192 clocks, so every stage gets its own register
    // (keeps each path short enough for 100 MHz).
    reg signed [51:0] rawi = 0, rawq = 0, shi = 0, shq = 0;
    reg [5:0]  shamt = 6'd36;
    reg signed [15:0] ri = 16'sd0, rq = 16'sd0;
    reg [15:0] ai = 16'd0, aq = 16'd0, mx = 16'd0, mn = 16'd0;
    reg [16:0] mag = 17'd0;
    reg [31:0] avg_fast = 32'd0, avg_slow = 32'd0;
    reg signed [33:0] df_fast = 34'sd0, df_slow = 34'sd0;
    reg signed [17:0] diff = 18'sd0;
    reg signed [34:0] amul = 35'sd0;
    reg signed [15:0] audio = 16'sd0, araw = 16'sd0;
    reg [4:0] dstep = 5'd0;
    // hum comb: notches at every multiple of fs / D (50 or 60 Hz and all their harmonics)
    reg signed [15:0] hx [0:255];
    reg signed [15:0] hy [0:255];
    integer hk;
    initial for (hk = 0; hk < 256; hk = hk + 1) begin hx[hk] = 16'sd0; hy[hk] = 16'sd0; end
    reg  [7:0] hwp = 8'd0;
    // 4-point (cubic Lagrange) fractional delay: taps at delays Di-1 .. Di+2, weights hc0..hc3 (Q14, from the ARM)
    reg  [1:0] tap = 2'd0;
    wire [7:0] hti = hwp - (hum_d[15:8] - 8'd1) - {6'd0, tap};
    wire signed [15:0] hcw = (tap == 2'd0) ? hc0 : (tap == 2'd1) ? hc1 : (tap == 2'd2) ? hc2 : hc3;
    reg  signed [31:0] px = 0, py = 0;
    reg  signed [15:0] hxq = 0, hyq = 0, hcq = 0;
    reg  signed [33:0] ax = 0, ay = 0;
    wire signed [33:0] ax14 = ax >>> 14, ay14 = ay >>> 14;
    reg  signed [16:0] xd = 0, yd = 0;
    reg  signed [33:0] ry = 0;
    reg  signed [19:0] ysum = 0;
    wire signed [15:0] ysat = (ysum > 20'sd32767) ? 16'sd32767 : (ysum < -20'sd32768) ? -16'sd32768 : ysum[15:0];
    wire signed [15:0] bi = (shi > 52'sd32767) ? 16'sd32767 : (shi < -52'sd32768) ? -16'sd32768 : shi[15:0];
    wire signed [15:0] bq = (shq > 52'sd32767) ? 16'sd32767 : (shq < -52'sd32768) ? -16'sd32768 : shq[15:0];
    wire signed [34:0] a10 = amul >>> 10;
    wire signed [15:0] a_sat = (a10 > 35'sd32767) ? 16'sd32767 : (a10 < -35'sd32768) ? -16'sd32768 : a10[15:0];
    // averages of |IQ| in Q15, updated with SIGNED differences (an unsigned one wraps when the level falls)
    wire signed [33:0] e_fast = $signed({2'b00, mag, 15'd0}) - $signed({2'b00, avg_fast});
    wire signed [33:0] e_slow = $signed({2'b00, mag, 15'd0}) - $signed({2'b00, avg_slow});
    reg        smp = 1'b0;
    always @(posedge clk) begin
        smp <= 1'b0;
        shamt <= 6'd36 - iq_shift;
        case (dstep)
            5'd0: if (v2i) begin rawi <= c2i; rawq <= c2q; dstep <= 5'd1; end
            5'd1: begin shi <= rawi >>> shamt; shq <= rawq >>> shamt; dstep <= 5'd2; end    // IQ_SHIFT gain
            5'd2: begin ri <= bi; rq <= bq; dstep <= 5'd3; end                               // saturate to 16 bits
            5'd3: begin ai <= ri[15] ? -ri : ri; aq <= rq[15] ? -rq : rq; dstep <= 5'd4; end
            5'd4: begin mx <= (ai > aq) ? ai : aq; mn <= (ai > aq) ? aq : ai; dstep <= 5'd5; end
            5'd5: begin mag <= {1'b0, mx} + (mn >> 2) + (mn >> 3); dstep <= 5'd6; end         // |IQ| ~ max + 3/8 min
            5'd6: begin df_fast <= e_fast >>> 6; df_slow <= e_slow >>> 10; dstep <= 5'd7; end
            5'd7: begin
                avg_fast <= avg_fast + df_fast[31:0];                                         // ~30 Hz DC block
                avg_slow <= avg_slow + df_slow[31:0];                                         // S-meter
                dstep <= 5'd8;
            end
            5'd8: begin diff <= $signed({1'b0, mag}) - $signed({1'b0, avg_fast[31:15]}); dstep <= 5'd9; end
            5'd9: begin amul <= diff * $signed({1'b0, af_gain}); dstep <= 5'd10; end
            5'd10: begin araw <= a_sat; tap <= 2'd0; ax <= 34'sd0; ay <= 34'sd0; dstep <= 5'd11; end
            5'd11: begin hxq <= hx[hti]; hyq <= hy[hti]; hcq <= hcw; dstep <= 5'd17; end      // one tap: read
            5'd17: begin px <= hxq * hcq; py <= hyq * hcq; dstep <= 5'd12; end                 //          multiply
            5'd12: begin
                ax <= ax + px; ay <= ay + py; tap <= tap + 1'b1;
                dstep <= (tap == 2'd3) ? 5'd16 : 5'd11;
            end
            5'd16: begin
                xd <= (ax14 > 34'sd65535) ? 17'sd65535 : (ax14 < -34'sd65536) ? -17'sd65536 : ax14[16:0];
                yd <= (ay14 > 34'sd65535) ? 17'sd65535 : (ay14 < -34'sd65536) ? -17'sd65536 : ay14[16:0];
                dstep <= 5'd13;
            end
            5'd13: begin ry <= yd * $signed({1'b0, hum_r}); dstep <= 5'd14; end
            5'd14: begin ysum <= $signed({{4{araw[15]}}, araw}) - $signed({{3{xd[16]}}, xd}) + $signed({ry[33], ry[33:15]}); dstep <= 5'd15; end
            5'd15: begin
                hx[hwp] <= araw; hy[hwp] <= ysat; hwp <= hwp + 1'b1;
                audio <= hum_on ? ysat : araw; smp <= 1'b1; dstep <= 5'd0;
            end
            default: dstep <= 5'd0;
        endcase
    end
    wire [16:0] car17 = avg_slow[31:15];                       // average |IQ|
    wire [15:0] carrier = car17[16] ? 16'hFFFF : car17[15:0];
    assign led_level = (carrier[15:13] != 3'd0) ? 8'hFF : carrier[12:5];
    wire [15:0] aud_mag = audio[15] ? -audio : audio;
    assign led_audio = aud_mag[14:7];

    // ---------------------------------------------------------------- capture FIFO: {I,Q} then {audio, carrier}
    (* ram_style = "block" *) reg [31:0] cap [0:4095];
    reg [12:0] cw = 13'd0, cr = 13'd0;
    wire [12:0] cap_n = cw - cr;
    reg [31:0] capq = 32'd0;
    reg        push2 = 1'b0;
    reg [31:0] wdat = 32'd0;
    reg        wen = 1'b0;
    always @(posedge clk) begin
        wen <= 1'b0;
        push2 <= 1'b0;
        if (smp && ctrl[0] && cap_n <= 13'd4094) begin wdat <= {ri, rq}; wen <= 1'b1; push2 <= 1'b1; end
        else if (push2) begin wdat <= {audio, carrier}; wen <= 1'b1; end
        if (wen) cap[cw[11:0]] <= wdat;
        capq <= cap[cr[11:0]];
    end

    // ---------------------------------------------------------------- tuners B..D: scale, then FIFO 2
    // same gain as tuner A (IQ_SHIFT); one channel per clock (select, shift, saturate), then 3 words per sample:
    // {B_I, B_Q}, {C_I, C_Q}, {D_I, D_Q}
    reg  [3:0]  sq = 4'd0;
    reg         sq_on = 1'b0, ok2 = 1'b0;
    reg  signed [51:0] xsel = 0, shv = 0;
    reg  [15:0] rs [0:5];
    integer rk;
    initial for (rk = 0; rk < 6; rk = rk + 1) rs[rk] = 16'd0;
    wire signed [15:0] shv_sat = (shv > 52'sd32767) ? 16'sd32767 : (shv < -52'sd32768) ? -16'sd32768 : shv[15:0];
    (* ram_style = "block" *) reg [31:0] cap2 [0:4095];
    reg [12:0] cw2 = 13'd0, cr2 = 13'd0;
    wire [12:0] cap2_n = cw2 - cr2;
    reg [31:0] capq2 = 32'd0, w2dat = 32'd0;
    reg        w2en = 1'b0;
    always @(posedge clk) begin
        w2en <= 1'b0;
        if (x6_v) begin sq_on <= 1'b1; sq <= 4'd0; end
        else if (sq_on) begin
            sq <= sq + 1'b1;
            if (sq < 4'd6) xsel <= x6_out[sq * 52 +: 52];
            if (sq >= 4'd1 && sq <= 4'd6) shv <= xsel >>> shamt;
            if (sq >= 4'd2 && sq <= 4'd7) rs[sq - 4'd2] <= shv_sat;
            if (sq == 4'd8) begin ok2 <= ctrl[0] && (cap2_n <= 13'd4092); end
            if (sq == 4'd9)  begin w2dat <= {rs[0], rs[1]}; w2en <= ok2; end
            if (sq == 4'd10) begin w2dat <= {rs[2], rs[3]}; w2en <= ok2; end
            if (sq == 4'd11) begin w2dat <= {rs[4], rs[5]}; w2en <= ok2; sq_on <= 1'b0; end
        end
        if (w2en) begin cap2[cw2[11:0]] <= w2dat; cw2 <= cw2 + 1'b1; end
        capq2 <= cap2[cr2[11:0]];
    end

    // ---------------------------------------------------------------- wide panadapter: block capture
    // Its own NCO (PAN_FREQ) + a CIC with run-time decimation 2^PAN_RLOG; writing PAN_CTRL bit 8 captures the
    // next 4096 I/Q samples, which the ARM reads out and FFTs (the display, not a listening path).
    wire        pan_v;
    wire signed [15:0] pan_i, pan_q;
    orphan_pan u_pan (.clk(clk), .bit_in(bit_in), .freq(pan_freq), .rlog(pan_rlog), .gain(pan_gain),
                      .v(pan_v), .oi(pan_i), .oq(pan_q));
    (* ram_style = "block" *) reg [31:0] snap [0:4095];
    reg [12:0] sw = 13'h1000, sr = 13'd0;          // sw[12] = capture done
    reg [31:0] snapq = 32'd0;
    always @(posedge clk) begin
        if (pan_v && !sw[12]) snap[sw[11:0]] <= {pan_i, pan_q};
        snapq <= snap[sr[11:0]];
    end

    // ---------------------------------------------------------------- I2S (Ardzy audio timing, sample held 4x)
    reg [10:0] fc = 11'd0;
    always @(posedge clk) fc <= fc + 1'b1;
    wire i2s_on = ctrl[4];
    assign mclk = i2s_on & fc[2];
    assign bclk = i2s_on & fc[4];
    wire [5:0] slot = fc[10:5];
    wire [4:0] pos = slot[4:0];
    reg signed [15:0] cur = 16'sd0;
    always @(posedge clk) begin
        if (fc == 11'd0) cur <= audio;
        if (fc[4:0] == 5'd0) begin
            lrclk <= i2s_on & slot[5];
            dout <= i2s_on && (pos >= 5'd1) && (pos <= 5'd16) && cur[5'd16 - pos];
        end
    end

    // ---------------------------------------------------------------- registers
    always @(posedge clk) begin
        if (wen) cw <= cw + 1'b1;
        if (pan_v && !sw[12]) sw <= sw + 1'b1;
        if (!rstn) ctrl <= 6'b100011;
        else if (bus_we && sel) begin
            case (idx)
                10'd0: ctrl <= bus_wdata[5:0];
                10'd1: rx_freq <= bus_wdata;
                10'd2: iq_shift <= bus_wdata[3:0];
                10'd3: af_gain <= bus_wdata[15:0];
                10'd4: tx_freq <= bus_wdata;
                10'd5: tx_tone <= bus_wdata;
                10'd6: tx_depth <= bus_wdata[7:0];
                10'd7: sd_pulse <= (bus_wdata[3:0] == 4'd0) ? 4'd1 : bus_wdata[3:0];
                10'd12: force_t <= bus_wdata[1:0];
                10'd13: begin nb_k <= bus_wdata[4:0]; nb_len <= bus_wdata[11:8]; end
                10'd14: begin hum_on <= bus_wdata[0]; hum_d <= bus_wdata[23:8]; end
                10'd15: hum_r <= bus_wdata[15:0];
                10'd17: hc0 <= bus_wdata[15:0];
                10'd18: hc1 <= bus_wdata[15:0];
                10'd19: hc2 <= bus_wdata[15:0];
                10'd20: hc3 <= bus_wdata[15:0];
                10'd21: freq_b <= bus_wdata;
                10'd22: freq_c <= bus_wdata;
                10'd23: freq_d <= bus_wdata;
                10'd24: pan_freq <= bus_wdata;
                10'd25: begin
                    pan_rlog <= (bus_wdata[3:0] < 4'd4) ? 4'd4 : (bus_wdata[3:0] > 4'd8) ? 4'd8 : bus_wdata[3:0];
                    pan_gain <= bus_wdata[7:4];
                    if (bus_wdata[8]) begin sw <= 13'd0; sr <= 13'd0; end
                end
                default: ;
            endcase
        end
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else if (idx[9]) begin
                if (cap_n != 13'd0) begin bus_rdata <= capq; cr <= cr + 1'b1; end
                else bus_rdata <= 32'd0;
            end else if (idx[9:8] == 2'b01) begin                       // 256..511: FIFO 2 (tuners B..D)
                if (cap2_n != 13'd0) begin bus_rdata <= capq2; cr2 <= cr2 + 1'b1; end
                else bus_rdata <= 32'd0;
            end else if (idx[9:7] == 3'b001) begin                      // 128..255: panadapter block, in order
                bus_rdata <= snapq; sr <= sr + 1'b1;
            end else case (idx)
                10'd0: bus_rdata <= {26'd0, ctrl};
                10'd1: bus_rdata <= rx_freq;
                10'd8: bus_rdata <= {16'd0, carrier};
                10'd9: bus_rdata <= {19'd0, cap_n};
                10'd10: bus_rdata <= 32'h52414431;                 // "RAD1"
                10'd11: bus_rdata <= {18'd0, density};
                10'd12: bus_rdata <= {28'd0, rx_pull_low, s2, s1, rx_in};      // debug: pin now
                10'd16: bus_rdata <= nb_count;                                   // samples blanked so far
                10'd21: bus_rdata <= freq_b;
                10'd22: bus_rdata <= freq_c;
                10'd23: bus_rdata <= freq_d;
                10'd24: bus_rdata <= pan_freq;
                10'd25: bus_rdata <= {sw[12], 23'd0, pan_gain, pan_rlog};     // [31] = capture done
                10'd26: bus_rdata <= {19'd0, cap2_n};
                10'd27: bus_rdata <= 32'h0000_0104;                              // 4 tuners + panadapter
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule

// 4th-order CIC decimator by 2^RLOG (Hogenauer), integrators on in_v, pipelined combs.
module orphan_cic4 #(parameter IW = 16, parameter RLOG = 6) (
    input  wire                         clk,
    input  wire                         in_v,
    input  wire signed [IW-1:0]         in,
    output reg                          out_v = 1'b0,
    output reg  signed [IW+4*RLOG-1:0]  out = 0
);
    localparam W = IW + 4 * RLOG;
    reg signed [W-1:0] i1 = 0, i2 = 0, i3 = 0, i4 = 0;
    reg [RLOG-1:0] n = 0;
    reg signed [W-1:0] x0 = 0, x1 = 0, x2 = 0, x3 = 0;
    reg signed [W-1:0] d0 = 0, d1 = 0, d2 = 0, d3 = 0;
    reg v0 = 1'b0, v1 = 1'b0, v2 = 1'b0, v3 = 1'b0;
    always @(posedge clk) begin
        v0 <= 1'b0;
        if (in_v) begin
            i1 <= i1 + {{(W-IW){in[IW-1]}}, in};
            i2 <= i2 + i1;
            i3 <= i3 + i2;
            i4 <= i4 + i3;
            n <= n + 1'b1;
            if (n == {RLOG{1'b1}}) begin x0 <= i4; v0 <= 1'b1; end
        end
        v1 <= v0; v2 <= v1; v3 <= v2; out_v <= v3;
        if (v0) begin x1 <= x0 - d0; d0 <= x0; end
        if (v1) begin x2 <= x1 - d1; d1 <= x1; end
        if (v2) begin x3 <= x2 - d2; d2 <= x2; end
        if (v3) begin out <= x3 - d3; d3 <= x3; end
    end
endmodule

// Extra tuner front end: NCO + mixer (the input is +-1, so no multiplier) + first CIC /64, like tuner A's.
module orphan_fe (
    input  wire               clk,
    input  wire               bit_in,
    input  wire [31:0]        freq,
    output wire               v1,
    output wire signed [23:0] oi,
    output wire signed [23:0] oq
);
    reg [31:0] ph = 32'd0;
    always @(posedge clk) ph <= ph + freq;
    wire signed [15:0] lc, ls;
    ardzy_sine_rom u_c (.clk(clk), .a(ph[31:22] + 10'd256), .q(lc));
    ardzy_sine_rom u_s (.clk(clk), .a(ph[31:22]), .q(ls));
    reg signed [15:0] mi = 16'sd0, mq = 16'sd0;
    reg bd = 1'b0;
    always @(posedge clk) begin
        bd <= bit_in;
        mi <= bd ? lc : -lc;
        mq <= bd ? -ls : ls;
    end
    wire vq;
    wire signed [39:0] ci, cq;
    orphan_cic4 #(.IW(16), .RLOG(6)) u_i (.clk(clk), .in_v(1'b1), .in(mi), .out_v(v1), .out(ci));
    orphan_cic4 #(.IW(16), .RLOG(6)) u_q (.clk(clk), .in_v(1'b1), .in(mq), .out_v(vq), .out(cq));
    assign oi = ci[39:16];
    assign oq = cq[39:16];
endmodule

// Six-channel 4th-order CIC decimator by 128, time-shared: all six inputs arrive together (in_v, at most every
// 64 clocks); the engine then walks channel by channel, one stage per clock (4 integrators, then on every 128th
// sample the 4 combs), keeping every stage's state in a small 64 x 52 memory. 48 clocks per input sample.
module orphan_cic4x6 (
    input  wire         clk,
    input  wire         in_v,
    input  wire [143:0] in,               // 6 x signed 24, channel 0 in the low bits
    output reg          out_v = 1'b0,
    output reg  [311:0] out = 312'd0      // 6 x signed 52
);
    localparam W = 52;
    reg signed [W-1:0] mem [0:63];        // address {channel, stage}: stages 0..3 integrators, 4..7 comb delays
    integer k;
    initial for (k = 0; k < 64; k = k + 1) mem[k] = 0;
    reg [143:0] xin = 144'd0;
    reg         busy = 1'b0, dec = 1'b0;
    reg [5:0]   s = 6'd0;
    reg [6:0]   n = 7'd0;
    reg signed [W-1:0] r = 0;
    wire [2:0] ch = s[5:3], stg = s[2:0];
    // the state word and the channel's input are fetched one clock ahead (address s + 1 is known), so each
    // clock is only one 52-bit add: memory read and channel select happen in the clock before
    reg  signed [W-1:0] m = 0;
    reg  signed [23:0]  xc = 24'sd0;
    wire [5:0] s1 = s + 1'b1;
    wire signed [W-1:0] opnd = (stg == 3'd0) ? {{(W-24){xc[23]}}, xc} : r;
    wire signed [W-1:0] sum = m + opnd;
    wire signed [W-1:0] dif = r - m;
    always @(posedge clk) begin
        if (in_v && !busy) begin m <= mem[6'd0]; xc <= in[23:0]; end
        else begin m <= mem[s1]; xc <= xin[s1[5:3] * 24 +: 24]; end
    end
    always @(posedge clk) begin
        out_v <= 1'b0;
        if (in_v && !busy) begin
            xin <= in; busy <= 1'b1; s <= 6'd0; dec <= (n == 7'd127); n <= n + 1'b1;
        end else if (busy) begin
            if (!stg[2]) begin mem[s] <= sum; r <= sum; end
            else if (dec) begin
                mem[s] <= r; r <= dif;
                if (stg == 3'd7) out[ch * W +: W] <= dif;
            end
            if (s == 6'd47) begin busy <= 1'b0; out_v <= dec; end
            s <= s + 1'b1;
        end
    end
endmodule

// 4th-order CIC decimator with run-time decimation 2^rlog (rlog 4..8), input every clock, 48-bit.
module orphan_cic4v (
    input  wire               clk,
    input  wire [3:0]         rlog,
    input  wire signed [15:0] in,
    output reg                out_v = 1'b0,
    output reg  signed [47:0] out = 0
);
    reg signed [47:0] i1 = 0, i2 = 0, i3 = 0, i4 = 0, x0 = 0, x1 = 0, x2 = 0, x3 = 0, d0 = 0, d1 = 0, d2 = 0, d3 = 0;
    reg [7:0] n = 8'd0, mask = 8'd63;
    reg v0 = 1'b0, v1 = 1'b0, v2 = 1'b0, v3 = 1'b0;
    always @(posedge clk) begin
        mask <= (rlog >= 4'd8) ? 8'd255 : (8'd1 << rlog) - 8'd1;
        i1 <= i1 + {{32{in[15]}}, in};
        i2 <= i2 + i1;
        i3 <= i3 + i2;
        i4 <= i4 + i3;
        n <= n + 1'b1;
        v0 <= 1'b0;
        if ((n & mask) == mask) begin x0 <= i4; v0 <= 1'b1; end
        v1 <= v0; v2 <= v1; v3 <= v2; out_v <= v3;
        if (v0) begin x1 <= x0 - d0; d0 <= x0; end
        if (v1) begin x2 <= x1 - d1; d1 <= x1; end
        if (v2) begin x3 <= x2 - d2; d2 <= x2; end
        if (v3) begin out <= x3 - d3; d3 <= x3; end
    end
endmodule

// Wide panadapter front end: NCO + mixer + variable CIC, scaled to 16-bit I/Q.
module orphan_pan (
    input  wire               clk,
    input  wire               bit_in,
    input  wire [31:0]        freq,
    input  wire [3:0]         rlog,
    input  wire [3:0]         gain,
    output reg                v = 1'b0,
    output reg  signed [15:0] oi = 16'sd0,
    output reg  signed [15:0] oq = 16'sd0
);
    reg [31:0] ph = 32'd0;
    always @(posedge clk) ph <= ph + freq;
    wire signed [15:0] lc, ls;
    ardzy_sine_rom u_c (.clk(clk), .a(ph[31:22] + 10'd256), .q(lc));
    ardzy_sine_rom u_s (.clk(clk), .a(ph[31:22]), .q(ls));
    reg signed [15:0] mi = 16'sd0, mq = 16'sd0;
    reg bd = 1'b0;
    always @(posedge clk) begin
        bd <= bit_in;
        mi <= bd ? lc : -lc;
        mq <= bd ? -ls : ls;
    end
    wire vi, vq;
    wire signed [47:0] ci, cq;
    orphan_cic4v u_i (.clk(clk), .rlog(rlog), .in(mi), .out_v(vi), .out(ci));
    orphan_cic4v u_q (.clk(clk), .rlog(rlog), .in(mq), .out_v(vq), .out(cq));
    // CIC gain is 2^(4 rlog): shift that back out, less the extra gain
    reg [5:0] sh = 6'd24;
    reg signed [47:0] si = 0, sq = 0;
    reg s1 = 1'b0;
    always @(posedge clk) begin
        sh <= {rlog, 2'b00} - {2'b00, gain};
        s1 <= vi;
        if (vi) begin si <= ci >>> sh; sq <= cq >>> sh; end
        v <= s1;
        if (s1) begin
            oi <= (si > 48'sd32767) ? 16'sd32767 : (si < -48'sd32768) ? -16'sd32768 : si[15:0];
            oq <= (sq > 48'sd32767) ? 16'sd32767 : (sq < -48'sd32768) ? -16'sd32768 : sq[15:0];
        end
    end
endmodule
