// [orphan] H4SHR-CH3KR hashrd: BM1387 commands, CRCs, PLL table and Bitmain's pacing (port of bm1387.py).
// Protocol facts from Bitmain's bmminer for the S9 (driver-btm-c5.c / .h, GPL-3.0) and cgminer driver-gekko (GPL-3.0).
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <cstdint>
#include <vector>

namespace bm {
constexpr uint8_t REG_ADDR = 0x00, REG_HASHCOUNT = 0x08, REG_PLL = 0x0C, REG_HCN = 0x14, REG_TICKET = 0x18,
                  REG_MISC = 0x1C, REG_I2C = 0x20;
constexpr int CHIPS = 63, ROWS = 21;
constexpr uint32_t CHIP_ID = 0x1387;
constexpr uint8_t TEMP_DEV = 0x98;               // the S9 board's temperature sensor (8-bit address)

uint8_t crc5(const uint8_t* d, int n);           // host commands: init 0x1F, over every byte
uint8_t crc5_bits(const uint8_t* d, int nbits);  // replies: bmminer CRC5 over the first nbits bits
uint16_t crc16_false(const uint8_t* d, int n);   // job packets: CRC-16/CCITT-FALSE
bool frame_ok(const uint8_t f[7]);               // CRC5 over 51 bits matches and byte 6 bits 6:5 are 0

std::vector<uint8_t> cmd_chain_inactive();
std::vector<uint8_t> cmd_set_address(uint8_t addr);
std::vector<uint8_t> cmd_read_reg(int chip, uint8_t reg);              // chip -1 = all
std::vector<uint8_t> cmd_write_reg(int chip, uint8_t reg, uint32_t v); // chip -1 = all, value MSB first

uint32_t pll_for(int mhz, int* actual);          // freq_pll_1385 (vilpll column), 200..650 MHz
std::vector<int> mhz_table();                    // every clock the PLL table has (the page's pickers)
uint32_t misc_value(int div, bool temp_mode);    // plain: 00 20 div 00; temperature mode: 40 21 div|0x40 60
uint32_t misc_gate(int div);                     // open core, all chips: 40 20 div|0x80 80
uint32_t misc_gate_temp_host(int div);           // the temperature host chip: 40 21 div|0xC0 E0
int baud_div_for_freq(int mhz);                  // bmminer: 200 -> 7, 400 -> 3, 650 -> 1
int cpb_for_div(int div);                        // our clocks per bit at 100 MHz: 32 * (div + 1)
uint32_t timeout_us(int mhz);                    // bmminer c:6379: 2^24 / 128 * 4 / MHz * 0.9
uint32_t i2c_cmd_value(uint8_t dev8, uint8_t reg, uint8_t data, bool write);
int chip_addr(int i);
// sensor byte -> C (extended range, offset 64). Below 0 C means the sensor lost its extended-range setting: rejected,
// like FF / 7F, so a lost config can never read 64 C low and hide heat.
bool temp_c(uint8_t d, int& c);
}
