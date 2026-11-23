# MIMIK chip model: LM75 (temperature)

LM75 / LM75A digital temperature sensor: 9-bit, 0.5 C per count, 16-bit registers.

Default I2C address: 0x48. 3.3 V buses only.

## Values you control (SENSORZ page)

| Value | Range | Default |
|---|---|---|
| Temperature | -55 .. 125 C | 22.5 |

Each value can be fixed (slider), or move by itself: sine, ramp or noise, with an amplitude and a period.

## Registers

| Register | What | Notes |
|---|---|---|
| 0 | temperature (read-only) | 9 bits, MSB first: raw = round(T * 2) << 7 |
| 1 | configuration | 0x00 (one byte on the chip) |
| 2 | T HYST | 75 C (0x4B00) |
| 3 | T OS | 80 C (0x5000) |

Address 0x48..0x4F on the real chip (A0..A2 pins). The LM75A has 11 bits; this model gives the classic 9.

Read-only registers: the bus master's writes there are ACKed and dropped, like the real chip.
