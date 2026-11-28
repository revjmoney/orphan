# Orphan Radio (Orphan 7600)

Orphan Radio is a software defined receiver built inside the FPGA of the Antminer S9 control board. One input pin
covers 1 kHz to 49 MHz with up to four tuners (slices A to D) and a wide panadapter, and the ARM side demodulates
and decodes on the board itself, so the radio works with nothing more than a browser.

Part of **Orphan**, FPGA Dev Linux for the S9 Control Board, by JMSCNC, makers of RotatoCAM.

## Quick start

1. Install Orphan on the board (see the main Orphan README) and log in: the Orphan menu opens.
2. Load the radio, any of these ways:
   - In the Orphan menu press **F** (FPGA projects), find **Orphan Radio** in the tree and load it.
     (The menu also has an **R** shortcut that opens the radio.)
   - Open the board page **http://orphan.local**, click **Orphan Radio**, then **Load**. The radio's own page opens
     in a new tab.
   - From a shell: `ardzy load orphan_radio`
3. The radio's page is on port 8000: **http://orphan.local:8000** (or `http://<board ip>:8000`).
4. Press **SPK** (top right of the receiver) to hear it in the browser. Browsers only allow sound after a click.
5. Pick a band key (for example **AM BC** or **WWV**) or type a frequency, and choose a mode.

To listen without a browser, see [Raw audio for ffplay](#raw-audio-for-ffplay).

When it starts, the program prints which FPGA build it found: `tuners: 4, wide panadapter: yes` means slices B to D
and the wide panadapter are available. With an older one-tuner build the page hides those parts.

## Wiring

All wiring is optional for a first look: the **Loop** input mode feeds the test transmitter to the receiver inside
the FPGA, with no wires at all.

| Connector | Pin | FPGA pin | What it is |
|---|---|---|---|
| J8 | 12 | W16 | **Receiver input** (antenna wire, or the RC front end node) |
| J8 | 5 | Y18 | **Test transmitter** output (square-wave AM carrier) |
| J8 | 15 | Y19 | **RC feedback** output (only used in RC mode) |
| J8 | 16 | none | 3.3 V |
| J8 | 1, 2, 9, 10, 13, 14 | none | GND |
| J3 | 5 | T14 | I2S MCLK to an optional PCM5102A DAC |
| J3 | 11 | P14 | I2S BCLK |
| J3 | 12 | R14 | I2S DOUT (data) |
| J3 | 15 | T15 | I2S LRCLK |
| J3 | 16 | none | 3.3 V for the DAC board |
| J3 | 1, 2, 9, 10, 13, 14 | none | GND |

The four FPGA LEDs (D5 to D8) show the signal strength as a bar. The fan headers keep working (Orphan's fan block
is in this design; set the speed in the menu's **Cooling** screen).

### Safety notes

- **3.3 V only.** The J1 to J9 connector pins go straight to the FPGA: no buffer, no protection, and they are
  **not 5 V tolerant**. Never connect 5 V logic, a 5 V supply or anything with a DC voltage above 3.3 V.
- The board has **no pull-ups** on the J connectors' FPGA pins (measured, see docs/headers.md). This design turns
  on the FPGA's own weak pull-up on J8 pin 12, and the zero-parts antenna mode uses it as part of its circuit.
- **Transmitting needs a licence.** The test transmitter on J8 pin 5 is for bench tests only. Keep it on a short
  wire into a dummy load, a resistor, or a direct short jumper to J8 pin 12. Never connect an antenna to it.
- A long antenna wire can pick up static. Do not leave a long outdoor wire on the input in stormy weather, and
  discharge it before you plug it in.
- The web page has no login. Use the radio on a network you trust.

### The optional PCM5102A DAC on J3

A PCM5102A I2S DAC board on J3 gives a line or headphone output with no PC at all.

| DAC board pin | Board |
|---|---|
| BCK | J3 pin 11 |
| DIN | J3 pin 12 |
| LCK (LRCK) | J3 pin 15 |
| SCK | see below |
| VIN / VCC | J3 pin 16 (3.3 V) |
| GND | J3 GND (pin 1, 2, 9, 10, 13 or 14) |

On the common PCM5102A modules set: **FMT low** (I2S format), **XSMT high** (unmuted), **FLT low** (normal
filter), **DEMP low** (de-emphasis off).

SCK: the design drives a 12.5 MHz master clock (256 times the 48.8 kHz frame rate) on J3 pin 5, while the comment in
the design's top file says "SCK to GND" (the PCM5102A then makes its own clock from BCK). Use **one** of the two:
SCK wired to J3 pin 5, **or** SCK tied to GND and J3 pin 5 left open. Never both at once: an FPGA output driving
into a grounded pin is a short.

What the DAC plays: the FPGA's own **AM** audio of slice A (after the FPGA hum filter and the AF gain). SAM, USB,
LSB, CW and NFM are demodulated on the ARM side and reach the browser and TCP port 8001, not the DAC.

## The antenna front end

### Zero-parts mode (works today)

Put a wire on **J8 pin 12** and choose input mode **Wire** in the **I/O** tab. In this mode the pin is its own
1-bit converter: whenever it reads high the FPGA pulls it low for a few clocks, so the pin hovers at its switching
point (the FPGA's weak pull-up plus the pin's own capacitance), and RF on the wire changes how often that happens.

Be honest with yourself about what to expect: this is a **first test**. It proves the chain works, but most of what
you see on the spectrum is **the board's own noise**. Strong local signals (an AM broadcast station, a nearby
test transmitter) are the realistic catches.

### The RC sigma-delta front end (first bench test 2026-11-28)

> **First results only. The part values below are a starting point, not a finished design.**

The design already has an **RC** input mode: J8 pin 15 drives the inverted input bit back through a resistor to the
input node, which makes a proper first-order sigma-delta converter. The planned circuit:

- a resistor from **J8 pin 15** to the input node (J8 pin 12),
- a capacitor from the input node to **ground**,
- the antenna coupled into that node.

Pick **RC** as the input mode in the **I/O** tab. The first build used 1 kOhm and 1 nF (1 us): the loop balances
(density about 52 %) and AM carriers show in the scan, but they sit only a few dB over the noise, too weak for
programme audio. Why: the node is a current summer, full scale is the feedback current (1.65 V / R), and the
1 nF to ground divides the antenna (about 100 to 200 pF for a 10 to 20 m wire) down to about 12 %. A simulation of
this loop and its DSP (10 mV antenna signal at 1 MHz) gives the signal over noise for:

| Resistor / capacitor | Signal over noise |
|---|---|
| 1 kOhm / 1 nF (first build) | 15 dB |
| 4.7 kOhm / 220 pF | 27 dB |
| **10 kOhm / 100 pF** | **32 dB** |
| 22 kOhm / 47 pF | 36 dB |

Also put 470 ohm to 1 kOhm in series with the antenna's coupling capacitor (it keeps strong shortwave and the
feedback edges off the wire). With a resistor above about 4.7 kOhm the FPGA's own pull-up on the input (about
10 to 40 kOhm) starts to shift the balance: a later build turns it off. The noise floor rises 6 dB per octave,
so this is a longwave / medium wave receiver; above a few MHz use the Network NESDR mode. Many carriers below
600 kHz carry a 60 Hz hum comb: they are switching power supplies, not beacons.

## The radio page

The page has a top bar, the receiver display (left), the controls (right), a tool drawer with six tabs, and a
status bar at the bottom.

### Top bar

| Control | What it does |
|---|---|
| **Built-in** | The FPGA receiver on J8 pin 12 (the normal source). |
| **Network NESDR** | Uses an RTL-SDR (NESDR) dongle on your PC as the tuner, through the board. See [Network NESDR](#network-nesdr-a-second-tuner-on-your-pc). |
| **GPIO I/Q** | For a board-local I/Q adapter that speaks the rtl_tcp format. Not set up by default; the page then says the adapter is not configured. |
| Coverage text | Shows the active source and its range, for example "FPGA · 1 kHz to 49 MHz". |
| **FX on / FX off** | The falling 0/1 "matrix rain" background. Your choice is remembered in this browser. |
| **Full screen** | Full screen on or off (hidden if the browser cannot do it). |

### Frequency readout and S-meter

- The big readout shows the **active slice** (its letter and colour on the left) in MHz.kHz.Hz, with leading
  zeros dimmed.
- Two chips under it show the **mode** (plus "auto" when Auto mode chose it, and the decoder name when one is on)
  and the **band** name from the band plan ("General coverage" outside the plan).
- The **S-meter** is a bar from S1 to S9 (green) and up to S9+60 (red), with a dB figure. For the built-in tuner it
  is worked out from the carrier level and the current RF gain.

### Band overview

The strip under the readout is a map of the band plan: coloured blocks are bands (coloured by their usual mode),
thin lines are known stations and calling frequencies, white dots are your memories, and coloured lines are the
slices. With the wide panadapter on, its window is drawn as a light blue box.

- Width buttons: **20 kHz**, **200 kHz**, **2 MHz**, **10 MHz**, and **1k to 49M** (the whole range, on a log scale).
- **Click** to tune the active slice there. **Mouse wheel** steps by the current step size.

### Slices A to D

On a four-tuner build a slice bar sits under the band overview. Each chip shows the slice letter, frequency and
mode.

- Slice **A** is always on. It is the main tuner: decoders, AGC, the AF gain and the FPGA hum filter work on A.
- Slices **B, C, D** are extra tuners. Press **On** / **Off** on a chip to switch one. Their default frequencies
  are 7.074 MHz USB, 14.230 MHz USB and 10.000 MHz AM.
- **Click a chip** to make that slice the active one. The knob, keypad, steps, bands, mode keys and memories always
  work on the active slice.
- **Vol** (0 to 150 %) and **L R** (left/right) set each slice's level and position in this browser's own mix,
  so you can listen to several slices at once, for example one in each ear.
- A small bar on each chip shows its signal level.

Only slice A goes to TCP port 8001 and the DAC; B to D are heard in the browser.

### Spectrum and waterfall

- **Width buttons** (wide panadapter): **5 MHz**, **2.5 MHz**, **1.25 MHz**, **625 kHz**, **312 kHz**. The FPGA's
  panadapter captures 6.25 MHz down to 390 kHz; the page shows the middle 80 % of that (the edges alias), which is
  where the button labels come from. **12 kHz** switches to the narrow view: the active slice's own 12.2 kHz of I/Q.
- **Floor** and **Range** set the bottom and the height of the dB scale. **Auto level** puts the floor just under
  the noise.
- The readout on the right shows the peak level in the view.
- Each active slice is drawn as a coloured line with a flag (frequency, mode, decoder) and its passband shaded.
- **Click** the spectrum to tune the active slice there. **Click a flag** to make that slice active.
- **Drag** left or right: in the wide view this moves the panadapter window; in the narrow view it retunes.
- **Mouse wheel** steps the active slice.
- When you tune near the edge of the wide view, the panadapter re-centres by itself.
- The **waterfall** below scrolls one row per new spectrum, with its brightness set from the noise level.

### Mode keys, SPK and frequency entry

| Control | What it does |
|---|---|
| **SPK** | Browser sound on or off. |
| Frequency box | Type a frequency in kHz and press Enter (`7074`), or add **m** for MHz (`14.2m`). |
| **AM** | Envelope AM (done in the FPGA for slice A). |
| **SAM** | Synchronous AM (a carrier-locked loop), steadier on fading stations. |
| **USB / LSB** | Single sideband, upper or lower. |
| **CW** | Morse, heard as a 700 Hz note. |
| **NFM** | Narrow FM. |
| **WFM** | Wide FM, only with the Network NESDR tuner. |
| **Auto** | Slice A only: picks the mode from the band plan each time you tune. Choosing a mode yourself turns Auto off. |

### Knob, keypad, steps, bands and memory keys

- **Knob**: drag it round or use the mouse wheel on it. Each detent moves one step; spin fast and it moves 3 or 10
  steps per detent.
- **Keypad**: digits and **.**, then **kHz** (or **ENT**, also kHz) or **MHz**. **CLR** clears the entry.
- **Keyboard**: arrow up or right tunes up one step, arrow down or left tunes down. Hold **Shift** for 10 steps.
- **Step**: 10 Hz, 100 Hz, 1k, 5k, 9k, 10k, 100k, 1M. The status bar shows the current step.
- **Band** keys (built-in tuner): VLF (24 kHz), WWVB (60 kHz), NDB (350 kHz), AM BC (1000 kHz), 160m, 80m, 49m,
  40m, 31m, WWV (10 MHz), 20m, CB (27.185 MHz), 10m, VHF lo (46.8 MHz), NAVTEX (518 kHz), FT8 40 (7.074 MHz).
- **M+** saves the active slice's frequency and mode as a memory. **< Mem** and **Mem >** step through the
  memories and tune them. The status bar shows the memory number and label.

### Status bar

From left to right: the link (**FPGA LIVE** or **OFFLINE**; the page reconnects by itself), the input (**IN:**
ANT, LOOP, JMP or RC), the test transmitter (**TX: ON / OFF**), the step, AGC, the RF gain, scan progress and the
current memory.

### Tab: Decode

The decoders run on the board, on slice A.

| Decoder | What it does |
|---|---|
| **Off** | No decoding. |
| **CW** | Morse to text, with the measured speed in wpm. |
| **NAVTEX** | Maritime safety text on 518 kHz (SITOR-B / CCIR 476 FEC). Prints "[NAVTEX sync]" when it locks. If it finds no sync for 30 s it tries the other tone polarity. |
| **WWVB** | The 60 kHz US time signal: prints the year, day of the year and UTC time (and DST) after each full minute frame. |
| **SSTV** | Slow-scan TV pictures. It waits for the VIS header that names the mode, then draws the picture as it arrives. |

SSTV modes it knows: Martin M1, Martin M2, Scottie S1, Scottie S2, Scottie DX, Robot 36, PD90 and PD120.

Shortcut buttons set frequency, mode and decoder in one press: **NAVTEX 518**, **WWVB 60**, **SSTV 14.230 USB**
and **SSTV 3.845 LSB**. **Clear text** empties the text box. The status next to the keys says **Locked** or
**Searching**.

**Where SSTV pictures are saved:** with the built-in tuner each picture is saved on the board as a PNG in the
radio's project folder, `/opt/ardzy/projects/orphan_radio/sstv/`, named date-time-mode (for example
`20261122-143005-MartinM1.png`), and also as `latest.png`. A picture is saved when it is complete, or after 20
seconds with no new lines if at least a third of it arrived. The page shows a link when it saves. You can also
open them in the browser: `http://orphan.local:8000/sstv/latest.png`, and `http://orphan.local:8000/sstv/list`
lists all saved files. (Pictures received through the Network NESDR are shown on the page but not saved.)

### Tab: Scan

The scanner sweeps a range in 9 kHz hops, takes an averaged spectrum at each hop, keeps peaks that stand out above
the local noise, merges duplicates, then tunes onto each hit to guess its mode (AM, USB, LSB, CW, NFM or a plain
carrier).

| Control | What it does |
|---|---|
| **Scan 10 kHz to 49 MHz** | The whole range. This is thousands of hops and takes several minutes. |
| **Scan this band** | The band-plan band slice A is in. |
| **Scan the overview** | Whatever the band overview strip shows right now. |
| **Stop** | Stops the scan. |
| **Auto-program** | When lit, the hits become automatic memories (replacing older automatic ones in that range; your own memories are kept). Up to 150 hits per scan. |
| **Threshold over noise** | 6 to 30 dB: how far above the noise a peak must be to count. |

The bar and the text below show progress, then "Scan done: N signals". The radio returns to where it was when the
scan ends.

### Tab: Memory

A list of all memories: number, frequency, mode, label (from the band plan, or the scan's guess) and either the
signal-to-noise figure, "auto" or "saved".

- **Click a row** to tune it.
- **Birdie** marks that frequency as the board's own noise: it is removed from the list and future scans skip it
  (within 0.3 kHz).
- **x** deletes one memory.
- **Clear auto** removes only the automatic memories. **Clear all** removes everything (it asks first).

Memories live in `memories.json` in the radio's project folder and survive restarts and Orphan updates.

### Tab: Scope / I/Q

- **Audio**: an oscilloscope trace of the active slice's audio.
- **IQ**: the I/Q constellation (a dot cloud of the baseband samples), with the average magnitude. A clean carrier
  makes a ring; noise makes a fuzzy blob.

### Tab: Levels

**Audio and gain**

| Control | What it does |
|---|---|
| **Volume** | Browser volume. |
| **RF gain x2^n** | Extra baseband gain, 0 to 15 (each step doubles it). Moving it turns Auto RF off. |
| **AF gain (AM)** | The FPGA's AM audio gain. Moving it turns AGC off. |
| **AGC** | Sets the AM audio gain from the carrier level, 20 times a second. |
| **Auto RF** | Raises or lowers the RF gain to keep the carrier in a good range. |
| **Treble** | A browser-side treble lift (high shelf at 2.5 kHz). |
| **Dither** | In Wire mode, adds a small random variation to the pull-low time. This breaks up idle tones that the 1-bit loop can paint on the spectrum. |

**Noise blanker** (in the FPGA, before the tuners, so it acts on every slice)

- **Off / Low / Med / High**: how big a spike must be (compared with the average level) before it is blanked.
  High blanks the most.
- **Pulse width**: how long each blank lasts (shown in microseconds).
- The note under it counts the samples blanked per 0.1 s.

**Hum and notch**

- **Off / 50 Hz / 60 Hz**: a comb filter that notches mains hum and all its harmonics. For AM on slice A it runs in
  the FPGA; for the other modes it runs on the board.
- **ANF**: an automatic notch that learns steady tones (carriers, whistles) and subtracts them.
- **Hum depth**: how deep and narrow the notches are.
- **Line frequency**: fine-tunes the mains frequency by up to half a hertz either way.

### Tab: I/O

**Input J8-12**

| Key | Input mode |
|---|---|
| **Wire** | Zero-parts antenna on J8 pin 12 (the default). |
| **Loop** | The test transmitter is fed to the receiver inside the FPGA. No wires. |
| **Jumper** | J8 pin 12 read as a plain logic input. Wire J8 pin 5 to J8 pin 12 and switch TX on. |
| **RC** | The resistor and capacitor front end (see [Coming after bench tests](#coming-after-bench-tests-the-rc-sigma-delta-front-end)). |

- **Pull-low**: in Wire mode, how many clocks (1 to 15) the FPGA pulls the pin low each time it reads high.
- **Density**: how much of the time the input reads high. Around 50 % means the input sits right at its switching
  point.

**Test transmitter J8-5**

| Control | What it does |
|---|---|
| **TX** | Switches the test transmitter on J8 pin 5 on or off (the status bar shows TX: ON). |
| **Melody** | Plays a short tune as the modulation (with TX on, or in Loop mode). |
| **Carrier** | Transmit frequency, 530 to 1700 kHz on the slider. |
| **Tone** | The modulating tone, 100 to 3000 Hz. |
| **Depth** | Modulation depth. |

A quick self-test: choose **Loop**, tune slice A to the same frequency as **Carrier** in AM, and press SPK. You
should hear the tone (or the melody).

## Network NESDR: a second tuner on your PC

An RTL-SDR dongle (such as a NooElec NESDR) on your PC can feed the same radio page through the board. It reaches
100 kHz to 1.75 GHz (direct sampling below 25 MHz, the tuner above), adds **WFM**, and the board demodulates its
audio at 50 kHz.

How it works: on the PC, Osmocom `rtl_tcp` serves the dongle on loopback only, and an SSH reverse tunnel carries
the samples to the board, so the PC needs no incoming firewall rule. On the board a small service
(`orphan-nesdr`) listens on port 8002 and the radio page talks to it.

### On the board (once)

This part is not installed by `setup-board.sh`; set it up by hand from the `nesdr-remote` folder:

1. Build the demodulator: `gcc -O3 -Wall -Wextra -Werror -fPIC -shared demod.c -o demod.so -lm`
2. Build the decoder: `gcc -O2 ../orphan_radio/rxd.c -o rxd-external -lm`
3. Copy `demod.so`, `rxd-external`, `server.py` and `index.html` to `/opt/orphan-nesdr/`.
4. Copy `orphan-nesdr.service` to `/etc/systemd/system/`, then run `systemctl daemon-reload`,
   `systemctl enable orphan-nesdr` and `systemctl start orphan-nesdr`.

### On the PC (Windows)

1. Install the WinUSB driver for the dongle and download the
   [Osmocom rtl-sdr Windows binaries](https://downloads.osmocom.org/binaries/windows/rtl-sdr/).
2. Set up SSH key login from the PC to `root@orphan.local` (the script runs SSH in batch mode, so it cannot type a
   password).
3. Close any other program that uses the dongle.
4. Run `start.ps1` from the `nesdr-remote` folder, giving your board and the folder with the Osmocom tools, for
   example `.\start.ps1 -Board orphan.local -ToolRoot C:\path\to\rtl-sdr`. Check the folder paths at the top of
   the script first, since they point at the author's own setup. Run it again after a restart or after replugging
   the dongle.

The script starts `rtl_tcp` on port 1234 on loopback and an SSH reverse tunnel to the board, then prints
"NESDR running".

### In the radio page

1. Click **Network NESDR** in the top bar. It connects by itself; **Connect / Disconnect** sits next to the
   frequency box.
2. Press **SPK**. Audio starts after about 0.7 s of buffering (the dongle delivers samples in bursts).
3. Tune as usual: knob, keypad, spectrum, memories, or type `104.1m`.

What changes with the network tuner:

- Band keys become AM, SW, 20m, CB, FM, Air, 2m and 70cm.
- Panadapter widths become 200, 100, 50 and 25 kHz.
- The RF slider becomes the **tuner gain** (the dongle's gain steps), and **Auto RF** switches the tuner to
  automatic gain.
- Scanning works over FM broadcast, the current band, or an overview up to 32 MHz wide. Hits appear as buttons;
  click one to tune it. With Auto-program on they are saved as automatic memories.
- Decoders CW, NAVTEX and SSTV work. **WWVB 60** switches back to the built-in tuner (the dongle cannot reach
  60 kHz).
- Slices B to D, the noise blanker, hum filter, AGC, input modes and the test transmitter are built-in tuner
  features and are greyed out.
- The dongle serves **one** browser at a time.

Click **Built-in** to go back to the FPGA receiver.

## Raw audio for ffplay

The board streams slice A's audio as raw 16-bit little-endian mono at 12207 Hz on **TCP port 8001**. With FFmpeg
installed on your PC:

```sh
ffplay -nodisp -f s16le -ar 12207 -ch_layout mono -fflags nobuffer tcp://orphan.local:8001
```

Use `tcp://<board ip>:8001` if `orphan.local` does not resolve. Older ffplay versions use `-ac 1` instead of
`-ch_layout mono`. The program prints this exact command, with the board's address, when it starts.

This stream carries the demodulated audio of slice A in whatever mode it is in (when the board-side DSP runs), and
it plays even if no browser is open.

## Ports and files

| What | Where |
|---|---|
| Web page and WebSocket | port 8000 |
| Raw audio (slice A) | TCP port 8001 |
| Network NESDR service (optional) | port 8002 |
| Memories | `/opt/ardzy/projects/orphan_radio/memories.json` |
| SSTV pictures | `/opt/ardzy/projects/orphan_radio/sstv/` |
| Board-side DSP | `orphan-rxd` (built from `rxd.c` with gcc the first time the radio starts) |

## Troubleshooting

| Problem | Try this |
|---|---|
| No sound in the browser | Press **SPK** (it must be lit) and check **Volume** and the slice's **Vol**. |
| Page says OFFLINE | The radio is not running: load it again from the menu or the board page. The page reconnects by itself. |
| Only noise in Wire mode | Expected with a bare wire: see [Zero-parts mode](#zero-parts-mode-works-today). Try a strong AM station at night, or the **Loop** self-test. |
| Decoders never show text | The decoders need the board-side DSP. If the radio's log says "board DSP not available, the browser demodulates instead", gcc could not build `orphan-rxd`; the browser then plays the modes but there are no decoders. |
| No slices B to D or wide panadapter | The FPGA build has one tuner only; the page hides those parts. |
| Network NESDR says to start rtl_tcp | Run `start.ps1` on the PC again and check that no other program holds the dongle. |
| Network NESDR says it is busy | Another browser is already streaming from the dongle; close it. |

---
[Buy me a coffee](https://buymeacoffee.com/revjmoney) · [orphan] · by [JMSCNC](https://jmscnc.com), makers of RotatoCAM · **[Rev. J. Money - 2026]**
