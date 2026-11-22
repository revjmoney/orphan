# The board

The Antminer S9 control board (marked "AntMiner_ControlBoard_XC7010"): a Xilinx **Zynq XC7Z010** (two ARM
Cortex-A9 cores at 667 MHz plus an Artix-7-class FPGA), 512 MB DDR3, 256 MB NAND flash, microSD, Ethernet,
and nine 18-pin hashboard connectors that go straight to FPGA pins.

## Power

12 V on the 6-pin PCIe connector. The board alone draws only a few watts.

## Boot jumpers

| Jumpers | Boots from |
|---|---|
| **JP2 = 1, JP4 = 1** | the microSD card (Ardzy, Orphan) |
| JP2 only | the NAND flash (stock firmware, or Orphan's flash install / a netboot kernel) |

## Headers

- **J1 .. J9** (2 x 9): pins 5, 11, 12, 15 are FPGA I/O (3.3 V, 4.7k pull-ups, **not 5 V tolerant**),
  pin 16 = 3.3 V, pin 18 = EN (from the ARM side), the rest GND. Full table: [pinmap.md](pinmap.md).
  - Orphan Radio: **J8 pin 12** RF input, J8 pin 15 RC feedback, J8 pin 5 test transmitter.
  - I2S DAC (PCM5102A) for the radio and the synth: **J3** pins 5 (MCLK), 11 (BCLK), 12 (DOUT), 15 (LRCLK).
- **Fans 1 .. 6**: one PWM for all (FPGA pin J18, 25 kHz in Orphan's designs) and six tach inputs.
  With no FPGA design loaded the fans run at full speed. Every Orphan design includes the fan block, Ardzy's
  examples 01 to 17 get it too (`orphan/fan-bits`), and the menu's **Cooling** screen sets the speed and shows the
  rpm of each header.
- **J12**: 3.3 V serial console, 115200 baud (U-Boot and Linux messages). Needed only for recovery work.

## LEDs, buttons, beeper

- **D5 .. D8**: four FPGA LEDs, active low, dimmable (Orphan uses them for signal level and light shows).
- **D2 / D3**: status LEDs on the ARM side (green MIO38, red MIO37, MIO15). Orphan can use D3 as SD-card activity
  (green = read, red = write).
- Two LEDs near the power plug (power good and FPGA "done") are wired in hardware and stay on.
- **IP button** (MIO51), **Reset button** (MIO47), **beeper** (MIO39): all on the ARM side.

## Sensors

The Zynq's own XADC: die temperature (about 50 C idle) and its supply voltages. The menu's **About this board**
shows them. There are no other sensors on the control board.

---
[Buy me a coffee](https://buymeacoffee.com/revjmoney) · by [JMSCNC](https://jmscnc.com), makers of RotatoCAM · **[Rev. J. Money - 2026]**
