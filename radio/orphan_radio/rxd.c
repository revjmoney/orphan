// orphan-rxd: the board-side receiver DSP for Orphan Radio (JMSCNC, Rev. J. Money 2026, GPL-3 + attribution).
//
// The FPGA hands over 12207 Hz complex baseband (I/Q) plus its own AM audio. This program owns that stream and
// does everything that used to run in the PC's browser, so the radio works with no PC at all:
//   demodulators  AM (the FPGA's), SAM (carrier PLL), USB, LSB, CW (700 Hz note), NFM
//   audio filters hum comb (50/60 Hz + harmonics, cubic fractional delay) and auto-notch (NLMS)
//   decoders      CW (Morse to text), NAVTEX (SITOR-B / CCIR 476 FEC, 518 kHz), WWVB (60 kHz time code)
// Everything goes into /dev/shm/orphan_rx (struct rxshm): a ring of {I, Q, audio} samples for main.py to stream,
// decoder text, and status. main.py writes the controls into the same struct.
//
// Build on the board:  gcc -O2 -o orphan-rxd rxd.c -lm
// Run:                 orphan-rxd            (live: reads the FPGA, needs root for /dev/mem)
//                      orphan-rxd --file x.iq [demod] [decoder]   (test: int16 I,Q pairs at 12207 Hz; prints text)
//                      orphan-rxd --iq-stdin /path/to/rxshm      (live external I,Q at 100 MHz / 8192)
#define _GNU_SOURCE
#include <fcntl.h>
#include <math.h>
#include <sched.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

#define FS       12207.03125
#define RAD_BASE 0x43C01000u
#define WIN      512
#define RING     65536                      /* samples in the shared ring (5.4 s) */
#define TEXTN    8192

enum { D_AM, D_SAM, D_USB, D_LSB, D_CW, D_NFM };
enum { X_OFF, X_CW, X_NAVTEX, X_WWVB, X_SSTV };
#define IMG_W 640
#define IMG_H 496
#define PANN  2048                          /* panadapter bins (4096-point FFT, pairs max-pooled) */
#define SNAPN 4096
#define SRING 16384                         /* slice ring: 1.3 s */

struct rxshm {                              /* main.py packs/unpacks the head of this; keep the order */
    uint32_t magic;                         /* 'ORX1' */
    int32_t  demod, hum;                    /* demod enum; hum 0 / 50 / 60 */
    float    hum_fine, hum_depth;
    int32_t  anf, decoder, quit;
    uint32_t cmd_seq;  int32_t cmd;         /* cmd 1 = clear decoder text */
    uint32_t wpos;                          /* total samples written to the ring */
    int32_t  alive;
    float    cw_wpm, level;
    int32_t  locked;                        /* decoder has sync */
    uint32_t text_w;                        /* total characters written to text[] */
    char     status[128];
    char     text[TEXTN];
    int16_t  ring[RING][3];                 /* I, Q, audio */
    /* SSTV picture (appended after the ring: main.py reads it at RX_RING_OFF + RING * 6) */
    uint32_t img_seq;                       /* +1 when a picture starts */
    int32_t  img_w, img_h, img_rows;        /* size, rows decoded so far */
    char     img_mode[16];
    uint8_t  img[IMG_H][IMG_W][3];
    /* tuners B..D (slices) + the wide panadapter (appended after the picture; main.py: RX_MULTI_OFF) */
    int32_t  multi;                         /* 1 = the FPGA has tuners B..D + panadapter */
    int32_t  s_demod[3];                    /* B..D demod enum, -1 = off (main.py) */
    uint32_t s_wpos;                        /* samples written to sring */
    float    s_level[3];                    /* average |IQ| per slice */
    int32_t  pan_on, pan_rlog, pan_gain;    /* main.py: panadapter on, decimation 2^rlog, gain */
    uint32_t pan_seq;                       /* +1 per new spectrum */
    uint32_t pan_freq;                      /* NCO step the spectrum was taken at */
    int32_t  pan_rlog_used;
    float    pan_db[PANN];                  /* dB per bin, lowest frequency first, CIC droop compensated */
    int16_t  sring[SRING][3][3];            /* per sample: slice B..D x {I, Q, audio} */
};

static struct rxshm *S;
static volatile uint32_t *R;
static volatile sig_atomic_t stop_now;
static void on_sig(int s) { (void)s; stop_now = 1; }

static void put_text(const char *t) { for (; *t; t++) { S->text[S->text_w % TEXTN] = *t; S->text_w++; } }
static void put_char(char ch) { char b[2] = {ch, 0}; put_text(b); }

/* ------------------------------------------------------------------ demodulators (same as the browser had) */
#define NT 129
/* one demodulator per slice (A uses the FPGA's AM; B..D have no FPGA detector, so AM is done here too) */
struct dm {
    float tr[NT], ti[NT], hi[256], hq[256];
    int hp, cur_taps;
    double pll_ph, pll_w, dc, agc, pi_, pq_, bfo, de, lvl;
};
static struct dm DA = {.cur_taps = -1, .agc = 0.05}, DS[3] = {{.cur_taps = -1, .agc = 0.05}, {.cur_taps = -1, .agc = 0.05}, {.cur_taps = -1, .agc = 0.05}};

static void make_taps(struct dm *d, int mode) {
    double fc = 0, bw = 4500;
    if (mode == D_USB) { fc = 1650; bw = 1400; } else if (mode == D_LSB) { fc = -1650; bw = 1400; }
    else if (mode == D_CW) { bw = 250; } else if (mode == D_NFM) { bw = 5000; }
    double s = 0, h[NT], m = (NT - 1) / 2.0;
    for (int i = 0; i < NT; i++) {
        double t = i - m, w = 0.42 - 0.5 * cos(2 * M_PI * i / (NT - 1)) + 0.08 * cos(4 * M_PI * i / (NT - 1));
        h[i] = (t == 0 ? 2 * bw / FS : sin(2 * M_PI * bw / FS * t) / (M_PI * t)) * w; s += h[i];
    }
    for (int i = 0; i < NT; i++) { double a = 2 * M_PI * fc * (i - m) / FS; d->tr[i] = h[i] / s * cos(a); d->ti[i] = h[i] / s * sin(a); }
    d->cur_taps = mode;
}

/* fpga_am: tuner A's AM audio from the FPGA, or NAN when there is none (slices B..D) */
static float demod(struct dm *d, float I, float Q, int mode, float fpga_am) {
    if (mode == D_AM && !isnan(fpga_am)) return fpga_am;
    if (d->cur_taps != mode) make_taps(d, mode);
    d->hi[d->hp] = I / 32768.0f; d->hq[d->hp] = Q / 32768.0f;
    float yr = 0, yi = 0;
    for (int j = 0; j < NT; j++) { int k = (d->hp - j) & 255; yr += d->tr[j] * d->hi[k] - d->ti[j] * d->hq[k]; yi += d->tr[j] * d->hq[k] + d->ti[j] * d->hi[k]; }
    d->hp = (d->hp + 1) & 255;
    double a = 0;
    if (mode == D_USB || mode == D_LSB) a = yr;
    else if (mode == D_CW) { d->bfo += 2 * M_PI * 700 / FS; if (d->bfo > 2 * M_PI) d->bfo -= 2 * M_PI; a = yr * cos(d->bfo) - yi * sin(d->bfo); }
    else if (mode == D_NFM) { double r = yr * d->pi_ + yi * d->pq_, i2 = yi * d->pi_ - yr * d->pq_; a = atan2(i2, r) * FS / (2 * M_PI * 3000);
        d->pi_ = yr; d->pq_ = yi; d->de += (a - d->de) * 0.25; a = d->de; }
    else if (mode == D_AM) { double mg = sqrt((double)yr * yr + (double)yi * yi); d->dc += (mg - d->dc) * 0.002; a = mg - d->dc; }
    else { double c = cos(d->pll_ph), s = sin(d->pll_ph), zr = yr * c + yi * s, zi = yi * c - yr * s, err = atan2(zi, fabs(zr) + 1e-9);
        d->pll_w += 0.00002 * err; if (d->pll_w > 0.02) d->pll_w = 0.02; if (d->pll_w < -0.02) d->pll_w = -0.02;
        d->pll_ph += d->pll_w + 0.005 * err; if (d->pll_ph > M_PI) d->pll_ph -= 2 * M_PI; if (d->pll_ph < -M_PI) d->pll_ph += 2 * M_PI;
        d->dc += (zr - d->dc) * 0.002; a = zr - d->dc; }
    d->agc = fmax(fabs(a), fmax(d->agc * 0.9997, 1e-4));
    return (float)(0.45 * a / d->agc * 32767.0);
}

/* the decoders' own narrow low-pass (+-250 Hz around the dial), separate from the listening demodulator */
static float dtap[NT], dhi[256], dhq[256]; static int dhp, dtap_ok;
static void dec_filter(float I, float Q, float *yr, float *yi) {
    if (!dtap_ok) { double s = 0, m = (NT - 1) / 2.0, bw = 250;
        for (int i = 0; i < NT; i++) { double t = i - m, w = 0.42 - 0.5 * cos(2 * M_PI * i / (NT - 1)) + 0.08 * cos(4 * M_PI * i / (NT - 1));
            dtap[i] = (float)((t == 0 ? 2 * bw / FS : sin(2 * M_PI * bw / FS * t) / (M_PI * t)) * w); s += dtap[i]; }
        for (int i = 0; i < NT; i++) dtap[i] /= (float)s; dtap_ok = 1; }
    dhi[dhp] = I / 32768.0f; dhq[dhp] = Q / 32768.0f;
    float r = 0, q = 0;
    for (int j = 0; j < NT; j++) { int k = (dhp - j) & 255; r += dtap[j] * dhi[k]; q += dtap[j] * dhq[k]; }
    dhp = (dhp + 1) & 255; *yr = r; *yi = q;
}

/* ------------------------------------------------------------------ hum comb + auto-notch (as in the browser) */
static float HX[1024], HY[1024]; static int Hp;
static float lag4(const float *b, int p, double D) {
    int Di = (int)floor(D); double t = D - Di;
#define G(k) b[(p - Di + 1 - (k) + 4096) & 1023]
    return (float)(G(0) * (-t * (t - 1) * (t - 2) / 6) + G(1) * ((t + 1) * (t - 1) * (t - 2) / 2)
                 + G(2) * (-(t + 1) * t * (t - 2) / 2) + G(3) * ((t + 1) * t * (t - 1) / 6));
#undef G
}
static float hum_comb(float x, double line, double depth) {
    double D = FS / line, r = 0.85 + 0.14 * depth;
    float y = x - lag4(HX, Hp, D) + (float)r * lag4(HY, Hp, D);
    HX[Hp] = x; HY[Hp] = y; Hp = (Hp + 1) & 1023; return y;
}
#define AL 32
static float aw[AL], ab[128]; static int ap;
static float auto_notch(float x) {
    x /= 32768.0f; float pr = 0, pw = 1e-6f;
    for (int k = 0; k < AL; k++) { float v = ab[(ap - 16 - k + 256) & 127]; pr += aw[k] * v; pw += v * v; }
    float e = x - pr, mu = 0.02f / pw;
    for (int k = 0; k < AL; k++) aw[k] += mu * e * ab[(ap - 16 - k + 256) & 127];
    ab[ap] = x; ap = (ap + 1) & 127; return e * 32768.0f;
}

/* ------------------------------------------------------------------ CW decoder (Morse to text) */
static const char *MORSE[][2] = {
    {".-", "A"}, {"-...", "B"}, {"-.-.", "C"}, {"-..", "D"}, {".", "E"}, {"..-.", "F"}, {"--.", "G"}, {"....", "H"},
    {"..", "I"}, {".---", "J"}, {"-.-", "K"}, {".-..", "L"}, {"--", "M"}, {"-.", "N"}, {"---", "O"}, {".--.", "P"},
    {"--.-", "Q"}, {".-.", "R"}, {"...", "S"}, {"-", "T"}, {"..-", "U"}, {"...-", "V"}, {".--", "W"}, {"-..-", "X"},
    {"-.--", "Y"}, {"--..", "Z"}, {"-----", "0"}, {".----", "1"}, {"..---", "2"}, {"...--", "3"}, {"....-", "4"},
    {".....", "5"}, {"-....", "6"}, {"--...", "7"}, {"---..", "8"}, {"----.", "9"}, {".-.-.-", "."}, {"--..--", ","},
    {"..--..", "?"}, {"-..-.", "/"}, {"-...-", "="}, {".-.-.", "+"}, {"-....-", "-"}, {".--.-.", "@"}, {"---...", ":"},
    {"...-.-", "<SK>"}, {".-...", "<AS>"}, {"-.-.-", "<KA>"}, {"........", "<ERR>"}};
static struct { double env, floor_, peak, dot; int on, len, gap; char sym[12]; int ns; int word_done; } cw = {0, 1e-4, 1e-3, 0.06 * FS, 0, 0, 0, "", 0, 1};
static void cw_flush(void) {
    if (!cw.ns) return;
    cw.sym[cw.ns] = 0;
    const char *out = "*";
    for (size_t i = 0; i < sizeof MORSE / sizeof MORSE[0]; i++) if (!strcmp(MORSE[i][0], cw.sym)) { out = MORSE[i][1]; break; }
    put_text(out); cw.ns = 0; cw.word_done = 0;
}
static void cw_sample(float yr, float yi) {
    double m = sqrt(yr * yr + yi * yi);
    cw.env += (m - cw.env) * (1.0 / (0.004 * FS));                       /* 4 ms smoothing */
    if (cw.env > cw.peak) cw.peak = cw.env; else cw.peak += (cw.env - cw.peak) * (1.0 / (2.0 * FS));
    if (cw.env < cw.floor_) cw.floor_ = cw.env; else cw.floor_ += (cw.env - cw.floor_) * (1.0 / (3.0 * FS));
    double hiT = cw.floor_ + 0.55 * (cw.peak - cw.floor_), loT = cw.floor_ + 0.40 * (cw.peak - cw.floor_);
    int keyed = cw.on ? (cw.env > loT) : (cw.env > hiT);
    if (cw.peak < cw.floor_ * 3) keyed = 0;                                /* no signal at all */
    S->locked = cw.peak > cw.floor_ * 3;
    if (keyed && !cw.on) {                                                  /* key down: the gap that just ended */
        if (cw.gap > 2.4 * cw.dot) cw_flush();
        if (cw.gap > 5.5 * cw.dot && !cw.word_done) { put_char(' '); cw.word_done = 1; }
        cw.len = 0;
    } else if (!keyed && cw.on) {                                           /* key up: classify the mark */
        if (cw.len > 0.01 * FS && cw.ns < 10) {
            int dah = cw.len > 2.0 * cw.dot;
            cw.sym[cw.ns++] = dah ? '-' : '.';
            double est = dah ? cw.len / 3.0 : cw.len;                       /* track the dot length (speed) */
            cw.dot += (est - cw.dot) * 0.15;
            if (cw.dot < 0.02 * FS) cw.dot = 0.02 * FS; if (cw.dot > 0.3 * FS) cw.dot = 0.3 * FS;
        }
        cw.gap = 0;
    }
    cw.on = keyed;
    if (cw.on) cw.len++; else {
        cw.gap++;
        if (cw.gap == (int)(2.4 * cw.dot) + 1) cw_flush();
        if (cw.gap == (int)(5.5 * cw.dot) + 1 && !cw.word_done) { put_char(' '); cw.word_done = 1; }
    }
    S->cw_wpm = (float)(1.2 / (cw.dot / FS));
}

/* ------------------------------------------------------------------ NAVTEX (SITOR-B, CCIR 476, FEC) */
/* code -> letter / figure; codes are bits 6..0 as written (1 = B = mark), on air bit 0 first (fldigi) */
static char ltr[128], fig[128];
#define C_ALPHA 0x0F
#define C_BETA  0x33
#define C_FIGS  0x36
#define C_LTRS  0x5A
#define C_SP    0x5C
#define C_REP   0x66
#define C_BLK   0x6A
#define C_LF    0x6C
#define C_CR    0x78
static void ccir_init(void) {
    static const struct { int c; char l, f; } T[] = {
        {0x17,'J','\''}, {0x1B,'F','!'}, {0x1D,'C',':'}, {0x1E,'K','('}, {0x27,'W','2'}, {0x2B,'Y','6'}, {0x2D,'P','0'},
        {0x2E,'Q','1'}, {0x35,'G','&'}, {0x39,'M','.'}, {0x3A,'X','/'}, {0x3C,'V','='}, {0x47,'A','-'}, {0x4B,'S','\''},
        {0x4D,'I','8'}, {0x4E,'U','7'}, {0x53,'D','$'}, {0x55,'R','4'}, {0x56,'E','3'}, {0x59,'N',','}, {0x63,'Z','+'},
        {0x65,'L',')'}, {0x69,'H','#'}, {0x71,'O','9'}, {0x72,'B','?'}, {0x74,'T','5'}};
    for (size_t i = 0; i < sizeof T / sizeof T[0]; i++) { ltr[T[i].c] = T[i].l; fig[T[i].c] = T[i].f; }
}
static int valid476(int c) { return __builtin_popcount(c & 0x7F) == 4; }
static struct {
    double ph, last_d, acc; int cnt; int bits_since;   /* bit clock */
    uint32_t sr;                                        /* last bits, newest in bit 0 */
    int slots[64]; int ns;                              /* recent 7-bit slots at the chosen alignment */
    int align, lock, figs, pol;
    int hist[7]; long nbits;                            /* alignment scoring */
    int parity_votes[2];
    long total;                                         /* slots since lock: never saturates (parity needs it) */
    int out_count;
} nx;
static void nx_emit(int c) {
    if (c == C_LTRS) { nx.figs = 0; return; }
    if (c == C_FIGS) { nx.figs = 1; return; }
    if (c == C_ALPHA || c == C_BETA || c == C_REP || c == C_BLK) return;
    if (c == C_SP) { put_char(' '); return; }
    if (c == C_CR) return;
    if (c == C_LF) { put_char('\n'); return; }
    char ch = nx.figs ? fig[c] : ltr[c];
    put_char(ch ? ch : '_');
}
/* a full 7-bit slot arrived at the locked alignment */
static void nx_slot(int c) {
    if (nx.ns < 64) nx.slots[nx.ns++] = c; else { memmove(nx.slots, nx.slots + 1, 63 * sizeof(int)); nx.slots[63] = c; }
    int n = nx.ns;
    long T = nx.total++;                                /* index of the slot that just arrived */
    if (n < 6) return;
    /* parity: first copies sit in one slot parity; their repeats 5 slots later. Vote for the parity whose
       slot pairs (k, k+5) agree most. */
    int a = nx.slots[n - 6], b = nx.slots[n - 1];
    if (valid476(a) && a == b) nx.parity_votes[(T - 5) & 1]++;
    if (nx.parity_votes[0] + nx.parity_votes[1] > 40) { nx.parity_votes[0] /= 2; nx.parity_votes[1] /= 2; }
    int par = nx.parity_votes[0] >= nx.parity_votes[1] ? 0 : 1;
    /* when the slot that just closed a pair is a repeat (slot index n-1 has the other parity), emit the char */
    if ((T & 1) != par) {
        int first = nx.slots[n - 6], rep = nx.slots[n - 1];
        int c2 = valid476(first) ? first : valid476(rep) ? rep : -1;
        if (c2 >= 0) nx_emit(c2); else put_char('_');
    }
}
static void nx_bit(int bit) {
    nx.sr = (nx.sr << 1) | (bit & 1);
    nx.nbits++;
    /* alignment search: for each of the 7 phases count valid characters over a sliding window */
    int ph = (int)(nx.nbits % 7);
    int c = 0; for (int k = 0; k < 7; k++) c |= ((nx.sr >> k) & 1) << (6 - k);   /* bit 0 first on air: reverse */
    int v = valid476(c);
    nx.hist[ph] += v ? 1 : -1; if (nx.hist[ph] > 40) nx.hist[ph] = 40; if (nx.hist[ph] < -40) nx.hist[ph] = -40;
    int best = 0; for (int k = 1; k < 7; k++) if (nx.hist[k] > nx.hist[best]) best = k;
    if (!nx.lock && nx.hist[best] > 18) { nx.lock = 1; nx.align = best; nx.ns = 0; nx.total = 0; put_text("\n[NAVTEX sync]\n"); }
    /* no sync for 30 s: try the other tone polarity (sources disagree on which NAVTEX tone is mark) */
    if (!nx.lock && nx.nbits % 3000 == 0) { nx.pol ^= 1; for (int k = 0; k < 7; k++) nx.hist[k] = 0; }
    if (nx.lock && nx.hist[nx.align] < 0) { nx.lock = 0; put_text("\n[NAVTEX lost]\n"); }
    if (nx.lock && nx.hist[best] > nx.hist[nx.align] + 10) { nx.align = best; nx.ns = 0; nx.total = 0; }
    if (nx.lock && ph == nx.align) nx_slot(c);
    S->locked = nx.lock;
}
static void navtex_sample(float yr, float yi) {
    /* FSK discriminator on the narrow baseband (dial on 518.000 kHz: tones at +-85 Hz) */
    static float pr, pi2;
    double d = atan2(yi * pr - yr * pi2, yr * pr + yi * pi2) * FS / (2 * M_PI);   /* instantaneous Hz */
    pr = yr; pi2 = yi;
    nx.acc += d; nx.cnt++;
    /* bit clock: 100 baud = 122.07 samples per bit; nudge the phase at every sign change of the smoothed tone */
    static double sm; sm += (d - sm) * 0.15;
    int sgn = sm > 0;
    static int last_sgn;
    double spb = FS / 100.0;
    if (sgn != last_sgn) { double err = nx.ph - spb / 2; nx.ph -= err * 0.1; }
    last_sgn = sgn;
    nx.ph += 1;
    if (nx.ph >= spb) {
        nx.ph -= spb;
        int bit = (nx.acc / (nx.cnt ? nx.cnt : 1)) > 0;                /* mark = the higher tone = 1 */
        if (nx.pol) bit ^= 1;
        nx.acc = 0; nx.cnt = 0;
        nx_bit(bit);
    }
}

/* ------------------------------------------------------------------ WWVB (60 kHz, amplitude time code) */
static struct { double env, hi; int low, lowlen, sec, bits[60], nb, frame_ok; long t; } wv = {0, 1, 0, 0, 0, {0}, 0, 0, 0};
static void wwvb_decode(void) {
    int *b = wv.bits;
    /* b[0] = frame marker (second 0); BCD fields per NIST */
    int minute = 40 * b[1] + 20 * b[2] + 10 * b[3] + 8 * b[5] + 4 * b[6] + 2 * b[7] + b[8];
    int hour = 20 * b[12] + 10 * b[13] + 8 * b[15] + 4 * b[16] + 2 * b[17] + b[18];
    int doy = 200 * b[22] + 100 * b[23] + 80 * b[25] + 40 * b[26] + 20 * b[27] + 10 * b[28] + 8 * b[30] + 4 * b[31] + 2 * b[32] + b[33];
    int year = 80 * b[45] + 40 * b[46] + 20 * b[47] + 10 * b[48] + 8 * b[50] + 4 * b[51] + 2 * b[52] + b[53];
    char t[96];
    snprintf(t, sizeof t, "\nWWVB: 20%02d day %03d  %02d:%02d UTC%s\n", year, doy, hour, minute, b[57] || b[58] ? " (DST)" : "");
    put_text(t);
}
static void wwvb_sample(float I, float Q) {
    double m = sqrt((double)I * I + (double)Q * Q);
    wv.env += (m - wv.env) * (1.0 / (0.01 * FS));                          /* 10 ms */
    if (wv.env > wv.hi) wv.hi = wv.env; else wv.hi += (wv.env - wv.hi) * (1.0 / (5.0 * FS));
    int low = wv.env < 0.45 * wv.hi;
    wv.t++;
    if (low) wv.lowlen++;
    if (!low && wv.low) {                                                   /* end of a reduced-power pulse */
        double s = wv.lowlen / FS;
        int sym = s < 0.1 ? -1 : s < 0.35 ? 0 : s < 0.65 ? 1 : 2;           /* 0.2 s = 0, 0.5 s = 1, 0.8 s = marker */
        if (sym >= 0) {
            char ch = sym == 2 ? 'M' : '0' + sym; put_char(ch);
            static int prev_marker;
            if (sym == 2 && prev_marker) { put_text(" [frame]\n"); wv.nb = 0; wv.bits[wv.nb++] = 2; wv.frame_ok = 1; }
            else if (wv.frame_ok && wv.nb < 60) {
                wv.bits[wv.nb++] = sym == 2 ? 0 : sym;
                if (wv.nb == 60) { wwvb_decode(); wv.nb = 0; wv.frame_ok = 0; }
            }
            prev_marker = sym == 2;
        }
        wv.lowlen = 0;
    }
    wv.low = low;
    S->locked = wv.frame_ok;
}

/* ------------------------------------------------------------------ SSTV (slow-scan TV pictures) */
/* Tones: 1200 Hz sync, 1500 Hz black .. 2300 Hz white; VIS header (1900 leader, 1200 start, 8 x 30 ms bits of
   1100 = 1 / 1300 = 0, LSB first, even parity, 1200 stop) names the mode. Times in ms from the line start. */
enum { K_RGB, K_ROBOT36, K_PD };
static const struct sstv_mode {
    const char *name; int vis, w, h, kind; double line, sync, sync_off, comp; double off[4];
} MODES[] = {
    {"Martin M1", 44, 320, 256, K_RGB, 446.446, 4.862, 0, 146.432, {5.434, 152.438, 299.442}},   /* G, B, R */
    {"Martin M2", 40, 320, 256, K_RGB, 226.798, 4.862, 0, 73.216, {5.434, 79.222, 153.010}},
    {"Scottie S1", 60, 320, 256, K_RGB, 428.22, 9.0, 279.48, 138.24, {1.5, 141.24, 289.98}},
    {"Scottie S2", 56, 320, 256, K_RGB, 277.692, 9.0, 180.628, 88.064, {1.5, 91.064, 191.128}},
    {"Scottie DX", 76, 320, 256, K_RGB, 1050.3, 9.0, 695.7, 345.6, {1.5, 348.6, 706.2}},
    {"Robot 36", 8, 320, 240, K_ROBOT36, 150.0, 9.0, 0, 88.0, {12.0, 106.0}},                    /* Y, chroma 44 ms */
    {"PD90", 99, 320, 256, K_PD, 703.04, 20.0, 0, 170.24, {22.08, 192.32, 362.56, 532.8}},     /* Y1, V, U, Y2 */
    {"PD120", 95, 640, 496, K_PD, 508.48, 20.0, 0, 121.6, {22.08, 143.68, 265.28, 386.88}},
};
#define HN 32768
static struct {
    float hist[HN]; long n;                 /* tone frequency history, n = samples seen */
    float fsm; float pr, pi;
    int state;                              /* 0 hunting VIS, 1 reading VIS bits, 2 picture */
    long vis_start;                         /* sample where the VIS start bit begins */
    const struct sstv_mode *m;
    double next, line_len;                  /* sample where the current line starts, samples per line (tracked) */
    int line, miss;                         /* miss = lines in a row without a sync (the signal went away) */
    uint8_t yrow[IMG_W], vrow[IMG_W];       /* Robot 36: luma + chroma of the previous (even) line */
} sv;
static float sdt_r[NT], sdt_i[NT], shi[256], shq[256]; static int shp, sdt_ok;
static double ms2s(double ms) { return ms * FS / 1000.0; }
static float hist_at(double t) { long k = (long)t; return sv.hist[k & (HN - 1)]; }
static double hist_mean(double a, double b) {                    /* mean tone over samples [a, b) */
    if (!isfinite(a) || !isfinite(b)) return 0;                   /* rxd runs real-time: never spin on bad times */
    long ia = (long)floor(a), ib = (long)ceil(b); if (ib <= ia) ib = ia + 1; if (ib - ia > HN) ib = ia + HN;
    double s = 0; for (long k = ia; k < ib; k++) s += sv.hist[k & (HN - 1)]; return s / (ib - ia);
}
static uint8_t tone2v(double f) { double v = (f - 1500.0) / 800.0 * 255.0; return v < 0 ? 0 : v > 255 ? 255 : (uint8_t)v; }
static uint8_t clamp8(double v) { return v < 0 ? 0 : v > 255 ? 255 : (uint8_t)v; }

static void sstv_picture_line(void) {
    const struct sstv_mode *m = sv.m;
    double L = sv.next;                                          /* expected start of this line */
    /* re-lock on this line's sync pulse: slide a sync-length window +-8 ms, keep the place with most 1200 Hz */
    double sp = L + ms2s(m->sync_off), best = -1, bestp = sp, len = ms2s(m->sync);
    for (double p = sp - ms2s(8); p <= sp + ms2s(8); p += 1) {
        int c = 0; for (int k = 0; k < (int)len; k++) c += hist_at(p + k) < 1350;
        if (c > best) { best = c; bestp = p; }
    }
    if (best > 0.7 * len) {                                      /* found: a 2nd order loop pulls phase + line rate */
        double e = bestp - sp;
        L += 0.5 * e; sv.line_len += 0.08 * e;
        sv.miss = 0;
        double nom = ms2s(m->line);                              /* never let noise drag the rate off by > 1 % */
        if (!(sv.line_len > nom * 0.99)) sv.line_len = nom * 0.99;
        if (!(sv.line_len < nom * 1.01)) sv.line_len = nom * 1.01;
    }
    else sv.miss++;
    sv.next = L + sv.line_len;
    double pxs = ms2s(m->comp) / m->w;
    int rows = m->kind == K_PD ? 2 : 1, row = sv.line * rows;
    if (row + rows > m->h || row + rows > IMG_H) return;
    for (int x = 0; x < m->w; x++) {
        double a = (x) * pxs, b = (x + 1) * pxs;
        if (m->kind == K_RGB) {                                  /* Martin / Scottie: G, B, R scans */
            uint8_t g = tone2v(hist_mean(L + ms2s(m->off[0]) + a, L + ms2s(m->off[0]) + b));
            uint8_t bl = tone2v(hist_mean(L + ms2s(m->off[1]) + a, L + ms2s(m->off[1]) + b));
            uint8_t r = tone2v(hist_mean(L + ms2s(m->off[2]) + a, L + ms2s(m->off[2]) + b));
            S->img[row][x][0] = r; S->img[row][x][1] = g; S->img[row][x][2] = bl;
        } else if (m->kind == K_ROBOT36) {                       /* luma 88 ms, chroma 44 ms: V on even, U on odd */
            uint8_t y = tone2v(hist_mean(L + ms2s(m->off[0]) + a, L + ms2s(m->off[0]) + b));
            double ca = x * (ms2s(44.0) / m->w), cb = (x + 1) * (ms2s(44.0) / m->w);
            uint8_t c = tone2v(hist_mean(L + ms2s(m->off[1]) + ca, L + ms2s(m->off[1]) + cb));
            if ((sv.line & 1) == 0) { sv.yrow[x] = y; sv.vrow[x] = c; }
            else {
                double V = sv.vrow[x] - 128.0, U = c - 128.0;
                for (int k = 0; k < 2; k++) { double Y = k ? y : sv.yrow[x]; int rr = row - 1 + k;
                    S->img[rr][x][0] = clamp8(Y + 1.402 * V); S->img[rr][x][1] = clamp8(Y - 0.344 * U - 0.714 * V);
                    S->img[rr][x][2] = clamp8(Y + 1.772 * U); }
            }
        } else {                                                 /* PD: Y1, V, U, Y2 = two rows */
            double v[4]; for (int k = 0; k < 4; k++) v[k] = tone2v(hist_mean(L + ms2s(m->off[k]) + a, L + ms2s(m->off[k]) + b));
            double V = v[1] - 128.0, U = v[2] - 128.0;
            for (int k = 0; k < 2; k++) { double Y = k ? v[3] : v[0];
                S->img[row + k][x][0] = clamp8(Y + 1.402 * V); S->img[row + k][x][1] = clamp8(Y - 0.344 * U - 0.714 * V);
                S->img[row + k][x][2] = clamp8(Y + 1.772 * U); }
        }
    }
    S->img_rows = row + rows;
}

static void sstv_sample(float I, float Q, int lsb) {
    if (!sdt_ok) {                                               /* complex band-pass 1000..2400 Hz (USB side) */
        double s = 0, h[NT], m = (NT - 1) / 2.0, bw = 750, fc = 1700;
        for (int i = 0; i < NT; i++) { double t = i - m, w = 0.42 - 0.5 * cos(2 * M_PI * i / (NT - 1)) + 0.08 * cos(4 * M_PI * i / (NT - 1));
            h[i] = (t == 0 ? 2 * bw / FS : sin(2 * M_PI * bw / FS * t) / (M_PI * t)) * w; s += h[i]; }
        for (int i = 0; i < NT; i++) { double a = 2 * M_PI * fc * (i - m) / FS; sdt_r[i] = (float)(h[i] / s * cos(a)); sdt_i[i] = (float)(h[i] / s * sin(a)); }
        sdt_ok = 1;
    }
    if (lsb) Q = -Q;                                             /* LSB: mirror the spectrum, then treat as USB */
    shi[shp] = I / 32768.0f; shq[shp] = Q / 32768.0f;
    float yr = 0, yi = 0;
    for (int j = 0; j < NT; j++) { int k = (shp - j) & 255; yr += sdt_r[j] * shi[k] - sdt_i[j] * shq[k]; yi += sdt_r[j] * shq[k] + sdt_i[j] * shi[k]; }
    shp = (shp + 1) & 255;
    double f = atan2(yi * sv.pr - yr * sv.pi, yr * sv.pr + yi * sv.pi) * FS / (2 * M_PI);
    sv.pr = yr; sv.pi = yi;
    sv.fsm += ((float)f - sv.fsm) * 0.5f;
    sv.hist[sv.n & (HN - 1)] = sv.fsm;
    long n = sv.n++;
    if (sv.state == 0) {                                          /* hunt: 30 ms of 1200 after 200 ms of 1900 */
        if (n % 32 || n < ms2s(300)) return;
        double s12 = hist_mean(n - ms2s(30), n), s19 = hist_mean(n - ms2s(230), n - ms2s(30));
        if (fabs(s12 - 1200) < 70 && fabs(s19 - 1900) < 80) {
            long e = n - (long)ms2s(30);                          /* find the 1900 -> 1200 edge precisely */
            for (long k = n - (long)ms2s(60); k < n; k++) if (hist_at(k) < 1550) { e = k; break; }
            sv.vis_start = e; sv.state = 1; S->locked = 0;
        }
    } else if (sv.state == 1) {                                   /* VIS bits once all of them are in */
        if (n < sv.vis_start + ms2s(300)) return;
        int code = 0, ones = 0;
        for (int i = 0; i < 8; i++) {
            double a = sv.vis_start + ms2s(30 + 30 * i + 6), b = sv.vis_start + ms2s(30 + 30 * (i + 1) - 6);
            int bit = hist_mean(a, b) < 1200;
            if (i < 7) code |= bit << i; ones += bit;
        }
        sv.state = 0;
        if (ones & 1) return;                                     /* even parity failed */
        for (size_t i = 0; i < sizeof MODES / sizeof MODES[0]; i++) if (MODES[i].vis == code) sv.m = &MODES[i];
        if (!sv.m || sv.m->vis != code) { sv.m = NULL; return; }
        sv.next = sv.vis_start + ms2s(300);                       /* picture starts after the stop bit */
        if (sv.m->vis == 60 || sv.m->vis == 56 || sv.m->vis == 76) sv.next += ms2s(9.0);   /* Scottie: a first sync */
        sv.line_len = ms2s(sv.m->line); sv.line = 0; sv.miss = 0;
        S->img_w = sv.m->w; S->img_h = sv.m->h; S->img_rows = 0;
        snprintf(S->img_mode, sizeof S->img_mode, "%s", sv.m->name);
        memset(S->img, 0, sizeof S->img);
        S->img_seq++;
        char t[64]; snprintf(t, sizeof t, "\n[SSTV %s, VIS %d]\n", sv.m->name, code); put_text(t);
        sv.state = 2; S->locked = 1;
    } else {                                                      /* picture: decode each line when it is all in */
        int lines = sv.m->kind == K_PD ? sv.m->h / 2 : sv.m->h;
        double need = sv.next + sv.line_len + ms2s(12);
        if (n < need) return;
        sstv_picture_line();
        if (sv.miss > 40) { put_text("[SSTV signal lost]\n"); lines = sv.line + 1; }
        if (++sv.line >= lines) {                                 /* the last line or two never get a "next" sync */
            for (int r = S->img_rows; r > 0 && r < sv.m->h && r < IMG_H; r++) memcpy(S->img[r], S->img[r - 1], sizeof S->img[r]);
            if (S->img_rows > 0) S->img_rows = sv.m->h;
            put_text("[SSTV picture done]\n"); sv.state = 0; S->locked = 0;
        }
    }
}

/* ------------------------------------------------------------------ main loop */
static void process(float I, float Q, float am) {
    float a = demod(&DA, I, Q, S->demod, am);
    if (S->hum && S->demod != D_AM) a = hum_comb(a, S->hum + S->hum_fine, S->hum_depth);   /* AM: done in the FPGA */
    if (S->anf) a = auto_notch(a);
    if (a > 32767) a = 32767; if (a < -32768) a = -32768;
    if (S->decoder == X_CW || S->decoder == X_NAVTEX) {
        float yr, yi; dec_filter(I, Q, &yr, &yi);
        if (S->decoder == X_CW) cw_sample(yr, yi); else navtex_sample(yr, yi);
    } else if (S->decoder == X_WWVB) wwvb_sample(I, Q);
    else if (S->decoder == X_SSTV) sstv_sample(I, Q, S->demod == D_LSB);
    uint32_t w = S->wpos % RING;
    S->ring[w][0] = (int16_t)I; S->ring[w][1] = (int16_t)Q; S->ring[w][2] = (int16_t)a;
    S->wpos++;
}

/* one sample of tuners B..D: v = {B_I, B_Q, C_I, C_Q, D_I, D_Q} */
static void process_slices(const int16_t *v) {
    uint32_t w = S->s_wpos % SRING;
    for (int s = 0; s < 3; s++) {
        float I = v[2 * s], Q = v[2 * s + 1], a = 0;
        if (S->s_demod[s] >= D_AM && S->s_demod[s] <= D_NFM) a = demod(&DS[s], I, Q, S->s_demod[s], NAN);
        if (a > 32767) a = 32767; if (a < -32768) a = -32768;
        DS[s].lvl += (sqrt(I * I + Q * Q) - DS[s].lvl) * 0.001;
        S->s_level[s] = (float)DS[s].lvl;
        S->sring[w][s][0] = (int16_t)I; S->sring[w][s][1] = (int16_t)Q; S->sring[w][s][2] = (int16_t)a;
    }
    S->s_wpos++;
}

/* ------------------------------------------------------------------ wide panadapter: FFT of a captured block */
static float fre[SNAPN], fim[SNAPN], fwin[SNAPN], fcomp[SNAPN];
static int fcomp_rlog = -1;
static void fft4096(float *re, float *im) {
    int n = SNAPN;
    for (int i = 1, j = 0; i < n; i++) { int b = n >> 1; for (; j & b; b >>= 1) j ^= b; j ^= b;
        if (i < j) { float t = re[i]; re[i] = re[j]; re[j] = t; t = im[i]; im[i] = im[j]; im[j] = t; } }
    for (int len = 2; len <= n; len <<= 1) {
        double a = -2 * M_PI / len; float wr = (float)cos(a), wi = (float)sin(a);
        for (int i = 0; i < n; i += len) { float cr = 1, ci = 0;
            for (int k = 0; k < len / 2; k++) {
                float *ur = &re[i + k], *ui = &im[i + k], *vr = &re[i + k + len / 2], *vi = &im[i + k + len / 2];
                float xr = *vr * cr - *vi * ci, xi = *vr * ci + *vi * cr;
                *vr = *ur - xr; *vi = *ui - xi; *ur += xr; *ui += xi;
                float t = cr * wr - ci * wi; ci = cr * wi + ci * wr; cr = t; } } }
}
static void pan_spectrum(const uint32_t *blk, int rlog) {
    if (!fwin[1]) for (int i = 0; i < SNAPN; i++)               /* Blackman-Harris */
        fwin[i] = (float)(0.35875 - 0.48829 * cos(2 * M_PI * i / SNAPN) + 0.14128 * cos(4 * M_PI * i / SNAPN) - 0.01168 * cos(6 * M_PI * i / SNAPN));
    if (fcomp_rlog != rlog) {                                     /* undo the CIC's droop: [sin(pi f R / F) / (R sin(pi f / F))]^4 */
        double R = (double)(1 << rlog);
        for (int i = 0; i < SNAPN; i++) {
            double f = (i - SNAPN / 2) / (double)SNAPN / R;         /* cycles per input clock */
            double h = fabs(f) < 1e-12 ? 1.0 : sin(M_PI * f * R) / (R * sin(M_PI * f));
            double g = -40.0 * log10(fabs(h) + 1e-12); fcomp[i] = (float)(g > 20 ? 20 : g);
        }
        fcomp_rlog = rlog;
    }
    for (int i = 0; i < SNAPN; i++) { fre[i] = (int16_t)(blk[i] >> 16) * fwin[i]; fim[i] = (int16_t)(blk[i] & 0xFFFF) * fwin[i]; }
    fft4096(fre, fim);
    for (int b = 0; b < PANN; b++) {                              /* fftshift, then max of each pair of bins */
        float best = -1e9f;
        for (int k = 0; k < 2; k++) { int i = 2 * b + k, j = (i + SNAPN / 2) % SNAPN;
            float p = 10.0f * log10f(fre[j] * fre[j] + fim[j] * fim[j] + 1e-3f) + fcomp[i];
            if (p > best) best = p; }
        S->pan_db[b] = best;
    }
}

static void setup_shm(const char *path) {
    int fd = open(path, O_RDWR | O_CREAT, 0644);
    if (fd < 0 || ftruncate(fd, sizeof(struct rxshm)) < 0) { perror(path); exit(1); }
    S = mmap(NULL, sizeof *S, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (S == MAP_FAILED) { perror("mmap shm"); exit(1); }
    if (S->magic != 0x3158524Fu) { memset(S, 0, sizeof *S); S->magic = 0x3158524Fu; S->hum_depth = 0.7f; }
    S->quit = 0;
}

static void process_commands(uint32_t *seen) {
    if (S->cmd_seq == *seen) return;
    *seen = S->cmd_seq;
    if (S->cmd == 1) {
        S->text_w = 0;
        memset(S->text, 0, TEXTN);
    }
}

static int run_iq_stdin(const char *shm) {
    setup_shm(shm);
    S->multi = 0;  /* A single network receiver supplies only slice A. */
    uint32_t seen = S->cmd_seq;
    int16_t samples[256][2];
    while (!stop_now && !S->quit) {
        size_t count = fread(samples, sizeof(samples[0]), 256, stdin);
        if (!count) break;
        process_commands(&seen);
        for (size_t k = 0; k < count; ++k)
            process(samples[k][0], samples[k][1], NAN);
        S->alive++;
    }
    return ferror(stdin) ? 1 : 0;
}

int main(int argc, char **argv) {
    ccir_init();
    signal(SIGINT, on_sig); signal(SIGTERM, on_sig);
    if (argc == 3 && !strcmp(argv[1], "--iq-stdin")) return run_iq_stdin(argv[2]);
    if (argc >= 3 && !strcmp(argv[1], "--file")) {                         /* offline test */
        static struct rxshm local; S = &local; memset(S, 0, sizeof *S); S->hum_depth = 0.7f;
        S->demod = argc > 3 ? atoi(argv[3]) : D_AM; S->decoder = argc > 4 ? atoi(argv[4]) : X_OFF;
        if (argc > 5) nx.pol = atoi(argv[5]);
        FILE *f = fopen(argv[2], "rb"); if (!f) { perror(argv[2]); return 1; }
        int16_t s[2]; uint32_t shown = 0;
        while (fread(s, 2, 2, f) == 2) {
            process(s[0], s[1], 0);
            while (shown < S->text_w) { putchar(S->text[shown % TEXTN]); shown++; }
        }
        fclose(f);
        if (S->decoder == X_CW) printf("\n[cw speed %.1f wpm]\n", S->cw_wpm);
        if (S->decoder == X_SSTV && S->img_rows > 0) {            /* test: write the picture as a PPM */
            const char *fn = argc > 6 ? argv[6] : "sstv_out.ppm";
            int ofd = open(fn, O_WRONLY | O_CREAT | O_TRUNC, 0644);
            FILE *o = ofd >= 0 ? fdopen(ofd, "wb") : NULL;
            if (o) { fprintf(o, "P6\n%d %d\n255\n", S->img_w, S->img_h);
                for (int y = 0; y < S->img_h; y++) fwrite(S->img[y], 3, S->img_w, o); fclose(o);
                printf("[picture %s %dx%d, %d rows -> %s]\n", S->img_mode, S->img_w, S->img_h, S->img_rows, fn); }
        }
        printf("\n");
        return 0;
    }
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) { perror("/dev/mem"); return 1; }
    R = mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, RAD_BASE);
    if (R == MAP_FAILED) { perror("mmap"); return 1; }
    if (R[10] != 0x52414431u) { fprintf(stderr, "orphan-rxd: Orphan Radio (RAD1) is not loaded\n"); return 1; }
    setup_shm("/dev/shm/orphan_rx");
    S->multi = (R[27] & 0xFF) >= 4;                                        /* tuners B..D + panadapter in the FPGA */
    for (int s = 0; s < 3; s++) if (S->s_demod[s] == 0 && !S->s_wpos) S->s_demod[s] = -1;
    mlockall(MCL_CURRENT | MCL_FUTURE);
    struct sched_param sp = { .sched_priority = 30 };
    sched_setscheduler(0, SCHED_FIFO, &sp);
    fprintf(stderr, "orphan-rxd: running (demods, filters, decoders on the board)\n");
    uint32_t seen = S->cmd_seq;
    while (!stop_now && !S->quit) {
        process_commands(&seen);
        uint32_t n = R[9] & 0x1FFF;                                        /* words waiting: {I,Q} then {audio, carrier} */
        n &= ~1u; if (n > 512) n = 512;
        static uint32_t w[512];
        for (uint32_t i = 0; i < n; i++) w[i] = R[WIN + i];
        for (uint32_t i = 0; i + 1 < n; i += 2) {
            int16_t I = (int16_t)(w[i] >> 16), Q = (int16_t)(w[i] & 0xFFFF), am = (int16_t)(w[i + 1] >> 16);
            process(I, Q, am);
        }
        S->level = (float)(R[8] & 0xFFFF);
        if (S->multi) {
            uint32_t n2 = R[26] & 0x1FFF;                                  /* tuners B..D: 3 words per sample */
            n2 -= n2 % 3; if (n2 > 768) n2 = 768;
            static uint32_t w2[768];
            for (uint32_t i = 0; i < n2; i++) w2[i] = R[256 + i];
            for (uint32_t i = 0; i + 2 < n2; i += 3) {
                int16_t v[6];
                for (int k = 0; k < 3; k++) { v[2 * k] = (int16_t)(w2[i + k] >> 16); v[2 * k + 1] = (int16_t)(w2[i + k] & 0xFFFF); }
                process_slices(v);
            }
            /* panadapter: arm a capture, then read + FFT it once it is in (~15 per second) */
            static int armed; static struct timespec last;
            struct timespec now; clock_gettime(CLOCK_MONOTONIC, &now);
            double dt = (now.tv_sec - last.tv_sec) + (now.tv_nsec - last.tv_nsec) * 1e-9;
            if (S->pan_on) {
                int rlog = S->pan_rlog < 4 ? 4 : S->pan_rlog > 8 ? 8 : S->pan_rlog, gain = S->pan_gain & 15;
                if (!armed && dt > 0.066) {
                    S->pan_freq = R[24]; S->pan_rlog_used = rlog;
                    R[25] = (uint32_t)(rlog | gain << 4 | 0x100); armed = 1; last = now;
                } else if (armed && (R[25] & 0x80000000u)) {
                    static uint32_t blk[SNAPN];
                    for (int i = 0; i < SNAPN; i++) blk[i] = R[128 + (i & 127)];
                    pan_spectrum(blk, S->pan_rlog_used);
                    S->pan_seq++; armed = 0;
                }
            } else armed = 0;
        }
        S->alive++;
        usleep(5000);
    }
    fprintf(stderr, "orphan-rxd: stopped\n");
    return 0;
}
