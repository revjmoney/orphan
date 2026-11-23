# MIMIK chip model: SRF02 (distance)

Devantech SRF02 ultrasonic range finder: write a command to register 0, wait for the ping, read the range.

Default I2C address: 0x70. 3.3 V buses only.

## Values you control (SENSORZ page)

| Value | Range | Default |
|---|---|---|
| Distance | 15 .. 600 cm | 120 |

Each value can be fixed (slider), or move by itself: sine, ramp or noise, with an amplitude and a period.

## Registers

| Register | What | Notes |
|---|---|---|
| 0 | read: software revision (6); write: command 0x50 inches, 0x51 cm, 0x52 microseconds | |
| 1 | unused, reads 0x80 | |
| 2, 3 | the range, high byte first, in the unit of the last command | read-only |
| 4, 5 | autotune minimum range (cm) | read-only |

Like the real chip it does not answer its address for about 65 ms after a ranging command (the write cycle setting), so drivers that poll for the ACK or wait 70 ms both work. Address 0x70 (0xE0 in the datasheet's 8-bit form).

Read-only registers: the bus master's writes there are ACKed and dropped, like the real chip.
