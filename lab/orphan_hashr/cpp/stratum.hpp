// [orphan] H4SHR-CH3KR hashrd: stratum v1 messages. A mining.notify becomes an FPGA job (refused when the FPGA cannot
// hold it), shares are checked against the pool's target, submits are formatted the way pools read them.
// Header byte rules as Orphan BTC (stratum_btc.header_for): version, ntime and nbits reversed, prevhash 4-byte words
// reversed, coinbase = coinb1 | extranonce1 | extranonce2 | coinb2, merkle branches as given.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include "json.hpp"
#include "work.hpp"
#include <array>
#include <cstdint>
#include <string>
#include <vector>

struct Notify {
    std::string id, prevhash, coinb1, coinb2, version, nbits, ntime;
    std::vector<std::string> merkle;
    bool clean = false;
};

constexpr int MAX_COINBASE = 1024;                 // bytes the FPGA job bank holds
constexpr int MAX_BRANCHES = 16;

bool notify_from(const json::Value& params, Notify& n);                       // the params array of mining.notify
bool job_from(const Notify& n, const std::string& en1_hex, int en2_size, uint16_t tag, Job& j, std::string& why);
std::array<uint8_t, 32> target_for(double diff);   // DIFF1 / diff, little-endian bytes (byte 31 most significant)
bool share_ok(const std::array<uint8_t, 32>& hash, const std::array<uint8_t, 32>& target);   // hash (LE) <= target
std::string submit_nonce_hex(uint32_t chip_nonce); // the header's nonce as pools read it: the chip word byte-swapped
std::string en2_hex(uint64_t en2, int size);       // big-endian, size bytes
bool hex_bytes(const std::string& s, std::vector<uint8_t>& out);              // false on odd length or non-hex
double share_difficulty(const std::array<uint8_t, 32>& hash);   // DIFF1 / the hash read little-endian
double nbits_difficulty(const std::string& nbits_hex);         // the network difficulty from a job's nbits
long coinbase_height(const std::string& coinb1_hex);           // the block height a BIP34 coinbase starts with, -1
