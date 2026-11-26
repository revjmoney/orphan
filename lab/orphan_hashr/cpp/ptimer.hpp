// [orphan] H4SHR-CH3KR hashrd: the owner-present power timer. A powered board turns itself off when nobody renewed it
// for `seconds`; the page can set the length or switch the timer off (Rev 2026-11-25). Off: the 90 C cut, the
// no-temperature cut and the PIC heartbeat still guard the board. One timer setting for every board.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <atomic>

struct PowerTimer {
    std::atomic<bool> on{true};
    std::atomic<int> seconds{600};
    static bool minutes_ok(int m) { return m >= 1 && m <= 1440; }
    bool expired(double now, double end) const { return on && now > end; }
};
