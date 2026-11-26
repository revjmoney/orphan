// [orphan] H4SHR-CH3KR: checks for the dev fee schedule (3 %, 97 minutes to the user, 3 to the developer, ledger kept
// across restarts; the same rule as orphan/devfee.py).
//   g++ -O2 -std=c++17 -o test_devfee test_devfee.cpp devfee.cpp json.cpp && ./test_devfee
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "devfee.hpp"
#include "json.hpp"
#include <cmath>
#include <cstdio>
#include <fstream>
#include <sstream>
#include <string>

static int pass = 0, total = 0;
static void check(bool ok, const char* name) {
    total++;
    if (ok) pass++;
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", name);
}

int main() {
    const std::string path = "test_devfee.local.json";
    std::remove(path.c_str());
    {
        DevFee f(path);
        check(f.next() == std::make_pair(DevFee::USER, 5820), "fresh_user_first");
        f.add(DevFee::USER, 5820);
        check(f.next() == std::make_pair(DevFee::DEV, 180), "dev_after_97");
        f.add(DevFee::DEV, 180);
        std::ifstream in(path);
        std::stringstream ss;
        ss << in.rdbuf();
        json::Value v;
        bool ok = std::fabs(f.owed()) < 1e-6 && json::parse(ss.str(), v) && std::fabs(v["user"].num(1)) < 1e-6 &&
                  std::fabs(v["dev"].num(1)) < 1e-6;
        check(ok, "settles");
    }
    std::remove(path.c_str());
    {
        DevFee f(path);
        f.add(DevFee::USER, 5820);
        f.add(DevFee::DEV, 60);
        DevFee g(path);                                 // hashrd restarted in the middle of a dev slice
        check(g.next() == std::make_pair(DevFee::DEV, 120), "restart_mid_slice");
        g.enabled = false;
        check(g.next() == std::make_pair(DevFee::USER, 5820), "opt_out");
    }
    std::remove(path.c_str());
    std::printf("%s %d/%d\n", pass == total ? "PASS" : "FAIL", pass, total);
    return pass == total ? 0 : 1;
}
