#!/bin/sh
# Route PWM ch0..3 to the FPGA LEDs D5..D8 through Ardzy's web API (waits up to 2 min for it).
for n in $(seq 1 60); do curl -sf -m 3 http://127.0.0.1/api/io >/dev/null && break; sleep 2; done
for i in 0 1 2 3; do
  curl -sf -m 5 -X POST "http://127.0.0.1/api/io/set?name=leds%5B$i%5D&mode=1" >/dev/null || exit 1
  curl -sf -m 5 -X POST "http://127.0.0.1/api/io/pwm/set?ch=$i&hz=1000&duty=100&pin=leds%5B$i%5D" >/dev/null || exit 1
done
