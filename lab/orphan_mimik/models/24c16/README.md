# MIMIK chip model: 24C16

24C16 family: 16 Kbit I2C EEPROM. Takes addresses 0x50..0x57: the low 3 address bits pick the 256-byte block.

One chip answers on 8 addresses. Common in car dashboards (odometer / immobiliser data) and set-top boxes.

| Setting | Value |
|---|---|
| I2C address | 0x50 (change it to 0x50..0x57 like the chip's A0..A2 pins) |
| Size | 2048 bytes |
| Page | 16 bytes (a write wraps inside its page, like the real chip) |
| Word address | 1 byte |
| Write cycle | 5000 us (the chip does not answer its address for this long after a write; drivers poll for the ACK) |

## Wiring

3.3 V buses only (the S9's FPGA pins are not 5 V tolerant). Connect the target's SCL, SDA and GND. The target bus
needs pull-ups (most boards have them; the S9's own I2C bus has 1 kohm pull-ups). Default pins: the S9's own I2C
bus, pins 3 (SDA) and 4 (SCL) of J1..J8. Any J1..J9 header pin can be SCL or SDA instead (KHIPZ page).

An empty chip reads 0xFF. Load your own image (a dump of the original chip) on the IMAGE page.
