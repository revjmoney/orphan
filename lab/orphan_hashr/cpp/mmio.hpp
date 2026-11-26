// [orphan] H4SHR-CH3KR hashrd: physical memory window (/dev/mem) and the Ardzy register bus.
// by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#pragma once
#include <cstddef>
#include <cstdint>

class Mmio {
public:
    Mmio(uint32_t base, size_t len);
    ~Mmio();
    Mmio(const Mmio&) = delete;
    Mmio& operator=(const Mmio&) = delete;
    uint32_t rd(uint32_t off) const { return p_[off / 4]; }
    void wr(uint32_t off, uint32_t v) { p_[off / 4] = v; }
private:
    volatile uint32_t* p_ = nullptr;
    size_t len_ = 0;
};

// Slot s, word i lives at 0x43C00000 + s * 0x1000 + 4 * i (Ardzy bus).
class Bus {
public:
    static constexpr uint32_t BASE = 0x43C00000;
    Bus() : m_(BASE, 0x10000) {}
    uint32_t rd(int slot, int i) const { return m_.rd(slot * 0x1000 + 4 * i); }
    void wr(int slot, int i, uint32_t v) { m_.wr(slot * 0x1000 + 4 * i, v); }
private:
    Mmio m_;
};
