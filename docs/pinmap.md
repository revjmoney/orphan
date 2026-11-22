# Antminer S9 control board: FPGA pin map

Chip: Xilinx Zynq xc7z010clg400-1 (dual Cortex-A9 667 MHz + Artix-7-class fabric, 512 MB DDR3).

Pin facts collected from the publicly circulated control board schematic and AMD's package file, and
**cross-checked against Ardzy's pin table** (tested on a real S9). Orphan's own designs use J8 (radio),
J3 (I2S DAC), the fan pins and the 4 FPGA LEDs, all as listed here.

## Hashboard connectors J1..J9 (2x9, 18-pin)

All on FPGA bank 34 (3.3 V, LVCMOS33). Every line has a 4.7K pull-up to 3.3 V and goes
straight to the FPGA: no buffer, no protection, NOT 5 V tolerant.

Connector pins: **5 = PLUG, 11 = TXD, 12 = RXD, 15 = RST** (the 4 FPGA pins),
16 = 3.3 V, 18 = EN (driven from the ARM side, PS MIO, not the FPGA), GND on 1/2/9/10/13/14.
(Pin numbers per Ardzy's tested table. An earlier draft of this file had 11/12/15 wrong.)
The shared I2C bus also reaches the connectors (SCL1/SDA1); confirm its connector pin numbers.

| Conn | pin 5 PLUG | pin 11 TXD | pin 12 RXD | pin 15 RST | EN (PS MIO) |
|------|-----|-----|-----|-----|-------------|
| J1 | T11 | T12 | U12 | T10 | MIO28 |
| J2 | R19 | V12 | W13 | V13 | MIO29 |
| J3 | T14 | P14 | R14 | T15 | MIO30 |
| J4 | Y16 | W14 | Y14 | Y17 | MIO31 |
| J5 | T16 | V15 | W15 | U17 | MIO32 |
| J6 | U14 | U18 | U19 | U15 | MIO33 |
| J7 | T20 | V20 | W20 | U20 | MIO34 |
| J8 | Y18 | V16 | W16 | Y19 | MIO35 |
| J9 | R16 | T17 | R18 | R17 | MIO36 |

(EN MIO numbers for J7..J9 follow the J1..J6 pattern seen in the schematic; confirm.)
Stock S9 mining uses only J6, J7, J8. The PLUG/TXD/RXD/RST names are only Bitmain's use:
to the FPGA they are 36 general-purpose 3.3 V I/O.

## Shared I2C (bank 34)
- SCL1 W18, SDA1 W19 (to the hashboard connectors)
- SCL2 N17, SDA2 P18

## Fans (bank 35)
- FAN_PWM J18 (one PWM shared by all fan headers)
- FAN_SPEED1..6 tach inputs: F19, F20, G17, G18, J20, H20
- Bank 35 looks like 3.3 V in the schematic; verify on the board.
- F19/F20 (AD12) and J20/H20 (AD5) are XADC analog pairs, J18 is AD4P. With the pull-ups
  removed they could be slow analog inputs (0..1 V range).

## LEDs, buttons, buzzer
- Per Ardzy's board.json (tested): green LED MIO38, red LED MIO37, PS LED MIO15 (active low),
  IP button MIO51 (active low), reset button MIO47 (active low), buzzer MIO39. All ARM side.
- FPGA LEDs D5..D8: F16, L19, M19, M17, active LOW. Orphan's `orphan_leds` block dims them with PWM.

## Clock
- 100 MHz oscillator into N18 (bank 34 MRCC) and K17 (bank 35 MRCC).

## On the ARM side (not FPGA)
Ethernet, SD card, NAND, UART console, the connector EN lines, LEDs and buttons all live on PS MIO
pins, so they work with ANY FPGA design, or none. The FPGA can be reloaded freely without losing
network or SD. (Unlike the EBAZ4205, whose Ethernet goes through the FPGA.)

## Totals
49 FPGA pins per Ardzy (36 on J1..J9, I2C, fans) plus the 4 bank-35 LED nets = ~51-53 usable.

Example LinuxCNC / HostMot2 split:
- 6 step/dir pairs (12 pins) for axes
- 3 encoders A/B/Z (9 pins) for spindle and handwheels
- 1 spindle PWM
- ~25 left for limit/home/probe inputs and relay outputs
Every pin needs a breakout: buffered outputs (74HCT-style to 5 V for TB6600s) and opto-isolated
inputs. Never wire switches or drivers straight to these pins.

## Do NOT use
- braiins/zynq-io `design/src/constrs/pin_assignment.tcl`: targets Braiins' "G9/G19" board, and
  its pins disagree with the S9 schematic (e.g. it drives R19, which is J2 PLUG on the S9).
  Its address map and IP list are still a useful reference (MIT licensed).

## Sources
- Ardzy (tested S9 pin table, Debian image): https://github.com/chrysovalantischryso/ardzy
- Schematic + notes: https://github.com/polprog/antminer_zynq (GPL-2.0, schematic is Bitmain's)
- Package file: https://www.xilinx.com/support/packagefiles/z7packages/xc7z010clg400pkg.txt
- S9 dev-board examples (HDMI, LCD2004 over I2C, SPI TFTs): https://github.com/astranome/Astra_S9_FPGA
- Mainline U-Boot has an S9 board target (bitmain-antminer-s9.dts).
