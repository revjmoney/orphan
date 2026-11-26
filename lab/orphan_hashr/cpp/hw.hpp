// [orphan] H4SHR-CH3KR hashrd: the FPGA cores. Slot 1 hashr (pins, RST/EN gating, I2C), slot 2 hr_disp (chains),
// slots 3 and 4 hr_build (the work builder), slot 15 orphan_fan. Header h: J1 = 0 .. J9 = 8.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <atomic>
#include "mmio.hpp"
#include "work.hpp"
#include <cstdint>
#include <mutex>
#include <vector>

class Hashr {                                     // slot 1
public:
    static constexpr int SLOT = 1;
    static constexpr uint32_t ID = 0x48535231;    // "HSR1"
    explicit Hashr(Bus& b);
    std::vector<int> pins();                       // 36 levels, hdr[4h + k]: k 0 PLUG, 1 TXD, 2 RXD, 3 RST
    std::vector<int> detect();                     // headers with a board (TXD and RST pulled low while undriven)
    void go(bool on);
    void header(int h, bool en, bool rst_run, bool swap = false);   // swap: TX on pin 12, RX on pin 11
    void en(int h, int level);                     // connector pin 18 via Linux gpio 28 + h; level -1 = input
    bool i2c_write(int bus, uint8_t addr7, const uint8_t* d, int n);
    bool i2c_read(int bus, uint8_t addr7, uint8_t* d, int n);
    std::recursive_mutex lock;
private:
    uint32_t i2c_op(int bus, uint32_t word);
    Bus& b_;
    uint32_t hctrl_[9] = {};
};

struct Nonce { int chain, jid, chip; uint32_t nonce, tag, tag2; };
struct RegReply { int chip, reg; uint32_t value; };
struct ChainStat { int works, cmds; bool sending, full; uint32_t sent, nonces, crc_err, frames, rx_ovf, last_jid; };

class Chain {                                     // slot 2, one chain
public:
    static constexpr int SLOT = 2;
    static constexpr uint32_t ID = 0x48534431;    // "HSD1"
    Chain(Bus& b, int c) : b_(b), c_(c) {}
    void send_cmd(const std::vector<uint8_t>& bytes);   // one atomic command
    void queue_baud(uint16_t cpb);                       // bit time changes after everything queued before it
    void set_cpb(uint16_t cpb);                          // at once (idle only)
    uint16_t cpb();
    void set_timeout(uint32_t us);
    void run(bool on);
    void source(bool builder);                           // CCTRL[4]: works from the FPGA builder, not push_work
    void flush(bool works, bool cmds, bool regs);
    bool push_work(uint32_t tag, uint32_t tag2, const uint8_t tail[12], const uint8_t mid[32]);  // false: FIFO full
    bool pop_reg(RegReply& r);
    ChainStat stat();
    int index() const { return c_; }
    bool running() const { return run_; }
    bool from_builder() const { return src_; }
private:
    int base() const { return 64 + 32 * c_; }
    Bus& b_;
    int c_;
    uint32_t ctrl() const { return (run_ ? 1u : 0u) | (src_ ? 0x10u : 0u); }
    std::atomic<bool> run_{false}, src_{false};
};

class Builder {                                   // slot 3 registers, slot 4 the two job banks (hr_build.v)
public:
    static constexpr int SLOT = 3, MEM = 4;
    static constexpr uint32_t ID = 0x48534231;    // "HSB1"
    explicit Builder(Bus& b) : b_(b) {}
    static std::vector<uint32_t> bank_image(const Job& j);
    void write_bank(int bank, const Job& j);       // write the bank that is not active, then flip to it
    void flip(int bank, bool clean);               // en2 restarts at the bank's EN2_START; clean drops queued works
    void enable(bool on);
    uint32_t built();
    uint32_t stalls();
    bool exhausted();
private:
    Bus& b_;
    bool en_ = false;
};

bool pop_nonce(Bus& b, Nonce& n);
uint32_t nonces_waiting(Bus& b);

class Fan {                                       // slot 15
public:
    static constexpr int SLOT = 15;
    explicit Fan(Bus& b) : b_(b) {}
    void rules(bool on, bool auto_curve);
    void temp(int c);
    void powered(bool on);
    void duty(int pct);                            // manual duty; never below 20 in effect
    void curve(int lo_c, int hi_c);
    int applied();
    bool watchdog();
    bool auto_curve();                             // MODE bit 0: the curve rules (else DUTY)
    int duty_set();                                // DUTY as last written (VIZOR's slider or hashrd)
    int curve_lo();
    int curve_hi();
    int rpm(int i);
private:
    Bus& b_;
};
