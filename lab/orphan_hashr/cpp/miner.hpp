// [orphan] H4SHR-CH3KR hashrd: the pool session and the miner loop. Stratum v1 (subscribe, authorize, notify,
// set_difficulty, submit), every pool job written into the FPGA builder, every nonce re-hashed on the ARM before a
// share goes out, the 3 % dev fee slices, reconnect with backoff. The hardware sits behind JobSink and NonceSource so
// the tests can run it against a fake pool and fake nonces.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include "algo.hpp"
#include "devfee.hpp"
#include "hw.hpp"
#include "stratum.hpp"
#include <deque>
#include <functional>
#include <map>
#include <mutex>
#include <set>
#include <string>
#include <tuple>
#include <vector>

struct JobSink {                                   // the FPGA side: builder banks and the chains it feeds
    virtual ~JobSink() = default;
    virtual void load(const Job& j, bool clean) = 0;
    virtual void stop() = 0;                       // no new works: builder off, chains stopped and flushed
};
struct NonceSource {
    virtual ~NonceSource() = default;
    virtual bool pop(Nonce& n) = 0;
};

struct PoolCfg {
    std::string url, user, password;               // url: stratum+tcp://host:port
};

struct MinePlan {                                  // pool, solo, or the two taking turns, solo first (Rev 2026-11-25)
    enum Mode { POOL, SOLO, ALTERNATE } mode = POOL;
    double leg_s = 3600;                           // one turn, seconds (the page sets minutes)
    bool solo_at(double t) const {                 // t: seconds since the plan was set
        if (mode != ALTERNATE) return mode == SOLO;
        return long(t / leg_s) % 2 == 0;
    }
    double leg_left(double t) const { return mode == ALTERNATE ? leg_s - (t - long(t / leg_s) * leg_s) : -1; }
    const char* name() const { return mode == POOL ? "pool" : mode == SOLO ? "solo" : "alternate"; }
};

struct BoardMine {                                 // per chain (one hashboard)
    uint64_t valid = 0, invalid = 0;
    double ghs = 0;
    std::vector<uint64_t> per_chip = std::vector<uint64_t>(72, 0);   // 63 on an S9 board, 72 on an L3+
};

struct MineStats {
    std::string state = "stopped", pool, user, last_event;
    std::string plan = "pool", leg = "pool";       // the plan, and whose turn it is now
    int leg_left_s = -1, leg_min = 60;             // seconds left in this turn (alternate only), one turn in minutes
    std::string solo_pool, solo_user;
    bool dev_slice = false, devfee = true;
    double ghs = 0, difficulty = 0;
    uint64_t valid = 0, invalid = 0, stale = 0, dupes = 0, accepted = 0, rejected = 0, submitted = 0, jobs = 0;
    std::vector<uint64_t> per_chip = std::vector<uint64_t>(72, 0);   // 63 on an S9 board, 72 on an L3+
    std::map<int, BoardMine> boards;               // by chain index (J number - 1)
    int slice_left_s = 0;
    double net_diff = 0, best_share = 0;           // network difficulty (job nbits), best share difficulty found
    long height = -1;                              // block height from the coinbase (BIP34), -1 unknown
    double connected_s = -1, last_share_s = -1;    // seconds since subscribed / since the last share went out
};

class Miner {
public:
    Miner(JobSink& sink, NonceSource& nonces, DevFee& fee, std::function<void(const std::string&)> log);
    ~Miner();
    void start(PoolCfg user_cfg);
    void stop();
    void set_plan(MinePlan plan, PoolCfg solo_cfg);   // any time; while mining it switches at once
    MinePlan plan() const;
    PoolCfg solo_cfg() const;
    bool running() const;
    MineStats stats() const;
    void poll_once(int wait_ms = 20);              // one step: connect or read pool lines, handle nonces, slices
    uint64_t en2_start = 0;                        // first extranonce2 of every job
    PoolCfg dev_cfg{DevFee::DEV_POOL, DevFee::DEV_USER, DevFee::DEV_PASSWORD};   // where dev fee slices mine
    double summary_s = 30;                         // a STATS line in the log this often while mining (0 = never)
    std::function<std::string()> summary_extra;    // appended to each STATS line (temperatures, fan)
    Algo algo;                                     // SHA-256d (S9 boards) or scrypt (L3+ boards)
    double suggest_diff = 0;                       // mining.suggest_difficulty when > 0
    double checkpoint_s = 30;                      // mining time goes into the dev fee ledger this often
    double subscribe_timeout_s = 30;               // no answer to subscribe: drop the connection, try again
    double idle_timeout_s = 300;                   // no new job this long: drop the connection, try again

private:
    struct Known { Notify n; Job j; double diff; int en2_size; };
    JobSink& sink_;
    NonceSource& src_;
    DevFee& fee_;
    std::function<void(const std::string&)> log_;
    mutable std::mutex mu_;
    MineStats st_;
    PoolCfg user_cfg_, cfg_, solo_cfg_;
    MinePlan plan_;
    double plan_t0_ = 0;                           // when the plan was set (alternate counts its turns from here)
    PoolCfg user_turn() const;                     // with mu_ held: the pool or the solo account, by the plan
    bool running_ = false;
    int fd_ = -1;
    std::string rx_;
    bool subscribed_ = false;
    std::string en1_;
    int en2_size_ = 0;
    double diff_ = 1;
    uint16_t next_tag_ = 1;
    std::deque<uint16_t> order_;                   // the last 8 job tags, oldest first
    std::map<uint16_t, Known> jobs_;
    std::set<std::tuple<uint16_t, uint64_t, uint32_t>> seen_;
    std::deque<std::tuple<uint16_t, uint64_t, uint32_t>> seen_order_;
    std::deque<std::pair<double, int>> recent_;    // (time, chain) of valid nonces, last 60 s
    int rid_ = 4;
    DevFee::Role role_ = DevFee::USER;
    double slice_t0_ = 0, slice_len_ = 0, next_try_ = 0, backoff_ = 2, started_ = 0, connected_at_ = 0, share_at_ = 0;
    double tcp_at_ = 0, notify_at_ = 0;            // when the socket connected, when the last job came
    struct Pending { double diff; int chain, chip; double t; };
    std::map<int, Pending> pending_;               // shares sent, waiting for the pool's answer (for the log)
    double sum_at_ = 0;                            // the last STATS line, and the counters then
    MineStats sum_last_;
    void summary(double now);                      // with mu_ held

    void connect_now();
    void disconnect(const std::string& why);
    void send(const std::string& method, const json::Value& params, int id);
    void handle(const std::string& line);
    void handle_nonce(const Nonce& n);
    void begin_slice();
    void end_slice();
    void event(const std::string& s);
};

double mono_now();                                 // seconds, steady clock
