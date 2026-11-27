// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Rev. J. Money
// Fast paths for the ORPHAN Remote (CYD) game stream, compiled on the board by cydlink.py (gcc -O2 -shared) and
// called through ctypes. Python/numpy stays the fallback. by JMSCNC, makers of RotatoCAM.
#include <stdint.h>

// 5 pixels of 6 bits per frame buffer word (pixel 0 in [5:0]) -> one byte per pixel
void unpack6(const uint32_t* w, int nw, uint8_t* out) {
    for (int i = 0; i < nw; i++) {
        uint32_t v = w[i];
        out[0] = v & 63; out[1] = (v >> 6) & 63; out[2] = (v >> 12) & 63; out[3] = (v >> 18) & 63; out[4] = (v >> 24) & 63;
        out += 5;
    }
}

// Rows of palette indices -> per row: u8 encoding (0 raw, 1 runs), u16 length, data; runs = (u8 count-1, value)
// pairs that never cross a row (w <= 256). Runs are used when they are shorter than the raw row. off[r] = start
// of row r in out, off[n] = total. out needs n * (3 + 2 * w) bytes.
int enc8(const uint8_t* img, int n, int w, uint8_t* out, int32_t* off) {
    int pos = 0;
    for (int r = 0; r < n; r++) {
        const uint8_t* row = img + r * w;
        uint8_t* d = out + pos + 3;
        int k = 0, x = 0;
        while (x < w) {
            uint8_t v = row[x];
            int c = 1;
            while (x + c < w && row[x + c] == v) c++;
            d[2 * k] = (uint8_t)(c - 1); d[2 * k + 1] = v;
            k++; x += c;
        }
        int len;
        if (2 * k < w) { out[pos] = 1; len = 2 * k; }
        else { out[pos] = 0; len = w; for (int i = 0; i < w; i++) d[i] = row[i]; }
        out[pos + 1] = len & 255; out[pos + 2] = len >> 8;
        off[r] = pos;
        pos += 3 + len;
    }
    off[n] = pos;
    return pos;
}
