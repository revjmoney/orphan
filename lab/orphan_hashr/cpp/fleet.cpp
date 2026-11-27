// [orphan] H4SHR-CH3KR hashrd: rules for several boards at once (see fleet.hpp). by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "fleet.hpp"

namespace fleet {

std::string jname(int h) { return "J" + std::to_string(h + 1); }

bool may_power_on(const std::vector<BoardView>& v, int h, std::string& why) {
    if (!chain_on(h)) { why = jname(h) + " has no chain in this bitstream"; return false; }
    for (auto& b : v)
        if (b.header == h && !b.off) { why = jname(h) + " is not off"; return false; }
    return true;
}

int pick(const std::vector<BoardView>& v, int want, std::string& why) {
    if (want >= 0) {
        for (auto& b : v) if (b.header == want) return want;
        why = jname(want) + " has no board";
        return -1;
    }
    std::vector<int> on;
    for (auto& b : v) if (!b.off) on.push_back(b.header);
    if (on.size() == 1) return on[0];
    if (on.empty()) { why = "no board is on"; return -1; }
    why = "several boards are on (";
    for (size_t i = 0; i < on.size(); i++) why += (i ? ", " : "") + jname(on[i]);
    why += "): name one";
    return -1;
}

int hottest(const std::vector<BoardView>& v) {
    int t = -1;
    for (auto& b : v) {
        if (!b.powered) continue;
        if (b.pcb_c > t) t = b.pcb_c;
        if (b.chip_c > t) t = b.chip_c;
    }
    return t;
}

bool others_on(const std::vector<BoardView>& v, int h) {
    for (auto& b : v) if (b.header != h && !b.off) return true;
    return false;
}

std::vector<int> off_targets(const std::vector<BoardView>& v, int want) {
    std::vector<int> o;
    for (auto& b : v) if (!b.off && (want < 0 || b.header == want)) o.push_back(b.header);
    return o;
}

StartPlan start_plan(const std::vector<Plug>& plugs, const std::vector<Remembered>& mem) {
    StartPlan p;
    for (const Plug& g : plugs) {
        if (!g.plugged || !g.chain || !chain_on(g.header)) continue;
        if (g.kind != "s9" && g.kind != "l3p") { p.skipped.push_back(jname(g.header) + ": pick S9 or L3+ first"); continue; }
        if (g.kind == "s9") p.sha = true; else p.scrypt = true;
        if (!g.off) continue;                      // already on (or on its way): leave it
        PowerStep s{g.header, g.kind, g.kind == "s9" ? S9_VOLTS : 0.0, g.kind == "s9" ? S9_MHZ : L3_MHZ};
        for (const Remembered& r : mem)
            if (r.header == g.header) { if (g.kind == "s9") s.volts = r.volts; s.mhz = r.mhz; }
        p.power.push_back(s);
    }
    return p;
}

}
