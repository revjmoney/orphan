// [orphan] H4SHR-CH3KR hashrd: the Orphan dev fee, 3 % of mining time, ON by default, opt-out. The same rule as
// orphan/devfee.py: for every 97 minutes mined to the user's wallet, 3 minutes go to the developer's pool account
// (Rev's Mining-Dutch account, SHA-256); time mined is kept in a ledger so a restart never skips the fee or charges
// it twice. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <string>
#include <utility>

class DevFee {
public:
    enum Role { USER, DEV };
    static constexpr int PERCENT = 3;
    static constexpr int USER_SLICE = 97 * 60;     // seconds to the user between dev slices
    static constexpr int DEV_SLICE = 3 * 60;
    static constexpr const char* DEV_POOL = "stratum+tcp://americas.mining-dutch.nl:9996";
    static constexpr const char* DEV_USER = "revjmoney.orphan-devfee";
    static constexpr const char* DEV_PASSWORD = "d=10";        // Mining-Dutch's floor difficulty

    explicit DevFee(std::string ledger_path);
    std::pair<Role, int> next() const;             // the next slice and its length in seconds
    void add(Role role, double seconds);           // time mined; the paid-off part is settled, the ledger rewritten
    double owed() const;                           // dev seconds owed for the user time so far
    bool enabled = true;

private:
    std::string path_;
    double user_ = 0, dev_ = 0;
    void save() const;
};
