`timescale 1ns / 1ps
// Orphan Synth v3: an 8-voice subtractive synth in the FPGA (JMSCNC, Rev. J. Money 2026, GPL-3 + attribution).
//
// Per voice: saw + pulse (PWM) + triangle + sine + sub-octave square + noise through a 6-channel mixer,
// its own resonant state-variable filter (low / band / high pass) with its own filter ADSR, an amp ADSR,
// velocity gain.
// Global: 2 LFOs (triangle, sine, saw up/down, square, sample & hold) and a 4-slot mod matrix
// (LFO1, LFO2 or LFO1 x LFO2 -> pitch, cutoff, resonance, amp, pulse width, drive, crush).
// Master: drive (soft / hard clip / wavefolder) -> bitcrusher (bits + sample-rate) -> long delay with feedback,
// tone and mix -> looper return -> volume. The delay line and the looper live in the ARM's RAM (orphan-fxd):
// the FPGA streams {delay input, loop record} to it with sample times and plays back {delay return, loop return}.
// I2S out to a PCM5102A, a capture FIFO for the browser, and LED level outputs for the light show.
//
// All multiplies go through ONE shared 18x18 multiplier (one DSP48), 2 clocks of latency: operands set
// at step k are read back as `pr` at step k+2. ~16 + 8 x 28 + 22 = ~262 of the 2048 clocks per sample.
//
// Timing: 100 MHz clock (FCLK0 must be 100 MHz: orphan-fclk.service), 2048 clocks per frame, fs = 48828.125 Hz.
//
// Registers (word index):
//   0 CTRL      [0] sound on  [1] capture on  [2] FX returns on (delay + looper streams)
//   1..6        mixer levels 0..255: 1 saw, 2 pulse, 3 triangle, 4 sine, 5 sub, 6 noise
//   7..10       amp ADSR:    7 attack step, 8 decay step, 9 sustain 0..65535, 10 release step (env full = 2^24)
//   11..14      filter ADSR: 11 attack, 12 decay, 13 sustain, 14 release
//   15 CUTOFF   0..65535 log (40 Hz .. 8 kHz)          16 RESO   damping Q15 (65535 ~ none, small = lots)
//   17 F_ENV    filter envelope amount, signed 16       18 VOLUME 0..256
//   19 LFO1_RATE / 20 LFO2_RATE  phase step per sample  21 LFO_SHAPE [2:0] LFO1 [5:3] LFO2:
//               0 triangle 1 sine 2 saw up 3 saw down 4 square 5 sample & hold
//   22..25 MOD  slot 0..3: [1:0] source (0 off, 1 LFO1, 2 LFO2, 3 LFO1 x LFO2), [6:4] destination
//               (0 none, 1 pitch, 2 cutoff, 3 resonance, 4 amp, 5 pulse width, 6 drive, 7 crush), [31:16] depth
//   24 is slot 2 (PW moved to 31)                       30 F_MODE 0 low, 1 band, 2 high, 3 bypass
//   31 PW       pulse width 0..65535 (32768 = square)
//   25 CAPTURE  read: oldest output sample (signed 16), removes it   26 CAP_LEVEL read
//   27 ID       "SYN3"     28 ACTIVE read: bit v = voice v sounding    29 debug: current output sample
//   32 + 4v     voice v: +0 phase increment, +1 gate (1 down / 0 up), +2 gain 0..65535
//   64 DRIVE    [15:0] gain (256 = x1 .. 65535 = x256)  [17:16] shape: 0 off, 1 soft, 2 hard clip, 3 fold
//   65 CRUSH    [4:0] bits 1..16 (16 = clean)  [13:8] sample-rate divide 1..63
//   66 DLY_FB   feedback 0..65535       67 DLY_WET mix 0..65535      68 DLY_TONE 0..65535 (65535 = bright)
//   69 LOOP_VOL 0..65535                70 FX_FLUSH write: empty both FX FIFOs, clear the overflow flag
//   72 T        read: sample counter (time)
//   73 CAP2_T   read: time of the oldest sample waiting for orphan-fxd     74 CAP2_LEVEL read (bit 31: overflowed)
//   75 PLAY_T   read: time at which the next written return will be played 76 PLAY_LEVEL read  77 UNDERRUNS read
//   512..1023   read: pop {delay input, loop record} for orphan-fxd; write: push {delay return, loop return}
//               (any address in the window, so the ARM moves blocks with one memcpy)
module orphan_synth #(parameter [3:0] SLOT = 4'd1) (
    input  wire        clk,
    input  wire        rstn,
    input  wire [15:0] bus_addr,
    input  wire [31:0] bus_wdata,
    input  wire        bus_we,
    input  wire        bus_re,
    output reg  [31:0] bus_rdata = 32'd0,
    output wire        mclk,
    output wire        bclk,
    output reg         lrclk = 1'b0,
    output reg         dout = 1'b0,
    output wire [31:0] led_voice,          // 4 x 8 bit: envelope of voices (0,1) (2,3) (4,5) (6,7)
    output reg  [7:0]  led_vu = 8'd0,      // output level, peak with decay
    output wire [7:0]  led_lfo             // LFO1 position 0..255
);
    wire sel = (bus_addr[15:12] == SLOT);
    wire [9:0] idx = bus_addr[11:2];

    // ---------------------------------------------------------------- settings
    reg [2:0]  ctrl = 3'd0;
    reg [7:0]  lvl_saw = 8'd200, lvl_pul = 8'd0, lvl_tri = 8'd0, lvl_sin = 8'd0, lvl_sub = 8'd0, lvl_noi = 8'd0;
    reg [23:0] atk = 24'd60000, dec = 24'd4000, rel = 24'd3000;
    reg [23:0] fatk = 24'd60000, fdec = 24'd2000, frel = 24'd3000;
    reg [15:0] sus = 16'd45000, fsus = 16'd20000;
    reg [15:0] cutoff = 16'd40000, reso = 16'd40000, pw = 16'd32768;
    reg signed [15:0] famt = 16'sd0;
    reg [8:0]  vol = 9'd200;
    reg [31:0] lfo1_inc = 32'd0, lfo2_inc = 32'd0;
    reg [2:0]  shape1 = 3'd0, shape2 = 3'd0;
    reg [31:0] slot0 = 32'd0, slot1 = 32'd0, slot2 = 32'd0, slot3 = 32'd0;
    reg [1:0]  fmode = 2'd0;
    reg [15:0] drive = 16'd256;
    reg [1:0]  dshape = 2'd0;
    reg [4:0]  bits = 5'd16;
    reg [5:0]  ds_n = 6'd1;
    reg [15:0] dly_fb = 16'd0, dly_wet = 16'd0, dly_tone = 16'hFFFF, loop_vol = 16'hFFFF;

    // ---------------------------------------------------------------- voices
    reg [31:0] inc   [0:7];
    reg [31:0] phase [0:7];
    reg [23:0] env   [0:7];
    reg [23:0] fenv  [0:7];
    reg [1:0]  st    [0:7];             // amp env: 0 idle, 1 attack, 2 decay/sustain, 3 release
    reg [1:0]  fst   [0:7];             // filter env, same states
    reg [15:0] gain  [0:7];
    reg signed [23:0] fl [0:7];         // filter state: low
    reg signed [23:0] fb [0:7];         // filter state: band
    reg [7:0]  gate = 8'd0, subb = 8'd0, active = 8'd0;
    reg [63:0] envtop = 64'd0;
    integer i;
    initial for (i = 0; i < 8; i = i + 1) begin
        inc[i] = 32'd0; phase[i] = 32'd0; env[i] = 24'd0; fenv[i] = 24'd0; st[i] = 2'd0; fst[i] = 2'd0;
        gain[i] = 16'hFFFF; fl[i] = 24'sd0; fb[i] = 24'sd0;
    end

    // ---------------------------------------------------------------- frame timing (Ardzy audio)
    reg [10:0] fc = 11'd0;
    always @(posedge clk) fc <= fc + 1'b1;
    wire on = ctrl[0];
    assign mclk = on & fc[2];
    assign bclk = on & fc[4];
    wire bit_start = (fc[4:0] == 5'd0);
    wire [5:0] slot = fc[10:5];
    wire frame_start = (fc == 11'd0);

    // ---------------------------------------------------------------- tables
    reg  [9:0] rom_a = 10'd0, rom2_a = 10'd0;
    wire signed [15:0] sine, sine2;
    ardzy_sine_rom u_rom (.clk(clk), .a(rom_a), .q(sine));
    ardzy_sine_rom u_rom2 (.clk(clk), .a(rom2_a), .q(sine2));
    reg  [8:0]  crom_a = 9'd0;
    wire [15:0] crom_q;
    orphan_cutoff_rom u_crom (.clk(clk), .a(crom_a), .q(crom_q));

    // ---------------------------------------------------------------- the shared multiplier
    reg signed [17:0] ma = 18'sd0, mb = 18'sd0;
    reg signed [35:0] pr = 36'sd0;
    always @(posedge clk) pr <= ma * mb;
    wire signed [35:0] pr3 = pr >>> 3;
    wire signed [35:0] pr4 = pr >>> 4;
    wire signed [35:0] pr8 = pr >>> 8;
    wire signed [35:0] pr9 = pr >>> 9;
    wire signed [35:0] pr10 = pr >>> 10;
    wire signed [35:0] pr15 = pr >>> 15;
    wire signed [35:0] pr16 = pr >>> 16;
    function signed [17:0] s18(input signed [15:0] x);
        s18 = {{2{x[15]}}, x};
    endfunction

    // ---------------------------------------------------------------- LFOs + mod matrix
    reg [31:0] lfo1_ph = 32'd0, lfo2_ph = 32'd0;
    reg [15:0] lfsr = 16'hACE1;
    reg signed [15:0] lsin1 = 16'sd0, lsin2 = 16'sd0, sh1 = 16'sd0, sh2 = 16'sd0;
    reg signed [15:0] L1 = 16'sd0, L2 = 16'sd0, L3 = 16'sd0;
    reg wrap1 = 1'b0, wrap2 = 1'b0;
    function signed [15:0] lshape(input [2:0] s, input [31:0] ph, input signed [15:0] sn, input signed [15:0] sh);
        reg [15:0] tu;
        begin
            tu = ph[31] ? ~ph[30:15] : ph[30:15];
            case (s)
                3'd0: lshape = $signed(tu ^ 16'h8000);
                3'd1: lshape = sn;
                3'd2: lshape = $signed(ph[31:16] ^ 16'h8000);
                3'd3: lshape = $signed(~ph[31:16] ^ 16'h8000);
                3'd4: lshape = ph[31] ? -16'sd32767 : 16'sd32767;
                default: lshape = sh;
            endcase
        end
    endfunction
    // slot fields
    wire [1:0] src0 = slot0[1:0], src1 = slot1[1:0], src2 = slot2[1:0], src3 = slot3[1:0];
    wire [2:0] dst0 = slot0[6:4], dst1 = slot1[6:4], dst2 = slot2[6:4], dst3 = slot3[6:4];
    function signed [15:0] srcval(input [1:0] s, input [2:0] d, input signed [15:0] a, input signed [15:0] b,
                                  input signed [15:0] c);
        reg signed [15:0] v;
        begin
            v = (s == 2'd1) ? a : (s == 2'd2) ? b : (s == 2'd3) ? c : 16'sd0;
            // amp is a one-way destination: use the source as 0..1 so the LFO only ever turns the volume down
            srcval = (d == 3'd4) ? $signed({1'b0, v[15:1] ^ 15'h4000}) : v;
            if (s == 2'd0) srcval = 16'sd0;
        end
    endfunction
    reg signed [17:0] m_pitch = 0, m_cut = 0, m_res = 0, m_amp = 0, m_pw = 0, m_drive = 0, m_crush = 0;
    reg signed [15:0] vib = 16'sd0, pwm_mod = 16'sd0, flfo = 16'sd0;
    reg [15:0] trem_g = 16'hFFFF, reso_eff = 16'd40000, drive_eff = 16'd256;
    reg [4:0]  bits_eff = 5'd16;
    reg [2:0]  acc_dst = 3'd0;
    wire signed [17:0] mod_v = pr15[17:0];
    assign led_lfo = L1[15:8] ^ 8'h80;
    function signed [15:0] sat16_18(input signed [17:0] x);
        sat16_18 = (x > 18'sd32767) ? 16'sd32767 : (x < -18'sd32768) ? -16'sd32768 : x[15:0];
    endfunction

    // ---------------------------------------------------------------- engine state
    reg        busy = 1'b0;
    reg [2:0]  v = 3'd0;
    reg [6:0]  step = 7'd0;
    reg [31:0] ph_r = 32'd0;
    reg signed [15:0] o_sin = 16'sd0;
    reg signed [27:0] msum = 28'sd0;
    reg signed [17:0] mixv = 18'sd0, fo = 18'sd0;
    reg signed [23:0] fl_n = 24'sd0, fh = 24'sd0;
    reg [15:0] fco = 16'd0;
    reg signed [23:0] acc = 24'sd0;
    reg signed [15:0] mix_out = 16'sd0;
    reg        new_sample = 1'b0;
    reg [31:0] T = 32'd0;                          // sample time

    // oscillators (from the voice's new phase)
    wire [15:0] tri_u = ph_r[31] ? ~ph_r[30:15] : ph_r[30:15];
    wire signed [15:0] o_tri = $signed(tri_u ^ 16'h8000);
    wire signed [15:0] o_saw = $signed(ph_r[31:16] ^ 16'h8000);
    wire signed [17:0] pw_m = $signed({2'b00, pw}) + $signed({{2{pwm_mod[15]}}, pwm_mod});
    wire [15:0] pw_c = (pw_m < 18'sd2048) ? 16'd2048 : (pw_m > 18'sd63487) ? 16'd63487 : pw_m[15:0];
    wire signed [15:0] o_pul = (ph_r[31:16] < pw_c) ? 16'sd24000 : -16'sd24000;
    wire signed [15:0] o_sub = subb[v] ? 16'sd24000 : -16'sd24000;
    wire signed [15:0] o_noi = $signed(lfsr);

    wire [31:0] inc_eff = inc[v] + pr4[31:0];
    wire [32:0] ph_sum = {1'b0, phase[v]} + {1'b0, inc_eff};

    wire signed [27:0] msum8 = msum >>> 8;
    wire signed [17:0] mixv_w = (msum8 > 28'sd131071) ? 18'sd131071 : (msum8 < -28'sd131072) ? -18'sd131072 : msum8[17:0];

    wire signed [19:0] cl = $signed({4'b0000, cutoff}) + $signed(pr16[19:0]) + $signed({{4{flfo[15]}}, flfo});
    wire [15:0] cl_c = (cl < 20'sd0) ? 16'd0 : (cl > 20'sd65535) ? 16'd65535 : cl[15:0];

    wire signed [23:0] fl_v = fl[v];
    wire signed [23:0] fb_v = fb[v];
    wire signed [25:0] s_low  = $signed({{2{fl_v[23]}}, fl_v}) + $signed(pr10[25:0]);
    wire signed [25:0] s_high = $signed({{8{mixv[17]}}, mixv}) - $signed({{2{fl_n[23]}}, fl_n}) - $signed(pr9[25:0]);
    wire signed [25:0] s_band = $signed({{2{fb_v[23]}}, fb_v}) + $signed(pr10[25:0]);
    wire signed [23:0] low_c  = (s_low  > 26'sd8388607) ? 24'sd8388607 : (s_low  < -26'sd8388608) ? -24'sd8388608 : s_low[23:0];
    wire signed [23:0] high_c = (s_high > 26'sd8388607) ? 24'sd8388607 : (s_high < -26'sd8388608) ? -24'sd8388608 : s_high[23:0];
    wire signed [23:0] band_c = (s_band > 26'sd8388607) ? 24'sd8388607 : (s_band < -26'sd8388608) ? -24'sd8388608 : s_band[23:0];
    wire signed [23:0] f_sel  = (fmode == 2'd0) ? fl_n : (fmode == 2'd1) ? band_c : (fmode == 2'd2) ? fh
                              : {{6{mixv[17]}}, mixv};
    wire signed [17:0] fo_w = (f_sel > 24'sd131071) ? 18'sd131071 : (f_sel < -24'sd131072) ? -18'sd131072 : f_sel[17:0];

    // ---------------------------------------------------------------- master chain state
    reg signed [20:0] pre21 = 21'sd0;
    reg signed [15:0] c16 = 16'sd0, cube = 16'sd0, y = 16'sd0, held = 16'sd0, s = 16'sd0;
    reg [5:0]  ds_cnt = 6'd0;
    reg signed [15:0] ret_d = 16'sd0, ret_l = 16'sd0, lp = 16'sd0;
    reg signed [15:0] loopv = 16'sd0, fbv = 16'sd0, wetv = 16'sd0, dly_in = 16'sd0, loop_rec = 16'sd0;
    reg signed [17:0] outp = 18'sd0;
    wire signed [35:0] pre36 = pr3;                                           // acc x gain / 512
    wire signed [20:0] pre_sat = (pre36 > 36'sd1048575) ? 21'sd1048575 : (pre36 < -36'sd1048576) ? -21'sd1048576 : pre36[20:0];
    wire signed [15:0] pre_c16 = (pre36 > 36'sd32767) ? 16'sd32767 : (pre36 < -36'sd32768) ? -16'sd32768 : pre36[15:0];
    // wavefolder: a triangle of the input, period 131072 (folds every +-32768)
    wire [16:0] fq = pre21[16:0] + 17'd32768;
    wire signed [17:0] fold_w = fq[16] ? $signed(18'd98304) - $signed({1'b0, fq}) : $signed({1'b0, fq}) - 18'sd32768;
    wire signed [15:0] fold16 = (fold_w > 18'sd32767) ? 16'sd32767 : (fold_w < -18'sd32767) ? -16'sd32767 : fold_w[15:0];
    // soft clip: 1.5 x - 0.5 x^3
    wire signed [17:0] soft_w = s18(c16) + (s18(c16) >>> 1) - (s18(cube) >>> 1);
    wire [15:0] cmask = 16'hFFFF << (5'd16 - bits_eff);
    wire signed [15:0] ysel = (dshape == 2'd1) ? sat16_18(soft_w) : (dshape == 2'd3) ? fold16 : c16;
    wire signed [15:0] ycr = ysel & $signed(cmask);
    wire signed [17:0] sum_fb = s18(s) + s18(fbv);
    wire signed [17:0] sum_wet = s18(s) + s18(wetv);
    wire signed [18:0] sum_out = {sum_wet[17], sum_wet} + {{3{loopv[15]}}, loopv};
    wire signed [17:0] lpd = s18(ret_d) - s18(lp);

    // ---------------------------------------------------------------- FX FIFOs (to / from orphan-fxd on the ARM)
    (* ram_style = "block" *) reg [31:0] cap2 [0:4095];
    (* ram_style = "block" *) reg [31:0] play [0:4095];
    reg [12:0] cw2 = 13'd0, cr2 = 13'd0, pw2 = 13'd0, prd = 13'd0;
    wire [12:0] cap2_n = cw2 - cr2;
    wire [12:0] play_n = pw2 - prd;
    reg [31:0] cap2q = 32'd0, playq = 32'd0;
    reg [31:0] cap2_t = 32'd0, play_t = 32'd0, underruns = 32'd0;
    reg        cap2_ovf = 1'b0;
    reg        push2 = 1'b0, popp = 1'b0, flush = 1'b0;
    wire       bus_pop2  = bus_re && sel && idx[9];
    wire       bus_push  = bus_we && sel && idx[9];

    always @(posedge clk) begin
        new_sample <= 1'b0;
        push2 <= 1'b0;
        popp <= 1'b0;
        if (!busy) begin
            if (frame_start) begin busy <= 1'b1; step <= 7'd0; end
        end else begin
            case (step)
            // ---- once per sample: two LFOs, then the mod matrix
            7'd0: begin
                lfo1_ph <= lfo1_ph + lfo1_inc; lfo2_ph <= lfo2_ph + lfo2_inc;
                wrap1 <= ({1'b0, lfo1_ph} + {1'b0, lfo1_inc}) >> 32;
                wrap2 <= ({1'b0, lfo2_ph} + {1'b0, lfo2_inc}) >> 32;
                acc <= 24'sd0; step <= 7'd1;
            end
            7'd1: begin rom2_a <= lfo1_ph[31:22]; step <= 7'd2; end
            7'd2: begin rom2_a <= lfo2_ph[31:22]; step <= 7'd3; end
            7'd3: begin lsin1 <= sine2; if (wrap1) sh1 <= $signed(lfsr); step <= 7'd4; end
            7'd4: begin lsin2 <= sine2; if (wrap2) sh2 <= $signed(lfsr ^ 16'h5A5A); step <= 7'd5; end
            7'd5: begin L1 <= lshape(shape1, lfo1_ph, lsin1, sh1); L2 <= lshape(shape2, lfo2_ph, lsin2, sh2); step <= 7'd6; end
            7'd6: begin ma <= s18(L1); mb <= s18(L2); step <= 7'd7;
                m_pitch <= 0; m_cut <= 0; m_res <= 0; m_amp <= 0; m_pw <= 0; m_drive <= 0; m_crush <= 0; end
            7'd7: step <= 7'd8;
            7'd8: begin L3 <= pr15[15:0]; step <= 7'd9; end
            7'd9:  begin ma <= s18(srcval(src0, dst0, L1, L2, L3)); mb <= s18(slot0[31:16]); step <= 7'd10; end
            7'd10: begin ma <= s18(srcval(src1, dst1, L1, L2, L3)); mb <= s18(slot1[31:16]); step <= 7'd11; end
            7'd11, 7'd12, 7'd13, 7'd14: begin                       // accumulate slot (step - 11)
                if (step == 7'd11) begin ma <= s18(srcval(src2, dst2, L1, L2, L3)); mb <= s18(slot2[31:16]); end
                if (step == 7'd12) begin ma <= s18(srcval(src3, dst3, L1, L2, L3)); mb <= s18(slot3[31:16]); end
                case ((step == 7'd11) ? dst0 : (step == 7'd12) ? dst1 : (step == 7'd13) ? dst2 : dst3)
                    3'd1: m_pitch <= m_pitch + mod_v;
                    3'd2: m_cut <= m_cut + mod_v;
                    3'd3: m_res <= m_res + mod_v;
                    3'd4: m_amp <= m_amp + mod_v;
                    3'd5: m_pw <= m_pw + mod_v;
                    3'd6: m_drive <= m_drive + mod_v;
                    3'd7: m_crush <= m_crush + mod_v;
                    default: ;
                endcase
                step <= step + 1'b1;
            end
            7'd15: begin                                              // apply the modulation
                vib <= sat16_18(m_pitch);
                flfo <= sat16_18(m_cut);
                pwm_mod <= sat16_18(m_pw >>> 1);
                begin : apply_res
                    reg signed [19:0] r;
                    r = $signed({4'd0, reso}) - (m_res <<< 1);
                    reso_eff <= (r < 20'sd2000) ? 16'd2000 : (r > 20'sd65535) ? 16'd65535 : r[15:0];
                end
                begin : apply_amp
                    reg signed [19:0] a;
                    a = 20'sd65535 - (m_amp <<< 1);
                    trem_g <= (a < 20'sd0) ? 16'd0 : (a > 20'sd65535) ? 16'd65535 : a[15:0];
                end
                begin : apply_drive
                    reg signed [19:0] d;
                    d = $signed({4'd0, drive}) + (m_drive <<< 1);
                    drive_eff <= (d < 20'sd256) ? 16'd256 : (d > 20'sd65535) ? 16'd65535 : d[15:0];
                end
                begin : apply_crush
                    reg signed [6:0] b;
                    b = $signed({2'b00, bits}) - $signed(m_crush[17:12]);
                    bits_eff <= (b < 7'sd1) ? 5'd1 : (b > 7'sd16) ? 5'd16 : b[4:0];
                end
                v <= 3'd0; step <= 7'd16;
            end

            // ---- per voice (16 .. 43)
            7'd16: begin
                ma <= {1'b0, inc[v][31:15]}; mb <= s18(vib);
                lfsr <= {1'b0, lfsr[15:1]} ^ (lfsr[0] ? 16'hB400 : 16'h0000);
                case (st[v])
                    2'd0: if (gate[v]) st[v] <= 2'd1;
                    2'd1: if (!gate[v]) st[v] <= 2'd3;
                          else if (env[v] > 24'hFFFFFF - atk) begin env[v] <= 24'hFFFFFF; st[v] <= 2'd2; end
                          else env[v] <= env[v] + atk;
                    2'd2: if (!gate[v]) st[v] <= 2'd3;
                          else if (env[v] > {sus, 8'd0} + dec) env[v] <= env[v] - dec;
                          else env[v] <= {sus, 8'd0};
                    2'd3: if (gate[v]) st[v] <= 2'd1;
                          else if (env[v] <= rel) begin env[v] <= 24'd0; st[v] <= 2'd0; end
                          else env[v] <= env[v] - rel;
                endcase
                case (fst[v])
                    2'd0: if (gate[v]) fst[v] <= 2'd1;
                    2'd1: if (!gate[v]) fst[v] <= 2'd3;
                          else if (fenv[v] > 24'hFFFFFF - fatk) begin fenv[v] <= 24'hFFFFFF; fst[v] <= 2'd2; end
                          else fenv[v] <= fenv[v] + fatk;
                    2'd2: if (!gate[v]) fst[v] <= 2'd3;
                          else if (fenv[v] > {fsus, 8'd0} + fdec) fenv[v] <= fenv[v] - fdec;
                          else fenv[v] <= {fsus, 8'd0};
                    2'd3: if (gate[v]) fst[v] <= 2'd1;
                          else if (fenv[v] <= frel) begin fenv[v] <= 24'd0; fst[v] <= 2'd0; end
                          else fenv[v] <= fenv[v] - frel;
                endcase
                step <= 7'd17;
            end
            7'd17: step <= 7'd18;
            7'd18: begin
                phase[v] <= ph_sum[31:0];
                if (ph_sum[32]) subb[v] <= ~subb[v];
                ph_r <= ph_sum[31:0];
                rom_a <= ph_sum[31:22];
                step <= 7'd19;
            end
            7'd19: step <= 7'd20;
            7'd20: begin o_sin <= sine; msum <= 28'sd0; ma <= s18(o_saw); mb <= {10'd0, lvl_saw}; step <= 7'd21; end
            7'd21: begin ma <= s18(o_pul); mb <= {10'd0, lvl_pul}; step <= 7'd22; end
            7'd22: begin msum <= msum + $signed(pr[27:0]); ma <= s18(o_tri); mb <= {10'd0, lvl_tri}; step <= 7'd23; end
            7'd23: begin msum <= msum + $signed(pr[27:0]); ma <= s18(o_sin); mb <= {10'd0, lvl_sin}; step <= 7'd24; end
            7'd24: begin msum <= msum + $signed(pr[27:0]); ma <= s18(o_sub); mb <= {10'd0, lvl_sub}; step <= 7'd25; end
            7'd25: begin msum <= msum + $signed(pr[27:0]); ma <= s18(o_noi); mb <= {10'd0, lvl_noi}; step <= 7'd26; end
            7'd26: begin msum <= msum + $signed(pr[27:0]); ma <= {1'b0, fenv[v][23:7]}; mb <= s18(famt); step <= 7'd27; end
            7'd27: begin msum <= msum + $signed(pr[27:0]); step <= 7'd28; end
            7'd28: begin mixv <= mixv_w; crom_a <= cl_c[15:7]; step <= 7'd29; end
            7'd29: step <= 7'd30;
            7'd30: begin fco <= crom_q; ma <= fb_v[23:6]; mb <= {2'b00, crom_q}; step <= 7'd31; end
            7'd31: begin ma <= fb_v[23:6]; mb <= {2'b00, reso_eff}; step <= 7'd32; end
            7'd32: begin fl_n <= low_c; step <= 7'd33; end
            7'd33: begin fh <= high_c; step <= 7'd34; end
            7'd34: begin ma <= fh[23:6]; mb <= {2'b00, fco}; step <= 7'd35; end
            7'd35: step <= 7'd36;
            7'd36: begin fb[v] <= band_c; fl[v] <= fl_n; fo <= fo_w; step <= 7'd37; end
            7'd37: begin ma <= {2'b00, env[v][23:8]}; mb <= {2'b00, gain[v]}; step <= 7'd38; end
            7'd38: step <= 7'd39;
            7'd39: begin ma <= {2'b00, pr[31:16]}; mb <= {2'b00, trem_g}; step <= 7'd40; end
            7'd40: step <= 7'd41;
            7'd41: begin ma <= fo; mb <= {2'b00, pr[31:16]}; step <= 7'd42; end
            7'd42: step <= 7'd43;
            7'd43: begin
                acc <= acc + $signed(pr16[23:0]);
                active[v] <= (st[v] != 2'd0);
                envtop[v*8 +: 8] <= env[v][23:16];
                if (v == 3'd7) step <= 7'd48; else begin v <= v + 1'b1; step <= 7'd16; end
            end

            // ---- master: drive -> crush -> delay + looper -> volume
            7'd48: begin ma <= acc[23:6]; mb <= {2'b00, (dshape == 2'd0) ? 16'd256 : drive_eff}; step <= 7'd49; end
            7'd49: step <= 7'd50;
            7'd50: begin pre21 <= pre_sat; c16 <= pre_c16; step <= 7'd51; end
            7'd51: begin ma <= s18(c16); mb <= s18(c16); step <= 7'd52; end              // x^2
            7'd52: step <= 7'd53;
            7'd53: begin ma <= {1'b0, pr[31:15]}; mb <= s18(c16); step <= 7'd54; end     // x^3 (x^2 >= 0)
            7'd54: step <= 7'd55;
            7'd55: begin cube <= sat16_18(pr15[17:0]); step <= 7'd56; end
            7'd56: begin y <= ycr; step <= 7'd57; end                                   // shape + bit depth
            7'd57: begin                                                                 // sample-rate reduce
                if (ds_cnt == 6'd0) begin held <= y; s <= y; ds_cnt <= (ds_n == 6'd0) ? 6'd0 : ds_n - 1'b1; end
                else begin s <= held; ds_cnt <= ds_cnt - 1'b1; end
                // take this sample's returns from orphan-fxd
                if (ctrl[2] && play_n != 13'd0) begin
                    ret_d <= $signed(playq[31:16]); ret_l <= $signed(playq[15:0]); popp <= 1'b1;
                end else begin
                    ret_d <= 16'sd0; ret_l <= 16'sd0;
                    if (ctrl[2]) underruns <= underruns + 1'b1;
                end
                step <= 7'd58;
            end
            7'd58: begin ma <= lpd; mb <= {2'b00, dly_tone}; step <= 7'd59; end         // tone: one-pole low-pass
            7'd59: begin ma <= s18(ret_l); mb <= {2'b00, loop_vol}; step <= 7'd60; end
            7'd60: begin lp <= sat16_18(s18(lp) + pr16[17:0]); step <= 7'd61; end
            7'd61: begin loopv <= pr16[15:0]; ma <= s18(lp); mb <= {2'b00, dly_fb}; step <= 7'd62; end
            7'd62: begin ma <= s18(lp); mb <= {2'b00, dly_wet}; step <= 7'd63; end
            7'd63: begin fbv <= pr16[15:0]; step <= 7'd64; end
            7'd64: begin wetv <= pr16[15:0]; step <= 7'd65; end
            7'd65: begin
                dly_in <= sat16_18(sum_fb);
                loop_rec <= sat16_18(sum_wet);
                outp <= (sum_out > 19'sd131071) ? 18'sd131071 : (sum_out < -19'sd131072) ? -18'sd131072 : sum_out[17:0];
                step <= 7'd66;
            end
            7'd66: begin push2 <= ctrl[2]; ma <= outp; mb <= {9'd0, vol}; step <= 7'd67; end
            7'd67: step <= 7'd68;
            7'd68: begin
                mix_out <= (pr8 > 36'sd32767) ? 16'sd32767 : (pr8 < -36'sd32768) ? -16'sd32768 : pr8[15:0];
                new_sample <= 1'b1; busy <= 1'b0;
            end
            default: busy <= 1'b0;
            endcase
        end
        if (new_sample) T <= T + 1'b1;
    end

    // FX FIFOs: capture to orphan-fxd, returns from it
    always @(posedge clk) begin
        if (flush) begin cr2 <= cw2; prd <= pw2; cap2_ovf <= 1'b0; end
        else begin
            if (push2) begin
                if (cap2_n < 13'd4095) begin
                    cap2[cw2[11:0]] <= {dly_in, loop_rec};
                    cw2 <= cw2 + 1'b1;
                    if (cap2_n == 13'd0 || (bus_pop2 && cap2_n == 13'd1)) cap2_t <= T;
                end else cap2_ovf <= 1'b1;
            end
            if (bus_pop2 && cap2_n != 13'd0) begin cr2 <= cr2 + 1'b1; cap2_t <= cap2_t + 1'b1; end
            if (popp) prd <= prd + 1'b1;
            if (bus_push && play_n < 13'd4095) begin
                play[pw2[11:0]] <= bus_wdata;
                pw2 <= pw2 + 1'b1;
            end
        end
        // time at which the next written return plays: one later per push; after an underrun, right after now
        if (step == 7'd57 && busy && ctrl[2] && play_n == 13'd0)
            play_t <= T + 1'b1 + ((bus_push && play_n < 13'd4095) ? 32'd1 : 32'd0);
        else if (bus_push && play_n < 13'd4095 && !flush) play_t <= play_t + 1'b1;
        cap2q <= cap2[cr2[11:0] + (bus_pop2 && cap2_n != 13'd0)];
        playq <= play[prd[11:0] + popp];
    end

    // ---------------------------------------------------------------- LED levels
    function [7:0] max8(input [7:0] a, input [7:0] b);
        max8 = (a > b) ? a : b;
    endfunction
    assign led_voice = {max8(envtop[63:56], envtop[55:48]), max8(envtop[47:40], envtop[39:32]),
                        max8(envtop[31:24], envtop[23:16]), max8(envtop[15:8], envtop[7:0])};
    reg [5:0] vu_div = 6'd0;
    wire [15:0] mag = mix_out[15] ? (~mix_out + 1'b1) : mix_out;
    wire [7:0]  mag8 = (mag[15:14] != 2'b00) ? 8'hFF : mag[13:6];
    always @(posedge clk) if (new_sample) begin
        vu_div <= vu_div + 1'b1;
        if (mag8 > led_vu) led_vu <= mag8;
        else if (vu_div == 6'd0 && led_vu != 8'd0) led_vu <= led_vu - 1'b1;
    end

    // ---------------------------------------------------------------- I2S out (same sample on L and R)
    reg signed [15:0] cur = 16'sd0;
    wire [4:0] pos = slot[4:0];
    always @(posedge clk) begin
        if (frame_start) cur <= mix_out;
        if (bit_start) begin
            lrclk <= on & slot[5];
            dout <= on && (pos >= 5'd1) && (pos <= 5'd16) && cur[5'd16 - pos];
        end
    end

    // ---------------------------------------------------------------- capture buffer for the browser
    (* ram_style = "block" *) reg [15:0] cap [0:2047];
    reg [11:0] cw = 12'd0, cr = 12'd0;
    wire [11:0] cap_n = cw - cr;
    reg [15:0] capq = 16'd0;
    wire push = new_sample && ctrl[1] && on;
    always @(posedge clk) begin
        if (push && cap_n != 12'd2048) cap[cw[10:0]] <= mix_out;
        capq <= cap[cr[10:0]];
    end

    // ---------------------------------------------------------------- registers
    wire [2:0] vv = idx[4:2];
    always @(posedge clk) begin
        flush <= 1'b0;
        if (push && cap_n != 12'd2048) cw <= cw + 1'b1;
        if (!rstn) begin ctrl <= 3'd0; gate <= 8'd0; end
        else if (bus_we && sel && !idx[9]) begin
            if (idx[9:5] == 5'd1) begin
                case (idx[1:0])
                    2'd0: inc[vv] <= bus_wdata;
                    2'd1: gate[vv] <= bus_wdata[0];
                    2'd2: gain[vv] <= bus_wdata[15:0];
                    default: ;
                endcase
            end else case (idx)
                10'd0:  ctrl <= bus_wdata[2:0];
                10'd1:  lvl_saw <= bus_wdata[7:0];
                10'd2:  lvl_pul <= bus_wdata[7:0];
                10'd3:  lvl_tri <= bus_wdata[7:0];
                10'd4:  lvl_sin <= bus_wdata[7:0];
                10'd5:  lvl_sub <= bus_wdata[7:0];
                10'd6:  lvl_noi <= bus_wdata[7:0];
                10'd7:  atk <= bus_wdata[23:0];
                10'd8:  dec <= bus_wdata[23:0];
                10'd9:  sus <= bus_wdata[15:0];
                10'd10: rel <= bus_wdata[23:0];
                10'd11: fatk <= bus_wdata[23:0];
                10'd12: fdec <= bus_wdata[23:0];
                10'd13: fsus <= bus_wdata[15:0];
                10'd14: frel <= bus_wdata[23:0];
                10'd15: cutoff <= bus_wdata[15:0];
                10'd16: reso <= bus_wdata[15:0];
                10'd17: famt <= bus_wdata[15:0];
                10'd18: vol <= (bus_wdata[8:0] > 9'd256) ? 9'd256 : bus_wdata[8:0];
                10'd19: lfo1_inc <= bus_wdata;
                10'd20: lfo2_inc <= bus_wdata;
                10'd21: begin shape1 <= bus_wdata[2:0]; shape2 <= bus_wdata[5:3]; end
                10'd22: slot0 <= bus_wdata;
                10'd23: slot1 <= bus_wdata;
                10'd24: slot2 <= bus_wdata;
                10'd25: slot3 <= bus_wdata;
                10'd30: fmode <= bus_wdata[1:0];
                10'd31: pw <= bus_wdata[15:0];
                10'd64: begin drive <= (bus_wdata[15:0] < 16'd256) ? 16'd256 : bus_wdata[15:0]; dshape <= bus_wdata[17:16]; end
                10'd65: begin bits <= (bus_wdata[4:0] == 5'd0) ? 5'd1 : (bus_wdata[4:0] > 5'd16) ? 5'd16 : bus_wdata[4:0];
                              ds_n <= (bus_wdata[13:8] == 6'd0) ? 6'd1 : bus_wdata[13:8]; end
                10'd66: dly_fb <= bus_wdata[15:0];
                10'd67: dly_wet <= bus_wdata[15:0];
                10'd68: dly_tone <= bus_wdata[15:0];
                10'd69: loop_vol <= bus_wdata[15:0];
                10'd70: flush <= 1'b1;
                default: ;
            endcase
        end
        if (bus_re) begin
            if (!sel) bus_rdata <= 32'd0;
            else if (idx[9]) bus_rdata <= (cap2_n != 13'd0) ? cap2q : 32'd0;
            else case (idx)
                10'd0:  bus_rdata <= {29'd0, ctrl};
                10'd25: if (cap_n != 0) begin bus_rdata <= {{16{capq[15]}}, capq}; cr <= cr + 1'b1; end
                        else bus_rdata <= 32'd0;
                10'd26: bus_rdata <= {20'd0, cap_n};
                10'd27: bus_rdata <= 32'h53594E33;             // "SYN3"
                10'd28: bus_rdata <= {24'd0, active};
                10'd29: bus_rdata <= {{16{mix_out[15]}}, mix_out};
                10'd72: bus_rdata <= T;
                10'd73: bus_rdata <= cap2_t;
                10'd74: bus_rdata <= {cap2_ovf, 18'd0, cap2_n};
                10'd75: bus_rdata <= play_t;
                10'd76: bus_rdata <= {19'd0, play_n};
                10'd77: bus_rdata <= underruns;
                default: bus_rdata <= 32'd0;
            endcase
        end
    end
endmodule
