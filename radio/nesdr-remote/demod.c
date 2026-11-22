/* SPDX-License-Identifier: GPL-3.0-or-later */
#include <math.h>
#include <stdint.h>
#include <stdlib.h>

enum { FM, NFM, AM, USB, LSB, CW, SAM };
enum { DECIMATE = 5, TAPS = 63, MID = TAPS / 2 };
static const float pi = 3.14159265358979323846f;

struct receiver {
    float i1, q1, i2, q2, prev_i, prev_q, dc, out1, out2, cw_phase;
    float sam_phase, sam_frequency;
    float i_history[TAPS], q_history[TAPS], hilbert[TAPS];
    unsigned pos;
    float narrow_i[4], narrow_q[4];
    unsigned narrow_phase;
};

void *receiver_new(void) {
    struct receiver *receiver = calloc(1, sizeof(*receiver));
    if (!receiver) return NULL;
    for (int tap = 0; tap < TAPS; ++tap) {
        int k = tap - MID;
        if (k % 2 != 0)
            receiver->hilbert[tap] = 2.0f / (pi * k) * (0.54f - 0.46f * cosf(2 * pi * tap / (TAPS - 1)));
    }
    return receiver;
}

void receiver_free(void *state) { free(state); }

static float follow(float state, float input, float alpha) {
    return state + alpha * (input - state);
}

/* Match the FPGA decoder's 100 MHz / 8192 sample clock from 250 kS/s. */
int decoder_iq(void *state, const uint8_t *iq, int samples, int16_t *output) {
    struct receiver *r = state;
    int written = 0;
    for (int n = 0; n < samples; ++n) {
        float i = iq[2*n] - 127.5f, q = iq[2*n+1] - 127.5f;
        for (int k = 0; k < 4; ++k) {
            i = r->narrow_i[k] = follow(r->narrow_i[k], i, 0.18f);
            q = r->narrow_q[k] = follow(r->narrow_q[k], q, 0.18f);
        }
        r->narrow_phase += 25;
        if (r->narrow_phase < 512) continue;
        r->narrow_phase -= 512;
        output[2*written] = (int16_t)(180 * i);
        output[2*written+1] = (int16_t)(180 * q);
        ++written;
    }
    return written;
}

void receiver_audio(void *state, const uint8_t *iq, int samples, int mode, int16_t *pcm) {
    struct receiver *r = state;
    const float iq_alpha = mode == FM ? 1.0f : mode == NFM ? 0.24f : mode == CW ? 0.028f : 0.12f;
    const float audio_alpha = mode == FM ? 0.247f : 0.29f;
    float fm_sum = 0;
    for (int n = 0; n < samples; ++n) {
        r->i1 = follow(r->i1, iq[2*n] - 127.5f, iq_alpha);
        r->q1 = follow(r->q1, iq[2*n+1] - 127.5f, iq_alpha);
        r->i2 = follow(r->i2, r->i1, iq_alpha);
        r->q2 = follow(r->q2, r->q1, iq_alpha);
        if (mode == FM || mode == NFM) {
            float cross = r->prev_i*r->q2 - r->prev_q*r->i2;
            float dot = r->prev_i*r->i2 + r->prev_q*r->q2;
            fm_sum += atan2f(cross, dot);
            r->prev_i = r->i2;
            r->prev_q = r->q2;
        }
        if ((n + 1) % DECIMATE) continue;
        float audio;
        if (mode == FM || mode == NFM) {
            audio = fm_sum * (mode == FM ? 2200.0f : 22000.0f);
            fm_sum = 0;
        } else if (mode == AM) {
            audio = hypotf(r->i2, r->q2) * 600.0f;
        } else if (mode == SAM) {
            float co = cosf(r->sam_phase), si = sinf(r->sam_phase);
            float real = r->i2*co + r->q2*si;
            float imag = r->q2*co - r->i2*si;
            float error = atan2f(imag, real);
            r->sam_frequency = fminf(0.1f, fmaxf(-0.1f, r->sam_frequency + 0.00015f*error));
            r->sam_phase += r->sam_frequency + 0.035f*error;
            if (r->sam_phase > pi) r->sam_phase -= 2*pi;
            if (r->sam_phase < -pi) r->sam_phase += 2*pi;
            audio = real * 600.0f;
        } else if (mode == CW) {
            audio = (r->i2*cosf(r->cw_phase) - r->q2*sinf(r->cw_phase)) * 850.0f;
            r->cw_phase += 2*pi*700/50000;
            if (r->cw_phase >= 2*pi) r->cw_phase -= 2*pi;
        } else {
            r->i_history[r->pos] = r->i2;
            r->q_history[r->pos] = r->q2;
            float quadrature = 0;
            for (int tap = 0; tap < TAPS; tap += 2)
                quadrature += r->hilbert[tap] * r->q_history[(r->pos + TAPS - tap) % TAPS];
            audio = (r->i_history[(r->pos + TAPS - MID) % TAPS] +
                     (mode == USB ? -quadrature : quadrature)) * 700.0f;
            r->pos = (r->pos + 1) % TAPS;
        }
        r->dc = follow(r->dc, audio, 0.003f);
        r->out1 = follow(r->out1, audio-r->dc, audio_alpha);
        r->out2 = follow(r->out2, r->out1, mode == FM ? 0.68f : audio_alpha);
        pcm[n/DECIMATE] = (int16_t)fminf(32767, fmaxf(-32768, r->out2));
    }
}
