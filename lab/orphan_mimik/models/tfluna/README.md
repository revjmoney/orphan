# MIMIK chip model: TF-Luna (distance)

Benewake TF-Luna LiDAR (time of flight) in I2C mode: distance, signal strength and chip temperature.

Default I2C address: 0x10. 3.3 V buses only.

## Values you control (SENSORZ page)

| Value | Range | Default |
|---|---|---|
| Distance | 20 .. 800 cm | 150 |
| Signal strength | 0 .. 30000  | 2000 |
| Chip temperature | -10 .. 60 C | 30 |

Each value can be fixed (slider), or move by itself: sine, ramp or noise, with an amplitude and a period.

## Registers

| Register | What | Notes |
|---|---|---|
| 0x00, 0x01 | distance in cm, low byte first (read-only) | |
| 0x02, 0x03 | signal strength (amp), low byte first (read-only) | |
| 0x04, 0x05 | chip temperature in 0.01 C, low byte first (read-only) | |
| 0x06, 0x07 | tick (ms), counts up | read-only |

Register map from Benewake's TF-Luna manual (I2C mode, address 0x10). Only the measurement registers are emulated; the settings registers (0x20 and up) just store what is written. **Not yet checked against a real TF-Luna.** A weak signal (amp under 100) means the real sensor reports its distance as unreliable.

Read-only registers: the bus master's writes there are ACKed and dropped, like the real chip.
