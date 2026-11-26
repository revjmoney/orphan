// [orphan] H4SHR-CH3KR: known-answer checks for the JSON and stratum message layer (pool job to FPGA job, share
// target, submit text). The genesis block, split like a pool's mining.notify, must rebuild the genesis header.
//   g++ -O2 -std=c++17 -o test_stratum test_stratum.cpp stratum.cpp json.cpp work.cpp sha256.cpp && ./test_stratum
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "json.hpp"
#include "stratum.hpp"
#include "work.hpp"
#include <cstdio>
#include <fstream>
#include <string>
#include <vector>

static std::string genesis_tx_hex() {             // the genesis coinbase, from the work model
    std::string s;
    char b[3];
    for (uint8_t c : genesis_job().coinbase) { std::snprintf(b, sizeof b, "%02x", c); s += b; }
    return s;
}

static int pass = 0, total = 0;
static void check(bool ok, const char* name) {
    total++;
    if (ok) pass++;
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", name);
}

// the genesis coinbase split the way a pool splits it: coinb1 | en1 (2 bytes) | en2 (4 bytes) | coinb2
static Notify genesis_notify(std::string& en1) {
    std::string tx = genesis_tx_hex();
    Notify n;
    n.id = "g1";
    n.prevhash = std::string(64, '0');
    n.coinb1 = tx.substr(0, 41 * 2);
    en1 = tx.substr(41 * 2, 2 * 2);
    n.coinb2 = tx.substr(47 * 2);
    n.version = "00000001";
    n.nbits = "1d00ffff";
    n.ntime = "495fab29";
    n.clean = true;
    return n;
}

static std::vector<uint32_t> read_hex_words(const char* path) {
    std::vector<uint32_t> v;
    std::ifstream f(path);
    std::string s;
    while (f >> s) v.push_back(uint32_t(std::stoul(s, nullptr, 16)));
    return v;
}

int main() {
    // json_roundtrip
    {
        json::Value v;
        bool ok = json::parse("{\"id\":1,\"method\":\"mining.notify\",\"params\":[\"a\",[],true,1.5,null]}", v);
        const json::Value& p = v["params"];
        ok = ok && v["id"].num() == 1 && v["method"].str() == "mining.notify" && p.size() == 5 && p[0].str() == "a" &&
             p[1].is_array() && p[1].size() == 0 && p[2].boolean() && p[3].num() == 1.5 && p[4].is_null();
        json::Value back;
        ok = ok && json::parse(json::dump(v), back) && back["params"][3].num() == 1.5 && back["method"].str() == "mining.notify";
        check(ok, "json_roundtrip");
    }
    // genesis_notify: the pool job becomes the FPGA job, and its work hashes to the genesis block
    {
        std::string en1, why;
        Notify n = genesis_notify(en1);
        Job j;
        bool ok = job_from(n, en1, 4, 1, j, why);
        j.en2_start = 0xffff001d;
        ok = ok && j.en2_off == 43 && j.en2_size == 4;
        Job jb = j;                                   // the placeholder bytes are zeros (the FPGA writes en2 there);
        const uint8_t e2[4] = {0xff, 0xff, 0x00, 0x1d}; // the model's bank carries the genesis en2 in them
        for (int k = 0; ok && k < 4; k++) jb.coinbase[size_t(43 + k)] = e2[k];
        auto want = read_hex_words("../sim/vec/genesis_bank.hex");
        ok = ok && bank_image(jb) == want;

        auto h = header_hash(build_work(j, 0xffff001d).header, 0x1dac2b7c);
        const uint8_t gen[32] = {0x6f, 0xe2, 0x8c, 0x0a, 0xb6, 0xf1, 0xb3, 0x72, 0xc1, 0xa6, 0xa2, 0x46, 0xae, 0x63, 0xf7, 0x4f,
                                 0x93, 0x1e, 0x83, 0x65, 0xe1, 0x5a, 0x08, 0x9c, 0x68, 0xd6, 0x19, 0x00, 0x00, 0x00, 0x00, 0x00};
        for (int i = 0; i < 32; i++) ok = ok && h[i] == gen[i];
        if (!why.empty()) std::printf("     why: %s\n", why.c_str());
        check(ok, "genesis_notify (bank and hash)");
    }
    // submit_hex
    check(submit_nonce_hex(0x1dac2b7c) == "7c2bac1d" && en2_hex(0xffff001d, 4) == "ffff001d" &&
          en2_hex(5, 8) == "0000000000000005", "submit_hex");
    // share_target: the genesis hash is a difficulty 2536.4 share
    {
        std::string en1, why;
        Notify n = genesis_notify(en1);
        Job j;
        job_from(n, en1, 4, 1, j, why);
        auto h = header_hash(build_work(j, 0xffff001d).header, 0x1dac2b7c);
        check(share_ok(h, target_for(1.0)) && share_ok(h, target_for(2536.0)) && !share_ok(h, target_for(2537.0)),
              "share_target (2536 yes, 2537 no)");
    }
    // refuse_oversize: jobs the FPGA cannot hold are refused with a reason
    {
        std::string en1, why;
        Notify n = genesis_notify(en1);
        Job j;
        bool ok = true;
        Notify big = n;
        big.coinb2 += std::string(2 * 1024, 'a');                    // coinbase over 1024 bytes
        why.clear(); ok = ok && !job_from(big, en1, 4, 1, j, why) && !why.empty();
        Notify br = n;
        for (int i = 0; i < 17; i++) br.merkle.push_back(std::string(64, '1'));
        why.clear(); ok = ok && !job_from(br, en1, 4, 1, j, why) && !why.empty();
        why.clear(); ok = ok && !job_from(n, en1, 9, 1, j, why) && !why.empty();         // en2 size 9
        why.clear(); ok = ok && !job_from(n, en1, 0, 1, j, why) && !why.empty();         // en2 size 0
        Notify badhex = n;
        badhex.coinb1 += "zz";                                        // not hex
        why.clear(); ok = ok && !job_from(badhex, en1, 4, 1, j, why) && !why.empty();
        check(ok, "refuse_oversize");
    }
    // pool statistics: network difficulty from nbits, a share's difficulty, the block height in the coinbase (BIP34)
    {
        std::string en1, why;
        Notify n = genesis_notify(en1);
        Job j;
        job_from(n, en1, 4, 1, j, why);
        auto h = header_hash(build_work(j, 0xffff001d).header, 0x1dac2b7c);
        double sd = share_difficulty(h);
        std::string cb1 = "01000000" "01" + std::string(64, '0') + "ffffffff" "1b" "03" "e4c40c";
        check(nbits_difficulty("1d00ffff") == 1.0 && sd > 2536.3 && sd < 2536.5 && coinbase_height(cb1) == 836836 &&
              coinbase_height("01") == -1, "pool stats: nbits 1d00ffff = 1, genesis share 2536.4, BIP34 height 836836");
    }
    std::printf("%s %d/%d\n", pass == total ? "PASS" : "FAIL", pass, total);
    return pass == total ? 0 : 1;
}
