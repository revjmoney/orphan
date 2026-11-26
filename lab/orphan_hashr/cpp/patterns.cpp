// [orphan] H4SHR-CH3KR hashrd: factory pattern test. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "patterns.hpp"
#include <chrono>
#include <cstdio>
#include <fstream>
#include <set>
#include <thread>

namespace {
const char* DIR = "/opt/ardzy/projects/bitmain_stock/minertest64";
double now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
uint32_t be32(const uint8_t* p) { return uint32_t(p[0]) << 24 | uint32_t(p[1]) << 16 | uint32_t(p[2]) << 8 | p[3]; }
}

PatternResult run_patterns(Board& board, Bus& bus, int count) {
    PatternResult r;
    r.count = count;
    if (!board.powered()) { r.why = "power is off"; return r; }
    const int chips = board.chips();
    std::vector<std::vector<uint8_t>> recs(chips);
    for (int c = 0; c < chips; c++) {
        char path[128];
        std::snprintf(path, sizeof path, "%s/raw_%02d.bin", DIR, c + 1);
        std::ifstream f(path, std::ios::binary);
        recs[c].assign(std::istreambuf_iterator<char>(f), {});
        if (int(recs[c].size()) < 48 * count) { r.why = std::string("pattern file missing or short: ") + path; return r; }
    }
    if (!board.open_cores(0)) { r.why = "could not open the cores"; return r; }   // patterns are difficulty 1
    Chain& ch = board.chain();
    std::set<long> found;
    r.per_chip.assign(chips, 0);
    auto collect = [&]() {
        Nonce n;
        while (pop_nonce(bus, n)) {
            if (n.chain != ch.index() || n.tag == 0xFFFFFFFF) continue;
            int c = int(n.tag >> 16), k = int(n.tag & 0xFFFF);
            if (c >= chips || k >= count) { r.other++; continue; }
            if (n.nonce != be32(&recs[c][48 * k + 44])) { r.other++; continue; }
            long key = long(c) * 65536 + k;
            if (found.count(key)) { r.copies++; continue; }
            found.insert(key);
            r.per_chip[c]++;
            if (int(n.nonce >> 26) != c) r.wrong_slice++;
        }
    };
    double t0 = now();
    ch.run(true);
    for (int k = 0; k < count; k++)
        for (int c = 0; c < chips; c++) {
            const uint8_t* p = &recs[c][48 * k];
            while (!ch.push_work(uint32_t(c) << 16 | uint32_t(k), 0, p + 32, p)) {
                if (!board.powered()) { r.why = "power went off during the test"; return r; }
                collect();
                std::this_thread::sleep_for(std::chrono::microseconds(500));
            }
            r.sent++;
            collect();
        }
    double end = now() + 5.0;
    while (now() < end) {
        collect();
        ChainStat s = ch.stat();
        if (!s.works && !s.sending) break;
        std::this_thread::sleep_for(std::chrono::milliseconds(2));
    }
    end = now() + 0.3;
    while (now() < end) { collect(); std::this_thread::sleep_for(std::chrono::milliseconds(2)); }
    ch.run(false);
    for (int c = 0; c < chips; c++) if (r.per_chip[c] == count) r.passed++;
    r.seconds = now() - t0;
    r.ok = true;
    return r;
}

std::string pattern_report(const PatternResult& r) {
    if (!r.ok) return "patterns: " + r.why;
    char b[256];
    std::snprintf(b, sizeof b, "patterns: %d of %d chips found all %d, %d works sent, %d copies, %d other, %d outside "
                  "their slice, %.1f s\nper chip:", r.passed, int(r.per_chip.size()), r.count, r.sent, r.copies,
                  r.other, r.wrong_slice, r.seconds);
    std::string s = b;
    for (int n : r.per_chip) s += " " + std::to_string(n);
    return s;
}
