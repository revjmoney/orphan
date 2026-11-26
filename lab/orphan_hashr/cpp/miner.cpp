// [orphan] H4SHR-CH3KR hashrd: the pool session and the miner loop (see miner.hpp). by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "miner.hpp"
#include <algorithm>
#include <chrono>
#include <cstring>
#include <fcntl.h>
#include <netdb.h>
#include <poll.h>
#include <sys/socket.h>
#include <unistd.h>

double mono_now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }

namespace {
bool split_url(const std::string& url, std::string& host, std::string& port) {
    std::string u = url;
    size_t p = u.find("://");
    if (p != std::string::npos) u = u.substr(p + 3);
    size_t c = u.rfind(':');
    if (c == std::string::npos || c == 0 || c + 1 >= u.size()) return false;
    host = u.substr(0, c);
    port = u.substr(c + 1);
    return true;
}
int dial(const std::string& host, const std::string& port, int timeout_ms, std::string& why) {
    addrinfo hints{}, *res = nullptr;
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    if (getaddrinfo(host.c_str(), port.c_str(), &hints, &res) != 0 || !res) { why = "cannot resolve " + host; return -1; }
    int fd = -1;
    for (addrinfo* a = res; a; a = a->ai_next) {
        fd = socket(a->ai_family, a->ai_socktype, a->ai_protocol);
        if (fd < 0) continue;
        fcntl(fd, F_SETFL, fcntl(fd, F_GETFL) | O_NONBLOCK);
        int r = connect(fd, a->ai_addr, a->ai_addrlen);
        if (r != 0 && errno == EINPROGRESS) {
            pollfd pf{fd, POLLOUT, 0};
            if (poll(&pf, 1, timeout_ms) == 1) {
                int err = 0;
                socklen_t n = sizeof err;
                getsockopt(fd, SOL_SOCKET, SO_ERROR, &err, &n);
                r = err ? -1 : 0;
            } else r = -1;
        }
        if (r == 0) break;
        close(fd);
        fd = -1;
    }
    freeaddrinfo(res);
    if (fd < 0) why = "cannot connect to " + host + ":" + port;
    return fd;
}
}

Miner::Miner(JobSink& sink, NonceSource& nonces, DevFee& fee, std::function<void(const std::string&)> log)
    : sink_(sink), src_(nonces), fee_(fee), log_(std::move(log)) {}

Miner::~Miner() { stop(); }

bool Miner::running() const { std::lock_guard<std::mutex> g(mu_); return running_; }

MineStats Miner::stats() const {
    std::lock_guard<std::mutex> g(mu_);
    MineStats s = st_;
    s.devfee = fee_.enabled;
    if (running_) s.slice_left_s = int(slice_t0_ + slice_len_ - mono_now());
    double t = mono_now();
    s.plan = plan_.name();
    s.leg = plan_.solo_at(t - plan_t0_) && !solo_cfg_.url.empty() ? "solo" : "pool";
    s.leg_left_s = plan_.mode == MinePlan::ALTERNATE ? int(plan_.leg_left(t - plan_t0_)) : -1;
    s.leg_min = int(plan_.leg_s / 60 + 0.5);
    s.solo_pool = solo_cfg_.url;
    s.solo_user = solo_cfg_.user;
    s.connected_s = subscribed_ && connected_at_ > 0 ? t - connected_at_ : -1;
    s.last_share_s = share_at_ > 0 ? t - share_at_ : -1;
    return s;
}

namespace {
std::string fmt_num(double d) {                    // 1234567 -> 1.23M, 16384 -> 16384, 0.5 -> 0.5
    char b[32];
    double a = d < 0 ? -d : d;
    if (a >= 1e12) std::snprintf(b, sizeof b, "%.2fT", d / 1e12);
    else if (a >= 1e9) std::snprintf(b, sizeof b, "%.2fG", d / 1e9);
    else if (a >= 1e6) std::snprintf(b, sizeof b, "%.2fM", d / 1e6);
    else if (a >= 1e5) std::snprintf(b, sizeof b, "%.0fk", d / 1e3);
    else if (a >= 100 || a == double(long(a))) std::snprintf(b, sizeof b, "%.0f", d);
    else std::snprintf(b, sizeof b, "%.3g", d);
    return b;
}
std::string fmt_rate(double hs) {                  // hashes per second -> "131 MH/s"
    const char* u[] = {"H/s", "kH/s", "MH/s", "GH/s", "TH/s", "PH/s"};
    int i = 0;
    while (hs >= 1000 && i < 5) { hs /= 1000; i++; }
    char b[32];
    std::snprintf(b, sizeof b, hs >= 100 ? "%.0f %s" : "%.1f %s", hs, u[i]);
    return b;
}
std::string jname(int chain) { return "J" + std::to_string(chain + 1); }
}

void Miner::event(const std::string& s) {
    st_.last_event = s;
    if (log_) log_(s);
}

void Miner::start(PoolCfg user_cfg) {
    {
        std::lock_guard<std::mutex> g(mu_);
        if (running_) return;
        user_cfg_ = std::move(user_cfg);
        running_ = true;
        st_ = MineStats();
        st_.state = "connecting";
        started_ = mono_now();
        sum_at_ = 0;
        sum_last_ = MineStats();
        pending_.clear();
        backoff_ = 2;
        next_try_ = 0;
    }
    begin_slice();
}

void Miner::stop() {
    bool was;
    {
        std::lock_guard<std::mutex> g(mu_);
        was = running_;
        running_ = false;
    }
    if (!was) return;
    end_slice();
    disconnect("stopped");
    std::lock_guard<std::mutex> g(mu_);
    st_.state = "stopped";
}

void Miner::set_plan(MinePlan plan, PoolCfg solo_cfg) {
    std::lock_guard<std::mutex> g(mu_);
    plan_ = plan;
    solo_cfg_ = std::move(solo_cfg);
    plan_t0_ = mono_now();
}
MinePlan Miner::plan() const { std::lock_guard<std::mutex> g(mu_); return plan_; }
PoolCfg Miner::solo_cfg() const { std::lock_guard<std::mutex> g(mu_); return solo_cfg_; }

PoolCfg Miner::user_turn() const {
    return plan_.solo_at(mono_now() - plan_t0_) && !solo_cfg_.url.empty() ? solo_cfg_ : user_cfg_;
}

// a dev fee slice or a user slice: which account mines, and for how long
void Miner::begin_slice() {
    auto nx = fee_.next();
    std::lock_guard<std::mutex> g(mu_);
    role_ = nx.first;
    cfg_ = role_ == DevFee::DEV ? dev_cfg : user_turn();
    slice_t0_ = mono_now();
    slice_len_ = nx.second;
    st_.dev_slice = role_ == DevFee::DEV;
    st_.pool = cfg_.url;
    st_.user = cfg_.user;
    next_try_ = 0;
}

void Miner::end_slice() {
    double t;
    DevFee::Role r;
    {
        std::lock_guard<std::mutex> g(mu_);
        t = mono_now() - slice_t0_;
        r = role_;
        slice_t0_ = mono_now();
    }
    if (r == DevFee::DEV || fee_.enabled) fee_.add(r, t);   // time mined with the fee off is never billed later
}

void Miner::send(const std::string& method, const json::Value& params, int id) {
    json::Value m = json::Value::object();
    m.set("id", id);
    m.set("method", method);
    m.set("params", params);
    std::string s = json::dump(m) + "\n";
    if (fd_ >= 0 && ::send(fd_, s.data(), s.size(), MSG_NOSIGNAL) != ssize_t(s.size())) disconnect("send failed");
}

void Miner::connect_now() {
    std::string host, port, why;
    PoolCfg c;
    {
        std::lock_guard<std::mutex> g(mu_);
        c = cfg_;
    }
    int fd = -1;
    if (!split_url(c.url, host, port)) why = "pool address must be stratum+tcp://host:port";
    else fd = dial(host, port, 5000, why);
    {
        std::lock_guard<std::mutex> g(mu_);
        if (fd < 0) {
            st_.state = "reconnecting";
            event(why + "; trying again in " + std::to_string(int(backoff_)) + " s");
            next_try_ = mono_now() + backoff_;
            backoff_ = std::min(60.0, backoff_ * 2);
            return;
        }
        fd_ = fd;
        tcp_at_ = notify_at_ = mono_now();
        event("connected to " + host + ":" + port + " (" + algo.name() + "), logging in as " + c.user);
        diff_ = 1;                                 // a new connection starts at difficulty 1 until the pool says
        rx_.clear();
        subscribed_ = false;
        st_.state = "subscribing";
    }                                              // send() may disconnect, which takes the lock itself
    json::Value p = json::Value::array();
    p.push("H4SHR-CH3KR/1.0");
    send("mining.subscribe", p, 1);
    json::Value a = json::Value::array();
    a.push(c.user);
    a.push(c.password);
    send("mining.authorize", a, 2);
    if (suggest_diff > 0) {
        json::Value s = json::Value::array();
        s.push(suggest_diff);
        send("mining.suggest_difficulty", s, 3);
    }
}

void Miner::disconnect(const std::string& why) {
    bool had;
    {
        std::lock_guard<std::mutex> g(mu_);
        had = fd_ >= 0;
        if (had) { close(fd_); fd_ = -1; }
        subscribed_ = false;
        jobs_.clear();
        order_.clear();
        if (running_) {
            st_.state = "reconnecting";
            next_try_ = mono_now() + backoff_;
            backoff_ = std::min(60.0, backoff_ * 2);
        }
        if (had) event("pool connection closed: " + why);
    }
    if (had) sink_.stop();                         // no new works while there is no pool to send shares to
}

void Miner::handle(const std::string& line) {
    json::Value m;
    if (!json::parse(line, m) || !m.is_object()) return;
    const std::string& method = m["method"].str();
    std::unique_lock<std::mutex> g(mu_);
    if (method == "mining.notify") {
        Notify n;
        if (!notify_from(m["params"], n)) { event("pool sent a mining.notify that is not readable"); return; }
        if (!subscribed_) return;
        uint16_t tag = next_tag_++;                // 1, 2, 3 ... 65534, 1 (0 and 0xFFFF are never a job)
        if (next_tag_ == 0 || next_tag_ == 0xFFFF) next_tag_ = 1;   // 0xFFFF: open_cores' busy works
        Job j;
        std::string why;
        st_.jobs++;
        if (!job_from(n, en1_, en2_size_, tag, j, why)) {
            event("job " + n.id + " refused: " + why + " (waiting for the next job)");
            if (n.clean) { jobs_.clear(); order_.clear(); g.unlock(); sink_.stop(); }
            return;
        }
        j.en2_start = en2_start;
        st_.net_diff = nbits_difficulty(n.nbits);
        st_.height = coinbase_height(n.coinb1);
        {
            std::string e = "job " + n.id + (n.clean ? ": new block" : ": same block, updated");
            if (n.clean && st_.height > 0) e += " " + std::to_string(st_.height);
            if (st_.net_diff > 0) e += ", network difficulty " + fmt_num(algo.kind == Algo::SCRYPT ? st_.net_diff * 65536.0 : st_.net_diff);
            e += ", pool difficulty " + fmt_num(diff_) + (n.clean ? ", old work dropped" : "");
            event(e);
        }
        if (n.clean) { jobs_.clear(); order_.clear(); }
        jobs_[tag] = Known{n, j, diff_, en2_size_};
        order_.push_back(tag);
        while (order_.size() > 8) { jobs_.erase(order_.front()); order_.pop_front(); }
        st_.state = "mining";
        notify_at_ = mono_now();
        backoff_ = 2;
        g.unlock();
        sink_.load(j, n.clean);
        return;
    }
    if (method == "mining.set_difficulty") {
        double d = m["params"][0].num(0);
        if (d > 0 && d != diff_) {
            std::string e = "pool difficulty " + fmt_num(d) + " (was " + fmt_num(diff_) + ")";
            double per = (algo.kind == Algo::SCRYPT ? 65536.0 : 4294967296.0) * d;   // hashes per share
            if (st_.ghs > 0) e += ": one share every ~" + fmt_num(per / (st_.ghs * 1e9)) + " s at " + fmt_rate(st_.ghs * 1e9);
            event(e);
        }
        if (d > 0) { diff_ = d; st_.difficulty = d; }
        return;
    }
    if (method == "client.reconnect" || method == "mining.set_extranonce") {
        g.unlock();
        disconnect(method + " from the pool");
        return;
    }
    if (!method.empty()) return;
    int id = int(m["id"].num(-1));
    if (id == 1) {
        const json::Value& r = m["result"];
        if (!r.is_array() || r.size() < 3 || !r[1].is_string()) { g.unlock(); disconnect("the pool refused the subscription"); return; }
        en1_ = r[1].str();
        en2_size_ = int(r[2].num(0));
        subscribed_ = true;
        connected_at_ = mono_now();
        event("subscribed: extranonce1 " + en1_ + ", extranonce2 " + std::to_string(en2_size_) + " bytes");
    } else if (id == 2) {
        if (!m["result"].boolean()) { g.unlock(); disconnect("the pool refused the wallet / worker " + cfg_.user); return; }
        event("authorized as " + cfg_.user);
    } else if (id >= 4) {
        auto pi = pending_.find(id);
        std::string what = "share #" + std::to_string(id);
        if (pi != pending_.end()) {
            char ms[16];
            std::snprintf(ms, sizeof ms, "%.0f", (mono_now() - pi->second.t) * 1000);
            what += " (difficulty " + fmt_num(pi->second.diff) + ", " + jname(pi->second.chain) + " chip " +
                    std::to_string(pi->second.chip) + ", answer in " + ms + " ms)";
            pending_.erase(pi);
        }
        if (m["result"].boolean()) {
            st_.accepted++;
            event(what + " accepted, " + std::to_string(st_.accepted) + " so far");
        } else {
            st_.rejected++;
            event(what + " rejected: " + json::dump(m["error"]));
        }
    }
}

void Miner::handle_nonce(const Nonce& n) {
    std::unique_lock<std::mutex> g(mu_);
    uint16_t tag = uint16_t(n.tag >> 16);
    auto it = jobs_.find(tag);
    if (it == jobs_.end()) { st_.stale++; return; }
    uint64_t en2 = uint64_t(n.tag & 0xFFFF) << 32 | n.tag2;
    auto key = std::make_tuple(tag, en2, n.nonce);
    if (seen_.count(key)) { st_.dupes++; return; }
    seen_.insert(key);
    seen_order_.push_back(key);
    while (seen_order_.size() > 4096) { seen_.erase(seen_order_.front()); seen_order_.pop_front(); }
    Known k = it->second;
    std::string user = cfg_.user;
    g.unlock();
    Work w = build_work(k.j, en2);                 // the ARM re-hashes every nonce: nothing goes out unchecked
    auto h = algo.hash(w.header, n.nonce);
    bool valid = algo.diff1(h);
    bool share = valid && share_ok(h, algo.target(k.diff));
    g.lock();
    BoardMine& b = st_.boards[n.chain];
    if (!valid) { st_.invalid++; b.invalid++; return; }
    st_.valid++;
    b.valid++;
    size_t chip = size_t(algo.chip(n.nonce));
    if (chip < st_.per_chip.size()) st_.per_chip[chip]++;
    if (chip < b.per_chip.size()) b.per_chip[chip]++;
    recent_.emplace_back(mono_now(), n.chain);
    st_.best_share = std::max(st_.best_share, algo.share_diff(h));
    if (!share) return;
    json::Value p = json::Value::array();
    p.push(user);
    p.push(k.n.id);
    p.push(en2_hex(en2, k.en2_size));
    p.push(k.n.ntime);
    p.push(submit_nonce_hex(n.nonce));
    int id = rid_++;
    st_.submitted++;
    share_at_ = mono_now();
    {
        double sd = algo.share_diff(h);
        pending_[id] = {sd, n.chain, int(chip), share_at_};
        while (pending_.size() > 256) pending_.erase(pending_.begin());
        event("share found on " + jname(n.chain) + " chip " + std::to_string(chip) + ": difficulty " + fmt_num(sd) +
              " (pool asks " + fmt_num(k.diff) + "), sent as #" + std::to_string(id));
    }
    g.unlock();
    send("mining.submit", p, id);
}

void Miner::poll_once(int wait_ms) {
    {
        std::lock_guard<std::mutex> g(mu_);
        if (!running_) return;
    }
    double now = mono_now();
    bool slice_over, need_connect;
    {
        std::lock_guard<std::mutex> g(mu_);
        slice_over = now >= slice_t0_ + slice_len_;
        if (role_ == DevFee::USER) {               // the plan's turn changed, or the page changed the plan
            PoolCfg u = user_turn();
            if (u.url != cfg_.url || u.user != cfg_.user || u.password != cfg_.password) slice_over = true;
        }
        need_connect = fd_ < 0 && now >= next_try_;
    }
    if (slice_over) {                              // a dev fee slice or a solo / pool turn: reconnect with the other account
        end_slice();
        PoolCfg was;
        DevFee::Role was_role;
        { std::lock_guard<std::mutex> g(mu_); was = cfg_; was_role = role_; }
        begin_slice();
        PoolCfg is;
        DevFee::Role is_role;
        { std::lock_guard<std::mutex> g(mu_); is = cfg_; is_role = role_; }
        if (is.url != was.url || is.user != was.user || is.password != was.password) {
            std::string why;
            if (is_role != was_role) why = std::string("dev fee slice ") + (is_role == DevFee::DEV ? "starts" : "ends");
            else { std::lock_guard<std::mutex> g(mu_); why = is.url == solo_cfg_.url && is.user == solo_cfg_.user ? "solo turn starts" : "pool turn starts"; }
            disconnect(why);
            std::lock_guard<std::mutex> g(mu_);
            next_try_ = 0;
            backoff_ = 2;
        }
        need_connect = false;
    }
    if (need_connect) connect_now();
    {                                              // checkpoint the dev fee ledger, and drop a silent pool
        bool cp = false, silent = false, idle = false;
        {
            std::lock_guard<std::mutex> g(mu_);
            double t = mono_now();
            cp = t - slice_t0_ >= checkpoint_s;
            silent = fd_ >= 0 && !subscribed_ && t - tcp_at_ > subscribe_timeout_s;
            idle = fd_ >= 0 && subscribed_ && t - notify_at_ > idle_timeout_s;
        }
        if (cp) {
            double done;
            {
                std::lock_guard<std::mutex> g(mu_);
                done = mono_now() - slice_t0_;
                slice_len_ -= done;                // the slice ends at the same moment
            }
            end_slice();
        }
        if (silent) disconnect("the pool did not answer the subscription");
        if (idle) disconnect("no new job from the pool for " + std::to_string(int(idle_timeout_s)) + " s");
    }
    int fd;
    { std::lock_guard<std::mutex> g(mu_); fd = fd_; }
    if (fd >= 0) {
        pollfd pf{fd, POLLIN, 0};
        if (poll(&pf, 1, wait_ms) == 1) {
            char b[8192];
            ssize_t k = ::recv(fd, b, sizeof b, 0);
            if (k <= 0) disconnect("the pool closed the connection");
            else {
                rx_.append(b, size_t(k));
                size_t p;
                while ((p = rx_.find('\n')) != std::string::npos) {
                    std::string line = rx_.substr(0, p);
                    rx_.erase(0, p + 1);
                    handle(line);
                }
                if (rx_.size() > 1 << 20) disconnect("the pool sent a line over 1 MB");
            }
        }
    } else if (wait_ms > 0) {
        poll(nullptr, 0, wait_ms);
    }
    Nonce n;
    for (int k = 0; k < 4096 && src_.pop(n); k++) handle_nonce(n);
    std::lock_guard<std::mutex> g(mu_);
    double t = mono_now();
    while (!recent_.empty() && recent_.front().first < t - 60) recent_.pop_front();
    double span = std::min(60.0, std::max(1.0, t - started_));
    st_.ghs = double(recent_.size()) / span * algo.hashes_per_nonce() / 1e9;
    std::map<int, size_t> per;
    for (auto& r : recent_) per[r.second]++;
    for (auto& b : st_.boards) b.second.ghs = double(per[b.first]) / span * algo.hashes_per_nonce() / 1e9;
    if (summary_s > 0 && st_.state == "mining" && t - sum_at_ >= summary_s) summary(t);
}

void Miner::summary(double now) {
    double secs = sum_at_ > 0 ? now - sum_at_ : now - started_;
    const MineStats& o = sum_last_;
    std::string e = "STATS " + fmt_rate(st_.ghs * 1e9);
    if (st_.boards.size() > 1) {
        e += " (";
        bool first = true;
        for (auto& b : st_.boards) { e += (first ? "" : ", ") + jname(b.first) + " " + fmt_rate(b.second.ghs * 1e9); first = false; }
        e += ")";
    }
    char b[64];
    std::snprintf(b, sizeof b, " | last %.0f s: ", secs);
    e += b + std::to_string(st_.valid - o.valid) + " nonces";
    if (st_.invalid != o.invalid) e += ", " + std::to_string(st_.invalid - o.invalid) + " bad";
    if (st_.stale != o.stale) e += ", " + std::to_string(st_.stale - o.stale) + " for old jobs";
    if (st_.dupes != o.dupes) e += ", " + std::to_string(st_.dupes - o.dupes) + " repeats";
    e += ", " + std::to_string(st_.submitted - o.submitted) + " shares sent, " + std::to_string(st_.jobs - o.jobs) + " jobs";
    e += " | total " + std::to_string(st_.accepted) + " accepted";
    if (st_.rejected) e += ", " + std::to_string(st_.rejected) + " not taken";
    e += ", best share " + fmt_num(st_.best_share) + ", pool difficulty " + fmt_num(st_.difficulty);
    if (st_.dev_slice) e += ", DEV FEE SLICE";
    if (summary_extra) { std::string x = summary_extra(); if (!x.empty()) e += " | " + x; }
    sum_last_ = st_;
    sum_at_ = now;
    event(e);
}
