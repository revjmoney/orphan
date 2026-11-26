// [orphan] H4SHR-CH3KR: the L3+ work feeder (ScryptSink) and the nonce router, without hardware.
//   g++ -O2 -std=c++17 -pthread -o test_scryptsink test_scryptsink.cpp scrypt_sink.cpp bm1485.cpp bm1387.cpp work.cpp sha256.cpp && ./test_scryptsink
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "bm1485.hpp"
#include "scrypt_sink.hpp"
#include <cstdio>
#include <deque>
#include <utility>

static int pass = 0, total = 0;
static void check(bool ok, const char* name) {
    total++;
    if (ok) pass++;
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", name);
}

int main() {
    std::vector<std::pair<int, std::vector<uint8_t>>> sent;
    ScryptSink s([] { return std::vector<int>{6, 7}; },
                 [&](int c, const std::vector<uint8_t>& f) { sent.emplace_back(c, f); }, [](int) { return 384; });
    Job j = genesis_job();
    j.tag = 9;
    j.en2_start = 0x100;
    s.load(j, true);
    s.tick(0);
    Work w0 = build_work(j, 0x100), w1 = build_work(j, 0x101);
    uint32_t t = 0, t2 = 0;
    bool ok = sent.size() == 2 && sent[0].first == 6 && sent[0].second == bm85::work_frame(0, w0.header) &&
              sent[1].first == 7 && sent[1].second == bm85::work_frame(0, w1.header) &&
              s.lookup(6, 0, t, t2) && t == w0.tag && t2 == w0.tag2 && s.lookup(7, 0, t, t2) && t2 == w1.tag2;
    check(ok, "a clean job: every L3+ chain gets work id 0 at once, each its own extranonce2");
    s.tick(5);
    bool quiet = sent.size() == 2;
    s.tick(19.5);
    check(quiet && sent.size() == 4 && sent[2].second[2] == 1 && sent[3].second[2] == 1,
          "then one work per chain every stock pacing interval (19 s at 384 MHz), ids counting up");
    Job j2 = j;
    j2.tag = 10;
    s.load(j2, false);
    s.tick(20);
    bool not_clean = sent.size() == 4;
    s.load(j2, true);
    s.tick(20.1);
    check(not_clean && sent.size() == 6, "a new job waits for the interval; a clean one goes out at once");
    for (int k = 0; k < 130; k++) s.tick(40 + 20.0 * k);   // 130 more works: ids 3 .. 132, wrapping to 5
    check(sent.back().second[2] == uint8_t((3 + 129) & 0x7F) && s.lookup(6, (3 + 129) & 0x7F, t, t2),
          "work ids wrap at 128 and the newest one is looked up");
    {
        std::deque<Nonce> fifo = {Nonce{6, (3 + 129) & 0x7F, 0, 0x0A3FFFFF, 0xDEAD, 0xBEEF}, Nonce{5, 3, 7, 0x1dac2b7c, 1u << 16, 5},
                                  Nonce{8, 77, 0, 0x12345678, 0, 0}};   // chain 8: an L3+ chain that never got work
        NonceRouter r([&](Nonce& n) { if (fifo.empty()) return false; n = fifo.front(); fifo.pop_front(); return true; },
                      [](int c) { return c >= 6; }, &s);
        Nonce a{}, b{};
        bool got_sc = r.scrypt().pop(a), got_sha = r.sha().pop(b), more_sc = r.scrypt().pop(a);
        s.lookup(6, (3 + 129) & 0x7F, t, t2);
        check(got_sc && got_sha && b.chain == 5 && b.tag == (1u << 16) && b.nonce == 0x1dac2b7c,
              "router: an S9 nonce goes to the SHA-256 miner untouched");
        Nonce c{};
        fifo = {Nonce{6, (3 + 129) & 0x7F, 0, 0x0A3FFFFF, 0xDEAD, 0xBEEF}};
        bool one = r.scrypt().pop(c);
        check(one && c.chain == 6 && c.tag == t && c.tag2 == t2 && c.chip == 0xA3 / 3 && !more_sc,
              "router: an L3+ nonce gets its job tag and extranonce2 from the work id; an unknown id is dropped");
    }
    s.stop();
    size_t n = sent.size();
    s.tick(10000);
    check(sent.size() == n && !s.lookup(6, 0, t, t2), "stop: no more works, nothing to look up");
    std::printf("%s %d/%d\n", pass == total ? "PASS" : "FAIL", pass, total);
    return pass == total ? 0 : 1;
}
