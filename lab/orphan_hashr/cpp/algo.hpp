// [orphan] H4SHR-CH3KR: what a miner re-hashes with. SHA-256d for S9 (BM1387) boards; scrypt N 1024 r 1 p 1 for
// L3+ (BM1485) boards, whose difficulty 1 is 65536 x easier (target 0x0000FFFF << 224). The chip returns the nonce
// big-endian into header bytes 76..79 for both. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <array>
#include <cstdint>

struct Algo {
    enum Kind { SHA256D, SCRYPT } kind = SHA256D;
    std::array<uint8_t, 32> hash(const uint8_t header[80], uint32_t nonce) const;
    bool diff1(const std::array<uint8_t, 32>& h) const;           // at least a difficulty-1 hash for this algorithm
    std::array<uint8_t, 32> target(double pool_diff) const;       // the pool's share target (stratum units)
    double share_diff(const std::array<uint8_t, 32>& h) const;    // the difficulty this hash would be worth
    int chip(uint32_t nonce) const;                               // which chip found it
    double hashes_per_nonce() const;   // for the hashrate: SHA 2^32 (BM1387 ticket 0); scrypt 2^16 x 256 (ticket mask
                                       // 0xFF; bench 2026-11-26: 15 shares from 2449 nonces fits only x256)
    const char* name() const { return kind == SCRYPT ? "scrypt" : "sha256d"; }
};
