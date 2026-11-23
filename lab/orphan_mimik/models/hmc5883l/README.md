# MIMIK chip model: HMC5883L (compass)

Honeywell HMC5883L 3-axis magnetometer (digital compass): 12-bit, X Z Y order, ID "H43".

Default I2C address: 0x1e. 3.3 V buses only.

## Values you control (SENSORZ page)

| Value | Range | Default |
|---|---|---|
| Heading | 0 .. 360 deg | 90 |
| Field strength | 0 .. 1 gauss | 0.5 |
| Inclination (dip) | -90 .. 90 deg | 60 |

Each value can be fixed (slider), or move by itself: sine, ramp or noise, with an amplitude and a period.

## Registers

| Register | What | Notes |
|---|---|---|
| 0 CRA, 1 CRB, 2 MODE | settings: 0x10, 0x20, 0x01 | CRB bits 7..5 set the gain |
| 3..8 | X, Z, Y: high byte first, two's complement (read-only) | |
| 9 | status: 1 = data ready (read-only) | |
| 10, 11, 12 | ID: "H", "4", "3" (read-only) | |

The level heading is atan2(Y, X) on the chip's axes, so X = H cos(heading), Y = H sin(heading), with H = field x cos(dip), Z = field x sin(dip) (down positive). The counts follow the gain in CRB (1090 counts / gauss at the power-up setting). Many cheap "HMC5883L" boards really carry a QMC5883L: if the driver finds nothing at 0x1E, use the QMC5883L model.

Read-only registers: the bus master's writes there are ACKed and dropped, like the real chip.
