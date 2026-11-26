// [orphan] H4SHR-CH3KR hashrd: the dev fee schedule (see devfee.hpp). by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "devfee.hpp"
#include "json.hpp"
#include <algorithm>
#include <cstdio>
#include <fstream>
#include <sstream>

DevFee::DevFee(std::string ledger_path) : path_(std::move(ledger_path)) {
    std::ifstream in(path_);
    if (!in) return;
    std::stringstream ss;
    ss << in.rdbuf();
    json::Value v;
    if (!json::parse(ss.str(), v)) return;
    user_ = v["user"].num(0);
    dev_ = v["dev"].num(0);
}

double DevFee::owed() const { return user_ * PERCENT / (100 - PERCENT) - dev_; }

std::pair<DevFee::Role, int> DevFee::next() const {
    double o = owed();
    if (enabled && o >= DEV_SLICE * 0.5) return {DEV, int(std::min(double(DEV_SLICE * 2), o) + 0.5)};
    return {USER, USER_SLICE};
}

void DevFee::add(Role role, double seconds) {
    if (seconds <= 0) return;
    (role == DEV ? dev_ : user_) += seconds;
    double settled = std::min(user_, dev_ * (100 - PERCENT) / PERCENT);   // drop the part already paid in full
    user_ -= settled;
    dev_ -= settled * PERCENT / (100 - PERCENT);
    save();
}

void DevFee::save() const {
    json::Value v = json::Value::object();
    v.set("user", user_);
    v.set("dev", dev_);
    std::string tmp = path_ + ".tmp";
    {
        std::ofstream out(tmp, std::ios::trunc);
        if (!out) return;
        out << json::dump(v);
        if (!out) return;
    }
    if (std::rename(tmp.c_str(), path_.c_str()) != 0) {     // Linux replaces atomically; elsewhere make room first
        std::remove(path_.c_str());
        std::rename(tmp.c_str(), path_.c_str());
    }
}
