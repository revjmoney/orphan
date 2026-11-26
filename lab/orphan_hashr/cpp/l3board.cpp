// [orphan] H4SHR-CH3KR hashrd: one Antminer L3+ hashboard. Facts and sources: lab-work/l3-re/BM1485-L3plus-protocol.md.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "l3board.hpp"
#include "board.hpp"
#include <algorithm>
#include <chrono>
#include <cstdio>
#include <thread>

namespace {
double now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
void sleep_s(double s) { std::this_thread::sleep_for(std::chrono::duration<double>(s)); }
constexpr uint16_t CPB_115200 = 864;               // 100 MHz / 864 = 115.7 kbaud; the L3+ never switches its baud
}

L3Board::L3Board(Bus& bus, Hashr& hr, Fan& fan, int header)
    : hr_(hr), fan_(fan), chain_(bus, header), pic_(hr, 1, uint8_t(0x50 | header)), h_(header) {}

bool L3Board::wait(double s) {
    double end = now() + s;
    while (now() < end) {
        if (stop_) return false;
        sleep_s(0.05);
    }
    return !stop_;
}

int L3Board::count_chips(double seconds) {          // replies to "read reg 0 from all chips"
    chain_.flush(false, false, true);
    tx(bm85::cmd_read_reg(-1, bm85::REG_ADDR));
    int n = 0;
    double end = now() + seconds;
    RegReply r;
    while (now() < end) {
        if (chain_.pop_reg(r)) { if (r.reg == bm85::REG_ADDR) n++; }
        else sleep_s(0.01);
    }
    return n;
}

bool L3Board::power_on(int mhz, std::string& why) {
    if (power_ != OFF) { why = "busy"; return false; }
    power_ = STARTING;
    stop_ = false;
    pic_up_ = false;
    dcdc_t_ = 0;
    std::lock_guard<std::mutex> g(uart);
    try {
        say("POWER ON (stock L3+ order, no voltage command)");
        chain_.run(false);                         // the FPGA work sender never runs on an L3+ chain
        chain_.source(false);
        chain_.flush(true, true, true);
        chain_.set_cpb(CPB_115200);
        hr_.go(true);
        hr_.header(h_, true, false);               // chips held in reset
        hr_.en(h_, 1);
        if (!wait(3.0)) throw std::runtime_error("stopped");
        uint8_t v = pic_.reset_l3();               // stock: 07, 1 s, 06, 1 s
        say("PIC application version 0x" + [&] { char b[4]; std::snprintf(b, sizeof b, "%02x", v); return std::string(b); }());
        last_hb_ = now();
        pic_up_ = true;
        pic_.enable(true);                         // 15 01
        dcdc_t_ = now();
        last_temp_t_ = 0;
        fan_.powered(true);
        timer_end_ = now() + Board::ptimer.seconds;
        if (!wait(5.0)) throw std::runtime_error("stopped");      // stock waits 5 s after DC-DC on
        for (int k = 0; k < 2; k++) {              // stock: reset low 500 ms, high, twice
            hr_.header(h_, true, false);
            if (!wait(0.5)) throw std::runtime_error("stopped");
            hr_.header(h_, true, true);
            if (!wait(0.5)) throw std::runtime_error("stopped");
        }
        int n = count_chips(2.0);
        say("chip count: " + std::to_string(n) + " (72 expected)");
        if (n == 0) throw std::runtime_error("no chip answered the count");
        tx(bm85::cmd_chain_inactive());
        sleep_s(0.03);
        for (int a = 0; a < 256 / bm85::INTERVAL; a++) {          // 85 addresses, as stock (extras are harmless)
            tx(bm85::cmd_set_address(uint8_t(a * bm85::INTERVAL)));
            sleep_s(0.01);
        }
        chips_ = std::min(bm85::CHIPS, count_chips(1.0));
        say("after addressing: " + std::to_string(chips_) + " chips");
        int actual = 0;
        tx(bm85::cmd_pll(-1, bm85::pll_for(mhz, &actual)));
        mhz_ = actual;
        sleep_s(0.01);
        tx(bm85::cmd_write_imm(-1, bm85::REG_MISC, 0x103a4041));
        sleep_s(0.002);
        for (uint8_t host : bm85::TEMP_HOSTS) {
            tx(bm85::cmd_write_imm(host, bm85::REG_MISC, 0x707a4041));   // sensor-host bits
            sleep_s(0.002);
        }
        sleep_s(0.1);
        for (uint8_t host : bm85::TEMP_HOSTS) {    // the board sensor (I2C 0x98) behind each host chip
            tx(bm85::cmd_write_imm(host, bm85::REG_I2C, 0x00009803));
            sleep_s(0.01);
        }
        static const int blocks[12] = {0, 1, 2, 3, 4, 5, 8, 9, 10, 11, 12, 13};
        for (int b : blocks) {                     // "open block": wire 00 i 00 01
            tx(bm85::cmd_write_imm(-1, bm85::REG_CORE, 0x01000000u | uint32_t(b) << 8));
            sleep_s(0.01);
        }
        for (uint8_t host : bm85::TEMP_HOSTS) {    // core-temperature select, stock default 2: wire 00 02 03 00
            tx(bm85::cmd_write_imm(host, bm85::REG_CORE, 0x00030200));
            sleep_s(0.01);
        }
        tx(bm85::cmd_ticket_mask(0xFF));
        sleep_s(0.01);
        chain_.flush(false, false, true);
        power_ = ON;
        {
            std::lock_guard<std::mutex> l(sm_);
            cmhz_.assign(size_t(bm85::CHIPS), mhz_.load());
            coff_.assign(size_t(bm85::CHIPS), false);
        }
        say("ON: " + std::to_string(chips_) + " chips at " + std::to_string(mhz_) + " MHz");
        return true;
    } catch (const std::exception& e) {
        why = e.what();
        say(std::string("bring-up failed: ") + why);
    }
    power_ = ON;
    power_off("bring-up failed: " + why);
    return false;
}

std::vector<std::string> l3_verdicts(const std::vector<int>& valid, const std::vector<int>& bad, const std::vector<bool>& off) {
    size_t n = valid.size();
    long sum = 0;
    int on = 0;
    for (size_t i = 0; i < n; i++) if (i >= off.size() || !off[i]) { sum += valid[i]; on++; }
    double mean = on ? double(sum) / on : 0;
    std::vector<std::string> v(n, "ok");
    for (size_t i = 0; i < n; i++) {
        int b = i < bad.size() ? bad[i] : 0;
        if (i < off.size() && off[i]) v[i] = "off";
        else if (b > 0 && b * 4 > valid[i] + b) v[i] = "bad";
        else if (mean < 5) v[i] = "few";
        else if (valid[i] == 0) v[i] = "dead";
        else if (valid[i] < 0.3 * mean) v[i] = "weak";
    }
    return v;
}

bool L3Board::row_balance_ok(const std::vector<int>& mhz, const std::vector<bool>& off) {
    long sum = 0;
    int n = 0;
    for (size_t i = 0; i < mhz.size(); i++) if (i >= off.size() || !off[i]) { sum += mhz[i]; n++; }
    if (n == 0) return true;
    double avg = double(sum) / n;
    for (size_t r = 0; r * 3 < mhz.size(); r++) {     // a row = 3 chips in address order (the page's map)
        long rs = 0;
        int rn = 0;
        for (size_t k = r * 3; k < r * 3 + 3 && k < mhz.size(); k++) if (k >= off.size() || !off[k]) { rs += mhz[k]; rn++; }
        if (rn == 0) continue;
        double ra = double(rs) / rn;
        if (ra > avg * 1.25 || ra < avg * 0.75) return false;
    }
    return true;
}

int L3Board::pacing_mhz(const std::vector<int>& mhz, const std::vector<bool>& off) {
    long sum = 0;
    int n = 0;
    for (size_t i = 0; i < mhz.size(); i++) if (i >= off.size() || !off[i]) { sum += mhz[i]; n++; }
    if (n == 0) { int a = 0; bm85::pll_for(0, &a); return a; }
    return int(sum / n);
}

bool L3Board::set_chips(const std::vector<int>& chips, int mhz, bool off, std::string& why) {
    if (!powered()) { why = "power is off"; return false; }
    int actual = 0;
    uint32_t word = bm85::pll_for(off ? 0 : mhz, &actual);    // 0 gives the table's lowest (100 MHz)
    std::vector<int> next;
    std::vector<bool> noff;
    { std::lock_guard<std::mutex> l(sm_); next = cmhz_; noff = coff_; }
    for (int i : chips) {
        if (i < 0 || i >= chips_) { why = "chip " + std::to_string(i) + " is not on this board"; return false; }
        next[size_t(i)] = actual;
        noff[size_t(i)] = off;
    }
    if (!row_balance_ok(next, noff)) {
        why = "a row would run more than 25 % away from the board average (the chips are in series)";
        say("clock change refused: " + why);
        return false;
    }
    // As on the S9 (a BM1387 whose PLL changes while it hashes stops finding nonces until its cores open again):
    // hold the works, set the PLLs, let them lock, open each chip's cores again, then the caller sends a fresh work.
    std::lock_guard<std::mutex> g(uart);
    hold_ = true;
    sleep_s(0.05);
    for (int i : chips) {
        tx(bm85::cmd_pll(bm85::chip_addr(i), word));
        sleep_s(0.002);
    }
    sleep_s(0.2);
    static const int blocks[12] = {0, 1, 2, 3, 4, 5, 8, 9, 10, 11, 12, 13};
    for (int i : chips)
        for (int b : blocks) {
            tx(bm85::cmd_write_imm(bm85::chip_addr(i), bm85::REG_CORE, 0x01000000u | uint32_t(b) << 8));
            sleep_s(0.002);
        }
    {
        std::lock_guard<std::mutex> l(sm_);
        for (int i : chips) { cmhz_[size_t(i)] = actual; coff_[size_t(i)] = off; }
        mhz_ = pacing_mhz(cmhz_, coff_);
    }
    hold_ = false;
    say(std::to_string(chips.size()) + " chip(s): " + (off ? "OFF (" + std::to_string(actual) + " MHz)" : std::to_string(actual) + " MHz") +
        ", cores opened again, board pace " + std::to_string(mhz_.load()) + " MHz");
    return true;
}

void L3Board::power_off(const std::string& why) {
    if (power_ == OFF) return;
    power_ = STOPPING;
    stop_ = true;
    chain_.run(false);
    chain_.flush(true, true, true);
    bool dcdc_off = false;
    for (int i = 0; i < 3 && !dcdc_off; i++) {
        try { pic_.enable(false); dcdc_off = true; }
        catch (const std::exception& e) { say(std::string("DC-DC off failed: ") + e.what()); }
    }
    try {
        hr_.header(h_, true, false);
        hr_.header(h_, false, false);
        hr_.en(h_, 0);
        if (!others_on || !others_on()) hr_.go(false);
    } catch (const std::exception& e) { say(std::string("header off failed: ") + e.what()); }
    if (dcdc_off || !pic_up_) { if (!others_on || !others_on()) fan_.powered(false); }
    else say("DC-DC state unknown: fans stay up");
    pic_up_ = false;
    dcdc_t_ = 0;
    pcb_ = -1;
    chip_ = -1;
    chips_ = 0;
    { std::lock_guard<std::mutex> l(sm_); last_off_ = why; }
    power_ = OFF;
    say("POWER OFF: " + why);
}

void L3Board::renew() { if (power_ == ON) timer_end_ = now() + Board::ptimer.seconds; }
int L3Board::timer_left() const { return power_ == ON ? int(timer_end_ - now()) : -1; }

void L3Board::tick() {
    if (power_ == OFF || power_ == STOPPING) return;
    double t = now();
    try {
        if (pic_up_ && t - last_hb_ >= 2.0) { pic_.heartbeat(); last_hb_ = t; }
    } catch (const std::exception& e) {
        return power_off(std::string("PIC heartbeat failed: ") + e.what());
    }
    if (power_ == ON && Board::ptimer.expired(t, timer_end_)) return power_off("timer ran out (nobody renewed it)");
    if (power_ == ON && t - last_temp_try_ >= 5.0) {
        std::unique_lock<std::mutex> g(uart, std::try_to_lock);
        if (g.owns_lock()) {
            last_temp_try_ = t;
            chain_.flush(false, false, true);
            for (uint8_t host : bm85::TEMP_HOSTS) tx(bm85::cmd_read_reg(host, bm85::REG_TEMP));
            int local = -1, remote = -1;
            double end = now() + 0.3;
            RegReply r;
            while (now() < end) {
                if (!chain_.pop_reg(r)) { sleep_s(0.01); continue; }
                int l, rm;
                if (r.reg == bm85::REG_TEMP && bm85::temps_from_reg44(r.value, l, rm)) {
                    local = std::max(local, l);
                    remote = std::max(remote, rm);
                }
            }
            if (local >= 0) {
                pcb_ = local;
                chip_ = remote;
                last_temp_t_ = t;
                if (on_temp) on_temp(); else fan_.temp(std::max(local, remote));
                if (local >= bm85::CUT_C) {
                    g.unlock();
                    return power_off("board temperature " + std::to_string(local) + " C, the L3+ cut is 86 C");
                }
            }
        }
    }
    double last = last_temp_t_ > 0 ? last_temp_t_ : dcdc_t_;
    if (dcdc_t_ > 0 && power_ == ON && t - last > TEMP_WINDOW_S) power_off("no temperature reading for 60 s");
}

std::string L3Board::state_text() const {
    char b[200];
    std::snprintf(b, sizeof b, "L3+ power %s chips %d mhz %d pcb %d chip %d timer %d", power_name().c_str(),
                  chips_.load(), mhz_.load(), pcb_.load(), chip_.load(), timer_left());
    return b;
}
