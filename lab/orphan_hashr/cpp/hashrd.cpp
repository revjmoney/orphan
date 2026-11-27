// [orphan] H4SHR-CH3KR hashrd: the hashboard daemon. No Python, no third-party libraries.
//   hashrd                  run the daemon (root): fans low, nothing powered until a power_on command
//   hashrd <command ...>    send one command to the running daemon and print its answer
// Commands (one per line on /run/hashrd.sock):
//   status | detect | power_on [volts] [mhz] [header] | power_off | renew | patterns [count] | builder_test [seconds]
//   mine_start [pool] [user] [password] | mine_stop | mine_status | devfee on|off
//   pic_info | set_volts v | set_chip i mhz|off | set_row r mhz|off | set_all mhz   (each may end with J6, J7 or J8)
//   hold [volts] [seconds] [J] | diag [volts] [J] | rstprobe [volts] [J] | kat [J] | skot [J]   (diagnostics, Rev present)
//   fan auto | fan manual <pct> | fan curve <lo_c> <hi_c>
// Power goes on only on a power_on command (Rev's rule: the owner is there); the renew timer, the 90 C board cut and
// the 60 s no-temperature cut run once a second.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "bm1387.hpp"
#include "board.hpp"
#include "cyd.hpp"
#include "fleet.hpp"
#include "fanctl.hpp"
#include "fpga_sink.hpp"
#include "http.hpp"
#include "json.hpp"
#include "l3board.hpp"
#include "mine_test.hpp"
#include "miner.hpp"
#include "patterns.hpp"
#include "scrypt_sink.hpp"
#include <algorithm>
#include <atomic>
#include <deque>
#include <fstream>
#include <chrono>
#include <csignal>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <memory>
#include <mutex>
#include <sstream>
#include <string>
#include <pthread.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <thread>
#include <unistd.h>
#include <vector>

namespace {
const char* SOCK = "/run/hashrd.sock";

std::mutex log_mu;
std::vector<std::string> recent;
struct LogEntry { long seq; double t; std::string level, msg; };
std::deque<LogEntry> page_log;                     // the page's log (it asks for the entries after its last seq)
long log_seq = 0;

std::string level_of(const std::string& s) {
    if (s.find("STATS ") != std::string::npos) return "stats";
    if (s.find(" accepted, ") != std::string::npos) return "good";
    for (const char* w : {"failed", "error", "refused", "above 90", "no temperature", "ran out", "rejected"})
        if (s.find(w) != std::string::npos && s.find(" accepted, ") == std::string::npos) return "error";
    for (const char* w : {"stopped", "unknown", "stale", "warn", "busy", "OFF", "HOLD"})
        if (s.find(w) != std::string::npos) return "warn";
    return "info";
}

void logline(const std::string& s) {
    char t[32];
    std::time_t now = std::time(nullptr);
    std::tm tm{};
    localtime_r(&now, &tm);
    std::strftime(t, sizeof t, "%H:%M:%S", &tm);
    std::lock_guard<std::mutex> g(log_mu);
    std::string line = std::string(t) + " " + s;
    std::printf("[hashrd] %s\n", line.c_str());
    std::fflush(stdout);
    recent.push_back(line);
    if (recent.size() > 20) recent.erase(recent.begin());
    page_log.push_back({++log_seq, double(now), level_of(s), s});
    if (page_log.size() > 400) page_log.pop_front();
}

int client(int argc, char** argv) {
    std::string line;
    for (int i = 1; i < argc; i++) line += (i > 1 ? " " : "") + std::string(argv[i]);
    line += "\n";
    int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    sockaddr_un a{};
    a.sun_family = AF_UNIX;
    std::strncpy(a.sun_path, SOCK, sizeof a.sun_path - 1);
    if (connect(fd, reinterpret_cast<sockaddr*>(&a), sizeof a) != 0) {
        std::fprintf(stderr, "hashrd is not running\n");
        return 1;
    }
    if (write(fd, line.data(), line.size()) < 0) return 1;
    char buf[4096];
    ssize_t n;
    while ((n = read(fd, buf, sizeof buf)) > 0) fwrite(buf, 1, size_t(n), stdout);
    close(fd);
    return 0;
}

struct Daemon {
    Bus bus;
    Hashr hr{bus};
    Fan fan{bus};
    std::mutex mu;                                 // guards boards[] and active
    std::unique_ptr<Board> boards[9];              // one per header, made once and never destroyed (threads keep
    int active = -1;                               // their pointers), so a board can never lose its safety loop
    std::unique_ptr<L3Board> l3[9];                // L3+ boards (l3board.hpp), made once like boards[]
    std::string kinds[9];                          // per header: "s9", "l3p", or "" = unknown (POWER ON refused)
    std::string kind(int h) { std::lock_guard<std::mutex> g(mu); return h >= 0 && h < 9 ? kinds[h] : std::string(); }
    static std::string kind_name(const std::string& k) { return k == "s9" ? "an S9 board" : k == "l3p" ? "an L3+ board" : "of unknown type"; }

    Board* current() {
        std::lock_guard<std::mutex> g(mu);
        return active < 0 ? nullptr : boards[active].get();
    }

    // ---- several boards (fleet.hpp): views for the rules, board objects with the shared GO / fan hooks
    static int jnum(const std::string& s) {         // "J6", "j6" or "6" -> 5
        std::string t = (!s.empty() && (s[0] == 'J' || s[0] == 'j')) ? s.substr(1) : s;
        int n = std::atoi(t.c_str());
        return n >= 1 && n <= 9 ? n - 1 : -1;
    }
    std::string board_temps(bool l3only) {         // "J7 42/32 C, fan 46 %" for the STATS lines
        std::string s;
        for (const BoardView& v : views()) {
            if (!v.powered) continue;
            if (l3only != (kind(v.header) == "l3p")) continue;
            s += (s.empty() ? "" : ", ") + std::string("J") + std::to_string(v.header + 1) + " chip " +
                 (v.chip_c >= 0 ? std::to_string(v.chip_c) : std::string("?")) + " C, board " +
                 (v.pcb_c >= 0 ? std::to_string(v.pcb_c) : std::string("?")) + " C";
        }
        return s + (s.empty() ? "" : ", ") + "fan " + std::to_string(fan.applied()) + " %";
    }
    std::vector<BoardView> views() {
        std::lock_guard<std::mutex> g(mu);
        std::vector<BoardView> v;
        for (auto& b : boards)
            if (b) v.push_back({b->header(), b->powered(), b->off(), b->pcb_c(), b->chip_c()});
        for (auto& b : l3)
            if (b) v.push_back({b->header(), b->powered(), b->off(), b->pcb_c(), b->chip_c()});
        return v;
    }
    Board* make_board(int h) {                     // with mu held
        if (!boards[h]) {
            Board* b = new Board(bus, hr, fan, h);
            b->log = logline;
            b->others_on = [this, h] { return fleet::others_on(views(), h); };
            b->on_temp = [this] { int t = fleet::hottest(views()); if (t >= 0) fan.temp(t); fan_tick(); };
            boards[h].reset(b);
        }
        return boards[h].get();
    }
    L3Board* make_l3(int h) {                      // with mu held
        if (!l3[h]) {
            L3Board* b = new L3Board(bus, hr, fan, h);
            b->log = logline;
            b->others_on = [this, h] { return fleet::others_on(views(), h); };
            b->on_temp = [this] { int t = fleet::hottest(views()); if (t >= 0) fan.temp(t); fan_tick(); };
            l3[h].reset(b);
        }
        return l3[h].get();
    }
    L3Board* l3_at(int h) { std::lock_guard<std::mutex> g(mu); return h >= 0 && h < 9 ? l3[h].get() : nullptr; }
    std::vector<L3Board*> powered_l3() {
        std::lock_guard<std::mutex> g(mu);
        std::vector<L3Board*> v;
        for (auto& b : l3) if (b && b->powered()) v.push_back(b.get());
        return v;
    }
    // the board a command means: "J<n>" at the end of the command, else the only board that is on, else the last one
    Board* chosen(std::istringstream& in, std::string& why) {
        std::string j;
        int want = (in >> j) ? jnum(j) : -1;
        auto v = views();
        int h = fleet::pick(v, want, why);
        if (h < 0 && want < 0) {
            bool any_on = false;
            for (auto& b : v) any_on = any_on || !b.off;
            if (!any_on) {                         // nothing on: the board last used (pic_info, status)
                Board* c = current();
                if (c && kind(c->header()) != "s9") { why = "no S9 board"; return nullptr; }
                return c;
            }
        }
        if (h < 0) return nullptr;
        std::lock_guard<std::mutex> g(mu);
        if (kinds[h] != "s9") { why = "J" + std::to_string(h + 1) + " is " + kind_name(kinds[h]) + ": that is an S9 command"; return nullptr; }
        return boards[h].get();
    }

    // ---- fan modes (fanctl.hpp): the curve until VIZOR's FAN slider moves, then the slider until the CURVE button
    FanFollow follow;
    std::mutex fan_mu;
    void fan_tick() {
        std::lock_guard<std::mutex> g(fan_mu);
        int d = fan.duty_set();
        if (follow.moved(d)) {
            if (fan.auto_curve()) {
                fan.rules(true, false);
                logline("fan: the FAN slider moved to " + std::to_string(d) + " %, manual until CURVE");
            }
            return;
        }
        if (fan.auto_curve()) {                    // the slider shows what the curve drives
            int a = fan.applied();
            if (a != d) { fan.duty(a); follow.mirror(a); }
        }
    }
    std::string fan_cmd(std::istringstream& in) {  // fan curve [lo hi] | fan manual <pct>
        std::string m;
        in >> m;
        std::lock_guard<std::mutex> g(fan_mu);
        if (m == "auto" || m == "curve") {
            int lo = fan.curve_lo(), hi = fan.curve_hi();
            if (m == "curve" && !(in >> lo >> hi)) { lo = fan.curve_lo(); hi = fan.curve_hi(); }
            if (!fan_curve_ok(lo, hi)) return "failed: curve 20 to 90 C, the top at least 5 C over the bottom\n";
            fan.curve(lo, hi);
            fan.rules(true, true);
            settings.set("fan_lo", lo);
            settings.set("fan_hi", hi);
            save_settings();
            return "fan curve " + std::to_string(lo) + " to " + std::to_string(hi) + " C\n";
        }
        if (m == "manual") {
            int pct = 20;
            in >> pct;
            pct = std::max(20, std::min(100, pct));
            fan.rules(true, false);
            fan.duty(pct);
            follow.mirror(pct);
            return "fan manual " + std::to_string(pct) + " %\n";
        }
        return "fan curve [lo hi] | fan manual <pct>\n";
    }

    // timer on|off [minutes]: the owner-present power timer; switching it on or changing it starts it over
    std::string timer_cmd(std::istringstream& in) {
        std::string v;
        int m = Board::ptimer.seconds / 60;
        in >> v;
        if (v != "on" && v != "off") return "timer on|off [minutes]\n";
        in >> m;
        if (!PowerTimer::minutes_ok(m)) return "failed: the timer is 1 to 1440 minutes\n";
        Board::ptimer.seconds = 60 * m;
        Board::ptimer.on = v == "on";
        for (Board* b : powered_boards()) b->renew();
        settings.set("timer_on", v == "on");
        settings.set("timer_min", m);
        save_settings();
        logline(v == "on" ? "power timer on, " + std::to_string(m) + " minutes"
                          : std::string("power timer OFF: the 90 C cut, the no-temperature cut and the PIC heartbeat still guard the boards"));
        return v == "on" ? "timer on, " + std::to_string(m) + " minutes\n" : "timer off\n";
    }

    // ---- settings kept across restarts: the mining plan, the fan curve and the power timer
    json::Value settings = json::Value::object();
    static constexpr const char* SETTINGS = "settings.local.json";
    void load_settings() {
        std::ifstream f(SETTINGS);
        if (!f) return;
        std::stringstream ss;
        ss << f.rdbuf();
        json::Value v;
        if (json::parse(ss.str(), v) && v.is_object()) settings = v;
    }
    void save_settings() {
        std::string tmp = std::string(SETTINGS) + ".tmp";
        { std::ofstream o(tmp); o << json::dump(settings) << "\n"; }
        std::rename(tmp.c_str(), SETTINGS);
    }
    static PoolCfg solo_default() { return {"stratum+tcp://americas.mining-dutch.nl:9996", "revjmoney.solo", "x"}; }
    void apply_plan() {                            // settings -> miner
        const std::string m = settings["plan"].str();
        MinePlan p;
        p.mode = m == "solo" ? MinePlan::SOLO : m == "alternate" ? MinePlan::ALTERNATE : MinePlan::POOL;
        p.leg_s = 60 * settings["minutes"].num(60);
        PoolCfg sc = solo_default();
        if (!settings["solo_pool"].str().empty()) sc.url = settings["solo_pool"].str();
        if (!settings["solo_user"].str().empty()) sc.user = settings["solo_user"].str();
        if (!settings["solo_password"].str().empty()) sc.password = settings["solo_password"].str();
        miner.set_plan(p, sc);
    }
    // plan pool|solo|alternate [minutes] [solo_pool solo_user solo_password]
    std::string plan_cmd(std::istringstream& in) {
        std::string m, url, user, pass;
        int minutes = int(settings["minutes"].num(60));
        in >> m;
        if (m != "pool" && m != "solo" && m != "alternate") return "plan pool|solo|alternate [minutes] [solo pool user password]\n";
        if (in >> minutes) in >> url >> user >> pass;
        if (minutes < 5 || minutes > 1440) return "failed: a turn is 5 to 1440 minutes\n";
        if (!url.empty()) {
            if (url.rfind("stratum+tcp://", 0) != 0 || user.empty() || pass.empty())
                return "failed: solo pool stratum+tcp://host:port, a user and a password\n";
            settings.set("solo_pool", url);
            settings.set("solo_user", user);
            settings.set("solo_password", pass);
        }
        settings.set("plan", m);
        settings.set("minutes", minutes);
        save_settings();
        apply_plan();
        PoolCfg sc = miner.solo_cfg();
        return "plan " + m + (m == "alternate" ? ", " + std::to_string(minutes) + " minute turns, solo first" : "") +
               (m != "pool" ? ", solo as " + sc.user + " on " + sc.url : "") + "\n";
    }

    // ---- mining: pool jobs into the FPGA builder, nonces re-hashed, shares submitted (miner.hpp)
    DevFee fee{"devfee.local.json"};
    FpgaSink sink{bus, [this] { return mining_chains(); }};   // only the boards mine_start opened (their op locks held)
    ScryptSink ssink{[this] { return l3_mining_headers(); },
                     [this](int c, const std::vector<uint8_t>& f) { L3Board* l = l3_at(c); if (l) l->send(f); },
                     [this](int c) { L3Board* l = l3_at(c); return l ? l->mhz() : bm85::DEFAULT_MHZ; }};
    NonceRouter router{[this](Nonce& n) { return pop_nonce(bus, n); }, [this](int c) { return kind(c) == "l3p"; },
                       &ssink};                    // the one owner of the FPGA nonce FIFO while mining
    Miner miner{sink, router.sha(), fee, [](const std::string& s) { logline("mine: " + s); }};
    // ---- L3+ mining (scrypt): its own pool, dev fee ledger and thread; works from the ARM (scrypt_sink.hpp)
    DevFee fee_sc{"devfee-scrypt.local.json"};
    Miner sminer{ssink, router.scrypt(), fee_sc, [](const std::string& s) { logline("mine L3+: " + s); }};
    std::atomic<bool> smining{false};
    std::thread smine_thread;
    std::vector<L3Board*> smine_boards;            // their op locks are held while mining
    std::mutex smine_mu;
    std::vector<int> l3_mining_headers() {
        std::vector<int> v;
        if (l3test_h >= 0) { v.push_back(l3test_h); return v; }   // the chip test feeds its one board
        for (L3Board* b : smine_boards) if (b->powered()) v.push_back(b->header());
        return v;
    }
    std::string smine_start(std::istringstream& in) {
        std::lock_guard<std::mutex> one(smine_mu);
        std::string url = "stratum+tcp://americas.mining-dutch.nl:8888", user = "revjmoney.l3hashr", pass = "x", a;
        if (in >> a) url = a;
        if (in >> a) user = a;
        if (in >> a) pass = a;
        if (smining) return "already mining (L3+)\n";
        if (l3test_h >= 0) return "busy: the chip test runs on J" + std::to_string(l3test_h + 1) + "\n";
        if (smine_thread.joinable()) smine_thread.join();
        std::vector<L3Board*> pw = powered_l3();
        if (pw.empty()) return "no L3+ board powered\n";
        for (L3Board* b : pw) if (!b->op.try_lock()) {
            for (L3Board* x : pw) { if (x == b) break; x->op.unlock(); }
            return "J" + std::to_string(b->header() + 1) + " busy\n";
        }
        for (L3Board* b : pw) b->op.unlock();      // the mining thread takes them itself
        smine_boards = pw;
        router.clear(true);
        sminer.start({url, user, pass});
        smining = true;
        smine_thread = std::thread([this] {
            for (L3Board* b : smine_boards) b->op.lock();
            while (smining) {
                sminer.poll_once(20);
                ssink.tick(mono_now());
                bool any = false;
                for (L3Board* b : smine_boards) any = any || b->powered();
                if (!any) { logline("mine L3+: no L3+ board powered any more, mining stops"); break; }
            }
            sminer.stop();
            ssink.stop();
            for (L3Board* b : smine_boards) b->op.unlock();
            smine_boards.clear();
            smining = false;
        });
        remember_pool("l3", url, user, pass);
        return "L3+ mining on " + url + " as " + user + (fee_sc.enabled ? " (3 % dev fee on)" : " (dev fee off)") + "\n";
    }
    // ---- L3+ chip test: one L3+ board hashes the genesis block for N s; the ARM re-checks every nonce with scrypt and
    // counts each chip's good and bad nonces; l3_verdicts() marks dead / weak / bad chips. L3+ mining must be stopped
    // (the test owns the scrypt work feeder); S9 mining can go on (the nonce router keeps the S9 nonces for it).
    struct L3Test {
        std::string state = "none";                // none, running, done, stopped
        int seconds = 0, total = 0, invalid = 0;
        double t0 = 0, t1 = 0, mhs = 0;
        std::vector<int> valid, bad;
        std::vector<std::string> verdict;
    };
    std::atomic<int> l3test_h{-1};                 // the header under test, -1 none
    std::map<int, L3Test> l3tests;
    std::mutex l3test_mu;
    std::thread l3test_thread;
    std::string l3test_cmd(std::istringstream& in) {
        std::string a, j;
        in >> a;
        if (a == "stop") {
            int h = l3test_h;
            if (h < 0) return "no chip test running\n";
            l3test_h = -1;
            if (l3test_thread.joinable()) l3test_thread.join();
            return "chip test on J" + std::to_string(h + 1) + " stopped\n";
        }
        int seconds = std::atoi(a.c_str());
        in >> j;
        int h = jnum(j);
        if (h < 0 || kind(h) != "l3p") return "failed: name an L3+ header, like: l3test 120 J6\n";
        if (seconds < 10 || seconds > 900) return "failed: a chip test is 10 to 900 seconds\n";
        L3Board* l = l3_at(h);
        if (!l || !l->powered()) return "failed: J" + std::to_string(h + 1) + " L3+ is not on\n";
        if (smining) return "busy: stop L3+ mining first (the test feeds the board its own work)\n";
        if (l3test_h >= 0) return "busy: a chip test runs on J" + std::to_string(l3test_h + 1) + "\n";
        if (l3test_thread.joinable()) l3test_thread.join();
        {
            std::lock_guard<std::mutex> g(l3test_mu);
            L3Test& t = l3tests[h];
            t = L3Test();
            t.state = "running";
            t.seconds = seconds;
            t.t0 = mono_now();
            t.valid.assign(size_t(bm85::CHIPS), 0);
            t.bad.assign(size_t(bm85::CHIPS), 0);
        }
        l3test_h = h;
        logline("J" + std::to_string(h + 1) + " L3+: chip test, " + std::to_string(seconds) +
                " s on the genesis block, every nonce re-hashed by the ARM");
        l3test_thread = std::thread([this, h, seconds] {
            Algo algo{Algo::SCRYPT};
            Job job = genesis_job();
            router.clear(true);
            ssink.load(job, true);
            double end = mono_now() + seconds;
            bool lost = false;
            while (mono_now() < end && l3test_h == h) {
                L3Board* b = l3_at(h);
                if (!b || !b->powered()) { lost = true; break; }
                ssink.tick(mono_now());
                Nonce n;
                for (int k = 0; k < 256 && router.scrypt().pop(n); k++) {
                    if (n.chain != h || uint16_t(n.tag >> 16) != job.tag) continue;
                    uint64_t en2 = uint64_t(n.tag & 0xFFFF) << 32 | n.tag2;
                    Work w = build_work(job, en2);
                    bool ok = algo.diff1(algo.hash(w.header, n.nonce));
                    int chip = algo.chip(n.nonce);
                    std::lock_guard<std::mutex> g(l3test_mu);
                    L3Test& t = l3tests[h];
                    if (chip >= 0 && chip < bm85::CHIPS) (ok ? t.valid : t.bad)[size_t(chip)]++;
                    if (ok) t.total++; else t.invalid++;
                }
                std::this_thread::sleep_for(std::chrono::milliseconds(20));
            }
            bool finished = mono_now() >= end && !lost;
            ssink.stop();
            router.clear(true);
            L3Board* b = l3_at(h);
            std::vector<bool> off(size_t(bm85::CHIPS), false);
            for (int i = 0; i < bm85::CHIPS; i++) off[size_t(i)] = b && b->chip_off(i);
            std::string summary;
            {
                std::lock_guard<std::mutex> g(l3test_mu);
                L3Test& t = l3tests[h];
                t.t1 = mono_now();
                t.verdict = l3_verdicts(t.valid, t.bad, off);
                double secs = std::max(1.0, t.t1 - t.t0);
                t.mhs = t.total * algo.hashes_per_nonce() / secs / 1e6;
                t.state = finished ? "done" : "stopped";
                std::map<std::string, std::vector<int>> by;
                for (int i = 0; i < bm85::CHIPS; i++) by[t.verdict[size_t(i)]].push_back(i);
                char r[64];
                std::snprintf(r, sizeof r, "%.0f MH/s", t.mhs);
                summary = "J" + std::to_string(h + 1) + " L3+: chip test " + t.state + " after " + std::to_string(int(secs)) +
                          " s: " + r + ", " + std::to_string(t.total) + " nonces (" + std::to_string(t.invalid) + " bad)";
                for (const char* v : {"ok", "weak", "dead", "bad", "off", "few"}) {
                    auto it = by.find(v);
                    if (it == by.end()) continue;
                    summary += ", " + std::to_string(it->second.size()) + " " + v;
                    if (std::string(v) != "ok" && std::string(v) != "few" && it->second.size() <= 8) {
                        summary += " (chip";
                        for (int i : it->second) summary += " " + std::to_string(i);
                        summary += ")";
                    }
                }
                if (by.count("few")) summary += " -- too few nonces per chip to judge, run it longer";
            }
            logline(summary);
            if (l3test_h == h) l3test_h = -1;
        });
        return "chip test started on J" + std::to_string(h + 1) + " for " + std::to_string(seconds) + " s\n";
    }

    std::string smine_stop() {
        std::lock_guard<std::mutex> one(smine_mu);
        if (!smining && !smine_thread.joinable()) return "L3+ not mining\n";
        smining = false;
        if (smine_thread.joinable()) smine_thread.join();
        return "L3+ mining stopped\n";
    }
    // kind J<n> s9|l3p|unknown: what is on a header; changed only while that header is off
    std::string kind_cmd(std::istringstream& in) {
        std::string j, k;
        in >> j >> k;
        int h = jnum(j);
        if (h < 0) return "kind J1..J9 s9|l3p|unknown\n";
        if (k == "unknown") k.clear();
        if (!k.empty() && k != "s9" && k != "l3p") return "kind J1..J9 s9|l3p|unknown\n";
        for (auto& v : views()) if (v.header == h && !v.off) return "failed: J" + std::to_string(h + 1) + " is on; power it off first\n";
        { std::lock_guard<std::mutex> g(mu); kinds[h] = k; }
        json::Value ks = json::Value::object();
        { std::lock_guard<std::mutex> g(mu); for (int i = 0; i < 9; i++) if (!kinds[i].empty()) ks.set("J" + std::to_string(i + 1), kinds[i]); }
        settings.set("kinds", ks);
        save_settings();
        logline("J" + std::to_string(h + 1) + " is " + kind_name(k));
        return "J" + std::to_string(h + 1) + " is " + kind_name(k) + "\n";
    }
    std::atomic<bool> mining{false};

    // START MINING ON ALL BOARDS (Rev, 2026-11-27): every plugged board at what it last ran at, then both miners
    void remember_power(int h, double volts, int mhz) {
        json::Value e = json::Value::object();
        e.set("volts", volts);
        e.set("mhz", mhz);
        json::Value all = settings["power"].is_object() ? settings["power"] : json::Value::object();
        all.set(fleet::jname(h), e);
        settings.set("power", all);
        save_settings();
    }
    void remember_pool(const std::string& which, const std::string& url, const std::string& user, const std::string& pass) {
        json::Value e = json::Value::object();
        e.set("pool", url);
        e.set("user", user);
        e.set("password", pass);
        settings.set(which + "_pool", e);
        save_settings();
    }
    std::string saved_pool(const std::string& which) {     // " url user pass", or "" for the built-in default
        const json::Value& e = settings[which + "_pool"];
        if (!e.is_object() || e["pool"].str().empty()) return "";
        return " " + e["pool"].str() + " " + e["user"].str() + " " + (e["password"].str().empty() ? "x" : e["password"].str());
    }
    std::vector<fleet::Plug> plugs() {
        std::vector<fleet::Plug> v;
        std::vector<int> det = hr.detect();
        for (int h = 0; h < 9; h++) {
            Board* x;
            L3Board* y;
            std::string k;
            { std::lock_guard<std::mutex> g(mu); x = boards[h].get(); y = l3[h].get(); k = kinds[h]; }
            bool off = k == "l3p" ? (!y || y->off()) : (!x || x->off());
            bool plugged = std::find(det.begin(), det.end(), h) != det.end() || !off;
            if (plugged) v.push_back({h, true, fleet::chain_on(h), k, off});
        }
        return v;
    }
    std::vector<fleet::Remembered> remembered() {
        std::vector<fleet::Remembered> m;
        const json::Value& all = settings["power"];
        for (int h = 0; h < 9; h++) {
            const json::Value& e = all[fleet::jname(h)];
            if (e.is_object() && e["mhz"].num(0) > 0) m.push_back({h, e["volts"].num(0), int(e["mhz"].num(0))});
        }
        return m;
    }
    std::atomic<bool> all_busy{false};
    std::string mine_all() {
        if (all_busy.exchange(true)) return "busy: already starting every board\n";
        fleet::StartPlan p = fleet::start_plan(plugs(), remembered());
        if (!p.sha && !p.scrypt) {
            all_busy = false;
            return p.skipped.empty() ? "no hashboard found on J6, J7 or J8\n" : "no board ready: " + p.skipped[0] + "\n";
        }
        std::string list;
        for (const fleet::PowerStep& s : p.power) list += (list.empty() ? "" : ", ") + fleet::jname(s.header);
        std::thread([this, p] {
            logline("start all: " + (p.power.empty() ? std::string("every board is on already")
                                                     : "powering on " + std::to_string(p.power.size()) + " board(s)"));
            for (const std::string& s : p.skipped) logline("start all: " + s);
            for (const fleet::PowerStep& s : p.power) {
                char v[32];
                std::snprintf(v, sizeof v, "%.2f", s.volts);
                std::string r = handle("power_on " + std::string(v) + " " + std::to_string(s.mhz) + " " + fleet::jname(s.header));
                while (!r.empty() && r.back() == '\n') r.pop_back();
                logline("start all: " + fleet::jname(s.header) + " " + r);
            }
            for (int i = 0; i < 2; i++) {
                bool sha = i == 0;
                if (sha ? (!p.sha || mining) : (!p.scrypt || smining)) continue;
                std::string r = handle(std::string(sha ? "mine_start" : "smine_start") + saved_pool(sha ? "s9" : "l3"));
                while (!r.empty() && r.back() == '\n') r.pop_back();
                logline("start all: " + r);
            }
            all_busy = false;
        }).detach();
        return "starting every board" + (list.empty() ? std::string() : ": powering on " + list) +
               ", then the miners (follow the log)\n";
    }
    // the 4 board LEDs (FPGA slot 5, orphan_larson): a breathing scanner while either miner runs, else the status
    // LEDs as before. A bitstream without slot 5 ignores the write.
    void leds_tick() { bus.wr(5, 1, (mining || smining) ? 1 : 0); }
    std::thread mine_thread;
    std::vector<Board*> mine_boards;               // their op locks are held while mining
    std::mutex mine_mu;                            // one mine_start / mine_stop at a time
    std::vector<Chain*> mining_chains() {
        std::vector<Chain*> v;
        for (Board* b : mine_boards) if (b->powered()) v.push_back(&b->chain());
        return v;
    }

    std::vector<Board*> powered_boards() {
        std::lock_guard<std::mutex> g(mu);
        std::vector<Board*> v;
        for (auto& b : boards) if (b && b->powered()) v.push_back(b.get());
        return v;
    }
    std::vector<Chain*> powered_chains() {
        std::vector<Chain*> v;
        for (Board* b : powered_boards()) v.push_back(&b->chain());
        return v;
    }

    std::string mine_start(std::istringstream& in) {
        std::lock_guard<std::mutex> one(mine_mu);
        std::string url = "stratum+tcp://americas.mining-dutch.nl:9996", user = "revjmoney.s9bench", pass = "x";
        std::string a;
        if (in >> a) url = a;
        if (in >> a) user = a;
        if (in >> a) pass = a;
        if (mining) return "already mining\n";
        if (mine_thread.joinable()) mine_thread.join();
        std::vector<Board*> pw = powered_boards();
        if (pw.empty()) return "no board powered\n";
        std::vector<Board*> locked;
        for (Board* b : pw) {
            if (!b->op.try_lock()) { for (Board* l : locked) l->op.unlock(); return "J" + std::to_string(b->header() + 1) + " busy\n"; }
            locked.push_back(b);
        }
        for (Board* b : pw)
            if (!b->open_cores(0)) {
                for (Board* l : locked) l->op.unlock();
                return "could not open the cores on J" + std::to_string(b->header() + 1) + "\n";
            }
        Nonce n;
        while (router.sha().pop(n)) {}              // leftovers from the open-core busy works (S9 chains only)
        for (Board* l : locked) l->op.unlock();     // a mutex is released by the thread that took it: the mining
        mine_boards = pw;                           // thread takes the op locks itself for as long as it mines
        router.clear(false);
        miner.start({url, user, pass});
        mining = true;
        mine_thread = std::thread([this] {
            for (Board* b : mine_boards) b->op.lock();
            while (mining) {
                miner.poll_once(20);
                bool any = false;
                for (Board* b : mine_boards) any = any || b->powered();
                if (!any) { logline("mine: no board powered any more, mining stops"); break; }
            }
            miner.stop();
            sink.stop();
            for (Board* b : mine_boards) b->op.unlock();
            mine_boards.clear();
            mining = false;
        });
        remember_pool("s9", url, user, pass);
        return "mining on " + url + " as " + user + (fee.enabled ? " (3 % dev fee on)" : " (dev fee off)") + "\n";
    }

    std::string mine_stop() {
        std::lock_guard<std::mutex> one(mine_mu);
        if (!mining && !mine_thread.joinable()) return "not mining\n";
        mining = false;
        if (mine_thread.joinable()) mine_thread.join();
        return "mining stopped\n";
    }

    std::string mine_status() {
        MineStats s = miner.stats();
        char t[512];
        std::snprintf(t, sizeof t, "%s%s %s as %s: %.1f GH/s, valid %llu, invalid %llu, stale %llu, dupes %llu, "
                      "shares %llu sent, %llu accepted, %llu rejected, difficulty %g, jobs %llu, dev fee %s\n",
                      s.state.c_str(), s.dev_slice ? " (DEV FEE SLICE)" : "", s.pool.c_str(), s.user.c_str(), s.ghs,
                      (unsigned long long)s.valid, (unsigned long long)s.invalid, (unsigned long long)s.stale,
                      (unsigned long long)s.dupes, (unsigned long long)s.submitted, (unsigned long long)s.accepted,
                      (unsigned long long)s.rejected, s.difficulty, (unsigned long long)s.jobs, s.devfee ? "on" : "off");
        std::string o = t;
        for (auto& b : s.boards) {
            std::snprintf(t, sizeof t, "  J%d: %.1f GH/s, valid %llu, invalid %llu\n", b.first + 1, b.second.ghs,
                          (unsigned long long)b.second.valid, (unsigned long long)b.second.invalid);
            o += t;
        }
        if (!s.last_event.empty()) o += "  last: " + s.last_event + "\n";
        return o;
    }

    // ---- network in and out (the board's Ethernet, from /proc/net/dev), rates over the time between two reads
    std::mutex net_mu;
    double net_t = 0;
    unsigned long long net_rx = 0, net_tx = 0;
    json::Value net_rates() {
        std::ifstream f("/proc/net/dev");
        std::string line, ifname;
        unsigned long long rx = 0, tx = 0;
        while (std::getline(f, line)) {
            size_t c = line.find(':');
            if (c == std::string::npos) continue;
            std::string name = line.substr(0, c);
            name.erase(0, name.find_first_not_of(' '));
            if (name == "lo") continue;
            std::istringstream ss(line.substr(c + 1));
            unsigned long long v[9] = {0};
            for (auto& x : v) ss >> x;
            if (v[0] + v[8] > rx + tx) { rx = v[0]; tx = v[8]; ifname = name; }   // the busiest interface
        }
        std::lock_guard<std::mutex> g(net_mu);
        double t = std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count();
        json::Value o = json::Value::object();
        o.set("iface", ifname);
        o.set("rx_total", double(rx));
        o.set("tx_total", double(tx));
        double dt = t - net_t;
        o.set("rx_kbs", net_t > 0 && dt > 0 && rx >= net_rx ? double(rx - net_rx) / dt / 1000.0 : 0.0);
        o.set("tx_kbs", net_t > 0 && dt > 0 && tx >= net_tx ? double(tx - net_tx) / dt / 1000.0 : 0.0);
        if (dt > 0.5 || net_t == 0) { net_t = t; net_rx = rx; net_tx = tx; }
        return o;
    }

    // ---- the page (port 8000): GET /api/state?since=N&board=J6, POST /api/action {"op": ..., "board": "J6", ...}
    static json::Value num_or_null(double v, double none = -1) { return v == none ? json::Value() : json::Value(v); }

    std::string state_json(const std::string& query) {
        long since = std::atol(query_value(query, "since").c_str());
        int want = jnum(query_value(query, "board"));
        Board* b = nullptr;
        {
            std::lock_guard<std::mutex> g(mu);
            if (want >= 0) b = boards[want].get();
        }
        if (!b) {
            auto v = views();
            for (auto& x : v) if (!x.off) { std::lock_guard<std::mutex> g(mu); b = boards[x.header].get(); break; }
        }
        if (!b) b = current();
        MineStats ms = miner.stats();
        json::Value s = json::Value::object();
        json::Value bd = json::Value::object();
        bool on = b && b->powered();
        bd.set("header", b ? json::Value("J" + std::to_string(b->header() + 1)) : json::Value());
        bd.set("power", b ? b->power_name() : std::string("off"));
        bd.set("pic_version", b ? num_or_null(b->pic_version()) : json::Value());
        bd.set("volts_set", b ? num_or_null(b->volts_set()) : json::Value());
        bd.set("volts_read", b ? num_or_null(b->volts_read()) : json::Value());
        bd.set("pcb_c", b ? num_or_null(b->pcb_c()) : json::Value());
        bd.set("chip_c", b ? num_or_null(b->chip_c()) : json::Value());
        bd.set("chips_answering", b ? b->chips() : 0);
        bd.set("mhz", b ? b->mhz() : 0);
        json::Value pt = json::Value::array(), ct = json::Value::array();   // every sensor (an S9 board has two)
        if (b) for (int t : b->pcb_temps()) pt.push(num_or_null(t));
        if (b) for (int t : b->chip_temps()) ct.push(num_or_null(t));
        bd.set("pcb_temps", pt);
        bd.set("chip_temps", ct);
        bd.set("last_off", b ? b->last_off() : std::string());
        s.set("board", bd);
        const BoardMine* bm_ = nullptr;
        if (b && ms.boards.count(b->header())) bm_ = &ms.boards.at(b->header());
        json::Value chips = json::Value::array();
        for (int i = 0; i < bm::CHIPS; i++) {
            json::Value c = json::Value::object();
            c.set("i", i);
            c.set("addr", bm::chip_addr(i));
            c.set("row", i / 3);
            int m = b ? b->chip_mhz(i) : 0;
            c.set("mhz", m > 0 && on ? json::Value(m) : json::Value());
            std::string st = !on ? "unknown" : b->chip_off(i) ? "off" : i < b->chips() ? "answering" : "missing";
            c.set("state", st);
            c.set("nonces", bm_ ? double(bm_->per_chip[size_t(i)]) : 0.0);
            chips.push(c);
        }
        s.set("chips", chips);
        json::Value rows = json::Value::array();
        for (int r = 0; r < bm::ROWS; r++) {
            json::Value row = json::Value::object();
            row.set("row", r);
            json::Value cs = json::Value::array();
            double sum = 0;
            int n = 0;
            for (int k = 0; k < 3; k++) {
                cs.push(3 * r + k);
                if (b && on && b->chip_mhz(3 * r + k) > 0) { sum += b->chip_mhz(3 * r + k); n++; }
            }
            row.set("chips", cs);
            row.set("mean_mhz", n ? json::Value(sum / n) : json::Value());
            rows.push(row);
        }
        s.set("rows", rows);
        json::Value tab = json::Value::array();
        for (int m : bm::mhz_table()) tab.push(m);
        s.set("mhz_table", tab);
        s.set("timer_left_s", on && Board::ptimer.on ? json::Value(b->timer_left()) : json::Value());
        s.set("timer_on", Board::ptimer.on.load());
        s.set("timer_min", Board::ptimer.seconds / 60);
        s.set("busy", b && (b->power_name() == "starting" || b->power_name() == "stopping"));
        json::Value all = json::Value::array();
        std::vector<int> det = hr.detect();
        for (int h = 0; h < 9; h++) {
            Board* x;
            { std::lock_guard<std::mutex> g(mu); x = boards[h].get(); }
            L3Board* y;
            std::string k;
            { std::lock_guard<std::mutex> g(mu); y = l3[h].get(); k = kinds[h]; }
            bool plugged = std::find(det.begin(), det.end(), h) != det.end() || (x && !x->off()) || (y && !y->off());   // a powered board drives its pins, detection cannot see it
            if (!x && !y && !plugged) continue;
            json::Value e = json::Value::object();
            e.set("header", "J" + std::to_string(h + 1));
            e.set("chain", fleet::chain_on(h));
            e.set("plugged", plugged);
            e.set("kind", k);
            e.set("power", k == "l3p" ? (y ? y->power_name() : std::string("off")) : (x ? x->power_name() : std::string("off")));
            bool l3k = k == "l3p";                 // this header's own numbers, for the page's overview cards
            bool pw = l3k ? (y && y->powered()) : (x && x->powered());
            e.set("chips", pw ? (l3k ? y->chips() : x->chips()) : 0);
            e.set("mhz", pw ? (l3k ? y->mhz() : x->mhz()) : 0);
            e.set("pcb_c", pw ? num_or_null(l3k ? y->pcb_c() : x->pcb_c()) : json::Value());
            e.set("chip_c", pw ? num_or_null(l3k ? y->chip_c() : x->chip_c()) : json::Value());
            all.push(e);
        }
        s.set("boards", all);
        json::Value l3s = json::Value::array();
        MineStats sm_all = sminer.stats();         // per-chip nonce counts of the L3+ miner
        for (int h = 0; h < 9; h++) {
            L3Board* y = l3_at(h);
            if (!y || kind(h) != "l3p") continue;
            json::Value e = json::Value::object();
            e.set("header", "J" + std::to_string(h + 1));
            e.set("power", y->power_name());
            e.set("chips", y->chips());
            e.set("mhz", y->mhz());
            e.set("pcb_c", num_or_null(y->pcb_c()));
            e.set("chip_c", num_or_null(y->chip_c()));
            e.set("timer_left_s", y->powered() && Board::ptimer.on ? json::Value(y->timer_left()) : json::Value());
            e.set("last_off", y->last_off());
            json::Value cm = json::Value::array(), co = json::Value::array(), nn = json::Value::array();
            auto bit = sm_all.boards.find(h);
            for (int i = 0; i < bm85::CHIPS; i++) {
                cm.push(y->chip_mhz(i));
                co.push(y->chip_off(i));
                nn.push(bit != sm_all.boards.end() && size_t(i) < bit->second.per_chip.size() ? double(bit->second.per_chip[size_t(i)]) : 0.0);
            }
            e.set("cmhz", cm);
            e.set("coff", co);
            e.set("nonces", nn);                   // valid nonces per chip since L3+ mining started
            {
                std::lock_guard<std::mutex> g(l3test_mu);
                auto ti = l3tests.find(h);
                if (ti != l3tests.end()) {
                    const L3Test& t = ti->second;
                    json::Value tj = json::Value::object(), tv = json::Value::array(), tb = json::Value::array(), td = json::Value::array();
                    tj.set("state", t.state);
                    tj.set("seconds", t.seconds);
                    tj.set("left_s", t.state == "running" ? std::max(0, int(t.t0 + t.seconds - mono_now())) : 0);
                    tj.set("total", t.total);
                    tj.set("invalid", t.invalid);
                    tj.set("mhs", t.state == "running" ? t.total * 65536.0 * 256.0 / std::max(1.0, mono_now() - t.t0) / 1e6 : t.mhs);
                    for (size_t i = 0; i < t.valid.size(); i++) { tv.push(t.valid[i]); tb.push(t.bad[i]); }
                    for (auto& v : t.verdict) td.push(v);
                    tj.set("valid", tv);
                    tj.set("bad", tb);
                    tj.set("verdict", td);
                    e.set("test", tj);
                }
            }
            l3s.push(e);
        }
        s.set("l3", l3s);
        {
            MineStats sm = sminer.stats();
            json::Value o = json::Value::object();
            o.set("state", sm.state);
            o.set("pool", sm.pool);
            o.set("user", sm.user);
            o.set("mhs", sm.ghs * 1000.0);
            o.set("valid", double(sm.valid));
            o.set("invalid", double(sm.invalid));
            o.set("accepted", double(sm.accepted));
            o.set("rejected", double(sm.rejected));
            o.set("difficulty", sm.difficulty);
            o.set("dev_slice", sm.dev_slice);
            o.set("last", sm.last_event);
            s.set("smine", o);
        }
        json::Value mine = json::Value::object();
        mine.set("state", ms.state);
        mine.set("pool", ms.pool);
        mine.set("user", ms.user);
        mine.set("dev_slice", ms.dev_slice);
        mine.set("plan", ms.plan);
        mine.set("leg", ms.leg);
        mine.set("leg_left_s", ms.leg_left_s);
        mine.set("leg_min", ms.leg_min);
        mine.set("solo_pool", ms.solo_pool);
        mine.set("solo_user", ms.solo_user);
        mine.set("devfee", ms.devfee);
        mine.set("ghs", ms.ghs);
        mine.set("difficulty", ms.difficulty);
        for (auto& kv : std::vector<std::pair<const char*, uint64_t>>{{"valid", ms.valid}, {"invalid", ms.invalid},
                 {"stale", ms.stale}, {"dupes", ms.dupes}, {"accepted", ms.accepted}, {"rejected", ms.rejected},
                 {"submitted", ms.submitted}, {"jobs", ms.jobs}})
            mine.set(kv.first, double(kv.second));
        mine.set("last_event", ms.last_event);
        mine.set("net_diff", ms.net_diff);
        mine.set("best_share", ms.best_share);
        mine.set("height", ms.height < 0 ? json::Value() : json::Value(double(ms.height)));
        mine.set("connected_s", ms.connected_s < 0 ? json::Value() : json::Value(ms.connected_s));
        mine.set("last_share_s", ms.last_share_s < 0 ? json::Value() : json::Value(ms.last_share_s));
        mine.set("slice_left_s", ms.slice_left_s);
        json::Value pb = json::Value::array();
        for (auto& kv : ms.boards) {
            json::Value e = json::Value::object();
            e.set("header", "J" + std::to_string(kv.first + 1));
            e.set("ghs", kv.second.ghs);
            e.set("valid", double(kv.second.valid));
            e.set("invalid", double(kv.second.invalid));
            pb.push(e);
        }
        mine.set("boards", pb);
        s.set("mine", mine);
        json::Value fanv = json::Value::object();
        fanv.set("applied", fan.applied());
        fanv.set("watchdog", fan.watchdog());
        fanv.set("mode", fan.auto_curve() ? "curve" : "manual");
        fanv.set("duty", fan.duty_set());
        fanv.set("lo", fan.curve_lo());
        fanv.set("hi", fan.curve_hi());
        json::Value rpm = json::Value::array();
        for (int i = 0; i < 6; i++) rpm.push(fan.rpm(i));   // all six fan headers' tach (rpm = edges/s x 30)
        fanv.set("rpm", rpm);
        s.set("fan", fanv);
        s.set("net", net_rates());
        json::Value lg = json::Value::array();
        {
            std::lock_guard<std::mutex> g(log_mu);
            for (auto& e : page_log) {
                if (e.seq <= since) continue;
                json::Value x = json::Value::object();
                x.set("seq", double(e.seq));
                x.set("t", e.t);
                x.set("level", e.level);
                x.set("msg", e.msg);
                lg.push(x);
            }
        }
        s.set("log", lg);
        return json::dump(s);
    }

    // an action from the page becomes the same command line the socket takes
    std::string action_json(const std::string& body) {
        json::Value a;
        json::Value out = json::Value::object();
        if (!json::parse(body, a) || !a["op"].is_string()) {
            out.set("ok", false);
            out.set("why", "bad request");
            return json::dump(out);
        }
        const std::string op = a["op"].str();
        std::string J = a["board"].is_string() ? " " + a["board"].str() : "";
        char v[32];
        std::snprintf(v, sizeof v, "%.2f", a["volts"].num(Pic::V_START));
        std::string volts = v, cmd;
        auto num = [&](const char* k, double d) { return std::to_string(long(a[k].num(d))); };
        if (op == "scan" || op == "renew" || op == "mine_stop" || op == "mine_all") cmd = op;
        else if (op == "pic_info" || op == "kat" || op == "skot") cmd = op + J;
        else if (op == "power_on") cmd = "power_on " + volts + " " + num("mhz", 400) + J;
        else if (op == "power_off") cmd = "power_off" + J;
        else if (op == "hold") cmd = "hold " + volts + " " + num("seconds", 120) + J;
        else if (op == "diag" || op == "rstprobe") cmd = op + " " + volts + J;
        else if (op == "patterns") cmd = "patterns " + num("count", 8) + J;
        else if (op == "set_volts") cmd = "set_volts " + volts + J;
        else if (op == "set_all") cmd = "set_all " + num("mhz", 400) + J;
        else if (op == "set_chip" || op == "set_row") {
            std::string what = a["off"].boolean() ? "off" : num("mhz", 400);
            cmd = op + " " + num(op == "set_chip" ? "chip" : "row", -1) + " " + what + J;
        } else if (op == "kind") {
            std::string k = a["kind"].str();
            if (k.find_first_of(" \t\r\n") != std::string::npos || J.empty()) { out.set("ok", false); out.set("why", "board and kind"); return json::dump(out); }
            cmd = "kind" + J + " " + (k.empty() ? "unknown" : k);
        } else if (op == "smine_start") {
            std::string url = a["pool"].str(), user = a["user"].str(), pass = a["password"].str();
            for (const std::string* f : {&url, &user, &pass})
                if (f->find_first_of(" \t\r\n") != std::string::npos) { out.set("ok", false); out.set("why", "pool, user and password may not contain spaces"); return json::dump(out); }
            cmd = "smine_start";
            if (!url.empty()) cmd += " " + url + " " + (user.empty() ? "revjmoney.l3hashr" : user) + " " + (pass.empty() ? "x" : pass);
        } else if (op == "l3test") {
            cmd = "l3test " + num("seconds", 120) + J;
        } else if (op == "l3test_stop") {
            cmd = "l3test stop";
        } else if (op == "smine_stop") {
            cmd = "smine_stop";
        } else if (op == "timer") {
            cmd = std::string("timer ") + (a["on"].boolean() ? "on " : "off ") + num("minutes", 10);
        } else if (op == "fan") {
            if (a["mode"].str() == "manual") cmd = "fan manual " + num("pct", 50);
            else cmd = "fan curve " + num("lo", 30) + " " + num("hi", 60);
        } else if (op == "plan") {
            std::string m = a["mode"].str(), url = a["solo_pool"].str(), user = a["solo_user"].str(), pass = a["solo_password"].str();
            for (const std::string* f : {&m, &url, &user, &pass})
                if (f->find_first_of(" \t\r\n") != std::string::npos) {
                    out.set("ok", false);
                    out.set("why", "solo pool, user and password may not contain spaces");
                    return json::dump(out);
                }
            cmd = "plan " + m + " " + num("minutes", 60);
            if (!url.empty()) cmd += " " + url + " " + user + " " + (pass.empty() ? "x" : pass);
        } else if (op == "devfee") cmd = std::string("devfee ") + (a["on"].boolean() ? "on" : "off");
        else if (op == "mine_start") {
            std::string url = a["pool"].str(), user = a["user"].str(), pass = a["password"].str();
            if (url.empty()) url = "stratum+tcp://americas.mining-dutch.nl:9996";
            if (user.empty()) user = "revjmoney.s9bench";
            if (pass.empty()) pass = "x";
            for (const std::string* f : {&url, &user, &pass})
                if (f->find_first_of(" \t\r\n") != std::string::npos) {
                    out.set("ok", false);
                    out.set("why", "pool, user and password may not contain spaces");
                    return json::dump(out);
                }
            cmd = "mine_start " + url + " " + user + " " + pass;
        } else {
            out.set("ok", false);
            out.set("why", "unknown action " + op);
            return json::dump(out);
        }
        std::string t = handle(cmd);
        while (!t.empty() && t.back() == '\n') t.pop_back();
        bool ok = true;
        for (const char* bad : {"failed", "no ", "busy", "several", "could not", "header J", "already", "not mining",
                                "unknown", "pool, user", "HOLD failed", "DIAG failed", "RSTPROBE failed", "KAT: ", "SKOT: "})
            if (t.rfind(bad, 0) == 0) ok = false;
        if (t.find(" is not off") != std::string::npos || t.find(" has no chain") != std::string::npos ||
            t.find(" has no board") != std::string::npos || t.find(" busy") != std::string::npos) ok = false;
        out.set("ok", ok);
        out.set(ok ? "msg" : "why", t);
        if (op == "power_on" && ok) {
            Board* b = current();
            if (b) out.set("chips", b->chips());
        }
        return json::dump(out);
    }

    // the CYD live screen's view of things: the board the page would show, the miner, the J pins, the log tail
    CydState cyd_state() {
        CydState s;
        Board* b = nullptr;
        L3Board* l = nullptr;
        {
            std::lock_guard<std::mutex> g(mu);
            for (int h = 0; h < 9; h++) {
                if (!b && boards[h] && !boards[h]->off()) b = boards[h].get();
                if (!l && l3[h] && !l3[h]->off()) l = l3[h].get();
            }
        }
        // an L3+ board on its own, or every other 5 s when an S9 board runs too
        if (l && (!b || int(mono_now() / 5) % 2)) {
            MineStats ms = sminer.stats();
            int h = l->header();
            s.l3 = true;
            s.power = l->power_name();
            s.header = "J" + std::to_string(h + 1) + " L3+";
            s.chips = l->chips();
            s.chips_total = bm85::CHIPS;
            s.timer_left = l->powered() ? l->timer_left() : -1;
            s.pcb = l->pcb_c();
            s.chip = l->chip_c();
            s.chip_state.assign(size_t(bm85::CHIPS), "unknown");
            for (int i = 0; i < bm85::CHIPS; i++)
                s.chip_state[size_t(i)] = !l->powered() ? "unknown" : i < l->chips() ? "answering" : "missing";
            std::vector<int> p = hr.pins();
            for (int k = 0; k < 4; k++) s.pins[k] = p[size_t(4 * h + k)];
            std::ifstream en("/sys/class/gpio/gpio" + std::to_string(28 + h) + "/value");
            if (!(en >> s.en)) s.en = -1;
            s.go = int(bus.rd(Hashr::SLOT, 0) & 1);
            s.mining = ms.state != "stopped";
            s.ghs = ms.ghs;
            s.valid = ms.valid;
            s.invalid = ms.invalid;
            s.accepted = ms.accepted;
            s.submitted = ms.submitted;
            std::lock_guard<std::mutex> g(log_mu);
            size_t from = page_log.size() > 20 ? page_log.size() - 20 : 0;   // STATS lines are left out (too long for the CYD)
            for (size_t i = from; i < page_log.size(); i++) if (page_log[i].level != "stats") s.log.emplace_back(page_log[i].level, page_log[i].msg);
            return s;
        }
        if (!b) b = current();
        MineStats ms = miner.stats();
        if (b) {
            s.power = b->power_name();
            s.header = "J" + std::to_string(b->header() + 1);
            s.chips = b->chips();
            s.timer_left = b->powered() ? b->timer_left() : -1;
            s.volts_read = b->volts_read();
            s.pcb = b->pcb_c();
            s.chip = b->chip_c();
            for (int i = 0; i < bm::CHIPS; i++)
                s.chip_state[size_t(i)] = !b->powered() ? "unknown" : b->chip_off(i) ? "off" : i < b->chips() ? "answering" : "missing";
            std::vector<int> p = hr.pins();
            int h = b->header();
            for (int k = 0; k < 4; k++) s.pins[k] = p[size_t(4 * h + k)];
            std::ifstream en("/sys/class/gpio/gpio" + std::to_string(28 + h) + "/value");
            if (!(en >> s.en)) s.en = -1;
            s.go = int(bus.rd(Hashr::SLOT, 0) & 1);
        }
        s.mining = ms.state != "stopped";
        s.ghs = ms.ghs;
        s.valid = ms.valid;
        s.invalid = ms.invalid;
        s.accepted = ms.accepted;
        s.submitted = ms.submitted;
        std::lock_guard<std::mutex> g(log_mu);
        size_t from = page_log.size() > 20 ? page_log.size() - 20 : 0;   // STATS lines are left out (too long for the CYD)
        for (size_t i = from; i < page_log.size(); i++) if (page_log[i].level != "stats") s.log.emplace_back(page_log[i].level, page_log[i].msg);
        return s;
    }

    std::string page() {
        for (const char* p : {"../index.html", "index.html"}) {
            std::ifstream f(p, std::ios::binary);
            if (f) { std::stringstream ss; ss << f.rdbuf(); return ss.str(); }
        }
        return "<p>index.html not found next to hashrd</p>";
    }

    std::string handle(const std::string& line) {
        std::istringstream in(line);
        std::string c;
        in >> c;
        if (c == "status") {                       // every board hashrd knows, the current one first
            std::ostringstream o;
            std::vector<Board*> all;
            Board* cur = current();
            if (cur) all.push_back(cur);
            {
                std::lock_guard<std::mutex> g(mu);
                for (auto& b : boards) if (b && b.get() != cur) all.push_back(b.get());
            }
            if (all.empty()) o << "no board\n";
            for (size_t k = 0; k < all.size(); k++)
                o << "J" << all[k]->header() + 1 << " " << all[k]->state_text() << "\n";
            o << "fan applied " << fan.applied() << " % watchdog " << (fan.watchdog() ? "FIRED" : "ok") << "\n";
            for (Board* board : all) {
                if (board->off() && board != cur) continue;
                ChainStat s = board->chain().stat();
                o << "J" << board->header() + 1 << " chain sent " << s.sent << " nonces " << s.nonces << " frames "
                  << s.frames << " crc_err " << s.crc_err << " rx_ovf " << s.rx_ovf << " works " << s.works << "\n";
                if (!board->last_off().empty()) o << "J" << board->header() + 1 << " last off: " << board->last_off() << "\n";
            }
            std::lock_guard<std::mutex> l(log_mu);
            for (auto& r : recent) o << "  " << r << "\n";
            return o.str();
        }
        if (c == "detect") {
            std::string s;
            for (int h : hr.detect()) s += " J" + std::to_string(h + 1);
            return "boards:" + (s.empty() ? std::string(" none") : s) + "\n";
        }
        if (c == "power_on") {                     // power_on [volts] [mhz] [J]: each board needs its own command
            double volts = Pic::V_START;
            int mhz = 400, h = -1;
            in >> volts >> mhz;
            std::string j;
            if (in >> j) h = jnum(j);
            if (h < 0) {                           // no J: the first plugged board that has a chain
                for (int d : hr.detect()) if (fleet::chain_on(d)) { h = d; break; }
                if (h < 0) return "no hashboard found on J6, J7 or J8\n";
            }
            if (h < 0 || h > 8) return "header J1..J9\n";
            std::string why, k = kind(h);
            if (k.empty()) return "J" + std::to_string(h + 1) + ": pick the board type (S9 or L3+) first\n";
            if (!fleet::may_power_on(views(), h, why)) return why + "\n";
            if (k == "l3p") {                      // L3+: no voltage (stock never sets one), the clock from the L3+ table
                L3Board* l;
                { std::lock_guard<std::mutex> g(mu); l = make_l3(h); }
                std::unique_lock<std::mutex> op(l->op, std::try_to_lock);
                if (!op.owns_lock()) return "busy\n";
                if (!l->power_on(mhz, why)) return "failed: " + why + "\n";
                remember_power(h, 0, mhz);
                return "on: " + l->state_text() + "\n";
            }
            Board* b;
            {
                std::lock_guard<std::mutex> g(mu);
                b = make_board(h);
                active = h;
            }
            std::unique_lock<std::mutex> op(b->op, std::try_to_lock);
            if (!op.owns_lock()) return "busy\n";
            if (!b->power_on(volts, mhz, why)) return "failed: " + why + "\n";
            remember_power(h, volts, mhz);
            return "on: " + b->state_text() + "\n";
        }
        if (c == "power_off") {                    // power_off [J]: no J = every board
            std::string j;
            int want = (in >> j) ? jnum(j) : -1;
            std::vector<Board*> t;
            {
                std::lock_guard<std::mutex> g(mu);
                for (int i = 0; i < 9; i++) if (boards[i] && (want < 0 || want == i)) t.push_back(boards[i].get());
            }
            std::vector<L3Board*> t3;
            {
                std::lock_guard<std::mutex> g(mu);
                for (int i = 0; i < 9; i++) if (l3[i] && (want < 0 || want == i)) t3.push_back(l3[i].get());
            }
            for (Board* b : t) b->power_off("POWER OFF command");   // outside mu: power_off asks views()
            for (L3Board* b : t3) b->power_off("POWER OFF command");
            return "off\n";
        }
        if (c == "renew") {
            for (Board* b : powered_boards()) b->renew();
            for (L3Board* b : powered_l3()) b->renew();
            return "renewed\n";
        }
        if ((c == "patterns" || c == "builder_test" || c == "kat" || c == "skot" || c == "hold" || c == "diag" ||
             c == "rstprobe") && smining)          // these read the shared nonce FIFO themselves
            return "busy: the L3+ boards are mining\n";
        if (c == "patterns") {
            int count = 8;
            in >> count;
            std::string why;
            Board* board = chosen(in, why);
            if (!board) return why + "\n";
            if (!board->powered()) return "no board powered\n";
            std::unique_lock<std::mutex> op(board->op, std::try_to_lock);
            if (!op.owns_lock()) return "busy\n";
            if (count < 1) count = 1;
            if (count > 912) count = 912;
            PatternResult r = run_patterns(*board, bus, count);
            logline(pattern_report(r).substr(0, 160));
            return pattern_report(r) + "\n";
        }
        if (c == "builder_test") {
            int seconds = 30;
            in >> seconds;
            std::string why;
            Board* board = chosen(in, why);
            if (!board) return why + "\n";
            if (!board->powered()) return "no board powered\n";
            std::unique_lock<std::mutex> op(board->op, std::try_to_lock);
            if (!op.owns_lock()) return "busy\n";
            if (seconds < 1) seconds = 1;
            if (seconds > 600) seconds = 600;
            MineResult r = run_builder_test(*board, bus, seconds);
            logline(mine_report(r).substr(0, 160));
            return mine_report(r) + "\n";
        }
        if (c == "scan") return handle("detect");
        if (c == "pic_info") {                     // pic_info [J]: read only (version, board id, sensor table)
            std::string j;
            int want = (in >> j) ? jnum(j) : -1;
            Board* b = nullptr;
            if (want < 0) {                        // no J: the board last used, else the first one plugged in
                b = current();
                if (!b) {
                    auto d = hr.detect();
                    if (d.empty()) return "no hashboard found\n";
                    want = d[0];
                }
            }
            if (!b) {                              // the header asked for (an L3+ header too: the PIC is the same)
                L3Board* l = l3_at(want);          // a running L3+ talks to its PIC itself: no second reader
                if (l && !l->off()) return "J" + std::to_string(want + 1) + " L3+ is on: pic_info only while it is off\n";
                std::lock_guard<std::mutex> g(mu);
                b = make_board(want);              // (before, an L3+ or not-yet-used J fell back to the first header)
                if (active < 0) active = want;
            }
            std::string t;
            bool ok = b->pic_info(t);
            return (ok ? "" : "failed: ") + t + "\n";
        }
        if (c == "set_volts") {
            double v = 0;
            in >> v;
            std::string why;
            Board* b = chosen(in, why);
            if (!b || !b->set_volts(v, why)) return "failed: " + why + "\n";
            return "voltage set\n";
        }
        if (c == "set_chip" || c == "set_row" || c == "set_all") {
            std::vector<int> chips;                // set_chip i mhz|off [J], set_row r mhz|off [J], set_all mhz [J]
            std::string m;
            int n = -1;
            if (c != "set_all") in >> n;
            in >> m;
            std::string jtok;
            in >> jtok;
            int jh = jtok.empty() ? -1 : jnum(jtok);
            if (jh >= 0 && kind(jh) == "l3p") {    // an L3+ board: 72 chips, rows of 3, 100..650 MHz
                L3Board* l = l3_at(jh);
                if (!l || !l->powered()) return "failed: J" + std::to_string(jh + 1) + " L3+ is not on\n";
                if (l3test_h == jh) return "busy: the chip test runs on J" + std::to_string(jh + 1) + "\n";
                bool off = m == "off";
                int mhz = off ? 0 : std::atoi(m.c_str());
                if (!off && (mhz < 100 || mhz > 650)) return "failed: clock 100 to 650 MHz, or off\n";
                std::vector<int> chips;
                if (c == "set_chip") chips.push_back(n);
                else if (c == "set_row") for (int k = 0; k < 3; k++) chips.push_back(3 * n + k);
                else for (int i = 0; i < l->chips(); i++) if (!l->chip_off(i)) chips.push_back(i);
                std::string why;
                if (!l->set_chips(chips, mhz, off, why)) return "failed: " + why + "\n";
                ssink.kick();                      // the chips start on a fresh work now, not in up to 19 s
                return "clock set\n";
            }
            std::istringstream rest(jtok);
            std::string cwhy;
            Board* b = chosen(rest, cwhy);
            if (!b) return "failed: " + cwhy + "\n";
            bool off = m == "off";
            int mhz = off ? 0 : std::atoi(m.c_str());
            if (c == "set_chip") chips.push_back(n);
            else if (c == "set_row") for (int k = 0; k < 3; k++) chips.push_back(3 * n + k);
            else for (int i = 0; i < b->chips(); i++) if (!b->chip_off(i)) chips.push_back(i);
            if (!off && (mhz < 200 || mhz > 650)) return "failed: clock 200 to 650 MHz, or off\n";
            std::string why;
            return b->set_chips(chips, mhz, off, why) ? "clock set\n" : "failed: " + why + "\n";
        }
        if (c == "hold" || c == "diag" || c == "rstprobe") {   // each powers an off board itself: Rev present
            double volts = Pic::V_START;
            int seconds = 120, h = -1;
            in >> volts;
            if (c == "hold") in >> seconds;
            std::string j, why;
            if (in >> j) h = jnum(j);
            if (h < 0) for (int d : hr.detect()) if (fleet::chain_on(d)) { h = d; break; }
            if (h < 0) return "no hashboard found on J6, J7 or J8\n";
            if (kind(h) != "s9") return "J" + std::to_string(h + 1) + " is " + kind_name(kind(h)) + ": HOLD, DIAG and RSTPROBE are S9 tests\n";
            if (!fleet::may_power_on(views(), h, why)) return why + "\n";
            Board* b;
            {
                std::lock_guard<std::mutex> g(mu);
                b = make_board(h);
                active = h;
            }
            std::unique_lock<std::mutex> op(b->op, std::try_to_lock);
            if (!op.owns_lock()) return "busy\n";
            if (c == "hold") return b->run_hold(volts, seconds) + "\n";
            return c == "diag" ? b->run_diag(volts) : b->run_rstprobe(volts);
        }
        if (c == "kat" || c == "skot") {
            std::string why;
            Board* b = chosen(in, why);
            if (!b) return why + "\n";
            if (!b->powered()) return "no board powered\n";
            std::unique_lock<std::mutex> op(b->op, std::try_to_lock);
            if (!op.owns_lock()) return "busy\n";
            return c == "kat" ? b->run_kat(bus) : b->run_skot(bus);
        }
        if (c == "mine_start") return mine_start(in);
        if (c == "mine_stop") return mine_stop();
        if (c == "mine_status") return mine_status();
        if (c == "devfee") {
            std::string v;
            in >> v;
            if (v == "on" || v == "off") {         // both miners (S9 SHA-256 and L3+ scrypt), kept across restarts
                fee.enabled = fee_sc.enabled = v == "on";
                settings.set("devfee", fee.enabled);
                save_settings();
            }
            return std::string("dev fee ") + (fee.enabled ? "on (3 %, thank you)" : "off") + "\n";
        }
        if (c == "timer") return timer_cmd(in);
        if (c == "kind") return kind_cmd(in);
        if (c == "smine_start") return smine_start(in);
        if (c == "mine_all") return mine_all();
        if (c == "smine_stop") return smine_stop();
        if (c == "l3test") return l3test_cmd(in);
        if (c == "fan") return fan_cmd(in);
        if (c == "plan") return plan_cmd(in);
        return "commands: status detect power_on [volts] [mhz] [J] power_off renew patterns [n] builder_test [s] "
               "mine_start [pool] [user] [pass] mine_stop mine_status devfee on|off pic_info set_volts set_chip "
               "set_row set_all hold diag rstprobe kat skot fan plan timer kind smine_start smine_stop ...\n";
    }

    void serve() {
        unlink(SOCK);
        int s = socket(AF_UNIX, SOCK_STREAM, 0);
        sockaddr_un a{};
        a.sun_family = AF_UNIX;
        std::strncpy(a.sun_path, SOCK, sizeof a.sun_path - 1);
        if (bind(s, reinterpret_cast<sockaddr*>(&a), sizeof a) != 0 || listen(s, 8) != 0) {
            logline("cannot open " + std::string(SOCK));
            return;
        }
        for (;;) {
            int fd = accept(s, nullptr, nullptr);
            if (fd < 0) continue;
            std::thread([this, fd]() {
                std::string line;
                char ch;
                while (read(fd, &ch, 1) == 1 && ch != '\n') line += ch;
                std::string out;
                try { out = handle(line); } catch (const std::exception& e) { out = std::string("error: ") + e.what() + "\n"; }
                if (write(fd, out.data(), out.size()) < 0) {}
                close(fd);
            }).detach();
        }
    }
};
}

int main(int argc, char** argv) {
    if (argc > 1) return client(argc, argv);
    sigset_t stop_sigs;                            // SIGTERM (ardzy stop, reboot) and SIGINT: every thread blocks them,
    sigemptyset(&stop_sigs);                       // one thread waits for them and shuts down cleanly
    sigaddset(&stop_sigs, SIGTERM);
    sigaddset(&stop_sigs, SIGINT);
    pthread_sigmask(SIG_BLOCK, &stop_sigs, nullptr);
    try {
        static Daemon d;
        std::thread([stop_sigs] {
            int sig = 0;
            sigwait(&stop_sigs, &sig);
            logline(std::string("stopping on ") + (sig == SIGTERM ? "SIGTERM" : "SIGINT") +
                    ": mining stops (the dev fee ledger is written), every board powers off");
            d.mine_stop();
            d.smine_stop();
            for (int i = 0; i < 9; i++) {
                Board* b;
                L3Board* l;
                { std::lock_guard<std::mutex> g(d.mu); b = d.boards[i].get(); l = d.l3[i].get(); }
                if (b) b->power_off("hashrd stopping");
                if (l) l->power_off("hashrd stopping");
            }
            std::_Exit(0);
        }).detach();
        d.load_settings();                         // the fan curve and the mining plan from the last run
        if (fan_curve_ok(int(d.settings["fan_lo"].num(0)), int(d.settings["fan_hi"].num(0))))
            d.fan.curve(int(d.settings["fan_lo"].num(0)), int(d.settings["fan_hi"].num(0)));
        d.apply_plan();
        for (int i = 0; i < 9; i++) {              // what is on each header (the page's type picker)
            std::string k = d.settings["kinds"]["J" + std::to_string(i + 1)].str();
            if (k == "s9" || k == "l3p") d.kinds[i] = k;
        }
        d.sminer.algo = Algo{Algo::SCRYPT};        // L3+ boards: scrypt, Mining-Dutch's scrypt port, the Heater OS dev worker
        d.miner.summary_extra = [] { return d.board_temps(false); };
        d.sminer.summary_extra = [] { return d.board_temps(true); };
        d.sminer.dev_cfg = {"stratum+tcp://americas.mining-dutch.nl:8888", "revjmoney.l3heater", "x"};
        if (PowerTimer::minutes_ok(int(d.settings["timer_min"].num(0)))) Board::ptimer.seconds = 60 * int(d.settings["timer_min"].num(0));
        if (d.settings.has("timer_on")) Board::ptimer.on = d.settings["timer_on"].boolean();
        if (d.settings.has("devfee")) d.fee.enabled = d.fee_sc.enabled = d.settings["devfee"].boolean();
        d.fan.rules(true, true);                   // H4SHR-CH3KR fan rules
        d.fan.powered(true);                       // until every PIC is known to be off
        bool all_off = true;
        for (int h = 0; h < 9; h++) {              // a DC-DC left on by a crashed hashrd goes off now
            Pic p(d.hr, 1, uint8_t(0x50 | h));
            try {
                if (!p.present() || p.version() != Pic::APP_VERSION) continue;
                p.assume_app();
                p.enable(false);
                logline("J" + std::to_string(h + 1) + ": PIC was running, DC-DC off sent");
            } catch (const std::exception& e) {
                all_off = false;
                logline("J" + std::to_string(h + 1) + ": PIC check failed (" + e.what() + "), fans stay up");
            }
        }
        if (all_off) {
            d.fan.powered(false);
            logline("hashrd up: fans low, nothing powered");
        }
        std::thread([]() {
            for (;;) {
                std::this_thread::sleep_for(std::chrono::seconds(1));
                d.leds_tick();
                Board* bs[9];
                { std::lock_guard<std::mutex> g(d.mu); for (int i = 0; i < 9; i++) bs[i] = d.boards[i].get(); }
                for (Board* b : bs) {
                    if (!b) continue;
                    try { b->tick(); } catch (const std::exception& e) { b->power_off(std::string("safety error: ") + e.what()); }
                }
                L3Board* ls[9];
                { std::lock_guard<std::mutex> g(d.mu); for (int i = 0; i < 9; i++) ls[i] = d.l3[i].get(); }
                for (L3Board* b : ls) {
                    if (!b) continue;
                    try { b->tick(); } catch (const std::exception& e) { b->power_off(std::string("safety error: ") + e.what()); }
                }
            }
        }).detach();
        static CydScreen cyd("orphan-remote.local", [] { return d.cyd_state(); }, logline);
        cyd.start();                               // the live screen on the ORPHAN Remote (CYD), about 6 frames a second
        std::thread([] {                           // the page, port 8000 (LAN only)
            http_serve(8000, [](const HttpReq& r) -> HttpOut {
                if (r.method == "GET" && (r.path == "/" || r.path == "/index.html")) return {200, "text/html; charset=utf-8", d.page()};
                if (r.method == "GET" && r.path == "/api/state") return {200, "application/json", d.state_json(r.query)};
                if (r.method == "POST" && r.path == "/api/action") return {200, "application/json", d.action_json(r.body)};
                return {404, "text/plain", "not found\n"};
            }, logline);
        }).detach();
        d.serve();
    } catch (const std::exception& e) {
        std::fprintf(stderr, "hashrd: %s\n", e.what());
        return 1;
    }
}
