# MIMIK chip model: MLX90614 (infrared)

Melexis MLX90614 infrared (non-contact) thermometer: SMBus, 0.02 K per count, every word with its PEC byte.

Default I2C address: 0x5a. 3.3 V buses only.

## Values you control (SENSORZ page)

| Value | Range | Default |
|---|---|---|
| Object (IR) temperature | -70 .. 380 C | 36.6 |
| Ambient (chip) temperature | -40 .. 125 C | 23.0 |

Each value can be fixed (slider), or move by itself: sine, ramp or noise, with an amplitude and a period.

## Registers

| Register | What | Notes |
|---|---|---|
| 0x06 | Ta, ambient (read-only) | LSB, MSB, PEC: raw = round((T + 273.15) / 0.02) |
| 0x07 | Tobj1, the object (read-only) | same |
| 0x08 | Tobj2 (read-only) | same as Tobj1 (single-zone chips) |

A read is: START, address+W, command (the RAM address), repeated START, address+R, 3 bytes (LSB, MSB, PEC). The PEC is SMBus CRC-8 (polynomial 0x07) over the address bytes, the command and the data, computed here so drivers that check it are happy. EEPROM words (0x20..0x3F) read as 0 in this model. SMBus is 100 kHz max on the chip.

Read-only registers: the bus master's writes there are ACKed and dropped, like the real chip.
