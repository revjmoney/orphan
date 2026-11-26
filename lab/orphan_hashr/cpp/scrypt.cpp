// [orphan] H4SHR-CH3KR: scrypt (RFC 7914): HMAC-SHA256, PBKDF2, Salsa20/8, BlockMix, ROMix. Standard library only.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "scrypt.hpp"
#include "sha256.hpp"
#include <cstring>
#include <vector>

namespace scrypt {
namespace {

struct Sha {                                       // streaming SHA-256 on sha::compress
    uint32_t h[8];
    uint8_t buf[64];
    size_t n = 0;
    uint64_t total = 0;
    Sha() { std::memcpy(h, sha::IV, sizeof h); }
    void add(const uint8_t* d, size_t len) {
        total += len;
        while (len) {
            size_t k = 64 - n < len ? 64 - n : len;
            std::memcpy(buf + n, d, k);
            n += k; d += k; len -= k;
            if (n == 64) { sha::compress(h, buf); n = 0; }
        }
    }
    void done(uint8_t out[32]) {
        uint64_t bits = total * 8;
        uint8_t pad = 0x80, z = 0;
        add(&pad, 1);
        while (n != 56) add(&z, 1);
        uint8_t l[8];
        for (int i = 0; i < 8; i++) l[i] = uint8_t(bits >> (56 - 8 * i));
        add(l, 8);
        for (int i = 0; i < 8; i++) {
            out[4 * i] = uint8_t(h[i] >> 24); out[4 * i + 1] = uint8_t(h[i] >> 16);
            out[4 * i + 2] = uint8_t(h[i] >> 8); out[4 * i + 3] = uint8_t(h[i]);
        }
    }
};

struct Hmac {                                      // HMAC-SHA256 with the key's pads hashed once
    Sha in, out;
    Hmac(const uint8_t* key, size_t klen) {
        uint8_t k[64] = {}, kh[32];
        if (klen > 64) { Sha s; s.add(key, klen); s.done(kh); key = kh; klen = 32; }
        if (klen) std::memcpy(k, key, klen);
        uint8_t ip[64], op[64];
        for (int i = 0; i < 64; i++) { ip[i] = k[i] ^ 0x36; op[i] = k[i] ^ 0x5c; }
        in.add(ip, 64);
        out.add(op, 64);
    }
};

inline uint32_t rotl(uint32_t x, int c) { return (x << c) | (x >> (32 - c)); }

void salsa20_8(uint32_t b[16]) {
    uint32_t x[16];
    std::memcpy(x, b, sizeof x);
    for (int i = 0; i < 8; i += 2) {
        x[4] ^= rotl(x[0] + x[12], 7);   x[8] ^= rotl(x[4] + x[0], 9);
        x[12] ^= rotl(x[8] + x[4], 13);  x[0] ^= rotl(x[12] + x[8], 18);
        x[9] ^= rotl(x[5] + x[1], 7);    x[13] ^= rotl(x[9] + x[5], 9);
        x[1] ^= rotl(x[13] + x[9], 13);  x[5] ^= rotl(x[1] + x[13], 18);
        x[14] ^= rotl(x[10] + x[6], 7);  x[2] ^= rotl(x[14] + x[10], 9);
        x[6] ^= rotl(x[2] + x[14], 13);  x[10] ^= rotl(x[6] + x[2], 18);
        x[3] ^= rotl(x[15] + x[11], 7);  x[7] ^= rotl(x[3] + x[15], 9);
        x[11] ^= rotl(x[7] + x[3], 13);  x[15] ^= rotl(x[11] + x[7], 18);
        x[1] ^= rotl(x[0] + x[3], 7);    x[2] ^= rotl(x[1] + x[0], 9);
        x[3] ^= rotl(x[2] + x[1], 13);   x[0] ^= rotl(x[3] + x[2], 18);
        x[6] ^= rotl(x[5] + x[4], 7);    x[7] ^= rotl(x[6] + x[5], 9);
        x[4] ^= rotl(x[7] + x[6], 13);   x[5] ^= rotl(x[4] + x[7], 18);
        x[11] ^= rotl(x[10] + x[9], 7);  x[8] ^= rotl(x[11] + x[10], 9);
        x[9] ^= rotl(x[8] + x[11], 13);  x[10] ^= rotl(x[9] + x[8], 18);
        x[12] ^= rotl(x[15] + x[14], 7); x[13] ^= rotl(x[12] + x[15], 9);
        x[14] ^= rotl(x[13] + x[12], 13); x[15] ^= rotl(x[14] + x[13], 18);
    }
    for (int i = 0; i < 16; i++) b[i] += x[i];
}

void blockmix(const uint32_t* in, uint32_t* out, uint32_t r) {   // 2r 64-byte blocks
    uint32_t x[16];
    std::memcpy(x, in + (2 * r - 1) * 16, 64);
    for (uint32_t i = 0; i < 2 * r; i++) {
        for (int k = 0; k < 16; k++) x[k] ^= in[i * 16 + k];
        salsa20_8(x);
        uint32_t dst = (i & 1) ? (r + i / 2) : (i / 2);  // even blocks first, then odd
        std::memcpy(out + dst * 16, x, 64);
    }
}

void romix(uint8_t* b, uint32_t N, uint32_t r) {
    size_t words = 32 * size_t(r);
    std::vector<uint32_t> x(words), y(words), v(words * N);
    for (size_t i = 0; i < words; i++)
        x[i] = uint32_t(b[4 * i]) | uint32_t(b[4 * i + 1]) << 8 | uint32_t(b[4 * i + 2]) << 16 | uint32_t(b[4 * i + 3]) << 24;
    for (uint32_t i = 0; i < N; i++) {
        std::memcpy(&v[i * words], x.data(), words * 4);
        blockmix(x.data(), y.data(), r);
        x.swap(y);
    }
    for (uint32_t i = 0; i < N; i++) {
        uint32_t j = x[words - 16] & (N - 1);        // Integerify: first word of the last block
        for (size_t k = 0; k < words; k++) x[k] ^= v[j * words + k];
        blockmix(x.data(), y.data(), r);
        x.swap(y);
    }
    for (size_t i = 0; i < words; i++) {
        b[4 * i] = uint8_t(x[i]); b[4 * i + 1] = uint8_t(x[i] >> 8);
        b[4 * i + 2] = uint8_t(x[i] >> 16); b[4 * i + 3] = uint8_t(x[i] >> 24);
    }
}

}  // namespace

void pbkdf2_sha256(const uint8_t* pw, size_t pwlen, const uint8_t* salt, size_t saltlen, uint32_t c,
                   uint8_t* dk, size_t dklen) {
    Hmac key(pw, pwlen);
    for (uint32_t blk = 1; dklen; blk++) {
        uint8_t be[4] = {uint8_t(blk >> 24), uint8_t(blk >> 16), uint8_t(blk >> 8), uint8_t(blk)};
        uint8_t u[32], t[32], ih[32];
        Sha a = key.in;
        if (saltlen) a.add(salt, saltlen);
        a.add(be, 4);
        a.done(ih);
        Sha o = key.out; o.add(ih, 32); o.done(u);
        std::memcpy(t, u, 32);
        for (uint32_t i = 1; i < c; i++) {
            Sha a2 = key.in; a2.add(u, 32); a2.done(ih);
            Sha o2 = key.out; o2.add(ih, 32); o2.done(u);
            for (int k = 0; k < 32; k++) t[k] ^= u[k];
        }
        size_t k = dklen < 32 ? dklen : 32;
        std::memcpy(dk, t, k);
        dk += k; dklen -= k;
    }
}

void scrypt(const uint8_t* pw, size_t pwlen, const uint8_t* salt, size_t saltlen, uint32_t N, uint32_t r,
            uint32_t p, uint8_t* dk, size_t dklen) {
    size_t blen = 128 * size_t(r);
    std::vector<uint8_t> b(blen * p);
    pbkdf2_sha256(pw, pwlen, salt, saltlen, 1, b.data(), b.size());
    for (uint32_t i = 0; i < p; i++) romix(&b[i * blen], N, r);
    pbkdf2_sha256(pw, pwlen, b.data(), b.size(), 1, dk, dklen);
}

void pow_1024_1_1(const uint8_t header[80], uint8_t out[32]) { scrypt(header, 80, header, 80, 1024, 1, 1, out, 32); }

}  // namespace scrypt
