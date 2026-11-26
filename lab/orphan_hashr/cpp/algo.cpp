// [orphan] H4SHR-CH3KR: SHA-256d or scrypt share checks. by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "algo.hpp"
#include "bm1485.hpp"
#include "scrypt.hpp"
#include "stratum.hpp"
#include "work.hpp"
#include <cstring>

std::array<uint8_t, 32> Algo::hash(const uint8_t header[80], uint32_t nonce) const {
    if (kind == SHA256D) return header_hash(header, nonce);
    uint8_t h[80];
    std::memcpy(h, header, 76);
    bm85::put_nonce(h, nonce);
    std::array<uint8_t, 32> out;
    scrypt::pow_1024_1_1(h, out.data());
    return out;
}

bool Algo::diff1(const std::array<uint8_t, 32>& h) const {
    return kind == SHA256D ? meets_diff1(h) : (h[31] == 0 && h[30] == 0);
}

std::array<uint8_t, 32> Algo::target(double pool_diff) const {
    return target_for(kind == SCRYPT ? pool_diff / 65536.0 : pool_diff);
}

double Algo::share_diff(const std::array<uint8_t, 32>& h) const {
    double d = share_difficulty(h);
    return kind == SCRYPT ? d * 65536.0 : d;
}

int Algo::chip(uint32_t nonce) const { return kind == SCRYPT ? bm85::chip_of_nonce(nonce) : int(nonce >> 26); }

double Algo::hashes_per_nonce() const { return kind == SCRYPT ? 65536.0 * 256.0 : 4294967296.0; }   // scrypt: ticket mask 0xFF
