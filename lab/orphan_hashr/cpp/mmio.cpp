// [orphan] H4SHR-CH3KR hashrd: /dev/mem mapping. by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later.
#include "mmio.hpp"
#include <fcntl.h>
#include <stdexcept>
#include <sys/mman.h>
#include <unistd.h>

Mmio::Mmio(uint32_t base, size_t len) : len_(len) {
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) throw std::runtime_error("cannot open /dev/mem (run as root)");
    void* m = mmap(nullptr, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, base);
    close(fd);
    if (m == MAP_FAILED) throw std::runtime_error("mmap of the FPGA registers failed");
    p_ = static_cast<volatile uint32_t*>(m);
}

Mmio::~Mmio() {
    if (p_) munmap(const_cast<uint32_t*>(p_), len_);
}
