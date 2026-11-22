"""Capture a private boot log; print only this firmware's connectivity line."""
from pathlib import Path
import serial,time
port=serial.Serial()
port.port='COM21';port.baudrate=115200;port.timeout=.1
port.dtr=False;port.rts=False;port.open()
# Reset via the same EN signal used by esptool, without entering the bootloader.
port.rts=True;time.sleep(.1);port.rts=False
buffer=bytearray();deadline=time.monotonic()+70
while time.monotonic()<deadline:
    buffer.extend(port.read(4096))
    if b'Orphan Remote: WiFi ' in buffer and b'\n' in buffer[buffer.index(b'Orphan Remote: WiFi '):]:break
port.close()
Path(__file__).resolve().parents[1].joinpath('local','boot.log').write_bytes(buffer)
for line in buffer.decode(errors='replace').splitlines():
    if line.startswith('Orphan Remote: WiFi '):print(line)
