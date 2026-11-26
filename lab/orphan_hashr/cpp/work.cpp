// [orphan] H4SHR-CH3KR: the work model. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "work.hpp"
#include "sha256.hpp"
#include <cstring>

#include <cstdio>

namespace {
uint32_t be32(const uint8_t* p) { return uint32_t(p[0]) << 24 | uint32_t(p[1]) << 16 | uint32_t(p[2]) << 8 | p[3]; }
std::vector<uint8_t> hex(const char* s) {
    std::vector<uint8_t> v;
    unsigned x;
    while (*s && std::sscanf(s, "%2x", &x) == 1) { v.push_back(uint8_t(x)); s += 2; }
    return v;
}
const char* GENESIS_TX =
    "01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff4d04ffff001d0104455468652054"
    "696d65732030332f4a616e2f32303039204368616e63656c6c6f72206f6e206272696e6b206f66207365636f6e64206261696c6f75742066"
    "6f722062616e6b73ffffffff0100f2052a01000000434104678afdb0fe5548271967f1a67130b7105cd6a828e03909a67962e0ea1f61deb6"
    "49f6bc3f4cef38c4f35504e51ec112de5c384df7ba0b8d578a4c702b6bf11d5fac00000000";
}

Job genesis_job() {
    Job j{};
    j.tag = 0x0001;
    std::memcpy(j.version, hex("01000000").data(), 4);
    std::memset(j.prevhash, 0, 32);
    std::memcpy(j.ntime, hex("29ab5f49").data(), 4);
    std::memcpy(j.nbits, hex("ffff001d").data(), 4);
    j.coinbase = hex(GENESIS_TX);
    j.en2_off = 43;                                // the ffff001d push in the coinbase script
    j.en2_size = 4;
    j.en2_start = 0xffff001d;
    return j;
}

bool en2_ok(const Job& j, uint64_t en2) {
    if (en2 >> 48) return false;
    return j.en2_size >= 6 || (en2 >> (8 * j.en2_size)) == 0;
}

std::array<uint8_t, 32> merkle_root(std::array<uint8_t, 32> h, const std::vector<std::array<uint8_t, 32>>& br) {
    uint8_t buf[64];
    for (auto& b : br) {
        std::memcpy(buf, h.data(), 32);
        std::memcpy(buf + 32, b.data(), 32);
        h = sha::sha256d(buf, 64);
    }
    return h;
}

Work build_work(const Job& j, uint64_t en2) {
    Work w{};
    std::vector<uint8_t> cb = j.coinbase;
    for (int k = 0; k < j.en2_size; k++) cb[j.en2_off + k] = uint8_t(en2 >> (8 * (j.en2_size - 1 - k)));
    auto root = merkle_root(sha::sha256d(cb.data(), cb.size()), j.branches);
    std::memcpy(w.header, j.version, 4);
    std::memcpy(w.header + 4, j.prevhash, 32);
    std::memcpy(w.header + 36, root.data(), 32);
    std::memcpy(w.header + 68, j.ntime, 4);
    std::memcpy(w.header + 72, j.nbits, 4);
    std::memcpy(w.midstate, sha::IV, sizeof w.midstate);
    sha::compress(w.midstate, w.header);
    w.tail[0] = be32(w.header + 72);
    w.tail[1] = be32(w.header + 68);
    w.tail[2] = be32(w.header + 64);
    w.tag = uint32_t(j.tag) << 16 | uint32_t(en2 >> 32 & 0xFFFF);
    w.tag2 = uint32_t(en2);
    return w;
}

std::array<uint8_t, 32> header_hash(const uint8_t header[80], uint32_t nonce) {
    uint8_t h[80];
    std::memcpy(h, header, 76);
    for (int k = 0; k < 4; k++) h[76 + k] = uint8_t(nonce >> (24 - 8 * k));
    return sha::sha256d(h, 80);
}

bool meets_diff1(const std::array<uint8_t, 32>& hash) { return !hash[28] && !hash[29] && !hash[30] && !hash[31]; }

std::vector<uint32_t> bank_image(const Job& j) {
    std::vector<uint32_t> m(512, 0);
    m[0] = j.tag;
    m[1] = be32(j.version);
    m[2] = be32(j.ntime);
    m[3] = be32(j.nbits);
    for (int i = 0; i < 8; i++) m[4 + i] = be32(j.prevhash + 4 * i);
    m[12] = uint32_t(j.coinbase.size());
    m[13] = uint32_t(j.en2_off);
    m[14] = uint32_t(j.en2_size);
    m[15] = uint32_t(j.branches.size());
    m[16] = uint32_t(j.en2_start >> 32 & 0xFFFF);
    m[17] = uint32_t(j.en2_start);
    for (size_t b = 0; b < j.branches.size() && b < 16; b++)
        for (int i = 0; i < 8; i++) m[64 + 8 * b + i] = be32(j.branches[b].data() + 4 * i);
    for (size_t i = 0; i < j.coinbase.size() && i < 1024; i++)
        m[256 + i / 4] |= uint32_t(j.coinbase[i]) << (24 - 8 * (i % 4));
    return m;
}
