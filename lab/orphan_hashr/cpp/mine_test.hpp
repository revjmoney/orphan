// [orphan] H4SHR-CH3KR hashrd: builder test. The FPGA builds every work from the genesis block as a job (en2 from 0)
// and feeds the board's chain; every nonce that comes back is rebuilt and re-hashed here (cpp/work.cpp) and counted
// valid (difficulty 1) or invalid, per chip. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include "board.hpp"
#include <string>
#include <vector>

struct MineResult {
    bool ok = false;
    std::string why;
    int seconds = 0, nonces = 0, valid = 0, invalid = 0, other = 0, swapped = 0;
    uint32_t built = 0, stalls = 0, sent = 0;
    std::vector<int> per_chip;           // valid nonces per chip (nonce >> 26)
    std::string diag;                    // the first invalid nonces: which en2 (if any) they really belong to
};

MineResult run_builder_test(Board& board, Bus& bus, int seconds);
std::string mine_report(const MineResult& r);
