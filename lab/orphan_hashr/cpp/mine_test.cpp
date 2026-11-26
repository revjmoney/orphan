// [orphan] H4SHR-CH3KR hashrd: builder test. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "mine_test.hpp"
#include "work.hpp"
#include <chrono>
#include <cstdio>
#include <thread>

namespace {
double now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
uint32_t bswap(uint32_t v) { return v >> 24 | (v >> 8 & 0xFF00) | (v << 8 & 0xFF0000) | v << 24; }
}

MineResult run_builder_test(Board& board, Bus& bus, int seconds) {
    MineResult r;
    r.seconds = seconds;
    if (!board.powered()) { r.why = "power is off"; return r; }
    if (!board.open_cores(0)) { r.why = "could not open the cores"; return r; }   // ticket 0: difficulty 1
    Job j = genesis_job();
    j.en2_start = 0;
    Builder b(bus);
    b.enable(false);
    b.write_bank(0, j);
    b.enable(true);
    b.flip(0, true);
    uint32_t built0 = b.built(), stalls0 = b.stalls();
    Chain& ch = board.chain();
    uint32_t sent0 = ch.stat().sent;
    r.per_chip.assign(board.chips(), 0);
    Nonce n;
    while (pop_nonce(bus, n)) {}                   // leftovers from the open-core busy works
    ch.flush(true, false, false);                  // queued ARM works must not go out as builder works
    ch.source(true);
    ch.run(true);
    double end = now() + seconds;
    while (now() < end) {
        if (!board.powered()) { r.why = "power went off during the test"; break; }
        while (pop_nonce(bus, n)) {
            if (n.chain != ch.index()) continue;
            r.nonces++;
            if ((n.tag >> 16) != j.tag) { r.other++; continue; }
            Work w = build_work(j, uint64_t(n.tag & 0xFFFF) << 32 | n.tag2);
            if (meets_diff1(header_hash(w.header, n.nonce))) {
                r.valid++;
                int c = int(n.nonce >> 26);
                if (c < int(r.per_chip.size())) r.per_chip[c]++;
            } else {
                r.invalid++;
                if (meets_diff1(header_hash(w.header, bswap(n.nonce)))) r.swapped++;   // byte-order diagnostic
                if (r.invalid <= 4) {                  // search every en2 handed out so far for the real work
                    uint32_t upto = b.built() - built0 + 8;
                    long hit = -1;
                    for (uint32_t e = 0; e < upto && hit < 0; e++)
                        if (meets_diff1(header_hash(build_work(j, e).header, n.nonce))) hit = long(e);
                    char t[160];
                    std::snprintf(t, sizeof t, "\n  invalid: jid %u chip %u nonce %08x tag %08x tag2 %08x -> %s %ld",
                                  unsigned(n.jid), unsigned(n.chip), n.nonce, n.tag, n.tag2,
                                  hit < 0 ? "no en2 up to" : "valid at en2", hit < 0 ? long(upto) : hit);
                    r.diag += t;
                }
            }
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(2));
    }
    ch.run(false);
    ch.source(false);
    ch.flush(true, false, false);                  // builder works left queued must not reach the next test
    b.enable(false);
    r.built = b.built() - built0;
    r.stalls = b.stalls() - stalls0;
    r.sent = ch.stat().sent - sent0;
    r.ok = r.why.empty();
    return r;
}

std::string mine_report(const MineResult& r) {
    if (!r.ok && r.nonces == 0) return "builder_test: " + r.why;
    char t[320];
    std::snprintf(t, sizeof t, "builder_test%s%s: %d s, %d nonces, %d valid (%.1f/s), %d invalid (%d valid byte-swapped), "
                  "%d other, works built %u sent %u, stalls %u\nper chip:", r.ok ? "" : " stopped: ", r.why.c_str(),
                  r.seconds, r.nonces, r.valid, r.seconds ? double(r.valid) / r.seconds : 0.0, r.invalid, r.swapped,
                  r.other, r.built, r.sent, r.stalls);
    std::string s = t;
    for (int c : r.per_chip) s += " " + std::to_string(c);
    return s + r.diag;
}
