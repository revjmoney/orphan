// [orphan] H4SHR-CH3KR: BM1485 (Antminer L3+) frames. Facts and their sources: lab-work/l3-re/BM1485-L3plus-protocol.md.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "bm1485.hpp"
#include "bm1387.hpp"

namespace bm85 {
namespace {
struct Pll { int mhz; uint32_t word; };
const Pll TABLE[100] = {   // stock cgminer table at 0x55804 (protocol doc section 6)
    {100, 0x00400242}, {106, 0x00440242}, {112, 0x00480242}, {118, 0x00420271}, {125, 0x00460271}, {131, 0x003f0261},
    {137, 0x00420232}, {142, 0x00440261}, {148, 0x00470261}, {154, 0x004a0261}, {160, 0x004d0232}, {166, 0x005d0271},
    {172, 0x00450251}, {178, 0x00470251}, {184, 0x00670271}, {190, 0x005b0232}, {196, 0x005e0261}, {200, 0x00400241},
    {206, 0x00420241}, {212, 0x00440241}, {217, 0x00570251}, {223, 0x006b0232}, {229, 0x006e0261}, {235, 0x00710232},
    {242, 0x00610251}, {248, 0x00770232}, {254, 0x007a0232}, {260, 0x007d0232}, {267, 0x006b0251}, {273, 0x006d0251},
    {279, 0x00430231}, {285, 0x00720251}, {294, 0x002f0221}, {300, 0x00600241}, {306, 0x00310221}, {312, 0x00640241},
    {319, 0x00660241}, {325, 0x004e0231}, {331, 0x006a0241}, {338, 0x00510231}, {344, 0x006e0241}, {350, 0x00540231},
    {353, 0x00710241}, {356, 0x00720241}, {359, 0x00730241}, {362, 0x00570231}, {366, 0x00750241}, {369, 0x00760241},
    {375, 0x005a0231}, {378, 0x00790241}, {381, 0x003d0221}, {384, 0x007b0241}, {387, 0x005d0231}, {391, 0x007d0241},
    {394, 0x003f0221}, {397, 0x007f0241}, {400, 0x00600231}, {406, 0x00410221}, {412, 0x00420221}, {419, 0x00430221},
    {425, 0x00440221}, {431, 0x00450221}, {437, 0x00460221}, {438, 0x00460221}, {444, 0x00470221}, {450, 0x00480221},
    {456, 0x00490221}, {462, 0x004a0221}, {469, 0x004b0221}, {475, 0x004c0221}, {481, 0x004d0221}, {487, 0x004e0221},
    {494, 0x004f0221}, {500, 0x00500221}, {506, 0x00510221}, {512, 0x00520221}, {519, 0x00530221}, {525, 0x00540221},
    {531, 0x00550221}, {537, 0x00560221}, {544, 0x00570221}, {550, 0x00580221}, {556, 0x00590221}, {562, 0x005a0221},
    {569, 0x005b0221}, {575, 0x005c0221}, {581, 0x005d0221}, {587, 0x005e0221}, {588, 0x005e0221}, {594, 0x005f0221},
    {600, 0x00600221}, {606, 0x00610221}, {612, 0x00620221}, {619, 0x00630221}, {625, 0x00640221}, {631, 0x00650221},
    {637, 0x00660221}, {638, 0x00660221}, {644, 0x00670221}, {650, 0x00680221}};

std::vector<uint8_t> with_crc5(std::vector<uint8_t> f) {
    f.push_back(bm::crc5(f.data(), int(f.size())));
    return f;
}
std::vector<uint8_t> write_wire(int chip, uint8_t reg, uint8_t b0, uint8_t b1, uint8_t b2, uint8_t b3) {
    return with_crc5({uint8_t(chip < 0 ? 0x51 : 0x41), 0x08, uint8_t(chip < 0 ? 0 : chip), reg, b0, b1, b2, b3});
}
}  // namespace

std::vector<uint8_t> cmd_chain_inactive() { return with_crc5({0x53, 0x04, 0x00, 0x00}); }
std::vector<uint8_t> cmd_set_address(uint8_t addr) { return with_crc5({0x40, 0x04, addr, 0x00}); }
std::vector<uint8_t> cmd_read_reg(int chip, uint8_t reg) {
    return with_crc5({uint8_t(chip < 0 ? 0x52 : 0x42), 0x04, uint8_t(chip < 0 ? 0 : chip), reg});
}
std::vector<uint8_t> cmd_write_imm(int chip, uint8_t reg, uint32_t v) {
    return write_wire(chip, reg, uint8_t(v), uint8_t(v >> 8), uint8_t(v >> 16), uint8_t(v >> 24));
}
std::vector<uint8_t> cmd_pll(int chip, uint32_t w) {
    return write_wire(chip, REG_PLL, uint8_t(w >> 24), uint8_t(w >> 16), uint8_t(w >> 8), uint8_t(w));
}
std::vector<uint8_t> cmd_ticket_mask(uint32_t mask) {
    uint32_t b = (mask >> 24) | ((mask >> 8) & 0xFF00) | ((mask << 8) & 0xFF0000) | (mask << 24);
    return cmd_write_imm(-1, REG_TICKET, b);
}

uint32_t pll_for(int mhz, int* actual) {
    const Pll* best = &TABLE[0];
    for (const Pll& p : TABLE) if (p.mhz <= mhz) best = &p;
    if (actual) *actual = best->mhz;
    return best->word;
}
std::vector<int> mhz_table() {
    std::vector<int> v;
    for (const Pll& p : TABLE) v.push_back(p.mhz);
    return v;
}
int chip_addr(int i) { return i * INTERVAL; }

std::vector<uint8_t> work_frame(uint8_t id, const uint8_t header[80]) {
    std::vector<uint8_t> f = {0x20, 0x50, uint8_t(id & 0x7F), 0x00};
    for (int w = 18; w >= 0; w--)                  // the 19 non-nonce header words, last first, each in header order
        for (int k = 0; k < 4; k++) f.push_back(header[4 * w + k]);
    uint16_t crc = bm::crc16_false(f.data(), int(f.size()));
    f.push_back(uint8_t(crc >> 8));
    f.push_back(uint8_t(crc));
    return f;
}

int timeout_s(int mhz) {
    double t = (268435455.9375 / (256 / INTERVAL)) / (double(mhz) * 1e6) * 0.95 * 2500.0;
    return int(t);
}
int chip_of_nonce(uint32_t nonce) { return int((nonce >> 20) & 0xFF) / INTERVAL; }
void put_nonce(uint8_t h[80], uint32_t n) {
    h[76] = uint8_t(n >> 24); h[77] = uint8_t(n >> 16); h[78] = uint8_t(n >> 8); h[79] = uint8_t(n);
}
bool temps_from_reg44(uint32_t v, int& local_c, int& remote_c) {
    if (v == 0) return false;
    local_c = int((v >> 16) & 0xFF);
    remote_c = int(v & 0xFF);
    return true;
}
}  // namespace bm85
