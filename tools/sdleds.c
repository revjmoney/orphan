// sdleds.c: SD card activity lights on the S9 control board's bicolor LED D3.
//   green (MIO38) = reads, red (MIO37) = writes. Both active high (driven through transistors Q2/Q3).
// The kernel's disk-read/disk-write LED triggers only exist for ATA disks, and the mmc trigger has no
// read/write split, so this polls the card's own counters in /sys/block/<dev>/stat.
//
// Build: gcc -O2 -Wall -o sdleds sdleds.c      Run: ./sdleds [mmcblk0]
// SIGTERM / Ctrl+C turns both LEDs off.
#include <fcntl.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <time.h>
#include <unistd.h>

#define GPIO_BASE 0xE000A000u
#define POLL_MS 15        /* how often the counters are read */
#define HOLD_MS 45        /* how long a flash stays lit after activity */
#define MIO_RED 37
#define MIO_GREEN 38

static volatile uint32_t *gpio;
static volatile sig_atomic_t stop;
static void on_sig(int s) { (void)s; stop = 1; }

/* bank 1 = MIO 32..53: MASK_DATA_1_LSW at 0x08 (MIO 32..47), DIRM_1 0x244, OEN_1 0x248 */
static void led(int mio, int on) {
    unsigned bit = mio - 32;
    gpio[0x08 / 4] = (~(1u << bit) & 0xFFFFu) << 16 | (on ? 1u << bit : 0);
}

static int read_stat(const char *path, unsigned long long *rd, unsigned long long *wr) {
    FILE *f = fopen(path, "r");
    if (!f) return -1;
    unsigned long long v[11] = {0};
    int n = fscanf(f, "%llu %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu",
                   &v[0], &v[1], &v[2], &v[3], &v[4], &v[5], &v[6], &v[7], &v[8], &v[9], &v[10]);
    fclose(f);
    if (n < 7) return -1;
    *rd = v[2];   /* sectors read */
    *wr = v[6];   /* sectors written */
    return 0;
}

int main(int argc, char **argv) {
    const char *dev = argc > 1 ? argv[1] : "mmcblk0";
    char path[128];
    snprintf(path, sizeof path, "/sys/block/%s/stat", dev);

    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) { perror("/dev/mem"); return 1; }
    void *p = mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, GPIO_BASE);
    if (p == MAP_FAILED) { perror("mmap"); return 1; }
    gpio = (volatile uint32_t *)p;

    /* make sure both pins are driven outputs (Ardzy's board init normally does this already) */
    unsigned m = (1u << (MIO_RED - 32)) | (1u << (MIO_GREEN - 32));
    gpio[0x244 / 4] |= m;
    gpio[0x248 / 4] |= m;

    signal(SIGINT, on_sig);
    signal(SIGTERM, on_sig);

    unsigned long long rd0, wr0, rd, wr;
    if (read_stat(path, &rd0, &wr0)) { fprintf(stderr, "cannot read %s\n", path); return 1; }
    int red_left = 0, green_left = 0;
    led(MIO_RED, 0);
    led(MIO_GREEN, 0);
    struct timespec ts = {0, POLL_MS * 1000000L};

    while (!stop) {
        nanosleep(&ts, NULL);
        if (read_stat(path, &rd, &wr)) continue;
        if (rd != rd0) green_left = HOLD_MS;
        if (wr != wr0) red_left = HOLD_MS;
        rd0 = rd; wr0 = wr;
        led(MIO_GREEN, green_left > 0);
        led(MIO_RED, red_left > 0);
        if (green_left > 0) green_left -= POLL_MS;
        if (red_left > 0) red_left -= POLL_MS;
    }
    led(MIO_RED, 0);
    led(MIO_GREEN, 0);
    return 0;
}
