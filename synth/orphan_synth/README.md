# Orphan Synth

Orphan Synth is an 8-voice subtractive synthesizer built inside the FPGA of the Antminer S9 control board: six
oscillators per voice, a resonant filter and two envelopes per voice, two LFOs with a mod matrix, drive, a
bitcrusher, a long delay, a looper and an arpeggiator. Play it from a web page, an SSH terminal, or any MIDI
keyboard or DAW over the network.

Part of **Orphan**, FPGA Dev Linux for the S9 Control Board, by JMSCNC, makers of RotatoCAM.

## Quick start

1. Install Orphan on the board (see the main Orphan README) and log in: the Orphan menu opens.
2. Load the synth, any of these ways:
   - In the Orphan menu press **F** (FPGA projects), find **Orphan Synth** in the tree and load it.
   - Open the board page **http://orphan.local**, click **Orphan Synth**, then **Load**. The synth's own page
     opens in a new tab.
   - From a shell: `ardzy load orphan_synth`
3. The synth's page is on port 8000: **http://orphan.local:8000** (or `http://<board ip>:8000`).
4. Press **Start sound in this browser**. Browsers only allow sound after a click.
5. Play the on-screen keys or your computer keyboard (**A W S E D F T G Y H U J K**), and try the presets.

The synth starts with the **Moog Bass** preset. Sound comes out in three places at once: the browser, the raw audio
port for ffplay, and an optional PCM5102A DAC on J3.

## Wiring

Nothing needs wiring to play: the browser and ffplay carry the sound over the network. The only hardware option is
a DAC board for a real line or headphone output.

A note on the name: the DAC link is **I2S** (a digital audio bus, "I-two-S"), not I2C (the two-wire control bus
with a similar name). The PCM5102A boards sold for this are I2S boards.

| Connector | Pin | FPGA pin | What it is |
|---|---|---|---|
| J3 | 5 | T14 | I2S MCLK (master clock, 12.5 MHz) |
| J3 | 11 | P14 | I2S BCLK (bit clock) |
| J3 | 12 | R14 | I2S DOUT (audio data) |
| J3 | 15 | T15 | I2S LRCLK (word clock, 48.8 kHz) |
| J3 | 16 | none | 3.3 V |
| J3 | 1, 2, 9, 10, 13, 14 | none | GND |

The four FPGA LEDs (D5 to D8) run the light shows. The fan headers keep working (Orphan's fan block is in this
design; set the speed in the menu's **Cooling** screen).

### PCM5102A DAC board

| DAC board pin | Board |
|---|---|
| BCK | J3 pin 11 |
| DIN | J3 pin 12 |
| LCK (LRCK) | J3 pin 15 |
| SCK | see below |
| VIN / VCC | J3 pin 16 (3.3 V) |
| GND | J3 GND (pin 1, 2, 9, 10, 13 or 14) |

On the common PCM5102A modules set:

| Pin | Level | Meaning |
|---|---|---|
| FMT | low | I2S format |
| XSMT | high | soft mute off (sound on) |
| FLT | low | normal filter |
| DEMP | low | de-emphasis off |

**SCK:** the design drives a 12.5 MHz master clock on **J3 pin 5** (256 times the 48828 Hz sample rate), so you
can wire SCK to J3 pin 5. The comment in the design's top file says "SCK to GND" instead (the PCM5102A then makes
its own clock from BCK). Pick **one**: SCK to J3 pin 5, **or** SCK tied to GND with J3 pin 5 left open. Never both
at once, because an FPGA output driving into a grounded pin is a short.

The synth is mono: the same sound goes to both DAC channels.

### Safety notes

- **3.3 V only.** The J1 to J9 connector pins go straight to the FPGA: no buffer, no protection, and they are
  **not 5 V tolerant**. Never connect 5 V logic or a 5 V supply to them.
- Every FPGA line on the J connectors has a **4.7k pull-up to 3.3 V** on the board.
- Start with the volume low when you plug in headphones: drive, resonance and the delay feedback can get loud.
- The web page and the network MIDI port have no login. Use the synth on a network you trust.

## The synth page

### Top row

| Control | What it does |
|---|---|
| **Start sound in this browser** | Starts the browser's audio. The button then says **Sound on**. |
| **All notes off** | Panic: stops every note, the sustain pedal and any arpeggio. |
| Status | "connected to the board", or "disconnected, retrying..." (it reconnects by itself). |
| **FX on / FX off** | The falling 0/1 "matrix rain" background, remembered in this browser. |

### Presets

**Moog Bass**, **Ensoniq Pad**, **Casio Organ**, **Brass**, **Pluck**, **Acid**, **Hoover Sweep**, **Wind**,
**Fuzz Lead**, **Wavefold Growl** and **8-bit Chip**. A preset sets the oscillators, filter, envelopes, LFO1, the
mod matrix, drive and bitcrusher. The lit button is the current preset; moving a sound control afterwards turns the
highlight off (your sound is now "custom"). The delay, looper and play settings are not part of the presets.

### Oscillators

Level sliders for each oscillator in every voice, mixed together:

| Slider | Sound |
|---|---|
| **Saw** | Bright, buzzy: the classic synth wave. |
| **Pulse** | Hollow, reedy. Its shape is set by **Pulse width**. |
| **Triangle** | Soft, flute-like. |
| **Sine** | Pure tone. |
| **Sub octave** | A square wave one octave down, for weight. |
| **Noise** | Hiss, for wind, breath and percussion. |
| **Pulse width** | 5 to 95 % (50 % is a square wave). |

### Filter

Each voice has its own resonant filter.

- **Low pass / Band pass / High pass / Off**: the filter type (Off bypasses it).
- **Cutoff**: 40 Hz to 8 kHz.
- **Resonance**: emphasis at the cutoff; high values whistle and squelch.
- **Envelope amount**: how far the filter envelope moves the cutoff, from -100 % (closes) to +100 % (opens).

### Filter envelope and Amp envelope

Two ADSR envelopes per voice: one moves the filter cutoff, the other shapes the loudness.

| Slider | Range | What it does |
|---|---|---|
| **Attack** | 1 ms to 3 s | Time to rise when a key goes down. |
| **Decay** | 10 ms to 4 s | Time to fall to the sustain level. |
| **Sustain** | 0 to 100 % | Level held while the key stays down. |
| **Release** | 10 ms to 4 s | Time to fade after the key comes up. |

### Play

- **Volume**: master volume.
- **Velocity**: how much key velocity changes loudness. At 0 % every note is equally loud.
- **Bend range**: pitch bend range, 1 to 12 semitones (for the bend slider and for MIDI pitch bend).

### LFOs

Two low-frequency oscillators for movement.

- **LFO1 shape / LFO2 shape**: triangle, sine, saw up, saw down, square, random (sample and hold).
- **LFO1 rate / LFO2 rate**: 0.05 to 20 Hz.

The LFOs do nothing on their own: route them in the mod matrix.

### Mod matrix

Four rows. Each row has:

- a **source**: off, LFO1, LFO2, or LFO1 x LFO2 (the two multiplied),
- a **destination**: none, pitch, cutoff, resonance, amp, pulse width, drive or crush,
- a **depth** from -100 % to +100 % (negative turns the movement upside down).

Examples: LFO1 to pitch gives vibrato, LFO1 to amp gives tremolo, LFO2 to cutoff gives a slow filter sweep.
The mod wheel of a MIDI keyboard drives **row 4** as vibrato (see [MIDI](#midi)).

### Drive

- **off / soft / hard / fold**: soft saturation, hard clipping, or a wavefolder.
- **Drive**: input gain, x1 to x256.
- Presets: **Off**, **Warm**, **Crunch**, **Fuzz**, **Fold**, **Destroy**.

### Bitcrusher

- **Bits**: 1 to 16 (16 is clean).
- **Sample-rate divide**: off, or /2 to /32 (the page shows the resulting sample rate).
- Presets: **Clean**, **Lo-fi**, **8-bit**, **Atari**, **Pulverize**.

### Long delay (RAM)

An echo whose memory lives in the board's RAM (handled by a small helper program, `orphan-fxd`).

| Control | What it does |
|---|---|
| **Sync to arp tempo** | off, or a note value (1/2, 1/4, 1/4T, 1/8., 1/8, 1/8T, 1/16) at the arpeggiator's **Tempo**. |
| **Time** | Delay time, 50 ms to 5 s (used when Sync is off). |
| **Feedback** | How many repeats (0 to 98 %). |
| **Mix** | Echo level. At 0 % the delay is silent. |
| **Tone (dark .. bright)** | Darker repeats at low settings. |
| **Tape wobble** | A slow pitch wobble on the repeats, like worn tape. |

### Looper (RAM)

Record what you play, loop it, and layer on top. Loops can be up to 120 seconds.

| Control | What it does |
|---|---|
| Big button | One button that walks through the loop: **Record** (start), **Close loop** (end the first take, playback starts), **Overdub** (record a new layer over the loop), **Stop overdub**. |
| **Stop** | Stops recording or playback. |
| **Play** | Plays the loop again after Stop. |
| **Undo** | Takes back the last overdub. |
| **Clear** | Empties the looper. |
| **Save WAV** | Saves the loop on the board and downloads it to your computer as `orphan_loop.wav`. |
| **Half speed** | Plays the loop at half speed (an octave down). |
| **Reverse** | Plays the loop backwards. |
| **Loop volume** | The loop's playback level. |
| **Overdub keeps old layers** | 50 to 100 %: below 100 % the older layers fade a little with every overdub pass. |

The status line shows the looper state, loop length and position, and any audio dropouts. If it says "not running
(needs orphan-fxd)", the helper program could not start, and the delay and looper are unavailable.

### Arpeggiator

When the arpeggiator is on, held notes are played one after another in a pattern instead of as a chord.

| Control | What it does |
|---|---|
| **Arp on / off** | Turns the arpeggiator on or off. |
| **Latch** | Keeps playing after you let go of the keys. A new chord replaces the latched one. |
| **Mode** | up, down, up-down, down-up, random, as played, chord (all held notes together), converge (outside in: lowest, highest, next lowest...), pinky (the lowest note between every other note). |
| **Rate** | 1/4, 1/8, 1/8T, 1/16, 1/16T, 1/32. |
| **Octaves** | Repeats the pattern over 1 to 4 octaves. |
| **Tempo** | 40 to 240 bpm (also the tempo for a synced delay). |
| **Gate** | How long each note sounds, 5 to 100 % of its step. |
| **Swing** | Pushes every other step late, 0 to 75 %. |
| **Ratchet** | Repeats each step 1 to 4 times. |
| **Octave jumps** | Chance that a step jumps an octave down, up, or two up. |
| **Skip chance** | Chance that a step is left silent, up to 90 %. |
| **Transpose** | Shifts the pattern by up to 12 semitones either way. |

### Lights

- Light shows on the four FPGA LEDs D5 to D8: **voices** (each LED follows a pair of voices), **vu meter**,
  **breathe**, **pulse**, **notes** (each note flashes an LED), **chase**, **sparkle** and **off**.
- **Front LED flashes**: the board's front status LED flashes green on notes and arpeggiator steps, red on the
  downbeat, and another status LED stays lit while any voice sounds. While this is in use the board's normal
  SD-card activity LED service is paused; it is started again when the synth stops.

### Scope, pitch bend and the on-screen keyboard

- The **scope** shows the synth's output waveform.
- **Pitch bend**: drag the slider to bend; it springs back to the centre when you let go.
- The **on-screen keyboard** has two octaves. Click or touch a key; the higher up on the key you press, the louder
  the note.

### Computer keyboard (in the page)

| Keys | Notes |
|---|---|
| **A S D F G H J K** | White keys C D E F G A B C |
| **W E T Y U** | Black keys C# D# F# G# A# |
| **Z / X** | Octave down / up (octave 1 to 7) |

The page starts at octave 4, so **A** is middle C. Keys do nothing while a slider or menu has focus; click an empty
part of the page first.

## Terminal keyboard (term.py)

You can play the synth from an SSH session on the board, with no browser. The synth must be running first. Then:

```sh
python3 /opt/ardzy/projects/orphan_synth/term.py
```

| Keys | What they do |
|---|---|
| **Z S X D C V G B H N J M ,** | One octave from C to C (laid out like a tracker: bottom row white keys, row above black keys) |
| **Q 2 W 3 E R 5 T 6 Y 7 U I 9 O 0 P** | The next octave up, C to E |
| **[ / ]** | Octave down / up |
| **Tab** | Next preset |
| **F** | Next filter type |
| **Up / Down** | Cutoff |
| **Left / Right** | Resonance |
| **A** | Arpeggiator on / off |
| **K** | Next arpeggiator mode |
| **L** | Arpeggiator latch |
| **- / =** | Arpeggiator tempo down / up by 5 bpm |
| **`** | Next light show |
| **Space** | All notes off |
| **Esc** | Quit (all notes off) |

Terminals only send key presses, not releases, so a note holds while the key auto-repeats and stops shortly after
you let go. Every note plays at velocity 100. The terminal cannot carry sound: listen with the browser page, ffplay
or the DAC. The screen shows the ffplay command for your board.

## Raw audio for ffplay

The synth's output streams as raw 16-bit little-endian mono at 48828 Hz on **TCP port 8001**. With FFmpeg on your
PC:

```sh
ffplay -nodisp -f s16le -ar 48828 -ch_layout mono -fflags nobuffer tcp://orphan.local:8001
```

Use `tcp://<board ip>:8001` if `orphan.local` does not resolve. Older ffplay versions use `-ac 1` instead of
`-ch_layout mono`.

## MIDI

The synth listens to MIDI three ways. All of them play the same synth, and you can use them together.

### What the synth reacts to

MIDI messages on **any channel** are accepted.

| Message | Effect |
|---|---|
| Note on / note off | Plays and releases notes (8 voices; when all are busy the oldest note is taken over). |
| Velocity | Loudness, scaled by the page's **Velocity** slider. |
| Pitch bend | Bends every sounding note, over the page's **Bend range**. |
| CC 1 (mod wheel) | Vibrato: sets **mod matrix row 4** to LFO1 to pitch, with depth from the wheel (up to 50 %). This replaces whatever row 4 held. |
| CC 7 | Volume |
| CC 64 (sustain pedal) | Holds released notes until the pedal comes up. |
| CC 71 | Resonance |
| CC 72 | Amp release |
| CC 73 | Amp attack |
| CC 74 | Filter cutoff |
| CC 75 | Filter envelope amount |
| CC 76 | LFO1 rate |
| CC 120, CC 123 | All notes off |

Not used: program change (choose presets on the page or with Tab in term.py), aftertouch, MIDI clock (the
arpeggiator has its own tempo) and SysEx.

### Web MIDI (a keyboard plugged into your computer)

In Chrome the page can read a MIDI keyboard connected to the computer the browser runs on. It forwards **notes and
pitch bend only** (no mod wheel, CCs or sustain pedal). Browsers only allow Web MIDI on secure (https) or localhost
pages, so on a plain `http://orphan.local:8000` address it may be blocked. If nothing happens, use network MIDI
instead, which also passes the CCs.

### USB MIDI keyboard on the board

Plug a class-compliant USB MIDI keyboard into the board. The synth reads every ALSA MIDI input it finds with
`aseqdump` (from the `alsa-utils` package; the synth prints a reminder if it is missing), checks for new devices
every few seconds, and passes notes, control changes and pitch bend.

### Network MIDI (RTP-MIDI / AppleMIDI)

The board is an RTP-MIDI device: it accepts sessions on **UDP ports 5004 and 5005**, the same protocol as
macOS network MIDI and rtpMIDI on Windows. When a session ends, all notes stop.

**Make it findable (once).** The board advertises itself over mDNS/Bonjour as **"Orphan Synth"** through avahi.
The advert file ships in the project folder; copy it into avahi's folder once (avahi picks it up by itself):

```sh
cp /opt/ardzy/projects/orphan_synth/orphan-synth.avahi.service /etc/avahi/services/
```

Without it you can still connect by adding the board by hand (below).

#### Windows: rtpMIDI

1. Install **Apple Bonjour** (rtpMIDI needs it to find devices; it comes with iTunes, or as Bonjour Print Services).
2. Install **rtpMIDI** by Tobias Erichsen and start it.
3. Under **My Sessions**, click **+** to create a session and tick it to enable it. The session name is the MIDI
   port your DAW will see.
4. Under **Directory**, **Orphan Synth** should appear. Select it and click **Connect**. It moves into the
   session's participant list.
5. If it does not appear: click **+** under Directory and add an entry by hand with the **board's IP address**
   (`<board ip>`) and port **5004**, then select it and click **Connect**.
6. If Windows Firewall asks about rtpMIDI, allow it on your private network.

#### macOS: Audio MIDI Setup

1. Open **Audio MIDI Setup** (in Applications, Utilities), then **Window > Show MIDI Studio**.
2. Double-click the **Network** icon to open MIDI Network Setup.
3. Under **My Sessions**, click **+** to create a session and tick it to enable it.
4. Under **Directory**, select **Orphan Synth** and click **Connect**.
5. If it is not listed, click **+** under Directory and add it by hand: the board's IP address and port 5004.

The session (for example "Session 1" or "Network Session 1") is now a MIDI output for every app on the Mac.

### Playing it from a DAW

The idea is the same in every DAW: the rtpMIDI (Windows) or Network (macOS) session is a **MIDI output** port.
Enable that port as an output in the DAW's MIDI settings, make a MIDI track, and send the track's MIDI to that
port. The synth itself makes the sound, so the track needs no software instrument. To record the synth's audio
back into the DAW, use the DAC on J3 into your audio interface.

- **Reaper**: in Preferences, under Audio, enable the session as a MIDI output device. On a MIDI track, open the
  track's routing (Route button) and choose the session as the **MIDI hardware output**.
- **Ableton Live**: in Settings (Preferences), on the Link, Tempo and MIDI page, switch **Track** on for the
  session's output port. On a MIDI track, set **MIDI To** to the session.
- **FL Studio**: in Options > MIDI settings, enable the session in the **Output** list and give it a port number.
  Add a **MIDI Out** channel set to the same port number, and play or sequence that channel.
- **Bitwig Studio**: put a **HW Instrument** device on an instrument track and set its MIDI output to the session.

Tips: the synth answers on any channel, so channel 1 is fine. The mod wheel takes over mod matrix row 4. If notes
hang after you stop the DAW, press **All notes off** on the page (or send CC 123).

## Ports and files

| What | Where |
|---|---|
| Web page and WebSocket | port 8000 |
| Raw audio | TCP port 8001 |
| Terminal control for term.py | port 8002, on the board only (not reachable from the network) |
| Network MIDI (RTP-MIDI) | UDP ports 5004 and 5005 |
| mDNS advert | `orphan-synth.avahi.service` (copy to `/etc/avahi/services/`) |
| Saved loop | `/tmp/orphan_loop.wav` on the board (cleared at reboot) |
| Delay and looper helper | `orphan-fxd` (built from `fxd.c` with gcc the first time the synth starts) |

## Troubleshooting

| Problem | Try this |
|---|---|
| No sound in the browser | Press **Start sound in this browser** (it must say **Sound on**), and check **Volume** and the oscillator levels. |
| No sound with a preset that should play | Check the **Filter**: a low cutoff with Low pass can make it nearly silent. Press **All notes off** if notes hang. |
| "The FPGA does not hold Orphan Synth" | A different FPGA design is loaded: load `orphan_synth` again. |
| term.py says "Orphan Synth is not running" | Load the synth first (menu, board page, or `ardzy load orphan_synth`). |
| "Orphan Synth" not listed in rtpMIDI or on the Mac | Copy the avahi advert file (see above), check that Bonjour is installed on Windows, or add the board by hand with its IP and port 5004. |
| rtpMIDI connects but no notes | Allow rtpMIDI through Windows Firewall on private networks, and check that the DAW track sends to the session port. |
| Web MIDI keyboard does nothing | Expected on a plain http address: use network MIDI or USB MIDI on the board. |
| Looper says "not running" | The helper `orphan-fxd` could not be built or started; check the synth's log output. |

---
[Buy me a coffee](https://buymeacoffee.com/revjmoney) · [orphan] · by [JMSCNC](https://jmscnc.com), makers of RotatoCAM · **[Rev. J. Money - 2026]**
