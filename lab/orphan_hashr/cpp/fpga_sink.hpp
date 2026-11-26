// [orphan] H4SHR-CH3KR hashrd: the miner's hardware side. Pool jobs go into the builder's inactive bank and flip in
// (clean drops queued works); the chains of the powered boards take the builder's works; nonces come from the FPGA's
// shared nonce FIFO. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include "miner.hpp"
#include <functional>
#include <set>
#include <vector>

class FpgaSink : public JobSink {
public:
    FpgaSink(Bus& bus, std::function<std::vector<Chain*>()> chains) : bus_(bus), b_(bus), chains_(std::move(chains)) {}
    void load(const Job& j, bool clean) override {
        bank_ ^= 1;                                 // the builder keeps working from the other bank meanwhile
        b_.write_bank(bank_, j);
        if (!on_) { b_.enable(true); on_ = true; }
        b_.flip(bank_, clean);
        for (Chain* c : chains_()) {
            if (fed_.count(c)) continue;
            c->flush(true, false, false);           // queued ARM works must not go out as pool works
            c->source(true);
            c->run(true);
            fed_.insert(c);
        }
    }
    void stop() override {
        b_.enable(false);
        on_ = false;
        for (Chain* c : fed_) {                     // every chain it fed, even one whose board went off meanwhile
            c->run(false);
            c->source(false);
            c->flush(true, false, false);
        }
        fed_.clear();
    }
private:
    Bus& bus_;
    Builder b_;
    std::function<std::vector<Chain*>()> chains_;
    int bank_ = 1;
    bool on_ = false;
    std::set<Chain*> fed_;                         // every chain ever fed, powered or not now
};
