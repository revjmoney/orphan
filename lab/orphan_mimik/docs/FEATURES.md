# MIMIK features and settings log

## Features
| Feature | Status |
|---|---|
| I2C target engine (24Cxx behaviour, 100 kHz / 400 kHz / 1 MHz) | done, tested in sim and on the board's pads |
| 32 KB image, ARM read/write port, saved like a real EEPROM (image.local.bin) | done |
| WP, write-cycle ACK polling (TWR) | done |
| SCL / SDA on any of the 36 header pins or the board I2C bus | done; header pins not yet tested with an outside master |
| Event log (512 deep) + LIVE page + hit map | done |
| Models 24C02, 24C16, 24C32, 24C256 | done |
| KHECK self-test (board I2C master) | done |
| Register mode (16 / 32-bit registers) and read-only bytes | done, sim + board |
| Sensor family: TMP102, LM75, MLX90614, SRF02, TF-Luna, HMC5883L, QMC5883L, MPU-6050, BH1750 | done, 30 / 30 on the board; TF-Luna map not checked against a real unit |
| SENSORZ page: sliders + sine / ramp / square / noise | done |
| Outside-master test (Pi / ESP32) | not done |
| SPI flash, parallel ROM, UART, 1-Wire engines | not started |

## Settings (defaults)
| Setting | Default |
|---|---|
| model | 24c02 |
| I2C address | 0x50 (mask 0x7f; 24C16 uses 0x78) |
| write cycle | 5000 us |
| WP | off |
| SCL / SDA | 36 / 37 (board I2C bus) |

## Change log
- 2026-11-23: v1 built and tested (sim 79/79, board 19/19); pointer is masked to the chip size and reset on a model change.
- 2026-11-23: sensor chip family, register mode, read-only bytes, SENSORZ page (sim 99/99, board 30/30 sensors + 20/20 memory).
