"""Probe a Stratum v1 pool without mining: subscribe, authorize, print what difficulty and jobs it sends.
    python3 pool_probe.py stratum+tcp://host:port user [password] [seconds]
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import json
import socket
import sys
import time
from urllib.parse import urlsplit

u = urlsplit(sys.argv[1])
user, pw = sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else 'x'
secs = float(sys.argv[4]) if len(sys.argv) > 4 else 15
s = socket.create_connection((u.hostname, u.port), timeout=10)
s.settimeout(1)
for rid, m, p in ((1, 'mining.subscribe', ['OrphanBTC/1.0']), (2, 'mining.authorize', [user, pw]),
                  (3, 'mining.suggest_difficulty', [0.001])):
    s.sendall((json.dumps({'id': rid, 'method': m, 'params': p}) + '\n').encode())
buf, t = b'', time.time()
while time.time() - t < secs:
    try:
        c = s.recv(65536)
    except socket.timeout:
        continue
    if not c:
        print('closed by pool')
        break
    buf += c
    while b'\n' in buf:
        line, buf = buf.split(b'\n', 1)
        m = json.loads(line)
        if m.get('method') == 'mining.notify':
            p = m['params']
            print('notify job', p[0], 'version', p[5], 'nbits', p[6], 'merkle', len(p[4]), 'coinb1', p[2][:40])
        else:
            print(json.dumps(m)[:300])
