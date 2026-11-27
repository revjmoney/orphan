// [orphan] H4SHR-CH3KR hashrd: the rules for up to three boards at once (chains on J6, J7, J8 in this bitstream):
// which plug may power on, which board a command means, what the fan follows, and whether the shared GO line may
// switch off. Pure logic so it can be tested without hardware. by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <string>
#include <vector>

struct BoardView {
    int header;                                    // 0..8 = J1..J9
    bool powered;                                  // DC-DC on, chips up
    bool off;                                      // fully off (not starting or stopping)
    int pcb_c, chip_c;                             // -1 = no reading
};

namespace fleet {
constexpr unsigned CHAIN_MASK = 0x0E0;             // the FPGA's CHAIN_MASK (hr_disp.v): J6, J7, J8
inline bool chain_on(int h) { return h >= 0 && h < 9 && (CHAIN_MASK >> h & 1); }
bool may_power_on(const std::vector<BoardView>& v, int h, std::string& why);
int pick(const std::vector<BoardView>& v, int want, std::string& why);   // want -1: the only powered board
int hottest(const std::vector<BoardView>& v);      // the hottest reading of any powered board, -1 none
bool others_on(const std::vector<BoardView>& v, int h);                  // another board not fully off
std::vector<int> off_targets(const std::vector<BoardView>& v, int want); // want -1: every board not off
std::string jname(int h);                          // "J6"

// START MINING ON ALL BOARDS (Rev, 2026-11-27): which boards to power on, at what, and which miners to start
constexpr double S9_VOLTS = 8.6;                   // an S9 with nothing saved: low and safe (board 2's daily setting)
constexpr int S9_MHZ = 300;
constexpr int L3_MHZ = 384;                        // an L3+ with nothing saved: stock clock
struct Plug { int header; bool plugged, chain; std::string kind; bool off; };      // kind "s9", "l3p" or "" (not picked)
struct Remembered { int header; double volts; int mhz; };                         // what it last powered on at
struct PowerStep { int header; std::string kind; double volts; int mhz; };
struct StartPlan { std::vector<PowerStep> power; bool sha = false, scrypt = false; std::vector<std::string> skipped; };
StartPlan start_plan(const std::vector<Plug>& plugs, const std::vector<Remembered>& mem);
}
