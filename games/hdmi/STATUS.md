# Orphan HDMI out: PAUSED (2026-11-25)

Rev paused this work to focus on the CYD frame rate. Nothing here is built or wired into any project.

- Design and plan (8 tasks, Task 1 in progress) are in the development notes, not in this repo yet.

Where it stopped (Task 1):
- hdl-util/hdmi (Sameer Puri, MIT OR Apache-2.0, commit 517e214) copied into hdl-util/, serializer.sv left out,
  hdmi.sv patched to output `tmds_words[29:0]` instead of serialized pins.
- Neither tool reads it as is: Icarus 12 asserts in packet_picker.sv (unpacked array port), Yosys stops at
  audio_clock_regeneration_packet.sv line 15 (`real` / `int` casts, unpacked array ports).
- Next step: port to plain Verilog-2005 fixed to VIC 1 (640 x 480, 800 x 525, sync 16/96 and 10/2, negative),
  48 kHz, 16-bit audio (ACR N 6144, CTS 25200), packed `sub` vectors; credit hdl-util in NOTICE.md.
