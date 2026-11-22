# Network NESDR for Orphan Radio

Open the radio board at `http://<board ip>:8000/`. Choose **Built-in antenna** for the FPGA receiver or **Network NESDR** for the PC's USB receiver. Both sources use the same panel, spectrum, waterfall and scope. The NESDR starts receiving as soon as you select it. Press **SPK** to hear audio. Enter a frequency such as `104.1m` and press Enter, or tune with the knob, keypad, presets, spectrum or memory list.

The PC runs Osmocom `rtl_tcp` on loopback. An OpenSSH reverse tunnel carries unsigned 8-bit interleaved I/Q samples and tuner commands between loopback ports, so the PC needs no incoming firewall rule. The board receives 250,000 I/Q pairs per second, about 4 Mbit/s of raw samples. Its Linux receiver demodulates mono audio at 50 kHz. The browser draws the spectrum and waterfall from the raw samples.

Audio playback starts after about 700 ms of samples arrive. The USB receiver can deliver samples in bursts, so the buffer trades a short listening delay for continuous playback. The spectrum and waterfall draw independently of audio scheduling.

The NESDR supports WFM, NFM, AM, SAM, USB, LSB and CW. Auto chooses the mode from the band plan. It uses Q direct sampling from 100 kHz to 25 MHz and the tuner above 25 MHz. The scanner can sweep FM broadcast, the current band, or up to a 32 MHz overview. Click a hit to tune it or enable Auto-program to save hits as automatic memories. The NESDR feeds CW, NAVTEX and SSTV to `orphan-rxd`. The **WWVB 60** button switches to the built-in tuner if the selected tuner cannot reach 60 kHz. Parallel FPGA slices B to D, FPGA noise filters and test TX are built-in tuner features.

## Additional tuner adapters

**GPIO I/Q** works with a board-local adapter that presents GPIO SDR samples through the rtl_tcp wire format. Set `ORPHAN_GPIO_IQ_PORT` to its loopback TCP port in a service override, and set `ORPHAN_GPIO_MIN_HZ` and `ORPHAN_GPIO_MAX_HZ` to its RF limits. The defaults are 1 kHz to 49 MHz. The adapter sends the 12-byte RTL0 header, then interleaved unsigned 8-bit I/Q. It must accept rtl_tcp sample-rate command 2 at 250 kS/s and tune command 1 in Hz. GPIO pin assignments and acquisition belong to the adapter for the specific hardware. The built-in tuner already uses the FPGA's J8 RF input.

If the NESDR has a physical LF upconverter rated for 60 kHz, set `ORPHAN_NESDR_LF_OFFSET_HZ` to the positive frequency translation in Hz. The service adds this offset to dial frequencies below 100 kHz and keeps the dial and waterfall on the original RF frequency. Bypass the converter for other bands. Leave the offset unset for the current bare dongle.

Use `start.ps1` on the PC after a restart or USB reconnect with the WinUSB driver installed and the [Osmocom Windows binaries](https://downloads.osmocom.org/binaries/windows/rtl-sdr/) (set their folder in `start.ps1`). Close other programs using the dongle. On the radio board, the systemd unit launches the unprivileged receiver. Build `demod.so` with `gcc -O3 -Wall -Wextra -Werror -fPIC -shared demod.c -o demod.so -lm`. Build the shared decoder with `gcc -O2 ../orphan_radio/rxd.c -o rxd-external -lm`. Install both binaries, `server.py` and the standalone fallback `index.html` in `/opt/orphan-nesdr/`.

The board exposes `GET /iq` on port 8002 for a raw client and `GET /stream` for the browser. The dongle serves one stream at a time. The board web panel and its tuning endpoint are for the trusted LAN.

---
[Buy me a coffee](https://buymeacoffee.com/revjmoney) · [orphan] · by [JMSCNC](https://jmscnc.com), makers of RotatoCAM · **[Rev. J. Money - 2026]**
