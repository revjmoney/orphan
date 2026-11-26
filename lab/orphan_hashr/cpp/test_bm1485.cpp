// [orphan] H4SHR-CH3KR: BM1485 (Antminer L3+, Scrypt) frames against the bytes Bitmain's stock L3+ cgminer sends
// (lab-work/l3-re/BM1485-L3plus-protocol.md 2.1, 3.1, 3.2, 3.3, 6).
//   g++ -O2 -std=c++17 -o test_bm1485 test_bm1485.cpp bm1485.cpp bm1387.cpp && ./test_bm1485
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "bm1387.hpp"
#include "bm1485.hpp"
#include "l3board.hpp"
#include <cstdio>
#include <vector>

static int pass = 0, total = 0;
static void check(bool ok, const char* name) {
    total++;
    if (ok) pass++;
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", name);
}
static std::vector<uint8_t> hex(const char* s) {
    std::vector<uint8_t> v;
    unsigned x;
    while (*s) {
        if (*s == ' ') { s++; continue; }
        if (std::sscanf(s, "%2x", &x) != 1) break;
        v.push_back(uint8_t(x));
        s += 2;
    }
    return v;
}

int main() {
    using namespace bm85;
    check(cmd_chain_inactive() == hex("53 04 00 00 1B"), "chain inactive == 53 04 00 00 1B");
    check(cmd_read_reg(-1, 0x00) == hex("52 04 00 00 12"), "read reg 0 from all == 52 04 00 00 12");
    check(cmd_read_reg(0x0C, 0x44) == hex("42 04 0C 44 01"), "read reg 0x44 from chip 0x0C == 42 04 0C 44 01");
    check(cmd_set_address(0x00) == hex("40 04 00 00 04") && cmd_set_address(0x03) == hex("40 04 03 00 05"),
          "set address 0 / 3");
    int actual = 0;
    check(pll_for(384, &actual) == 0x007B0241 && actual == 384, "pll_for(384) == 007B0241");
    check(cmd_pll(-1, pll_for(384, nullptr)) == hex("51 08 00 08 00 7B 02 41 06"),
          "PLL 384 MHz, all chips: the word goes out MSB first");
    check(cmd_write_imm(-1, REG_MISC, 0x103a4041) == hex("51 08 00 18 41 40 3A 10 00"),
          "MISC all chips: an immediate goes out LSB first");
    check(cmd_write_imm(0x0C, REG_MISC, 0x707a4041) == hex("41 08 0C 18 41 40 7A 70 10"), "MISC chip 0x0C");
    check(cmd_ticket_mask(0xFF) == hex("51 08 00 14 00 00 00 FF 1D"), "ticket mask 0xFF");
    check(pll_for(386, &actual) == 0x007B0241 && actual == 384 && pll_for(50, &actual) == 0x00400242 && actual == 100 &&
              pll_for(900, &actual) == 0x00680221 && actual == 650 && mhz_table().size() == 100,
          "pll_for rounds down to the table, clamps to 100..650, 100 entries");
    {
        uint8_t h[80];
        for (int i = 0; i < 80; i++) h[i] = uint8_t(i);
        std::vector<uint8_t> f = work_frame(0x85, h);
        bool words = f.size() == 82;
        for (int w = 0; words && w < 19; w++)          // frame word k = header word 18 - k, bytes in header order
            for (int k = 0; k < 4; k++) words = words && f[size_t(4 + 4 * w + k)] == h[4 * (18 - w) + k];
        uint16_t crc = bm::crc16_false(f.data(), 80);
        check(words && f[0] == 0x20 && f[1] == 0x50 && f[2] == 0x05 && f[3] == 0x00 &&
                  f[80] == uint8_t(crc >> 8) && f[81] == uint8_t(crc),
              "work frame: 20 50 id&7F 00, header words reversed (nonce dropped), CRC-16 big-endian");
    }
    check(timeout_s(384) == 19, "pacing at 384 MHz: 19 s per work per chain");
    check(chip_of_nonce(0x0A3FFFFF) == 0xA3 / 3 && chip_of_nonce(0x00000000) == 0, "chip from nonce: ((n>>20)&0xFF)/3");
    {
        uint8_t h[80] = {};
        put_nonce(h, 0x11223344);
        check(h[76] == 0x11 && h[77] == 0x22 && h[78] == 0x33 && h[79] == 0x44, "reply nonce b0..b3 -> header 76..79");
    }
    {
        int local = 0, remote = 0;
        check(temps_from_reg44(0x00340029u, local, remote) && local == 0x34 && remote == 0x29 &&
                  !temps_from_reg44(0x00000000u, local, remote),
              "reg 0x44 (value = b0<<24 .. b3, as the FPGA packs it): byte 1 local, byte 3 remote; zero = no reading");
    }
    // per-chip clock: chip 5 is address 15 (0x0F), unicast 0x41, same PLL word bytes as the broadcast
    {
        std::vector<uint8_t> want = {0x41, 0x08, 0x0F, 0x08, 0x00, 0x7B, 0x02, 0x41};
        want.push_back(bm::crc5(want.data(), int(want.size())));
        check(cmd_pll(chip_addr(5), pll_for(384, nullptr)) == want, "per-chip PLL: chip 5 = address 0x0F, unicast");
    }
    {
        int a = 0;
        pll_for(0, &a);
        check(a == 100, "OFF = the table's lowest clock, 100 MHz");
    }
    {   // rows of 3 within 25 % of the board average; chips that are off do not count
        std::vector<int> m(72, 384);
        std::vector<bool> off(72, false);
        check(L3Board::row_balance_ok(m, off), "row balance: all at 384 is fine");
        m[0] = m[1] = m[2] = 250;
        check(!L3Board::row_balance_ok(m, off), "row balance: one row at 250 of 384 is refused");
        off[0] = off[1] = off[2] = true;
        check(L3Board::row_balance_ok(m, off), "row balance: a row that is off does not count");
        check(L3Board::pacing_mhz(m, off) == 384, "pace = mean of the chips that are on");
    }
    {   // chip test verdicts
        std::vector<int> v(72, 20), b(72, 0);
        std::vector<bool> off(72, false);
        v[3] = 0; v[7] = 4; b[9] = 10; off[11] = true;
        auto r = l3_verdicts(v, b, off);
        check(r[0] == "ok" && r[3] == "dead" && r[7] == "weak" && r[9] == "bad" && r[11] == "off",
              "verdicts: ok / dead / weak (<30 %) / bad (>1 in 4 failed) / off");
        auto f = l3_verdicts(std::vector<int>(72, 2), std::vector<int>(72, 0), std::vector<bool>(72, false));
        check(f[0] == "few", "verdicts: an average under 5 nonces per chip is 'few' (run it longer)");
    }
    std::printf("%s %d/%d\n", pass == total ? "PASS" : "FAIL", pass, total);
    return pass == total ? 0 : 1;
}
