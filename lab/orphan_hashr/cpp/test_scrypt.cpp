// [orphan] H4SHR-CH3KR: scrypt (RFC 7914) known answers, for re-checking L3+ (BM1485) nonces on the ARM.
//   g++ -O2 -std=c++17 -o test_scrypt test_scrypt.cpp scrypt.cpp sha256.cpp && ./test_scrypt
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "scrypt.hpp"
#include <cstdio>
#include <cstring>
#include <string>
#include <vector>

static int pass = 0, total = 0;
static void check(bool ok, const char* name) {
    total++;
    if (ok) pass++;
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", name);
}
static std::string hex(const uint8_t* p, size_t n) {
    std::string s;
    char b[3];
    for (size_t i = 0; i < n; i++) { std::snprintf(b, sizeof b, "%02x", p[i]); s += b; }
    return s;
}
static std::vector<uint8_t> bytes(const char* s) { return std::vector<uint8_t>(s, s + std::strlen(s)); }

int main() {
    {   // RFC 7914 section 11: PBKDF2-HMAC-SHA256, P "passwd", S "salt", c 1, dkLen 64
        auto p = bytes("passwd"), s = bytes("salt");
        std::vector<uint8_t> dk(64);
        scrypt::pbkdf2_sha256(p.data(), p.size(), s.data(), s.size(), 1, dk.data(), dk.size());
        check(hex(dk.data(), 64) == "55ac046e56e3089fec1691c22544b605f94185216dde0465e68b9d57c20dacbc"
                                    "49ca9cccf179b645991664b39d77ef317c71b845b1e30bd509112041d3a19783",
              "PBKDF2-HMAC-SHA256 (RFC 7914 11)");
    }
    {   // RFC 7914 section 12: scrypt("", "", 16, 1, 1, 64)
        std::vector<uint8_t> dk(64);
        scrypt::scrypt(nullptr, 0, nullptr, 0, 16, 1, 1, dk.data(), dk.size());
        check(hex(dk.data(), 64) == "77d6576238657b203b19ca42c18a0497f16b4844e3074ae8dfdffa3fede21442"
                                    "fcd0069ded0948f8326a753a0fc81f17e8d3e0fb2e0d3628cf35e20c38d18906",
              "scrypt N=16 r=1 p=1 (RFC 7914 12)");
    }
    {   // RFC 7914 section 12: scrypt("password", "NaCl", 1024, 8, 16, 64)
        auto p = bytes("password"), s = bytes("NaCl");
        std::vector<uint8_t> dk(64);
        scrypt::scrypt(p.data(), p.size(), s.data(), s.size(), 1024, 8, 16, dk.data(), dk.size());
        check(hex(dk.data(), 64) == "fdbabe1c9d3472007856e7190d01e9fe7c6ad7cbc8237830e77376634b373162"
                                    "2eaf30d92e22a3886ff109279d9830dac727afb94a83ee6d8360cbdfa2cc0640",
              "scrypt N=1024 r=8 p=16 (RFC 7914 12)");
    }
    {   // Litecoin's proof of work is scrypt(header, header, 1024, 1, 1, 32): the 80-byte path must equal the general one
        uint8_t h[80];
        for (int i = 0; i < 80; i++) h[i] = uint8_t(i * 7 + 3);
        uint8_t a[32], b[32];
        scrypt::pow_1024_1_1(h, a);
        scrypt::scrypt(h, 80, h, 80, 1024, 1, 1, b, 32);
        check(std::memcmp(a, b, 32) == 0, "pow_1024_1_1(header) == scrypt(header, header, 1024, 1, 1, 32)");
    }
    std::printf("%s %d/%d\n", pass == total ? "PASS" : "FAIL", pass, total);
    return pass == total ? 0 : 1;
}
