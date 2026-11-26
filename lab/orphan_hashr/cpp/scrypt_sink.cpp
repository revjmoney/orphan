// [orphan] H4SHR-CH3KR: L3+ works from the ARM, and the nonce split. by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "scrypt_sink.hpp"
#include "bm1485.hpp"

void ScryptSink::load(const Job& j, bool clean) {
    std::lock_guard<std::mutex> g(mu_);
    if (!have_ || clean) en2_ = j.en2_start;      // a new job: extranonce2 starts over
    job_ = j;
    have_ = true;
    if (clean) fresh_ = true;
}

void ScryptSink::stop() {
    std::lock_guard<std::mutex> g(mu_);
    have_ = false;
    fresh_ = false;
    st_.clear();
}

void ScryptSink::tick(double now) {
    std::vector<std::pair<int, std::vector<uint8_t>>> out;
    {
        std::lock_guard<std::mutex> g(mu_);
        if (!have_) return;
        bool fresh = fresh_;
        fresh_ = false;
        for (int c : chains_()) {
            ChainState& cs = st_[c];
            if (!fresh && cs.next >= 0 && now < cs.next) continue;
            Work w = build_work(job_, en2_++);
            int id = cs.id;
            cs.id = (cs.id + 1) & 0x7F;
            cs.ids[id] = {w.tag, w.tag2};
            cs.next = now + bm85::timeout_s(mhz_(c));
            out.emplace_back(c, bm85::work_frame(uint8_t(id), w.header));
        }
    }
    for (auto& f : out) send_(f.first, f.second);   // outside the lock: sending touches the bus
}

bool ScryptSink::lookup(int chain, int id, uint32_t& tag, uint32_t& tag2) const {
    std::lock_guard<std::mutex> g(mu_);
    auto c = st_.find(chain);
    if (c == st_.end()) return false;
    auto s = c->second.ids.find(id & 0x7F);
    if (s == c->second.ids.end()) return false;
    tag = s->second.tag;
    tag2 = s->second.tag2;
    return true;
}

void NonceRouter::clear(bool scrypt) {
    std::lock_guard<std::mutex> g(mu_);
    (scrypt ? qsc_ : qsha_).clear();
}

bool NonceRouter::take(bool scrypt, Nonce& n) {
    std::lock_guard<std::mutex> g(mu_);
    Nonce x;
    for (int k = 0; k < 4096 && pop_(x); k++) {    // empty the FIFO into the two queues
        if (!is_scrypt_(x.chain)) { qsha_.push_back(x); continue; }
        if (!sink_ || !sink_->lookup(x.chain, x.jid, x.tag, x.tag2)) continue;   // a work id we never sent: drop
        x.chip = bm85::chip_of_nonce(x.nonce);
        qsc_.push_back(x);
    }
    while (qsha_.size() > CAP) qsha_.pop_front();
    while (qsc_.size() > CAP) qsc_.pop_front();
    std::deque<Nonce>& q = scrypt ? qsc_ : qsha_;
    if (q.empty()) return false;
    n = q.front();
    q.pop_front();
    return true;
}
