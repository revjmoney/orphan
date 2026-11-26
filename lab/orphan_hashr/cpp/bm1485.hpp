// [orphan] H4SHR-CH3KR: the BM1485 (Antminer L3+, Scrypt) wire protocol, from Bitmain's stock L3+ cgminer
// (lab-work/l3-re/BM1485-L3plus-protocol.md). Commands: type 0x40 | all<<4 | cmd (0 address, 1 write, 2 read,
// 3 inactive), length byte WITHOUT the CRC, CRC5 as the S9 (bm::crc5). Byte-order trap: register immediates go out LSB
// first, the PLL word MSB first. Works: one 82-byte frame per work id (0..127), ~19 s apart at 384 MHz; replies are the
// S9's 7-byte frames (nonce = b0..b3 big-endian, work id = b5). by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <cstdint>
#include <vector>

namespace bm85 {
constexpr int CHIPS = 72, INTERVAL = 3, DEFAULT_MHZ = 384;
constexpr uint8_t REG_ADDR = 0x00, REG_PLL = 0x08, REG_TICKET = 0x14, REG_MISC = 0x18, REG_I2C = 0x1C,
                  REG_CORE = 0x3C, REG_TEMP = 0x44;
constexpr uint8_t TEMP_HOSTS[2] = {0x0C, 0xC9};   // chips 4 and 67 carry the board sensors (I2C 0x98)
constexpr int CUT_C = 86;                         // stock: PIC off at 86 C on chip 0x0C's local sensor

std::vector<uint8_t> cmd_chain_inactive();
std::vector<uint8_t> cmd_set_address(uint8_t addr);
std::vector<uint8_t> cmd_read_reg(int chip, uint8_t reg);                  // chip -1: all chips
std::vector<uint8_t> cmd_write_imm(int chip, uint8_t reg, uint32_t value); // value LSB first on the wire
std::vector<uint8_t> cmd_pll(int chip, uint32_t word);                     // PLL word MSB first on the wire
std::vector<uint8_t> cmd_ticket_mask(uint32_t mask);                       // all chips, stock's bswap32(mask)
uint32_t pll_for(int mhz, int* actual);            // the stock 100-entry table, rounded down, 100..650 MHz
std::vector<int> mhz_table();
int chip_addr(int i);                              // i * 3
std::vector<uint8_t> work_frame(uint8_t id, const uint8_t header[80]);    // 82 bytes
int timeout_s(int mhz);                            // seconds between works on one chain (stock formula)
int chip_of_nonce(uint32_t nonce);                 // ((nonce >> 20) & 0xFF) / 3
void put_nonce(uint8_t header[80], uint32_t reply_nonce);                 // reply b0..b3 -> header bytes 76..79
bool temps_from_reg44(uint32_t value, int& local_c, int& remote_c);       // false: no reading
}
