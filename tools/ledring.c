// ledring.c: fade-in / fade-out "ring" across every software-controllable LED on the Antminer S9
// control board running Ardzy. Works with either FPGA design:
//   - Ardzy pin-control v2 (ARZ2): its PWM channels 0..3 (routed by ledring-setup.sh)
//   - any Orphan design (ardzy_bus "ARDZ" + orphan_leds "LED1" at slot 14): manual levels, gamma in hardware
//
//  D5..D8  FPGA pins leds[0..3] (F16, L19, M19, M17), ACTIVE LOW, hardware PWM channels 0..3
//          (route first: POST /api/io/pwm/set?ch=N&hz=1000&duty=100&pin=leds[N]).
//  D2      MIO15, active LOW         \  software PWM through the Zynq PS GPIO block
//  D3      MIO38 green, MIO37 red     /  (pins must already be outputs: `ardzy led ... off` does that)
//
// D15 (power good) and D1 (FPGA DONE) are hardwired and can't be controlled.
//
// Build on the board:  gcc -O2 -o ledring ledring.c -lm
// Run:                 ./ledring [period_seconds]     (Ctrl+C or SIGTERM turns everything off)
#include <fcntl.h>
#include <math.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

#define CTL_BASE  0x43C00000u   /* ardzy_ctl registers */
#define GPIO_BASE 0xE000A000u   /* Zynq PS GPIO */
#define NLED 7
#define LEVELS 100              /* soft-PWM steps per frame */
#define TICK_NS 50000L          /* 50 us tick -> 5 ms frame -> 200 Hz soft PWM */

static volatile uint32_t *ctl, *gpio, *oled;     /* oled = orphan_leds block (slot 14), or NULL */
static uint32_t oled_src_saved;
static volatile sig_atomic_t stop;
static void on_sig(int s) { (void)s; stop = 1; }

static volatile uint32_t *map(int fd, uint32_t base) {
    void *p = mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, base);
    if (p == MAP_FAILED) { perror("mmap"); exit(1); }
    return (volatile uint32_t *)p;
}

/* MASK_DATA_0_LSW (bank 0, MIO 0..15) at 0x00, MASK_DATA_1_LSW (bank 1, MIO 32..47) at 0x08.
   Upper 16 bits = mask (0 = this bit is written), lower 16 = value. Only touches our pins. */
static void mio_write(int mio, int level) {
    unsigned off = mio < 16 ? 0x00 : 0x08, bit = mio < 16 ? mio : mio - 32;
    gpio[off / 4] = (~(1u << bit) & 0xFFFFu) << 16 | (unsigned)(level ? 1u << bit : 0);
}

static void fpga_pwm(int ch, uint32_t period, double bright) {   /* active low: high time = dark */
    if (oled) {                                   /* orphan_leds squares the level (gamma): send sqrt */
        oled[2 + ch] = (uint32_t)lround(sqrt(bright) * 255.0);
        return;
    }
    ctl[(0x64 + 8 * ch) / 4] = (uint32_t)lround(period * (1.0 - bright));
}

static void all_off(uint32_t per[4]) {
    for (int ch = 0; ch < 4; ch++) fpga_pwm(ch, per[ch], 0.0);
    if (oled) oled[1] = oled_src_saved;          /* give the LEDs back to the design's own light show */
    mio_write(15, 1);   /* D2 active low: 1 = off */
    mio_write(37, 0);
    mio_write(38, 0);
}

static double now_s(void) {
    struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec + t.tv_nsec / 1e9;
}

int main(int argc, char **argv) {
    double period = argc > 1 ? atof(argv[1]) : 2.8;   /* seconds for the wave to go once around */
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) { perror("/dev/mem"); return 1; }
    ctl = map(fd, CTL_BASE);
    gpio = map(fd, GPIO_BASE);
    uint32_t per[4] = {0, 0, 0, 0};
    if (ctl[0] == 0x41525A32u) {                          /* Ardzy pin-control v2 */
        for (int ch = 0; ch < 4; ch++) {
            per[ch] = ctl[(0x60 + 8 * ch) / 4];
            if (per[ch] < 2) { fprintf(stderr, "PWM ch%d has no period: route it first\n", ch); return 1; }
        }
    } else if (ctl[0] == 0x4152445Au) {                   /* "ARDZ": an ardzy_bus design, look for orphan_leds */
        oled = map(fd, CTL_BASE + 14 * 0x1000);
        if (oled[0] != 0x4C454431u) { fprintf(stderr, "this FPGA design has no orphan_leds block (slot 14)\n"); return 1; }
        oled_src_saved = oled[1];
        oled[1] = 0x0000;                                  /* all four LEDs: manual level */
    } else {
        fprintf(stderr, "no LED control in the loaded FPGA design (need pin-control or orphan_leds)\n");
        return 1;
    }
    signal(SIGINT, on_sig);
    signal(SIGTERM, on_sig);

    /* ring order: D5 D6 D7 D8 (FPGA), then D2, D3 green, D3 red */
    const int mio_pin[3] = {15, 38, 37}, mio_active_low[3] = {1, 0, 0};
    double t0 = now_s();
    struct timespec next; clock_gettime(CLOCK_MONOTONIC, &next);

    while (!stop) {
        double t = (now_s() - t0) / period, b[NLED];
        for (int i = 0; i < NLED; i++) {
            double ph = t - (double)i / NLED;
            double w = 0.5 - 0.5 * cos(2 * M_PI * (ph - floor(ph)));   /* 0..1 smooth hump */
            b[i] = pow(w, 3.0 * 2.2);                                   /* sharpen + gamma */
        }
        for (int ch = 0; ch < 4; ch++) fpga_pwm(ch, per[ch], b[ch]);

        int on_steps[3];
        for (int k = 0; k < 3; k++) on_steps[k] = (int)lround(b[4 + k] * LEVELS);
        for (int step = 0; step < LEVELS && !stop; step++) {          /* one 5 ms soft-PWM frame */
            for (int k = 0; k < 3; k++) {
                int lit = step < on_steps[k];
                mio_write(mio_pin[k], mio_active_low[k] ? !lit : lit);
            }
            next.tv_nsec += TICK_NS;
            if (next.tv_nsec >= 1000000000L) { next.tv_nsec -= 1000000000L; next.tv_sec++; }
            clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &next, NULL);
        }
    }
    all_off(per);
    return 0;
}
