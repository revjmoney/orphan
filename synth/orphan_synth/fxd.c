// orphan-fxd: the RAM side of Orphan Synth v3's long delay and looper (JMSCNC, Rev. J. Money 2026, GPL-3 + attribution).
//
// The FPGA streams {delay input, loop record} samples with their sample time (T) and plays back
// {delay return, loop return} at exact times, so this program only has to keep the buffers in RAM:
//   delay line: 2^20 samples (21.5 s) ring, read D samples back (+ optional tape wobble, interpolated)
//   looper:     up to 120 s, record / play / overdub (with decay) / stop / undo / clear / half speed / reverse / save
// Control and status go through /dev/shm/orphan_fx (struct fxctl, written by main.py).
//
// Build on the board:  gcc -O2 -o orphan-fxd fxd.c -lm        Run as root (needs /dev/mem).
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

#define SYN_BASE  0x43C01000u          /* ardzy_bus slot 1 */
#define FS        48828.125
#define DBITS     20
#define DSIZE     (1u << DBITS)
#define DMASK     (DSIZE - 1)
#define LMAX      ((int32_t)(FS * 120))
#define FILL      700                  /* returns kept ahead of the FPGA, samples (~14 ms) */
#define DMIN      (FILL + 1500)        /* shortest delay that is always ready in time (~45 ms) */
#define WIN       512                  /* word index of the FIFO window */

enum { R_ID = 27, R_FLUSH = 70, R_T = 72, R_CAP2_T = 73, R_CAP2_N = 74, R_PLAY_T = 75, R_PLAY_N = 76, R_UNDER = 77 };
enum { S_EMPTY, S_REC, S_PLAY, S_DUB, S_STOP };
enum { C_PEDAL = 1, C_STOP, C_PLAY, C_CLEAR, C_UNDO, C_SAVE };

struct fxctl {                         /* every field 4 bytes; main.py packs the same layout */
    uint32_t magic;                    /* 'OFX1' */
    int32_t  delay;                    /* samples */
    float    wob_depth;                /* samples */
    float    wob_rate;                 /* Hz */
    uint32_t cmd_seq;
    int32_t  cmd;
    int32_t  half, reverse;
    float    decay;                    /* overdub: old layers x decay (1 = keep forever) */
    int32_t  quit;
    int32_t  state, len, pos;
    uint32_t underruns, overflows, resyncs, save_done;
    int32_t  alive;
};

static volatile uint32_t *R;
static volatile sig_atomic_t stop_now;
static void on_sig(int s) { (void)s; stop_now = 1; }

static int16_t *dl, *loopb, *undob;
static int32_t state = S_EMPTY, L = 0, has_undo = 0;
static uint32_t rec_t0, loop_t0, cap_to;   /* times */

static uint32_t next_play_t(void) { uint32_t lvl = R[R_PLAY_N] & 0x1FFF; return R[R_T] + 1 + lvl; }

static int16_t sat16(int32_t x) { return x > 32767 ? 32767 : x < -32768 ? -32768 : (int16_t)x; }

static int32_t loop_pos(uint32_t t, int half, int rev) {
    uint32_t u = t - loop_t0;
    if (half) u >>= 1;
    int32_t p = (int32_t)(u % (uint32_t)L);
    return rev ? L - 1 - p : p;
}

static void save_wav(const char *fn) {
    FILE *f = fopen(fn, "wb");
    if (!f) return;
    uint32_t n = (uint32_t)L * 2, sr = 48828, br = sr * 2;
    fwrite("RIFF", 1, 4, f); uint32_t x = 36 + n; fwrite(&x, 4, 1, f); fwrite("WAVEfmt ", 1, 8, f);
    x = 16; fwrite(&x, 4, 1, f); uint16_t h = 1; fwrite(&h, 2, 1, f); fwrite(&h, 2, 1, f);
    fwrite(&sr, 4, 1, f); fwrite(&br, 4, 1, f); h = 2; fwrite(&h, 2, 1, f); h = 16; fwrite(&h, 2, 1, f);
    fwrite("data", 1, 4, f); fwrite(&n, 4, 1, f); fwrite(loopb, 2, (size_t)L, f); fclose(f);
}

static void command(struct fxctl *c, int cmd) {
    uint32_t now = cap_to;                 /* time of the next captured sample */
    switch (cmd) {
    case C_PEDAL:
        if (state == S_EMPTY) { state = S_REC; rec_t0 = now; }
        else if (state == S_REC) {
            L = (int32_t)(now - rec_t0);
            if (L < 2000) { state = S_EMPTY; L = 0; }
            else {
                loop_t0 = rec_t0; state = S_PLAY;
                int32_t pk = 0; for (int32_t i = 0; i < L; i++) { int32_t a = loopb[i] < 0 ? -loopb[i] : loopb[i]; if (a > pk) pk = a; }
                fprintf(stderr, "orphan-fxd: loop closed, %d samples (%.2f s), peak %d\n", L, L / FS, pk);
            }
        } else if (state == S_PLAY) { memcpy(undob, loopb, (size_t)L * 2); has_undo = 1; state = S_DUB; }
        else if (state == S_DUB) state = S_PLAY;
        else if (state == S_STOP) { loop_t0 = next_play_t(); state = S_PLAY; }
        break;
    case C_STOP:
        if (state == S_REC) { L = (int32_t)(now - rec_t0); loop_t0 = rec_t0; state = L >= 2000 ? S_STOP : S_EMPTY; }
        else if (state == S_PLAY || state == S_DUB) state = S_STOP;
        break;
    case C_PLAY:
        if (state == S_STOP && L > 0) { loop_t0 = next_play_t(); state = S_PLAY; }
        break;
    case C_CLEAR: state = S_EMPTY; L = 0; has_undo = 0; break;
    case C_UNDO:
        if (has_undo && L > 0) { int16_t *t = loopb; loopb = undob; undob = t; if (state == S_DUB) state = S_PLAY; }
        break;
    case C_SAVE:
        if (L > 0) save_wav("/tmp/orphan_loop.wav");
        c->save_done = c->cmd_seq;
        break;
    }
}

int main(void) {
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) { perror("/dev/mem"); return 1; }
    R = mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, SYN_BASE);
    if (R == MAP_FAILED) { perror("mmap"); return 1; }
    if (R[R_ID] != 0x53594E33u) { fprintf(stderr, "orphan-fxd: Orphan Synth v3 (SYN3) is not loaded\n"); return 1; }

    int sfd = open("/dev/shm/orphan_fx", O_RDWR | O_CREAT, 0644);
    if (sfd < 0 || ftruncate(sfd, sizeof(struct fxctl)) < 0) { perror("/dev/shm/orphan_fx"); return 1; }
    struct fxctl *c = mmap(NULL, sizeof *c, PROT_READ | PROT_WRITE, MAP_SHARED, sfd, 0);
    if (c == MAP_FAILED) { perror("mmap shm"); return 1; }
    if (c->magic != 0x3158464Fu) { memset(c, 0, sizeof *c); c->magic = 0x3158464Fu; c->delay = 24414; c->decay = 1.0f; }

    dl = calloc(DSIZE, 2); loopb = calloc((size_t)LMAX, 2); undob = calloc((size_t)LMAX, 2);
    if (!dl || !loopb || !undob) { fprintf(stderr, "orphan-fxd: out of memory\n"); return 1; }
    mlockall(MCL_CURRENT | MCL_FUTURE);
    struct sched_param sp = { .sched_priority = 40 };
    sched_setscheduler(0, SCHED_FIFO, &sp);
    signal(SIGINT, on_sig); signal(SIGTERM, on_sig);

    R[R_FLUSH] = 1;
    cap_to = R[R_T];
    uint32_t seen_seq = c->cmd_seq, under0 = R[R_UNDER];
    struct timespec next; clock_gettime(CLOCK_MONOTONIC, &next);
    fprintf(stderr, "orphan-fxd: running (delay buffer %.1f s, loop up to %d s)\n", DSIZE / FS, (int)(LMAX / FS));

    while (!stop_now && !c->quit) {
        if (c->cmd_seq != seen_seq) { seen_seq = c->cmd_seq; command(c, c->cmd); }

        // 1) captured samples -> delay line and looper
        uint32_t n = R[R_CAP2_N];
        if (n & 0x80000000u) { R[R_FLUSH] = 1; c->overflows++; c->resyncs++; cap_to = R[R_T]; goto writes; }
        n &= 0x1FFF;
        if (n > 512) n = 512;
        if (n) {
            uint32_t t0 = R[R_CAP2_T];
            if (t0 != cap_to) c->resyncs++;            /* dropped samples: carry on from the FPGA's time */
            int half = c->half, rev = c->reverse;
            float decay = c->decay;
            for (uint32_t i = 0; i < n; i++) {
                uint32_t w = R[WIN + (i & 511)], t = t0 + i;
                int16_t din = (int16_t)(w >> 16), rec = (int16_t)(w & 0xFFFF);
                dl[t & DMASK] = din;
                if (state == S_REC) {
                    int32_t k = (int32_t)(t - rec_t0);
                    if (k >= 0 && k < LMAX) loopb[k] = rec;
                    else if (k >= LMAX) { L = LMAX; loop_t0 = rec_t0; state = S_PLAY; }
                } else if (state == S_DUB && L > 0 && (int32_t)(t - loop_t0) >= 0) {
                    int32_t p = loop_pos(t, half, rev);
                    loopb[p] = sat16((int32_t)lrintf(loopb[p] * decay) + rec);
                }
            }
            cap_to = t0 + n;
        }
    writes:
        // 2) returns for the coming ~14 ms: delay line read + loop playback
        {
            uint32_t lvl = R[R_PLAY_N] & 0x1FFF;
            if (lvl < FILL) {
                // the next written return plays right after the ones already queued: now + 1 + queue length
                // (from T, which is always right; PLAY_T keeps a stale offset if the queue never ran dry)
                uint32_t pt = R[R_T] + 1 + lvl, m = FILL - lvl;
                if (m > 512) m = 512;
                int32_t D = c->delay < DMIN ? DMIN : c->delay > (int32_t)DSIZE - 8192 ? (int32_t)DSIZE - 8192 : c->delay;
                float wd = c->wob_depth, wr = c->wob_rate;
                int half = c->half, rev = c->reverse;
                for (uint32_t j = 0; j < m; j++) {
                    uint32_t t = pt + j;
                    double back = D;
                    if (wd > 0) back += wd * 0.5 * (1.0 + sin(2 * M_PI * wr * (double)t / FS));
                    double src = (double)t - back;
                    int32_t d16 = 0;
                    uint32_t s0 = (uint32_t)floor(src);
                    if ((int32_t)(cap_to - s0) >= 2 && (int32_t)(cap_to - s0) < (int32_t)DSIZE - 4) {
                        double f = src - floor(src);
                        d16 = (int32_t)lrint(dl[s0 & DMASK] * (1 - f) + dl[(s0 + 1) & DMASK] * f);
                    }
                    int32_t l16 = 0;
                    if ((state == S_PLAY || state == S_DUB) && L > 0 && (int32_t)(t - loop_t0) >= 0)
                        l16 = loopb[loop_pos(t, half, rev)];
                    R[WIN + (j & 511)] = ((uint32_t)(uint16_t)d16 << 16) | (uint16_t)l16;
                }
            }
        }
        // 3) status
        c->state = state; c->len = L;
        c->pos = (state == S_PLAY || state == S_DUB) && L > 0 ? loop_pos(cap_to, c->half, c->reverse)
               : state == S_REC ? (int32_t)(cap_to - rec_t0) : 0;
        c->underruns = R[R_UNDER] - under0;
        c->alive++;

        next.tv_nsec += 2000000L;                          /* every 2 ms */
        if (next.tv_nsec >= 1000000000L) { next.tv_nsec -= 1000000000L; next.tv_sec++; }
        clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &next, NULL);
    }
    fprintf(stderr, "orphan-fxd: stopped\n");
    return 0;
}
