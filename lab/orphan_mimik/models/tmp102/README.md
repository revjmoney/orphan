# MIMIK chip model: TMP102 (temperature)

TI TMP102 digital temperature sensor: 12-bit, 0.0625 C per count, 16-bit registers.

Default I2C address: 0x48. 3.3 V buses only.

## Values you control (SENSORZ page)

| Value | Range | Default |
|---|---|---|
| Temperature | -55 .. 128 C | 22.5 |

Each value can be fixed (slider), or move by itself: sine, ramp or noise, with an amplitude and a period.

## Registers

| Register | What | Notes |
|---|---|---|
| 0 | temperature (read-only) | 12 bits, MSB first, left-justified: raw = round(T / 0.0625) << 4 |
| 1 | configuration | 0x60A0 at power-up |
| 2 | T LOW | 75 C (0x4B00) |
| 3 | T HIGH | 80 C (0x5000) |

Address 0x48..0x4B on the real chip (ADD0 pin): change the address on KHIPZ.

Read-only registers: the bus master's writes there are ACKed and dropped, like the real chip.
