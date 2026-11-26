// [orphan] H4SHR-CH3KR hashrd: stratum v1 messages (see stratum.hpp). by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "stratum.hpp"
#include <cmath>
#include <cstdlib>
#include <cstdio>
#include <cstring>

bool hex_bytes(const std::string& s, std::vector<uint8_t>& out) {
    if (s.size() % 2) return false;
    out.clear();
    out.reserve(s.size() / 2);
    for (size_t i = 0; i < s.size(); i += 2) {
        int v = 0;
        for (int k = 0; k < 2; k++) {
            char c = s[i + k];
            v <<= 4;
            if (c >= '0' && c <= '9') v |= c - '0';
            else if (c >= 'a' && c <= 'f') v |= c - 'a' + 10;
            else if (c >= 'A' && c <= 'F') v |= c - 'A' + 10;
            else return false;
        }
        out.push_back(uint8_t(v));
    }
    return true;
}

bool notify_from(const json::Value& p, Notify& n) {
    if (!p.is_array() || p.size() < 9) return false;
    for (int k : {0, 1, 2, 3, 5, 6, 7}) if (!p[k].is_string()) return false;
    if (!p[4].is_array()) return false;
    n.id = p[0].str();
    n.prevhash = p[1].str();
    n.coinb1 = p[2].str();
    n.coinb2 = p[3].str();
    n.merkle.clear();
    for (auto& b : p[4].items()) {
        if (!b.is_string()) return false;
        n.merkle.push_back(b.str());
    }
    n.version = p[5].str();
    n.nbits = p[6].str();
    n.ntime = p[7].str();
    n.clean = p[8].boolean();
    return true;
}

static bool field4(const std::string& hex, uint8_t out[4]) {   // a 4-byte stratum field, reversed into header order
    std::vector<uint8_t> b;
    if (!hex_bytes(hex, b) || b.size() != 4) return false;
    for (int i = 0; i < 4; i++) out[i] = b[3 - i];
    return true;
}

bool job_from(const Notify& n, const std::string& en1_hex, int en2_size, uint16_t tag, Job& j, std::string& why) {
    std::vector<uint8_t> cb1, en1, cb2, prev;
    if (en2_size < 1 || en2_size > 8) { why = "extranonce2 size " + std::to_string(en2_size) + " (the FPGA takes 1 to 8 bytes)"; return false; }
    if (!hex_bytes(n.coinb1, cb1) || !hex_bytes(en1_hex, en1) || !hex_bytes(n.coinb2, cb2)) { why = "coinbase is not hex"; return false; }
    size_t len = cb1.size() + en1.size() + size_t(en2_size) + cb2.size();
    if (len > size_t(MAX_COINBASE)) { why = "coinbase " + std::to_string(len) + " bytes (the FPGA holds 1024)"; return false; }
    if (n.merkle.size() > size_t(MAX_BRANCHES)) { why = std::to_string(n.merkle.size()) + " merkle branches (the FPGA folds 16)"; return false; }
    if (!hex_bytes(n.prevhash, prev) || prev.size() != 32) { why = "prevhash is not 32 bytes of hex"; return false; }
    Job k{};
    if (!field4(n.version, k.version) || !field4(n.ntime, k.ntime) || !field4(n.nbits, k.nbits)) { why = "version, ntime or nbits is not 4 bytes of hex"; return false; }
    for (int w = 0; w < 8; w++)
        for (int b = 0; b < 4; b++) k.prevhash[4 * w + b] = prev[4 * w + 3 - b];
    k.coinbase = cb1;
    k.coinbase.insert(k.coinbase.end(), en1.begin(), en1.end());
    k.en2_off = int(k.coinbase.size());
    k.coinbase.resize(k.coinbase.size() + size_t(en2_size), 0);
    k.coinbase.insert(k.coinbase.end(), cb2.begin(), cb2.end());
    k.en2_size = en2_size;
    for (auto& h : n.merkle) {
        std::vector<uint8_t> b;
        if (!hex_bytes(h, b) || b.size() != 32) { why = "a merkle branch is not 32 bytes of hex"; return false; }
        std::array<uint8_t, 32> a;
        std::memcpy(a.data(), b.data(), 32);
        k.branches.push_back(a);
    }
    k.tag = tag;
    k.en2_start = 0;
    j = std::move(k);
    return true;
}

std::array<uint8_t, 32> target_for(double diff) {
    std::array<uint8_t, 32> t{};
    if (!(diff > 0)) { t.fill(0xFF); return t; }
    long double x = (65535.0L / (long double)diff) * std::ldexp((long double)1, 208);
    if (x >= std::ldexp((long double)1, 256)) { t.fill(0xFF); return t; }
    for (int k = 31; k >= 0; k--) {
        long double p = std::ldexp((long double)1, 8 * k);
        long double b = std::floor(x / p);
        if (b > 255) b = 255;
        if (b < 0) b = 0;
        t[size_t(k)] = uint8_t(b);
        x -= b * p;
    }
    return t;
}

bool share_ok(const std::array<uint8_t, 32>& hash, const std::array<uint8_t, 32>& target) {
    for (int k = 31; k >= 0; k--) {
        if (hash[size_t(k)] < target[size_t(k)]) return true;
        if (hash[size_t(k)] > target[size_t(k)]) return false;
    }
    return true;
}

std::string submit_nonce_hex(uint32_t n) {
    char b[9];
    uint32_t v = n >> 24 | (n >> 8 & 0xFF00) | (n << 8 & 0xFF0000) | n << 24;
    std::snprintf(b, sizeof b, "%08x", v);
    return b;
}

std::string en2_hex(uint64_t en2, int size) {
    std::string o;
    char b[3];
    for (int k = 0; k < size; k++) {
        std::snprintf(b, sizeof b, "%02x", unsigned(en2 >> (8 * (size - 1 - k)) & 0xFF));
        o += b;
    }
    return o;
}

double share_difficulty(const std::array<uint8_t, 32>& hash) {
    long double v = 0;
    for (int k = 31; k >= 0; k--) v = v * 256 + hash[size_t(k)];
    if (v <= 0) return 0;
    return double((65535.0L * std::ldexp((long double)1, 208)) / v);
}

double nbits_difficulty(const std::string& nbits_hex) {
    unsigned long n = std::strtoul(nbits_hex.c_str(), nullptr, 16);
    long double target = (long double)(n & 0xFFFFFF) * std::ldexp((long double)1, int(8 * ((n >> 24) - 3)));
    if (target <= 0) return 0;
    return double((65535.0L * std::ldexp((long double)1, 208)) / target);
}

long coinbase_height(const std::string& coinb1_hex) {
    std::vector<uint8_t> b;
    if (!hex_bytes(coinb1_hex, b) || b.size() < 44) return -1;
    size_t p = 41;                                 // version 4, input count 1, previous output 36
    if (b[p] >= 0xFD) return -1;                   // a one-byte script length is all a coinbase uses
    p++;
    int n = b[p++];                                // BIP34: the script starts with a push of the height
    if (n < 1 || n > 8 || p + size_t(n) > b.size()) return -1;
    long h = 0;
    for (int k = n - 1; k >= 0; k--) h = h * 256 + b[p + size_t(k)];
    return h;
}
