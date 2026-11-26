// [orphan] H4SHR-CH3KR hashrd: one Antminer L3+ hashboard (72 x BM1485, Scrypt) on a J header of the S9 control board.
// A sibling of Board (the S9 one), so the S9 path stays as it is. Stock L3+ order (lab-work/l3-re/BM1485-L3plus-
// protocol.md 2.3): PIC reset -> app, DC-DC on (NO voltage command: stock never sets one, the PIC's own default runs
// the board), 5 s, reset pulse twice, count, address 0, 3, 6 ..., PLL, MISC, sensor, open blocks, ticket mask 0xFF.
// Safety: owner-present timer, PIC heartbeat, 86 C cut (stock), no temperature for 60 s cut. Works come from the ARM
// (scrypt_sink.hpp) through the chain's raw command path; the chain's FPGA work sender stays off.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include "bm1485.hpp"
#include "hw.hpp"
#include "pic.hpp"
#include <atomic>
#include <functional>
#include <mutex>
#include <string>
#include <vector>

// The L3+ chip test's verdict per chip from its counts over the test: "off" (switched off), "dead" (no nonce
// while the others averaged 5 or more), "weak" (under 30 % of the average of the chips that are on, average 5 or
// more), "bad" (more than 1 nonce in 4 failed the ARM's scrypt check), else "ok"; "few" when the average is
// under 5 (run it longer).
std::vector<std::string> l3_verdicts(const std::vector<int>& valid, const std::vector<int>& bad, const std::vector<bool>& off);

class L3Board {
public:
    static constexpr int TEMP_WINDOW_S = 60;
    L3Board(Bus& bus, Hashr& hr, Fan& fan, int header);
    bool power_on(int mhz, std::string& why);      // owner present: only on a command
    void power_off(const std::string& why);
    void tick();                                   // once a second: heartbeat, temperatures, cuts, timer, fan feed
    void renew();
    bool powered() const { return power_ == ON; }
    bool off() const { return power_ == OFF; }
    int chips() const { return chips_; }
    int pcb_c() const { return pcb_; }             // board sensor (local)
    int chip_c() const { return chip_; }           // remote diode
    int mhz() const { return mhz_; }
    int chip_mhz(int i) const { std::lock_guard<std::mutex> g(sm_); return i >= 0 && i < int(cmhz_.size()) ? cmhz_[size_t(i)] : 0; }
    bool chip_off(int i) const { std::lock_guard<std::mutex> g(sm_); return i >= 0 && i < int(coff_.size()) && coff_[size_t(i)]; }
    // chips (0..71) to mhz, or OFF (the table's lowest clock, 100 MHz; the miner and the chip test count them out).
    // Works are held while the PLLs change, then each chip's cores are opened again; the caller kicks a fresh work.
    bool set_chips(const std::vector<int>& chips, int mhz, bool off, std::string& why);
    static bool row_balance_ok(const std::vector<int>& mhz, const std::vector<bool>& off);   // rows of 3, +-25 %
    static int pacing_mhz(const std::vector<int>& mhz, const std::vector<bool>& off);        // mean of chips not off
    int header() const { return h_; }
    int timer_left() const;
    std::string state_text() const;
    std::string power_name() const { static const char* n[] = {"off", "starting", "on", "stopping"}; return n[int(power_)]; }
    std::string last_off() const { std::lock_guard<std::mutex> g(sm_); return last_off_; }
    Chain& chain() { return chain_; }
    void send(const std::vector<uint8_t>& frame) { if (!hold_) tx(frame); }   // a work (dropped while clocks change)
    std::function<void(const std::string&)> log;
    std::function<bool()> others_on;               // another board keeps GO high
    std::function<void()> on_temp;
    std::mutex op, uart;
private:
    enum Power { OFF, STARTING, ON, STOPPING };
    bool wait(double s);
    void tx(const std::vector<uint8_t>& f) { std::lock_guard<std::mutex> g(cmd_mu_); chain_.send_cmd(f); }   // one command at a time
    void say(const std::string& s) { if (log) log("J" + std::to_string(h_ + 1) + " L3+: " + s); }
    int count_chips(double seconds);
    Hashr& hr_;
    Fan& fan_;
    Chain chain_;
    Pic pic_;
    int h_;
    std::atomic<Power> power_{OFF};
    std::atomic<bool> stop_{false};
    std::atomic<int> chips_{0}, pcb_{-1}, chip_{-1}, mhz_{0};
    std::atomic<bool> hold_{false};
    std::vector<int> cmhz_ = std::vector<int>(bm85::CHIPS, 0);      // each chip's clock (MHz)
    std::vector<bool> coff_ = std::vector<bool>(bm85::CHIPS, false);
    bool pic_up_ = false;
    double dcdc_t_ = 0, last_temp_t_ = 0, timer_end_ = 0, last_hb_ = 0, last_temp_try_ = 0;
    mutable std::mutex sm_;
    std::mutex cmd_mu_;                            // the work feeder and the temperature reads share the chain
    std::string last_off_;
};
