// [orphan] H4SHR-CH3KR: the L3+ side of the miner. BM1485 boards need one 82-byte work about every 19 s per chain, so
// the ARM builds them (no FPGA builder) and sends each through the chain's raw command path; the chain's FPGA work
// sender stays off. ScryptSink remembers which (job tag, extranonce2) each work id 0..127 carried; NonceRouter splits
// the one FPGA nonce FIFO between the SHA-256 miner (S9 chains) and the scrypt miner (L3+ chains) and gives L3+ nonces
// their tags back. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include "miner.hpp"
#include <deque>
#include <functional>
#include <map>
#include <mutex>
#include <vector>

class ScryptSink : public JobSink {
public:
    using Send = std::function<void(int chain, const std::vector<uint8_t>& frame)>;
    ScryptSink(std::function<std::vector<int>()> chains, Send send, std::function<int(int chain)> mhz)
        : chains_(std::move(chains)), send_(std::move(send)), mhz_(std::move(mhz)) {}
    void load(const Job& j, bool clean) override;  // a clean job goes out on every chain at the next tick
    void stop() override;                          // no more works; every work id forgotten
    void tick(double now);                         // send the works that are due (the mining loop calls it)
    void kick() { std::lock_guard<std::mutex> g(mu_); fresh_ = true; }   // a new work on every chain at the next tick
    bool lookup(int chain, int id, uint32_t& tag, uint32_t& tag2) const;
private:
    struct Slot { uint32_t tag, tag2; };
    struct ChainState { double next = -1; int id = 0; std::map<int, Slot> ids; };
    std::function<std::vector<int>()> chains_;
    Send send_;
    std::function<int(int)> mhz_;
    mutable std::mutex mu_;
    bool have_ = false, fresh_ = false;
    Job job_{};
    uint64_t en2_ = 0;
    std::map<int, ChainState> st_;
};

class NonceRouter {
public:
    NonceRouter(std::function<bool(Nonce&)> pop, std::function<bool(int chain)> is_scrypt, ScryptSink* sink)
        : pop_(std::move(pop)), is_scrypt_(std::move(is_scrypt)), sink_(sink), sha_(*this, false), sc_(*this, true) {}
    NonceSource& sha() { return sha_; }
    NonceSource& scrypt() { return sc_; }
    void clear(bool scrypt);                       // a miner starting: forget what waited for it
    static constexpr size_t CAP = 4096;            // an idle side keeps only the newest
private:
    struct Q : NonceSource {
        Q(NonceRouter& r, bool s) : r_(r), s_(s) {}
        bool pop(Nonce& n) override { return r_.take(s_, n); }
        NonceRouter& r_;
        bool s_;
    };
    bool take(bool scrypt, Nonce& n);
    std::function<bool(Nonce&)> pop_;
    std::function<bool(int)> is_scrypt_;
    ScryptSink* sink_;
    std::mutex mu_;
    std::deque<Nonce> qsha_, qsc_;
    Q sha_, sc_;
};
