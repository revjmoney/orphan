// [orphan] H4SHR-CH3KR: the work model. One stratum job + an extranonce2 -> one chip work (midstate, tail, tags).
// This is the FPGA builder's known-answer oracle and the ARM's share checker. by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <array>
#include <cstdint>
#include <vector>

// Every field is already in header byte order (C++ converts the stratum orders before it builds a Job).
struct Job {
    uint16_t tag;                                  // pool-job tag: C++ finds the stratum job id (and ntime) from it
    uint8_t version[4], prevhash[32], ntime[4], nbits[4];
    std::vector<uint8_t> coinbase;                 // cb1 | en1 | en2 placeholder | cb2, up to 1024 bytes
    int en2_off, en2_size;                         // where the extranonce2 goes, 1..8 bytes, big-endian, low byte last
    std::vector<std::array<uint8_t, 32>> branches; // merkle branches, internal byte order, 0..16
    uint64_t en2_start;                            // first extranonce2 (48 bits)
};

struct Work {
    uint8_t header[80];                            // nonce bytes 76..79 are zero
    uint32_t midstate[8];                          // H0..H7 after header[0..63] from the IV
    uint32_t tail[3];                              // header bytes 72..75, 68..71, 64..67, byte 0 in bits 31:24
    uint32_t tag, tag2;                            // {pool tag, en2[47:32]}, en2[31:0]
};

bool en2_ok(const Job& j, uint64_t en2);           // en2 fits in EN2_SIZE bytes and in 48 bits
Work build_work(const Job& j, uint64_t en2);
std::array<uint8_t, 32> merkle_root(std::array<uint8_t, 32> cb_hash, const std::vector<std::array<uint8_t, 32>>& br);
std::array<uint8_t, 32> header_hash(const uint8_t header[80], uint32_t nonce); // nonce big-endian at 76..79 (byte order as the chip returns it)
bool meets_diff1(const std::array<uint8_t, 32>& hash);
std::vector<uint32_t> bank_image(const Job& j);    // the 512-word FPGA job bank (slot 4 layout)
Job genesis_job();                                 // the genesis block as a job (tag 1, en2 = its ffff001d bytes)
