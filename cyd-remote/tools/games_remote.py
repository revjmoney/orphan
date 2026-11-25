# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Rev. J. Money
"""Drive an Orphan Games console from a PC (load a ROM, press pad buttons) over its WebSocket, for testing.

  py -3 tools/games_remote.py <board ip> load "Nova the Squirrel.nes"
  py -3 tools/games_remote.py <board ip> press START [seconds]
Buttons: A B SELECT START UP DOWN LEFT RIGHT (NES order, bit 0 = A). by JMSCNC, makers of RotatoCAM.
"""
import base64
import json
import os
import socket
import struct
import sys
import time

BUTTONS = {'A': 1, 'B': 2, 'SELECT': 4, 'START': 8, 'UP': 16, 'DOWN': 32, 'LEFT': 64, 'RIGHT': 128}


def connect(host, port=8000):
    s = socket.create_connection((host, port), timeout=5)
    key = base64.b64encode(os.urandom(16)).decode()
    s.sendall(('GET /ws HTTP/1.1\r\nHost: %s\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n'
               'Sec-WebSocket-Key: %s\r\nSec-WebSocket-Version: 13\r\n\r\n' % (host, key)).encode())
    data = b''
    while b'\r\n\r\n' not in data:
        data += s.recv(1024)
    return s


def send(s, obj):
    p = json.dumps(obj).encode()
    mask = os.urandom(4)
    hdr = bytes([0x81]) + (bytes([0x80 | len(p)]) if len(p) < 126 else bytes([0x80 | 126]) + struct.pack('>H', len(p)))
    s.sendall(hdr + mask + bytes(b ^ mask[i % 4] for i, b in enumerate(p)))


def main():
    host, cmd = sys.argv[1], sys.argv[2]
    s = connect(host)
    if cmd == 'load':
        send(s, {'load': sys.argv[3]})
        time.sleep(1.5)
    elif cmd == 'press':
        bits = 0
        for b in sys.argv[3].split('+'):
            bits |= BUTTONS[b.upper()]
        send(s, {'pads': [bits, 0]})
        time.sleep(float(sys.argv[4]) if len(sys.argv) > 4 else 0.15)
        send(s, {'pads': [0, 0]})
        time.sleep(0.1)
    s.close()


if __name__ == '__main__':
    main()
