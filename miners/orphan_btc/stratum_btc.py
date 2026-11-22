"""Orphan BTC: Stratum v1 Bitcoin pool client driving the FPGA's SHA-256 units (Ardzy's 13_sha256 core).

Every result from the FPGA is re-hashed on the ARM and compared to the pool's exact share target before it is sent.
by JMSCNC, makers of RotatoCAM. GPL-3.0-or-later."""
import hashlib
import json
import select
import socket
import ssl
import struct
import time
from urllib.parse import urlsplit

DIFF1 = 0x00000000FFFF0000000000000000000000000000000000000000000000000000


def dsha(b):
    return hashlib.sha256(hashlib.sha256(b).digest()).digest()


def swap_words(b):
    """Stratum sends prevhash as 8 little-endian words in big-endian order: swap each 4-byte word."""
    return b''.join(b[i:i + 4][::-1] for i in range(0, len(b), 4))


def target_for(diff):
    diff = float(diff)
    if not diff > 0:
        raise ValueError('Pool sent an invalid difficulty')
    return min((1 << 256) - 1, int(DIFF1 / diff))


def header_for(job, en1, en2):
    """The 80-byte block header (nonce 0) for a mining.notify job and an extranonce2."""
    coinbase = bytes.fromhex(job['coinb1'] + en1 + en2 + job['coinb2'])
    root = dsha(coinbase)
    for branch in job['merkle']:
        root = dsha(root + bytes.fromhex(branch))
    return (bytes.fromhex(job['version'])[::-1] + swap_words(bytes.fromhex(job['prevhash'])) + root +
            bytes.fromhex(job['ntime'])[::-1] + bytes.fromhex(job['nbits'])[::-1] + b'\0\0\0\0')


def hash_value(header, nonce):
    return int.from_bytes(dsha(header[:76] + struct.pack('<I', nonce)), 'little')


def bits_difficulty(nbits_hex):
    """Network difficulty from the block header's compact target."""
    n = int(nbits_hex, 16)
    target = (n & 0xFFFFFF) << (8 * ((n >> 24) - 3))
    return DIFF1 / target if target else 0.0


def varint(b, o):
    v = b[o]
    if v < 0xFD:
        return v, o + 1
    k = {0xFD: 2, 0xFE: 4, 0xFF: 8}[v]
    return int.from_bytes(b[o + 1:o + 1 + k], 'little'), o + 1 + k


def coinbase_info(job, en1, en2_size):
    """The block this job builds: its height (BIP34) and its full reward (subsidy + fees), from the coinbase."""
    try:
        cb = bytes.fromhex(job['coinb1'] + en1 + '00' * en2_size + job['coinb2'])
        o = 4                                         # version
        nin, o = varint(cb, o)
        o += 36                                       # the coinbase's empty prevout
        slen, o = varint(cb, o)
        script = cb[o:o + slen]
        o += slen + 4
        height = int.from_bytes(script[1:1 + script[0]], 'little') if script and 1 <= script[0] <= 8 else None
        nout, o = varint(cb, o)
        total = 0
        for _ in range(nout):
            total += int.from_bytes(cb[o:o + 8], 'little')
            o += 8
            pl, o = varint(cb, o)
            o += pl
        return {'height': height, 'reward': total / 1e8}
    except (ValueError, IndexError, KeyError):
        return {'height': None, 'reward': None}


def zero_bits_for(target):
    """Leading zero bits the FPGA must find so it never misses a share (it checks 1..32)."""
    return max(1, min(32, 256 - target.bit_length()))


class Session:
    def __init__(self, sha, cfg, cancel, update, until=None):
        self.sha, self.cfg, self.cancel, self.update, self.until = sha, cfg, cancel, update, until
        self.sock, self.buf, self.seq, self.pending = None, b'', 10, {}
        self.en1, self.en2_size, self.job, self.target = '', 4, None, target_for(1)
        self.stats = dict(accepted=0, rejected=0, submitted=0, jobs=0, difficulty=None, best=0)

    def send(self, method, params, rid):
        self.sock.sendall((json.dumps({'id': rid, 'method': method, 'params': params}) + '\n').encode())

    def handle(self, m):
        method, params, ev = m.get('method'), m.get('params') or [], None
        if method == 'mining.notify':
            self.job = dict(id=params[0], prevhash=params[1], coinb1=params[2], coinb2=params[3], merkle=params[4],
                            version=params[5], nbits=params[6], ntime=params[7], clean=params[8], en2=0, nonce=0)
            self.stats['jobs'] += 1
            ci = coinbase_info(self.job, self.en1, self.en2_size)
            self.update(chain={'height': ci['height'], 'reward': ci['reward'], 'nbits': params[6],
                               'net_diff': bits_difficulty(params[6]), 'pool': self.cfg['pool']})
            ev = 'New job %s (block %s, bits %s, reward %s)' % (params[0], ci['height'], params[6],
                                                                 '%.8f' % ci['reward'] if ci['reward'] else '?')
        elif method == 'mining.set_difficulty':
            self.target = target_for(params[0])
            self.stats['difficulty'] = float(params[0])
            ev = 'Pool share difficulty %s (FPGA looks for %d zero bits, ARM checks the exact target)' % (
                params[0], zero_bits_for(self.target))
        elif not method:
            rid = m.get('id')
            if rid == 1:
                if m.get('error') or not isinstance(m.get('result'), list):
                    raise RuntimeError('Pool rejected the subscription')
                self.en1, self.en2_size = m['result'][1], int(m['result'][2])
                ev = 'Subscribed: extranonce1 %s, extranonce2 %d bytes' % (self.en1, self.en2_size)
            elif rid == 2:
                if m.get('result') is not True:
                    raise RuntimeError('Pool rejected the wallet / worker: %s' % (m.get('error'),))
                ev = 'Wallet authorized by the pool'
            elif rid in self.pending:
                self.pending.pop(rid)
                ok = m.get('result') is True and not m.get('error')
                self.stats['accepted' if ok else 'rejected'] += 1
                ev = 'Share accepted by the pool' if ok else 'Share rejected: %s' % (m.get('error'),)
        self.update(mining=dict(self.stats), log_message=ev)

    def start_search(self):
        j = self.job
        en2 = ('%0*x' % (2 * self.en2_size, j['en2']))[-2 * self.en2_size:]
        j['header'], j['en2hex'] = header_for(j, self.en1, en2), en2
        j['zb'], j['tgt'] = zero_bits_for(self.target), self.target
        self.sha.mine(j['header'], start=j['nonce'], count=(1 << 32) - j['nonce'], zero_bits=j['zb'], wait=False)
        self.current = (j['id'], j['en2'], self.target)

    def run(self):
        u = urlsplit(self.cfg['pool'])
        user = self.cfg['wallet'] + ('.' + self.cfg['worker'] if self.cfg.get('worker') else '')
        self.update(log_message='Connecting to %s as %s' % (self.cfg['pool'], user))
        self.sock = socket.create_connection((u.hostname, u.port), timeout=10)
        if u.scheme == 'stratum+ssl':
            self.sock = ssl.create_default_context().wrap_socket(self.sock, server_hostname=u.hostname)
        self.sock.settimeout(5)
        self.send('mining.subscribe', ['OrphanBTC/1.0'], 1)
        self.send('mining.authorize', [user, self.cfg.get('password') or 'x'], 2)
        if self.cfg.get('suggest_diff'):
            self.send('mining.suggest_difficulty', [float(self.cfg['suggest_diff'])], 3)
        self.current, heard, t0, done0 = None, time.monotonic(), time.monotonic(), 0
        try:
            while not self.cancel.is_set():
                if self.until is not None and time.monotonic() >= self.until and not self.pending:
                    break
                if select.select([self.sock], [], [], 0.05)[0]:
                    chunk = self.sock.recv(65536)
                    if not chunk:
                        raise ConnectionError('The pool closed the connection')
                    self.buf += chunk
                    while b'\n' in self.buf:
                        line, self.buf = self.buf.split(b'\n', 1)
                        if line.strip():
                            self.handle(json.loads(line))
                    heard = time.monotonic()
                if time.monotonic() - heard > 300:
                    raise TimeoutError('The pool stopped sending work')
                if not self.job or not self.en1:
                    continue
                j = self.job
                if self.current is None or self.current[0] != j['id'] or self.current[2] != self.target:
                    if self.current is not None:
                        self.sha.stop()
                        done0 += self.sha.r(6)                     # what the cut-short search tried
                    self.start_search()
                st = self.sha.r(1)
                if st & 2:                                         # still searching
                    if time.monotonic() - getattr(self, 'shown', 0) > 1:
                        self.shown, el = time.monotonic(), time.monotonic() - t0
                        self.update(rate=(done0 + self.sha.r(6)) / el if el > 1 else 0, hashes=done0 + self.sha.r(6))
                    continue
                r = self.sha.result()
                done0 += r['hashes']
                if r['found']:
                    nonce, value = r['nonce'], hash_value(j['header'], r['nonce'])
                    zb = 256 - value.bit_length()
                    self.stats['best'] = max(self.stats['best'], zb)
                    if value <= j['tgt']:                          # a real share: the ARM checked the full target
                        self.seq += 1
                        self.send('mining.submit', [user, j['id'], j['en2hex'], j['ntime'], '%08x' % nonce], self.seq)
                        self.pending[self.seq] = time.monotonic()
                        self.stats['submitted'] += 1
                        self.update(log_message='Share found: nonce %08x, %d zero bits; sent to the pool' % (nonce, zb))
                    j['nonce'] = nonce + 1
                else:
                    j['nonce'] = 1 << 32                           # all nonces tried
                if j['nonce'] >= 1 << 32:                          # next extranonce2: a new merkle root, new space
                    j['en2'], j['nonce'] = j['en2'] + 1, 0
                self.start_search()
                el = time.monotonic() - t0
                self.update(mining=dict(self.stats), rate=done0 / el if el > 1 else 0)
                if any(time.monotonic() - t > 60 for t in self.pending.values()):
                    raise TimeoutError('The pool did not answer a submitted share')
        finally:
            self.sha.stop()
            if self.sock:
                self.sock.close()
