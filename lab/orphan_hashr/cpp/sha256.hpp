// [orphan] H4SHR-CH3KR: SHA-256 (FIPS 180-4), standard library only. by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <array>
#include <cstddef>
#include <cstdint>

namespace sha {
extern const uint32_t IV[8];
void compress(uint32_t h[8], const uint8_t block[64]);       // one 64-byte block into h
std::array<uint8_t, 32> sha256(const uint8_t* d, size_t n);
std::array<uint8_t, 32> sha256d(const uint8_t* d, size_t n); // sha256(sha256(d))
}
