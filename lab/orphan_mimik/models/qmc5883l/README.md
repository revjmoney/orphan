# MIMIK chip model: QMC5883L (compass)

QST QMC5883L 3-axis magnetometer (the chip on most cheap "GY-271" compass boards): 16-bit, low byte first.

Default I2C address: 0x0d. 3.3 V buses only.

## Values you control (SENSORZ page)

| Value | Range | Default |
|---|---|---|
| Heading | 0 .. 360 deg | 90 |
| Field strength | 0 .. 2 gauss | 0.5 |
| Inclination (dip) | -90 .. 90 deg | 60 |

Each value can be fixed (slider), or move by itself: sine, ramp or noise, with an amplitude and a period.

## Registers

| Register | What | Notes |
|---|---|---|
| 0x00..0x05 | X, Y, Z: low byte first, two's complement (read-only) | |
| 0x06 | status: bit 0 data ready (read-only) | |
| 0x07, 0x08 | temperature (relative, read-only) | |
| 0x09 | control 1: bits 5..4 range (00 = 2 gauss, 01 = 8 gauss) | |
| 0x0A, 0x0B | control 2, SET/RESET period | |
| 0x0D | chip ID 0xFF (read-only) | |

Counts: 12000 per gauss in the 2 gauss range, 3000 in the 8 gauss range (control 1 bits 5..4). Heading = atan2(Y, X) on the chip's axes, as in the HMC5883L model.

Read-only registers: the bus master's writes there are ACKed and dropped, like the real chip.
