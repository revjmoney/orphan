# MIMIK chip model: MPU-6050 (motion)

InvenSense MPU-6050 accelerometer + gyroscope (GY-521 boards): 16-bit, high byte first, WHO_AM_I 0x68.

Default I2C address: 0x68. 3.3 V buses only.

## Values you control (SENSORZ page)

| Value | Range | Default |
|---|---|---|
| Accel X | -2 .. 2 g | 0 |
| Accel Y | -2 .. 2 g | 0 |
| Accel Z | -2 .. 2 g | 1 |
| Gyro X | -250 .. 250 deg/s | 0 |
| Gyro Y | -250 .. 250 deg/s | 0 |
| Gyro Z | -250 .. 250 deg/s | 0 |
| Chip temperature | -40 .. 85 C | 25 |

Each value can be fixed (slider), or move by itself: sine, ramp or noise, with an amplitude and a period.

## Registers

| Register | What | Notes |
|---|---|---|
| 0x1B GYRO_CONFIG, 0x1C ACCEL_CONFIG | bits 4..3 pick the range | |
| 0x3B..0x40 | accel X, Y, Z (read-only) | high byte first |
| 0x41, 0x42 | temperature: raw = (T - 36.53) x 340 (read-only) | |
| 0x43..0x48 | gyro X, Y, Z (read-only) | |
| 0x6B PWR_MGMT_1 | 0x40 at power-up (sleep) | |
| 0x75 WHO_AM_I | 0x68 (read-only) | |

Counts follow the ranges the driver sets: accel 16384 / 8192 / 4096 / 2048 per g, gyro 131 / 65.5 / 32.8 / 16.4 per deg/s. The real chip only measures after the driver clears the sleep bit; this model always answers. The DMP and the FIFO are not emulated.

Read-only registers: the bus master's writes there are ACKed and dropped, like the real chip.
