// [orphan] H4SHR-CH3KR: checks for the CYD screen (baked font, frame drawing, the rectangle upload, changed rows).
//   g++ -O2 -std=c++17 -o test_cyd test_cyd.cpp cyd.cpp && ./test_cyd
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "cyd.hpp"
#include <cstdio>
#include <memory>
#include <string>

static int pass = 0, total = 0;
static void check(bool ok, const char* name) {
    total++;
    if (ok) pass++;
    std::printf("%s %s\n", ok ? "ok  " : "FAIL", name);
}

int main() {
    check(Frame::text_width("63/63", FONT_B30) == 5 * FONT_B30.width && FONT_B30.width > 0, "text width: monospace");
    auto f = std::make_unique<Frame>();
    f->fill(0);
    f->text(0, 0, "A", FONT_B13, 0xFFFF, 0);
    int inside = 0, outside = 0;
    for (int y = 0; y < Frame::H; y++)
        for (int x = 0; x < Frame::W; x++)
            if (f->px[y][x]) (x < FONT_B13.width && y < FONT_B13.height ? inside : outside)++;
    check(inside > 0 && outside == 0, "an A in bold 13 lands inside its glyph box");
    const uint16_t two[2] = {0x1234, 0xABCD};
    std::string r = rect_request("cyd", 0, 0, 2, 1, two);
    check(r.find("POST /rect?x=0&y=0&w=2&h=1&hud=0 HTTP/1.1\r\n") == 0 && r.find("Content-Length: 4\r\n") != std::string::npos &&
          r.size() >= 4 && uint8_t(r[r.size() - 4]) == 0x12 && uint8_t(r[r.size() - 3]) == 0x34 &&
          uint8_t(r[r.size() - 2]) == 0xAB && uint8_t(r[r.size() - 1]) == 0xCD, "rect upload: RGB565 high byte first");
    auto g = std::make_unique<Frame>(*f);
    check(changed_bands(f.get(), *g).empty(), "two identical frames: nothing to send");
    g->px[100][50] = 0x07E0;
    auto b = changed_bands(f.get(), *g);
    check(b.size() == 1 && b[0].y0 == 100 && b[0].y1 == 100 && b[0].x0 == 50 && b[0].x1 == 50, "one changed pixel: one band");
    check(changed_bands(nullptr, *g).size() == 1 && changed_bands(nullptr, *g)[0].x1 == Frame::W - 1,
          "first frame: the whole screen");
    std::printf("%s %d/%d\n", pass == total ? "PASS" : "FAIL", pass, total);
    return pass == total ? 0 : 1;
}
