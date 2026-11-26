// [orphan] H4SHR-CH3KR hashrd: the S9 hashboard PIC (voltage controller), port of pic.py.
// bmminer facts (driver-btm-c5.c, GPL-3.0): 7-bit address 0x50 | header, every byte its own I2C transaction, commands
// 55 AA + code, pic = 1608.420446 - 170.423497 x V. Learned on the bench (Ghidra teardown 2026-11-23): it powers up in
// its bootloader (version 0xCC); only 17 and 06 are safe there; 2 ms between transfers; a dummy read resyncs its parser.
// Flash commands (01..05, 08, 09) are never sent.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include "hw.hpp"
#include <cstdint>
#include <functional>
#include <mutex>
#include <stdexcept>
#include <string>
#include <vector>

struct PicError : std::runtime_error {
    using std::runtime_error::runtime_error;
};

class Pic {
public:
    static constexpr double V_MIN = 8.6, V_MAX = 9.40, V_START = 9.0;
    static constexpr uint8_t LOADER = 0xCC, APP_VERSION = 0x03;
    Pic(Hashr& hw, int bus, uint8_t addr7) : hw_(hw), bus_(bus), addr_(addr7) {}
    static int volts_to_pic(double v);
    static double pic_to_volts(int p);
    bool present();
    void wait_present(double seconds = 3.0);
    void resync();
    uint8_t version();
    uint8_t ensure_app(double seconds = 3.0);
    uint8_t reset();                               // 07, then back to the application
    uint8_t reset_l3();                            // L3+ stock order: 07, 1.1 s, 06 always, 1 s (its loader is not 0xCC)
    std::vector<uint8_t> board_id();
    std::vector<uint8_t> temp_table();
    std::vector<int> temp_hosts();                 // chip addresses hosting the sensors (fallback 0xF4 = chip 61)
    void set_voltage(double v);
    double voltage();
    void enable(bool on);
    void heartbeat();
    bool in_app() const { return in_app_; }
    void assume_app() { in_app_ = true; }
    std::function<void(const std::string&, const std::string&)> on_trace;
private:
    void send(std::vector<uint8_t> codes);
    std::vector<uint8_t> read(int n);
    void need_app();
    void trace(const char* kind, const std::string& text) { if (on_trace) on_trace(kind, text); }
    Hashr& hw_;
    int bus_;
    uint8_t addr_;
    bool in_app_ = false;
    std::recursive_mutex lock_;
};
