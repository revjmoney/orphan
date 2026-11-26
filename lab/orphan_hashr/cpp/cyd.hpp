// [orphan] H4SHR-CH3KR hashrd: the live screen on the ORPHAN Remote (CYD, ESP32-2432S028R, 320 x 240). The same big
// layout the Python screen drew (power and chip count, header and timer, volts and temperatures or the mining line,
// the J pins, the 63-chip map, the last log lines), drawn here with a baked bitmap font and sent as RGB565
// rectangles to the CYD's graphics port (8091, high byte first, hud=0), only the rows that changed.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include "font_dejavu.hpp"
#include <atomic>
#include <cstdint>
#include <functional>
#include <string>
#include <thread>
#include <utility>
#include <vector>

inline uint16_t rgb565(int r, int g, int b) { return uint16_t((r >> 3) << 11 | (g >> 2) << 5 | (b >> 3)); }

struct Frame {
    static constexpr int W = 320, H = 240;
    uint16_t px[H][W];
    void fill(uint16_t c);
    void rect(int x0, int y0, int x1, int y1, uint16_t fill_c, bool filled = true);   // inclusive corners
    void line_h(int y, uint16_t c);
    void text(int x, int y, const std::string& s, const Glyphs& g, uint16_t c, int anchor);  // 0 left, 1 middle, 2 right
    static int text_width(const std::string& s, const Glyphs& g) { return int(s.size()) * g.width; }
};

struct CydState {
    std::string power = "off", header;             // header "J6" or empty
    int chips = 0, timer_left = -1;                // timer -1: not running
    int chips_total = 63;                          // 63 on an S9 board, 72 on an L3+
    bool l3 = false;                               // an L3+ board: no volts, hashrate in MH/s
    double volts_read = -1;
    int pcb = -1, chip = -1;
    bool mining = false;
    double ghs = 0;
    unsigned long long valid = 0, invalid = 0, accepted = 0, submitted = 0;
    int pins[4] = {-1, -1, -1, -1};                // PLUG, TX, RX, RST levels, -1 unknown
    int en = -1, go = -1;
    std::vector<std::string> chip_state = std::vector<std::string>(63, "unknown");
    std::vector<std::pair<std::string, std::string>> log;   // (level, text), oldest first
};

void render(Frame& f, const CydState& s);

struct Band { int x0, y0, x1, y1; };
std::vector<Band> changed_bands(const Frame* prev, const Frame& cur);   // prev null: the whole screen
std::string rect_request(const std::string& host, int x, int y, int w, int h, const uint16_t* px);  // px row-major

class CydScreen {                                  // a thread: render the state, send what changed, ~6 frames/s
public:
    CydScreen(std::string host, std::function<CydState()> state, std::function<void(const std::string&)> log)
        : host_(std::move(host)), state_(std::move(state)), log_(std::move(log)) {}
    void start();
private:
    std::string host_;
    std::function<CydState()> state_;
    std::function<void(const std::string&)> log_;
    void run();
    bool post(const Frame& f, const Band& b, std::string& why);
    bool post_once(const Frame& f, const Band& b, std::string& why);
};
