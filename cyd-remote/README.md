# ORPHAN Remote

**A general Linux scene display and touch terminal for the CYD.**

**By JMSCNC, makers of RotatoCAM. Copyright (C) 2026 Rev. J. Money.**

This belongs to the main Orphan project. The Kaspa miner lives in its own repository and publishes status for the mining view.

The native 320 × 240 panel has System, Mining, FPGA Projects, Radio and Synth views. System shows a one-minute die-temperature graph and Mining shows a one-minute hashrate graph, the current or last run rate, share totals and job status. Tap the bottom bar to change views. The touch stream is available to Linux applications through the event API.

## Linux side

Install `server/orphan_display.py` at `/opt/orphan-display/orphan_display.py` and install the supplied systemd unit. The service listens on port 8090, uses sysfs/procfs and the Ardzy CLI, and never touches FPGA MMIO.

| Endpoint | Purpose |
| --- | --- |
| `GET /api/display?view=system&tiles=1` | Version 1 scene with redraw bands containing text, shapes and graphs |
| `GET /api/display?view=system` | Legacy full scene with text and rectangle commands |
| `GET /api/display?view=mining` | Adapter for the miner's live API on port 8000 |
| `GET /api/system` | Host, temperature, memory, disk, uptime and FPGA project |
| `POST /api/input` | Touch/button event from a display |
| `GET /api/events?after=N` | Recent input events after sequence N |

## CYD side

Firmware targets the ESP32-2432S028R with ILI9341/ST7789 and resistive XPT2046 touch. It reuses the established CYD board configuration at 40 MHz display SPI. Existing Wi-Fi is read from the `net` NVS namespace (`s0..s4`, `p0..p4`), with the ESP32's remembered station connection as fallback. No Wi-Fi password belongs in source control.

Once online, open `http://orphan-remote.local/` or the IP printed on serial. Set the target to `http://BOARD_IP:8090`; this is stored in the display's NVS. The CYD checks for a new scene about every 450 ms and the server samples telemetry once a second. Each band includes a content revision so the CYD updates only changed areas. `GET /status` reports target, view, connectivity, heap, graphics port and scene redraw counters.

### Graphics transport

TCP port **8091** accepts an HTTP rectangle upload:

```text
POST /rect?x=0&y=0&w=320&h=240 HTTP/1.1
Host: DISPLAY_IP
Content-Length: 153600

<row-major little-endian RGB565 pixels>
```

Bounds and exact payload length are validated. The CYD streams small strips, so full-frame uploads do not require PSRAM. With `scale=2`, dimensions are source pixels and the panel shows the rectangle at twice the width and height. A 160 × 120 source needs 38,400 bytes. Add `smooth=1` for edge-aware scaling of pixel art. Clients can check for `scale2: true` in `/status` or send an unscaled rectangle.

A graphics upload suspends status redraws for ten seconds. Successive uploads maintain graphics mode, with an optional FPS and temperature overlay enabled by default. Touch events still travel to the selected Linux host. `tools/frame_demo.py` supplies a textured CPU raycast preview, and the Orphan Graphics Toys project sends frames rendered by the FPGA.

## Build and flash

Build with PlatformIO and the pinned libraries in `platformio.ini`. Preserve a full flash backup before replacing firmware. Local backups are excluded from Git because they contain device settings.

The connected device has 4 MiB flash and `app0` at `0x10000`, 1,966,080 bytes long. Its original NVS is at `0x9000` for 20,480 bytes. Flashing only `app0` plus its OTA selector preserves NVS and the existing partition table. Re-check offsets for another device.

Scene/control endpoints are intended for a trusted LAN.
