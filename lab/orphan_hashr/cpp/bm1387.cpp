// [orphan] H4SHR-CH3KR hashrd: BM1387. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "bm1387.hpp"

namespace bm {
namespace {
struct PllEntry { int mhz; uint32_t word; };
// bmminer driver-btm-c5.h freq_pll_1385, 4th column ("vilpll"), 200 to 650 MHz
const PllEntry PLL[] = {
    {200, 0x400241}, {225, 0x480241}, {250, 0x500241}, {275, 0x580241}, {300, 0x600241}, {325, 0x680241},
    {350, 0x700241}, {375, 0x780241}, {400, 0x800241}, {404, 0x610231}, {406, 0x410221}, {408, 0x620231},
    {412, 0x420221}, {416, 0x640231}, {418, 0x430221}, {420, 0x650231}, {425, 0x440221}, {429, 0x670231},
    {431, 0x450221}, {433, 0x680231}, {437, 0x460221}, {441, 0x6A0231}, {443, 0x470221}, {445, 0x6B0231},
    {450, 0x480221}, {454, 0x6D0231}, {456, 0x490221}, {458, 0x6E0231}, {462, 0x4A0221}, {466, 0x700231},
    {468, 0x4B0221}, {470, 0x710231}, {475, 0x4C0221}, {479, 0x730231}, {481, 0x4D0221}, {483, 0x740231},
    {487, 0x4E0221}, {491, 0x760231}, {493, 0x4F0221}, {495, 0x770231}, {500, 0x500221}, {504, 0x790231},
    {506, 0x510221}, {508, 0x7A0231}, {512, 0x520221}, {516, 0x7C0231}, {518, 0x530221}, {520, 0x7D0231},
    {525, 0x540221}, {529, 0x7F0231}, {531, 0x550221}, {533, 0x800231}, {537, 0x560221}, {543, 0x570221},
    {550, 0x580221}, {556, 0x590221}, {562, 0x5A0221}, {568, 0x5B0221}, {575, 0x5C0221}, {581, 0x5D0221},
    {587, 0x5E0221}, {593, 0x5F0221}, {600, 0x600221}, {606, 0x610221}, {612, 0x620221}, {618, 0x630221},
    {625, 0x640221}, {631, 0x650221}, {637, 0x660221}, {643, 0x670221}, {650, 0x680221},
};

std::vector<uint8_t> pkt(std::vector<uint8_t> body) {
    body.push_back(crc5(body.data(), int(body.size())));
    return body;
}
}

uint8_t crc5(const uint8_t* d, int n) {
    uint8_t crc = 0x1F;
    for (int k = 0; k < n; k++)
        for (int i = 7; i >= 0; i--) {
            int top = (crc >> 4) & 1;
            crc = (crc << 1) & 0x1F;
            if (((d[k] >> i) & 1) ^ top) crc ^= 0x05;
        }
    return crc;
}

uint8_t crc5_bits(const uint8_t* d, int nbits) {
    int c[5] = {1, 1, 1, 1, 1};
    for (int i = 0; i < nbits; i++) {
        int bit = (d[i / 8] >> (7 - (i % 8))) & 1;
        int c1 = c[1];
        c[1] = c[0];
        c[0] = c[4] ^ bit;
        c[4] = c[3];
        c[3] = c[2];
        c[2] = c1 ^ c[0];
    }
    return uint8_t(c[4] * 16 | c[3] * 8 | c[2] * 4 | c[1] * 2 | c[0]);
}

uint16_t crc16_false(const uint8_t* d, int n) {
    uint16_t c = 0xFFFF;
    for (int k = 0; k < n; k++) {
        c ^= uint16_t(d[k]) << 8;
        for (int i = 0; i < 8; i++) c = (c & 0x8000) ? uint16_t((c << 1) ^ 0x1021) : uint16_t(c << 1);
    }
    return c;
}

bool frame_ok(const uint8_t f[7]) { return crc5_bits(f, 51) == (f[6] & 0x1F) && ((f[6] >> 5) & 3) == 0; }

std::vector<uint8_t> cmd_chain_inactive() { return pkt({0x55, 0x05, 0x00, 0x00}); }
std::vector<uint8_t> cmd_set_address(uint8_t addr) { return pkt({0x41, 0x05, addr, 0x00}); }

std::vector<uint8_t> cmd_read_reg(int chip, uint8_t reg) {
    if (chip < 0) return pkt({0x54, 0x05, 0x00, reg});
    return pkt({0x44, 0x05, uint8_t(chip), reg});
}

std::vector<uint8_t> cmd_write_reg(int chip, uint8_t reg, uint32_t v) {
    return pkt({uint8_t(chip < 0 ? 0x58 : 0x48), 0x09, uint8_t(chip < 0 ? 0 : chip), reg,
                uint8_t(v >> 24), uint8_t(v >> 16), uint8_t(v >> 8), uint8_t(v)});
}

uint32_t pll_for(int mhz, int* actual) {
    const PllEntry* best = &PLL[0];
    for (const auto& e : PLL)
        if (e.mhz <= mhz) best = &e;
    if (actual) *actual = best->mhz;
    return best->word;
}

uint32_t misc_value(int div, bool temp_mode) {
    if (temp_mode) return (0x40u << 24) | (0x21u << 16) | (uint32_t((div & 0x1F) | 0x40) << 8) | 0x60;
    return (0x20u << 16) | (uint32_t(div & 0x1F) << 8);
}

uint32_t misc_gate(int div) { return (0x40u << 24) | (0x20u << 16) | (uint32_t((div & 0x1F) | 0x80) << 8) | 0x80; }
uint32_t misc_gate_temp_host(int div) {
    return (0x40u << 24) | (0x21u << 16) | (uint32_t((div & 0x1F) | 0xC0) << 8) | 0xE0;
}

int baud_div_for_freq(int mhz) {
    double timeout = 16777216.0 / 128 * 4 / mhz * 0.9;
    double rbaud = 1e6 * 5 / 3 / timeout * 512;
    int div = int(25e6 / rbaud / 8 - 1);
    return div < 0 ? 0 : (div > 26 ? 26 : div);
}

int cpb_for_div(int div) { return 32 * (div + 1); }

uint32_t timeout_us(int mhz) {
    uint32_t t = uint32_t(16777216.0 / 128 * 4 / mhz * 0.9);
    return t > 0x1FFFF ? 0x1FFFF : t;
}

uint32_t i2c_cmd_value(uint8_t dev8, uint8_t reg, uint8_t data, bool write) {
    return (0x01u << 24) | (uint32_t(dev8 | (write ? 1 : 0)) << 16) | (uint32_t(reg) << 8) | data;
}

int chip_addr(int i) { return 4 * i; }

bool temp_c(uint8_t d, int& c) {
    if (d == 0xFF || d == 0x7F || d < 64) return false;
    c = d - 64;
    return true;
}
}

namespace bm {
std::vector<int> mhz_table() {
    std::vector<int> v;
    for (const auto& e : PLL) v.push_back(e.mhz);
    return v;
}
}
