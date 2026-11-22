# Orphan Graphics Toys

**By JMSCNC, makers of RotatoCAM.** Main Orphan project, separate from the Kaspa miner repository.

Menu: **F FPGA projects → Graphics toys: raycast + CYD → Orphan Graphics Toys**.

The local `TOY1` image contains a raycaster, color-wave renderer, XOR field, Ardzy's 64 x 64 hardware Game of Life, and the standard Orphan fan peripheral. The raycaster's wall traversal, projection and pixel shading execute in FPGA logic. ARM supplies camera vectors, reads the completed 160 x 120 RGB565 buffer and sends it to the CYD. A compatible CYD doubles the pixels locally and smooths raycast edges. Earlier firmware receives a panel-sized frame scaled by ARM. Browser controls use port 8000. W/A/S/D and CYD touches can steer the camera.

Live telemetry separates FPGA render time, framebuffer readback, Wi-Fi transfer and application frame rate. The CYD reports its presented-frame FPS and displays the Zynq die temperature. A Life benchmark checks 100 generations against the CPU and measures free-running generations per second.

## Verified on a board, 2026-11-21

* 2,058 LUTs, 1,638 FFs, 11 BRAM36 equivalents, two DSPs.
* Timing: 101.3 MHz maximum, PASS at 100 MHz.
* All 57,600 checked pixels across raycast, waves and XOR match the CPU oracle on real hardware.
* Raycast capture: 280.21 microseconds for the test camera.
* Waves / XOR capture: 195.19 microseconds each.
* Hardware Life matches the CPU after 100 generations; free-running rate 1,428,572 generations/s.
* Full 320 x 240 CYD frame transfers typically took around 0.4 to 0.8 seconds in the local test. This link, rather than FPGA rendering, limits visible frame rate.

`test_graphics.py` generates exact expected captures and a Verilog bus test. `verify_hardware.py` checks the physical framebuffer and Life engine; stop the project's display program before running it.

## External source library

* [Raybox Zero](https://github.com/algofoogle/raybox-zero): Wolfenstein-style raycaster implemented in hardware, with FPGA and Tiny Tapeout targets. It needs an S9-specific port and display adaptation; it is not the code running in TOY1.
* [Project F](https://github.com/projf/projf-explore): FPGA graphics demonstrations and building blocks for future ports.
* [Original Doom source](https://github.com/id-Software/DOOM): CPU game-engine source, useful for a later Linux game port. No Doom game assets are included here.

The current raycaster is a small maze-rendering demonstration, not the full Doom game. The menu also offers a two-minute ARM-rendered CYD preview and distinguishes it from the FPGA-rendered project.
