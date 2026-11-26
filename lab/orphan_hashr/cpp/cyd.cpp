// [orphan] H4SHR-CH3KR hashrd: the CYD live screen (see cyd.hpp). by JMSCNC, makers of RotatoCAM.
// [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "cyd.hpp"
#include <algorithm>
#include <cerrno>
#include <chrono>
#include <cstdio>
#include <cstring>
#include <memory>
#ifndef _WIN32
#include <netdb.h>
#include <poll.h>
#include <sys/socket.h>
#include <unistd.h>
#endif

namespace {
// Rev's palette (full-strength colors stay clean on the CYD's TN panel)
const uint16_t BG = rgb565(0, 0, 0), LIME = rgb565(50, 255, 50), LEMON = rgb565(255, 244, 79),
               ORANGE = rgb565(255, 103, 0), WHITE = rgb565(255, 255, 255), MUTED = rgb565(130, 130, 130),
               LINE = rgb565(0, 130, 0), DARK = rgb565(45, 45, 45);
// older ORPHAN Remote firmware drew its temp/FPS box here: repainted every 2 s (also the keep-alive)
constexpr int HUD_X = 170, HUD_Y = 2, HUD_W = 148, HUD_H = 13;

uint16_t state_color(const std::string& s) {
    if (s == "answering") return LIME;
    if (s == "missing") return ORANGE;
    if (s == "off") return MUTED;
    return DARK;
}
std::string mmss(int s) { char b[16]; std::snprintf(b, sizeof b, "%d:%02d", s / 60, s % 60); return b; }
}

void Frame::fill(uint16_t c) { for (auto& row : px) for (auto& p : row) p = c; }

void Frame::rect(int x0, int y0, int x1, int y1, uint16_t c, bool filled) {
    for (int y = std::max(0, y0); y <= std::min(H - 1, y1); y++)
        for (int x = std::max(0, x0); x <= std::min(W - 1, x1); x++)
            if (filled || y == y0 || y == y1 || x == x0 || x == x1) px[y][x] = c;
}

void Frame::line_h(int y, uint16_t c) { if (y >= 0 && y < H) for (int x = 0; x < W; x++) px[y][x] = c; }

void Frame::text(int x, int y, const std::string& s, const Glyphs& g, uint16_t c, int anchor) {
    int w = text_width(s, g);
    if (anchor == 1) x -= w / 2;
    else if (anchor == 2) x -= w;
    for (unsigned char ch : s) {
        if (ch >= 32 && ch < 127) {
            const uint8_t* b = g.bits + size_t(ch - 32) * size_t(g.height * g.stride);
            for (int r = 0; r < g.height; r++)
                for (int col = 0; col < g.width; col++)
                    if (b[r * g.stride + col / 8] & (0x80 >> (col % 8))) {
                        int X = x + col, Y = y + r;
                        if (X >= 0 && X < W && Y >= 0 && Y < H) px[Y][X] = c;
                    }
        }
        x += g.width;
    }
}

void render(Frame& f, const CydState& s) {
    const int W = Frame::W, H = Frame::H;
    f.fill(BG);
    std::string pw = s.power;
    for (auto& c : pw) c = char(std::toupper((unsigned char)c));
    f.text(4, 0, pw, FONT_B30, pw == "ON" ? LIME : pw == "OFF" ? MUTED : LEMON, 0);
    uint16_t col = s.chips == s.chips_total ? WHITE : (s.power == "on" ? ORANGE : MUTED);
    f.text(W - 4, 0, std::to_string(s.chips) + "/" + std::to_string(s.chips_total), FONT_B30, col, 2);
    f.text(W / 2, 4, s.header.empty() ? "J?" : s.header, FONT_B19, LEMON, 1);
    if (s.timer_left >= 0) f.text(W / 2, 24, mmss(s.timer_left), FONT_B13, LEMON, 1);
    char b[96];
    std::string pcb = s.pcb < 0 ? "-" : std::to_string(s.pcb) + "C", chc = s.chip < 0 ? "-" : std::to_string(s.chip) + "C";
    bool hot = s.pcb >= 75 || s.chip >= 90;
    if (s.mining) {
        if (s.l3) std::snprintf(b, sizeof b, "%.0fMH", s.ghs * 1000.0);
        else std::snprintf(b, sizeof b, "%.1fGH", s.ghs);
        f.text(4, 38, b, FONT_B19, WHITE, 0);
        f.text(W - 4, 38, pcb + " " + chc, FONT_B19, hot ? ORANGE : WHITE, 2);
        std::snprintf(b, sizeof b, "ok %llu  bad %llu  shares %llu/%llu", s.valid, s.invalid, s.accepted, s.submitted);
        f.text(4, 56, b, FONT_B13, s.invalid ? ORANGE : WHITE, 0);
    } else {
        uint16_t reading = hot ? ORANGE : WHITE;
        if (s.volts_read < 0) f.text(4, 38, "-", FONT_B19, WHITE, 0);
        else { std::snprintf(b, sizeof b, "%.2fV", s.volts_read); f.text(4, 38, b, FONT_B19, WHITE, 0); }
        f.text(112, 38, "PCB", FONT_B19, LIME, 0);
        f.text(112 + Frame::text_width("PCB ", FONT_B19), 38, pcb, FONT_B19, reading, 0);
        f.text(W - 4, 38, chc, FONT_B19, reading, 2);
        f.text(W - 4 - Frame::text_width(chc + " ", FONT_B19), 38, "CHIP", FONT_B19, LIME, 2);
    }
    const char* names[6] = {"PLUG", "TX", "RX", "RST", "EN", "GO"};
    int vals[6] = {s.pins[0], s.pins[1], s.pins[2], s.pins[3], s.en, s.go};
    for (int k = 0, x = 4; k < 6; k++, x += 53) {
        int v = vals[k];
        f.rect(x, 74, x + 12, 86, v > 0 ? LIME : BG, true);
        f.rect(x, 74, x + 12, 86, v >= 0 ? LIME : LINE, false);
        f.text(x + 15, 72, names[k], FONT_B13, v >= 0 ? LEMON : MUTED, 0);
    }
    const int nchips = int(s.chip_state.size()), cols = (nchips + 2) / 3;   // 21 columns (S9) or 24 (L3+)
    const int top = 92, cw = (W - 8) / (cols > 0 ? cols : 21);
    for (int i = 0; i < nchips; i++) {
        int r = i / 3, k = i % 3, x0 = 4 + r * cw, y0 = top + k * 8;
        f.rect(x0, y0, x0 + cw - 2, y0 + 6, state_color(i < int(s.chip_state.size()) ? s.chip_state[size_t(i)] : "unknown"));
    }
    f.line_h(top + 26, LINE);
    int y = top + 29, rows = (H - y) / 18;
    std::vector<std::pair<std::string, uint16_t>> lines;
    for (auto& e : s.log) {
        uint16_t c = e.first == "error" ? ORANGE : e.first == "warn" ? LEMON : LIME;
        std::string t = e.second;
        for (size_t i = 0; i < std::max<size_t>(1, t.size()); i += 33) lines.emplace_back(t.substr(i, 33), c);
    }
    size_t from = lines.size() > size_t(rows) ? lines.size() - size_t(rows) : 0;
    for (size_t i = from; i < lines.size(); i++, y += 18) f.text(3, y, lines[i].first, FONT_B15, lines[i].second, 0);
}

std::vector<Band> changed_bands(const Frame* prev, const Frame& cur) {
    std::vector<Band> out;
    if (!prev) { out.push_back({0, 0, Frame::W - 1, Frame::H - 1}); return out; }
    int start = -1, last = -1;
    auto row_diff = [&](int y) { return std::memcmp(prev->px[y], cur.px[y], sizeof cur.px[y]) != 0; };
    auto close = [&] {
        int x0 = Frame::W, x1 = -1;
        for (int yy = start; yy <= last; yy++)
            for (int x = 0; x < Frame::W; x++)
                if (prev->px[yy][x] != cur.px[yy][x]) { x0 = std::min(x0, x); x1 = std::max(x1, x); }
        out.push_back({x0, start, x1, last});
    };
    for (int y = 0; y < Frame::H; y++) {
        if (!row_diff(y)) continue;
        if (start < 0) start = y;
        else if (y > last + 6) { close(); start = y; }   // bands closer than 6 rows are merged
        last = y;
    }
    if (start >= 0) close();
    return out;
}

std::string rect_request(const std::string& host, int x, int y, int w, int h, const uint16_t* px) {
    std::string body;
    body.reserve(size_t(w * h * 2));
    for (int i = 0; i < w * h; i++) { body += char(px[i] >> 8); body += char(px[i] & 0xFF); }
    char head[256];
    std::snprintf(head, sizeof head,
                  "POST /rect?x=%d&y=%d&w=%d&h=%d&hud=0 HTTP/1.1\r\nHost: %s\r\nContent-Length: %zu\r\nConnection: close\r\n\r\n",
                  x, y, w, h, host.c_str(), body.size());
    return head + body;
}

#ifndef _WIN32
bool CydScreen::post(const Frame& f, const Band& b, std::string& why) {   // one retry: the CYD is sometimes busy
    if (post_once(f, b, why)) return true;
    std::this_thread::sleep_for(std::chrono::milliseconds(50));
    return post_once(f, b, why);
}

bool CydScreen::post_once(const Frame& f, const Band& b, std::string& why) {
    int w = b.x1 - b.x0 + 1, h = b.y1 - b.y0 + 1;
    std::vector<uint16_t> px(size_t(w * h));
    for (int y = 0; y < h; y++) std::memcpy(&px[size_t(y * w)], &f.px[b.y0 + y][b.x0], size_t(w) * 2);
    std::string req = rect_request(host_, b.x0, b.y0, w, h, px.data());
    addrinfo hints{}, *res = nullptr;
    hints.ai_socktype = SOCK_STREAM;
    if (getaddrinfo(host_.c_str(), "8091", &hints, &res) != 0 || !res) { why = "cannot find " + host_; return false; }
    int fd = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
    timeval tv{3, 0};
    setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof tv);
    setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof tv);
    bool ok = fd >= 0 && connect(fd, res->ai_addr, res->ai_addrlen) == 0;
    freeaddrinfo(res);
    size_t off = 0;
    while (ok && off < req.size()) {
        ssize_t k = send(fd, req.data() + off, req.size() - off, MSG_NOSIGNAL);
        if (k <= 0) ok = false; else off += size_t(k);
    }
    char r[32] = {0};
    bool sent = ok;
    ssize_t got = ok ? recv(fd, r, sizeof r - 1, 0) : -1;
    if (ok) ok = got > 12 && std::strncmp(r, "HTTP/1.1 200", 12) == 0;
    int err = errno;
    if (fd >= 0) close(fd);
    if (!ok) {
        why = !sent ? "cannot send to " + host_ + " (" + std::strerror(err) + ")"
                    : "the CYD answered \"" + std::string(r, got > 0 ? size_t(got) : 0).substr(0, 20) + "\" (" +
                          std::to_string(w) + "x" + std::to_string(h) + " at " + std::to_string(b.x0) + "," + std::to_string(b.y0) + ")";
        for (auto& ch : why) if (ch == '\r' || ch == '\n') ch = ' ';
    }
    return ok;
}

void CydScreen::run() {
    std::unique_ptr<Frame> prev, cur(new Frame);
    std::string err;
    auto last_hud = std::chrono::steady_clock::now() - std::chrono::seconds(10);
    for (;;) {
        auto t0 = std::chrono::steady_clock::now();
        render(*cur, state_());
        std::string why;
        bool ok = true;
        for (const Band& b : changed_bands(prev.get(), *cur)) if (!(ok = post(*cur, b, why))) break;
        auto tnow = std::chrono::steady_clock::now();
        if (ok && tnow - last_hud > std::chrono::seconds(2)) {   // the old-firmware corner, also the keep-alive
            ok = post(*cur, {HUD_X, HUD_Y, HUD_X + HUD_W - 1, HUD_Y + HUD_H - 1}, why);
            last_hud = tnow;
        }
        if (ok) {
            if (!err.empty() && log_) log_("CYD screen: sending again");
            err.clear();
            if (!prev) prev.reset(new Frame);
            std::swap(prev, cur);
            if (!cur) cur.reset(new Frame);
        } else {
            if (err.empty() && log_) log_("CYD screen: " + why + " (retrying)");
            err = why;
            prev.reset();                          // send everything once it answers again
            std::this_thread::sleep_for(std::chrono::seconds(1));
        }
        auto dt = std::chrono::steady_clock::now() - t0;
        if (dt < std::chrono::milliseconds(166)) std::this_thread::sleep_for(std::chrono::milliseconds(166) - dt);
    }
}

void CydScreen::start() { std::thread([this] { run(); }).detach(); }
#else
void CydScreen::start() {}
#endif
