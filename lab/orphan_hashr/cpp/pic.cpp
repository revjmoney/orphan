// [orphan] H4SHR-CH3KR hashrd: PIC control. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "pic.hpp"
#include <chrono>
#include <cstdio>
#include <thread>

namespace {
constexpr int GAP_US = 2000;                      // pause after every PIC transfer
const uint8_t FORBIDDEN[] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x08, 0x09};
void sleep_us(int us) { std::this_thread::sleep_for(std::chrono::microseconds(us)); }
double now() { return std::chrono::duration<double>(std::chrono::steady_clock::now().time_since_epoch()).count(); }
std::string hex(const std::vector<uint8_t>& v) {
    std::string s;
    char b[4];
    for (size_t i = 0; i < v.size(); i++) { std::snprintf(b, sizeof b, i ? " %02X" : "%02X", v[i]); s += b; }
    return s;
}
}

int Pic::volts_to_pic(double v) {
    int p = int(1608.420446 - 170.423497 * v);
    return p < 0 ? 0 : (p > 255 ? 255 : p);
}

double Pic::pic_to_volts(int p) { return (1608.420446 - p) / 170.423497; }

void Pic::send(std::vector<uint8_t> codes) {
    for (uint8_t f : FORBIDDEN)
        if (!codes.empty() && codes[0] == f) throw PicError("PIC flash command never sent");
    codes.insert(codes.begin(), {0x55, 0xAA});
    trace("PIC>", hex(codes));
    for (size_t i = 0; i < codes.size(); i++) {
        bool ok = hw_.i2c_write(bus_, addr_, &codes[i], 1);
        sleep_us(GAP_US);
        if (!ok) throw PicError("no answer from the PIC at byte " + std::to_string(i) + " of " + hex(codes));
    }
}

std::vector<uint8_t> Pic::read(int n) {
    std::vector<uint8_t> out;
    for (int i = 0; i < n; i++) {
        uint8_t b = 0;
        bool ok = hw_.i2c_read(bus_, addr_, &b, 1);
        sleep_us(GAP_US);
        if (!ok) { trace("ERR", "PIC read: no answer"); throw PicError("PIC stopped answering"); }
        out.push_back(b);
    }
    trace("PIC<", hex(out));
    return out;
}

bool Pic::present() { return hw_.i2c_write(bus_, addr_, nullptr, 0); }

void Pic::wait_present(double seconds) {
    double end = now() + seconds;
    while (now() < end) {
        if (present()) return;
        sleep_us(50000);
    }
    throw PicError("PIC does not answer");
}

void Pic::resync() {
    uint8_t b;
    hw_.i2c_read(bus_, addr_, &b, 1);
    sleep_us(GAP_US);
}

uint8_t Pic::version() {
    std::lock_guard<std::recursive_mutex> g(lock_);
    send({0x17});
    return read(1)[0];
}

uint8_t Pic::ensure_app(double seconds) {
    std::lock_guard<std::recursive_mutex> g(lock_);
    wait_present();
    resync();
    uint8_t v = version();
    if (v == LOADER) {
        send({0x06});
        double end = now() + seconds;
        while (now() < end) {
            sleep_us(100000);
            if (!present()) continue;
            v = version();
            if (v != LOADER) break;
        }
    }
    in_app_ = (v == APP_VERSION);
    if (!in_app_) {
        char b[48];
        std::snprintf(b, sizeof b, "PIC version not supported (0x%02X)", v);
        throw PicError(v == LOADER ? "PIC still in its bootloader" : b);
    }
    return v;
}

uint8_t Pic::reset() {
    std::lock_guard<std::recursive_mutex> g(lock_);
    in_app_ = false;
    send({0x07});
    sleep_us(200000);
    wait_present();
    return ensure_app();
}

uint8_t Pic::reset_l3() {                         // stock L3+ cgminer: 07, 100 ms + 1000 ms, 06, 100 ms + 1000 ms
    std::lock_guard<std::recursive_mutex> g(lock_);
    in_app_ = false;
    send({0x07});
    sleep_us(1100000);
    wait_present();
    send({0x06});
    sleep_us(1100000);
    return ensure_app();
}

void Pic::need_app() {
    if (!in_app_) throw PicError("PIC not in its application");
}

std::vector<uint8_t> Pic::board_id() {
    std::lock_guard<std::recursive_mutex> g(lock_);
    need_app();
    send({0x13});
    return read(12);
}

std::vector<uint8_t> Pic::temp_table() {         // 4 pairs of (sensor chip + 1, offset), as bmminer reads them
    std::lock_guard<std::recursive_mutex> g(lock_);
    need_app();
    send({0x23});
    return read(8);
}

std::vector<int> Pic::temp_hosts() {
    auto raw = temp_table();
    std::vector<int> hosts;
    for (int i = 0; i < 8; i += 2)
        if (raw[i] > 0 && raw[i] <= 63) hosts.push_back((raw[i] - 1) * 4);
    if (hosts.empty()) hosts.push_back(0xF4);
    return hosts;
}

void Pic::set_voltage(double v) {
    std::lock_guard<std::recursive_mutex> g(lock_);
    if (v < V_MIN || v > V_MAX) throw PicError("voltage outside 8.60 to 9.40 V");
    need_app();
    send({0x10, uint8_t(volts_to_pic(v))});
    sleep_us(100000);
}

double Pic::voltage() {
    std::lock_guard<std::recursive_mutex> g(lock_);
    need_app();
    send({0x18});
    return pic_to_volts(read(1)[0]);
}

void Pic::enable(bool on) {
    std::lock_guard<std::recursive_mutex> g(lock_);
    if (on) need_app();
    else if (!in_app_) return;                     // never powered by us; the bootloader must not get app commands
    send({0x15, uint8_t(on ? 1 : 0)});
}

void Pic::heartbeat() {
    std::lock_guard<std::recursive_mutex> g(lock_);
    need_app();
    send({0x16});
}
