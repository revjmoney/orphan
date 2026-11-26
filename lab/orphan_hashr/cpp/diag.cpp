// [orphan] H4SHR-CH3KR hashrd: the bring-up diagnostics from the stuck-chain hunt, ported from the Python service
// (HOLD, DIAG, RSTPROBE, KAT, SKOT). Each powers the board itself, so each runs only on a command with Rev present.
// With the FPGA owning the chain's RX, "bytes back" are the collector's CRC-checked frames (register replies and
// nonces) and the chain counters, plus the RX pin's level from slot 1.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "board.hpp"
#include "bm1387.hpp"
#include "sha256.hpp"
#include "work.hpp"
#include <chrono>
#include <cstdio>
#include <set>
#include <thread>

namespace {
constexpr int SLOW_DIV = 26;                      // 115.7 kbaud
constexpr int FAST_DIV = 1;                       // 1.5625 Mbaud
double now_s() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
void sleep_ms(int ms) { std::this_thread::sleep_for(std::chrono::milliseconds(ms)); }

std::vector<uint8_t> with_crc(std::vector<uint8_t> p) {
    uint16_t c = bm::crc16_false(p.data(), int(p.size()));
    p.push_back(uint8_t(c >> 8));
    p.push_back(uint8_t(c));
    return p;
}
std::vector<uint8_t> busy_packet(int jid) {
    std::vector<uint8_t> p = {0x21, 0x36, uint8_t(jid & 0x7F), 0x01, 0, 0, 0, 0};
    p.insert(p.end(), 12, 0xFF);
    p.insert(p.end(), 32, 0x00);
    return with_crc(p);
}
// the chain's work words for an 80-byte header: tail = bytes 72..75, 68..71, 64..67; midstate H7..H0 big-endian
void tail_mid(const std::vector<uint8_t>& hdr, uint8_t tail[12], uint8_t mid[32]) {
    for (int w = 0; w < 3; w++)
        for (int b = 0; b < 4; b++) tail[4 * w + b] = hdr[size_t(72 - 4 * w + b)];
    uint32_t h[8];
    for (int i = 0; i < 8; i++) h[i] = sha::IV[i];
    sha::compress(h, hdr.data());
    for (int i = 0; i < 8; i++)
        for (int b = 0; b < 4; b++) mid[4 * i + b] = uint8_t(h[7 - i] >> (24 - 8 * b));
}
}

std::vector<uint8_t> Board::kat_header(int k) {
    Work w = build_work(genesis_job(), 0xffff001d);
    std::vector<uint8_t> h(w.header, w.header + 80);
    uint32_t t = h[68] | h[69] << 8 | h[70] << 16 | uint32_t(h[71]) << 24;
    t += uint32_t(k);
    for (int b = 0; b < 4; b++) h[size_t(68 + b)] = uint8_t(t >> (8 * b));
    return h;
}

std::vector<uint8_t> Board::skot_job(int i) {
    static const uint8_t J[2][52] = {   // skot/bm1387_scripts miner.py: two real test jobs (bytes before the CRC-16)
        {0x21, 0x36, 0x74, 0x01, 0, 0, 0, 0, 0xF9, 0x1E, 0x0E, 0x17, 0x80, 0x20, 0xCC, 0x60, 0x61, 0x81, 0x55, 0x05,
         0x00, 0x36, 0x06, 0x53, 0x32, 0x62, 0xA2, 0x41, 0x21, 0xA0, 0x3C, 0xB2, 0x43, 0xE3, 0xC0, 0x53, 0x49, 0xFC,
         0x20, 0x7A, 0x9D, 0x5D, 0xE0, 0x84, 0xE6, 0x62, 0x14, 0x75, 0x99, 0xCB, 0x96, 0x9C},
        {0x21, 0x36, 0x75, 0x01, 0, 0, 0, 0, 0xF9, 0x1E, 0x0E, 0x17, 0x80, 0x20, 0xCC, 0x60, 0x3A, 0xEC, 0xC0, 0x17,
         0x48, 0xC5, 0x54, 0x38, 0x05, 0x06, 0x1A, 0xA3, 0x45, 0xD7, 0x4C, 0xA1, 0x0D, 0xB6, 0x44, 0x5F, 0x0C, 0x85,
         0x62, 0xF2, 0x97, 0xB4, 0xAE, 0x27, 0x03, 0x33, 0xAB, 0xEE, 0x11, 0xA8, 0x93, 0x5C}};
    if (i < 0 || i > 1) return {};
    return with_crc(std::vector<uint8_t>(J[i], J[i] + 52));
}

// DC-DC on at the voltage, chips not brought up (no counting, no addressing): the diagnostics' common start
bool Board::dcdc_up(double volts, bool rst_run, std::string& why) {
    if (power_ != OFF) { why = "the board is not off"; return false; }
    if (!volts_ok(volts)) { why = "voltage must be 8.60 to 9.40 V"; return false; }
    power_ = STARTING;
    stop_ = false;
    pic_up_ = false;
    dcdc_t_ = 0;
    try {
        chain_.run(false);
        chain_.source(false);
        chain_.flush(true, true, true);
        chain_.set_cpb(uint16_t(bm::cpb_for_div(SLOW_DIV)));
        div_ = SLOW_DIV;
        hr_.go(true);
        hr_.header(h_, true, rst_run);
        hr_.en(h_, 1);
        if (!wait(3.0)) throw std::runtime_error("stopped");
        pic_ver_ = pic_.reset();
        last_hb_ = now_s();
        pic_up_ = true;
        pic_.set_voltage(volts);
        double back = pic_.voltage();
        if (back - volts > 0.05 || volts - back > 0.05) throw std::runtime_error("PIC voltage readback mismatch");
        volts_set_ = volts;
        volts_read_ = back;
        pic_.enable(true);
        dcdc_t_ = now_s();
        last_temp_t_ = 0;
        fan_.powered(true);
        timer_end_ = now_s() + ptimer.seconds;
        power_ = ON;
        char b[80];
        std::snprintf(b, sizeof b, "DC-DC on at %.2f V (chips not brought up)", back);
        say(b);
        return true;
    } catch (const std::exception& e) {
        why = e.what();
        power_off(std::string("diagnostic start failed: ") + e.what());
        return false;
    }
}

int Board::count_at(int div) {
    chain_.set_cpb(uint16_t(bm::cpb_for_div(div)));
    int n = count();
    chain_.set_cpb(uint16_t(bm::cpb_for_div(SLOW_DIV)));
    return n;
}

std::string Board::run_hold(double volts, int seconds) {
    if (seconds < 10) seconds = 10;
    if (seconds > 300) seconds = 300;
    std::lock_guard<std::mutex> g(uart);
    std::string why;
    if (!dcdc_up(volts, false, why)) return "HOLD failed: " + why;     // RST low: chips held in reset
    hold_until_ = now_s() + seconds;
    timer_end_ = hold_until_ + 1;
    std::string s = "HOLD: DC-DC on, chips held in reset for " + std::to_string(seconds) +
                    " s: measure the chain voltage now (POWER OFF ends it sooner)";
    say(s);
    return s;
}

std::string Board::run_diag(double volts) {
    std::string out, why;
    {
        std::lock_guard<std::mutex> g(uart);
        if (!dcdc_up(volts, false, why)) return "DIAG failed: " + why;
    }
    try {
        if (!wait(5.0)) throw std::runtime_error("stopped");
        for (int swap = 0; swap < 2; swap++)
            for (int en = 1; en >= 0; en--) {
                std::lock_guard<std::mutex> g(uart);
                hr_.en(h_, en);
                hr_.header(h_, true, false, swap);          // reset held 3 s (bmminer), then released
                if (!wait(3.0)) throw std::runtime_error("stopped");
                hr_.header(h_, true, true, swap);
                if (!wait(1.0)) throw std::runtime_error("stopped");
                int idle = 0;
                for (int k = 0; k < 50; k++) idle += hr_.pins()[size_t(4 * h_ + (swap ? 1 : 2))];
                ChainStat s0 = chain_.stat();
                drain_regs();
                for (int k = 0; k < 3; k++) { cmd(bm::cmd_chain_inactive()); sleep_ms(30); }
                cmd(bm::cmd_read_reg(-1, bm::REG_ADDR));
                int regs = 0;
                RegReply r;
                double end = now_s() + 0.6;
                while (now_s() < end) { if (chain_.pop_reg(r)) regs++; else sleep_ms(2); }
                ChainStat s1 = chain_.stat();
                char b[200];
                std::snprintf(b, sizeof b, "DIAG %s EN=%d: RX idle high %d/50, %d chip replies, %u frames, %u CRC errors",
                              swap ? "SWAPPED" : "normal ", en, idle, regs, s1.frames - s0.frames, s1.crc_err - s0.crc_err);
                say(b);
                out += std::string(b) + "\n";
            }
    } catch (const std::exception& e) {
        out += std::string("DIAG stopped: ") + e.what() + "\n";
    }
    power_off("DIAG finished");
    hr_.header(h_, false, false, false);
    return out;
}

std::string Board::run_rstprobe(double volts) {
    std::string out, why;
    {
        std::lock_guard<std::mutex> g(uart);
        if (!dcdc_up(volts, true, why)) return "RSTPROBE failed: " + why;
    }
    try {
        if (!wait(5.0)) throw std::runtime_error("stopped");
        auto line = [&](const std::string& step) {
            std::lock_guard<std::mutex> g(uart);
            int s = count_at(SLOW_DIV), f = count_at(FAST_DIV);
            std::string l = "RSTPROBE " + step + ": " + std::to_string(s) + " at 115.7k, " + std::to_string(f) + " at 1.5625M";
            say(l);
            out += l + "\n";
        };
        line("before");
        for (int level = 0; level < 2; level++) {
            hr_.header(h_, true, level);
            if (!wait(1.0)) throw std::runtime_error("stopped");
            hr_.header(h_, true, !level);
            if (!wait(1.0)) throw std::runtime_error("stopped");
            line("pulse " + std::to_string(level) + " then " + std::to_string(1 - level));
        }
        out += "a real reset leaves the chips answering at 115.7k\n";
    } catch (const std::exception& e) {
        out += std::string("RSTPROBE stopped: ") + e.what() + "\n";
    }
    power_off("RSTPROBE finished");
    return out;
}

std::string Board::run_kat(Bus& bus) {
    if (!powered()) return "KAT: power is off\n";
    if (!open_cores(0)) return "KAT: could not open the cores\n";
    std::string out;
    Nonce n;
    while (pop_nonce(bus, n)) {}                    // the busy works' leftovers
    chain_.run(false);
    chain_.source(false);
    chain_.flush(true, false, false);
    chain_.set_timeout(0x1FFFF);                    // one job, then the chips keep scanning it
    for (int k = 0; k < 6 && powered(); k++) {
        std::vector<uint8_t> hdr = kat_header(k);
        uint8_t tail[12], mid[32];
        tail_mid(hdr, tail, mid);
        uint32_t tag = 0x4B415400u | uint32_t(k);   // "KAT" + k
        chain_.push_work(tag, 0, tail, mid);
        chain_.run(true);
        int valid = 0, other = 0;
        std::set<uint32_t> distinct;              // one header has about one diff-1 nonce in 2^32: the chips find it again and again
        double end = now_s() + 1.5;
        while (now_s() < end) {
            if (!pop_nonce(bus, n)) { sleep_ms(2); continue; }
            if (n.chain != chain_.index() || n.tag != tag) continue;
            if (meets_diff1(header_hash(hdr.data(), n.nonce))) { valid++; distinct.insert(n.nonce); }
            else other++;
        }
        chain_.run(false);
        chain_.flush(true, false, false);
        char b[120];
        std::snprintf(b, sizeof b, "KAT ntime+%d: %d distinct valid nonces (%d copies), %d other", k, int(distinct.size()), valid, other);
        say(b);
        out += std::string(b) + "\n";
    }
    chain_.set_timeout(uint32_t(bm::timeout_us(mhz_)));
    out += "(the genesis nonce itself never comes back: it names core 124, which a BM1387 does not have)\n";
    return out;
}

std::string Board::run_skot(Bus& bus) {
    if (!powered()) return "SKOT: power is off\n";
    std::string out;
    std::lock_guard<std::mutex> g(uart);
    chain_.run(false);
    chain_.source(false);
    chain_.flush(true, true, true);
    Nonce n;
    while (pop_nonce(bus, n)) {}
    ChainStat s0 = chain_.stat();
    cmd(bm::cmd_write_reg(-1, bm::REG_MISC, bm::misc_gate(div_)));
    sleep_ms(10);
    for (int x = 0; x < 0x74; x++) { chain_.send_cmd(busy_packet(x)); sleep_ms(5); }
    sleep_ms(300);
    ChainStat s1 = chain_.stat();
    int busy_nonces = 0;
    while (pop_nonce(bus, n)) if (n.chain == chain_.index()) busy_nonces++;
    char b[200];
    std::snprintf(b, sizeof b, "SKOT busy works: %u frames, %d nonces, %u CRC errors", s1.frames - s0.frames, busy_nonces,
                  s1.crc_err - s0.crc_err);
    say(b);
    out += std::string(b) + "\n";
    for (int i = 0; i < 2; i++) {
        std::vector<uint8_t> j = skot_job(i);
        ChainStat a = chain_.stat();
        chain_.send_cmd(j);
        int got = 0;
        uint32_t first = 0;
        double end = now_s() + 1.0;
        while (now_s() < end) {
            if (!pop_nonce(bus, n)) { sleep_ms(2); continue; }
            if (n.chain != chain_.index()) continue;
            if (!got) first = n.nonce;
            got++;
        }
        ChainStat z = chain_.stat();
        std::snprintf(b, sizeof b, "SKOT job %02X: %u frames, %d nonces", j[2], z.frames - a.frames, got);
        std::string l = b;
        if (got) { std::snprintf(b, sizeof b, ", first %08x", first); l += b; }
        say(l);
        out += l + "\n";
        sleep_ms(10);
    }
    return out;
}
