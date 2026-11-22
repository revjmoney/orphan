#!/bin/sh
# Before the LED ring starts. With Ardzy pin-control loaded: route PWM ch0..3 to the FPGA LEDs D5..D8 through
# Ardzy's web API (waits up to 2 min for it). With an Orphan design (orphan_leds block) nothing is needed.
# The ring also owns the front LED, so the SD-activity lights (s9-sdleds) pause while it runs.
systemctl stop s9-sdleds 2>/dev/null
for n in $(seq 1 60); do curl -sf -m 3 http://127.0.0.1/api/io >/dev/null && break; sleep 2; done
curl -sf -m 3 http://127.0.0.1/api/io | grep -q '"ok": false' && exit 0      # not pin-control: nothing to route
for i in 0 1 2 3; do
  curl -sf -m 5 -X POST "http://127.0.0.1/api/io/set?name=leds%5B$i%5D&mode=1" >/dev/null || exit 0
  curl -sf -m 5 -X POST "http://127.0.0.1/api/io/pwm/set?ch=$i&hz=1000&duty=100&pin=leds%5B$i%5D" >/dev/null || exit 0
done
