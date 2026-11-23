# SPEKTOR / INJEKTOR 3000: feature log

[Rev. J. Money - 2026] · by JMSCNC, makers of RotatoCAM

## 2026-11-22: SPEKTOR

- 16-channel logic analyzer core (spektor.v): 100 MSa/s, RAW 32K samples or RLE, 4-stage trigger, sample-exact
  trigger position, 36:1 kanal map (any header pin is any channel).
- Page: SKOPE, TRIGGR, DEKODE (UART / I2C / SPI), MEETRZ, LOGZ, PROBEZ, INJEKTOR bay, terminal drawer.

## 2026-11-23: INTERSEKTOR (INJEKTOR's first module): UART man-in-the-middle bridge

- intersektor.v (slot 2): two directions (A → B, B → A), each with its own input pin, output pin and baud.
- Modes OFF (sniff), WIRE (bit-level pass-through), RELAY (FPGA swap/drop table + inject), HOLD (the ARM rewrites).
- 512-byte inject queue per direction; 1024-entry log with microsecond time stamps; OUT entries read back from the
  output pads.
- Safety: outputs only after GO (never saved), pin conflict guard, FAILSAFE (HOLD falls back to RELAY after 250 ms
  without a heartbeat), mode changes wait for an idle line.
- Shortened (3/4) stop bit while bytes queue, so a sender up to about 2.5 % fast cannot overrun RELAY.
- Baud finder (shortest pulse) and AUTO baud.
- Built-in test UARTs (TEST mode) that play device A and device B.
- mitm_service.py: heartbeat, log reader, HOLD rule engine (find / replace of any length, 30 ms partial-match wait),
  PAUSE + hand edit + FORWARD, settings in mitm.local.json.
- Page: INTERSEKTOR panel on INJEKTOR (modes, pins, baud, RULEZ, HOLD KUE, LIVE LOG); terminal `mitm`, `inject`, `rule`.
- top.v: header pins are now IOBUFs (SPEKTOR still reads every pad, so it captures the bridge's outputs too).
- Tests: simulation 40/40 (sim/test_ik.py), board 2 20/20 (ik_hw_test.py, outputs checked by SPEKTOR captures),
  page in Chrome. Not yet: two real outside devices.
- Build: 2309 LUT (13 %), 19 BRAM, fmax 127 MHz.
