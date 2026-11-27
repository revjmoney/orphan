// [orphan] H4SHR-CH3KR: checks for the multi-board rules (which plugs have a chain, which board a command means,
// what the fan follows, what may switch the shared GO line off). Pure logic, no hardware.
//   g++ -O2 -std=c++17 -o test_fleet test_fleet.cpp fleet.cpp && ./test_fleet
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "fleet.hpp"
#include <cstdio>
#include <string>
#include <vector>

static int pass = 0, total = 0;
static void check(bool ok, const char* name) {
    total++;
    if (ok) pass++;
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", name);
}

int main() {
    // header index h = J number - 1; the bitstream has chains on J6, J7, J8
    std::vector<BoardView> two = {{5, true, false, 40, 60}, {6, true, false, 45, 52}};
    std::string why;
    check(fleet::chain_on(5) && fleet::chain_on(6) && fleet::chain_on(7) && !fleet::chain_on(0) && !fleet::chain_on(8),
          "chains on J6, J7, J8 only");
    std::vector<BoardView> j6 = {{5, true, false, 40, 60}};
    check(fleet::may_power_on(j6, 6, why), "J7 may power on while J6 is on");
    why.clear();
    check(!fleet::may_power_on(j6, 5, why) && why.find("J6") != std::string::npos, "J6 again is refused (not off)");
    why.clear();
    check(!fleet::may_power_on(j6, 1, why) && why == "J2 has no chain in this bitstream", "J2 is refused: no chain");
    why.clear();
    check(fleet::pick(two, -1, why) < 0 && why.find("J6") != std::string::npos && why.find("J7") != std::string::npos,
          "no J with two boards on: refused, naming J6 and J7");
    why.clear();
    check(fleet::pick(two, 6, why) == 6 && fleet::pick(j6, -1, why) == 5, "a named J, or the only powered board");
    check(fleet::hottest(two) == 60 && fleet::hottest({}) == -1, "the fan follows the hottest reading of any board");
    check(fleet::others_on(two, 5) && !fleet::others_on(j6, 5), "GO stays on while another board is on");
    std::vector<int> off = fleet::off_targets(two, -1);
    check(off.size() == 2 && off[0] == 5 && off[1] == 6 && fleet::off_targets(two, 6) == std::vector<int>{6},
          "power_off without J turns every board off, with J only that one");
    // START MINING ON ALL BOARDS: power every plugged board that is off (its type picked), at the volts and MHz it
    // last ran at (or the safe defaults), then start the miner for each kind that has a board
    std::vector<fleet::Plug> plugs = {
        {5, true, true, "l3p", true}, {6, true, true, "l3p", false}, {7, true, true, "s9", true}};
    std::vector<fleet::Remembered> mem = {{7, 8.9, 350}};
    fleet::StartPlan sp = fleet::start_plan(plugs, mem);
    check(sp.power.size() == 2 && sp.power[0].header == 5 && sp.power[1].header == 7,
          "start all: powers J6 and J8, leaves J7 (already on) alone");
    check(sp.power[0].kind == "l3p" && sp.power[0].mhz == fleet::L3_MHZ,
          "start all: an L3+ with nothing saved at the L3+ default clock");
    check(sp.power[1].volts == 8.9 && sp.power[1].mhz == 350, "start all: an S9 at the volts and MHz it last ran at");
    check(sp.sha && sp.scrypt, "start all: both miners start (an S9 and L3+ boards)");
    std::vector<fleet::Plug> odd = {{5, true, true, "", true}, {6, false, false, "s9", true}, {7, true, true, "s9", true}};
    sp = fleet::start_plan(odd, {});
    check(sp.power.size() == 1 && sp.power[0].header == 7 && sp.power[0].volts == fleet::S9_VOLTS &&
              sp.power[0].mhz == fleet::S9_MHZ,
          "start all: an S9 with nothing saved at the S9 defaults");
    check(sp.skipped.size() == 1 && sp.skipped[0].find("J6") != std::string::npos,
          "start all: a board with no type picked is named, not powered");
    check(sp.sha && !sp.scrypt, "start all: only the S9 miner when there is no L3+");
    sp = fleet::start_plan({}, {});
    check(sp.power.empty() && !sp.sha && !sp.scrypt, "start all: nothing plugged, nothing to do");
    std::printf("%s %d/%d\n", pass == total ? "PASS" : "FAIL", pass, total);
    return pass == total ? 0 : 1;
}
