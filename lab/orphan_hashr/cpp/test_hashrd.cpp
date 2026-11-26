// [orphan] H4SHR-CH3KR hashrd: known-answer checks for the BM1387 and PIC math (no hardware touched).
//   g++ -O2 -std=c++17 -o test_hashrd test_hashrd.cpp board.cpp diag.cpp bm1387.cpp pic.cpp hw.cpp mmio.cpp work.cpp sha256.cpp && ./test_hashrd
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "bm1387.hpp"
#include "board.hpp"
#include "fanctl.hpp"
#include "hw.hpp"
#include "pic.hpp"
#include "work.hpp"
#include <algorithm>
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
    while (*s && std::sscanf(s, "%2x", &x) == 1) { v.push_back(uint8_t(x)); s += 2; }
    return v;
}

int main() {
    auto skot = hex("2136740100000000f91e0e178020cc6061815505003606533262a24121a03cb243e3c05349fc207a9d5de084e662147599cb969c");
    check(bm::crc16_false(skot.data(), int(skot.size())) == 0xC6BB, "crc16_false(Skot job 0x74) == C6BB");
    check(bm::cmd_chain_inactive() == hex("5505000010"), "chain inactive == 55 05 00 00 10");
    check(bm::cmd_set_address(4) == hex("410504000a"), "set address 4 == 41 05 04 00 0A");
    check(bm::cmd_write_reg(-1, bm::REG_MISC, bm::misc_value(7, false)) == hex("5809001c0020070019"),
          "write misc divider 7 == 58 09 00 1C 00 20 07 00 19");
    for (const char* f : {"5f275ce0007495", "0b683c0600759e", "2f28a626004595", "13879000000007"})
        check(bm::frame_ok(hex(f).data()), f);
    check(!bm::frame_ok(hex("13879000000008").data()), "bad CRC rejected");
    check(bm::timeout_us(200) == 2359 && bm::timeout_us(400) == 1179 && bm::timeout_us(650) == 725,
          "timeout_us 200/400/650 == 2359/1179/725");
    check(bm::baud_div_for_freq(200) == 7 && bm::baud_div_for_freq(400) == 3 && bm::baud_div_for_freq(650) == 1,
          "baud divider 200/400/650 == 7/3/1");
    check(bm::cpb_for_div(7) == 256 && bm::cpb_for_div(26) == 864, "clocks per bit 7 -> 256, 26 -> 864");
    int actual = 0;
    check(bm::pll_for(400, &actual) == 0x800241 && actual == 400, "pll_for(400) == 0x800241");
    check(bm::pll_for(401, &actual) == 0x800241 && actual == 400, "pll_for(401) rounds down to 400");
    check(Pic::volts_to_pic(9.0) == 74, "PIC byte for 9.0 V == 74");
    check(bm::misc_gate(7) == 0x40208780u && bm::misc_gate_temp_host(7) == 0x4021C7E0u, "open-core misc values");
    int tc = 0;
    check(bm::temp_c(64 + 30, tc) && tc == 30, "temperature byte 94 -> 30 C (extended range)");
    check(!bm::temp_c(25, tc) && !bm::temp_c(0x7F, tc) && !bm::temp_c(0xFF, tc),
          "temperature bytes 25 (standard range: config lost), 7F, FF rejected");
    {
        std::vector<uint32_t> want;                // what cpp/test_work wrote for the FPGA testbench
        FILE* f = std::fopen("../sim/vec/genesis_bank.hex", "r");
        unsigned w;
        while (f && std::fscanf(f, "%x", &w) == 1) want.push_back(w);
        if (f) std::fclose(f);
        check(want.size() == 512 && Builder::bank_image(genesis_job()) == want,
              "Builder::bank_image(genesis) == sim/vec/genesis_bank.hex");
    }
    {                                              // board controls: the row balance rule (hashr_service._balance_ok)
        std::vector<int> all(63, 400);
        check(Board::balance_ok(all), "balance: all 63 chips at 400 MHz");
        std::vector<int> r500 = all, r520 = all;
        for (int i = 0; i < 3; i++) { r500[i] = 500; r520[i] = 520; }
        check(Board::balance_ok(r500), "balance: one row at 500 (95 MHz from the mean, limit 101) passes");
        check(!Board::balance_ok(r520), "balance: one row at 520 (114 MHz from the mean, limit 101) fails");
        check(!Board::volts_ok(8.59) && !Board::volts_ok(9.41) && Board::volts_ok(8.60) && Board::volts_ok(9.40),
              "voltage window 8.60 .. 9.40 V");
    }
    {                                              // diagnostics: KAT headers and Skot's jobs
        std::vector<uint8_t> g0 = Board::kat_header(0), g3 = Board::kat_header(3);
        Work w = build_work(genesis_job(), 0xffff001d);
        bool same = g0.size() == 80 && std::equal(g0.begin(), g0.end(), w.header);
        bool rolled = g3.size() == 80;
        for (int i = 0; rolled && i < 80; i++)
            if ((i < 68 || i > 71) && g3[size_t(i)] != g0[size_t(i)]) rolled = false;
        uint32_t t0 = g0[68] | g0[69] << 8 | g0[70] << 16 | uint32_t(g0[71]) << 24;
        uint32_t t3 = g3[68] | g3[69] << 8 | g3[70] << 16 | uint32_t(g3[71]) << 24;
        check(same && rolled && t3 == t0 + 3, "KAT: genesis header, then ntime + k (little-endian)");
        const uint8_t sk74[54] = {0x21, 0x36, 0x74, 0x01, 0, 0, 0, 0,
            0xf9, 0x1e, 0x0e, 0x17, 0x80, 0x20, 0xcc, 0x60, 0x61, 0x81, 0x55, 0x05,
            0x00, 0x36, 0x06, 0x53, 0x32, 0x62, 0xa2, 0x41, 0x21, 0xa0, 0x3c, 0xb2, 0x43, 0xe3, 0xc0, 0x53, 0x49, 0xfc,
            0x20, 0x7a, 0x9d, 0x5d, 0xe0, 0x84, 0xe6, 0x62, 0x14, 0x75, 0x99, 0xcb, 0x96, 0x9c, 0xc6, 0xbb};
        std::vector<uint8_t> s0 = Board::skot_job(0), s1 = Board::skot_job(1);
        check(s0.size() == 54 && std::equal(s0.begin(), s0.end(), sk74) && s1.size() == 54 && s1[2] == 0x75 &&
              bm::crc16_false(s1.data(), 52) == uint16_t(s1[52] << 8 | s1[53]),
              "SKOT: job 0x74 packs to the packet tb_disp pins (CRC C6 BB), job 0x75 carries its CRC");
    }
    {                                              // the power timer: on/off and its length (Rev 2026-11-25)
        PowerTimer t;
        check(t.on && t.seconds == 600, "power timer: on, 10 minutes by default");
        check(t.expired(1000.5, 1000) && !t.expired(999, 1000), "power timer: runs out past its end");
        t.on = false;
        check(!t.expired(5000, 1000), "power timer: off never runs out");
        check(PowerTimer::minutes_ok(1) && PowerTimer::minutes_ok(1440) && !PowerTimer::minutes_ok(0) &&
              !PowerTimer::minutes_ok(1441), "power timer: 1 to 1440 minutes");
    }
    {                                              // a live clock change paces the jobs for the new clock
        check(Board::pacing_mhz({300, 300, 300}, {false, false, false}) == 300, "pacing clock: all at 300");
        check(Board::pacing_mhz({400, 400, 200}, {false, false, true}) == 400, "pacing clock: OFF chips left out");
        check(Board::pacing_mhz({300, 400, 500}, {false, false, false}) == 400, "pacing clock: the mean of the rest");
        check(Board::pacing_mhz({200, 200}, {true, true}) == 200, "pacing clock: all OFF -> the minimum");
    }
    {                                              // fan: VIZOR's slider takes over from the curve (Rev 2026-11-25)
        FanFollow f;
        bool first = f.moved(80);                  // hashrd's first look: whatever the slider held at boot
        bool same = f.moved(80);
        bool slid = f.moved(55);                   // Rev moved the slider
        f.mirror(49);                              // the curve drives 49 %, the slider shows it
        bool mirrored = f.moved(49);
        check(!first && !same && slid && !mirrored, "fan: only a slider move switches to manual, not boot or mirror");
        check(fan_curve_ok(30, 60) && fan_curve_ok(20, 90) && !fan_curve_ok(19, 60) && !fan_curve_ok(30, 91) &&
              !fan_curve_ok(50, 54) && !fan_curve_ok(60, 30), "fan curve: 20..90 C, top at least 5 C over bottom");
    }
    std::printf("%s %d/%d\n", pass == total ? "PASS" : "FAIL", pass, total);
    return pass == total ? 0 : 1;
}
