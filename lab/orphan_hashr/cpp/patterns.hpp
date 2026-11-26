// [orphan] H4SHR-CH3KR hashrd: Bitmain's factory pattern test, ported (single-board-test send_func 0x19e5c,
// get_work 0xb0e4). raw_NN.bin = the unpacked minertest64_NN.bin: 48-byte records (midstate 0..31, tail 32..43,
// nonce 44..47) for chip NN-1; each nonce lies in that chip's own address slice. For each pattern the chips' works go
// out one after another at Bitmain's pacing; a chip passes a pattern when its own known nonce comes back.
// The pattern files are Bitmain's and stay in /opt/ardzy/projects/bitmain_stock (never in a repo).
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include "board.hpp"
#include <string>
#include <vector>

struct PatternResult {
    bool ok = false;
    std::string why;
    int count = 0, passed = 0, copies = 0, other = 0, wrong_slice = 0, sent = 0;
    double seconds = 0;
    std::vector<int> per_chip;           // patterns found per chip
};

PatternResult run_patterns(Board& board, Bus& bus, int count);
std::string pattern_report(const PatternResult& r);
