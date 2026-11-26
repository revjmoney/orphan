// [orphan] H4SHR-CH3KR hashrd: FPGA core access. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "hw.hpp"
#include <chrono>
#include <fstream>
#include <stdexcept>
#include <string>
#include <thread>
#include <unistd.h>

namespace {
constexpr uint32_t I2C_START_W = 0u << 8, I2C_W = 1u << 8, I2C_R_ACK = 2u << 8, I2C_R_NACK = 3u << 8;
constexpr uint32_t I2C_STOP = 1u << 10;
constexpr uint32_t I2C_DIV_SLOW = 1250;          // 20 kHz: the hashboard PICs are slow I2C slaves
constexpr uint32_t EN = 1, RST_RUN = 2;

void sleep_us(int us) { std::this_thread::sleep_for(std::chrono::microseconds(us)); }

void write_file(const std::string& path, const std::string& v) {
    std::ofstream f(path);
    f << v;
}

uint32_t be32(const uint8_t* p) { return uint32_t(p[0]) << 24 | uint32_t(p[1]) << 16 | uint32_t(p[2]) << 8 | p[3]; }
}

Hashr::Hashr(Bus& b) : b_(b) {
    if (b_.rd(SLOT, 127) != ID) throw std::runtime_error("HASHR core not found in slot 1 (load orphan_hashr)");
    if (b_.rd(2, 127) != 0x48534431) throw std::runtime_error("dispatcher not found in slot 2 (old bitstream?)");
    go(false);
    b_.wr(SLOT, 5, I2C_DIV_SLOW);
}

std::vector<int> Hashr::pins() {
    std::lock_guard<std::recursive_mutex> g(lock);
    uint64_t v = b_.rd(SLOT, 1) | (uint64_t(b_.rd(SLOT, 2) & 0xF) << 32);
    std::vector<int> p(36);
    for (int i = 0; i < 36; i++) p[i] = (v >> i) & 1;
    return p;
}

std::vector<int> Hashr::detect() {
    auto p = pins();
    std::vector<int> out;
    for (int h = 0; h < 9; h++)
        if (!(hctrl_[h] & EN) && p[4 * h + 1] == 0 && p[4 * h + 3] == 0) out.push_back(h);
    return out;
}

void Hashr::go(bool on) {
    std::lock_guard<std::recursive_mutex> g(lock);
    b_.wr(SLOT, 0, on ? 1 : 0);
}

void Hashr::header(int h, bool en_, bool rst_run, bool swap) {
    std::lock_guard<std::recursive_mutex> g(lock);
    hctrl_[h] = (en_ ? EN : 0) | (rst_run ? RST_RUN : 0) | (swap ? 0x10u : 0u);
    b_.wr(SLOT, 16 + 8 * h, hctrl_[h]);
}

void Hashr::en(int h, int level) {
    const int n = 28 + h;
    const std::string path = "/sys/class/gpio/gpio" + std::to_string(n);
    if (access(path.c_str(), F_OK) != 0) {
        write_file("/sys/class/gpio/export", std::to_string(n));
        sleep_us(50000);
    }
    if (level < 0) {
        write_file(path + "/direction", "in");
        return;
    }
    write_file(path + "/direction", "out");
    write_file(path + "/value", level ? "1" : "0");
}

uint32_t Hashr::i2c_op(int bus, uint32_t word) {
    const int reg = bus == 1 ? 3 : 4;
    b_.wr(SLOT, reg, word);
    auto end = std::chrono::steady_clock::now() + std::chrono::milliseconds(50);
    for (;;) {
        uint32_t st = b_.rd(SLOT, reg);
        if (!(st >> 31)) return st;
        if (std::chrono::steady_clock::now() > end) throw std::runtime_error("I2C bus stuck (SCL held low?)");
        sleep_us(200);
    }
}

bool Hashr::i2c_write(int bus, uint8_t addr7, const uint8_t* d, int n) {
    std::lock_guard<std::recursive_mutex> g(lock);
    uint32_t st = i2c_op(bus, I2C_START_W | ((addr7 << 1) & 0xFE) | (n ? 0 : I2C_STOP));
    if (st & 0x100) {
        if (n) i2c_op(bus, I2C_R_NACK | I2C_STOP);
        return false;
    }
    for (int i = 0; i < n; i++) {
        st = i2c_op(bus, I2C_W | d[i] | (i == n - 1 ? I2C_STOP : 0));
        if (st & 0x100) {
            if (i != n - 1) i2c_op(bus, I2C_R_NACK | I2C_STOP);
            return false;
        }
    }
    return true;
}

bool Hashr::i2c_read(int bus, uint8_t addr7, uint8_t* d, int n) {
    std::lock_guard<std::recursive_mutex> g(lock);
    uint32_t st = i2c_op(bus, I2C_START_W | (uint32_t(addr7) << 1) | 1);
    if (st & 0x100) {
        i2c_op(bus, I2C_R_NACK | I2C_STOP);
        return false;
    }
    for (int i = 0; i < n; i++) {
        st = i2c_op(bus, i == n - 1 ? (I2C_R_NACK | I2C_STOP) : I2C_R_ACK);
        d[i] = st & 0xFF;
    }
    return true;
}

// ------------------------------------------------------------------ chains
void Chain::send_cmd(const std::vector<uint8_t>& bytes) {
    for (uint8_t v : bytes) b_.wr(SLOT, base() + 3, v);
    b_.wr(SLOT, base() + 3, 0x100);
}

void Chain::queue_baud(uint16_t cpb) { b_.wr(SLOT, base() + 4, cpb); }
void Chain::set_cpb(uint16_t cpb) { b_.wr(SLOT, base() + 1, cpb); }
uint16_t Chain::cpb() { return b_.rd(SLOT, base() + 1) & 0xFFFF; }
void Chain::set_timeout(uint32_t us) { b_.wr(SLOT, base() + 2, us > 0x1FFFF ? 0x1FFFF : us); }

void Chain::run(bool on) {
    run_ = on;
    b_.wr(SLOT, base() + 0, ctrl());
}

void Chain::source(bool builder) {
    src_ = builder;
    b_.wr(SLOT, base() + 0, ctrl());
}

void Chain::flush(bool works, bool cmds, bool regs) {
    for (int i = 0; i < 200 && (b_.rd(SLOT, base() + 6) & (1u << 16)); i++) usleep(100);   // let the packet end
    b_.wr(SLOT, base() + 0, ctrl() | (works ? 2 : 0) | (cmds ? 4 : 0) | (regs ? 8 : 0));
}

bool Chain::push_work(uint32_t tag, uint32_t tag2, const uint8_t tail[12], const uint8_t mid[32]) {
    if (b_.rd(SLOT, base() + 6) & (1u << 17)) return false;
    b_.wr(SLOT, base() + 8, tag);
    b_.wr(SLOT, base() + 9, tag2);
    for (int i = 0; i < 3; i++) b_.wr(SLOT, base() + 10 + i, be32(tail + 4 * i));
    for (int i = 0; i < 8; i++) b_.wr(SLOT, base() + 13 + i, be32(mid + 4 * i));
    b_.wr(SLOT, base() + 5, 1);
    return true;
}

bool Chain::pop_reg(RegReply& r) {
    uint32_t v = b_.rd(SLOT, base() + 21);
    if (!(v >> 31)) return false;
    r.chip = (v >> 8) & 0xFF;
    r.reg = v & 0xFF;
    r.value = b_.rd(SLOT, base() + 22);
    return true;
}

ChainStat Chain::stat() {
    uint32_t s = b_.rd(SLOT, base() + 6);
    ChainStat c;
    c.works = s & 0x1F;
    c.cmds = (s >> 8) & 0x1F;
    c.sending = (s >> 16) & 1;
    c.full = (s >> 17) & 1;
    c.sent = b_.rd(SLOT, base() + 23);
    c.nonces = b_.rd(SLOT, base() + 24);
    c.crc_err = b_.rd(SLOT, base() + 25);
    c.frames = b_.rd(SLOT, base() + 26);
    c.rx_ovf = b_.rd(SLOT, base() + 27);
    c.last_jid = b_.rd(SLOT, base() + 28);
    return c;
}

uint32_t nonces_waiting(Bus& b) { return b.rd(Chain::SLOT, 1); }

bool pop_nonce(Bus& b, Nonce& n) {
    uint32_t v = b.rd(Chain::SLOT, 2);
    if (!(v >> 31)) return false;
    n.chain = (v >> 24) & 0xF;
    n.jid = (v >> 16) & 0x7F;
    n.chip = v & 0x3F;
    n.nonce = b.rd(Chain::SLOT, 3);
    n.tag = b.rd(Chain::SLOT, 4);
    n.tag2 = b.rd(Chain::SLOT, 5);
    return true;
}

// ------------------------------------------------------------------ fans
void Fan::rules(bool on, bool auto_curve) { b_.wr(SLOT, 9, (on ? 2 : 0) | (auto_curve ? 1 : 0)); }
void Fan::temp(int c) { b_.wr(SLOT, 10, c < 0 ? 0 : (c > 255 ? 255 : c)); }
void Fan::powered(bool on) { b_.wr(SLOT, 11, on ? 1 : 0); }
void Fan::duty(int pct) { b_.wr(SLOT, 1, pct < 0 ? 0 : (pct > 100 ? 100 : pct)); }
void Fan::curve(int lo_c, int hi_c) { b_.wr(SLOT, 12, lo_c); b_.wr(SLOT, 13, hi_c); }
int Fan::applied() { return b_.rd(SLOT, 14) & 0x7F; }
bool Fan::watchdog() { return b_.rd(SLOT, 15) & 1; }
bool Fan::auto_curve() { return b_.rd(SLOT, 9) & 1; }
int Fan::duty_set() { return b_.rd(SLOT, 1) & 0x7F; }
int Fan::curve_lo() { return b_.rd(SLOT, 12) & 0xFF; }
int Fan::curve_hi() { return b_.rd(SLOT, 13) & 0xFF; }
int Fan::rpm(int i) { return int(b_.rd(SLOT, 2 + i)) * 30; }

// ------------------------------------------------------------------ work builder (slots 3 and 4)
std::vector<uint32_t> Builder::bank_image(const Job& j) { return ::bank_image(j); }

void Builder::write_bank(int bank, const Job& j) {
    std::vector<uint32_t> m = bank_image(j);
    for (int i = 0; i < 512; i++) b_.wr(MEM, 512 * (bank & 1) + i, m[i]);
}

void Builder::flip(int bank, bool clean) {
    b_.wr(SLOT, 1, (en_ ? 1u : 0u) | (bank & 1 ? 2u : 0u) | 4u | (clean ? 8u : 0u));
}

void Builder::enable(bool on) {
    en_ = on;
    b_.wr(SLOT, 1, on ? 1u : 0u);
}

uint32_t Builder::built() { return b_.rd(SLOT, 3); }
uint32_t Builder::stalls() { return b_.rd(SLOT, 4); }
bool Builder::exhausted() { return (b_.rd(SLOT, 2) >> 1) & 1; }
