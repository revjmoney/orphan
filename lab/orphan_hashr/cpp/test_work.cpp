// [orphan] H4SHR-CH3KR: known-answer checks for the C++ work model (the FPGA builder's oracle), and the testbench
// vector writer.
//   g++ -O2 -std=c++17 -o test_work test_work.cpp sha256.cpp work.cpp && ./test_work && ./test_work vec ../sim/vec
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "sha256.hpp"
#include "work.hpp"
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

static std::vector<uint8_t> hex(const char* s) {
    std::vector<uint8_t> v;
    unsigned x;
    while (*s && std::sscanf(s, "%2x", &x) == 1) { v.push_back(uint8_t(x)); s += 2; }
    return v;
}
static std::array<uint8_t, 32> h32(const char* s, bool reverse) {
    auto v = hex(s);
    std::array<uint8_t, 32> a{};
    for (int i = 0; i < 32; i++) a[i] = v[reverse ? 31 - i : i];
    return a;
}

static Job big_job() {                             // 300-byte coinbase, en2 straddles bytes 63/64, 16 branches
    Job j{};
    j.tag = 0x0002;
    std::memcpy(j.version, hex("20000000").data(), 4);
    for (int i = 0; i < 32; i++) j.prevhash[i] = uint8_t(0xA0 + i);
    std::memcpy(j.ntime, hex("6743b1c0").data(), 4);
    std::memcpy(j.nbits, hex("17030ecd").data(), 4);
    for (int i = 0; i < 300; i++) j.coinbase.push_back(uint8_t((i * 37 + 11) & 0xFF));
    j.en2_off = 60;
    j.en2_size = 8;
    for (int b = 0; b < 16; b++) {
        std::array<uint8_t, 32> br;
        for (int k = 0; k < 32; k++) br[k] = uint8_t((b * 16 + k) & 0xFF);
        j.branches.push_back(br);
    }
    j.en2_start = 0x00FFFFFFFFFEull;               // +2 carries across bit 32 into the TAG
    return j;
}

static Job pad_job() {                             // 120 bytes: length mod 64 = 56, padding needs a third block
    Job j{};
    j.tag = 0x0003;
    std::memcpy(j.version, hex("20000004").data(), 4);
    for (int i = 0; i < 32; i++) j.prevhash[i] = uint8_t(0x5A ^ i);
    std::memcpy(j.ntime, hex("01020304").data(), 4);
    std::memcpy(j.nbits, hex("1d00ffff").data(), 4);
    for (int i = 0; i < 120; i++) j.coinbase.push_back(uint8_t(i ^ 0xC3));
    j.en2_off = 100;
    j.en2_size = 1;
    j.en2_start = 0xFE;
    return j;
}

static bool write_vectors(const std::string& dir) {
    struct N { const char* name; Job j; } jobs[] = {{"genesis", genesis_job()}, {"big", big_job()}, {"pad", pad_job()}};
    for (auto& n : jobs) {
        std::string p = dir + "/" + n.name + "_bank.hex";
        FILE* f = std::fopen(p.c_str(), "w");
        if (!f) return false;
        for (uint32_t w : bank_image(n.j)) std::fprintf(f, "%08x\n", w);
        std::fclose(f);
        p = dir + "/" + n.name + "_works.hex";
        f = std::fopen(p.c_str(), "w");
        if (!f) return false;
        for (uint64_t e = n.j.en2_start; e < n.j.en2_start + 3 && en2_ok(n.j, e); e++) {
            Work w = build_work(n.j, e);
            std::fprintf(f, "%08x\n%08x\n%08x\n%08x\n%08x\n", w.tag, w.tag2, w.tail[0], w.tail[1], w.tail[2]);
            for (int i = 7; i >= 0; i--) std::fprintf(f, "%08x\n", w.midstate[i]);
        }
        std::fclose(f);
    }
    return true;
}

int main(int argc, char** argv) {
    if (argc == 3 && std::string(argv[1]) == "vec") {
        bool ok = write_vectors(argv[2]);
        std::printf("%s\n", ok ? "vectors written" : "cannot write vectors");
        return ok ? 0 : 1;
    }
    const char* abc = "abc";
    check(sha::sha256(reinterpret_cast<const uint8_t*>(abc), 3) ==
              h32("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad", false),
          "sha256(abc)");

    Job g = genesis_job();
    check(g.coinbase.size() == 204, "genesis coinbase is 204 bytes");
    Work w = build_work(g, 0xffff001d);
    auto hdr = hex("01000000000000000000000000000000000000000000000000000000000000000000000"
                   "03ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d00000000");
    check(std::memcmp(w.header, hdr.data(), 80) == 0, "genesis header");
    auto hh = header_hash(w.header, 0x1dac2b7c);
    check(hh == h32("6fe28c0ab6f1b372c1a6a246ae63f74f931e8365e15a089c68d6190000000000", false) && meets_diff1(hh),
          "genesis block hash, meets diff 1");

    auto root = merkle_root(h32("b1fea52486ce0c62bb442b530a3f0132b826c74e473d1f2c220bfa78111c5082", true),
                            {h32("f4184fc596403b9d638783cf57adfe4c75c605f6356fbc91338530e9831e9e16", true)});
    check(root == h32("7dac2c5666815c17a3b36427de37bb9d2e2c5ccec3f8633eb91a4205cb4c10ff", true), "block 170 merkle root");

    Job b = big_job();
    Work t = build_work(b, 0x010000000005ull);
    check(t.tag == (0x0002u << 16 | 0x0100u) && t.tag2 == 0x00000005u, "tags TAG={pool,en2[47:32]} TAG2=en2[31:0]");

    std::printf("%s %d/%d\n", pass == total ? "PASS" : "FAIL", pass, total);
    return pass == total ? 0 : 1;
}
