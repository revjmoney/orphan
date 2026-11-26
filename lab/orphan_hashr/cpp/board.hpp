// [orphan] H4SHR-CH3KR hashrd: one hashboard. Bring-up in bmminer's order, temperatures through the host chip's
// I2C, opening the cores, and the safety rules (owner-present renew timer, 90 C board cut, 60 s no-temperature cut,
// fan curve feed). Port of hashr_service.py.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include "ptimer.hpp"
#include "bm1387.hpp"
#include "hw.hpp"
#include "pic.hpp"
#include <atomic>
#include <deque>
#include <functional>
#include <mutex>
#include <string>
#include <vector>

class Board {
public:
    static constexpr int PCB_MAX_C = 90, TEMP_WINDOW_S = 60;
    Board(Bus& bus, Hashr& hr, Fan& fan, int header);
    bool power_on(double volts, int mhz, std::string& why);   // owner present: only on a command
    void power_off(const std::string& why);
    void tick();                       // once a second: heartbeat, temperatures, cuts, timer, fan feed
    void renew();
    static PowerTimer ptimer;              // the shared owner-present timer setting
    bool open_cores(uint8_t ticket);   // gate, host-chip temperature bits, 114 busy works, ticket, HCN 0, pacing
    bool powered() const { return power_ == ON; }
    bool off() const { return power_ == OFF; }
    int chips() const { return chips_; }
    int pcb_c() const { return pcb_; }
    int chip_c() const { return chip_; }
    int mhz() const { return mhz_; }
    int header() const { return h_; }
    int timer_left() const;
    std::string state_text() const;
    std::string last_off() const { std::lock_guard<std::mutex> g(sm_); return last_off_; }
    Chain& chain() { return chain_; }
    // board controls (the page's): PIC info, voltage, per-chip / per-row clocks with the row balance rule
    static bool balance_ok(const std::vector<int>& mhz_per_chip);   // each row (3 chips) within 25 % of the board mean
    static int pacing_mhz(const std::vector<int>& mhz, const std::vector<bool>& off);   // the mean of the chips not OFF
    static bool volts_ok(double v) { return v >= Pic::V_MIN - 1e-9 && v <= Pic::V_MAX + 1e-9; }
    bool pic_info(std::string& text);
    bool set_volts(double v, std::string& why);
    bool set_chips(const std::vector<int>& chips, int mhz, bool off, std::string& why);   // off = minimum clock
    int chip_mhz(int i) const { std::lock_guard<std::mutex> g(sm_); return i >= 0 && i < int(cmhz_.size()) ? cmhz_[size_t(i)] : 0; }
    bool chip_off(int i) const { std::lock_guard<std::mutex> g(sm_); return i >= 0 && i < int(coff_.size()) && coff_[size_t(i)]; }
    std::string power_name() const { static const char* n[] = {"off", "starting", "on", "stopping"}; return n[int(power_)]; }
    int pic_version() const { return pic_ver_; }       // -1 = not read yet
    double volts_set() const { return volts_set_; }    // -1 = not set
    double volts_read() const { return volts_read_; }
    std::vector<int> pcb_temps() const { std::lock_guard<std::mutex> g(sm_); return pcb_list_; }     // one per sensor
    std::vector<int> chip_temps() const { std::lock_guard<std::mutex> g(sm_); return chip_list_; }
    // diagnostics from the stuck-chain hunt (diag.cpp); each powers the board itself: only with Rev present
    std::string run_hold(double volts, int seconds);   // DC-DC on, chips held in reset, off by itself after seconds
    std::string run_diag(double volts);                // TX/RX normal and swapped x EN on/off: what comes back
    std::string run_rstprobe(double volts);            // which RST level really resets the chips
    std::string run_kat(Bus& bus);                    // genesis + 5 ntime-rolled headers, every nonce re-hashed
    std::string run_skot(Bus& bus);                   // Skot's bm1387_scripts replayed byte for byte
    static std::vector<uint8_t> kat_header(int k);     // the genesis header with ntime + k
    static std::vector<uint8_t> skot_job(int i);       // Skot's job i (0: id 0x74, 1: id 0x75) with its CRC-16
    std::mutex uart;                   // whoever uses the register-reply FIFO holds this
    std::mutex op;                     // one operation at a time (power_on, patterns); power_off never waits for it
    std::function<void(const std::string&)> log;
    std::function<bool()> others_on;   // set by hashrd: another board is not fully off (GO and the fan are shared)
    std::function<void()> on_temp;     // set by hashrd: a new temperature (the fan follows the hottest board)
private:
    bool open_cores_held(uint8_t ticket);   // open_cores with uart held
    enum Power { OFF, STARTING, ON, STOPPING };
    bool wait(double s);               // false when a shutdown happened meanwhile
    void cmd(const std::vector<uint8_t>& c);
    void drain_regs();
    bool read_reg(int chip, uint8_t reg, uint32_t& v, double timeout_s, bool any = false);
    int count();
    void address_pass();
    bool temp_init();
    bool i2c_wait(int reg, uint32_t& v);
    bool temp_reg(uint8_t reg, int& c, int host = -1);   // host -1: temp_host_
    void say(const std::string& s) { if (log) log(s); }
    Bus& bus_;
    Hashr& hr_;
    Fan& fan_;
    Chain chain_;
    Pic pic_;
    int h_;
    std::atomic<int> power_{OFF};
    std::atomic<bool> stop_{false};
    int chips_ = 0, pcb_ = -1, chip_ = -1, mhz_ = 0, div_ = 26, temp_host_ = -1;
    bool pic_up_ = false;
    int seen_chip_ = -1, seen_reg_ = -1;   // address and register bytes of the last register reply
    double dcdc_t_ = 0, last_temp_t_ = 0, timer_end_ = 0, last_hb_ = 0, last_temp_try_ = 0;
    std::string last_off_;
    std::vector<int> cmhz_;            // each chip's clock (MHz), set at power on
    std::vector<bool> coff_;           // chips switched OFF (minimum clock)
    mutable std::mutex sm_;            // the state the page and CYD threads read: clocks, off flags, temperatures, last_off_
    std::vector<int> temp_hosts_;      // every sensor host chip that answered (an S9 board has two)
    std::vector<int> pcb_list_, chip_list_;   // their board and chip readings, -1 = no reading
    double hold_until_ = 0;            // HOLD: chips in reset (no temperatures), powered until this time
    int pic_ver_ = -1;
    double volts_set_ = -1, volts_read_ = -1;
    bool dcdc_up(double volts, bool rst_run, std::string& why);   // DC-DC on, no chip bring-up (diagnostics)
    int count_at(int div);             // chips answering at a baud divider
};
