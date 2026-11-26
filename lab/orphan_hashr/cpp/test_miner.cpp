// [orphan] H4SHR-CH3KR: the miner against a fake stratum pool on localhost, a fake FPGA (job sink) and fake nonces.
// Builds on the board (POSIX sockets):
//   g++ -O2 -std=c++17 -pthread -o test_miner test_miner.cpp miner.cpp algo.cpp scrypt.cpp bm1485.cpp bm1387.cpp stratum.cpp devfee.cpp json.cpp work.cpp sha256.cpp && ./test_miner
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "miner.hpp"
#include <arpa/inet.h>
#include <atomic>
#include <chrono>
#include <cstdio>
#include <fstream>
#include <netinet/in.h>
#include <sys/socket.h>
#include <thread>
#include <unistd.h>

static int pass = 0, total = 0;
static void check(bool ok, const char* name) {
    total++;
    if (ok) pass++;
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", name);
}

// ---------------------------------------------------------------- a fake stratum pool
struct FakePool {
    int lfd = -1, port = 0;
    std::atomic<int> cfd{-1};
    std::atomic<int> accepted{0};
    std::mutex mu;
    std::vector<std::string> lines;               // every line the miner sent, in order
    std::thread th;
    std::atomic<bool> quit{false};
    FakePool() {
        lfd = socket(AF_INET, SOCK_STREAM, 0);
        int one = 1;
        setsockopt(lfd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one);
        sockaddr_in a{};
        a.sin_family = AF_INET;
        a.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
        bind(lfd, reinterpret_cast<sockaddr*>(&a), sizeof a);
        socklen_t n = sizeof a;
        getsockname(lfd, reinterpret_cast<sockaddr*>(&a), &n);
        port = ntohs(a.sin_port);
        listen(lfd, 4);
        th = std::thread([this] {
            while (!quit) {
                int c = accept(lfd, nullptr, nullptr);
                if (c < 0) break;
                cfd = c;
                accepted++;
                std::string buf;
                char b[4096];
                ssize_t k;
                while ((k = read(c, b, sizeof b)) > 0) {
                    buf.append(b, size_t(k));
                    size_t p;
                    while ((p = buf.find('\n')) != std::string::npos) {
                        std::lock_guard<std::mutex> g(mu);
                        lines.push_back(buf.substr(0, p));
                        buf.erase(0, p + 1);
                    }
                }
            }
        });
    }
    ~FakePool() { quit = true; shutdown(lfd, SHUT_RDWR); close(lfd); if (cfd >= 0) close(cfd); th.join(); }
    void say(const std::string& l) { std::string s = l + "\n"; if (write(cfd, s.data(), s.size()) < 0) {} }
    void drop() { int c = cfd.exchange(-1); shutdown(c, SHUT_RDWR); close(c); }
    size_t count() { std::lock_guard<std::mutex> g(mu); return lines.size(); }
    std::string line(size_t i) { std::lock_guard<std::mutex> g(mu); return i < lines.size() ? lines[i] : ""; }
};

struct FakeSink : JobSink {
    std::vector<Job> loads;
    std::vector<bool> cleans;
    int stops = 0;
    void load(const Job& j, bool clean) override { loads.push_back(j); cleans.push_back(clean); }
    void stop() override { stops++; }
};
struct FakeNonces : NonceSource {
    std::deque<Nonce> q;
    bool pop(Nonce& n) override { if (q.empty()) return false; n = q.front(); q.pop_front(); return true; }
};

template <class F> static bool until(Miner& m, F f, int ms = 3000) {
    for (int t = 0; t < ms; t += 20) { m.poll_once(20); if (f()) return true; }
    return f();
}

static std::string genesis_tx() {
    std::string s;
    char b[3];
    for (uint8_t c : genesis_job().coinbase) { std::snprintf(b, sizeof b, "%02x", c); s += b; }
    return s;
}
static std::string notify_line(const char* id, bool clean) {
    std::string tx = genesis_tx();
    return std::string("{\"id\":null,\"method\":\"mining.notify\",\"params\":[\"") + id + "\",\"" + std::string(64, '0') +
           "\",\"" + tx.substr(0, 82) + "\",\"" + tx.substr(94) + "\",[],\"00000001\",\"1d00ffff\",\"495fab29\"," +
           (clean ? "true" : "false") + "]}";
}

int main() {
    std::remove("test_miner.local.json");
    DevFee fee("test_miner.local.json");
    fee.enabled = false;
    FakePool pool;
    FakeSink sink;
    FakeNonces nonces;
    std::vector<std::string> logs;
    Miner m(sink, nonces, fee, [&](const std::string& s) { logs.push_back(s); });
    m.en2_start = 0xffff001d;
    std::string url = "stratum+tcp://127.0.0.1:" + std::to_string(pool.port);
    m.start({url, "revjmoney.s9bench", "x"});

    // subscribe_flow
    bool ok = until(m, [&] { return pool.count() >= 2; });
    ok = ok && pool.line(0).find("\"mining.subscribe\"") != std::string::npos &&
         pool.line(1).find("\"mining.authorize\"") != std::string::npos &&
         pool.line(1).find("[\"revjmoney.s9bench\",\"x\"]") != std::string::npos;
    std::string en1 = genesis_tx().substr(82, 4);
    pool.say("{\"id\":1,\"result\":[[[\"mining.notify\",\"s1\"]],\"" + en1 + "\",4],\"error\":null}");
    pool.say("{\"id\":2,\"result\":true,\"error\":null}");
    pool.say("{\"id\":null,\"method\":\"mining.set_difficulty\",\"params\":[1]}");
    pool.say(notify_line("g1", true));
    ok = ok && until(m, [&] { return sink.loads.size() == 1; });
    if (ok) {
        Job j = sink.loads[0];
        const uint8_t e2[4] = {0xff, 0xff, 0x00, 0x1d};
        for (int k = 0; k < 4; k++) j.coinbase[size_t(j.en2_off + k)] = e2[k];
        std::vector<uint32_t> want;
        std::ifstream f("../sim/vec/genesis_bank.hex");
        std::string s;
        while (f >> s) want.push_back(uint32_t(std::stoul(s, nullptr, 16)));
        ok = bank_image(j) == want && sink.cleans[0];
    }
    check(ok, "subscribe_flow (subscribe, authorize, genesis job in the bank)");

    // submit_line: the genesis nonce from chain 5 goes to the pool exactly as pools read it
    nonces.q.push_back(Nonce{5, 1, 7, 0x1dac2b7c, 1u << 16, 0xffff001d});
    size_t before = pool.count();
    ok = until(m, [&] { return pool.count() > before; });
    std::string want_line = "{\"id\":4,\"method\":\"mining.submit\",\"params\":[\"revjmoney.s9bench\",\"g1\",\"ffff001d\",\"495fab29\",\"7c2bac1d\"]}";
    ok = ok && pool.line(before) == want_line;
    if (!ok) std::printf("     got  %s\n     want %s\n", pool.line(before).c_str(), want_line.c_str());
    pool.say("{\"id\":4,\"result\":true,\"error\":null}");
    ok = ok && until(m, [&] { return m.stats().accepted == 1; });
    MineStats st = m.stats();
    ok = ok && st.valid == 1 && st.submitted == 1 && st.boards.count(5) && st.boards[5].valid == 1;
    check(ok, "submit_line (mining.submit text, accepted)");

    // diff_per_job: job g2 arrives at difficulty 3000; the same genesis nonce (a 2536 share) is valid, not submitted
    pool.say("{\"id\":null,\"method\":\"mining.set_difficulty\",\"params\":[3000]}");
    pool.say(notify_line("g2", false));
    ok = until(m, [&] { return sink.loads.size() == 2; });
    nonces.q.push_back(Nonce{5, 2, 7, 0x1dac2b7c, 2u << 16, 0xffff001d});
    ok = ok && until(m, [&] { return m.stats().valid == 2; });
    for (int k = 0; k < 10; k++) m.poll_once(20);
    st = m.stats();
    ok = ok && st.submitted == 1 && st.difficulty == 3000;
    check(ok, "diff_per_job (difficulty in force when the job came)");

    // stale_after_clean: after a clean job, a nonce for g1 is never submitted
    pool.say(notify_line("g3", true));
    ok = until(m, [&] { return sink.loads.size() == 3; });
    nonces.q.push_back(Nonce{5, 1, 7, 0x1dac2b7c, 1u << 16, 0xffff001e});
    ok = ok && until(m, [&] { return m.stats().stale == 1; });
    for (int k = 0; k < 10; k++) m.poll_once(20);
    ok = ok && m.stats().submitted == 1;
    check(ok, "stale_after_clean");

    // reconnect: the pool drops us; the chains stop getting works, the miner subscribes again within 2.5 s
    int stops = sink.stops, acc = pool.accepted;
    size_t lines0 = pool.count();
    pool.drop();
    ok = until(m, [&] { return sink.stops > stops; }, 1000);
    auto t0 = std::chrono::steady_clock::now();
    ok = ok && until(m, [&] { return pool.accepted > acc; }, 2600);
    double dt = std::chrono::duration<double>(std::chrono::steady_clock::now() - t0).count();
    bool s1 = sink.stops > stops, a1 = pool.accepted > acc;
    ok = ok && dt < 2.6 && until(m, [&] { return pool.count() > lines0; });
    ok = ok && pool.line(lines0).find("\"mining.subscribe\"") != std::string::npos;
    if (!ok) std::printf("     stopped %d accepted %d after %.2f s, line %s\n", s1, a1, dt, pool.line(lines0).c_str());
    check(ok, "reconnect (stop, subscribe again)");
    m.stop();

    // dev_slice: with 180 s owed, the first session mines to the developer's account
    std::remove("test_miner.local.json");
    DevFee fee2("test_miner.local.json");
    fee2.add(DevFee::USER, 5820);
    FakePool pool2;
    Miner m2(sink, nonces, fee2, [&](const std::string& s) { logs.push_back(s); });
    m2.dev_cfg = {"stratum+tcp://127.0.0.1:" + std::to_string(pool2.port), DevFee::DEV_USER, DevFee::DEV_PASSWORD};
    m2.start({url, "revjmoney.s9bench", "x"});
    ok = until(m2, [&] { return pool2.count() >= 2; });
    ok = ok && pool2.line(1).find("[\"revjmoney.orphan-devfee\",\"d=10\"]") != std::string::npos && m2.stats().dev_slice;
    check(ok, "dev_slice (owed time goes to the developer's account first)");
    m2.stop();
    std::remove("test_miner.local.json");

    // ledger_checkpoint: mining time reaches the dev fee ledger during a slice, not only at its end (a crash or a
    // power cut must not skip the fee or charge it twice)
    {
        std::remove("test_miner_cp.local.json");
        DevFee f3("test_miner_cp.local.json");
        FakePool p3;
        Miner m3(sink, nonces, f3, nullptr);
        m3.checkpoint_s = 0.2;
        m3.start({"stratum+tcp://127.0.0.1:" + std::to_string(p3.port), "revjmoney.s9bench", "x"});
        for (int k = 0; k < 40; k++) m3.poll_once(20);              // about 0.8 s, never stopped
        DevFee seen("test_miner_cp.local.json");                    // what a restart would read now
        check(seen.owed() > 0.3 * 3 / 97, "ledger_checkpoint (time saved while mining)");
        m3.stop();
        std::remove("test_miner_cp.local.json");
    }
    // opt_out_not_billed: time mined with the dev fee off is never billed when it is switched on again
    {
        std::remove("test_miner_oo.local.json");
        DevFee f4("test_miner_oo.local.json");
        f4.enabled = false;
        FakePool p4;
        Miner m4(sink, nonces, f4, nullptr);
        m4.checkpoint_s = 0.2;
        m4.start({"stratum+tcp://127.0.0.1:" + std::to_string(p4.port), "revjmoney.s9bench", "x"});
        for (int k = 0; k < 40; k++) m4.poll_once(20);
        m4.stop();
        DevFee seen("test_miner_oo.local.json");
        check(seen.owed() == 0, "opt_out_not_billed");
        std::remove("test_miner_oo.local.json");
    }
    // subscribe_timeout: a pool that takes the connection but never answers is dropped and tried again
    {
        std::remove("test_miner_st.local.json");
        DevFee f5("test_miner_st.local.json");
        f5.enabled = false;
        FakePool p5;
        Miner m5(sink, nonces, f5, nullptr);
        m5.subscribe_timeout_s = 0.5;
        m5.start({"stratum+tcp://127.0.0.1:" + std::to_string(p5.port), "revjmoney.s9bench", "x"});
        bool ok5 = until(m5, [&] { return p5.accepted >= 2; }, 4000);
        check(ok5, "subscribe_timeout (silent pool dropped, connected again)");
        m5.stop();
        std::remove("test_miner_st.local.json");
    }
    // algo_scrypt: L3+ nonces are re-hashed with scrypt; scrypt difficulty 1 is 65536 x the SHA-256 one. Nonce
    // 0x00012efd on the genesis header (en2 ffff001d) hashes to 00004ff3db61... (found by search, a ~3.2 share).
    {
        Algo sc{Algo::SCRYPT};
        Work w = build_work(genesis_job(), 0xffff001d);
        auto h = sc.hash(w.header, 0x00012efd);
        auto h2 = sc.hash(w.header, 0x00012efe);
        double d = sc.share_diff(h);
        check(h[31] == 0x00 && h[30] == 0x00 && h[29] == 0x4f && h[28] == 0xf3 && sc.diff1(h) && !sc.diff1(h2),
              "algo_scrypt: hash and difficulty 1");
        check(d > 3.1 && d < 3.3 && share_ok(h, sc.target(3)) && !share_ok(h, sc.target(4)) &&
                  sc.chip(0x0A3FFFFF) == 0xA3 / 3,
              "algo_scrypt: share difficulty in scrypt units, pool target, chip from nonce");
        {   // not circular: the real Litecoin genesis header (nonce 2084524493 as a chip returns it, big-endian)
            const char* mr = "97ddfbbae6be97fd6cdf3e7ca13232a3afff2353e29badfab7f73011edd4ced9";
            uint8_t lh[80] = {};
            lh[0] = 1;
            for (int i = 0; i < 32; i++) { unsigned x; std::sscanf(mr + 2 * i, "%2x", &x); lh[36 + 31 - i] = uint8_t(x); }
            uint32_t t = 1317972665, bits = 0x1e0ffff0;
            for (int i = 0; i < 4; i++) { lh[68 + i] = uint8_t(t >> 8 * i); lh[72 + i] = uint8_t(bits >> 8 * i); }
            auto g = sc.hash(lh, 0xCD513F7C);      // 2084524493 = 0x7C3F51CD
            std::string hx;
            char b2[3];
            for (int k = 31; k >= 0; k--) { std::snprintf(b2, sizeof b2, "%02x", g[size_t(k)]); hx += b2; }
            check(hx == "0000050c34a64b415b6b15b37f2216634b5b1669cb9a2e38d76f7213b0671e00" && sc.diff1(g),
                  "algo_scrypt: the Litecoin genesis header hashes under its own nBits");
        }
        Algo sh;
        check(sh.kind == Algo::SHA256D && sh.diff1(sh.hash(w.header, 0x1dac2b7c)) && sh.chip(0xFC000000) == 63,
              "algo_sha256d: the S9 path unchanged");
    }
    // scrypt_submit: a Scrypt miner submits the L3+ nonce at difficulty 1 and keeps it back at difficulty 4
    {
        std::remove("test_miner_sc.local.json");
        DevFee f7("test_miner_sc.local.json");
        f7.enabled = false;
        FakePool p7;
        FakeSink s7;
        FakeNonces n7;
        Miner m7(s7, n7, f7, nullptr);
        m7.algo = Algo{Algo::SCRYPT};
        m7.en2_start = 0xffff001d;
        m7.start({"stratum+tcp://127.0.0.1:" + std::to_string(p7.port), "revjmoney.l3hashr", "x"});
        bool ok7 = until(m7, [&] { return p7.count() >= 2; });
        p7.say("{\"id\":1,\"result\":[[[\"mining.notify\",\"s1\"]],\"" + genesis_tx().substr(82, 4) + "\",4],\"error\":null}");
        p7.say("{\"id\":2,\"result\":true,\"error\":null}");
        p7.say("{\"id\":null,\"method\":\"mining.set_difficulty\",\"params\":[1]}");
        p7.say(notify_line("l1", true));
        ok7 = ok7 && until(m7, [&] { return s7.loads.size() == 1; });
        n7.q.push_back(Nonce{6, 1, 0, 0x00012efd, 1u << 16, 0xffff001d});
        size_t before7 = p7.count();
        ok7 = ok7 && until(m7, [&] { return p7.count() > before7; });
        ok7 = ok7 && p7.line(before7).find("[\"revjmoney.l3hashr\",\"l1\",\"ffff001d\",\"495fab29\",\"fd2e0100\"]") != std::string::npos;
        check(ok7, "scrypt_submit (difficulty 1: the L3+ nonce goes out)");
        p7.say("{\"id\":null,\"method\":\"mining.set_difficulty\",\"params\":[4]}");
        p7.say(notify_line("l2", false));
        bool ok8 = until(m7, [&] { return s7.loads.size() == 2; });
        n7.q.push_back(Nonce{6, 2, 0, 0x00012efd, 2u << 16, 0xffff001d});
        ok8 = ok8 && until(m7, [&] { return m7.stats().valid == 2; });
        for (int k = 0; k < 10; k++) m7.poll_once(20);
        ok8 = ok8 && m7.stats().submitted == 1 && m7.stats().invalid == 0;
        check(ok8, "scrypt_submit (difficulty 4: valid, kept back)");
        m7.stop();
        std::remove("test_miner_sc.local.json");
    }
    // mine_plan: pool, solo, or both taking turns (Rev 2026-11-25); a turn of solo comes first
    {
        MinePlan pl{MinePlan::POOL, 60}, so{MinePlan::SOLO, 60}, al{MinePlan::ALTERNATE, 60};
        check(!pl.solo_at(0) && !pl.solo_at(5000) && so.solo_at(0) && so.solo_at(5000), "mine_plan: pool / solo");
        check(al.solo_at(0) && al.solo_at(59.9) && !al.solo_at(60) && !al.solo_at(119.9) && al.solo_at(120) &&
              int(al.leg_left(45)) == 15 && int(al.leg_left(70)) == 50, "mine_plan: alternate, solo first, leg_left");
    }
    // alternate: the miner takes turns on the solo pool and the pool, and the page can change the plan while mining
    {
        std::remove("test_miner_al.local.json");
        DevFee f6("test_miner_al.local.json");
        f6.enabled = false;
        FakePool ps, pp;
        Miner m6(sink, nonces, f6, nullptr);
        m6.set_plan({MinePlan::ALTERNATE, 0.6}, {"stratum+tcp://127.0.0.1:" + std::to_string(ps.port), "solo.worker", "m=solo"});
        m6.start({"stratum+tcp://127.0.0.1:" + std::to_string(pp.port), "revjmoney.s9bench", "x"});
        bool ok6 = until(m6, [&] { return ps.count() >= 2; }) && pp.accepted == 0 &&
                   ps.line(1).find("[\"solo.worker\",\"m=solo\"]") != std::string::npos && m6.stats().leg == "solo";
        ok6 = ok6 && until(m6, [&] { return pp.count() >= 2; }) && m6.stats().leg == "pool";
        ok6 = ok6 && until(m6, [&] { return ps.accepted >= 2; });
        check(ok6, "alternate (solo turn, pool turn, solo again)");
        m6.set_plan({MinePlan::POOL, 0.6}, {"stratum+tcp://127.0.0.1:" + std::to_string(ps.port), "solo.worker", "m=solo"});
        int before = pp.accepted;
        bool ok7 = until(m6, [&] { return pp.accepted > before; }) && m6.stats().leg == "pool" && m6.stats().plan == "pool";
        check(ok7, "set_plan while mining switches at once");
        m6.stop();
        std::remove("test_miner_al.local.json");
    }
    std::printf("%s %d/%d\n", pass == total ? "PASS" : "FAIL", pass, total);
    return pass == total ? 0 : 1;
}
