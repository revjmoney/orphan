// [orphan] H4SHR-CH3KR hashrd: fan modes. The curve runs the fan until someone moves VIZOR's FAN slider (it writes
// orphan_fan's DUTY register); then the slider rules until the page's CURVE button. While the curve rules, hashrd
// writes the curve's duty into DUTY so the slider shows what the fan really does.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once

struct FanFollow {
    int seen = -1;                                 // DUTY as hashrd last saw or wrote it
    bool moved(int duty) {                         // true when DUTY changed behind hashrd's back (a slider move)
        bool m = seen >= 0 && duty != seen;
        seen = duty;
        return m;
    }
    void mirror(int duty) { seen = duty; }         // hashrd wrote DUTY itself
};

inline bool fan_curve_ok(int lo_c, int hi_c) { return lo_c >= 20 && hi_c <= 90 && hi_c >= lo_c + 5; }
