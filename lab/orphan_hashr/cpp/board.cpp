// [orphan] H4SHR-CH3KR hashrd: one hashboard. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "board.hpp"
#include <cmath>
#include <algorithm>
#include <chrono>
#include <cstdio>
#include <thread>

namespace {
double now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
void sleep_s(double s) { std::this_thread::sleep_for(std::chrono::duration<double>(s)); }
constexpr int SLOW_DIV = 26;                      // 115.7 kbaud: the chips' power-up speed
constexpr int COUNT_TRIES = 3;
}

Board::Board(Bus& bus, Hashr& hr, Fan& fan, int header)
    : bus_(bus), hr_(hr), fan_(fan), chain_(bus, header), pic_(hr, 1, uint8_t(0x50 | header)), h_(header) {}

bool Board::wait(double s) {
    double end = now() + s;
    while (now() < end) {
        if (stop_) return false;
        sleep_s(0.05);
    }
    return !stop_;
}

void Board::cmd(const std::vector<uint8_t>& c) { chain_.send_cmd(c); }

void Board::drain_regs() { chain_.flush(false, false, true); }

bool Board::read_reg(int chip, uint8_t reg, uint32_t& v, double timeout_s, bool any) {
    cmd(bm::cmd_read_reg(chip, reg));
    double end = now() + timeout_s;
    RegReply r;
    while (now() < end) {
        while (chain_.pop_reg(r)) {
            seen_chip_ = r.chip; seen_reg_ = r.reg;
            if (any || (r.chip == chip && r.reg == reg)) { v = r.value; return true; }
        }
        sleep_s(0.002);
    }
    return false;
}

int Board::count() {
    drain_regs();
    cmd(bm::cmd_read_reg(-1, bm::REG_ADDR));
    double end = now() + 0.6;
    int n = 0;
    RegReply r;
    while (now() < end) {
        while (chain_.pop_reg(r))
            if ((r.value >> 16) == bm::CHIP_ID) n++;
        sleep_s(0.01);
    }
    return n;
}

void Board::address_pass() {                      // bmminer c:7599-7636
    for (int i = 0; i < 3; i++) { cmd(bm::cmd_chain_inactive()); sleep_s(0.03); }
    for (int a = 0; a < 256; a += 4) { cmd(bm::cmd_set_address(uint8_t(a))); sleep_s(0.03); }
    drain_regs();
}

bool Board::i2c_wait(int reg, uint32_t& v) {      // bmminer wait_iic_ok / check_reg_temp
    for (int i = 0; i < 40; i++) {
        uint32_t x;
        if (read_reg(temp_host_, bm::REG_I2C, x, 0.05, true)) {   // like bmminer: the one reply in flight
            v = x;
            if ((x >> 30) == 0 && (reg < 0 || int((x >> 8) & 0xFF) == reg)) return true;
        }
        sleep_s(0.005);
    }
    return false;
}

bool Board::temp_reg(uint8_t reg, int& c, int host) {
    if (host >= 0) temp_host_ = host;          // i2c_wait reads the reply from temp_host_
    uint32_t v;
    i2c_wait(-1, v);
    cmd(bm::cmd_write_reg(host < 0 ? temp_host_ : host, bm::REG_I2C, bm::i2c_cmd_value(bm::TEMP_DEV, reg, 0, false)));
    sleep_s(0.002);
    if (!i2c_wait(reg, v)) return false;
    return bm::temp_c(uint8_t(v & 0xFF), c);    // FF / 7F (bmminer) and below 0 C count as failed reads
}

bool Board::temp_init() {
    std::vector<int> hosts;
    try { hosts = pic_.temp_hosts(); } catch (const PicError&) {}
    if (std::find(hosts.begin(), hosts.end(), 0xF4) == hosts.end()) hosts.push_back(0xF4);
    { std::lock_guard<std::mutex> g(sm_); temp_hosts_.clear(); }
    for (int host : hosts) {                       // every sensor the PIC names (an S9 board has two), chip 61 last
        if (host / 4 >= chips_) continue;
        if (temp_hosts_.size() == 2) break;
        temp_host_ = host;                         // i2c_wait reads the replies from temp_host_
        cmd(bm::cmd_write_reg(host, bm::REG_MISC, bm::misc_value(div_, true)));
        sleep_s(0.01);
        uint32_t v;
        i2c_wait(-1, v);
        cmd(bm::cmd_write_reg(host, bm::REG_I2C, bm::i2c_cmd_value(bm::TEMP_DEV, 0x09, 0x04, true)));
        sleep_s(0.002);
        i2c_wait(-1, v);
        int c;
        if (temp_reg(0x00, c, host)) {
            { std::lock_guard<std::mutex> g(sm_); temp_hosts_.push_back(host); }
            say("temperature sensor via chip " + std::to_string(host / 4) + " (I2C replies carry chip byte " +
                std::to_string(seen_chip_) + ", register byte " + std::to_string(seen_reg_) + ")");
        }
    }
    { std::lock_guard<std::mutex> g(sm_); pcb_list_.assign(temp_hosts_.size(), -1); chip_list_.assign(temp_hosts_.size(), -1); }
    if (!temp_hosts_.empty()) { temp_host_ = temp_hosts_[0]; return true; }
    temp_host_ = -1;
    say("temperature sensor: no answer (last reply chip byte " + std::to_string(seen_chip_) + ", register byte " +
        std::to_string(seen_reg_) + ")");
    return false;
}

bool Board::power_on(double volts, int mhz, std::string& why) {
    if (power_ != OFF) { why = "busy"; return false; }
    power_ = STARTING;
    stop_ = false;
    pic_up_ = false;                               // no heartbeat until the PIC runs its application
    dcdc_t_ = 0;
    std::lock_guard<std::mutex> g(uart);
    try {
        say("POWER ON: header J" + std::to_string(h_ + 1));
        chain_.run(false);
        chain_.source(false);                      // a chain left on the builder by a cut mid-mining takes ARM works again
        chain_.flush(true, true, true);
        chain_.set_cpb(uint16_t(bm::cpb_for_div(SLOW_DIV)));
        div_ = SLOW_DIV;
        hr_.go(true);
        hr_.header(h_, true, false);               // chips held in reset
        hr_.en(h_, 1);
        if (!wait(3.0)) throw std::runtime_error("stopped");
        pic_ver_ = pic_.reset();                     // the application version it answers with
        last_hb_ = now();
        pic_up_ = true;
        pic_.set_voltage(volts);
        double back = pic_.voltage();
        if (back - volts > 0.05 || volts - back > 0.05) throw std::runtime_error("PIC voltage readback mismatch");
        volts_set_ = volts;
        volts_read_ = back;
        pic_.enable(true);
        dcdc_t_ = now();
        last_temp_t_ = 0;
        fan_.powered(true);
        timer_end_ = now() + ptimer.seconds;
        if (!wait(10.0)) throw std::runtime_error("stopped");      // settle with reset held (bmminer)
        hr_.header(h_, true, false);
        if (!wait(1.0)) throw std::runtime_error("stopped");
        hr_.header(h_, true, true);                // release: low = held, high = run
        if (!wait(1.0)) throw std::runtime_error("stopped");
        int n = 0;
        for (int t = 0; t < COUNT_TRIES && n < bm::CHIPS; t++) {
            n = count();
            say("chip count: " + std::to_string(n));
        }
        if (n == 0) throw std::runtime_error("no chip answered the count");
        address_pass();
        chips_ = std::min(bm::CHIPS, std::max(count(), count()));   // a stray reply never makes it 64
        say("after addressing: " + std::to_string(chips_) + " chips");
        int actual = mhz;
        uint32_t word = bm::pll_for(mhz, &actual);  // bmminer order: frequency, then baud, then temperature
        for (int i = 0; i < chips_; i++) cmd(bm::cmd_write_reg(bm::chip_addr(i), bm::REG_PLL, word));
        mhz_ = actual;
        { std::lock_guard<std::mutex> g(sm_); cmhz_.assign(size_t(chips_), mhz_); coff_.assign(size_t(chips_), false); }
        if (!wait(0.2)) throw std::runtime_error("stopped");
        div_ = bm::baud_div_for_freq(mhz_);
        cmd(bm::cmd_write_reg(-1, bm::REG_MISC, bm::misc_value(div_, false)));
        chain_.queue_baud(uint16_t(bm::cpb_for_div(div_)));
        sleep_s(0.05);
        drain_regs();
        uint32_t v;
        bool ok = read_reg(0, bm::REG_ADDR, v, 0.15) && (v >> 16) == bm::CHIP_ID;
        say(std::string("after the baud switch (divider ") + std::to_string(div_) + ") chip 0 " +
            (ok ? "answers" : "is SILENT"));
        temp_init();
        power_ = ON;
        say("ON: " + std::to_string(chips_) + " chips at " + std::to_string(mhz_) + " MHz");
        return true;
    } catch (const std::exception& e) {
        why = e.what();
        say(std::string("bring-up failed: ") + why);
    }
    power_ = ON;                                   // let power_off run its full sequence
    power_off("bring-up failed: " + why);
    return false;
}

bool Board::open_cores(uint8_t ticket) {          // bmminer open_core and cgminer gekko MINER_OPEN_CORE
    std::lock_guard<std::mutex> g(uart);
    return open_cores_held(ticket);
}

bool Board::open_cores_held(uint8_t ticket) {
    if (power_ != ON) return false;
    cmd(bm::cmd_write_reg(-1, bm::REG_MISC, bm::misc_gate(div_)));
    sleep_s(0.01);
    if (temp_host_ >= 0) {
        cmd(bm::cmd_write_reg(temp_host_, bm::REG_MISC, bm::misc_gate_temp_host(div_)));
        sleep_s(0.01);
    }
    uint8_t tail[12], mid[32] = {};
    for (auto& b : tail) b = 0xFF;
    chain_.set_timeout(10000);                     // 114 busy works, 10 ms apart
    chain_.run(true);
    double end = now() + 5.0;                      // 114 x 10 ms, with room
    for (int i = 0; i < 114; i++)
        while (!chain_.push_work(0xFFFFFFFF, 0, tail, mid)) {
            if (power_ != ON || now() > end) { chain_.run(false); return false; }
            sleep_s(0.005);
        }
    while (chain_.stat().works || chain_.stat().sending) {
        if (power_ != ON || now() > end) { chain_.run(false); return false; }
        sleep_s(0.01);
    }
    chain_.run(false);
    cmd(bm::cmd_write_reg(-1, bm::REG_TICKET, ticket));
    sleep_s(0.05);
    cmd(bm::cmd_write_reg(-1, bm::REG_HCN, 0));    // bmminer: ticket mask, set_hcnt(0), 10 ms
    sleep_s(0.01);
    chain_.set_timeout(bm::timeout_us(mhz_));
    say("cores open: ticket " + std::to_string(ticket) + ", a job every " + std::to_string(bm::timeout_us(mhz_)) + " us");
    return true;
}

void Board::power_off(const std::string& why) {
    if (power_ == OFF) return;
    power_ = STOPPING;
    stop_ = true;
    chain_.run(false);
    bool dcdc_off = false;
    for (int i = 0; i < 3 && !dcdc_off; i++) {
        try { pic_.enable(false); dcdc_off = true; }
        catch (const std::exception& e) { say(std::string("DC-DC off failed: ") + e.what()); }
    }
    try {
        hr_.header(h_, true, false);
        hr_.header(h_, false, false);
        hr_.en(h_, 0);
        if (!others_on || !others_on()) hr_.go(false);   // GO is shared by every header: last board off only
    } catch (const std::exception& e) { say(std::string("header off failed: ") + e.what()); }
    if (dcdc_off || !pic_up_) {                      // DC-DC state unknown: fans stay on the powered rules
        if (!others_on || !others_on()) fan_.powered(false);
    }
    else say("DC-DC state unknown: fans stay up");
    pic_up_ = false;
    hold_until_ = 0;
    dcdc_t_ = 0;
    temp_host_ = -1;
    { std::lock_guard<std::mutex> g(sm_); temp_hosts_.clear(); }
    { std::lock_guard<std::mutex> g(sm_); pcb_list_.clear(); chip_list_.clear(); last_off_ = why; }
    chips_ = 0;
    power_ = OFF;
    say("POWER OFF: " + why);
}

PowerTimer Board::ptimer;

void Board::renew() { if (power_ == ON) timer_end_ = now() + ptimer.seconds; }

int Board::timer_left() const { return power_ == ON ? int(timer_end_ - now()) : -1; }

void Board::tick() {
    if (power_ == OFF || power_ == STOPPING) return;
    double t = now();
    try {
        if (pic_up_ && t - last_hb_ >= 2.0) { pic_.heartbeat(); last_hb_ = t; }
    } catch (const std::exception& e) {
        return power_off(std::string("PIC heartbeat failed: ") + e.what());
    }
    if (power_ == ON && ptimer.expired(t, timer_end_)) return power_off("timer ran out (nobody renewed it)");
    if (hold_until_ > 0) {                         // HOLD: chips in reset, no temperatures; bounded by its own time
        if (t > hold_until_) return power_off("HOLD time over");
        return;
    }
    if (temp_host_ >= 0 && t - last_temp_try_ >= 5.0) {
        std::unique_lock<std::mutex> g(uart, std::try_to_lock);
        if (g.owns_lock()) {
            last_temp_try_ = t;
            int pcb_max = -1, chip_max = -1;           // every sensor; the safety cuts and the fan use the hottest
            std::vector<int> hosts;
            { std::lock_guard<std::mutex> l(sm_); hosts = temp_hosts_; }   // a power off may clear it meanwhile
            std::vector<int> pl(hosts.size(), -1), cl(hosts.size(), -1);
            for (size_t k = 0; k < hosts.size(); k++) {
                int p, c;
                pl[k] = temp_reg(0x00, p, hosts[k]) ? p : -1;
                cl[k] = pl[k] >= 0 && temp_reg(0x01, c, hosts[k]) ? c : -1;
                pcb_max = std::max(pcb_max, pl[k]);
                chip_max = std::max(chip_max, cl[k]);
            }
            {
                std::lock_guard<std::mutex> l(sm_);
                if (temp_hosts_ == hosts) { pcb_list_ = pl; chip_list_ = cl; }
            }
            if (pcb_max >= 0) {
                pcb_ = pcb_max;
                chip_ = chip_max;
                last_temp_t_ = t;
                if (on_temp) on_temp(); else fan_.temp(chip_ > pcb_ ? chip_ : pcb_);
                if (pcb_ > PCB_MAX_C) {
                    g.unlock();
                    return power_off("board temperature " + std::to_string(pcb_) + " C above 90 C");
                }
            }
        }
    }
    double last = last_temp_t_ > 0 ? last_temp_t_ : dcdc_t_;
    if (dcdc_t_ > 0 && t - last > TEMP_WINDOW_S) power_off("no temperature reading for 60 s");
}

std::string Board::state_text() const {
    static const char* names[] = {"off", "starting", "on", "stopping"};
    char b[200];
    std::snprintf(b, sizeof b, "power %s chips %d mhz %d pcb %d chip %d timer %d", names[int(power_)], chips_, mhz_,
                  pcb_, chip_, timer_left());
    return b;
}

// ---------------------------------------------------------------- board controls (the page's)
bool Board::balance_ok(const std::vector<int>& mhz) {
    if (mhz.empty()) return true;
    double board = 0;
    for (int m : mhz) board += m;
    board /= double(mhz.size());
    for (size_t r = 0; r + 2 < mhz.size(); r += 3) {           // each step of the series voltage chain
        double m = (mhz[r] + mhz[r + 1] + mhz[r + 2]) / 3.0;
        if (std::fabs(m - board) > 0.25 * board) return false;
    }
    return true;
}

bool Board::pic_info(std::string& text) {
    try {
        uint8_t v = pic_.ensure_app();
        pic_ver_ = v;
        std::vector<uint8_t> id = pic_.board_id();
        char b[160];
        std::string hex;
        for (uint8_t c : id) { std::snprintf(b, sizeof b, "%02x", c); hex += b; }
        std::snprintf(b, sizeof b, "PIC version 0x%02X (%s), board id %s, %.2f V", v,
                      v == Pic::APP_VERSION ? "supported" : "NOT supported: voltage stays off", hex.c_str(), volts_read_ = pic_.voltage());
        text = b;
        std::string tt;
        for (uint8_t c : pic_.temp_table()) { std::snprintf(b, sizeof b, " %02x", c); tt += b; }
        text += ", sensor table" + tt;
        say(text);
        return v == Pic::APP_VERSION;
    } catch (const std::exception& e) {
        text = std::string("PIC: ") + e.what();
        say(text);
        return false;
    }
}

bool Board::set_volts(double v, std::string& why) {
    if (!powered()) { why = "power is off"; return false; }
    if (!volts_ok(v)) { why = "voltage must be 8.60 to 9.40 V"; return false; }
    pic_.set_voltage(v);
    volts_set_ = v;
    volts_read_ = pic_.voltage();
    char b[80];
    std::snprintf(b, sizeof b, "voltage %.2f V (PIC reads %.2f V)", v, pic_.voltage());
    say(b);
    return true;
}

bool Board::set_chips(const std::vector<int>& chips, int mhz, bool off, std::string& why) {
    if (!powered()) { why = "power is off"; return false; }
    int actual = 0;
    uint32_t word = bm::pll_for(off ? 0 : mhz, &actual);      // pll_for clamps: 0 gives the table's minimum
    std::vector<int> next;
    { std::lock_guard<std::mutex> l(sm_); next = cmhz_; }
    for (int i : chips) {
        if (i < 0 || i >= chips_) { why = "chip " + std::to_string(i) + " is not on this board"; return false; }
        next[size_t(i)] = actual;
    }
    if (!balance_ok(next)) {
        why = "a row would run more than 25 % away from the board average (series voltage steps drift)";
        say("clock change refused: " + why);
        return false;
    }
    // A BM1387 whose PLL changes while its cores hash stops finding nonces until its cores are opened again
    // (2026-11-25, J6 200 -> 300 MHz while mining: nonces stopped, going back to 200 did not help). bmminer only sets
    // the clock before open_core. So: stop the chain, set the clock, let the PLL lock, open the cores again, pace the
    // jobs for the new clock, and give the chain back to whoever fed it.
    std::lock_guard<std::mutex> g(uart);
    bool was_run = chain_.running(), was_builder = chain_.from_builder();
    if (was_run) {
        chain_.run(false);
        chain_.source(false);
        chain_.flush(true, false, false);
    }
    for (int i : chips) {
        cmd(bm::cmd_write_reg(bm::chip_addr(i), bm::REG_PLL, word));
        { std::lock_guard<std::mutex> l(sm_); cmhz_[size_t(i)] = actual; coff_[size_t(i)] = off; }
    }
    { std::lock_guard<std::mutex> l(sm_); mhz_ = pacing_mhz(cmhz_, coff_); }
    sleep_s(0.2);                                  // PLL lock (power_on waits the same)
    bool ok = true;
    if (was_run) {
        ok = open_cores_held(0);                   // sets the pacing for mhz_ too
        chain_.source(was_builder);
        chain_.run(true);
    } else {
        chain_.set_timeout(bm::timeout_us(mhz_));
    }
    say(std::to_string(chips.size()) + " chip(s): " + (off ? "OFF" : std::to_string(actual) + " MHz") +
        (was_run ? (ok ? ", cores opened again" : ", opening the cores again FAILED") : ""));
    if (!ok) why = "the cores did not open again after the clock change";
    return ok;
}

int Board::pacing_mhz(const std::vector<int>& mhz, const std::vector<bool>& off) {
    long sum = 0;
    int n = 0;
    for (size_t i = 0; i < mhz.size(); i++)
        if (i >= off.size() || !off[i]) { sum += mhz[i]; n++; }
    if (n == 0) { int a = 0; bm::pll_for(0, &a); return a; }
    return int(sum / n);
}
