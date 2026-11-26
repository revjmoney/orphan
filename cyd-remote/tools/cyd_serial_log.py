# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Rev. J. Money
"""Keep the ORPHAN Remote's (CYD) USB serial output in a file, one timestamped line each, reopening the port if
it goes away (a reset, a reflash). The firmware prints a heartbeat every 5 s ("HB up=... age8091=..."), so after a
hang this file shows whether the loop still ran.
  py -3 tools/cyd_serial_log.py [COM21] [cyd-serial.log]
Opening the port does not reset the CYD (DTR and RTS are left released). by JMSCNC, makers of RotatoCAM.
"""
import sys
import time

import serial

port = sys.argv[1] if len(sys.argv) > 1 else 'COM21'
path = sys.argv[2] if len(sys.argv) > 2 else 'cyd-serial.log'

while True:
    try:
        s = serial.Serial()
        s.port, s.baudrate, s.timeout = port, 115200, 1
        s.dtr = False
        s.rts = False
        s.open()
        with open(path, 'a', encoding='utf-8', errors='replace') as f:
            f.write('%s --- logger opened %s\n' % (time.strftime('%Y-%m-%d %H:%M:%S'), port))
            f.flush()
            buf = b''
            while True:
                buf += s.read(256)
                while b'\n' in buf:
                    line, buf = buf.split(b'\n', 1)
                    f.write('%s %s\n' % (time.strftime('%Y-%m-%d %H:%M:%S'),
                                         line.decode('utf-8', 'replace').rstrip('\r')))
                    f.flush()
    except (serial.SerialException, OSError):
        time.sleep(3)          # port busy (a flash) or unplugged: try again
