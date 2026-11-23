#!/usr/bin/env python3
"""MIMIK sensor chips, hardware test on the board: each sensor model is loaded, given values, and read through the
real I2C pads by the board's own I2C master the way that chip's usual driver reads it. The bytes are decoded here
with the datasheet formulas (independently of the model code) and compared with the values that were set.
   python3 sensor_test.py          (with orphan_mimik loaded and its program stopped: ardzy stop)
by JMSCNC, makers of RotatoCAM. [Rev. J. Money - 2026] GPL-3.0-or-later."""
import math
import sys
import time

from mimik_hw import Mimik

m = Mimik()
fails = []
START, STOP, WRITE, RACK, RNACK = 1, 2, 3, 4, 5


def check(name, ok, info=''):
    print('%-4s %s %s' % ('ok' if ok else 'FAIL', name, info), flush=True)
    if not ok:
        fails.append(name)


def load(mid, **v):
    m.load_model(mid)
    vals = {c['id']: c['default'] for c in m.model['controls']}
    vals.update(v)
    m.plugin.update(m, vals)
    return vals


def set_vals(vals, **v):
    vals.update(v)
    m.plugin.update(m, vals)


def rd(dev, reg, n, khz=100):
    return m.m_read(dev, reg, n, khz)


def wr(dev, reg, data, khz=100):
    return m.m_write(dev, reg, data, khz)


def s16(hi, lo):
    v = hi << 8 | lo
    return v - 65536 if v & 0x8000 else v


# ---- temperature
v = load('tmp102', temp=25.0)
b = rd(0x48, 0, 2)
check('TMP102 25.0 C', (s16(b[0], b[1]) >> 4) * 0.0625 == 25.0, b.hex())
set_vals(v, temp=-10.5)
b = rd(0x48, 0, 2)
check('TMP102 -10.5 C (negative)', (s16(b[0], b[1]) >> 4) * 0.0625 == -10.5, b.hex())
b = rd(0x48, 0, 4)
check('TMP102 a 4-byte read wraps inside the register', b[:2] == b[2:], b.hex())
wr(0x48, 0, [0x12, 0x34])
check('TMP102 temperature register is read-only', (s16(*rd(0x48, 0, 2)) >> 4) * 0.0625 == -10.5)
wr(0x48, 2, [0x3C, 0x00])
check('TMP102 T LOW is writable (60 C)', rd(0x48, 2, 2) == b'\x3c\x00')
check('TMP102 config at power-up 0x60A0', rd(0x48, 1, 2) == b'\x60\xa0')

v = load('lm75', temp=22.5)
b = rd(0x48, 0, 2)
check('LM75 22.5 C', (s16(b[0], b[1]) >> 7) * 0.5 == 22.5, b.hex())
set_vals(v, temp=-3.0)
b = rd(0x48, 0, 2)
check('LM75 -3.0 C', (s16(b[0], b[1]) >> 7) * 0.5 == -3.0, b.hex())


# ---- infrared
def crc8(data):
    c = 0
    for x in data:
        c ^= x
        for _ in range(8):
            c = ((c << 1) ^ 7) & 0xFF if c & 0x80 else (c << 1) & 0xFF
    return c


v = load('mlx90614', object=36.6, ambient=23.0)
for cmd, want in ((0x07, 36.6), (0x06, 23.0)):
    b = rd(0x5A, cmd, 3)
    t = (b[1] << 8 | b[0]) * 0.02 - 273.15
    check('MLX90614 command %02x = %.2f C' % (cmd, want), abs(t - want) < 0.011, '%.3f' % t)
    check('MLX90614 command %02x PEC is right' % cmd, b[2] == crc8([0xB4, cmd, 0xB5, b[0], b[1]]), b.hex())
set_vals(v, object=-20.0)
b = rd(0x5A, 0x07, 3)
check('MLX90614 object -20 C', abs((b[1] << 8 | b[0]) * 0.02 - 273.15 + 20) < 0.011)

# ---- distance
v = load('srf02', distance=123)
m.events()
ok = wr(0x70, 0, [0x51])                            # range in cm
for e in m.events():
    m.plugin.on_event(m, e, v)
t = time.time()
polls = 0
while not wr(0x70, 1, []) and time.time() - t < 0.2:   # NACK while it "pings"
    polls += 1
dt = (time.time() - t) * 1000
check('SRF02 does not answer while ranging (~65 ms)', ok and polls > 0 and 55 < dt < 90, '%d polls, %.0f ms' % (polls, dt))
b = rd(0x70, 0, 4)
check('SRF02 revision 6, range 123 cm', b[0] == 6 and (b[2] << 8 | b[3]) == 123, b.hex())
wr(0x70, 0, [0x50])                                 # inches
for e in m.events():
    m.plugin.on_event(m, e, v)
time.sleep(0.08)
b = rd(0x70, 2, 2)
check('SRF02 in inches: 48', (b[0] << 8 | b[1]) == round(123 / 2.54), b.hex())

v = load('tfluna', distance=257, amp=1500, temp=31.25)
b = rd(0x10, 0, 6)
check('TF-Luna 257 cm, amp 1500, 31.25 C', (b[1] << 8 | b[0]) == 257 and (b[3] << 8 | b[2]) == 1500 and
      (b[5] << 8 | b[4]) == 3125, b.hex())

# ---- compass
v = load('hmc5883l', heading=30, field=0.5, dip=60)
check('HMC5883L ID "H43"', rd(0x1E, 10, 3) == b'H43')
b = rd(0x1E, 3, 6)
x, z, y = s16(b[0], b[1]), s16(b[2], b[3]), s16(b[4], b[5])
hd = math.degrees(math.atan2(y, x)) % 360
check('HMC5883L heading 30 deg', abs(hd - 30) < 0.3, 'x %d y %d z %d -> %.2f' % (x, y, z, hd))
check('HMC5883L 1090 counts / gauss', abs(math.sqrt(x * x + y * y + z * z) - 545) < 2, '%.1f' % math.sqrt(x * x + y * y + z * z))
wr(0x1E, 1, [0xE0])                                 # gain 230 counts / gauss
set_vals(v, heading=250)
b = rd(0x1E, 3, 6)
x, z, y = s16(b[0], b[1]), s16(b[2], b[3]), s16(b[4], b[5])
check('HMC5883L follows the gain the driver sets (230)', abs(math.sqrt(x * x + y * y + z * z) - 115) < 2 and
      abs(math.degrees(math.atan2(y, x)) % 360 - 250) < 1, '%d %d %d' % (x, y, z))

v = load('qmc5883l', heading=200, field=0.5, dip=0)
check('QMC5883L chip ID 0xFF', rd(0x0D, 0x0D, 1) == b'\xff')
b = rd(0x0D, 0, 7)
x, y = s16(b[1], b[0]), s16(b[3], b[2])
check('QMC5883L heading 200 deg, 12000 counts / gauss', abs(math.degrees(math.atan2(y, x)) % 360 - 200) < 0.1 and
      abs(math.hypot(x, y) - 6000) < 2 and b[6] & 1, 'x %d y %d' % (x, y))

# ---- motion
v = load('mpu6050', ax=0.5, ay=-0.25, az=1.0, gx=10, gy=-20, gz=125, temp=30)
check('MPU-6050 WHO_AM_I 0x68', rd(0x68, 0x75, 1) == b'\x68')
b = rd(0x68, 0x3B, 14)
w = [s16(b[i], b[i + 1]) for i in range(0, 14, 2)]
check('MPU-6050 accel 0.5 / -0.25 / 1 g', w[:3] == [8192, -4096, 16384], str(w[:3]))
check('MPU-6050 temperature 30 C', abs(w[3] / 340 + 36.53 - 30) < 0.01, str(w[3]))
check('MPU-6050 gyro 10 / -20 / 125 deg/s', w[4:] == [1310, -2620, 16375], str(w[4:]))
wr(0x68, 0x1C, [0x08])                              # +-4 g
m.plugin.update(m, v)
b = rd(0x68, 0x3F, 2)
check('MPU-6050 follows ACCEL_CONFIG (+-4 g: 1 g = 8192)', s16(b[0], b[1]) == 8192)

# ---- light
v = load('bh1750', lux=500)
r = m.i2c([(START, 0), (WRITE, 0x23 << 1), (WRITE, 0x10), (STOP, 0)])
r = m.i2c([(START, 0), (WRITE, 0x23 << 1 | 1), (RACK, 0), (RNACK, 0), (STOP, 0)])
n = r[1][1] << 8 | r[2][1]
check('BH1750 continuous H-res: 500 lux -> 600 counts', n == 600 and n / 1.2 == 500, str(r))
m.i2c([(START, 0), (WRITE, 0x23 << 1), (WRITE, 0x11), (STOP, 0)])
r = m.i2c([(START, 0), (WRITE, 0x23 << 1 | 1), (RACK, 0), (RNACK, 0), (STOP, 0)])
check('BH1750 H-res mode 2: 1200 counts (0.5 lux steps)', (r[1][1] << 8 | r[2][1]) == 1200, str(r))

m.load_model('24c02')
print('\n%d failed' % len(fails) + (': ' + ', '.join(fails) if fails else ''))
sys.exit(1 if fails else 0)
