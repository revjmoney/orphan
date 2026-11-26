// [orphan] H4SHR-CH3KR: scrypt (RFC 7914) on the ARM: every nonce an L3+ (BM1485) board returns is re-hashed here
// before a share goes out. Litecoin / Dogecoin proof of work = scrypt(header, header, N 1024, r 1, p 1, 32 bytes).
// Standard library only. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <cstddef>
#include <cstdint>

namespace scrypt {
void pbkdf2_sha256(const uint8_t* pw, size_t pwlen, const uint8_t* salt, size_t saltlen, uint32_t c,
                   uint8_t* dk, size_t dklen);
void scrypt(const uint8_t* pw, size_t pwlen, const uint8_t* salt, size_t saltlen, uint32_t N, uint32_t r,
            uint32_t p, uint8_t* dk, size_t dklen);
void pow_1024_1_1(const uint8_t header[80], uint8_t out[32]);   // the Litecoin / Dogecoin header hash
}
