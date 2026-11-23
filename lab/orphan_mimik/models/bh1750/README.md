# MIMIK chip model: BH1750 (light)

ROHM BH1750 ambient light sensor: write a mode command, read 2 bytes of lux x 1.2.

Default I2C address: 0x23. 3.3 V buses only.

## Values you control (SENSORZ page)

| Value | Range | Default |
|---|---|---|
| Light | 0 .. 54612 lux | 350 |

Each value can be fixed (slider), or move by itself: sine, ramp or noise, with an amplitude and a period.

## Registers

| Register | What | Notes |
|---|---|---|
| commands 0x10, 0x13, 0x20, 0x23 | high-resolution / low-resolution modes: reads give round(lux x 1.2) | |
| commands 0x11, 0x21 | high-resolution mode 2: reads give round(lux x 2.4) (half-lux steps) | |
| 0x00 power down, 0x01 power on, 0x07 reset | accepted | |

The chip has no registers: the command byte picks the mode and every read returns the latest measurement. The model keeps the measurement under each mode command, so any driver sequence reads the right value. Address 0x23 (ADDR pin low) or 0x5C (high). The measuring-time register (MTreg) is not emulated (default 69).

Read-only registers: the bus master's writes there are ACKed and dropped, like the real chip.
